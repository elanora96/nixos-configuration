{
  lib,
  config,
  inputs,
  ...
}:
let
  mediaDir = config.homelab.storage;
  stateDir = "${mediaDir}/data/.state";
  movieDir = "${mediaDir}/Videos/Movies/";
  showDir = "${mediaDir}/Videos/TV Shows/";
in
{
  imports = [ inputs.nixflix.nixosModules.default ];

  sops.secrets = {
    # keep-sorted start block=yes
    "jellyfin/api_key" = { };
    "jellyfin/el_password" = { };
    # keep-sorted end
  };

  nixflix = {
    inherit mediaDir stateDir;
    enable = true;

    nginx = {
      inherit (config.homelab) domain;
      enable = true;
      enableACME = true;
      forceSSL = true;
    };

    postgres.enable = true;

    theme = {
      enable = true;
      name = "organizr";
    };

    jellyfin = {
      enable = true;
      apiKey._secret = config.sops.secrets."jellyfin/api_key".path;
      users.el = {
        policy.isAdministrator = true;
        password._secret = config.sops.secrets."jellyfin/el_password".path;
        configuration = {
          subtitleLanguagePreference = "eng";
          subtitleMode = "Always";
        };
      };
      libraries =
        let
          metadataCountryCode = "US";
          preferredMetadataLanguage = "en";
          subtitleDownloadLanguages = [ "eng" ];
        in
        {
          Movies = lib.mkForce {
            inherit metadataCountryCode preferredMetadataLanguage subtitleDownloadLanguages;
            collectionType = "movies";
            enableRealtimeMonitor = true;
            paths = [ movieDir ];
          };
          Shows = lib.mkForce {
            inherit metadataCountryCode preferredMetadataLanguage subtitleDownloadLanguages;
            collectionType = "tvshows";
            seasonZeroDisplayName = "Specials";
            paths = [ showDir ];
          };
        };
    };
  };
}
