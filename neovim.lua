-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1
vim.g.mapleader = ' '
vim.g.vim_markdown_folding_disabled = 1

vim.opt.swapfile = false
vim.wo.number = true
vim.cmd[[set tabstop=4]]
vim.cmd[[set shiftwidth=4]]
vim.cmd[[set expandtab]]
vim.cmd[[let &showbreak = '↪ ']]
vim.cmd[[set wrap]]

local undodir = '~/.config/nvim/undo'
if vim.fn.isdirectory(undodir) == 0 then
    vim.fn.mkdir(undodir, 'p')
end
vim.g.undodir = undodir

vim.g.bookmark_sign = '🎗️'
vim.g.bookmark_highlight_lines = true
vim.g.bookmark_no_default_key_mappings = true

vim.cmd[[
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>
function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction
]]

require('mini.comment').setup()
require('mini.misc').setup()
require('mini.basics').setup()
require('mini.indentscope').setup()
require('mini.move').setup({
    mappings = {
        -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
        left = '<C-h>',
        right = '<C-l>',
        down = '<C-j>',
        up = '<C-k>',
    }
})
require('mini.starter').setup()
require('mini.map').setup()
MiniMap.open()

require('telescope').setup {
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    }
  }
}
require('telescope').load_extension('fzf')

require'nvim-treesitter.configs'.setup {
	highligh = {
		enable = true,
	},
	indent = {
		enable = true,
	},
	incremental_selection = {
		enable = true,
	},
}
local lspconfig = require('lspconfig')
lspconfig.elmls.setup {}
vim.cmd('colorscheme tokyonight-day')
vim.cmd [[
augroup fmt
  autocmd!
  autocmd BufWritePre * Neoformat
augroup END
]]
require('gitsigns').setup{
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
}
require('nvim-web-devicons').setup{}
require('lualine').setup {
  options = {
    theme = 'tokyonight'
  }
}
require("bufferline").setup{}
require('copilot').setup{
	suggestion = {
		auto_trigger = true,
		keymap = {
			accept = "<tab>",
		},
	}
}
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
  ["g"] = { "<cmd>LazyGit<CR>", "Lazygit" },
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
  b = {
     name = "Bookmarks",
     b = { "<cmd>Telescope vim_bookmarks all<cr>", "all bookmarks" },
     c = { "<cmd>Telescope vim_bookmarks current_file<cr>", "current file" },

     t = { "<cmd>BookmarkToggle<cr>", "toggle" },
     a = { "<cmd>BookmarkAnnotate<cr>", "annotate" },
     n = { "<cmd>BookmarkNext<cr>", "next" },
     p = { "<cmd>BookmarkPrev<cr>", "prev" },
     c = { "<cmd>BookmarkClear<cr>", "clear" },
     x = { "<cmd>BookmarkClearAll<cr>", "clear all" },
     k = { "<cmd>BookmarkMoveUp<cr>", "move up" },
     j = { "<cmd>BookmarkMoveDown<cr>", "move down" },
     l = { "<cmd>BookmarkMoveToLine<cr>", "move to line" },
     },
}, { prefix = "<leader>" })
