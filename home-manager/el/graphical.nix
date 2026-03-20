{ pkgs, ... }:

{
  imports = [ ./minimal.nix ];

  home = {
    packages = with pkgs; [
      # keep-sorted start
      audacious
      equibop
      hunspell
      hunspellDicts.en_US
      kdePackages.filelight
      kdePackages.partitionmanager
      libreoffice-qt6-fresh
      meslo-lgs-nf
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
      theme = "gruvbox_material";
    };
    firefox = {
      enable = true;
    };
    mpv = {
      enable = true;
      config = {
        sub-auto = "fuzzy";
      };
    };
    # keep-sorted end
  };

  xdg.configFile."zed/settings.json".text = builtins.toJSON {
    # keep-sorted start block=yes
    "buffer_font_size" = 15;
    "edit_predictions" = {
      "mode" = "subtle";
    };
    "icon_theme" = "Colored Zed Icons Theme Dark";
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
      "nixd" = {
        "initialization_options" = {
          "formatting" = {
            "command" = [ "nixfmt" ];
          };
          "options" = {
            # If this is ommited; default search path (<nixpkgs>) will be used.
            "nixos" = {
              "expr" =
                "(builtins.getFlake \"/home/el/Projects/nixos-configuration\").nixosConfigurations.inanna.options";
            };
            # By default there is no home-manager options completion
            "home_manager" = {
              "expr" =
                "(builtins.getFlake \"/home/el/Projects/nixos-configuration\").nixosConfigurations.inanna.options.home-manager.users.type.getSubOptions []";
            };
            # For flake-parts options.
            "flake-parts" = {
              "expr" = "(builtins.getFlake \"/home/el/Projects/nixos-configuration\").debug.options";
            };
            # For a `perSystem` flake-parts option =
            "flake-parts2" = {
              "expr" = "(builtins.getFlake \"/home/el/Projects/nixos-configuration\").currentSystem.options";
            };
          };
        };
      };
    };
    "soft_wrap" = "bounded";
    "telemetry" = {
      "metrics" = false;
      "diagnostics" = false;
    };
    "theme" = {
      "mode" = "system";
      "light" = "One Light";
      "dark" = "Gruvbox Material Neovim Dark";
    };
    "ui_font_size" = 16;
    # keep-sorted end
  };
}
