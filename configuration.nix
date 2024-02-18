{ config, pkgs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;
  boot.supportedFilesystems =
    [
      "ntfs"
    ];

  environment.systemPackages = with pkgs;
      [
	act
	ansible
	tmux
        curl
        doggo
        gh
        git
        glab
        glances
        hugo
        mc
        ncdu
        neovim
        nushell
        openvscode-server
        python3
        starship
        wget
      ];

  fileSystems."/media/Content" =
    {
      device = "/dev/disk/by-uuid/14CA2BE5CA2BC23A";
      fsType = "ntfs-3g";
    };

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings =
    {
      LC_ADDRESS = "ru_RU.UTF-8";
      LC_IDENTIFICATION = "ru_RU.UTF-8";
      LC_MEASUREMENT = "ru_RU.UTF-8";
      LC_MONETARY = "ru_RU.UTF-8";
      LC_NAME = "ru_RU.UTF-8";
      LC_NUMERIC = "ru_RU.UTF-8";
      LC_PAPER = "ru_RU.UTF-8";
      LC_TELEPHONE = "ru_RU.UTF-8";
      LC_TIME = "ru_RU.UTF-8";
    };

  networking.firewall.enable = false;
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  nixpkgs.config.allowUnfree = true;

  time.timeZone = "Asia/Tbilisi";

  security.sudo.extraRules=
    [
      {
        users = [ "nett00n" ];
        commands = [
          {
            command = "ALL" ;
            options= [ "NOPASSWD" ];
          }
        ];
      }
    ];

  services.openssh.enable = true;

  system.copySystemConfiguration = true;
  system.stateVersion = "23.11";

  systemd.services.glances =
    {
      description = "Glances system monitor";
      after =
        [
          "network.target"
        ];
      wantedBy =
        [
          "multi-user.target"
        ];
      serviceConfig =
        {
          ExecStart = "/run/current-system/sw/bin/glances -w";
          Restart = "always";
          RestartSec = "30";
          User = "root";
        };
    };

  users.users.nett00n =
    {
      isNormalUser = true;
      description = "nett00n";
          extraGroups =
            [
              "networkmanager"
              "wheel"
              "sudo"
              "docker"
            ];
      packages = with pkgs;
        [
        ];
    };

  virtualisation.docker.enable = true;

}
