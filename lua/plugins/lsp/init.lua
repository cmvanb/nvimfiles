--------------------------------------------------------------------------------
-- LSP configuration
--
-- Based on: https://github.com/VonHeikemen/lsp-zero.nvim/wiki/Under-the-hood
--------------------------------------------------------------------------------

local function lsp_keymaps(bufnr)
    -- TODO: Extract
    local map = function(m, lhs, rhs)
        local opts = {remap = false, silent = true, buffer = bufnr}
        vim.keymap.set(m, lhs, rhs, opts)
    end

    -- LSP actions
    map('n', 'gh', '<cmd>lua vim.lsp.buf.hover()<cr>')
    map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')
    map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')
    map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')
    map('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>')
    map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>')
    map('n', 'gH', '<cmd>lua vim.lsp.buf.signature_help()<cr>')
    map('n', 'gc', '<cmd>lua vim.lsp.buf.rename()<cr>')
    map('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<cr>')
    map('x', 'ga', '<cmd>lua vim.lsp.buf.range_code_action()<cr>')

    -- Diagnostics
    map('n', 'ge', '<cmd>lua vim.diagnostic.open_float()<cr>')
    map('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
    map('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')
end

local function lsp_settings()
    local sign = function(opts)
        vim.fn.sign_define(opts.name, {
            texthl = opts.name,
            text = opts.text,
            numhl = ''
        })
    end

    sign({ name = 'DiagnosticSignError', text = '✘' })
    sign({ name = 'DiagnosticSignWarn', text = '⚠' })
    sign({ name = 'DiagnosticSignHint', text = '' })
    sign({ name = 'DiagnosticSignInfo', text = 'ℹ' })

    vim.diagnostic.config({
        virtual_text = false,
        signs = true,
        update_in_insert = false,
        underline = true,
        severity_sort = true,
        float = {
            focusable = false,
            style = 'minimal',
            border = 'rounded',
            source = 'always',
            header = '',
            prefix = '',
        },
    })

    vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
        vim.lsp.handlers.hover,
        {
            border = 'rounded',
        }
    )

    vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
        vim.lsp.handlers.signature_help,
        {
            border = 'rounded',
        }
    )
end

local function lsp_attach(client, bufnr)
    local buf_command = vim.api.nvim_buf_create_user_command

    lsp_keymaps(bufnr)

    buf_command(bufnr, 'LspFormat', function()
        vim.lsp.buf.format()
    end, { desc = 'Format buffer with language server' })
end

-- Setup
lsp_settings()

require('mason').setup({
    ui = {
        border = 'rounded',
    },
})

local mason_lspconfig = require('mason-lspconfig')
mason_lspconfig.setup({})

mason_lspconfig.setup_handlers({
    function(server_name)
        require('lspconfig')[server_name].setup({
            on_attach = lsp_attach,
            capabilities = require('cmp_nvim_lsp').default_capabilities(),
        })
    end
})

