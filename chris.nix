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
    acpi
    awscli
    dmidecode
    docker
    docker_compose
    git
    google-cloud-sdk
    kubectl
    kubernetes-helm
  ];

  desktopSystemPkgs = with pkgs; [
    duplicity
    gptfdisk
    htop
    iotop
    irssi
    ispell
    light
    lm_sensors
    maim
    nix-prefetch-git
    ntfs3g
    parted
  ];
  desktopPkgs = with pkgs; [
    alacritty
    dolphin
    emacs
    enpass
    evince
    feh
    firefox
    gnome3.gnome-settings-daemon
    gnome3.gnome_terminal
    gnumake
    hexchat
    konsole
    libreoffice
    lxappearance
    lxqt.qterminal
    maim
    mpv
    neovim
    openvpn
    paper-icon-theme
    pavucontrol
    rofi
    scrot
    spotify
    sshpass
    tint2
    unstable.google-chrome
    volumeicon
    xbindkeys
  ];
  musicProdPkgs = with pkgs; [
    audacity
    qjackctl
    supercollider
    unstable.jack2
  ];
  cliPkgs = with pkgs; [
    ag
    bash
    exa
    fzf
    gitAndTools.diff-so-fancy
    global
    jq
    postgresql
    pstree
    ranger
    ripgrep
    shellcheck
    stdenv
    tree
    unzip
    wget
    xclip
    xdotool
    zsh
  ];
  myHaskellPackages = with pkgs; [
    cabal-install
    cabal2nix
    haskellPackages.apply-refact
    haskellPackages.bhoogle
    haskellPackages.greenclip
    haskellPackages.hindent
    haskellPackages.hlint
    haskellPackages.hoogle
    unstable.haskellPackages.ghcid
    unstable.stack
  ];
in
{

   environment.systemPackages = with pkgs; [
     # google-chrome
     #libjack2
     #xorg.xrdb
     #xsettingsd
     breeze-gtk
   ]
   ++ devopsPkgs
   ++ desktopPkgs
   ++ desktopSystemPkgs
   ++ musicProdPkgs
   ++ cliPkgs
   ++ myHaskellPackages;

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
