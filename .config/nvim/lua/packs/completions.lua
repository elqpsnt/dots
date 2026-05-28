-- =============================================================================
--  [ COMPLETION FRAMEWORK REPOSITORY REGISTRY ]
-- =============================================================================
-- Native package registration handled directly by Neovim's built-in vim.pack system
vim.pack.add({
	{
		src = "https://github.com/saghen/blink.cmp",
		version = vim.version.range("^1"), -- Track major version updates automatically
	},
})

-- Lazy load on first insert mode entry
-- Create an isolated auto-command namespace container to prevent event duplication
local group = vim.api.nvim_create_augroup("BlinkCmpLazyLoad", { clear = true })

-- Intercept the editor lifecycle to defer engine loading until text typing actually begins
vim.api.nvim_create_autocmd("InsertEnter", {
	pattern = "*", -- Monitor all open file targets and buffers globally
	group = group,
	once = true,   -- Execute this configuration routine exactly once per session
	callback = function()
		-- Initialize the main autocomplete engine parameters inside active memory
		require("blink.cmp").setup({
			-- Apply pre-configured classic tab completion mapping behaviors
			keymap = { preset = "super-tab" },
			
			-- Tweak icon rendering adjustments matching system text specifications
			appearance = {
				nerd_font_variant = "mono",     -- Enforce consistent workspace icon alignments
				use_nvim_cmp_as_default = true, -- Inherit legacy nvim-cmp highlights structure
			},
			
			-- Configure text completion dropdown attributes
			completion = {
				-- Disable contextual helper document box previews from automatically appearing
				documentation = { auto_show = false },
			},
			
			-- Define look-up priority sequence parameters across active editing instances
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
			
			-- Optimization: Attempt compiled Rust core routines, warning on fallback to Lua
			fuzzy = { implementation = "prefer_rust_with_warning" },
		})
	end,
})
