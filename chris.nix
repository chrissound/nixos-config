{ config, pkgs, ... }:

#{ config, ... }:


let
  sources = import ./nix/sources.nix;
  niv = import sources.niv {};
  nixpkgsMyStable = import (builtins.fetchTarball {
    url = https://github.com/NixOS/nixpkgs/archive/775fb69ed73e7cf6b7d3dd9853a60f40e8efc340.tar.gz;
    sha256 = "1w068b0ydw4c26mcjiwlzdfqcdk3rrwmfx4hxzgfhfwcz2nmh3if";
  }) {config.allowUnfree = true;};
  nixpkgs1903 = import (builtins.fetchTarball {
    url = https://github.com/NixOS/nixpkgs/archive/f52505fac8c82716872a616c501ad9eff188f97f.tar.gz;
  }) {config.allowUnfree = true;};
  sodiumSierraStrawberry = import sources.SodiumSierraStrawberry {};
  moscoviumorange = import sources.MoscoviumOrange {};
  hexla = import sources.Hexla {};
  myxmonad = import sources.XMonadLayouts {}; # 
  # myxmonad = pkgs.callPackage /home/chris/fromLaptopt/usbflash/Haskell/MyXmonad/lib/default.nix {};
  # sodiumSierraStrawberry = pkgs.callPackage /home/chris/fromLaptopt/usbflash/Haskell/SodiumSierraStrawberry/default.nix {};
  # moscoviumorange = pkgs.callPackage /home/chris/fromLaptopt/usbflash/Haskell/MoscoviumOrange/default.nix {};
  # myxmonad = pkgs.callPackage /home/chris/fromLaptopt/usbflash/Haskell/MyXmonad/default.nix {};
  # hexla = pkgs.callPackage /home/chris/fromLaptopt/usbflash/Haskell/Hexla/default.nix {};
  unstable = import <unstable> {
    config = config.nixpkgs.config;
  };
  myCustomPkgs = [
    sodiumSierraStrawberry
    moscoviumorange
    myxmonad
    hexla
    # (import (builtins.fetchTarball "https://github.com/chrissound/GitChapter/archive/master.tar.gz") {}) # gitchapter
  ];
  programmingPkgs = with pkgs; [
    # idea.idea-community
    # jetbrains.phpstorm
  ];
  nixStuffPkgs = with pkgs; [

    (import (builtins.fetchTarball "https://github.com/target/lorri/archive/rolling-release.tar.gz") {})
    nixops
    nix-deploy
    nix-index
    (unstable.haskellPackages.niv)
    cachix
  ];
  devopsK8sPkgs = with pkgs; [
    kubernetes-helm
    unstable.kops
    kubectl
    unstable.minikube
  ];
  devopsPkgs = with pkgs; [
    # anydesk
    (unstable.terraform.withPlugins(p: [
      p.aws
      p.google
      p.hcloud
      p.libvirt
      p.random
      p.template
      p.null
      p.external
      p.kubernetes
      p.helm
      ]))
    dive
    acpi
    awscli
    aws-iam-authenticator
    dmidecode
    docker
    docker_compose
    google-cloud-sdk
    # gitlab-runner
    python37Packages.yamllint
    python37Packages.virtualenv
    python37Packages.virtualenvwrapper
    vagrant
    gcc
    openssl
    virtmanager
    gnome3.dconf
    gnumake
    gitkraken
    git
    # nomad
    # unstable.consul
    # unstable.traefik
    nginx
    zoom-us
    # mysql-workbench
    sqlite
  ] ++ devopsK8sPkgs;
  desktopSystemPkgsNetwork = with pkgs; [
    bind
    tcptrack
    bmon
    tshark
    tcpdump
    traceroute
    smbclient
    iana-etc
    inetutils
    nmap
    netcat-gnu
  ];
  systemPkgs = with pkgs; [
    htop
    hdparm
    iotop
    mdadm
    parted
    gptfdisk
    ntfs3g
    smartmontools
    ncdu
    gparted
    lsof
  ];
  desktopSystemPkgsStorage = with pkgs; [
    jmtpfs
    duplicity
    sysstat
    e2fsprogs
    borgbackup
    sshfs-fuse
  ];
  desktopSystemPkgs = with pkgs; [
	  xorg.xgamma
    # (wine.override { wineBuild = "wine64"; })
    bc
    dtrx
    gnupg
    gwenview
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
    i3
    openvpn
    postgresql
    qt5ct
    wine
    wmctrl
    x11vnc
    xorg.xf86videodummy	
    xvfb_run
    usbutils
    p7zip
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
    breeze-icons
    xcompmgr
    compton
    tint2
    taffybar
  ];
  desktopMediaPkgs = with pkgs; [
    (import (builtins.fetchTarball "https://github.com/owickstrom/komposition/archive/master.tar.gz") {}).komposition
    unstable.kdenlive
    kinit
    testdisk-photorec
    graphicsmagick
    xfce4-14.thunar
    xfce4-14.tumbler
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
  editorPkgs = with pkgs; [
    emacs
    neovim
  ];
  desktopPkgs = with pkgs; [
    barrier
    v4l_utils
    libv4l
    sylpheed
    alacritty
    dolphin
    vscode
    evince
    firefox
    brave
    gnome3.gnome_terminal
    hexchat
    konsole
    libreoffice
    lxqt.qterminal
    pavucontrol
    rofi
    scrot
    tor-browser-bundle-bin
    unstable.enpass
    nixpkgsMyStable.pkgs.google-chrome
    transmission-gtk
    signal-desktop
    screenkey
    scantailor
    teamviewer
  ] ++ desktopEnvironmentUiPkgs ++ desktopMediaPkgs;
  communicationPkgs = with pkgs; [
    discord
    tdesktop # telegram
    # skypeforlinux
    thunderbird
    gnome3.evolution 
  ];
  musicProdPkgs = with pkgs; [
    calf
    ardour
    sox
    audacity
    qjackctl
    libjack2
    supercollider
    jack2
    bitwig-studio
  ];
  dataTextPkgs = with pkgs; [
    jq
    jl
    ripgrep
    gron
  ];
  cliPkgs = with pkgs; [
    asciinema
    direnv
    gist
    ag
    bat
    bash
    broot
    # unstable.ruplacer
    exa
    fd
    fzf
    fpp
    gitAndTools.diff-so-fancy
    global
    pstree
    pv
    ranger
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
    lz4
    wget
    xclip
    xdotool
    zsh
  ];
  myHaskellPackages = with pkgs; [
    ghc
    stack
    cabal2nix
    cabal-install
    haskellPackages.pretty-simple
    haskellPackages.apply-refact
    # unstable.haskellPackages.bhoogle
    haskellPackages.greenclip
    haskellPackages.hindent
    haskellPackages.hlint
    haskellPackages.hoogle
    unstable.haskellPackages.hpack
    haskellPackages.hserv
    haskellPackages.profiteur
    # unstable.haskellPackages.vgrep
    #haskellPackages.taffyBar
    #stack2nix
    unstable.haskellPackages.ghcid
    unstable.haskellPackages.ghc-prof-flamegraph
    # unstable.haskellPackages.hpack-convert
    #unstable.haskellPackages.steeloverseer
    # stack
    (import (builtins.fetchTarball "https://github.com/hercules-ci/ghcide-nix/tarball/master") {}).ghcide-ghc865
    (import (builtins.fetchTarball "https://github.com/mpickering/eventlog2html/archive/master.tar.gz") {}).eventlog2html
  ];
  myCorePackages = with pkgs; [
  ]
  ++ editorPkgs
  ++ cliPkgs
  ++ systemPkgs
  ++ dataTextPkgs
  ;
in
{
   environment.systemPackages = with pkgs;
      programmingPkgs
   ++ devopsPkgs
   ++ nixStuffPkgs
   ++ desktopPkgs
   ++ desktopSystemPkgs
   ++ musicProdPkgs
   ++ communicationPkgs
   ++ myHaskellPackages
   ++ myCustomPkgs
   ++ myCorePackages
   ++ [nodejs peek remmina arduino prometheus xvfb_run xrdp openbox libvncserver tigervnc x2goclient awesome x11vnc keepass keepassxc mysql openjdk
   xorg.xinit
   ];

    nixpkgs.config.allowUnfree = true;

    programs.chromium = {
       enable = true;
       extensions = [
        "dbepggeogbaibhgnhhndojpepiihcmeb" # Vimium
        "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
        "kmcfomidfpdkfieipokbalgegidffkal" # enpass
        "biiammgklaefagjclmnlialkmaemifgo" # sideways tree tabs
        "fihnjjcciajhdojfnbdddfaoknhalnja" # I don't care about cookies
        "nffaoalbilbmmfgbnbgppjihopabppdk" # video speed controller
        "klbibkeccnjlkjkiokjodocebajanakg" # suspender
        "djcfdncoelnlbldjfhinnjlhdjlikmph" # high contrast
       ];
    };
}
