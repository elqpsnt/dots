-- ╔══════════════════════════════════════════════════════════════╗
-- ║                     💾 SESSION SETUP                         ║
-- ║   Automated workspace state persistence and state reloading  ║
-- ╚══════════════════════════════════════════════════════════════╝

vim.opt.sessionoptions = "buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- =============================================================================
--  [ Session Directory Core Initialization ]
-- =============================================================================
local session_dir = vim.fn.stdpath("state") .. "/sessions/"
if vim.fn.isdirectory(session_dir) == 0 then
	vim.fn.mkdir(session_dir, "p")
end

-- =============================================================================
--  [ Internal Path Determination Closures ]
-- =============================================================================
-- Convert active working directory paths to safe system filename strings
local function get_session_file()
	local cwd = vim.fn.getcwd()
	local session_name = cwd:gsub("/", "%%")
	return session_dir .. session_name .. ".vim"
end

-- Absolute location pointing directly to the fallback cache file
local function get_last_session_file()
	return session_dir .. "last_session.vim"
end

-- =============================================================================
--  [ Automated Lifecycle Workspace Event Hooks ]
-- =============================================================================
-- SessionLoadPre — Close hanging floating window instances before session layout injection
local _ui2_ft = { cmd = true, msg = true, pager = true, dialog = true }
vim.api.nvim_create_autocmd("SessionLoadPre", {
	callback = function()
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			if vim.api.nvim_win_get_config(win).relative ~= "" then
				local ft = vim.bo[vim.api.nvim_win_get_buf(win)].filetype
				if not _ui2_ft[ft] then
					pcall(vim.api.nvim_win_close, win, true)
				end
			end
		end
	end,
})

-- VimEnter — Automatically pull workspace data if editor was invoked cleanly without target file args
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		if vim.fn.argc() == 0 then
			local session_file = get_session_file()
			if vim.fn.filereadable(session_file) == 1 then
				vim.cmd("silent! set winminwidth=1 winwidth=1 winminheight=1 winheight=1")
				vim.cmd("source " .. vim.fn.fnameescape(session_file))
			end
		end
	end,
})

-- VimLeavePre — Automatically serialise window geometry and loaded targets to storage on closing
vim.api.nvim_create_autocmd("VimLeavePre", {
	callback = function()
		local stop_file = session_dir .. ".stop_saving"
		if vim.fn.filereadable(stop_file) == 1 then
			vim.fn.delete(stop_file) -- Consume flag and drop saving cycle
			return
		end

		-- Verify working contexts explicitly contain file tracking buffers
		local buf_count = 0
		for _, buf in ipairs(vim.api.nvim_list_bufs()) do
			if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_name(buf) ~= "" then
				buf_count = buf_count + 1
			end
		end

		-- Require minimum 1 valid file buffer present to execute file write
		if buf_count >= 1 then
			local session_file = get_session_file()
			vim.cmd("mksession! " .. vim.fn.fnameescape(session_file))
			vim.cmd("mksession! " .. vim.fn.fnameescape(get_last_session_file()))
		end
	end,
})

-- =============================================================================
--  [ Interactive Keymappings ]
-- =============================================================================
-- Trigger local session reloads associated with active project directory paths
vim.keymap.set("n", "<leader>qs", function()
	local session_file = get_session_file()
	if vim.fn.filereadable(session_file) == 1 then
		vim.cmd("source " .. vim.fn.fnameescape(session_file))
	else
		print("No session found for current directory")
	end
end, { desc = "Load session for current directory" })

-- Instantly pull the global fallback recovery layout image file
vim.keymap.set("n", "<leader>ql", function()
	local last_session = get_last_session_file()
	if vim.fn.filereadable(last_session) == 1 then
		vim.cmd("source " .. vim.fn.fnameescape(last_session))
	else
		print("No last session found")
	end
end, { desc = "Load last session" })

-- Interactive list selector query to select and unpack archived layouts
vim.keymap.set("n", "<leader>qS", function()
	local sessions = {}
	local session_files = vim.fn.glob(session_dir .. "*.vim", false, true)

	for _, file in ipairs(session_files) do
		local name = vim.fn.fnamemodify(file, ":t:r")
		name = name:gsub("%%", "/") -- Revert back from filesystem safe delimiters
		table.insert(sessions, name)
	end

	if #sessions == 0 then
		print("No sessions found")
		return
	end

	vim.ui.select(sessions, {
		prompt = "Select session to load:",
	}, function(choice)
		if choice then
			local session_file = session_dir .. choice:gsub("/", "%%") .. ".vim"
			vim.cmd("source " .. vim.fn.fnameescape(session_file))
		end
	end)
end, { desc = "Select session to load" })

-- Drop a stop flag tracking file into environment space to block automated storage writes on exit
vim.keymap.set("n", "<leader>qd", function()
	local stop_file = session_dir .. ".stop_saving"
	vim.fn.writefile({}, stop_file)
	print("Session saving stopped")
end, { desc = "Stop session saving" })
