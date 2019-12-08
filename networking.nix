{ config, pkgs, ... }:
{
    networking.hostName = "blueberry"; # Define your hostname.
    networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    networking.extraHosts =
    ''
    34.70.83.136 app.willowbee.ca
    52.209.72.168 jenkins.howdoo.io
    52.209.72.168 jenkins2.howdoo.io
 
    '';
    # ''
    # # staging      raiden-api-ingress   pp3-be.fnstaging.net       35.244.133.249    80, 443   161d
    # # staging      subzero-ingress      pp3.fnstaging.net          35.201.114.203    80, 443   165d

    # # 35.171.228.123 api.k8s2.budbuds.us
    # app.willowbee.ca 34.70.83.136
    # chatbot.boomlabs.ai 35.203.27.94


    # mygitlab.ddns.net 34.70.231.64

    # # # Fresh nation

    # # 35.244.133.249 pp3-be.fnstaging.net
    # # 35.201.114.203 pp3.fnstaging.net
    # # 35.244.133.249 pp3-be.freshnation.net
    # # 35.201.114.203 pp3.freshnation.net

    # 192.168.39.56 raiden-api-ingress.local
    # 192.168.39.56 subzero-ingress.local

    
    # # # 35.244.133.249 chrispp3-be.ddns.net
    # # # 35.244.202.44 subzero.freshnation.com

    # # # 116.203.70.99 trycatchchris.co.uk

    # # # 104.31.92.167 testk8s.telepass.cc
    # # # 192.168.39.61 example.com

    # # # 192.168.122.224 www.levelnine.de
    # # # 192.168.122.224 www.objectiveit.de
    # # # 192.168.122.224 levelnine.de
    # # # 192.168.122.224 objectiveit.de
    # # 35.244.154.110 www.levelnine.de
    # # 35.244.154.110 www.objectiveit.de
    # # 35.244.154.110 levelnine.de
    # # 35.244.154.110 objectiveit.de


    # 35.244.185.12 pp3-be-demo.freshnation.com
    # 34.96.106.143 demo.freshnation.com
    # '';
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
