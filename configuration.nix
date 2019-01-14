# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

# let 
#   hardware.pulseaudio.package = pkgs.pulseaudioFull.override { jackaudioSupport = true; };
# in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./chris.nix
      #./gh22652.nix
      #./cursor.nix
    ];
    powerManagement = {
    enable = true;
    cpuFreqGovernor = "ondemand";
    };
  systemd.services.systemd-udev-settle.serviceConfig.ExecStart = "${pkgs.coreutils}/bin/true";
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;

	services.printing.enable = true;

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
  boot.extraModprobeConfig = "options nouveau noaccel=1 runpm=0 nofbaccel=1 modeset=1";

  networking.hostName = "nixos"; # Define your hostname.
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.extraHosts =
  ''
  35.244.133.249 pp3-be.fnstaging.net
  35.244.133.249 chrispp3-be.ddns.net
  '';

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
				font-droid
				iosevka
		];
};

  # Set your time zone.
  time.timeZone = "Europe/London";

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
        haskellPackages = pkgs.haskellPackages.override {
          overrides = hsSelf: hsSuper: {
            greenclip  = pkgs.haskell.lib.overrideCabal hsSuper.greenclip  (oa: {
              version = "3.1.1";
              sha256 = "1axh1q7kcvcnhn4rl704i4gcix5yn5v0sb3bdgjk4vgkd7fv8chw";
              executablePkgconfigDepends = oa.executablePkgconfigDepends ++ [pkgs.xorg.libXdmcp];
            });

            wordexp  = pkgs.haskell.lib.overrideCabal hsSuper.wordexp  (oa: {
              version = "0.2.2";
              sha256 = "1mbcrq89jz0dcibw66w0jdy4f4bfpx4zwjfs98rm3jjgdikwdzb4";
            });
          };
        };
      };


  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;
  services.emacs.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    # synaptics = {
	  #   enable = true;
    # };
    dpi = 128;
    enable = true;
    layout = "dvorak";
    xkbOptions = "eurosign:e";
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = haskellPackages: [
        haskellPackages.xmonad-contrib
        haskellPackages.xmonad-extras
        haskellPackages.xmonad
      ];
    };

    windowManager.default = "xmonad";

    libinput.enable = true;
    libinput.middleEmulation = true;

  };

    services.redshift = {
      enable = true;
      latitude = "55";
      longitude = "3";
      temperature = {
        day = 7500;
        night = 3500;
      };
      brightness = {
        day = "1.0";
        night = "0.7";
      };
	};

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.xserverArgs =
  [
    "-logfile" "/tmp/x.log"
  ];
  #services.xserver.desktopManager.plasma5.enable = true;
  # services.xserver.displayManager.lightdm.enable = true;

  #Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.chris =
  { isNormalUser = true;
    home = "/home/chris";
    description = "Chris Stryczynski";
    extraGroups = [ "wheel" "networkmanager" "docker" "audio"];
    shell = pkgs.zsh;
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.03";
	virtualisation.docker.enable = true;
  hardware.bluetooth.enable = true;

  # hardware.pulseaudio.configFile = pkgs.writeText "default.pa" ''
  # #load-module module-bluetooth-policy
  # #load-module module-bluetooth-discover
  # '';

  systemd.user.services = {
    greenclip = {
      description = "Greenclip: Simple clipboard manager to be integrated with rofi";
      enable = true;
      serviceConfig = {
        Type      = "simple";
        ExecStart = "${pkgs.haskellPackages.greenclip}/bin/greenclip daemon";
        Restart   = "always";
      };
      wantedBy = [ "default.target" ];
    };
  };
}
