local Plugin = { 'neovim/nvim-lspconfig' }
local user = {}

Plugin.tag = 'v0.1.8'
Plugin.dependencies = {
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'williamboman/mason.nvim' },
  { 'williamboman/mason-lspconfig.nvim' },
  {
    'nvimdev/lspsaga.nvim',
    branch = 'main',
    dependencies = {
      -- { 'neovim/nvim-lspconfig', tag = 'v0.1.8' },
      { 'ms-jpq/coq_nvim',       branch = 'coq' },
      { 'ms-jpq/coq.artifacts',  branch = 'artifacts' },
      { 'ms-jpq/coq.thirdparty', branch = '3p' },
    },
  },
  "ray-x/navigator.lua",
  requires = {
    { "ray-x/guihua.lua",               run = "cd lua/fzy && make" },
    { "neovim/nvim-lspconfig" },
    { "nvim-treesitter/nvim-treesitter" },
  }
}

Plugin.cmd = { 'LspInfo', 'LspInstall', 'LspUnInstall' }
Plugin.event = { 'BufReadPre', 'BufNewFile' }
Plugin.ft = { 'python', 'lua', 'go', 'bash', 'markdown' }

function Plugin.init()
  -- See :help vim.diagnostic.config()
  vim.diagnostic.config({
    virtual_text = true,
    severity_sort = false,
    float = {
      border = 'rounded',
      source = true,
    },
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = '✘',
        [vim.diagnostic.severity.WARN] = '▲',
        [vim.diagnostic.severity.HINT] = '⚑',
        [vim.diagnostic.severity.INFO] = '»',
      },
    },
  })

  vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
    vim.lsp.handlers.hover,
    { border = 'rounded' }
  )

  vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
    vim.lsp.handlers.signature_help,
    { border = 'rounded' }
  )

  -- for coq
  vim.g.coq_settings = {
    auto_start = true,
    clients = {
      lsp = {
        resolve_timeout = 0.2,
        weight_adjust = 1,
      },
    },
    display = {
      icons = {
        mode = 'none'
      }
    },
    keymap = {
      jump_to_mark = 'c-n'
    }
  }

  vim.lsp.set_log_level('debug')
end

function Plugin.config()
  local lspconfig = require('lspconfig')
  local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
  -- only show above warnings
  -- lsp_capabilities.textDocument.publishDiagnostics.tagSupport.valueSet = { 2 }

  require('mason').setup({ ui = { border = 'single' } })
  require("navigator").setup({ mason = true, })



  local group = vim.api.nvim_create_augroup('lsp_cmds', { clear = true })

  vim.api.nvim_create_autocmd('LspAttach', {
    group = group,
    desc = 'LSP actions',
    callback = user.on_attach
  })

  -- See :help mason-lspconfig-settings
  require('mason-lspconfig').setup({
    handlers = {
      -- See :help mason-lspconfig-dynamic-server-setup
      function(server)
        -- See :help lspconfig-setup
        lspconfig[server].setup({
          capabilities = lsp_capabilities,
        })
      end,
      ['lua_ls'] = function()
        -- if you install the language server for lua it will
        -- load the config from lua/plugins/lsp/lua_ls.lua
        require('plugins.lsp.lua_ls')
      end,
      rust_analyzer = function() require('rust-tools').setup() end,
      ['pyright'] = function()
        --        local pyrightpath = vim.fn.system({"pyenv", "prefix", "neovim3"})
        --        local pyrightcmd = {pyrightpath:gsub("\n", "") .. "/bin/pyright-langserver", "--stdio"}
        --
        require('coq').lsp_ensure_capabilities({
          capabilities = lsp_capabilities,
          on_attach = user.on_attach,
          on_init = function(client)
            client.config.settings.python.pythonPath = user.get_python_path(client.config.root_dir)
          end,
          --          cmd = pyrightcmd,
        })
      end,
    },
    ensure_installed = {
      -- https://github.com/williamboman/mason-lspconfig.nvim
      'gopls',
      'lua_ls',
      'marksman',
      'vimls',
      'pyright',
      'rust_analyzer',
      'bashls',
      'yamlls',
    },
  })

  --        local opts = { noremap = true, silent = true }
  --        vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
  --        -- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  --        -- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
  --        vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
  --        local saga = require('lspsaga')
  --        saga.setup({
  --          -- your configuration
  --        })
  --
  --        vim.keymap.set('n', '<Leader>ot', '<cmd>Lspsaga open_floaterm zsh<CR>', { silent = true })
  --        vim.keymap.set('t', '<Leader>ot', '<C-\\><C-n><cmd>Lspsaga close_floaterm<CR>', { silent = true })
  --
  --        vim.keymap.set('n', '<Leader>ol', '<cmd>Lspsaga outline <CR>', { silent = true })
  --        vim.keymap.set('n', ']d', '<cmd>Lspsaga diagnostic_jump_next<CR>', { silent = true })
  --        vim.keymap.set('n', '[d', '<cmd>Lspsaga diagnostic_jump_prev<CR>', { silent = true })
end

function user.on_attach(event)
  print(vim.inspect(event))
  local bufmap = function(mode, lhs, rhs, desc)
    local opts = { buffer = event.buf, desc = desc }
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  -- You can search each function in the help page.
  -- For example :help vim.lsp.buf.hover()

  bufmap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', 'Hover documentation')
  bufmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', 'Go to definition')
  bufmap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', 'Go to declaration')
  bufmap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', 'Go to implementation')
  bufmap('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', 'Go to type definition')
  bufmap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', 'Go to reference')
  bufmap('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', 'Show function signature')
  bufmap('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', 'Rename symbol')
  bufmap({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', 'Format buffer')
  bufmap('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', 'Execute code action')
  bufmap('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>', 'Show line diagnostic')
  bufmap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>', 'Previous diagnostic')
  bufmap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>', 'Next diagnostic')
  --          -- Enable completion triggered by <c-x><c-o>
  --          vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format({async = false})]]
  --          vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  --
  --          -- Mappings.
  --          -- See `:help vim.lsp.*` for documentation on any of the below functions
  --          local bufopts = { noremap = true, silent = true, buffer = bufnr }
  --          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  --          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  --          vim.keymap.set('n', 'gt', '<cmd>tab split | lua vim.lsp.buf.definition()<CR>', bufopts)
  --          vim.keymap.set('n', 'gs', '<cmd>split | lua vim.lsp.buf.definition()<CR>', bufopts)
  --          vim.keymap.set('n', 'ge', '<cmd>vsplit | lua vim.lsp.buf.definition()<CR>', bufopts)
  --          -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  --
  --          vim.keymap.set('n', 'K', '<cmd>Lspsaga hover_doc<CR>', bufopts)
  --          vim.keymap.set('n', 'Ks', '<Cmd>Lspsaga signature_help<CR>', bufopts)
  --          -- Rename
  --          vim.keymap.set('n', 'gr', '<cmd>Lspsaga rename<CR>', bufopts)
  --          -- Definition preview
  --          vim.keymap.set('n', 'Kd', '<cmd>Lspsaga preview_definition<CR>', bufopts)
  --
  --          -- vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  --          -- vim.keymap.set('n', 'gk', vim.lsp.buf.signature_help, bufopts)
  --          vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  --          vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  --          vim.keymap.set('n', '<space>wl', function()
  --            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  --          end, bufopts)
  --          -- vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  --          vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  --          vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  --          vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  --          vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)

  require('navigator.lspclient.mapping').setup({ client = event.client, bufnr = event.buf }) -- setup navigator keymaps here,
  require("navigator.dochighlight").documentHighlight(event.buf)
  require('navigator.codeAction').code_action_prompt(event.buf)
end

function user.get_python_path(workspace)
  local path = require('lspconfig/util').path
  -- Use activated virtualenv.
  if vim.env.VIRTUAL_ENV then
    return path.join(vim.env.VIRTUAL_ENV, 'bin', 'python')
  end

  -- Find and use virtualenv from pipenv in workspace directory.
  local match = vim.fn.glob(path.join(workspace, 'Pipfile'))
  if match ~= '' then
    local venv = vim.fn.trim(vim.fn.system('PIPENV_PIPFILE=' .. match .. ' pipenv --venv'))
    return path.join(venv, 'bin', 'python')
  end

  -- Fallback to system Python.
  return vim.fn.exepath('python3') or vim.fn.exepath('python') or 'python'
end

return Plugin
