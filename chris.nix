# nix = {
#   binaryCaches = [
#     "https://cache.nixos.org/"
#     "https://komposition.cachix.org"
#   ];
#   binaryCachePublicKeys = [
#     "komposition.cachix.org-1:nzWESzP0bEENshGnqQYN8+mic6JOxw2APw/AJAXhF3Y="
#   ];
#   trustedUsers = [ "root" "chris" ];
# };

{ config, pkgs, ... }:

let
  xmonadChris = pkgs.callPackage ./xmonad/default.nix {};
  unstable = import <unstable> {
    config = config.nixpkgs.config; 
  };
in
{
   environment.systemPackages = with pkgs; [
     scrot
     maim
     openvpn
     sshpass
     ntfs3g
     # google-chrome
     #xorg.xrdb
     #xsettingsd
     acpi
     kubernetes-helm
     ag
     alacritty
     audacity
     awscli
     bash
     breeze-gtk
     cabal-install
     cabal2nix
     dmidecode
     docker
     docker_compose
     dolphin
     duplicity
     emacs
     enpass
     evince
     exa
     feh
     firefox
     fzf
     git
     gitAndTools.diff-so-fancy
     gnome3.gnome-settings-daemon
     gnome3.gnome_terminal
     gnumake
     google-cloud-sdk
     gptfdisk
     haskellPackages.apply-refact
     haskellPackages.greenclip
     haskellPackages.hindent
     haskellPackages.hlint
     haskellPackages.bhoogle
     haskellPackages.hoogle
     hexchat
     htop
     iotop
     irssi
     ispell
     jq
     konsole
     kubectl
     libreoffice
     light
     lm_sensors
     lxappearance
     lxqt.qterminal
     maim
     mpv
     neovim
     nix-prefetch-git
     paper-icon-theme
     parted
     pavucontrol
     postgresql
     pstree
     ranger
     ripgrep
     rofi
     spotify
     stdenv
     tint2
     tree
     unstable.google-chrome
     unstable.haskellPackages.ghcid
     unstable.stack
     unzip
     volumeicon
     wget
     xbindkeys
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
