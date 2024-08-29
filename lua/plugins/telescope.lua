local Plugin = { "nvim-telescope/telescope.nvim" }
Plugin.cmd = { "Telescope" }
Plugin.branch = "0.1.x"
Plugin.dependencies = {
  { "nvim-lua/plenary.nvim" },
  { "nvim-telescope/telescope-fzf-native.nvim",     build = "make" },
  { "kdheepak/lazygit.nvim" },
  { "nvim-telescope/telescope-live-grep-args.nvim", version = "^1.1", },
  {
    "BurntSushi/ripgrep",
    build = function()
      local job = vim.fn.jobstart(
        { "brew", "install", "ripgrep" }
      )
    end,
  },
  { "nvim-telescope/telescope-ui-select.nvim" },
  { "nvimtools/hydra.nvim" },
}

Plugin.init = function()
  vim.api.nvim_create_autocmd("BufEnter", {
    group = vim.api.nvim_create_augroup("telescope-file-browser.nvim", { clear = true }),
    pattern = "*",
    callback = function()
      vim.schedule(function()
        local netrw_bufname, _
        if vim.bo[0].filetype == "netrw" then return end
        local bufname = vim.api.nvim_buf_get_name(0)
        if vim.fn.isdirectory(bufname) == 0 then
          _, netrw_bufname = pcall(vim.fn.expand, "#:p:h")
          return
        end

        -- prevents reopening of file-browser if exiting without selecting a file
        if netrw_bufname == bufname then
          netrw_bufname = nil
          return
        else
          netrw_bufname = bufname
        end
        vim.bo[0].bufhidden = "wipe"
        require("telescope").extensions.file_browser.file_browser({
          cwd = vim.fn.expand("%:p:h"),
        })
      end)
    end,
    once = true,
    desc = "lazy-loaded telescope-file-browser.nvimw",
  })
  -- require("user.keymaps").telescope()
  Plugin.hydra()
end

Plugin.config = function()
  local actions = require("telescope.actions")
  local tele = require("telescope")
  local lga_actions = require("telescope-live-grep-args.actions")
  tele.setup({
    defaults = {
      path_display = { "smart" },
      layout_strategy = "flex",
      layout_config = {
        prompt_position = "top",
      },
      mapping = {
        i = {
          ["<C-k>"] = lga_actions.quote_prompt(),
          ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
          ["<C-h>"] = "which_key",
        },
      },
    },
    pickers = {
      find_files = {
      }
    },
    extensions = {
      ["ui-select"] = {
        require("telescope.themes").get_dropdown({}),
      },
      -- ...
      fzf = {
        fuzzy = true,                   -- false will only do exact matching
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true,    -- override the file sorter
        case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
        -- the default case_mode is "smart_case"
      }
    },
  })
  tele.load_extension("fzf")
  tele.load_extension("lazygit")
  tele.load_extension("live_grep_args")
  tele.load_extension("ui-select")
end
Plugin.lazy = false
Plugin.hydra = function()
  local Hydra = require("hydra")
  local cmd = require("hydra.keymap-util").cmd

  local hint = [[
                 _f_: files       _m_: marks
   🭇🬭🬭🬭🬭🬭🬭🬭🬭🬼    _o_: old files   _g_: live grep
  🭉🭁🭠🭘    🭣🭕🭌🬾   _p_: projects    _/_: search in file
  🭅█ ▁     █🭐
  ██🬿      🭊██   _r_: resume      _u_: undotree
 🭋█🬝🮄🮄🮄🮄🮄🮄🮄🮄🬆█🭀  _h_: vim help    _c_: execute command
 🭤🭒🬺🬹🬱🬭🬭🬭🬭🬵🬹🬹🭝🭙  _k_: keymaps     _;_: commands history
                 _O_: options     _?_: search history
 ^
                 _<Enter>_: Telescope           _<Esc>_
]]

  Hydra({
    name = "Telescope",
    hint = hint,
    config = {
      color = "teal",
      invoke_on_body = true,
      hint = {
        position = "middle",
        float_opts = {
          style = "minimal",
        },
      },
    },
    mode = "n",
    body = "<C-p>",
    heads = {
      { "f",       cmd "Telescope find_files" },
      -- { "g",       cmd "Telescope live_grep" },
      { "g",       require("telescope").extensions.live_grep_args.live_grep_args },
      { "o",       cmd "Telescope oldfiles",                  { desc = "recently opened files" } },
      { "h",       cmd "Telescope help_tags",                 { desc = "vim help" } },
      { "m",       cmd "MarksListBuf",                        { desc = "marks" } },
      { "k",       cmd "Telescope keymaps" },
      { "O",       cmd "Telescope vim_options" },
      { "r",       cmd "Telescope resume" },
      { "p",       cmd "Telescope projects",                  { desc = "projects" } },
      { "/",       cmd "Telescope current_buffer_fuzzy_find", { desc = "search in file" } },
      { "?",       cmd "Telescope search_history",            { desc = "search history" } },
      { ";",       cmd "Telescope command_history",           { desc = "command-line history" } },
      { "c",       cmd "Telescope commands",                  { desc = "execute command" } },
      { "u",       cmd "silent! %foldopen! | UndotreeToggle", { desc = "undotree" } },
      { "M",       cmd "Telescope man_pages",                 { desc = "man pages" } },
      { "K",       cmd "Telescope quickfix",                  { desc = "quickfix" } },
      { "<Enter>", cmd "Telescope",                           { exit = true, desc = "list all pickers" } },
      { "<Esc>",   nil,                                       { exit = true, nowait = true } },
    }
  })
end

return Plugin
