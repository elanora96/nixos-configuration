{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
let
  mediaDir = config.homelab.storage;
  stateDir = "${mediaDir}/data/.state";
  movieDir = "${mediaDir}/Videos/Movies/";
  showDir = "${mediaDir}/Videos/TV Shows/";
  downloadsDir = "${mediaDir}/Downloads";
  musicDir = "${mediaDir}/Music";
  mediaUsers = [ "el" ];
in
{
  imports = [ inputs.nixflix.nixosModules.default ];

  sops.secrets =
    let
      rootOwnedMediaGroupRead = {
        group = "media";
        mode = "0440";
      };
    in
    {
      # keep-sorted start block=yes
      "jellyfin/alex_password" = { };
      "jellyfin/api_key" = rootOwnedMediaGroupRead;
      "jellyfin/el_password" = { };
      "lidarr/api_key" = rootOwnedMediaGroupRead;
      "lidarr/password" = rootOwnedMediaGroupRead;
      "opensubtitles/api_key" = { };
      "opensubtitles/password" = { };
      "qbittorrent/app_password" = { };
      # keep-sorted end
    };

  nixflix = {
    inherit
      downloadsDir
      mediaDir
      mediaUsers
      stateDir
      ;
    enable = true;
    serviceDependencies = [ "mnt-media.mount" ];

    # keep-sorted start block=yes

    downloadarr = {
      enable = true;
      qbittorrent.enable = true;
    };
    jellyfin = {
      enable = true;
      apiKey._secret = config.sops.secrets."jellyfin/api_key".path;
      users =
        let
          configuration = {
            subtitleLanguagePreference = "eng";
            subtitleMode = "Always";
          };
        in
        {
          el = {
            inherit configuration;
            policy.isAdministrator = true;
            password._secret = config.sops.secrets."jellyfin/el_password".path;
          };
          alex = {
            inherit configuration;
            password._secret = config.sops.secrets."jellyfin/alex_password".path;
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
          Music = {
            inherit metadataCountryCode preferredMetadataLanguage;
            collectionType = "music";
            paths = config.nixflix.lidarr.mediaDirs;
          };
        };
      plugins =
        let
          inherit (inputs.nixflix.lib.jellyfinPlugins) fromRepo;
        in
        {
          subbuzz = {
            enable = true;
            config = {
              OpenSubApiKey._secret = config.sops.secrets."opensubtitles/api_key".path;
              OpenSubPassword._secret = config.sops.secrets."opensubtitles/password".path;
              OpenSubUserName = "turkey4637";
              EnableOpenSubtitles = true;
              EnableYifySubtitles = true;
              Cache.SubLifeInMinutes = "Always";
            };
          };
          "Subtitle Extract" = {
            enable = true;
            config.ExtractionDuringLibraryScan = true;
          };
          "Intro Skipper" = {
            package = fromRepo {
              version = "1.10.11.17";
              hash = "sha256-cfEnLqKeEGpQSth3NPjDnxCkgv2pePfgCXfVIOrYSiQ=";
            };
            config = {
              ExcludeSeries = "";
              AutoDetectIntros = true;
              AnalyzeSeasonZero = false;
              PreferChromaprint = false;
              CacheFingerprints = true;
              UseAlternativeBlackFrameAnalyzer = false;
              UpdateMediaSegments = true;
              RebuildMediaSegments = true;
              ScanIntroduction = true;
              ScanCredits = true;
              ScanRecap = true;
              ScanPreview = true;
              ScanCommercial = false;
              AnalysisPercent = "25";
              AnalysisLengthLimit = "10";
              FullLengthChapters = false;
              SkipFirstEpisode = false;
              SkipFirstEpisodeAnime = false;
              MinimumIntroDuration = "15";
              MaximumIntroDuration = "120";
              MinimumCreditsDuration = "15";
              MaximumCreditsDuration = "450";
              MaximumMovieCreditsDuration = "900";
              MinimumRecapDuration = "15";
              MaximumRecapDuration = "120";
              MinimumPreviewDuration = "15";
              MaximumPreviewDuration = "120";
              MinimumCommercialDuration = "15";
              MaximumCommercialDuration = "120";
              BlackFrameMinimumPercentage = "85";
              BlackFrameThreshold = "28";
              UseChapterMarkersBlackFrame = true;
              AdjustIntroBasedOnChapters = true;
              AdjustIntroBasedOnSilence = true;
              SnapToKeyframe = true;
              EndSnapThreshold = "2";
              AdjustWindowInward = "5";
              AdjustWindowOutward = "2";
              ChapterAnalyzerIntroductionPattern = "(^|\\s)(Intro|Introduction|OP|Opening)(?!\\sEnd)(\\s|$)";
              ChapterAnalyzerEndCreditsPattern = "(^|\\s)(Credits?|ED|Ending|Outro)(?!\\sEnd)(\\s|$)";
              ChapterAnalyzerPreviewPattern = "(^|\\s)(Preview|PV|Sneak\\s?Peek|Coming\\s?(Up|Soon)|Next\\s+(time|on|episode)|Extra|Teaser|Trailer)(?!\\sEnd)(\\s|:|$)";
              ChapterAnalyzerRecapPattern = "(^|\\s)(Re?cap|Sum{1,2}ary|Prev(ious(ly)?)?|(Last|Earlier)(\\s\\w+)?|Catch[ -]up)(?!\\sEnd)(\\s|:|$)";
              ChapterAnalyzerCommercialPattern = "(^|\\s)(Ad(vert(isement)?)?|Commercial)(?!\\sEnd)(\\s|$)";
              IntroEndOffset = "0";
              IntroStartOffset = "0";
              MaximumFingerprintPointDifferences = 6;
              MaximumTimeSkip = 3.5;
              InvertedIndexShift = 2;
              SilenceDetectionMaximumNoise = "-50";
              SilenceDetectionMinimumDuration = "0.33";
              MaxParallelism = "2";
              ProcessThreads = "0";
              ProcessPriority = "BelowNormal";
              UseFileTransformationPlugin = false;
              SkipbuttonHideDelay = "8";
              EnableMainMenu = true;
              FileTransformationPluginEnabled = false;
            };
          };
        };
    };
    lidarr = {
      enable = true;
      mediaDirs = [ musicDir ];
      config = {
        apiKey._secret = config.sops.secrets."lidarr/api_key".path;
        hostConfig.password._secret = config.sops.secrets."lidarr/password".path;
      };
    };
    nginx = {
      inherit (config.homelab) domain;
      enable = true;
      enableACME = true;
      forceSSL = true;
    };
    postgres.enable = true;
    theme = {
      enable = true;
      name = "catppuccin-macchiato";
    };
    torrentClients = {
      qbittorrent = {
        inherit downloadsDir;
        enable = true;
        vpn.enable = true;
        password._secret = config.sops.secrets."qbittorrent/app_password".path;
        serverConfig = {
          LegalNotice.Accepted = true;
          BitTorrent = {
            Session = {
              AddTorrentStopped = false;
              QueueingSystemEnabled = true;

              # Required for port forwarding from a VPN
              ReannounceWhenAddressChanged = true;
            };
          };
          Preferences = {
            General.Locale = "en";
            WebUI =
              let
                # TODO:
                # While the password is bare in config
                # And will end up in the nix store
                # It is already hashed
                # https://codeberg.org/feathecutie/qbittorrent_password
                # But I do wish I could use sops for it
                # qbittorrent doesn't make this easy
                # Can't use a password file or an environment variable
                hashedPBKDF2 = "X2o9OGuXHOAkBE2sEAFnCw==:SAy4Hy6Ras+4JfSVf8GjnWXXxBnZPTm5jPL8A3b4jb+NuE6c2poCRXcV/IO3E8FpWeVDPfIZoYkjcChVACqZew==";
              in
              {
                Username = "admin";
                Password_PBKDF2 = "@ByteArray(${hashedPBKDF2})";
              };
          };
        };
      };
    };
    vpn = {
      enable = true;
      wgConfFile = config.sops.secrets."wireguard_conf".path;
      accessibleFrom = [
        "192.0.0.0/24"
        "127.0.0.0/24"
        "100.0.0.0/24"
      ];
    };
    # keep-sorted end
  };
  systemd.services.vpn-port-forward =
    let
      qbCfg = config.nixflix.torrentClients.qbittorrent;
    in
    lib.mkIf (config.nixflix.vpn.enable && qbCfg.vpn.enable) {
      description = "VPN port forwarding for qBittorrent";
      after = [
        "${config.systemd.services.qbittorrent.vpnConfinement.vpnNamespace}.service"
        "qbittorrent.service"
      ];
      requires = [
        "${config.systemd.services.qbittorrent.vpnConfinement.vpnNamespace}.service"
        "qbittorrent.service"
      ];
      wantedBy = [ "multi-user.target" ];

      path = [
        pkgs.curl
        pkgs.jq
        pkgs.libnatpmp
        pkgs.iproute2
        pkgs.gawk
      ];

      serviceConfig = {
        Type = "simple";
        Restart = "on-failure";
        RestartSec = "5s";
        ExecStart =
          let
            ns = config.systemd.services.qbittorrent.vpnConfinement.vpnNamespace;
            qbHost = "http://${qbCfg.serverConfig.Preferences.WebUI.Address}:${toString config.services.qbittorrent.webuiPort}";
            qbUser = qbCfg.serverConfig.Preferences.WebUI.Username;
            qbPassFile = config.sops.secrets."qbittorrent/app_password".path;
          in
          pkgs.writeShellScript "vpn-port-forward" ''
            QB_HOST="${qbHost}"
            QB_USER="${qbUser}"
            QB_PASS=$(cat ${qbPassFile})

            QB_COOKIE=$(curl -s -c - --data "username=$QB_USER&password=$QB_PASS" \
              "$QB_HOST/api/v2/auth/login" | grep SID | awk '{print $NF}')

            CURRENT_PORT=$(curl -s -b "SID=$QB_COOKIE" \
              "$QB_HOST/api/v2/app/preferences" | jq '.listen_port')

            while true; do
              UDP_OUT=$(ip netns exec ${ns} natpmpc -a 1 0 udp 60 -g 10.2.0.1)
              ip netns exec ${ns} natpmpc -a 1 0 tcp 60 -g 10.2.0.1

              PORT=$(echo "$UDP_OUT" | grep "Mapped public port" | awk '{print $4}')

              if [ -z "$PORT" ]; then
                echo "Failed to get port, is the tunnel up?"
                sleep 5
                continue
              fi

              if [ "$PORT" != "$CURRENT_PORT" ]; then
                echo "Port changed: $CURRENT_PORT -> $PORT, updating qBittorrent..."
                curl -s -b "SID=$QB_COOKIE" \
                  --data "json={\"listen_port\":$PORT,\"random_port\":false}" \
                  "$QB_HOST/api/v2/app/setPreferences"
                curl -s -b "SID=$QB_COOKIE" \
                  --data "hashes=all" \
                  "$QB_HOST/api/v2/torrents/reannounce"
                CURRENT_PORT=$PORT
              fi

              sleep 45
            done
          '';
      };
    };
}
