return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "bash",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "query",
        "rust",
        "toml",
        "vim",
        "vimdoc",
        "yaml",
      },
      highlight = { enable = true },
      indent = { enable = true },
    },
  },

  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {},
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      enable_git_status = true,
      filesystem = {
        follow_current_file = { enabled = true },
      },
      default_component_configs = {
        git_status = {
          symbols = {
            added = "A",
            deleted = "D",
            modified = "M",
            renamed = "R",
            untracked = "?",
            ignored = "I",
            unstaged = "U",
            staged = "S",
            conflict = "!",
          },
        },
      },
      window = {
        position = "left",
        width = 35,
      },
    },
  },

  {
    "stevearc/oil.nvim",
    lazy = false,
    dependencies = {
      { "nvim-mini/mini.icons", opts = {} },
    },
    opts = {
      view_options = {
        show_hidden = true,
      },
    },
  },

  {
    "lewis6991/gitsigns.nvim",
    opts = {},
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      options = {
        theme = "auto",
        globalstatus = true,
      },
    },
  },
}
