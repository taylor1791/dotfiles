{ config, lib, pkgs, ... }: let
  programName = "neovim";
  cfg = config.taylor1791.programs.${programName};
in {
  options.taylor1791.programs.${programName} = {
    enable = lib.mkEnableOption "Enable taylor1791's neovim configuration";

    ai = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Enable AI features.";
    };

    development = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Enable features for writing software.";
    };
  };

  config = let
    snipsDir = "${config.xdg.configHome}/nvim/UltiSnips";
  in lib.mkIf cfg.enable {
    home.file."${snipsDir}" = {
      source = ./UltiSnips;
      recursive = true;
    };

    programs.neovim = let
      vimPlugins = pkgs.vimPlugins;

      plugins = [
        # Languages
        { pkg = vimPlugins.kotlin-vim; }
        { pkg = vimPlugins.vader-vim; }
        { pkg = vimPlugins.vim-nix; }
        { pkg = vimPlugins.yats-vim; }

        # Tools
        { pkg = vimPlugins.vim-addon-local-vimrc; }
      ] ++ lib.lists.optionals cfg.development [
        {
          pkg = vimPlugins.ale;
          config = ''
            let g:ale_fix_on_save = v:true
            nmap <leader>ah <esc>:ALEHover<cr>
            nmap <leader>an <esc>:ALENext<cr>
            nmap <leader>ad <esc>:ALEDetail<cr>
            nmap <leader>aN <esc>:ALEPrevious<cr>
          '';
        }

        { pkg = vimPlugins.cmp-calc; }
        { pkg = vimPlugins.cmp-nvim-lsp; }
        { pkg = vimPlugins.cmp-nvim-lsp-signature-help; }

        {
          pkg = vimPlugins.nvim-cmp;
          config = ''
            lua << EOF
              local cmp = require('cmp')

              cmp.setup({
                mapping = cmp.mapping.preset.insert({
                  ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                  ['<C-f>'] = cmp.mapping.scroll_docs(4),
                }),

                sources = cmp.config.sources({
                  { name = 'calc' },
                  { name = 'nvim_lsp_signature_help' },
                  { name = 'nvim_lsp' },
                }),
              })
            EOF
          '';
        }

        {
          pkg = vimPlugins.nvim-lspconfig;
          config = ''
            nnoremap gd :lua vim.lsp.buf.definition()<cr>
            nnoremap gy :lua vim.lsp.buf.type_definition()<cr>
            nnoremap <leader>la :lua vim.lsp.buf.code_action()<cr>
            vnoremap <leader>la :lua vim.lsp.buf.code_action()<cr>
            nnoremap <leader>lh :lua vim.lsp.buf.hover()<cr>
          '';
        }

        {
          pkg = vimPlugins.onedark-vim;
          config = ''
            set termguicolors " Enable 24-bit colors
            let g:onedark_terminal_italics=1 " A vow to use terminals supporting italics.
            colorscheme onedark
          '';
        }

        { pkg = vimPlugins.plenary-nvim; }
        { pkg = pkgs.taylor1791.skim; }
        {
          pkg = pkgs.taylor1791.skim-vim;
          config = ''
            nnoremap <leader>f <esc>:Files!<cr>
            nnoremap <leader>/ <esc>:Rg<cr>
          '';
        }

        {
          pkg = vimPlugins.typescript-tools-nvim;
          config = ''
            lua << EOF
              require('typescript-tools').setup({
                settings = {
                  expose_as_code_action = "all",

                  jsx_close_tag = {
                    enable = false,
                    filetypes = { "javascriptreact", "typescriptreact" },
                  },
                },
              })
            EOF
          '';
        }

        {
          pkg = vimPlugins.ultisnips;
          config = ''
            let g:UltiSnipsEditSplit='vertical'
            let g:UltiSnipsExpandTrigger='<C-Space>'
            let g:UltiSnipsSnippetDirectories = ['${snipsDir}']
          '';
        }

        { pkg = vimPlugins.vim-fugitive; }

        {
          pkg = vimPlugins.vim-hexokinase;
          config = ''
            let g:Hexokinase_ftEnabled = ['css', 'html', 'javascript']
          '';
        }

        {
          pkg = vimPlugins.vim-test;
          config = ''
            nnoremap <leader>T <esc>:TestFile<cr>
          '';
        }
      ] ++ lib.lists.optionals cfg.ai [
        {
          pkg = vimPlugins.copilot-vim;
          config = ''
            inoremap <silent><script><expr> <C-j> copilot#Accept("")
            let g:copilot_no_tab_map = v:true
          '';
        }
      ];

      pluginsWithExtraConfig = builtins.filter (builtins.hasAttr "config") plugins;

      pluginExtraConfig = builtins.map
        ({ config, pkg }: "\" ${pkg.name}\n${config}")
        pluginsWithExtraConfig;
    in {
      enable = true;
      defaultEditor = true;
      extraPackages = [];
      plugins = builtins.map (plugin: plugin.pkg) plugins;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      extraConfig = ''
        " Since <leader> is called upon by many plugin/*, elect the true leader early.
        let mapleader = "\<space>"

        " Command Mode Options
        set wildmode=longest,list,full " When completion matching

        " Search Options
        set incsearch          " Show "live" matches
        set ignorecase         " Case insensitive matching
        set hlsearch           " Highlight matches
        set smartcase          " Respect case when using a capital letter
        set inccommand=nosplit " Live preview of :substitute

        " Display Options
        set lazyredraw            " Don't update the screen while running macros.
        set list listchars=tab:>- " Display tabs using
        set nowrap                " Do not wrap lines
        set number relativenumber " Use relative line numbers, except the current line
        set pumheight=16          " Maximum number of pop-up items
        set ruler                 " Show cursor position
        set scrolloff=7           " Always show at least 7 lines around cursor
        set spell                 " Always enable spelling
        set synmaxcol=256         " Last column to syntax highlight

        " Indentation Options
        set expandtab     " Convert <TAB> to spaces
        set tabstop=4     " Make real tabs fill 4 columns
        set shiftwidth=2  " Number of spaces for each auto-indent step
        set shiftround    " When using > and <, stop at shiftwidths.

        " Editing Options
        set autoread                   " Autoload changed files if safe
        set backspace=indent,eol,start " Backspace over these characters too
        set formatoptions+=n           " Recognize numbered lists when formatting text
        set formatoptions+=r           " Insert comment leader automatically
        set fileformat=unix            " Regardless of platform, use unix EOL
        set fileformats=unix,dos,mac   " Regardless of platform, use these
        set nojoinspaces               " Use 1 space after punctuation when joining
        set textwidth=88               " Black found that 88 produces significantly shorter
                                       " lines than 80 characters
        " Integration Options
        set belloff=
        set clipboard=unnamed,unnamedplus
        set mouse=a

        " Restore the cursors previous position. See :help last-position-jump
        autocmd BufReadPost *
          \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
          \ |   exe "normal! g`\""
          \ | endif

        " Vim Temporary File Options
        if exists('$SUDO_USER')
          " Avoid creating files owned by root.
          set nobackup nowritebackup
          set noswapfile
          set noundofile
          set shada="NONE"
        else
          set backup " Save a backup before writing to a file.
          set backupdir=~/.local/share/nvim/backup
          set undofile " Save undo to disk
          set swapfile " Enable recovery/locking - I forget all the open terminals
        endif

        " Mappings
        nnoremap <esc> :nohlsearch<cr>
        nnoremap <leader>s <esc>:source %<cr>
        nnoremap Q <nop>
        nnoremap / /\v
        nnoremap ? ?\v

        " Display the token under the cursor. Useful for debugging syntax highlighting.
        function ShowToken()
          echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . ">"
            \ " trans<" . synIDattr(synID(line("."),col("."),0),"name") . ">"
            \ " lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"
        endfunction
      '' + "\n" + builtins.concatStringsSep "\n" pluginExtraConfig;
    };
  };
}
