{ pkgs, services, ... }:



{
  imports = [
     ./apps/nixvim.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "klock";
  home.homeDirectory = "/home/klock";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
      pkgs.gruvbox-gtk-theme pkgs.gruvbox-plus-icons
      pkgs.gnome.gnome-tweaks pkgs.gnomeExtensions.hibernate-status-button pkgs.gnomeExtensions.tray-icons-reloaded pkgs.gnomeExtensions.gsconnect pkgs.gnomeExtensions.blur-my-shell
      pkgs.pfetch pkgs.qbittorrent pkgs.nextcloud-client
      pkgs.tor-browser
      pkgs.mangohud
      pkgs.wineWowPackages.stable pkgs.winetricks pkgs.mono4
      pkgs.droidcam pkgs.obs-studio-plugins.droidcam-obs pkgs.obs-studio pkgs.telegram-desktop pkgs.element-desktop pkgs.syncthing
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/klock/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
     EDITOR = "nvim";
  };
  
  dconf.settings = {
    "org/gnome/mutter" = {
      experimental-features = [ "scale-monitor-framebuffer" ];
    };
  };

  programs.git = {
     enable = true;
     userName = "Abdulee";
     userEmail = "abdulee@disroot.org";
     extraConfig = {
         init.defaultBranch = "main";
     };
  };

  programs.zsh = {
     enable = true;
     shellAliases = {
        la = "ls -al";
	update = "sudo nixos-rebuild switch --flake /etc/nixos/#default";
     };
     initExtra = ''
           [[ ! -f ${/home/klock/.config/home-manager/.p10k.zsh} ]] || source ${/home/klock/.config/home-manager/.p10k.zsh}
     '';
     zplug = {
        enable = true;
        plugins = [
          { name = "zsh-users/zsh-autosuggestions"; } # Simple plugin installation
          { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; }
	  { name = "zsh-users/zsh-syntax-highlighting"; tags = [ defer:2 ]; }
        ];
     };
  };

  programs.alacritty = {
     enable = true; 
     settings = {
     	window.dimensions = {
           lines = 40;
	   columns = 120;
        };
	import = [
           "~/.config/alacritty/themes/themes/gruvbox_dark.toml"
	];
	font.normal = { family = "FiraCode Nerd Font"; style="Regular"; };
     };
  };


  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
