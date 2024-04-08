-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

--- LSP, linters and formatters
-- reload "user.lsp"

local formatter = require("lvim.lsp.null-ls.formatters")

formatter.setup({
	{
		name = "prettier",
		args = { "--line-width", "100" },
	},
	{
		name = "stylua",
	},
})

-- code folding treesitter folds
vim.cmd("set foldmethod=expr")
vim.cmd("set foldexpr=nvim_treesitter#foldexpr()")
vim.cmd("set nofoldenable")
vim.opt.scrolloff = 8
lvim.transparent_window = false

local tab_length = 4
vim.opt.tabstop = tab_length
vim.opt.softtabstop = tab_length
vim.opt.shiftwidth = tab_length
vim.opt.expandtab = true

lvim.builtin.nvimtree.setup.view.side = "right"
lvim.builtin.project.manual_mode = true

------------------------------------------------------- Illuminate
-- https://ansidev.xyz/posts/2023-04-25-how-to-change-the-highlight-style-using-vim-illuminate
-- Illuminate highlight word instead of underline
lvim.builtin.illuminate.active = true
lvim.builtin.illuminate.options.delay = 50
vim.api.nvim_set_hl(0, "IlluminatedWordText", { link = "Visual" })
vim.api.nvim_set_hl(0, "IlluminatedWordRead", { link = "Visual" })
vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { link = "Visual" })
--- auto update the highlight style on colorscheme change
vim.api.nvim_create_autocmd({ "ColorScheme" }, {
	pattern = { "*" },
	callback = function(_)
		vim.api.nvim_set_hl(0, "IlluminatedWordText", { link = "Visual" })
		vim.api.nvim_set_hl(0, "IlluminatedWordRead", { link = "Visual" })
		vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { link = "Visual" })
	end,
})

vim.diagnostic.config({
	virtual_text = {
		prefix = "●",
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "E",
			[vim.diagnostic.severity.WARN] = "W",
			[vim.diagnostic.severity.HINT] = "H",
			[vim.diagnostic.severity.INFO] = "I",
		},
		linehl = {
			[vim.diagnostic.severity.ERROR] = "ErrorMsg",
		},
		numhl = {
			[vim.diagnostic.severity.WARN] = "WarningMsg",
		},
	},
})

lvim.icons.diagnostics = {
	BoldError = "E",
	Error = "E",
	BoldWarning = "W",
	Warning = "W",
	BoldInformation = "I",
	Information = "I",
	BoldQuestion = "Q",
	Question = "Q",
	BoldHint = "H",
	Hint = "H",
	Debug = "D",
	Trace = "✎",
}

-- -- https://github.com/LunarVim/LunarVim/discussions/3830
vim.api.nvim_set_keymap(
	"n",
	"<Leader>t",
	"<Cmd>lua vim.diagnostic.open_float(nil, {focus=false})<CR>",
	{ noremap = true, silent = true }
)

lvim.builtin.lualine.sections.lualine_c = {
	"diff",
	function()
		return require("lsp-progress").progress()
	end,
}
lvim.builtin.lualine.options.icons_enabled = false
------------------------------------------------------- Illuminate

-- Primeagen: highlight the yanked text
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup("HighlightYank", {})
autocmd("TextYankPost", {
	group = yank_group,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 40,
		})
	end,
})

----------------------------------------------- colorscheme
-- vim.g.tundra_biome = 'arctic' -- arctic or jungle
vim.opt.background = "dark"
lvim.colorscheme = "noirbuddy"
----------------------------------------------- colorscheme

------------------------------- lsp progress
vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
vim.api.nvim_create_autocmd("User", {
	group = "lualine_augroup",
	pattern = "LspProgressStatusUpdated",
	callback = require("lualine").refresh,
})
------------------------------- lsp progress

-------------------------------------- trouble
lvim.builtin.which_key.mappings["t"] = {
	name = "Diagnostics",
	t = { "<cmd>TroubleToggle<cr>", "trouble" },
	w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "workspace" },
	d = { "<cmd>TroubleToggle document_diagnostics<cr>", "document" },
	q = { "<cmd>TroubleToggle quickfix<cr>", "quickfix" },
	l = { "<cmd>TroubleToggle loclist<cr>", "loclist" },
	r = { "<cmd>TroubleToggle lsp_references<cr>", "references" },
}

-------------------------------------- trouble

---------------------------------------------------- Plugins
lvim.plugins = {
	{
		"kdheepak/monochrome.nvim",
		lazy = false,
	},
	{
		"sam4llis/nvim-tundra",
		lazy = false,
	},
	{
		"jesseleite/nvim-noirbuddy",
		dependencies = {
			{ "tjdevries/colorbuddy.nvim" },
		},
		lazy = false,
		priority = 1000,
		opts = {
			-- All of your `setup(opts)` will go here
		},
	},
	{
		"ray-x/lsp_signature.nvim",
		event = "VeryLazy",
		opts = {
			hint_enable = false,
		},
		config = function(_, opts)
			require("lsp_signature").setup(opts)
		end,
	},
	{
		lazy = true,
		"linrongbin16/lsp-progress.nvim",
		config = function()
			require("lsp-progress").setup()
		end,
	},
	{
		"ahmedkhalf/lsp-rooter.nvim",
		event = "BufRead",
		config = function()
			require("lsp-rooter").setup()
		end,
	},
	{
		"folke/trouble.nvim",
		cmd = "TroubleToggle",
	},
}
---------------------------------------------------- Plugins
