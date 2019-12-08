{ config, pkgs, ... }:

{
  containers.test2 = {
    config = { config, pkgs, ... }:
    {

      nixpkgs.config.allowUnfree = true;

      imports =
        [ # Include the results of the hardware scan.
          ./my-elasticsearch.nix
        ];

      networking.firewall.allowedTCPPorts =  [ 3000 ];

      # environment.etc = {
      #   "resolv.conf".text =
      #   ''
      #   nameserver 192.168.0.32
      #   domain Home
      #   nameserver 192.168.0.1
      #   nameserver fd41:931f:1a76:0:7250:afff:fe37:3384
      #   options edns0
      #   options edns0
      #   '';
      # };

      services.kibana.enable = true;
      services.my-elasticsearch = {
        enable = true;
        extraJavaOptions = [ "-Xms256m" "-Xmx256m" ];
        extraConf = ''
        http.cors.allow-origin: http://localhost:1358,http://127.0.0.1:1358, https://opensource.appbase.io
        http.cors.enabled: true
        http.cors.allow-headers : X-Requested-With,X-Auth-Token,Content-Type,Content-Length,Authorization
        '';
      };
      # services.influxdb.enable = true;
      # services.grafana.enable  = true;
      environment.systemPackages = with pkgs; [
        sshfs-fuse
        git
        ripgrep
        influxdb
        wget
      ];
    };
  };

  containers.mark = {
    config = { config, pkgs, ... }:
    {

      services.kubernetes = {
        roles = ["master" "node"];
        masterAddress = "abc";
      };

      networking.firewall.allowedTCPPorts =  [ 3000 ];

      # environment.etc = {
      #   "resolv.conf".text =
      #   ''
      #   nameserver 192.168.0.32
      #   domain Home
      #   nameserver 192.168.0.1
      #   nameserver fd41:931f:1a76:0:7250:afff:fe37:3384
      #   options edns0
      #   options edns0
      #   '';
      # };
      environment.systemPackages = with pkgs; [
        python36
        python36Packages.virtualenv
        python36Packages.cffi
        git
        gcc
        libffi
        purePackages.ffi
        vim
        python.pkgs.pip
      ];
    };
  };

  containers.nixbincache = {
    privateNetwork = true;
    autoStart = true;
    hostAddress = "192.168.140.10";
    localAddress = "192.168.140.11";
    hostAddress6 = "fc00::1";
    localAddress6 = "fc00::2";

    config = { config, pkgs, ... }:
    {

      networking.firewall.enable = false;
      networking.useHostResolvConf = true;
      networking.firewall.rejectPackets = true;
      networking.firewall.allowedTCPPorts =  [ 80 443 ];

      services.nginx = {
        enable = true;
        appendHttpConfig = ''
          proxy_cache_path /var/public-nginx-cache/ levels=1:2 keys_zone=cachecache:100m max_size=200g inactive=180d use_temp_path=off;

          # Cache only success status codes; in particular we don't want to cache 404s.
          # See https://serverfault.com/a/690258/128321
          map $status $cache_header {
            200     "public";
            302     "public";
            default "no-cache";
          }

          access_log logs/access.log;
        '';
        virtualHosts."localhost" = {
          # enableACME = true;

          locations."/" = {
            root = "/var/public-nix-cache";
            extraConfig = ''
              expires max;
              add_header Cache-Control $cache_header always;
              sendfile on;

              # Ask the upstream server if a file isn't available locally
              error_page 404 = @fallback;
            '';
          };
          extraConfig = ''
            # Using a variable for the upstream endpoint to ensure that it is
            # resolved at runtime as opposed to once when the config file is loaded
            # and then cached forever (we don't want that):
            # see https://tenzer.dk/nginx-with-dynamic-upstreams/
            # This fixes errors like
            #   nginx: [emerg] host not found in upstream "upstream.example.com"
            # when the upstream host is not reachable for a short time when
            # nginx is started.
            resolver 8.8.8.8;
            set $upstream_endpoint http://cache.nixos.org;
          '';
          locations."@fallback" = {
            proxyPass = "$upstream_endpoint";
            extraConfig = ''
              proxy_cache cachecache;
              proxy_cache_valid  200 302  60m;

              expires max;
              add_header Cache-Control $cache_header always;
            '';
          };
          # We always want to copy cache.nixos.org's nix-cache-info file,
          # and ignore our own, because `nix-push` by default generates one
          # without `Priority` field, and thus that file by default has priority
          # 50 (compared to cache.nixos.org's `Priority: 40`), which will make
          # download clients prefer `cache.nixos.org` over our binary cache.
          locations."= /nix-cache-info" = {
            # Note: This is duplicated with the `@fallback` above,
            # would be nicer if we could redirect to the @fallback instead.
            proxyPass = "$upstream_endpoint";
            extraConfig = ''
              proxy_cache cachecache;
              proxy_cache_valid  200 302  60m;

              expires max;
              add_header Cache-Control $cache_header always;
            '';
          };
        };
      };
    };
  };
}
