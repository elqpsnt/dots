-- ╔══════════════════════════════════════════════════════════════╗
-- ║                   🩺  DIAGNOSTIC SETUP                       ║
-- ║     In-line error highlighting, signs, and keymappings       ║
-- ╚══════════════════════════════════════════════════════════════╝

local map = vim.keymap.set
local sev = vim.diagnostic.severity

-- =============================================================================
--  [ Color Palette & Custom Highlights ]
-- =============================================================================
-- Hex codes for full-line diagnostic backgrounds
local palette = {
	err  = "#51202A", -- Soft muted red for errors
	warn = "#3B3B1B", -- Soft muted amber/yellow for warnings
	info = "#1F3342", -- Soft muted blue for informational entries
	hint = "#1E2E1E", -- Soft muted green for contextual code hints
}

-- Apply custom background colors with a subtle transparency blend
vim.api.nvim_set_hl(0, "DiagnosticErrorLine", { bg = palette.err, blend = 20 })
vim.api.nvim_set_hl(0, "DiagnosticWarnLine",  { bg = palette.warn, blend = 15 })
vim.api.nvim_set_hl(0, "DiagnosticInfoLine",  { bg = palette.info, blend = 10 })
vim.api.nvim_set_hl(0, "DiagnosticHintLine",  { bg = palette.hint, blend = 10 })

-- Configure the custom visual sign for Debug Adapter Protocol (DAP) breakpoints
vim.api.nvim_set_hl(0, "DapBreakpointSign", { fg = "#FF0000", bg = nil, bold = true })
vim.fn.sign_define("DapBreakpoint", {
	text     = "●",                  -- Large solid dot icon in the gutter
	texthl   = "DapBreakpointSign", -- Highlight group matching the red text color
	linehl   = "",                  -- Do not color the entire active line background
	numhl    = "",                  -- Do not color the line numbers column
})

-- =============================================================================
--  [ Core Diagnostic Configuration ]
-- =============================================================================
vim.diagnostic.config({
	underline     = true,  -- Underline problem text fragments
	severity_sort = true,  -- Sort errors above warnings in lists for quick scanning
	update_in_insert = false, -- Defer linting updates until exiting Insert mode (prevents UI flicker)

	-- Floating window properties for popup diagnostic cards
	float = {
		border = "rounded", -- Rounded frame matching global window styles
		source = true,      -- Append the tool source (e.g., lua_ls, pyright) to message
	},

	-- Custom icon indicators for the sign column gutter
	signs = {
		text = {
			[sev.ERROR] = " ",
			[sev.WARN]  = " ",
			[sev.INFO]  = " ",
			[sev.HINT]  = "󰌵 ",
		},
	},

	-- Text string rendering at the end of problematic code lines
	virtual_text = {
		spacing = 4,         -- Gap columns between line text and virtual text start
		source  = "if_many", -- Only print server names if multiple diagnostic engines output errors
		prefix  = "●",        -- Custom glyph leading the diagnostic notice string
	},

	-- Full line text highlighting configurations
	linehl = {
		[sev.ERROR] = "DiagnosticErrorLine", -- Apply the custom dark red background to error lines
	},
})

-- =============================================================================
--  [ Interactive Keymappings ]
-- =============================================================================
-- Helper closure to wrap targeted jumping through diagnostic items
local diagnostic_goto = function(next, severity)
	severity = severity and vim.diagnostic.severity[severity] or nil
	return function()
		-- Neovim 0.11+ clean jumping structure passing target count directions
		vim.diagnostic.jump({ count = next and 1 or -1, float = true, severity = severity })
	end
end

-- Keymaps mapping floating previews and filtered cycling jumps
map("n", "<leader>cd", vim.diagnostic.open_float,      { desc = "Line Diagnostics" })
map("n", "]d",         diagnostic_goto(true),          { desc = "Next Diagnostic" })
map("n", "[d",         diagnostic_goto(false),         { desc = "Prev Diagnostic" })
map("n", "]e",         diagnostic_goto(true, "ERROR"),  { desc = "Next Error" })
map("n", "[e",         diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
map("n", "]w",         diagnostic_goto(true, "WARN"),   { desc = "Next Warning" })
map("n", "[w",         diagnostic_goto(false, "WARN"),  { desc = "Prev Warning" })
