local opt = vim.opt
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

vim.g.mapleader = ' '
vim.g.maplocalleader = ';'


vim.wo.number = true
opt.relativenumber = true
opt.mouse = 'a'
opt.breakindent = true
opt.undofile = true

opt.conceallevel = 3
-- opt.signcolumn = 'yes'
opt.spelloptions:append('camel')

opt.undofile = true
opt.undolevels = 10000

opt.textwidth = 80     -- Text width maximum chars before wrapping
opt.tabstop = 2        -- The number of spaces a tab is
opt.shiftwidth = 2     -- Number of spaces to use in auto(indent)
opt.smarttab = true    -- Tab insert blanks according to 'shiftwidth'
opt.autoindent = true  -- Use same indenting on new lines
opt.smartindent = true -- Smart autoindenting on new lines
opt.shiftround = true  -- Round indent to multiple of 'shiftwidth'

opt.ignorecase = true  -- Search ignoring case
opt.smartcase = true   -- Keep case when searching with *

opt.termguicolors = true
opt.shortmess:append({ W = true, I = true, c = true })
opt.showmode = true   -- Don't show mode in cmd window
opt.scrolloff = 2     -- Keep at least 2 lines above/below
opt.sidescrolloff = 5 -- Keep at least 5 lines left/right
opt.numberwidth = 1   -- Minimum number of columns to use for the line number
opt.signcolumn = 'yes'

if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)


require("lazy").setup({
	{
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
		lazy = true,
	},
	{
		'nvim-treesitter/nvim-treesitter',
		opts = {
			function()
				return {
					ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "python", "javascript", "css", "html" },
					sync_install = false,
					auto_install = true,
					highlight = {
						enable = true,
						additional_vim_regex_highlighting = false,
					},
				}
			end
		}
	},
	{
		'williamboman/mason.nvim',
		dependencies = { 'neovim/nvim-lspconfig' },
		build = function()
			pcall(vim.cmd, 'MasonUpdate')
		end,
	},

	{
		'williamboman/mason-lspconfig.nvim',
		dependencies = { 'neovim/nvim-lspconfig' },
		opts = {}
	},            
	{ "neovim/nvim-lspconfig" },
	{ -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
  },
})

require("gruvbox").setup({
	undercurl = true,
	underline = true,
	bold = true,
	italic = {
		strings = false,
		comments = false,
		operators = false,
		folds = false,
	},
	strikethrough = true,
	invert_selection = false,
	invert_signs = false,
	invert_tabline = false,
	invert_intend_guides = false,
	inverse = false,  -- invert background for search, diffs, statuslines and errors
	contrast = "hard", -- can be "hard", "soft" or empty string
	palette_overrides = {
		dark0_hard = "#1E1E1E"
	},
	overrides = {},
	dim_inactive = false,
	transparent_mode = true
})


vim.cmd("colorscheme gruvbox")

-- local lsp = require('lsp-zero').preset({})
--
-- lsp.on_attach(function(client, bufnr)
-- 	lsp.default_keymaps({ buffer = bufnr })
-- end)
--
-- local lsp = require('lsp-zero').preset({})
-- require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

-- lsp.lua_ls.setup({})
local mason = require('mason').setup({})
local lspconfig = require('lspconfig')
lspconfig.lua_ls.setup({
	settings = {
		lua = {
			diagnostics = {
				global = { 'vim' }
			}
		}
	}
})
lspconfig.pyright.setup({})
lspconfig.tsserver.setup({})
-- lspconfig.autopep8.setup({})


-- nvim-cmp setup
local cmp = require 'cmp'
local luasnip = require 'luasnip'

luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}
