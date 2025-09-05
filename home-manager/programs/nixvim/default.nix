{ inputs, ... }:
{

  imports = [
    inputs.home
    inputs.nixvim.homeManagerModules.nixvim
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    luaLoader.enable = true;
    extraConfigLua = ''
    '';

    plugins = {};
  };
}
