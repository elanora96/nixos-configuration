{ config, pkgs, ... }:

{
  imports = [ ./minimal.nix ];

  home = {
    packages = with pkgs; [
      # keep-sorted start
      audacious
      hunspell
      hunspellDicts.en_US
      kdePackages.filelight
      kdePackages.partitionmanager
      lagrange-tui
      libreoffice-qt-stable
      mkvtoolnix
      nicotine-plus
      projectm_3
      prusa-slicer
      signal-desktop
      tauon
      thunderbird
      vscodium
      zed-editor
      # keep-sorted end
    ];
  };

  programs = {
    # keep-sorted start block=yes
    alacritty = {
      enable = true;
      # For sixel support
      package = pkgs.alacritty-graphics;
    };
    anki = {
      enable = true;
    };
    equibop = {
      enable = true;
      # TODO: Move config here
      # equicord = {
      #   themes = [ ];
      #   settings = { plugins = {

      #   }; };
      # };
      # settings = { };
    };
    firefox = {
      enable = true;
      configPath = "${config.xdg.configHome}/mozilla/firefox";
      nativeMessagingHosts = [ pkgs.kdePackages.plasma-browser-integration ];
    };
    mpv = {
      enable = true;
      config = {
        sub-auto = "fuzzy";
      };
    };
    pay-respects = {
      enable = true;
      enableZshIntegration = true;
    };
    # keep-sorted end
  };

  stylix.targets = {
    firefox.profileNames = [ "default" ];
    nixvim.enable = true;
    zellij.enable = true;
    zed.enable = true;
  };

  xdg.configFile."zed/settings.json".text = builtins.toJSON {
    # keep-sorted start block=yes
    "buffer_font_size" = 15;
    "edit_predictions" = {
      "mode" = "subtle";
    };
    "icon_theme" = "Catppuccin Macchiato";
    "lsp" = {
      "lua-language-server" = {
        "settings" = {
          "Lua" = {
            "diagnostics" = {
              "globals" = [ "vim" ];
            };
          };
        };
      };
      "nixd" =
        let
          flakeExpr = "(builtins.getFlake \"/home/el/Projects/nixos-configuration\")";
        in
        {
          "initialization_options" = {
            "formatting" = {
              "command" = [ "nixfmt" ];
            };
            "options" = {
              # If this is omitted; default search path (<nixpkgs>) will be used.
              "nixos"."expr" = "${flakeExpr}.nixosConfigurations.inanna.options";
              # By default there is no home-manager options completion
              "home_manager"."expr" =
                "${flakeExpr}.nixosConfigurations.inanna.options.home-manager.users.type.getSubOptions []";
              # For flake-parts options.
              "flake-parts"."expr" = "${flakeExpr}.debug.options";
              # For a `perSystem` flake-parts option =
              "flake-parts2"."expr" = "${flakeExpr}.currentSystem.options";
            };
          };
        };
    };
    "project_panel" = {
      "dock" = "left";
    };
    "soft_wrap" = "bounded";
    "telemetry" = {
      "metrics" = false;
      "diagnostics" = false;
    };
    "terminal" = {
      "shell" = {
        "program" = "zsh";
      };
    };
    "theme" = {
      "mode" = "system";
      "light" = "Catppuccin Latte";
      "dark" = "Catppuccin Macchiato";
    };
    "ui_font_family" = ".SystemUIFont";
    "ui_font_size" = 16;
    # keep-sorted end
  };
}
