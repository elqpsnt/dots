-- ╔══════════════════════════════════════════════════════════════╗
-- ║                   🎨 STATUSLINE SETUP                        ║
-- ║   Custom global statusline component engine using Rosé Pine  ║
-- ╚══════════════════════════════════════════════════════════════╝

local M = {}

local NONE = "NONE"

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
	gold     = vim.o.background == "light" and "#ea9d34" or "#f6c177",
	rose     = vim.o.background == "light" and "#d7827e" or "#ebbcba",
	pine     = vim.o.background == "light" and "#286983" or "#31748f",
	foam     = vim.o.background == "light" and "#56949f" or "#9ccfd8",
	iris     = vim.o.background == "light" and "#907aa9" or "#c4a7e7",
	highlight_low = vim.o.background == "light" and "#f4ede8" or "#212030",
	highlight_med = vim.o.background == "light" and "#dfdad9" or "#403d52",
}

-- =============================================================================
--  [ Highlight Engine Commands Wrapper ]
-- =============================================================================
local function hi(group, opts)
	local cmd = { "highlight!", group }
	if opts.guibg then table.insert(cmd, "guibg=" .. opts.guibg) end
	if opts.guifg then table.insert(cmd, "guifg=" .. opts.guifg) end
	if opts.gui   then table.insert(cmd, "gui=" .. opts.gui) end
	vim.cmd(table.concat(cmd, " "))
end

-- Layout structural container baselines
hi("StatusLine",   { guibg = NONE, guifg = NONE })
hi("StatusLineNC", { guibg = NONE, guifg = NONE })

-- Operational Mode state segments
hi("StatusMode",       { guibg = palette.pine, guifg = palette.base, gui = "bold" })
hi("StatusModeToNorm", { guibg = NONE,         guifg = palette.pine })

-- VCS Git component elements
hi("StatusGit",         { guibg = palette.overlay, guifg = palette.text, gui = "bold" })
hi("StatusGitToNorm",   { guibg = NONE,            guifg = palette.iris })
hi("StatusDiffAdd",     { guibg = NONE,            guifg = palette.foam, gui = "bold" })
hi("StatusDiffChange",  { guibg = NONE,            guifg = palette.gold, gui = "bold" })
hi("StatusDiffDelete",  { guibg = NONE,            guifg = palette.love, gui = "bold" })

-- Dynamic filename definitions
hi("StatusFile",       { guibg = NONE, guifg = NONE, gui = "bold" })
hi("StatusFileToNorm", { guibg = NONE, guifg = NONE })

-- Language Server Protocol notifications
hi("StatusLSP",       { guibg = NONE, guifg = NONE, gui = "bold" })
hi("StatusLSPToNorm", { guibg = NONE, guifg = NONE })

-- Diagnostic severe code validation signals
hi("StatusErrorIcon", { guibg = NONE, guifg = palette.love, gui = "bold" })
hi("StatusWarnIcon",  { guibg = NONE, guifg = palette.gold, gui = "bold" })
hi("StatusInfoIcon",  { guibg = NONE, guifg = palette.pine, gui = "bold" })
hi("StatusHintIcon",  { guibg = NONE, guifg = palette.iris })

-- Miscellaneous positional metadata and file information fields
hi("StatusBuffer",   { guibg = palette.highlight_low, guifg = palette.subtle })
hi("StatusType",     { guibg = palette.highlight_low, guifg = palette.subtle })
hi("StatusNorm",     { guibg = NONE,                  guifg = NONE })
hi("StatusLocation", { guibg = palette.highlight_med, guifg = palette.text })
hi("StatusPercent",  { guibg = palette.iris,          guifg = palette.base, gui = "bold" })

-- =============================================================================
--  [ Async Diagnostic Monitors & Cache Layers ]
-- =============================================================================
local _diag_cache = {}

vim.api.nvim_create_autocmd("DiagnosticChanged", {
	callback = function(args)
		local buf = args.buf
		local sev = vim.diagnostic.severity
		local counts = vim.diagnostic.count(buf)
		_diag_cache[buf] = {
			e = counts[sev.ERROR] or 0,
			w = counts[sev.WARN] or 0,
			i = counts[sev.INFO] or 0,
			h = counts[sev.HINT] or 0,
		}
	end,
})

-- =============================================================================
--  [ Prose Writing Proximity Counters (Markdown Metrics) ]
-- =============================================================================
local _wc_state = { words = 0, timer = nil }

vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "BufEnter" }, {
	callback = function()
		local ft = vim.bo.filetype
		if not (ft:match("md") or ft:match("markdown") or ft == "text") then return end
		if _wc_state.timer then
			_wc_state.timer:stop()
			_wc_state.timer:close()
		end
		_wc_state.timer = vim.defer_fn(function()
			_wc_state.timer = nil
			_wc_state.words = vim.fn.wordcount().words or 0
		end, 500)
	end,
})

-- =============================================================================
--  [ Visual Element Icon Caches ]
-- =============================================================================
local _icon_cache = {}

vim.api.nvim_create_autocmd({ "BufWipeout", "BufDelete" }, {
	callback = function(args)
		_icon_cache[args.buf] = nil
	end,
})

-- =============================================================================
--  [ Functional Data Compilers & String Translators ]
-- =============================================================================
-- Query the active head ref state values from runtime buffer variables
local function get_git_branch()
	local branch = vim.b.gitsigns_head
	if not branch or branch == "" then return "" end

	local gs = vim.b.gitsigns_status_dict
	if gs and gs.root then
		local repo_name = vim.fn.fnamemodify(gs.root, ":t")
		return repo_name .. "/" .. branch
	end

	return branch
end

-- Format unified operational hunk tracking statistics fields
local function build_git_diff()
	local gs = vim.b.gitsigns_status_dict or {}
	local added = gs.added or 0
	local changed = gs.changed or 0
	local removed = gs.removed or 0

	local diff_str = ""
	if added > 0   then diff_str = diff_str .. "%#StatusDiffAdd# " .. added .. " " end
	if changed > 0 then diff_str = diff_str .. "%#StatusDiffChange# " .. changed .. " " end
	if removed > 0 then diff_str = diff_str .. "%#StatusDiffDelete# " .. removed .. " " end

	return diff_str .. "%#StatusLine#"
end

-- Compile active evaluation warnings into a cohesive string segment block
local function get_diagnostics()
	local buf = vim.api.nvim_get_current_buf()
	local c = _diag_cache[buf] or {}
	local s = ""
	if (c.e or 0) > 0 then s = s .. "%#StatusErrorIcon# " .. c.e .. " " end
	if (c.w or 0) > 0 then s = s .. "%#StatusWarnIcon# " .. c.w .. " " end
	if (c.i or 0) > 0 then s = s .. "%#StatusInfoIcon# " .. c.i .. " " end
	if (c.h or 0) > 0 then s = s .. "%#StatusHintIcon# " .. c.h .. " " end

	return s .. "%#StatusLine#"
end

-- Safely lookup associated devicon strings matching the current file format
local function get_file_icon()
	local bufnr = vim.api.nvim_get_current_buf()
	if _icon_cache[bufnr] ~= nil then return _icon_cache[bufnr] end

	local ok, icons = pcall(require, "nvim-web-devicons")
	if not ok then
		_icon_cache[bufnr] = ""
		return ""
	end
	local name = vim.api.nvim_buf_get_name(bufnr)
	local f = vim.fn.fnamemodify(name, ":t")
	local e = vim.fn.fnamemodify(name, ":e")
	local icon = icons.get_icon(f, e, { default = true })
	local result = icon and icon .. " " or ""
	_icon_cache[bufnr] = result
	return result
end

-- Convert metrics to readable structural word totals and read times
local function word_reading()
	local ft = vim.bo.filetype
	if ft:match("md") or ft:match("markdown") or ft == "text" then
		local w = _wc_state.words
		if w == 0 then return "" end
		return w .. "w " .. " " .. math.ceil(w / 200) .. "m"
	end
	return ""
end

-- Vim operational state context string indicators
local mode_icons = {
	n       = " NORMAL",
	c       = " COMMAND",
	t       = " TERMINAL",
	i       = " INSERT",
	R       = " REPLACE",
	V       = " V-LINE",
	[" "]  = " V-BLOCK",
	r       = " R-PENDING",
	v       = " VISUAL",
}

-- =============================================================================
--  [ Main Pipeline Component Assembler Engine ]
-- =============================================================================
function M.build()
	local st = ""

	-- Section A: Core Mode Indicator Block
	local m = vim.fn.mode()
	st = st .. "%#StatusMode# " .. (mode_icons[m] or m) .. " " .. "%#StatusModeToNorm#"

	-- Section B: Version Control Branch & Mutation Diff Hunks
	local br = get_git_branch()
	if br ~= "" then
		st = st .. "%#StatusGit# " .. " " .. br .. " " .. "%#StatusGitToNorm#"
		local git_diff = build_git_diff()
		if git_diff ~= "" then st = st .. git_diff .. "%#StatusGitToNorm#" end
	end

	-- Section C: Path Location File Target Name Contexts
	local fnm = vim.fn.expand("%:.")
	if fnm ~= "" then
		st = st .. "%#StatusFile# " .. fnm .. " " .. (vim.bo.modified and " " or "") .. "%#StatusFileToNorm#"
	end

	-- Section D: Client Language Server Diagnostic Signals
	local di = get_diagnostics()
	if di ~= "" then st = st .. "%#StatusLSP# " .. di .. " " .. "%#StatusLSPToNorm#" end

	-- Window Splitting Separator Alignment Axis Breakpoint
	st = st .. "%="

	-- Section E: Asynchronous Background Server Progress Logs
	local progress = vim.ui.progress_status and vim.ui.progress_status() or ""
	if progress ~= "" then st = st .. "%#StatusLSP# " .. progress .. " %#StatusLine#" end

	-- Section F: File Type Identification & Extension Icon Grids
	local ft = vim.bo.filetype
	if ft ~= "" then st = st .. "%#StatusType# " .. get_file_icon() .. ft .. "%#StatusTypeToNorm#" end

	-- Section G: Prose Metrics Counters
	local wr = word_reading()
	if wr ~= "" then st = st .. "%#StatusBuffer# " .. " " .. wr end

	-- Section H: Structural File Encoding, Formatting, and Cursor Bounds
	st = st
		.. "%#StatusBuffer# "
		.. vim.bo.fileencoding
		.. " "
		.. vim.bo.fileformat
		.. " "
		.. "%#StatusLocation# %l:%c "
		.. "%#StatusPercent# %p%% "

	return st
end

-- Global global layout option flags assignments
vim.opt.laststatus = 3
vim.opt.showmode = false
vim.o.statusline = "%!v:lua.require('config.statusline').build()"

return M
