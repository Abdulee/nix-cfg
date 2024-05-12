# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan. ./hardware-configuration.nix
    ./hardware-configuration.nix
    ];

  # Bootloader.
boot = { loader.systemd-boot.enable = false;
  lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };
};
nixpkgs.hostPlatform = "x86_64-linux";

# suspend to RAM (deep) rather than `s2idle`
boot.kernelParams = [ "mem_sleep_default=deep" ];
boot.kernelModules = [ "v4l2loopback" ];
boot.extraModulePackages = [ pkgs.linuxPackages.v4l2loopback ];
# suspend-then-hibernate
systemd.sleep.extraConfig = ''
   HibernateDelaySec=30m
   SuspendState=mem
'';



  boot.bootspec.enable = true;
#  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-6058c605-85d9-47bb-b776-a9c67d3a0fe5".device = "/dev/disk/by-uuid/6058c605-85d9-47bb-b776-a9c67d3a0fe5";
  networking.hostName = "orlux"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Madrid";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_ES.UTF-8";
    LC_IDENTIFICATION = "es_ES.UTF-8";
    LC_MEASUREMENT = "es_ES.UTF-8";
    LC_MONETARY = "es_ES.UTF-8";
    LC_NAME = "es_ES.UTF-8";
    LC_NUMERIC = "es_ES.UTF-8";
    LC_PAPER = "es_ES.UTF-8";
    LC_TELEPHONE = "es_ES.UTF-8";
    LC_TIME = "es_ES.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "es";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "es";

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [ hplip hplipWithPlugin ];
  services.avahi = {
  enable = true;
  nssmdns4 = true;
  openFirewall = true;
};

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  services.flatpak.enable = true;
  powerManagement.enable = true;
  services.thermald.enable = true;
  powerManagement.powertop.enable = true;
  services.tailscale.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  programs.zsh.enable = true;
  users.users.klock = {
    isNormalUser = true;
    description = "klock";
    extraGroups = [ "networkmanager" "wheel" "wireshark"];
    shell = pkgs.zsh;
    packages = with pkgs; [
      #obsidian
      neofetch
      tailscale
      android-tools
      alacritty
      ghc haskellPackages.QuickCheck python3
      librewolf brave chromium thunderbird
      neovim fira-code-nerdfont
      xournalpp
      flatpak gnome.gnome-software
      keepassxc
      htop
      libreoffice texliveFull
      mpv
      lutris discord
      distrobox podman wireshark
      ventoy
      cowsay
      kdenlive
      ghostscript_headless
    ];
  };
programs.kdeconnect.enable = true;
programs.wireshark.enable = true;

home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "klock" = import ./home.nix;
    };
  };

#  services.syncthing = {
#     enable = true;

#     overrideFolders = false;
#     overrideDevices = false;

#     settings = {
#        devices = {
#	   "kaktus" = {id = "2QDXEW5-FIYTHPS-5HOQKYU-6B7JJF2-LYNV6XL-DXY77TV-6QGC7OS-HUHWSQP";};
#	};
#	folders = {
#	   "Notes" = {
#	     path = "/home/klock/Documents/Notes";
#	     devices = [ "kaktus" ];
#	   };
#	};
#     };
#  };


#Mounting my NFS Share
  fileSystems."/home/klock/share" = {
    device = "192.168.1.66:/mnt/mainStorage/shared";
    fsType = "nfs";
    options = [
    "x-systemd.mount-timeout=10"
    "timeo=100"
    "rw"
    "hard"
    "intr"
    "nfsvers=4"
    "sec=sys"
    ];
  };


# enabling virtualisation
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     wget
     git
     sbctl niv
     gnat13 gdb ddd
     nfs-utils iperf nmap inetutils
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
  nix.gc.automatic = true; #auto garbage clearing old system snapshots every monday 00:00
  nix.gc.dates = "weekly";

}
