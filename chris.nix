{ config, pkgs, ... }:

{
   environment.systemPackages = with pkgs; [
     wget
     git
     neovim
     tint2
     unzip
     ranger
     enpass
     rofi
     pavucontrol
     light
     konsole
     emacs
     firefox
     lxqt.qterminal
   ];

    nixpkgs.config.allowUnfree = true;

    programs.chromium = {
       enable = true;
       extensions = [
        "dbepggeogbaibhgnhhndojpepiihcmeb" # Vimium
       ];
    };
}
