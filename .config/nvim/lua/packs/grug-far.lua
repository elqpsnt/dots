-- =============================================================================
--  [ MULTI-FILE SEARCH & REPLACE PACKAGE REGISTRY ]
-- =============================================================================
-- Native package registration for grug-far (Global Search and Replace utility)
vim.pack.add({
	"https://github.com/MagicDuck/grug-far.nvim",
})

-- =============================================================================
--  [ GRUG-FAR ENGINE CONFIGURATION ]
-- =============================================================================
-- Initialize core plugin settings and visual workspace preferences
require("grug-far").setup({
	-- Prevent ASCII headers from stretching out or breaking smaller split windows
	headerMaxWidth = 80,
})

-- =============================================================================
--  [ INTERACTIVE KEYMAP DEFINITIONS ]
-- =============================================================================
-- Bind search-and-replace controls across Normal, Visual, and Visual-Block modes
vim.keymap.set({ "n", "v", "x" }, "<leader>sr", function()
	local grug = require("grug-far")
	
	-- Context Intelligence: Scrape file extension of active buffer if it's a real file
	local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
	
	-- Open the interactive dynamic search panel canvas
	grug.open({
		-- Transient: Completely wipe the search panel buffer from history when closed
		transient = true,
		prefills = {
			-- Smart Filter: Pre-populate file extension filter (e.g., '*.lua', '*.rs') 
			-- based on your active file, ignoring special windows like terminal or explorer
			filesFilter = ext and ext ~= "" and "*." .. ext or nil,
		},
	})
end, { desc = "Search and Replace" })
