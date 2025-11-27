---@meta
_G.vim = vim -- tell lua_ls that vim exists globally

vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = false
vim.o.tabstop = 4
vim.o.swapfile = false
vim.o.signcolumn = "yes"
vim.o.winborder = "rounded"
vim.g.mapleader = " "
vim.diagnostic.config({
	virtual_text = false,
	signs = true,
	underline = true,
	update_in_insert = false,
})
vim.o.completeopt = "menuone,noinsert,noselect"
vim.o.pumheight = 12                     -- max height of popup menu

vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>o', ':update<CR> :source<CR>')
vim.keymap.set('n', '<leader>w', ':write<CR>')
vim.keymap.set('n', '<leader>q', ':bdelete<CR>')
vim.keymap.set('n', '<leader>ff', vim.lsp.buf.format)
vim.keymap.set('n', '<leader>t', ":Pick files<CR>")
vim.keymap.set('n', '<leader>r', ":Pick grep_live<CR>")
vim.keymap.set('n', '<leader>e', ":Oil<CR>")
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { noremap = true, silent = true })
vim.keymap.set('i', '<C-Space>', vim.lsp.buf.signature_help, { desc = "Show signature" })
vim.keymap.set('i', '<C-x>', '<C-x><C-o>', { desc = "Trigger omni-completion" })
vim.keymap.set('i', '<C-f>', '<C-x><C-f>', { desc = "Trigger file completion" })

vim.pack.add({
	{ src = "https://github.com/vague-theme/vague.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/echasnovski/mini.pick" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
})

require "mini.pick".setup()
require "oil".setup()

vim.lsp.enable({ "lua_ls", "eslint", "ts_ls", "pyright"})

vim.cmd("colorscheme vague")
vim.cmd(":hi statusline guibg=NONE")

vim.o.omnifunc = "v:lua.vim.lsp.omnifunc" -- omni-complete on any keypress
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.supports_method("textDocument/completion") then
      vim.bo[args.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
    end
  end,
})

-- The single most important option for Python/Django
vim.lsp.config('pyright', {
  -- Server-specific settings. See `:help lsp-quickstart`
  settings = {
    python = {
      analysis = {
        -- This is the magic switch that makes Pyright show parameter names
        autoImportCompletions = true,
        -- This makes it suggest parameter names while you type inside (…)
        inlayHints = {
          functionLikeParameterNames = true,   -- ← shows max_length= while typing
          variableTypes = true,
        },
      },
    },
  },
})


