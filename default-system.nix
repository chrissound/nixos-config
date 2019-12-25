{ config, pkgs, lib, ... }:
{
  powerManagement = {
    enable = true;
    cpuFreqGovernor = lib.mkDefault "ondemand";
  };

  systemd.services.systemd-udev-settle.serviceConfig.ExecStart = "${pkgs.coreutils}/bin/true";

  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;

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

  users.extraUsers.chris =
    { isNormalUser = true;
      home = "/home/chris";
      description = "Chris Stryczynski";
      extraGroups = [ "wheel" "networkmanager" "docker" "audio" "libvirtd" "dialout"];
      shell = pkgs.zsh;
    };

  programs.dconf.enable = true;

  environment.interactiveShellInit = ''
   if [[ "$VTE_VERSION" > 3405 ]]; then
   source "${pkgs.gnome3.vte}/etc/profile.d/vte.sh"
   fi
   '';

  time.timeZone = "Europe/London";

}
