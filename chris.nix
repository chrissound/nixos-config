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
#{ config, ... }:

let
  xmonadChris = pkgs.callPackage ./xmonad/default.nix {};
  unstable = import <unstable> {
    config = config.nixpkgs.config; 
  };
  devopsPkgs = with pkgs; [
    # anydesk
    teamviewer
    acpi
    awscli
    dmidecode
    docker
    docker_compose
    google-cloud-sdk
    kubectl
    kubernetes-helm
    minikube
    openssl
    virtmanager
    gnome3.dconf
    gnumake
  ];

  desktopSystemPkgsNetwork = with pkgs; [
    git
    bind
    tcptrack
    bmon
    tshark
    traceroute
    smbclient
  ];
  desktopSystemPkgsStorage = with pkgs; [
    jmtpfs
    duplicity
    gparted
    gptfdisk
    hdparm
    iotop
    ntfs3g
    parted
    smartmontools
    sysstat
    e2fsprogs
    ncdu
    mdadm
    borgbackup
  ];
  desktopSystemPkgs = with pkgs; [
    bc
    ddccontrol
    gnupg
    gwenview
    htop
    irssi
    ispell
    light
    lm_sensors
    maim
    nix-prefetch-git
    postgresql
    qt5ct
    wmctrl
	  xorg.xgamma
    openvpn
    inotify-tools
    multitail
  ] ++ desktopSystemPkgsStorage ++ desktopSystemPkgsNetwork;
  desktopEnvironmentUiPkgs = with pkgs; [
    gxmessage
    gnome3.gnome-settings-daemon
    paper-icon-theme
    lxappearance
    volumeicon
    xbindkeys
    breeze-gtk
    xcompmgr
    compton
    tint2
  ];
  desktopMediaPkgs = with pkgs; [
    xfce4-13.thunar
    xfce4-13.tumbler
    imagemagickBig
    pinta
    gthumb
    vlc
    youtube-dl
    feh
    file
    mpv
    spotify
    simplescreenrecorder
  ];
  desktopPkgs = with pkgs; [
    alacritty
    dolphin
    emacs
    neovim
    evince
    firefox
    gnome3.gnome_terminal
    hexchat
    konsole
    libreoffice
    lxqt.qterminal
    pavucontrol
    rofi
    scrot
    tor-browser-bundle-bin
    thunderbird
    unstable.enpass
    unstable.google-chrome
    transmission
    transmission-gtk
    signal-desktop
    tdesktop # telegram
  ] ++ desktopEnvironmentUiPkgs ++ desktopMediaPkgs;
  musicProdPkgs = with pkgs; [
    sox
    audacity
    qjackctl
    supercollider
    unstable.jack2
  ];
  cliPkgs = with pkgs; [
    ag
    bash
    unstable.broot
    # unstable.ruplacer
    exa
    fd
    fzf
    fpp
    gitAndTools.diff-so-fancy
    global
    jq
    pstree
    pv
    ranger
    ripgrep
    shellcheck
    sshpass
    stdenv
    tmux
    tldr
    tree
    unzip
    wget
    xclip
    xdotool
    zsh
  ];
  myHaskellPackages = with pkgs; [
    cabal2nix
    cabal-install
    haskellPackages.apply-refact
    haskellPackages.bhoogle
    haskellPackages.greenclip
    haskellPackages.hindent
    haskellPackages.hlint
    haskellPackages.hoogle
    haskellPackages.hpack
    haskellPackages.hserv
    # unstable.haskellPackages.vgrep
    #haskellPackages.taffyBar
    stack2nix
    unstable.haskellPackages.ghcid
    unstable.haskellPackages.ghc-prof-flamegraph
    # unstable.haskellPackages.hpack-convert
    #unstable.haskellPackages.steeloverseer
    unstable.stack
  ];
in
{
   environment.systemPackages = with pkgs;
      devopsPkgs
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
        "niloccemoadcdkdjlinkgdfekeahmflj" # pocket
       ];
    };
}
