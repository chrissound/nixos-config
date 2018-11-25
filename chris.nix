{ config, pkgs, ... }:

let
  xmonadChris = pkgs.callPackage ./xmonad/default.nix {};
  unstable = import <unstable> {
    config = config.nixpkgs.config; 
  };
in
{
   environment.systemPackages = with pkgs; [
     duplicity
     tree
     #xorg.xrdb
     #xsettingsd
     gnome3.gnome-settings-daemon
     volumeicon
     iotop
     gptfdisk
     parted
     # google-chrome
     unstable.google-chrome
     evince
     acpi
     ag
     alacritty
     audacity
     bash
     cabal-install
     cabal2nix
     dmidecode
     docker
     docker_compose
     emacs
     enpass
     exa
     feh
     firefox
     fzf
     git
     gitAndTools.diff-so-fancy
     gnome3.gnome_terminal
     gnumake
     haskellPackages.greenclip
     hexchat
     htop
     irssi
     ispell
     konsole
     light
     lm_sensors
     lxqt.qterminal
     mpv
     neovim
     nix-prefetch-git
     pavucontrol
     postgresql
     pstree
     ranger
     ripgrep
     rofi
     stdenv
     tint2
     unstable.haskellPackages.ghcid
     unstable.stack
     unzip
     paper-icon-theme
     wget
     xclip
     xdotool
     zsh
   ];

    nixpkgs.config.allowUnfree = true;

    programs.chromium = {
       enable = true;
       extensions = [
        "dbepggeogbaibhgnhhndojpepiihcmeb" # Vimium
        "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
        "kmcfomidfpdkfieipokbalgegidffkal"
       ];
    };
}
