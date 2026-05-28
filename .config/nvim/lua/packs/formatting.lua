-- ╔══════════════════════════════════════════════════════════════╗
-- ║                  🦀 CONFORM.NVIM CONFIGURATION               ║
-- ║     Ultra-performant linting and automated layout styling    ║
-- ║               engines powered by oxlint & oxfmt              ║
-- ╚══════════════════════════════════════════════════════════════╝

-- Declare core plugin dependencies via native package manager layout
vim.pack.add({
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/windwp/nvim-ts-autotag" },
})

local conform = require("conform")

conform.setup({
	-- =============================================================================
	--  [ Global Component Toggles & Subsystem Adjustments ]
	-- =============================================================================
	format_on_save = {
		timeout_ms = 3000, -- Maximum sync execution wait time window
		lsp_format = "fallback", -- Use LSP formatters if local binaries are missing
	},

	-- =============================================================================
	--  [ Dedicated Formatters Mapping By File Type ]
	-- =============================================================================
	formatters_by_ft = {
		lua = { "stylua" },
		-- Oxlint handles code mutation actions, oxfmt takes care of structural layouts
		javascript = { "oxlint", "oxfmt" },
		javascriptreact = { "oxlint", "oxfmt" },
		typescript = { "oxlint", "oxfmt" },
		typescriptreact = { "oxlint", "oxfmt" },
		graphql = { "oxfmt" },
		go = { "goimports", "gofmt" },
		json = { "oxfmt" },
		sql = { "sql_formatter" },
	},

	-- =============================================================================
	--  [ Specialized Tool Parameters Overrides ]
	-- =============================================================================
	formatters = {
		sql_formatter = {
			prepend_args = { "--language", "postgresql" },
		},
		-- Fix the Oxlint pipeline to handle stdin streaming changes safely
		oxlint = {
			args = { "--fix", "--stdin-filename", "$FILENAME" },
			stdin = true,
			exit_codes = { 0, 1 }, -- Suppress noisy error prompts on lint warnings
		},
	},
})

-- Initialize supplementary structural typing markup tag behaviors
require("nvim-ts-autotag").setup()

-- =============================================================================
--  [ Interactive Mappings Lookup Dictionary ]
-- =============================================================================
-- stylua: ignore start
local keymaps = {
	{ 
		"<leader>mp", 
		function() 
			conform.format({ lsp_format = "fallback", async = false, timeout_ms = 500 }) 
		end, 
		desc = "Format file or range", 
		mode = { "n", "v" } 
	},
}
-- stylua: ignore end

-- =============================================================================
--  [ Keymap Compiler Loop ]
-- =============================================================================
-- Process and loop the keymaps dictionary to programmatically bind them to core APIs
for _, map in ipairs(keymaps) do
	local opts = { desc = map.desc }

	if map.silent ~= nil then
		opts.silent = map.silent
	end
	if map.expr ~= nil then
		opts.expr = map.expr
	end
	if map.noremap ~= nil then
		opts.noremap = map.noremap
	else
		opts.noremap = true
	end

	local mode = map.mode or "n"
	vim.keymap.set(mode, map[1], map[2], opts)
end
