-- ╔══════════════════════════════════════════════════════════════╗
-- ║                  ⌨️  WHICH-KEY KEYMAP LAYER                 ║
-- ║     Interactive popup keybinding guide, prefix grouping,     ║
-- ║                 and automated menu expansion                 ║
-- ╚══════════════════════════════════════════════════════════════╝

-- Native package definitions managed directly by Neovim's built-in vim.pack system
vim.pack.add({
	"https://github.com/folke/which-key.nvim", -- Visual keymap prompter and registry utility
})

-- Initialize the keybinding popup engine interface
local wk = require("which-key")
wk.setup({
	preset = "helix", -- Match popup mechanics and window sizing to the Helix editor style
})

-- Register prefix descriptions, icons, auto-expansions, and custom code macros
wk.add({
	{ "<leader><tab>", group = "tabs" },
	{ "<leader>c", group = "code" },
	{ "<leader>d", group = "debug" },
	{ "<leader>D", group = "Diffview", icon = { icon = "", color = "orange" } },
	{ "<leader>p", group = "Yanky", icon = { icon = "󰃮 ", color = "yellow" } },
	{ "<leader>dp", group = "profiler" },
	{ "<leader>f", group = "file/find" },
	{ "<leader>g", group = "git" },
	{ "<leader>gh", group = "hunks" },
	{ "<leader>q", group = "quit/session" },
	{ "<leader>s", group = "search" },
	{ "<leader>u", group = "ui", icon = { icon = "󰙵 ", color = "cyan" } },
	{ "<leader>x", group = "diagnostics/quickfix", icon = { icon = "󱖫 ", color = "green" } },
	{ "[", group = "prev" },
	{ "]", group = "next" },
	{ "g", group = "goto" },
	{ "gs", group = "surround" },
	{ "z", group = "fold" },
	
	-- Dynamic Buffer Selection Expansion Menu
	{
		"<leader>b",
		group = "buffer",
		expand = function()
			-- Automatically populate the menu list with all active buffers in memory
			return require("which-key.extras").expand.buf()
		end,
	},
	
	-- Dynamic Window Operations Expansion Menu
	{
		"<leader>w",
		group = "windows",
		proxy = "<c-w>", -- Feed custom keys directly to native vim split window controls
		expand = function()
			-- Automatically populate menu items with window arrangement shortcuts
			return require("which-key.extras").expand.win()
		end,
	},
	
	-- Contextual application level keymap definitions
	{ "gx", desc = "Open with system app" },
	
	-- Clipboard File-Path Copy Sub-Menu Namespace Block
	{
		"<leader>fC",
		group = "Copy Path",
		{
			"<leader>fCf",
			function()
				vim.fn.setreg("+", vim.fn.expand("%:p")) -- Copy full file path to system clipboard
				vim.notify("Copied full file path: " .. vim.fn.expand("%:p"))
			end,
			desc = "Copy full file path",
		},
		{
			"<leader>fCn",
			function()
				vim.fn.setreg("+", vim.fn.expand("%:t")) -- Copy file name to system clipboard
				vim.notify("Copied file name: " .. vim.fn.expand("%:t"))
			end,
			desc = "Copy file name",
		},
		{
			"<leader>fCr",
			function()
				local cwd = vim.fn.getcwd() -- Current working directory absolute layout path
				local full_path = vim.fn.expand("%:p") -- Full active file absolute path
				local rel_path = full_path:sub(#cwd + 2) -- Strip the root workspace path prefix strings
				vim.fn.setreg("+", rel_path) -- Copy clean relative path string to system clipboard
				vim.notify("Copied relative file path: " .. rel_path)
			end,
			desc = "Copy relative file path",
		},
		{
			"<leader>?",
			function()
				-- Render an interactive prompt containing exclusively local buffer keymaps
				require("which-key").show({ global = false })
			end,
			desc = "Buffer Keymaps (which-key)",
		},
		{
			"<c-w><space>",
			function()
				-- Lock split-window adjustments into a repetitive looping hydra sub-state
				require("which-key").show({ keys = "<c-w>", loop = true })
			end,
			desc = "Window Hydra Mode (which-key)",
		},
	},
	
	-- Shared multi-mode structural shortcuts
	{
		mode = { "n", "v" }, -- Mirror command presence cleanly across both Normal and Visual spaces
		{ "<leader>W", "<cmd>w<cr>", desc = "Write" }, -- Save the current targeted buffer state changes
	},
})
