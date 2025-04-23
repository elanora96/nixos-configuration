{ config, pkgs, ... }:

let
  plugins = with pkgs.vimPlugins; [
    treesitterWithGrammars
    lazy-nvim
  ];
in
{
  programs.neovim = {
    inherit plugins;
    enable = true;
    package = pkgs.neovim;

    extraLuaConfig = ''
      vim.g.mapleader = " "
      require("lazy").setup({
        spec = plugins,
        performance = {
          reset_packpath = false,
          rtp = { reset = false },
        },
        dev = {
          path = "${pkgs.vimUtils.packDir config.home-manager.users.el.programs.neovim.finalPackage.passthru.packpathDirs}/pack/myNeovimPackages/start",
          patterns = {""},
        }
        install = {
          colorscheme = { "gruvbox-material" },
          missing = false, 
        },
        checker = { enabled = false },
      })

    '';
  };

  home.file."./.config/nvim" = {
    source = ./nvim;
    recursive = true;
  };
}
