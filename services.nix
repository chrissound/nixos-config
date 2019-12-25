{ config, pkgs, ... }:

let
  sources = import ./nix/sources.nix;
  moscoviumorange = sources.MoscoviumOrange;
  in
{
  services.safeeyes.enable = true;

  services.printing.enable = true;
  services.printing.drivers = [ pkgs.brlaser pkgs.brgenml1lpr pkgs.brgenml1cupswrapper ];
  # services.xrdp.enable = true;

  services.nextcloud = {
    # enable = true;
    enable = false;
    hostName = "_";
    nginx.enable = true;
    config = {
      adminuser = "chrissy";
      adminpassFile = "/etc/nixos/secrets/nextcloud_adminpass";
      extraTrustedDomains = [
      "192.168.0.6"
      "10.0.2.2"
      ];
    };
  };

  # services.samba = {
  #   enable = false;
  #   securityType = "user";
  #   extraConfig = ''
  #     workgroup = WORKGROUP
  #     server string = smbnix
  #     netbios name = smbnix
  #     hosts allow = 192.168.0  localhost 10.0.2
  #     hosts deny = 0.0.0.0/0
  #     guest account = nobody
  #     wins support = yes
  #     local master = yes
  #     preferred master = yes
  #   '';
  #   shares = {
  #     public = {
  #       path = "/home/chris/mount/raid18t/chris/samba";
  #       browseable = "yes";
  #       "read only" = "no";
  #       "guest ok" = "yes";
  #       "create mask" = "0777";
  #       "directory mask" = "0755";
  #       "force user" = "chris";
  #       "force group" = "users";
  #       "valid users" = "chris, guest";
  #     };
  #   };
  # };

  ### BEGIN HERE
 
  # services.grafana.enable = true;
  # services.my-elasticsearch = {
  #   enable = true;
  #   extraJavaOptions = [ "-Xms128m" "-Xmx128m" ];
  #   extraConf = ''
  #   http.cors.allow-origin: http://localhost:1358,http://127.0.0.1:1358, https://opensource.appbase.io
  #   http.cors.enabled: true
  #   http.cors.allow-headers : X-Requested-With,X-Auth-Token,Content-Type,Content-Length,Authorization
  #   '';
  # };

  # services.kibana.enable = true;
  # services.logstash.enable = true;
  # services.logstash.inputConfig = ''
  #   # Read from journal
  #   udp {
  #     port => 25826
  #     buffer_size => 1452
  #     codec => collectd { }
  #   }
  #   file {
  #     type => "text"
  #     path => ["/tmp/wtfchris"]
  #   }
  # '';
  # services.logstash.outputConfig = ''
  #   stdout { }
  #   if [collectd_type] =~ /.+/ {
  #     elasticsearch {
  #       index => "metrics-%{+xxxx.ww}"
  #     }
  #   }
  # '';
  # services.collectd.enable = true;
  # services.collectd.extraConfig = ''
  # LoadPlugin CPU
  # LoadPlugin Memory
  # LoadPlugin Interface
  # LoadPlugin Memory
  # LoadPlugin Network
  # <Plugin "network">
  # Server "127.0.0.1"
  # </Plugin>

  # '';

 ### END HERE

  systemd.user.services = {
    greenclip = {
      description = "Greenclip: Simple clipboard manager to be integrated with rofi";
      enable = true;
      serviceConfig = {
        Type      = "simple";
        ExecStart = "${pkgs.haskellPackages.greenclip}/bin/greenclip daemon";
        Restart   = "always";
        RestartSec   = 10;
      };
      wantedBy = [ "default.target" ];
    };
    moscoviumOrange = {
      enable = true;
      description = "MoscoviumOrange terminal history";
      serviceConfig = {
        Type      = "simple";
        ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %h/.config/moscoviumOrange/pending/";
        ExecStart = "${moscoviumorange}/bin/moscoviumorange --daemon";
        Restart   = "always";
        RestartSec   = 1;
      };
      wantedBy = [ "default.target" ];
    };
    echotmp = {
      enable = true;
      description = "echotmp";
      serviceConfig = {
        Type      = "simple";
        ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p /tmp2/echotmp/";
        ExecStart = "${pkgs.bash}/bin/bash -c \"echo 'hello' >> /tmp2/echotmp/log.txt\"";
        OnUnitInactiveSec = "30s";
      };
      wantedBy = [ "default.target" ];
    };
  };

  location = {
    latitude = 55.0;
    longitude = 3.0;
  };

  services.redshift = {
    enable = true;
    # latitude = "55";
    # longitude = "3";
    temperature = {
      day = 7500;
      night = 3500;
    };
    brightness = {
      day = "1.0";
      night = "0.7";
    };
	};

  services.openssh.enable = true;
  # services.teamviewer.enable = true;
  services.emacs.enable = true;

  services.xserver = {
    videoDrivers = [ "nvidia" ];
    # videoDrivers = [ "amdgpu" ];
	  #   enable = true;
    # };
    dpi = 160;
    #dpi = 192;
    enable = true;
    layout = "dvorak";
    xkbOptions = "eurosign:e";
    # windowManager.xmonad = {
    #   enable = true;
    #   enableContribAndExtras = true;
    #   extraPackages = haskellPackages: [
    #     haskellPackages.xmonad-contrib
    #     haskellPackages.xmonad-extras
    #     haskellPackages.xmonad
    #   ];
    # };

    # windowManager.default = "xmonad";
    displayManager.sddm.enable = false;

    libinput.enable = true;
    libinput.middleEmulation = true;

    # Fix redshift green
    # https://github.com/jonls/redshift/issues/587
    screenSection = ''
      Option "UseNvKmsCompositionPipeline" "0"
    '';

    serverFlagsSection =
      ''
      Option "OffTime" "1"
      '';
  };

  # services.prometheus.enable = true;
  services.prometheus.enable = false;
  services.prometheus.configText = ''
    global:
      scrape_interval:     5s # By default, scrape targets every 15 seconds.

      # Attach these labels to any time series or alerts when communicating with
      # external systems (federation, remote storage, Alertmanager).
      external_labels:
        monitor: 'codelab-monitor'

    # A scrape configuration containing exactly one endpoint to scrape:
    # Here it's Prometheus itself.
    scrape_configs:
      # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
      - job_name: 'prometheus'
        scrape_interval: 5s
        static_configs:
          - targets: ['localhost:9090']
      - job_name: 'haproxy'
        scrape_interval: 5s
        static_configs:
          - targets: ['10.8.0.1:9101']

  '';

  # services.nfs.server.enable = true;

  # services.haproxy.enable = true;
  services.haproxy.config = builtins.readFile /etc/nixos/configs/haproxy.conf;
}
