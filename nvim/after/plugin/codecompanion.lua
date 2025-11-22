require("codecompanion").setup({
  adapters = {
    http = {
      ollama = function()
        return require("codecompanion.adapters").extend("ollama", {
          schema = {
            model = {
              default = "gpt-oss:20b",
            },
          },
        })
      end,
    },
  },
  strategies = {
    chat = {
      adapter = "ollama",
    },
    inline = {
      adapter = "ollama",
    },
  },
  display = {
    chat = {
      window = {
        layout = "vertical", -- vertical split
        width = 0.4, -- 40% of screen width
        height = 0.8,
        relative = "editor",
        border = "single",
        position = "right", -- Open on right side
      },
    },
  },
})
