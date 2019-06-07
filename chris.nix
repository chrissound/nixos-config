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
  # xmonadChris = pkgs.callPackage ./xmonad/default.nix {};
  sodiumSierraStrawberry = pkgs.callPackage /home/chris/fromLaptopt/usbflash/Haskell/SodiumSierraStrawberry/default.nix {};
  unstable = import <unstable> {
    config = config.nixpkgs.config; 
  };
  myCustomPkgs = [
    sodiumSierraStrawberry
  ];
  devopsPkgs = with pkgs; [
    # anydesk
    (unstable.terraform.withPlugins (p: [
      p.aws
      p.google
      p.hcloud
      p.libvirt
      p.random
      p.template
      ]))
    teamviewer
    dive
    acpi
    awscli
    dmidecode
    docker
    docker_compose
    google-cloud-sdk
    gitlab-runner
    python37Packages.yamllint
    kubectl
    kubernetes-helm
    unstable.minikube
    openssl
    virtmanager
    gnome3.dconf
    gnumake
    gitkraken
    git
    nomad
    unstable.consul
    unstable.traefik
    nginx
    zoom-us
  ];

  desktopSystemPkgsNetwork = with pkgs; [
    bind
    tcptrack
    bmon
    tshark
    traceroute
    smbclient
    iana-etc
    inetutils
    nmap
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
    sshfs-fuse
  ];
  desktopSystemPkgs = with pkgs; [
	  xorg.xgamma
    # (wine.override { wineBuild = "wine64"; })
    bc
    ddccontrol
    dtrx
    gnupg
    gwenview
    htop
    inotify-tools
    irssi
    ispell
    light
    lm_sensors
    maim
    mkpasswd
    multitail
    nix-prefetch-git
    openbox
    openvpn
    postgresql
    qt5ct
    wine
    wmctrl
    x11vnc
    xorg.xf86videodummy	
    xvfb_run
    usbutils
  ] ++ desktopSystemPkgsStorage ++ desktopSystemPkgsNetwork;
  desktopEnvironmentUiPkgs = with pkgs; [
    gxmessage
    gnome3.gnome-settings-daemon
    gnome3.gnome-system-monitor
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
    kdenlive
    testdisk-photorec
    graphicsmagick
    xfce4-13.thunar
    xfce4-13.tumbler
    imagemagickBig
    pinta
    gthumb
    vlc
    youtube-dl
    feh
    qiv
    file
    (mpv.override { jackaudioSupport = true; })
    mplayer
    spotify
    simplescreenrecorder
    ffmpeg
  ];
  desktopPkgs = with pkgs; [
    v4l_utils
    libv4l
    gnome3.evolution 
    sylpheed
    alacritty
    dolphin
    emacs
    neovim
    vscode
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
    transmission-gtk
    signal-desktop
    tdesktop # telegram
    screenkey
    scantailor
  ] ++ desktopEnvironmentUiPkgs ++ desktopMediaPkgs;
  musicProdPkgs = with pkgs; [
    calf
    ardour
    sox
    audacity
    qjackctl
    libjack2
    supercollider
    unstable.jack2
  ];
  cliPkgs = with pkgs; [
    gist
    ag
    bat
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
    moreutils
    tldr
    tree
    zip
    unzip
    pigz
    wget
    xclip
    xdotool
    zsh
  ];
  myHaskellPackages = with pkgs; [
    cabal2nix
    cabal-install
    haskellPackages.xmonad
    haskellPackages.pretty-simple
    haskellPackages.apply-refact
    # unstable.haskellPackages.bhoogle
    haskellPackages.greenclip
    haskellPackages.hindent
    haskellPackages.hlint
    haskellPackages.hoogle
    unstable.haskellPackages.hpack
    haskellPackages.hserv
    # unstable.haskellPackages.vgrep
    #haskellPackages.taffyBar
    unstable.stack2nix
    unstable.haskellPackages.ghcid
    unstable.haskellPackages.ghc-prof-flamegraph
    # unstable.haskellPackages.hpack-convert
    #unstable.haskellPackages.steeloverseer
    stack
  ];
in
{
   environment.systemPackages = with pkgs;
      devopsPkgs
   ++ desktopPkgs
   ++ desktopSystemPkgs
   ++ musicProdPkgs
   ++ cliPkgs
   ++ myHaskellPackages
   ++ myCustomPkgs
   ++ [nodejs lsof peek remmina arduino prometheus xvfb_run xrdp openbox libvncserver tigervnc x2goclient awesome x11vnc keepass keepassxc mysql openjdk
   xorg.xinit
   ];

    nixpkgs.config.allowUnfree = true;

    programs.chromium = {
       enable = true;
       extensions = [
        "dbepggeogbaibhgnhhndojpepiihcmeb" # Vimium
        "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
        "kmcfomidfpdkfieipokbalgegidffkal" # enpass
        "niloccemoadcdkdjlinkgdfekeahmflj" # pocket
        "biiammgklaefagjclmnlialkmaemifgo" # sideways tree tabs
        "fihnjjcciajhdojfnbdddfaoknhalnja" # I don't care about cookies
        "nffaoalbilbmmfgbnbgppjihopabppdk" # video speed controller
       ];
    };
}
