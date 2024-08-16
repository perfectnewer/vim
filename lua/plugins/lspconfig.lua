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
  },
  { "jay-babu/mason-nvim-dap.nvim" },
  { "mfussenegger/nvim-dap" },
  { "mfussenegger/nvim-dap-python" },
  { "rcarriga/nvim-dap-ui" },
}

Plugin.cmd = { 'LspInfo', 'LspInstall', 'LspUnInstall' }
-- Plugin.event = { 'BufReadPre *.py|*.pyi|*.lua|*.go|*.gomod|*.sh|*.md',
--   'BufNewFile *.py|*.pyi|*.lua|*.go|*.gomod|*.sh|*.md' }
Plugin.ft = { 'python', 'lua', 'go', 'bash', 'markdown', 'vim', 'ts', 'js', 'html', 'gomo' }

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
      buffers = {
        match_syms = true
      }
    },
    keymap = {
      recommended = false,
      jump_to_mark = '<c-f>',
    }
  }

	vim.lsp.set_log_level('warn')
end

function Plugin.config()
  require('mason').setup({ ui = { border = 'single' } })
  require("mason-nvim-dap").setup({
    ensure_installed = { "python", "delve" },
    handlers = {
      function(config)
        -- all sources with no handler get passed here

        -- Keep original functionality
        require('mason-nvim-dap').default_setup(config)
      end,
      python = function(config)
        config.adapters = {
          type = "executable",
          command = "/home/simon/.pyenv/versions/neovim3/bin/python",
          args = {
            "-m",
            "debugpy.adapter",
          },
        }
        require('mason-nvim-dap').default_setup(config) -- don't forget this!
      end,
    },
  })
  -- See :help mason-lspconfig-settings
  -- https://github.com/williamboman/mason-lspconfig.nvim
  require('mason-lspconfig').setup({
    ensure_installed = {
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

  local cmp = require('cmp')
  local cmp_select = { behavior = cmp.SelectBehavior.Select }
  cmp.setup({
    mapping = {
      ['<CR>'] = cmp.mapping.confirm({ select = false }),
      ['<s-tab>'] = cmp.mapping.select_prev_item(cmp_select),
      ['<tab>'] = cmp.mapping.select_next_item(cmp_select),
    }
  })
  local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
  local lspconfig = require('lspconfig')
  local default_opts = require('coq').lsp_ensure_capabilities({
    capabilities = lsp_capabilities,
    on_attach = user.on_attach,
  })

	local handlers = {
		-- See :help mason-lspconfig-dynamic-server-setup
		function(server)
			-- See :help lspconfig-setup
			lspconfig[server].setup(default_opts)
		end,
		['lua_ls'] = function()
			local opts = vim.tbl_extend("force", default_opts, require('plugins.lsp.lua_ls').setup())
			lspconfig.lua_ls.setup(opts)
		end,
		['pyright'] = function()
			local pyrightpath = vim.fn.system({ "pyenv", "prefix", "neovim3" })
			local pyrightcmd = { pyrightpath:gsub("\n", "") .. "/bin/pyright-langserver", "--stdio" }
			local opts = {
				on_init = function(client)
					client.config.settings.python.pythonPath = user.get_python_path(client.config.root_dir)
          user.set_dap_pypath(client.config.root_dir)
				end,
				cmd = pyrightcmd,
			}
			lspconfig.pyright.setup(vim.tbl_deep_extend("force", default_opts, opts))
		end,
		['gopls'] = function()
			local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol
				.make_client_capabilities())
			require('go').setup({
				-- other setups ....
				lsp_cfg = {
					capabilities = capabilities,
					-- other setups
				},
				lsp_on_attach = user.on_attach,
			})
			require('dap').set_log_level('TRACE')
		end
	}
	require('mason-lspconfig').setup_handlers(handlers)

	local saga = require('lspsaga').setup({
		-- your configuration
	})
	-- only show above warnings
	-- lsp_capabilities.textDocument.publishDiagnostics.tagSupport.valueSet = { 2 }

	-- require("navigator").setup({ mason = true, })

	--        local opts = { noremap = true, silent = true }
	--        vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
	--
	vim.keymap.set('n', '<Leader>ot', '<cmd>Lspsaga open_floaterm zsh<CR>', { silent = true })
	vim.keymap.set('t', '<Leader>ot', '<C-\\><C-n><cmd>Lspsaga close_floaterm<CR>', { silent = true })
	vim.keymap.set('n', '<Leader>ol', '<cmd>Lspsaga outline <CR>', { silent = true })
	vim.o.signcolumn = "yes"
end

function user.on_attach(client, bufnr)
	require('navigator.lspclient.mapping').setup({ client = client, bufnr = bufnr }) -- setup navigator keymaps here,
	require("navigator.dochighlight").documentHighlight(bufnr)
	require('navigator.codeAction').code_action_prompt(bufnr)

	vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

	local bufmap = function(mode, lhs, rhs, desc)
		local opts = { noremap = true, silent = true, buffer = bufnr, desc = desc }
		vim.keymap.set(mode, lhs, rhs, opts)
	end

	local ft = vim.bo.filetype
	if ft == 'go' then
		local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
		vim.api.nvim_create_autocmd("BufWritePre", {
			-- 3
			-- pattern = "*.go",
			buffer = bufnr,
			callback = function()
				-- 4 + 5
				vim.lsp.buf.format({ async = false, id = client })
			end,
			group = format_sync_grp,
		})
	end

	-- You can search each function in the help page.
	-- For example :help vim.lsp.buf.hover()

	bufmap('n', 'K', '<cmd>Lspsaga hover_doc<CR>', 'Hover documentation')
	bufmap('n', 'gd', vim.lsp.buf.definition, 'Go to definition')
	bufmap('n', 'gD', vim.lsp.buf.declaration, 'Go to declaration')
	bufmap('n', 'gi', vim.lsp.buf.implementation, 'Go to implementation')
	bufmap('n', 'go', vim.lsp.buf.type_definition, 'Go to type definition')
	bufmap('n', 'gr', vim.lsp.buf.references, 'Go to reference')
	bufmap('n', 'gs', '<cmd>Lspsaga signature_help<CR>', 'Show function signature')
	bufmap('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', 'Rename symbol')
	bufmap({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', 'Format buffer')
	bufmap('n', '<LocalLeader>ca', '<cmd>Lspsaga code_action<cr>', 'Execute code action')
	bufmap('n', 'gl', vim.diagnostic.open_float, 'Show line diagnostic')
	bufmap('n', '[d', '<cmd>Lspsaga diagnostic_jump_next<CR>', 'Previous diagnostic')
	bufmap('n', ']d', '<cmd>Lspsaga diagnostic_jump_prev<CR>', 'Next diagnostic')
	-- Enable completion triggered by <c-x><c-o>
	-- vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format({async = false})]]
	--
	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	-- vim.keymap.set('n', 'gt', '<cmd>tab split | lua vim.lsp.buf.definition()<CR>', bufopts)
	-- vim.keymap.set('n', 'gs', '<cmd>split | lua vim.lsp.buf.definition()<CR>', bufopts)
	-- vim.keymap.set('n', 'ge', '<cmd>vsplit | lua vim.lsp.buf.definition()<CR>', bufopts)
	-- vim.keymap.set('n', 'gr', '<cmd>Lspsaga rename<CR>', bufopts)
	-- -- Definition preview
	-- vim.keymap.set('n', 'Kd', '<cmd>Lspsaga preview_definition<CR>', bufopts)
	--
	-- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
	-- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
	-- vim.keymap.set('n', '<space>wl', function()
	--   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	-- end, bufopts)
	-- vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
	-- vim.keymap.set('n', 'gr', , bufopts)
	-- vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
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

-- https://miguelcrespo.co/posts/how-to-debug-like-a-pro-using-neovim/
function user.set_dap_pypath(workspace)
  require('dap-python').setup("/home/simon/.pyenv/versions/neovim3/bin/python") -- earlier so setup the various defaults ready to be replaced
  require("dapui").setup()
  require('dap.ext.vscode').load_launchjs(nil, {})
  local dap, dapui = require("dap"), require("dapui")
  -- Open automatically when a new debug session is created
  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
  end
  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
  end
  vim.keymap.set('n', '<F5>', require 'dap'.continue)
  vim.keymap.set('n', '<F10>', require 'dap'.step_over)
  vim.keymap.set('n', '<F11>', require 'dap'.step_into)
  vim.keymap.set('n', '<F12>', require 'dap'.step_out)
  vim.keymap.set('n', '<leader>b', require 'dap'.toggle_breakpoint)
  local pypath = user.get_python_path(workspace)
  -- local dap = require("dap")
  -- dap.adapters.python = {
  --     type = 'executable',
  --     command = pypath,
  --     args = {'-m', 'debugpy.adapter'}
  -- }
  -- dap.configurations.python = {
  --     {
  --         type = 'python';
  --         request = 'launch';
  --         name = "Launch file";
  --         program = "${file}";
  --         pythonPath = pypath,
  --     },
  --     {
  --         type = 'python',
  --         request = 'launch',
  --         name = 'DAP Django',
  --         program = vim.loop.cwd() .. '/manage.py',
  --         args = {'runserver', '--noreload'},
  --         justMyCode = true,
  --         django = true,
  --         console = "integratedTerminal",
  --     },
  --     {
  --         type = 'python';
  --         request = 'attach';
  --         name = 'Attach remote';
  --         connect = function()
  --             return {
  --                 host = '127.0.0.1',
  --                 port = 5678
  --             }
  --         end;
  --     },
  --     {
  --         type = 'python';
  --         request = 'launch';
  --         name = 'Launch file with arguments';
  --         program = '${file}';
  --         args = function()
  --             local args_string = vim.fn.input('Arguments: ')
  --             return vim.split(args_string, " +")
  --         end;
  --         console = "integratedTerminal",
  --         pythonPath = pypath,
  --     }
  -- }
end

return Plugin
