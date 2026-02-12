--------------------------------------------------------------------------------
-- CodeCompanion.nvim configuration
--------------------------------------------------------------------------------

return {
    {
        "olimorris/codecompanion.nvim",
        opts = {
            adapters = {
                http = {
                    anthropic = function()
                        return require("codecompanion.adapters").extend("anthropic", {
                            env = {
                                api_key = "cmd:rbw get 'Anthropic/Claude API Key'",
                            },
                        })
                    end,
                },
            },
            strategies = {
                chat = {
                    adapter = "anthropic",
                },
                inline = {
                    adapter = "anthropic",
                },
            },
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
    },
}
