--------------------------------------------------------------------------------
-- minuet-ai: LLM-powered code completion via virtual text
--------------------------------------------------------------------------------

return {
    {
        'milanglacier/minuet-ai.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        event = 'InsertEnter',
        config = function()
            require('minuet').setup {
                provider = 'openai_compatible',
                provider_options = {
                    openai_compatible = {
                        model = 'qwen/qwen3-coder-30b-a3b-instruct',
                        end_point = 'https://openrouter.ai/api/v1/chat/completions',
                        api_key = function()
                            return vim.fn.system('rbw get "OpenRouter API Key"'):gsub('%s+$', '')
                        end,
                        name = 'OpenRouter',
                        stream = true,
                        optional = {
                            max_tokens = 128,
                            top_p = 0.9,
                        },
                    },
                },
                virtualtext = {
                    -- Only trigger manually; add filetypes here to enable auto
                    auto_trigger_ft = {},
                    keymap = {
                        accept = '<A-j>',
                        accept_line = '<A-k>',
                        next = '<A-l>',
                        prev = '<A-h>',
                        dismiss = '<A-;>',
                    },
                },
                -- Tune request cadence to keep API costs reasonable
                throttle = 1500,
                debounce = 500,
                request_timeout = 4,
                n_completions = 2,
            }
        end,
    },
}
