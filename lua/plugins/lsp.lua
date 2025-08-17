--------------------------------------------------------------------------------
-- LSP configuration
--
-- Based on: https://github.com/VonHeikemen/lsp-zero.nvim/wiki/Under-the-hood
--------------------------------------------------------------------------------

local ThemeConfig = require('theme.config')
local ThemeSymbols = require('theme.symbols')
local KeyMapUtils = require('utils.keymaps')
local TableUtils = require('utils.table')

-- Language servers to enable by default
--
-- Mason will automatically install these.
-- NOTE: Not limited to language servers, can also be DAPs, linters, formatters, etc.
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
        virtual_lines = {
            current_line = true,
            source = true,
        },
        signs = {
            text = {
                [vim.diagnostic.severity.ERROR] = ThemeSymbols.diagnostic_signs.error,
                [vim.diagnostic.severity.WARN] = ThemeSymbols.diagnostic_signs.warn,
                [vim.diagnostic.severity.INFO] = ThemeSymbols.diagnostic_signs.info,
                [vim.diagnostic.severity.HINT] = ThemeSymbols.diagnostic_signs.hint,
            },
        },
        update_in_insert = false,
        underline = true,
        severity_sort = true,
        float = {
            focusable = false,
            style = 'minimal',
            border = ThemeConfig.border,
            source = true,
            header = '',
            prefix = '',
        },
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
    KeyMapUtils.unmap('<C-W>d')
    KeyMapUtils.unmap('<C-W><C-D>')

    -- LSP actions
    KeyMapUtils.noremap(
        'gh',
        function()
            vim.lsp.buf.hover({
                border = ThemeConfig.border,
            })
        end,
        TableUtils.merge(opts, { desc = 'LSP: Show hover' }))
    KeyMapUtils.noremap(
        'gs',
        vim.lsp.buf.signature_help,
        TableUtils.merge(opts, { desc = 'LSP: Show signature help' }))
    KeyMapUtils.noremap(
        'gc',
        vim.lsp.buf.rename,
        TableUtils.merge(opts, { desc = 'LSP: Rename' }))
    KeyMapUtils.noremap(
        'ga',
        vim.lsp.buf.code_action,
        TableUtils.merge(opts, { desc = 'LSP: Code action' }))
    KeyMapUtils.noremap(
        'gj',
        function() vim.diagnostic.jump({ count = 1, float = true }) end,
        TableUtils.merge(opts, { desc = 'LSP: Next diagnostic' }))
    KeyMapUtils.noremap(
        'gk',
        function() vim.diagnostic.jump({ count = -1, float = true }) end,
        TableUtils.merge(opts, { desc = 'LSP: Previous diagnostic' }))
    KeyMapUtils.noremap(
        'gl',
        vim.diagnostic.open_float,
        TableUtils.merge(opts, { desc = 'LSP: Show diagnostic' }))
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
        PATH = "append",
        ui = {
            border = ThemeConfig.border,
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

            client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
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
