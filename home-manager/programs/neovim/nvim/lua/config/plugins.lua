---@diagnostic disable: undefined-global
return {
  {
    "stevearc/oil.nvim",
    opts = {
      -- See :help oil-actions for a list of all available actions
      view_options = {
        -- Show files and directories that start with "."
        show_hidden = true,
      },
      watch_for_changes = true,
    },
    dependencies = { { "echasnovski/mini.icons", opts = {} } }
    -- dependencies = { "nvim-tree/nvim-web-devicons" }
  },
  {
    "wincent/command-t",
    build = "cd lua/wincent/commandt/lib && make",
    init = function()
      vim.g.CommandTPreferredImplementation = 'lua'
    end,
    config = function()
      require('wincent.commandt').setup({})
    end,
  },
  {
    'numToStr/Comment.nvim',
    opts = {}
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        ensure_installed = { "bash", "c", "clojure", "cmake", "cpp", "css", "gitignore", "html", "java", "javascript", "json", "lua", "make", "markdown", "nix", "python", "rust", "toml", "typescript", "tsx", "yaml" },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },

      })
    end
  },
  {
    "dundalek/lazy-lsp.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      { "VonHeikemen/lsp-zero.nvim", branch = "v3.x" },
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/nvim-cmp",
    },
    config = function()
      local lsp_zero = require("lsp-zero")

      lsp_zero.on_attach(function(_, bufnr)
        lsp_zero.default_keymaps({
          buffer = bufnr,
          preserve_mappings = false
        })
      end)

      require("lazy-lsp").setup {
        excluded_servers = {
          -- "als",         -- Deprecation warning
          "ruff_lsp",
          "bufls",
          -- "bazelrc-lsp", -- Errors
          -- "tsserver"     -- Deprecation warning
        },
      }
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
  },
  {
    "Olical/conjure",
    ft = { "clojure" },
    lazy = true,
    init = function()
      vim.g["conjure#debug"] = true
    end,

    dependencies = { "PaterJason/cmp-conjure" },
  },
  {
    "PaterJason/cmp-conjure",
    lazy = true,
    config = function()
      local cmp = require("cmp")
      local config = cmp.get_config()
      table.insert(config.sources, { name = "conjure" })
      return cmp.setup(config)
    end,
  },
  {
    "lambdalisue/vim-suda",
  },
  {
    'sainnhe/gruvbox-material',
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.gruvbox_material_background = "hard"
      vim.g.gruvbox_material_enable_italic = true
    end
  } }
