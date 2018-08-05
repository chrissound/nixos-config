{ config, pkgs, ... }:

{
   environment.systemPackages = with pkgs; [
     audacity
     mpv

     postgresql
     docker
     docker_compose
     lm_sensors
     acpi
     feh
     haskellPackages.stack
     wget
     git
     neovim
     tint2
     unzip
     enpass
     pavucontrol
     light

     konsole
     emacs

     firefox
     lxqt.qterminal
     stdenv
     gnumake
     bash
     htop

     ispell
     ripgrep
     ranger
     rofi
     zsh
   ];

    nixpkgs.config.allowUnfree = true;

    programs.chromium = {
       enable = true;
       extensions = [
        "dbepggeogbaibhgnhhndojpepiihcmeb" # Vimium
       ];
    };
}
