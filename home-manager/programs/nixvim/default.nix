_:
{
  defaultEditor = true;
  viAlias = true;
  vimAlias = true;
  colorschemes.gruvbox-material-nvim.enable = true;

  opts = {
    expandtab = true;
    shiftwidth = 2;
    smartindent = true;
    tabstop = 2;
    number = true;
    clipboard = "unnamedplus";
  };

  # Keymaps
  globals = {
    mapleader = " ";
  };

  plugins = {
    # UI
    # keep-sorted start block=yes
    bufferline.enable = true;
    lualine.enable = true;
    noice = {
      # WARNING: This is considered experimental feature, but provides nice UX
      enable = true;
      settings.presets = {
        bottom_search = true;
        command_palette = true;
        long_message_to_split = true;
        #inc_rename = false;
        #lsp_doc_border = false;
      };
    };
    telescope = {
      enable = true;
      keymaps = {
        "<leader>ff" = {
          options.desc = "file finder";
          action = "find_files";
        };
        "<leader>fg" = {
          options.desc = "find via grep";
          action = "live_grep";
        };
      };
      extensions = {
        file-browser.enable = true;
      };
    };
    treesitter = {
      enable = true;
      highlight.enable = true;
      indent.enable = true;
    };
    web-devicons.enable = true;
    which-key.enable = true;
    # keep-sorted end

    # Dev
    lsp = {
      enable = true;
      inlayHints = true;
      servers = {
        # keep-sorted start block=yes
        biome.enable = true;
        hls = {
          enable = true;
          installGhc = false; # Managed by Nix devShell
        };
        marksman.enable = true;
        nil_ls.enable = true;
        nixd.enable = true;
        ruff.enable = true;
        rust_analyzer = {
          enable = true;
          installCargo = false;
          installRustc = false;
        };
        taplo.enable = true;
        # keep-sorted end
      };
    };
    lazygit.enable = true;
  };
  keymaps = [
    # Open lazygit within nvim.
    {
      action = "<cmd>LazyGit<CR>";
      key = "<leader>gg";
    }
  ];
}
