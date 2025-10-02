--------------------------------------------------------------------------------
-- LSP configuration
--
-- Based on: https://github.com/VonHeikemen/lsp-zero.nvim/wiki/Under-the-hood
--------------------------------------------------------------------------------

local theme_config = require('theme.config')
local theme_symbols = require('theme.symbols')
local keys = require('utils.keymaps')
local tbl = require('utils.table')

-- Language servers to enable by default
-- NOTE: Not limited to language servers, can also be DAPs, linters, formatters, etc.
--
-- Mason will automatically install these.
--------------------------------------------------------------------------------
local language_servers = {
    'bashls',
    'clangd',
    'cssls',
    'dockerls',
    'html',
    'jsonls',
    'lua_ls',
    'pyright',
    'svelte',
    'ts_ls',
    'yamlls',
}

-- LSP on_attach configuration
--------------------------------------------------------------------------------
-- LSP attach diagnostics
local function lsp_attach_diagnostics()
    vim.diagnostic.config({
        virtual_text = false,
        virtual_lines = false,
        signs = {
            text = {
                [vim.diagnostic.severity.ERROR] = theme_symbols.diagnostic_signs.error,
                [vim.diagnostic.severity.WARN] = theme_symbols.diagnostic_signs.warn,
                [vim.diagnostic.severity.INFO] = theme_symbols.diagnostic_signs.info,
                [vim.diagnostic.severity.HINT] = theme_symbols.diagnostic_signs.hint,
            },
        },
        update_in_insert = false,
        underline = true,
        severity_sort = true,
        float = {
            focusable = false,
            style = 'minimal',
            border = theme_config.border,
            source = true,
            header = '',
            prefix = '',
        },
    })

    -- Show virtual inline diagnostics when cursor is hovering.
    local augroup = vim.api.nvim_create_augroup('DiagnosticHover', { clear = true })
    local virtual_lines_shown = false

    vim.api.nvim_create_autocmd('CursorHold', {
        group = augroup,
        callback = function()
            local bufnr = vim.api.nvim_get_current_buf()
            local cursor = vim.api.nvim_win_get_cursor(0)
            local line = cursor[1] - 1 -- Convert to 0-based indexing

            -- Get diagnostics for the current line
            local diagnostics = vim.diagnostic.get(bufnr, { lnum = line })

            if #diagnostics > 0 then
                -- Show virtual lines when hovering over diagnostic
                if not virtual_lines_shown then
                    vim.diagnostic.config({ virtual_lines = {
                        spacing = 2,
                        current_line = true,
                        source = true,
                    } })
                    virtual_lines_shown = true
                end
            else
                -- Hide virtual lines when not hovering over diagnostic
                if virtual_lines_shown then
                    vim.diagnostic.config({ virtual_lines = false })
                    virtual_lines_shown = false
                end
            end
        end,
    })

    -- Hide virtual lines when cursor moves.
    vim.api.nvim_create_autocmd('CursorMoved', {
        group = augroup,
        callback = function()
            local bufnr = vim.api.nvim_get_current_buf()
            local cursor = vim.api.nvim_win_get_cursor(0)
            local line = cursor[1] - 1

            local diagnostics = vim.diagnostic.get(bufnr, { lnum = line })

            if #diagnostics == 0 and virtual_lines_shown then
                vim.diagnostic.config({ virtual_lines = false })
                virtual_lines_shown = false
            end
        end,
    })
end

-- LSP attach keymaps
local function lsp_attach_keymaps(buffer)
    -- TODO: Check client capabilities before creating keymaps.
    -- see: https://neovim.io/doc/user/lsp.html

    -- local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    -- if client:supports_method('textDocument/implementation') then
    --     -- Create a keymap for vim.lsp.buf.implementation ...
    -- end

    local opts = { silent = true, buffer = buffer }

    -- Unmap some defaults
    keys.unmap('<C-W>d')
    keys.unmap('<C-W><C-D>')

    -- LSP actions
    keys.noremap(
        'gh',
        function()
            vim.lsp.buf.hover({
                border = theme_config.border,
            })
        end,
        tbl.merge(opts, { desc = 'LSP: Show hover' }))

    keys.noremap(
        'gs',
        vim.lsp.buf.signature_help,
        tbl.merge(opts, { desc = 'LSP: Show signature help' }))

    keys.noremap(
        'gc',
        vim.lsp.buf.rename,
        tbl.merge(opts, { desc = 'LSP: Rename' }))

    keys.noremap(
        'ga',
        vim.lsp.buf.code_action,
        tbl.merge(opts, { desc = 'LSP: Code action' }))

    keys.noremap(
        'gj',
        function()
            vim.diagnostic.jump({ count = 1, float = true })
        end,
        tbl.merge(opts, { desc = 'LSP: Next diagnostic' }))

    keys.noremap(
        'gk',
        function()
            vim.diagnostic.jump({ count = -1, float = true })
        end,
        tbl.merge(opts, { desc = 'LSP: Previous diagnostic' }))

    -- TODO: This works as a 'dismiss', but it should instead globally toggle the diagnostics.
    keys.noremap(
        'gl',
        function()
            local current = vim.diagnostic.config()
            vim.diagnostic.config({
                virtual_lines = current and not current.virtual_lines,
            })
        end,
        tbl.merge(opts, { desc = 'LSP: Show diagnostic' }))
end

-- LSP attach autocommand
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('my.lsp', {}),
    callback = function(args)
        lsp_attach_diagnostics()
        lsp_attach_keymaps(args.buf)

        vim.api.nvim_buf_create_user_command(args.buf, 'LspFormat', function()
            vim.lsp.buf.format()
        end, { desc = 'Format buffer with language server' })
    end,
})

local function mason_config()
    require('mason').setup({
        PATH = 'append',
        ui = {
            border = theme_config.border,
        },
    })
end

local function lsp_config()
    -- LSP generic configuration
    ----------------------------------------------------------------------------
    require('lspconfig')

    local lsp_capabilities =
        -- Enable blink.cmp and merge default capabilities
        require('blink.cmp').get_lsp_capabilities({
            textDocument = {
                -- Enable snippets with LuaSnip.
                completion = {
                    completionItem = {
                        snippetSupport = true,
                    },
                },
                -- TODO: Investigate -> We don't use UFO anymore, does this do anything useful?
                -- Enable folding with UFO.
                foldingRange = {
                    dynamicRegistration = false,
                    lineFoldingOnly = true,
                },
            },
        })

    vim.lsp.config('*', {
        capabilities = lsp_capabilities,
    })

    vim.lsp.enable(language_servers)

    -- LSP specific configuration
    ----------------------------------------------------------------------------
    -- Lua
    vim.lsp.config('lua_ls', {
        on_init = function(client)
            -- If this is a Lua project which is not a Neovim config, exit early.
            if client.workspace_folders then
                local path = client.workspace_folders[1].name
                if path ~= vim.fn.stdpath('config')
                    -- TODO: Needs more robust Neovim config detection, or at
                    -- least a soft-coded path. It would be nice to detect not
                    -- only our own setup but others as well.
                    and path ~= '/home/surfer/Code/dotfiles/config/nvim'
                    and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
                then
                    return
                end
            end

            -- Otherwise, configure for Neovim.
            client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                runtime = {
                    version = 'LuaJIT',
                    path = {
                        'lua/?.lua',
                        'lua/?/init.lua',
                        'lua/utils/?.lua',
                    },
                },
                workspace = {
                    checkThirdParty = false,
                    library = {
                        vim.env.VIMRUNTIME,
                        '${3rd}/luv/library',

                        -- Or pull in all of 'runtimepath'.
                        -- NOTE: this is a lot slower and will cause issues when working on
                        -- your own configuration. see: https://github.com/neovim/nvim-lspconfig/issues/3189
                        -- vim.api.nvim_get_runtime_file('', true),
                    }
                }
            })

            client:notify('workspace/didChangeConfiguration', { settings = client.config.settings })
        end,

        settings = {
            Lua = {
                telemetry = {
                    enable = false,
                },
            }
        }
    })

    -- Mason/LSP integration
    ----------------------------------------------------------------------------
    local mason_lspconfig = require('mason-lspconfig')

    mason_lspconfig.setup({
        automatic_enable = {
            exclude = {
                'rust_analyzer',
            }
        },
        ensure_installed = language_servers,
    })
end

return {
    {
        'williamboman/mason.nvim',
        config = mason_config,
    },
    {
        'williamboman/mason-lspconfig.nvim',
        dependencies = {
            'mason.nvim',
        },
    },
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'saghen/blink.cmp',
            'mason-lspconfig.nvim',
        },
        config = lsp_config,
    },
}
