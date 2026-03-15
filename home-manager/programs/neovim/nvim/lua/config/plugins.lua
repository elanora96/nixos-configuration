return {
  {
    "stevearc/oil.nvim",
    opts = {
      view_options = {
        show_hidden = true,
      },
      watch_for_changes = true,
    },
    dependencies = { { "echasnovski/mini.icons", opts = {} } }
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
        use_vim_lsp_config = true,
        excluded_servers = {
          "bufls",
        },
        configs = {
          lua_ls = {
            settings = {
              Lua = {
                diagnostics = {
                  -- Get the language server to recognize the `vim` global
                  globals = { "vim" },
                },
              },
            },
          }, }
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
    'sainnhe/gruvbox-material',
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.gruvbox_material_background = "hard"
      vim.g.gruvbox_material_enable_italic = true
    end
  },
  {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true },
    config = function()
      require('lualine').setup { options = {
        theme = 'gruvbox'
      } }
    end
  },
  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      vim.opt.termguicolors = true
      vim.opt.mousemoveevent = true
      require("bufferline").setup { options = {
        hover = {
          enabled = true,
          delay = 200,
          reveal = { 'close' }
        }
      } }
    end
  },
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        -- Conform will run multiple formatters sequentially
        python = { "isort", "black" },
        -- You can customize some of the format options for the filetype (:help conform.format)
        rust = { "rustfmt", lsp_format = "fallback" },
        -- Conform will run the first available formatter
        javascript = { "prettierd", "prettier", stop_after_first = true },
      },
    },
  }
}
