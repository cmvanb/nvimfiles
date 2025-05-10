--------------------------------------------------------------------------------
-- LSP configuration
--
-- Based on: https://github.com/VonHeikemen/lsp-zero.nvim/wiki/Under-the-hood
--------------------------------------------------------------------------------

local function mason_config()
    local ThemeConfig = reload('theme.config')

    reload('mason').setup({
        ui = {
            border = ThemeConfig.border,
        },
    })
end

local function nvim_lspconfig_config()
    -- Imports
    local KeyMapUtils = reload('utils.keymaps')
    local TableUtils = reload('utils.table')
    local ThemeConfig = reload('theme.config')
    local ThemeSymbols = reload('theme.symbols')

    -- Diagnostics UI
    ----------------------------------------------------------------------------
    vim.diagnostic.config({
        virtual_text = false,
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
            source = 'always',
            header = '',
            prefix = '',
        },
    })

    -- LSP functions
    ----------------------------------------------------------------------------
    local function lsp_keymaps(bufnr)
        local opts = { silent = true, buffer = bufnr }

        -- Unmap some defaults
        KeyMapUtils.unmap('<C-W>d')
        KeyMapUtils.unmap('<C-W><C-D>')

        -- LSP actions
        KeyMapUtils.noremap(
            'gh',
            vim.lsp.buf.hover,
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
            vim.diagnostic.goto_next,
            TableUtils.merge(opts, { desc = 'LSP: Next diagnostic' }))
        KeyMapUtils.noremap(
            'gk',
            vim.diagnostic.goto_prev,
            TableUtils.merge(opts, { desc = 'LSP: Previous diagnostic' }))
        KeyMapUtils.noremap(
            'gl',
            vim.diagnostic.open_float,
            TableUtils.merge(opts, { desc = 'LSP: Show diagnostic' }))
    end

    local function lsp_attach(_, bufnr)
        local buf_command = vim.api.nvim_buf_create_user_command

        lsp_keymaps(bufnr)

        buf_command(bufnr, 'LspFormat', function()
            vim.lsp.buf.format()
        end, { desc = 'Format buffer with language server' })
    end

    -- LSP capabilities
    ----------------------------------------------------------------------------
    local base_capabilities =
        reload('blink.cmp').get_lsp_capabilities()

    local lsp_capabilities =
        TableUtils.merge(base_capabilities, {
            textDocument = {
                -- Enable snippets with LuaSnip.
                completion = {
                    completionItem = {
                        snippetSupport = true,
                    },
                },
                -- Enable folding with UFO.
                foldingRange = {
                    dynamicRegistration = false,
                    lineFoldingOnly = true,
                },
            },
        })

    local default_ls_config = {
        on_attach = lsp_attach,
        capabilities = lsp_capabilities,
    }

    -- LSP server configuration
    ----------------------------------------------------------------------------
    local lspconfig = reload('lspconfig')

    -- Lua
    lspconfig.lua_ls.setup(
        TableUtils.merge(default_ls_config, {
            on_init = function(client)
                local path = client.workspace_folders[1].name
                if not vim.loop.fs_stat(path .. '/.luarc.json') and not vim.loop.fs_stat(path .. '/.luarc.jsonc') then
                    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                        runtime = {
                            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                            version = 'LuaJIT'
                        },
                        workspace = {
                            -- Make the server aware of Neovim runtime files
                            library = { vim.env.VIMRUNTIME }
                            -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                            -- library = vim.api.nvim_get_runtime_file("", true)
                        }
                    })

                    client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
                end
                return true
            end,

            settings = {
                Lua = {
                    telemetry = {
                        enable = false,
                    },
                },
            },
        })
    )

    -- Mason/LSP integration
    ----------------------------------------------------------------------------
    local mason_lspconfig = reload('mason-lspconfig')

    mason_lspconfig.setup({
        -- Enable after Neovim 0.11.0
        automatic_enable = true,
        -- A list of tools to automatically install if they're not already installed.
        ensure_installed = {
            'bashls',
            'clangd',
            'cssls',
            'dockerls',
            'html',
            'jsonls',
            'lua_ls',
            'pyright',
            'ts_ls',
            'yamlls',
        },
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
        config = nvim_lspconfig_config,
    },
}
