{ config, pkgs, ... }:

let
  # Define variables for repetitive values
  myIpAddress = "192.168.1.99";
  myNetworkGateway = "192.168.1.1";
  myNameservers =
    [ "208.67.222.222" "208.67.220.220" "9.9.9.9" "1.1.1.1" "8.8.8.8" ];
  myLocale = "en_US.UTF-8";
  myTimezone = "Asia/Tbilisi";
  # List of system packages
  mySystemPackages = [
    pkgs.act
    pkgs.ansible
    pkgs.bat
    pkgs.curl
    pkgs.direnv
    pkgs.du-dust
    pkgs.duf
    pkgs.fd
    pkgs.gh
    pkgs.git
    pkgs.glab
    pkgs.glances
    pkgs.gping
    pkgs.hugo
    pkgs.mc
    pkgs.ncdu
    pkgs.neovim
    pkgs.nushell
    pkgs.openvscode-server
    pkgs.procs
    pkgs.python3
    pkgs.q
    pkgs.starship
    pkgs.tmux
    pkgs.wget
    pkgs.yq-go
  ];
in {
  imports = [ ./hardware-configuration.nix ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;
  boot.supportedFilesystems = [ "ntfs" ];

  environment.systemPackages = mySystemPackages;

  fileSystems."/media/Content" = {
    device = "/dev/disk/by-uuid/14CA2BE5CA2BC23A";
    fsType = "ntfs-3g";
  };

  i18n.defaultLocale = myLocale;

  networking.defaultGateway = myNetworkGateway;
  networking.enableIPv6 = false;
  networking.firewall.enable = false;
  networking.hostName = "nixos";
  networking.interfaces.eth0.ipv4.addresses = [{
    address = myIpAddress;
    prefixLength = 24;
  }];
  networking.nameservers = myNameservers;
  networking.networkmanager.enable = true;

  nixpkgs.config.allowUnfree = true;

  time.timeZone = myTimezone;

  security.sudo.extraRules = [{
    users = [ "nett00n" ];
    commands = [{
      command = "ALL";
      options = [ "NOPASSWD" ];
    }];
  }];

  services.openssh.enable = true;

  system.copySystemConfiguration = true;
  system.stateVersion = "23.11";

  systemd.services.glances = {
    description = "Glances system monitor";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "/run/current-system/sw/bin/glances -w";
      Restart = "always";
      RestartSec = "30";
      User = "root";
    };
  };

  systemd.services.code-server = {
    description = "Glances system monitor";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart =
        "/run/current-system/sw/bin/openvscode-server"
          + " --host 0.0.0.0"
          + " --port 3001"
          + " --accept-server-license-terms"
          + " --telemetry-level off"
          + " --without-connection-token";
      Restart = "always";
      RestartSec = "30";
      User = "nett00n";
    };
  };

  users.users.nett00n = {
    isNormalUser = true;
    description = "nett00n";
    extraGroups = [ "networkmanager" "wheel" "sudo" "docker" ];
    packages = with pkgs; [ ];
  };

  virtualisation.docker.enable = true;

}
