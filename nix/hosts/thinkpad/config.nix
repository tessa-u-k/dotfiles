# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardwareconfig.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.efiSupport = false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.kernelPackages = pkgs.linuxPackages_latest;
  programs.nix-ld.enable = false;

  networking.hostName = "pennyix"; # Define your hostname.
  networking.networkmanager.enable = true;
  services.printing.enable = true;

  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services.upower.enable = true;
  services.libinput.enable = true;
  services.power-profiles-daemon.enable = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;


  virtualisation.docker.enable = true;  

  security.rtkit.enable = true;

  # Fingerprint reader (Synaptics 06cb:009a) via open-fprintd + python-validity.
  # Enroll with `fprintd-enroll` after rebuilding.
  services."06cb-009a-fingerprint-sensor" = {
    enable = true;
    backend = "python-validity";
  };

  security.pam.services = {
    # plasma-login-manager substacks "login", so this covers the greeter and TTYs.
    # Note: a fingerprint login can't unlock KWallet (it needs the password).
    login.fprintAuth = true;
    sudo.fprintAuth = true;
    # Lock screen fingerprint; Plasma only defines this when services.fprintd is on.
    kde-fingerprint.fprintAuth = true;
  };

  # KWallet is the only Secret Service provider (PAM unlock comes from plasma6).
  services.gnome.gnome-keyring.enable = false;
  security.pam.services.login.enableGnomeKeyring = false;
  # KWallet doesn't ship a D-Bus activation file for the Secret Service name.
  services.dbus.packages = [
    (pkgs.writeTextDir "share/dbus-1/services/org.freedesktop.secrets.service" ''
      [D-BUS Service]
      Name=org.freedesktop.secrets
      Exec=${pkgs.kdePackages.kwallet}/bin/ksecretd
    '')
  ];

  # SSH keys live in ssh-agent; ksshaskpass (set by plasma6) stores passphrases in KWallet.
  programs.ssh.startAgent = true;
  programs.ssh.extraConfig = ''
    AddKeysToAgent yes
  '';
  systemd.user.services.ssh-add-keys = {
    description = "Load SSH keys into ssh-agent using passphrases from KWallet";
    wantedBy = [ "graphical-session.target" ];
    after = [ "graphical-session.target" "ssh-agent.service" ];
    requires = [ "ssh-agent.service" ];
    unitConfig.ConditionPathExists = "%h/.ssh/tess_rsa";
    environment = {
      SSH_AUTH_SOCK = "%t/ssh-agent";
      SSH_ASKPASS = config.programs.ssh.askPassword;
      SSH_ASKPASS_REQUIRE = "force";
    };
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${config.programs.ssh.package}/bin/ssh-add %h/.ssh/tess_rsa";
      StandardInput = "null";
    };
  };
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  users.users.penny = {
    isNormalUser = true;
    description = "penny";
    extraGroups = [ "networkmanager" "wheel" "docker" "plugdev" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      orca-slicer
      qFlipper
      calibre
      nzbget
      firefox-esr
      pangolin-cli
      kiwix
      kiwix-tools
      unzip
      rpi-imager
      claude-code
    ];
  };

  programs.zsh.enable = true;
  # Enable Plasma 
  services.desktopManager.plasma6.enable = true;

    # Default display manager for Plasma
  services.displayManager.plasma-login-manager.enable = true;

    # Optionally enable xserver
  services.xserver.enable = true;
    



  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
    gnome-tweaks
    wget
    lshw
    nmap
    os-prober
    swaylock
    libGL
  ];
  programs.steam.enable = true;
  # Make sure fontconfig is enabled
  fonts.fontconfig.enable = true;

  # Add nerd-fonts.ubuntu-sans to your list of packages
  fonts.packages = with pkgs; [
    nerd-fonts.ubuntu-sans
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
  ];

  # Optionally, set it as your default monospace font
  fonts.fontconfig.defaultFonts.monospace = [
    "UbuntuSansMono Nerd Font"
  ];
  services = {
  tor = {
    enable = true;
    client.dns.enable = true;
    settings.DNSPort = [{
      addr = "127.0.0.1";
      port = 53;
    }];
  };
  resolved = {
    enable = true; # For caching DNS requests.
  };
};

networking.nameservers = [ "127.0.0.1" ];
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    # SSH is handled by ssh-agent + KWallet (see programs.ssh above).
    enableSSHSupport = false;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = false;

  # Open ports in the firewall.
  #  networking.firewall.allowedTCPPorts = [  ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  nixpkgs.config.allowUnfree = true;
  nix.settings.sandbox = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "26.05"; # Did you read the comment?

}
