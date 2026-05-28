-- ╔══════════════════════════════════════════════════════════════╗
-- ║                🌳  TREE-SITTER GRAMMAR LAYER                 ║
-- ║     Incremental AST parsing, structural semantic motions,     ║
-- ║                    and smart code folding                     ║
-- ╚══════════════════════════════════════════════════════════════╝

-- Native package definitions managed directly by Neovim's built-in vim.pack system
vim.pack.add({
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		version = "main", -- Target the active, modernized upstream rewrite branch
	},
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
		version = "main", -- Keep semantic textobjects synchronized on the main branch
	},
})

-- Initialize the modern Tree-sitter highlighting engine
require("nvim-treesitter").setup({})

-- Explicitly fetch, compile, and manage language-specific AST grammar binaries
require("nvim-treesitter").install({
	"bash",
	"blade",
	"c",
	"comment",
	"css",
	"diff",
	"dockerfile",
	"fish",
	"gitcommit",
	"gitignore",
	"go",
	"gomod",
	"gosum",
	"gowork",
	"html",
	"ini",
	"javascript",
	"jsdoc",
	"json",
	"lua",
	"luadoc",
	"luap",
	"make",
	"markdown",
	"markdown_inline",
	"nginx",
	"nix",
	"proto",
	"python",
	"query",
	"regex",
	"rust",
	"scss",
	"sql",
	"terraform",
	"toml",
	"tsx",
	"typescript",
	"vim",
	"vimdoc",
	"xml",
	"yaml",
	"zig",
})

-- Configure language-aware text objects selection and navigation rules
require("nvim-treesitter-textobjects").setup({
	select = {
		enable = true,
		lookahead = true, -- Automatically advance cursor forward to match target nodes
		selection_modes = {
			["@parameter.outer"] = "v", -- Visual characterwise mode for arguments/variables
			["@function.outer"] = "V",  -- Visual linewise mode for complete function blocks
			["@class.outer"] = "<c-v>", -- Visual blockwise mode for object/class scopes
		},
		include_surrounding_whitespace = false,
	},
	move = {
		enable = true,
		set_jumps = true, -- Log structural motions in the jump list for historical travel (Ctrl-O/I)
	},
})

-- -------------------------------------------------------------------------
--  [ SELECTION KEYMAP MATRIX: VISUAL STATE TARGETING ]
-- -------------------------------------------------------------------------
-- Instantiates operator-pending and visual mappings for fast structural block captures
local sel = require("nvim-treesitter-textobjects.select")
for _, map in ipairs({
	{ { "x", "o" }, "af", "@function.outer" },  -- Select [a]ll of a [f]unction block
	{ { "x", "o" }, "if", "@function.inner" },  -- Select [i]nside a [f]unction body
	{ { "x", "o" }, "ac", "@class.outer" },     -- Select [a]ll of a [c]lass structure
	{ { "x", "o" }, "ic", "@class.inner" },     -- Select [i]nside a [c]lass structure
	{ { "x", "o" }, "aa", "@parameter.outer" }, -- Select [a]ll of an [a]rgument variable
	{ { "x", "o" }, "ia", "@parameter.inner" }, -- Select [i]nside an [a]rgument variable
	{ { "x", "o" }, "ad", "@comment.outer" },   -- Select [a]ll of a [d]ocumentation comment block
	{ { "x", "o" }, "as", "@statement.outer" }, -- Select [a]ll of an expression [s]tatement block
}) do
	vim.keymap.set(map[1], map[2], function()
		sel.select_textobject(map[3], "textobjects")
	end, { desc = "Select " .. map[3] })
end

-- -------------------------------------------------------------------------
--  [ MOTION KEYMAP MATRIX: AST NODE NAVIGATION ]
-- -------------------------------------------------------------------------
-- Instantiates normal and structural navigation bindings to step smoothly over code blocks
local mv = require("nvim-treesitter-textobjects.move")
for _, map in ipairs({
	{ { "n", "x", "o" }, "]m", mv.goto_next_start, "@function.outer" },     -- Step to next function start
	{ { "n", "x", "o" }, "[m", mv.goto_previous_start, "@function.outer" }, -- Step to previous function start
	{ { "n", "x", "o" }, "]]", mv.goto_next_start, "@class.outer" },        -- Step to next class start
	{ { "n", "x", "o" }, "[[", mv.goto_previous_start, "@class.outer" },    -- Step to previous class start
	{ { "n", "x", "o" }, "]M", mv.goto_next_end, "@function.outer" },       -- Step to next function end
	{ { "n", "x", "o" }, "[M", mv.goto_previous_end, "@function.outer" },   -- Step to previous function end
	{ { "n", "x", "o" }, "]o", mv.goto_next_start, { "@loop.inner", "@loop.outer" } }, -- Step to next execution loop
	{ { "n", "x", "o" }, "[o", mv.goto_previous_start, { "@loop.inner", "@loop.outer" } }, -- Step to previous loop
}) do
	local modes, lhs, fn, query = map[1], map[2], map[3], map[4]
	local qstr = (type(query) == "table") and table.concat(query, ",") or query
	vim.keymap.set(modes, lhs, function()
		fn(query, "textobjects")
	end, { desc = "Move to " .. qstr })
end

-- Listens to native package framework signals to re-compile active grammars following updates
vim.api.nvim_create_autocmd("PackChanged", {
	desc = "Handle nvim-treesitter updates",
	group = vim.api.nvim_create_augroup("nvim-treesitter-pack-changed-update-handler", { clear = true }),
	callback = function(event)
		if event.data.kind == "update" then
			local ok = pcall(vim.cmd, "TSUpdate")
			if ok then
				vim.notify("TSUpdate completed successfully!", vim.log.levels.INFO)
			else
				vim.notify("TSUpdate command not available yet, skipping", vim.log.levels.WARN)
			end
		end
	end,
})

-- Exclusions lookup dictionary to skip running parser loops on UI or low-overhead screens
local SKIP_FT = {
	[""] = true,
	qf = true,
	help = true,
	man = true,
	noice = true,
	notify = true,
	snacks_notif = true,
	snacks_notif_history = true,
	snacks_picker_list = true,
	snacks_picker_input = true,
	snacks_input = true,
	snacks_terminal = true,
	dapui_scopes = true,
	dapui_breakpoints = true,
	dapui_stacks = true,
	dapui_watches = true,
	dapui_console = true,
	dap_repl = true,
	gitcommit = true,
	gitrebase = true,
	lazy = true,
	lspinfo = true,
	checkhealth = true,
	startuptime = true,
	TelescopePrompt = true,
	TelescopeResults = true,
	spectre_panel = true,
	["grug-far"] = true,
	trouble = true,
}

-- Initialize runtime syntax highlighters and link dynamic folding expressions
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "*" },
	callback = function()
		local ft = vim.bo.filetype
		if SKIP_FT[ft] then
			return
		end

		local ok = pcall(vim.treesitter.start)
		if not ok then
			return
		end

		-- Apply semantic tree expressions to drive editor code folding metrics safely
		vim.wo[0].foldmethod = "expr"
		vim.wo[0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
	end,
})

-- Intercept and redirect smart line indentation formatting to use parsed AST calculations
vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
