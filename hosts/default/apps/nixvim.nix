{ inputs, lib, config,  ... }: {
   imports = [
      inputs.nixvim.homeManagerModules.nixvim
   ];
   programs.nixvim = {
      enable = true;
      colorschemes.gruvbox.enable = true;
      colorschemes.gruvbox.settings.true_color = true;

      clipboard = {
         register = "unnamedplus";
         providers.wl-copy.enable = true;
      };
      opts = {
         number = true;
         relativenumber = true;
         tabstop = 3;
         shiftwidth = 3;
         softtabstop = 3;
         expandtab = true;
         termguicolors = true;
      };

      plugins = {
         lightline.enable = true;
         lightline.colorscheme = "jellybeans";
         treesitter.enable = true;
         telescope.enable = true;
#         coq-nvim = {
#            enable = true;
#            settings.auto_start = "shut-up";
#            installArtifacts = true;
#         };
         neo-tree = {
            enable = true;
            closeIfLastWindow = true;
         };
         nvim-autopairs.enable = true;
         lsp = {
            enable = true;
            servers = {
               ccls.enable = true;
               hls.enable = true;
               pylsp.enable = true;
               texlab.enable = true;
               ltex = {
                  enable = true;
                  settings.language = "es";
               };
               nil_ls.enable = true; #nix LSP
               html.enable = true;
               cssls.enable = true;
            };
         };
         ts-autotag = {
            enable = true;
            filetypes = ["html" "xml" "javascript" "typescript"];
         };
      };

      globals = {
         mapleader = " ";
         maplocalleader = " ";
      };
      keymaps = let
         normal =
         lib.mapAttrsToList
         (key: action: {
          mode = "n";
          inherit action key;
          })
      {
         "<leader>f" = ":Telescope find_files<CR>";
         "<leader>tt" = ":Neotree<CR>";
         "<leader>jt" = ":split<CR>:wincmd j<CR><C-W>10-<CR>:terminal<CR>"; #gives me a nice terminal split
      };
      in
         config.nixvim.helpers.keymaps.mkKeymaps
         {options.silent = true;}
      (normal);
   };
}
