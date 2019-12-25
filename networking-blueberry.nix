{ config, pkgs, ... }:
{
    networking.hostName = "blueberry"; # Define your hostname.
    networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    networking.extraHosts =
    ''
    '';
    networking.nat.enable = true;
    networking.nat.internalInterfaces = ["ve-+"];
    networking.nat.externalInterface = "wlp2s0f0u8";
    # networking.networkmanager.unmanaged = [ "interface-name:ve-*" ];

    networking.firewall.enable = true;
    networking.firewall.allowedTCPPorts =  [ 80 81 443 5900 2049 111 9000  24800 ];
    networking.firewall.trustedInterfaces = [ "ve-+" "ve-nixbincache"];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # networking.firewall.extraCommands =
    #   ''
    #     ip46tables -A nixos-fw -i ve-+ -p tcp --dport 443 -j nixos-fw-accept;
    #     ip46tables -A nixos-fw -i ve-+ -p tcp --dport 80 -j nixos-fw-accept;
    #     ip46tables -A nixos-fw -i ve-+ -p udp --dport 53 -j nixos-fw-accept;
    #     ip46tables -A nixos-fw -i ve-+ -p tcp --dport 53 -j nixos-fw-accept;
    #     '';
}
