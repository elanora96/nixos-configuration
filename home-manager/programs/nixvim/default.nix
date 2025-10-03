{ inputs, ... }:
{

  imports = [
    inputs.home
    inputs.nixvim.homeModules.nixvim
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    luaLoader.enable = true;
    extraConfigLua = '''';

    plugins = { };
  };
}
