{pkgs, ...}:
{
   programs.tmux = {
      enable = true;
      terminal = "tmux-256color";
      baseIndex = 1;
      keyMode = "vi";
      plugins = with pkgs; 
      [
         tmuxPlugins.gruvbox
      ];
      extraConfig = ''
      set -g @tmux-gruvbox 'dark'
      '';
   };
}
