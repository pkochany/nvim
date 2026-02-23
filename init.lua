---@meta
_G.vim = vim -- tell lua_ls that vim exists globally

-- turn off pearl provider
vim.g.loaded_perl_provider = 0

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
vim.o.completeopt = "menuone,noinsert,noselect"  -- show even if one result, do not insert automatically, do not select automatically
vim.o.pumheight = 12                             -- max height of popup menu

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
vim.keymap.set('n', '<leader>c', ":terminal<CR>")
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { noremap = true, silent = true })
vim.keymap.set('n', '<Tab>', ':bnext<CR>', { desc = "Next buffer" })
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', { desc = "Previous buffer" })
vim.keymap.set('i', '<C-Space>', vim.lsp.buf.signature_help, { desc = "Show signature" })
vim.keymap.set('i', '<C-x>', '<C-x><C-o>', { desc = "Trigger omni-completion" })
vim.keymap.set('i', '<C-f>', '<C-x><C-f>', { desc = "Trigger file completion" })
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true })
vim.keymap.set('t', '<leader>c', '<C-\\><C-n>:bd!<CR>', { desc = "Leave terminal" })

vim.pack.add({
	{ src = "https://github.com/vague-theme/vague.nvim" }, -- theme
	{ src = "https://github.com/stevearc/oil.nvim" },      -- file management
	{ src = "https://github.com/echasnovski/mini.pick" },  -- modal for fzf search
	{ src = "https://github.com/neovim/nvim-lspconfig" },  -- lsp server configs
	{ src = "https://github.com/hrsh7th/nvim-cmp" },       -- automatic omni-complete
    { src = "https://github.com/hrsh7th/cmp-nvim-lsp" },   -- automatic omni-complete
    { src = "https://github.com/b0o/schemastore.nvim" },   -- json schema
    { src = "https://github.com/jesseduffield/lazygit" },  -- git wrapper
	{ src = "https://github.com/akinsho/toggleterm.nvim" }, -- toggle multiple terminals during an editing session
	{ src = "https://github.com/mattn/emmet-vim" }, -- html css
	{ src = "https://github.com/roobert/tailwindcss-colorizer-cmp.nvim" },
	{ src = "https://github.com/Jezda1337/nvim-html-css" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/tpope/vim-surround" }
})

require("nvim-treesitter.config").setup({
  ensure_installed = {
    "html",
    "javascript",
    "typescript",
    "tsx",
    "css",
    "json",
  },
  sync_install = false,     -- async install (good choice)
  auto_install = true,      -- automatically install missing parsers when opening a file
})

require "html-css".setup({
  enable_on = { "html", "jsx", "tsx", "javascriptreact", "typescriptreact" },
  style_sheets = {
    -- PATHS WITH FILES TO INCLUDE IN AUTOCOMPLETE
    "./node_modules/bootstrap/dist/css/bootstrap.min.css",
  },
})

-- Enable Emmet for HTML, JSX, and CSS
vim.g.user_emmet_install_global = 0 -- disable global installation
vim.g.user_emmet_mode = "i"         -- activate in insert mode
vim.g.user_emmet_expandabbr_key = "<C-y>" -- key to expand abbreviation
vim.g.user_emmet_settings = {
    javascript = {
        extends = "html",
    },
    ["typescript.jsx"] = {
        extends = "html",
    },
}

require "toggleterm".setup({
  size = 20,
  open_mapping = [[<c-\>]],
  hide_numbers = true,
  shade_filetypes = {},
  shade_terminals = true,
  shading_factor = 2,
  start_in_insert = true,
  insert_mappings = true,
  persist_size = true,
  direction = "float",
  close_on_exit = true,
})
require "mini.pick".setup() -- turn on modal for fzf search
require "oil".setup()       -- turn on oil

-- LAZY GIT
local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({
  cmd = "lazygit",
  hidden = true,
  direction = "float",
})
vim.keymap.set("n", "<leader>g", function()
  lazygit:toggle()
end)

vim.lsp.enable({ "lua_ls", "eslint", "ts_ls", "pyright", "jsonls", "tailwindcss" }) -- turn on linters

vim.lsp.config('lspconfig', {})

vim.cmd("colorscheme vague")
vim.cmd(":hi statusline guibg=NONE")

-- Minimal nvim-cmp setup (auto-triggers on typing, LSP only)
local cmp = require("cmp")
cmp.setup({
  snippet = { expand = function() vim.notify("No snippets used", vim.log.levels.WARN) end },  -- Disable snippets
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),  -- Manual trigger if needed
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),  -- Enter to confirm
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
	-- Scroll popup menu by page
    ["<PageUp>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select, count = 12 })
        else
            fallback()
        end
    end, { "i", "s" }),
    ["<PageDown>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select, count = 12 })
        else
            fallback()
        end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },  -- Your Pyright/lua_ls completions
    { name = "buffer" },    -- Optional: from current buffer (add if you want)
	{ name = "emmet" },
	{ name = "html-css" },
  }),
  completion = {
    completeopt = "menu,menuone,noinsert,noselect",  -- Modern popup behavior
  },
  window = {
    completion = cmp.config.window.bordered(),  -- Optional: pretty border
    documentation = cmp.config.window.bordered(),
  },
})

-- Tell LSP to use cmp (add to your existing LspAttach callback)
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client:supports_method("textDocument/completion") then  -- ← Changed here: added colon
      vim.bo[args.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
      require("cmp_nvim_lsp").default_capabilities(client.server_capabilities)  -- If you added this from my last suggestion
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

-- JSON
vim.lsp.config("jsonls", {
    settings = {
        json = {
            validate = true,  -- enable built-in JSON validation
            schemas = {
                {
                    description = "package.json",
                    fileMatch = { "package.json" },
                    url = "https://json.schemastore.org/package.json",
                },
                {
                    description = "tsconfig.json",
                    fileMatch = { "tsconfig.json", "tsconfig.*.json" },
                    url = "https://json.schemastore.org/tsconfig.json",
                },
            },
        },
    },
})

