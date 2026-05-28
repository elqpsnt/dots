-- ╔══════════════════════════════════════════════════════════════╗
-- ║                  🌹  ROSÉ PINE COLORSCHEME                   ║
-- ║         Theme installation, variants, and custom overrides   ║
-- ╚══════════════════════════════════════════════════════════════╝

-- Register the official Rosé Pine repository inside the package manifest
vim.pack.add({
	{ src = "https://github.com/rose-pine/neovim" },
})

-- =============================================================================
--  [ Theme Profile Configuration & Overrides ]
-- =============================================================================
require("rose-pine").setup({
	-- -------------------------------------------------------------------------
	--  Font Styling Tolerances
	-- -------------------------------------------------------------------------
	styles = {
		bold         = false, -- Turn off bold face weights across syntax highlights
		italic       = true,  -- Use italic faces for comments, keywords, and hints
		transparency = true,  -- Strip default background fills to expose alpha transparency
	},

	-- -------------------------------------------------------------------------
	--  Granular Highlight Group Specifics
	-- -------------------------------------------------------------------------
	highlight_groups = {
		-- Inline parameter information layouts
		LspInlayHint = { bg = "base", fg = "muted", italic = true },

		-- Notification UI system components
		NotificationInfo    = { bg = "none", fg = "text" },
		NotificationWarning = { bg = "none", fg = "subtle" },
		NotificationError   = { bg = "none", fg = "love" },
	},
})

-- =============================================================================
--  [ Global Environment Theme Paint Execution ]
-- =============================================================================
vim.cmd("colorscheme rose-pine")
