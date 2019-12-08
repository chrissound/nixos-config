{ config, pkgs, ... }:

let
  hardware.pulseaudio.package = pkgs.pulseaudioFull.override {
    jackaudioSupport = true;
  };
  nixpkgsMyStable = import (builtins.fetchTarball {
    url = https://github.com/NixOS/nixpkgs/archive/775fb69ed73e7cf6b7d3dd9853a60f40e8efc340.tar.gz;
    sha256 = "1w068b0ydw4c26mcjiwlzdfqcdk3rrwmfx4hxzgfhfwcz2nmh3if";
  }) {};
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./chris.nix
      ./services.nix
      ./containers.nix
      ./my-elasticsearch.nix
      ./cachix.nix
      ./nixos.nix
      ./networking.nix
    ];

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "ondemand";
  };

  systemd.services.systemd-udev-settle.serviceConfig.ExecStart = "${pkgs.coreutils}/bin/true";

  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;


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
  boot.kernelPackages = pkgs.linuxPackages_latest;

  environment.etc."zsh/zshrc".source = "${pkgs.awscli}/share/zsh/site-functions/aws_zsh_completer.sh";

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

   nixpkgs.config.packageOverrides = pkgs: {
     kdenlive = pkgs.kdenlive.overrideAttrs (oldAttrs: rec {
         postInstall = ''
          wrapProgram $out/bin/kdenlive --prefix FREI0R_PATH : ${pkgs.frei0r}/lib/frei0r-1
        '';
        nativeBuildInputs = oldAttrs.nativeBuildInputs or [] ++ [ pkgs.makeWrapper ];
     });
   };


  users.extraUsers.chris =
  { isNormalUser = true;
    home = "/home/chris";
    description = "Chris Stryczynski";
    extraGroups = [ "wheel" "networkmanager" "docker" "audio" "libvirtd" "dialout"];
    shell = pkgs.zsh;
  };
  users.extraUsers.chris2 =
    { isNormalUser = true;
      home = "/home/chris2";
      description = "Chris Stryczynski";
      extraGroups = [ "wheel" "networkmanager" "docker" "audio" "libvirtd" "dialout"];
      shell = pkgs.zsh;
    };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.03";
	virtualisation.docker.enable = true;
  hardware.bluetooth.enable = true;
  virtualisation.libvirtd.enable = true;
  # virtualisation.virtualbox.host.enable = true;

  # hardware.pulseaudio.configFile = pkgs.writeText "default.pa" ''
  # #load-module module-bluetooth-policy
  # #load-module module-bluetooth-discover
  # '';
  programs.dconf.enable = true;

  nix = {
    # binaryCaches = [
    #   "http://192.168.140.11/"
    #   # "https://cache.nixos.org/"
    #   # "https://hydra.iohk.io"
    # ];
    # binaryCachePublicKeys = [
    #   "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
    #   #"my-nix-cache:z3o8Kf/PTzehVpMsE2KoYyf5rkU/XCR0+AfEvtKSgo8="
    # ];
    trustedUsers = [ "root" "chris" ];
  };
  # nix = {
  #   binaryCaches = [
  #     "https://cache.nixos.org/"
  #     "http://127.0.0.1:8899"
  #   ];
  #   binaryCachePublicKeys = [
  #     "my-nix-cache:z3o8Kf/PTzehVpMsE2KoYyf5rkU/XCR0+AfEvtKSgo8="
  #   ];
  #   trustedUsers = [ "root" "chris" ];
  # };
}
