{ config, pkgs, ... }:

let
  hardware.pulseaudio.package = pkgs.pulseaudioFull.override {
    jackaudioSupport = true;
  };
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./chris.nix
      ./services.nix
      ./containers.nix
      ./my-elasticsearch.nix
      ./cachix.nix
      ./nixos.nix
      ./networking.nix
      ./default-system.nix
      ./boot.nix
    ];

  hardware.pulseaudio.package = pkgs.pulseaudioFull;

   nixpkgs.config.packageOverrides = pkgs: {
     kdenlive = pkgs.kdenlive.overrideAttrs (oldAttrs: rec {
         postInstall = ''
          wrapProgram $out/bin/kdenlive --prefix FREI0R_PATH : ${pkgs.frei0r}/lib/frei0r-1
        '';
        nativeBuildInputs = oldAttrs.nativeBuildInputs or [] ++ [ pkgs.makeWrapper ];
     });
   };

  users.extraUsers.chris2 =
    { isNormalUser = true;
      home = "/home/chris2";
      description = "Chris Stryczynski";
      extraGroups = [ "wheel" "networkmanager" "docker" "audio" "libvirtd" "dialout"];
      shell = pkgs.zsh;
    };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.03";
	virtualisation.docker.enable = true;
  hardware.bluetooth.enable = true;
  virtualisation.libvirtd.enable = true;
  virtualisation.virtualbox.host.enable = true;

  # hardware.pulseaudio.configFile = pkgs.writeText "default.pa" ''
  # #load-module module-bluetooth-policy
  # #load-module module-bluetooth-discover
  # '';

  nix = {
    binaryCaches = [
      # "http://192.168.140.11/"
      "https://cache.nixos.org/"
      "https://hydra.iohk.io"
    ];
    binaryCachePublicKeys = [
      "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      # 6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=
    #   #"my-nix-cache:z3o8Kf/PTzehVpMsE2KoYyf5rkU/XCR0+AfEvtKSgo8="
    ];
    trustedUsers = [ "root" "chris" ];
  };
  # nix = {
  #   binaryCaches = [
  #     "https://cache.nixos.org/"
  #     "http://127.0.0.1:8899"
  #   ];
  #   binaryCachePublicKeys = [
  #     "my-nix-cache:z3o8Kf/PTzehVpMsE2KoYyf5rkU/XCR0+AfEvtKSgo8="
  #   ];
  #   trustedUsers = [ "root" "chris" ];
  # };
}
