-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1
vim.g.mapleader = ' '
vim.opt.swapfile = false

vim.cmd("colorscheme nightfox")

require('nvim-web-devicons').setup{}
require('lualine').setup{}
require('copilot').setup{}
require("nvim-tree").setup({
  update_cwd = false,
  prefer_startup_root = true,
  sync_root_with_cwd = false,
  sort_by = "case_sensitive",
  actions = {
    open_file = {
      quit_on_open = true,
    },
    change_dir = {
      enable = false,
      global = false,
      restrict_above_cwd = true,
    },
  },
  view = {
    adaptive_size = true,
    mappings = {
      list = {
        { key = "u", action = "dir_up" },
      },
    },
  },
  renderer = {
    group_empty = true,
  },
})

require("which-key").setup()
local wk = require("which-key")

require("toggleterm").setup()

require('hop').setup()

wk.register({
  [" "] = { "<cmd>HopWord<cr>", "Hop Word" },
  ["h"] = {
    name = "Hop",
    w = { "<cmd>HopWord<cr>", "Word" },
    l = { "<cmd>HopLine<cr>", "Line" },
    p = { "<cmd>HopPattern<cr>", "Pattern" },
  },
  f = {
    name = "File",
    f = { "<cmd>Telescope find_files<cr>", "Find File" },
    b = { "<cmd>Telescope buffers<cr>", "Buffers" },
    n = { "<cmd>enew<cr>", "New File" },
    r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
    t = { "<cmd>Telescope treesitter<cr>", "treesitter" },
  },
  s = {
    name = "Search",
    l = { "<cmd>Telescope live_grep<cr>", "Live Grep" },
    w = { function()
      local cursor_word = vim.fn.expand("<cword>")
      vim.cmd("Telescope grep_string search=" .. cursor_word)
    end, "Word" },
    f = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Current Buffer" },
  },
  y = {
    name = "Yank",
    y = { "<cmd>FZFNeoyank<cr>", "Search yanks" },
    y = { "<cmd>FZFNeoyankSelection<cr>", "", mode = "v" },
  },
  g = {
    name = "Git",
    l = { "<cmd>LazyGit<CR>", "Lazygit" },
  },
  b = {
    name = "Buffer",
    o = { "<cmd>BufferLineCloseLeft<cr><cmd>BufferLineCloseRight<cr>", "Close Other Buffers" },
    c = { "<cmd>BufferLinePickClose<cr>", "Pick Close Buffer" },
    r = { "<cmd>BufferLineCloseRight<cr>", "Close Buffers Right" },
    l = { "<cmd>BufferLineCloseLeft<cr>", "Close Buffers Left" },
  },
  l = {
    name = "LSP",
    r = { "<cmd>Telescope lsp_references<cr>",	"Lists LSP references for word under the cursor" },
    d = { "<cmd>Telescope lsp_document_symbols<cr>",	"Lists LSP document symbols in the current buffer" },
    w = { "<cmd>Telescope lsp_workspace_symbols<cr>",	"Lists LSP document symbols in the current workspace" },
    c = { "<cmd>Telescope lsp_code_actions<cr>",	"Lists any LSP actions for the word under the cursor, that can be triggered with <cr>" },
    C = { "<cmd>Telescope lsp_range_code_actions<cr>",	"Lists any LSP actions for a given range, that can be triggered with <cr>" },
    D = { "<cmd>Telescope diagnostics<cr>",	"Lists Diagnostics for all open buffers or a specific buffer. Use option bufnr=0 for current buffer." },
    i = { "<cmd>Telescope lsp_implementations<cr>",	"Goto the implementation of the word under the cursor if there's only one, otherwise show all options in Telescope" },
    d = { "<cmd>Telescope lsp_definitions<cr>",	"Goto the definition of the word under the cursor, if there's only one, otherwise show all options in Telescope" },
    t = { "<cmd>Telescope lsp_type_definitions<cr>",	"Goto the definition of the type of the word under the cursor, if there's only one, otherwise show all options in Telescope" },
    o = { "<cmd>AerialToggle!<CR>", "Display code outline" },
  },
}, { prefix = "<leader>" })
