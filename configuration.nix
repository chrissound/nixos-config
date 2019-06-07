{ config, pkgs, ... }:

let 
  hardware.pulseaudio.package = pkgs.pulseaudioFull.override {
    jackaudioSupport = true;
  };
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./chris.nix
      ./services.nix
      ./containers.nix
    ];
    powerManagement = {
    enable = true;
    cpuFreqGovernor = "ondemand";
    };
  systemd.services.systemd-udev-settle.serviceConfig.ExecStart = "${pkgs.coreutils}/bin/true";
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;

	# services.nginx.enable = ;
  # environment.etc = {
  #   "resolv.conf".text = "nameserver 192.168.0.32\n";
  # };

  ## Boot
    # Use the GRUB 2 boot loader.
    boot.loader.grub.enable = true;
    boot.loader.grub.useOSProber = true;
    boot.loader.grub.version = 2;
    boot.loader.grub.efiSupport = true;
    boot.loader.grub.efiInstallAsRemovable = true;
    boot.loader.efi.efiSysMountPoint = "/boot/efi";
    # Define on which hard drive you want to install Grub.
    boot.loader.grub.device = "nodev"; # or "nodev" for efi only
    boot.loader.systemd-boot.enable = true;
    #boot.extraModprobeConfig = "options nouveau noaccel=1 runpm=0 nofbaccel=1 modeset=1";

  ## Networking 
    networking.hostName = "nixos"; # Define your hostname.
    networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    networking.extraHosts =
    ''
    # 35.244.133.249 pp3-be.fnstaging.net
    # 35.244.133.249 chrispp3-be.ddns.net
    # 35.244.202.44 subzero.freshnation.com

    # 116.203.70.99 trycatchchris.co.uk

    104.31.92.167 testk8s.telepass.cc
    192.168.122.85 raiden-api-ingress.local
    192.168.122.85 subzero-ingress.local
    192.168.39.61 example.com

    '';
    networking.nat.enable = true;
    networking.nat.internalInterfaces = ["ve-+"];
    networking.nat.externalInterface = "wlp2s0f0u8";
    # networking.networkmanager.unmanaged = [ "interface-name:ve-*" ];

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

  security.sudo.wheelNeedsPassword = false;

  i18n = {
    consoleFont = "Lat2-Terminus32";
    consoleKeyMap = "dvorak";
    defaultLocale = "en_US.UTF-8";
  };

  fonts = {
      fontconfig = {
        ultimate.enable = true;	# This enables fontconfig-ultimate settings for better font rendering
        defaultFonts = {
          monospace = ["Iosevka"];
        };
      };
      enableFontDir = true;
      enableGhostscriptFonts = true;
      fonts = with pkgs; [
        terminus_font
          corefonts
          noto-fonts
          iosevka
      ];
  };

  time.timeZone = "Africa/Abidjan";

   #List packages installed in system profile. To search by name, run:
   #$ nix-env -qaP | grep wget
   environment.systemPackages = with pkgs; [
   ];

   environment.interactiveShellInit = ''
   if [[ "$VTE_VERSION" > 3405 ]]; then
   source "${pkgs.gnome3.vte}/etc/profile.d/vte.sh"
   fi
   '';

    # nixpkgs.config.packageOverrides = pkgs: {
    #     haskellPackages = pkgs.haskellPackages.override {
    #       overrides = hsSelf: hsSuper: {
    #         greenclip  = pkgs.haskell.lib.overrideCabal hsSuper.greenclip  (oa: {
    #           version = "3.1.1";
    #           sha256 = "1axh1q7kcvcnhn4rl704i4gcix5yn5v0sb3bdgjk4vgkd7fv8chw";
    #           executablePkgconfigDepends = oa.executablePkgconfigDepends ++ [pkgs.xorg.libXdmcp];
    #         });

    #         wordexp  = pkgs.haskell.lib.overrideCabal hsSuper.wordexp  (oa: {
    #           version = "0.2.2";
    #           sha256 = "1mbcrq89jz0dcibw66w0jdy4f4bfpx4zwjfs98rm3jjgdikwdzb4";
    #         });
    #       };
    #     };
    #   };


  # networking.firewall.allowedTCPPorts = [ ... ];
  networking.firewall.allowedTCPPorts =  [ 80 81 5900 2049 111 ];
  # networking.firewall.allowedUDPPorts = [ ... ];


  users.extraUsers.chris =
  { isNormalUser = true;
    home = "/home/chris";
    description = "Chris Stryczynski";
    extraGroups = [ "wheel" "networkmanager" "docker" "audio" "libvirtd" "dialout"];
    shell = pkgs.zsh;
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.03";
	virtualisation.docker.enable = true;
  hardware.bluetooth.enable = true;
  virtualisation.libvirtd.enable = true;
  virtualisation.virtualbox.host.enable = true;

  # hardware.pulseaudio.configFile = pkgs.writeText "default.pa" ''
  # #load-module module-bluetooth-policy
  # #load-module module-bluetooth-discover
  # '';
  programs.dconf.enable = true;

  nix = {
    binaryCaches = [
      "https://cache.nixos.org/"
      "https://komposition.cachix.org"
    ];
    binaryCachePublicKeys = [
      "komposition.cachix.org-1:nzWESzP0bEENshGnqQYN8+mic6JOxw2APw/AJAXhF3Y="
    ];
    trustedUsers = [ "root" "chris" ];
  };
}
