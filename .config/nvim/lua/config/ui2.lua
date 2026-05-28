-- ╔═════════════════════════════════════════════════════════════════════╗
-- ║                  🖥️  UI2 ARCHITECTURE                               ║
-- ║     Native message, command-line, and pager subsystem configuration ║
-- ╚═════════════════════════════════════════════════════════════════════╝

-- Native Neovim 0.12+ message/cmdline engine redesign.
-- This subsystems transforms the legacy paging output into fully standard, 
-- interactive buffers and windows for improved scrollback and lookups.
require("vim._core.ui2").enable({
	enable = true,

	-- =============================================================================
	--  [ Core Message Routing Modules ]
	-- =============================================================================
	msg = {
		---@type 'cmd'|'msg' Default stream intercept rendering zone
		---@type string|table<string, 'cmd'|'msg'|'pager'> Layout dictionary mapping explicit kinds
		targets = "cmd",

		-- -------------------------------------------------------------------------
		--  Viewport Layout Geometry Settings
		-- -------------------------------------------------------------------------
		-- Expanded size tolerances configured when text strings exceed raw 'cmdheight' bounds
		cmd = {
			height = 0.5,
		},

		-- Interactive structural popup confirmations and text warning cards
		dialog = {
			height = 0.5,
		},

		-- Short-lived notification toasts rendered in separate ephemeral layout viewports
		msg = {
			height = 0.5,
			timeout = 4000, -- Duration threshold (ms) an isolated alert entry remains on display
		},

		-- Full window buffer scrollback engines processing intense multi-line outputs
		pager = {
			height = 1,
		},
	},
})
