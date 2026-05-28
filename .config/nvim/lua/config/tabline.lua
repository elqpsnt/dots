-- ╔══════════════════════════════════════════════════════════════╗
-- ║                      🔖 TABLINE SETUP                        ║
-- ║   Custom buffer-line tracker with smart invalidation caching ║
-- ╚══════════════════════════════════════════════════════════════╝

local M = {}

local SEP = "" -- Separator glyph at buffer boundary bounds
local CLOSE = "" -- Close icon shown exclusively on the active buffer target
local NO_NAME = "[NO NAME]"

-- Internal performance caching registers
local _tab_cache = nil
local _tab_cache_buf = nil

-- =============================================================================
--  [ Rosé Pine Adaptive Palette (Adaptive Dark & Light Support) ]
-- =============================================================================
-- Colors dynamically fall back to standard variant tokens if vim.o.background targets 'light'
local palette = {
	base     = vim.o.background == "light" and "#faf4ed" or "#191724",
	surface  = vim.o.background == "light" and "#fffaf3" or "#1f1d2e",
	overlay  = vim.o.background == "light" and "#f2e9e1" or "#26233a",
	muted    = vim.o.background == "light" and "#9893a5" or "#6e6a86",
	subtle   = vim.o.background == "light" and "#79748e" or "#908caa",
	text     = vim.o.background == "light" and "#575279" or "#e0def4",
	love     = vim.o.background == "light" and "#b4637a" or "#eb6f92",
	pine     = vim.o.background == "light" and "#286983" or "#31748f",
	highlight_low = vim.o.background == "light" and "#f4ede8" or "#212030",
	highlight_med = vim.o.background == "light" and "#dfdad9" or "#403d52",
}

-- =============================================================================
--  [ Dynamic Theme Highlights Configuration ]
-- =============================================================================
function M.set_highlights()
	vim.api.nvim_set_hl(0, "MyBufInactive",  { fg = palette.subtle,   bg = palette.surface })
	vim.api.nvim_set_hl(0, "MyBufActive",    { fg = palette.text,     bg = palette.overlay, bold = true })
	vim.api.nvim_set_hl(0, "MyBufSeparator", { fg = palette.base,     bg = palette.surface })
	vim.api.nvim_set_hl(0, "MyBufClose",     { fg = palette.love,     bg = palette.overlay })
end

-- =============================================================================
--  [ Cache Eviction & Invalidation Subsystems ]
-- =============================================================================
local _tab_invalidate_events = {
	"BufAdd",
	"BufDelete",
	"BufWipeout",
	"BufFilePost",    -- Triggered when buffer gets renamed
	"BufModifiedSet", -- Triggered when modified state dirty flags mutate
}

vim.api.nvim_create_autocmd(_tab_invalidate_events, {
	group = vim.api.nvim_create_augroup("MyTablineCache", { clear = true }),
	callback = function()
		_tab_cache = nil
	end,
})

-- =============================================================================
--  [ Text Formatting & Name Sanitization Utilities ]
-- =============================================================================
-- Resolve corresponding file extension devicons via lazy runtime pcall hooks
local function get_icon(filename, name)
	local ok, devicons = pcall(require, "nvim-web-devicons")
	if not ok or not name or name == "" then return "" end
	local ext = vim.fn.fnamemodify(name, ":e")
	local icon = devicons.get_icon(filename, ext, { default = true })
	return icon and (icon .. " ") or ""
end

-- Parse absolute path targets into clean contextual directory trails
local function get_display_name(path)
	if path == "" then return NO_NAME end
	local parts = vim.split(path, "/", { plain = true })
	if #parts == 1 then
		return parts[1]
	elseif #parts == 2 then
		return parts[#parts - 1] .. "/" .. parts[#parts]
	else
		-- Extract unified trail mapping matching: grandparent/parent/filename
		return parts[#parts - 2] .. "/" .. parts[#parts - 1] .. "/" .. parts[#parts]
	end
end

-- =============================================================================
--  [ Core Buffer Component Canvas Generators ]
-- =============================================================================
-- Compile operational metadata bounds matching a single buffer identification handle
local function render_buf(bufnr, current)
	if not vim.api.nvim_buf_is_loaded(bufnr) then return "" end
	if not vim.bo[bufnr].buflisted then return "" end

	local name = vim.api.nvim_buf_get_name(bufnr)
	local display_name = get_display_name(name)
	local filename = (name ~= "" and vim.fn.fnamemodify(name, ":t")) or NO_NAME
	local icon = get_icon(filename, name)
	local content = icon .. display_name

	if bufnr == current then
		return table.concat({
			"%#MyBufActive# ",
			content,
			" %#MyBufClose#",
			CLOSE,
			" %#MyBufSeparator#",
			SEP,
		})
	else
		return table.concat({
			"%#MyBufInactive# ",
			content,
			"  %#MyBufSeparator#",
			SEP,
		})
	end
end

-- Global frame pipeline evaluation entry point executed by Neovim kernel
function _G.tabline()
	local current = vim.api.nvim_get_current_buf()

	-- Pull from optimization registers if layout topology is clean
	if _tab_cache and _tab_cache_buf == current then
		return _tab_cache
	end

	local parts = {}
	-- Loop structural listed elements sequentially by ascending internal index allocation IDs
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		local chunk = render_buf(bufnr, current)
		if chunk ~= "" then table.insert(parts, chunk) end
	end

	if #parts == 0 then
		_tab_cache = ""
		_tab_cache_buf = current
		return ""
	end

	local line = table.concat(parts)
	-- Strip trailing layout boundaries prior to terminal paint operations
	local result = line:gsub(vim.pesc(SEP) .. "$", "")
	_tab_cache = result
	_tab_cache_buf = current
	return result
end

-- =============================================================================
--  [ Plugin Initialization Interface Hook ]
-- =============================================================================
function M.setup()
	M.set_highlights()

	vim.api.nvim_create_augroup("MyTabline", { clear = true })
	vim.api.nvim_create_autocmd("ColorScheme", {
		group = "MyTabline",
		callback = M.set_highlights,
	})

	vim.opt.showtabline = 2
	vim.opt.tabline = "%!v:lua.tabline()"
end

-- =============================================================================
--  [ Interactive Keymappings ]
-- =============================================================================
-- Force-evict all target items positioned leftwards of current focus line axis
vim.keymap.set("n", "<leader>bl", function()
	local cur = vim.api.nvim_get_current_buf()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted and buf < cur then
			pcall(vim.api.nvim_buf_delete, buf, { force = true })
		end
	end
end, { desc = "Close all left buffers" })

-- Force-evict all target items positioned rightwards of current focus line axis
vim.keymap.set("n", "<leader>br", function()
	local cur = vim.api.nvim_get_current_buf()
	local bufs = vim.api.nvim_list_bufs()
	for i = #bufs, 1, -1 do
		local buf = bufs[i]
		if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted and buf > cur then
			pcall(vim.api.nvim_buf_delete, buf, { force = true })
		end
	end
end, { desc = "Close all right buffers" })

M.setup()

return M
