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
  devopsPkgs = with pkgs; [
    awscli
    docker_compose
    kubectl
    kubernetes-helm
    google-cloud-sdk
  ];
  desktopPkgs = with pkgs; [
    dolphin
    firefox
    gnome3.gnome-settings-daemon
    gnome3.gnome_terminal
    libreoffice
    lxappearance
    lxqt.qterminal
    mpv
    paper-icon-theme
    pavucontrol
    rofi
    spotify
    tint2
    unstable.google-chrome
    volumeicon
    xbindkeys
    konsole
    enpass
    evince
  ];
  musicProdPkgs = with pkgs; [
    audacity
    supercollider
    qjackctl
    unstable.jack2
  ];
  cliPkgs = with pkgs; [
    tree
    global
    exa
    fzf
    ag
    gitAndTools.diff-so-fancy
    jq
    ranger
    shellcheck
    stdenv
    ripgrep
    xclip
    xdotool
    zsh
    bash
  ];
in
{

   environment.systemPackages = with pkgs; [
     scrot
     maim
     openvpn
     sshpass
     ntfs3g
     # google-chrome
     #libjack2
     #xorg.xrdb
     #xsettingsd
     breeze-gtk
     cabal-install
     cabal2nix
     acpi
     alacritty
     dmidecode
     docker
     duplicity
     emacs
     feh
     git
     gnumake
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
     light
     lm_sensors
     maim
     neovim
     nix-prefetch-git
     ntfs3g
     parted
     postgresql
     pstree
     unstable.haskellPackages.ghcid
     unstable.stack
     unzip
     wget
   ]
   ++ devopsPkgs
   ++ desktopPkgs
   ++ musicProdPkgs
   ++ cliPkgs;

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
