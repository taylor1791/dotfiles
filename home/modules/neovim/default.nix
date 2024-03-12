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

    home.packages = [ pkgs.jdt-language-server pkgs.kotlin-language-server ];

    programs.neovim = let
      vimPlugins = pkgs.vimPlugins;

      plugins = [
        { pkg = vimPlugins.vim-addon-local-vimrc; }
      ] ++ lib.lists.optionals cfg.development [
        {
          pkg = vimPlugins.ale;
          config = ''
            let g:ale_fix_on_save = v:true
          '';
        }

        { pkg = vimPlugins.cmp-calc; }
        { pkg = vimPlugins.cmp-nvim-lsp; }
        { pkg = vimPlugins.cmp-nvim-lsp-signature-help; }

        {
          pkg = vimPlugins.gitsigns-nvim;
          config = ''
            lua << EOF
              require('gitsigns').setup({
                on_attach = function(bufnr)
                  local gs = package.loaded.gitsigns

                  local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                  end

                  -- Navigation
                  map('n', ']c', function()
                    if vim.wo.diff then return ']c' end
                    vim.schedule(function() gs.next_hunk() end)
                    return '<Ignore>'
                  end, {expr=true})

                  map('n', '[c', function()
                    if vim.wo.diff then return '[c' end
                    vim.schedule(function() gs.prev_hunk() end)
                    return '<Ignore>'
                  end, {expr=true})

                  -- Actions
                  map('n', '<leader>hs', gs.stage_hunk)
                  map('n', '<leader>hr', gs.reset_hunk)
                  map('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
                  map('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
                  map('n', '<leader>hS', gs.stage_buffer)
                  map('n', '<leader>hu', gs.undo_stage_hunk)
                  map('n', '<leader>hR', gs.reset_buffer)
                  map('n', '<leader>hp', gs.preview_hunk)
                  map('n', '<leader>hb', function() gs.blame_line{full=true} end)
                  map('n', '<leader>tb', gs.toggle_current_line_blame)
                  map('n', '<leader>hd', gs.diffthis)
                  map('n', '<leader>hD', function() gs.diffthis('~') end)
                  map('n', '<leader>td', gs.toggle_deleted)

                  -- Text object
                  map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
                end
              })
            EOF
          '';
        }

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

                sorting = {
                  priority_weight = 2,
                  comparators = {
                    cmp.config.compare.sort_text,
                    cmp.config.compare.order,
                  },
                },

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
          pkg = vimPlugins.nvim-jdtls;
          config = ''
            lua << EOF
              local function setup_jdtls()
                local root_sentinel_files = {
                  "build.gradle",
                  "build.gradle.kts",
                  "gradlew",
                  "gradlew.bat",
                  "pom.xml",
                  ".git"
                }
                local java_cwd = vim.fs.dirname(vim.fs.find(root_sentinel_files, { upward = true })[1])
                local project_name = vim.fs.basename(java_cwd)
                local jdtls = require('jdtls')

                local capabilities = require("cmp_nvim_lsp").default_capabilities()
                capabilities.textDocument.completion.completionItem.snippetSupport = false

                jdtls.start_or_attach({
                  capabilities = capabilities,
                  root_dir = java_cwd,

                  cmd = {
                    "jdt-language-server",
                    "-data",
                    vim.env.HOME .. "/.cache/jdtls/" .. project_name,
                  },

                  settings = {
                    java = {
                      completion = {
                        maxResults = 128,
                      },
                    },
                  },
                })
              end

              vim.api.nvim_create_autocmd('FileType', {
                pattern = {'java'},
                callback = setup_jdtls,
              })
            EOF
          '';
        }

        {
          pkg = vimPlugins.nvim-lspconfig;
          config = ''
            lua << EOF
              -- Kotlin
              require('lspconfig').kotlin_language_server.setup({})

              vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                  local bufnr = args.buf

                  vim.keymap.set("n", "<leader>k", vim.lsp.buf.hover, { buffer = bufnr })
                  vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })
                  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr })
                  vim.keymap.set("n", "gT", vim.lsp.buf.type_definition, { buffer = bufnr })
                  vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next, { buffer = bufnr})
                  vim.keymap.set("n", "<leader>dN", vim.diagnostic.goto_prev, { buffer = bufnr})
                  vim.keymap.set("n", "<leader>af", vim.lsp.buf.format, { buffer = bufnr })
                  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr })
                  vim.keymap.set({"n", "v"}, "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr })
                end,
              })

              vim.api.nvim_create_autocmd("LspDetach", {
                callback = function(args)
                  local bufnr = args.buf

                  vim.keymap.del("n", "<leader>k", { buffer = bufnr })
                  vim.keymap.del("n", "gd", { buffer = bufnr })
                  vim.keymap.del("n", "gi", { buffer = bufnr })
                  vim.keymap.del("n", "gT", { buffer = bufnr })
                  vim.keymap.del("n", "<leader>dn", { buffer = bufnr })
                  vim.keymap.del("n", "<leader>dN", { buffer = bufnr })
                  vim.keymap.del("n", "<leader>af", { buffer = bufnr })
                  vim.keymap.del("n", "<leader>rn", { buffer = bufnr })
                  vim.keymap.del({"n", "v"}, "<leader>ca", { buffer = bufnr })
                end,
              })
            EOF
          '';
        }

        {
          pkg = vimPlugins.nvim-treesitter.withAllGrammars;
          config = ''
            lua << EOF
              require('nvim-treesitter.configs').setup({
                highlight = { enable = true, },
                indent = { enable = true, },

                textobjects = {
                  select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                      ["aa"] = { query = "@parameter.outer", desc = "outer arguments" },
                      ["ia"] = { query = "@parameter.inner", desc = "innter arguments" },
                      ["ac"] = { query = "@class.outer", desc = "outer class" },
                      ["ic"] = { query = "@class.inner", desc = "inner class" },
                      ["af"] = { query = "@function.outer", desc = "outer function" },
                      ["if"] = { query = "@function.inner", desc = "inner function" },
                      ["aj"] = { query = "@conditional.outer", desc = "outer conditional (judge)" },
                      ["ij"] = { query = "@conditional.inner", desc = "inner conditional (judge)" },
                      ["al"] = { query = "@loop.outer", desc = "outer loop" },
                      ["il"] = { query = "@loop.inner", desc = "inner loop" },
                    },

                    include_surronding_whitespace = true,
                  },
                },
              })
            EOF
          '';
        }

        { pkg = vimPlugins.nvim-treesitter-textobjects; }

        {
          pkg = vimPlugins.onedark-vim;
          config = ''
            set termguicolors " Enable 24-bit colors
            let g:onedark_terminal_italics=1 " A vow to use terminals supporting italics.
            colorscheme onedark
          '';
        }

        { pkg = vimPlugins.plenary-nvim; }

        { pkg = vimPlugins.telescope-fzf-native-nvim; }
        {
          pkg = vimPlugins.telescope-nvim;

          config = ''
            lua << EOF
              local telescope = require('telescope')

              telescope.load_extension('fzf')
              telescope.load_extension('undo')
              telescope.setup({})
            EOF

            nnoremap <leader>f :Telescope find_files<cr>
            nnoremap <leader>/ :Telescope live_grep<cr>
            nnoremap <leader>r :Telescope buffers<cr>
            nnoremap <leader>li :Telescope lsp_incoming_calls<cr>
            nnoremap <leader>lr :Telescope lsp_references<cr>
            nnoremap <leader>u :Telescope undo<cr>
            nnoremap <leader>dl :Telescope diagnostic<cr>
          '';
        }

        { pkg = vimPlugins.telescope-undo-nvim; }

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
        match errorMsg /\s\+$/                   " Highlight trailing whitespace
        set lazyredraw                           " Don't update the screen while running macros.
        set list listchars=trail:~,tab:>-,nbsp:␣ " Show tabs and trailing whitespace
        set nowrap                               " Do not wrap lines
        set number relativenumber                " Use relative line numbers, except the current line
        set pumheight=16                         " Maximum number of pop-up items
        set ruler                                " Show cursor position
        set scrolloff=7                          " Always show at least 7 lines around cursor
        set spell                                " Always enable spelling

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
      '' + "\n" + builtins.concatStringsSep "\n" pluginExtraConfig;
    };
  };
}
