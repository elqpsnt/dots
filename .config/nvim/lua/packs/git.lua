-- ╔══════════════════════════════════════════════════════════════╗
-- ║                  🐙  GIT SUBSYSTEM INTEGRATION               ║
-- ║     Real-time status column gutters & advanced side-by-side  ║
-- ║                 file comparison workspaces                   ║
-- ╚══════════════════════════════════════════════════════════════╝

-- Native package registration handled directly by Neovim's built-in vim.pack system
vim.pack.add({
	"https://github.com/lewis6991/gitsigns.nvim", -- Real-time gutter indicators and hunk staging management
	"https://gitlab.com/tduyng/vdiff.nvim",       -- Advanced side-by-side git diffing and conflict resolution engine
})

-- Setup gitsigns.nvim
require("gitsigns").setup({
	-- Customize dynamic status column indicators to represent uncommitted code states
	signs = {
		add = { text = "▎" },          -- Added line block marker
		change = { text = "▎" },       -- Modified line block marker
		delete = { text = "" },       -- Deleted line block indicator arrow
		topdelete = { text = "" },    -- Deletion block marker happening at start of file
		changedelete = { text = "~" }, -- Deletion structural replacement block marker
		untracked = { text = "┆" },    -- New file without tracking markers
	},
	-- Mirror status styles exactly for items staged in git's index cache
	signs_staged = {
		add = { text = "▎" },
		change = { text = "▎" },
		delete = { text = "" },
		topdelete = { text = "" },
		changedelete = { text = "~" },
		untracked = { text = "┆" },
	},
	-- Enable virtual text commit metadata overlays at the end of the current line
	current_line_blame = true,
	current_line_blame_opts = {
		virt_text = true,
		virt_text_pos = "eol",       -- Align git author statistics directly at the end of line
		delay = 800,                 -- Shadows wait threshold before rendering strings
		ignore_whitespace = false,   -- Take formatting alterations into blame computations
		virt_text_priority = 100,    -- Render stack layout index weight
		use_focus = true,            -- Show blame data exclusively when window is focused
	},
	-- String format structure tracking: [Author Name], [Commit Time] - [Message] ([Short Hash])
	current_line_blame_formatter = "<author>, <author_time:%R> - <summary> (<abbrev_sha>)",
	-- Instantiates buffer context actions when a file hooks up with active version control
	on_attach = function(buffer)
		local gs = package.loaded.gitsigns

		-- Clean helper utility wrapper to inject local shortcut profiles
		local function map(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, { buffer = buffer, desc = desc })
		end

		-- Navigate forward through individual code additions/deletions chunks
		map("n", "]h", function()
			if vim.wo.diff then
				vim.cmd.normal({ "]c", bang = true }) -- Fallback to standard vim diff jumps if inside a raw diff view
			else
				gs.nav_hunk("next")
			end
		end, "Next Hunk")

		-- Navigate backward through individual code additions/deletions chunks
		map("n", "[h", function()
			if vim.wo.diff then
				vim.cmd.normal({ "[c", bang = true }) -- Fallback to standard vim diff jumps if inside a raw diff view
			else
				gs.nav_hunk("prev")
			end
		end, "Prev Hunk")

		-- Direct telemetry jump links to outer layout boundaries
		map("n", "]H", function()
			gs.nav_hunk("last")
		end, "Last Hunk")
		map("n", "[H", function()
			gs.nav_hunk("first")
		end, "First Hunk")

		-- Staging and Reset configurations mapping layers
		map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
		map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")

		-- Macro buffer global control configurations mapping layers
		map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
		map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
		map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
		map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")
		map("n", "<leader>ghb", function()
			gs.blame_line({ full = true })
		end, "Blame Line")
		map("n", "<leader>ghB", function()
			gs.blame()
		end, "Blame Buffer")
		map("n", "<leader>ghd", gs.diffthis, "Diff This")
		map("n", "<leader>ghD", function()
			gs.diffthis("~")
		end, "Diff This ~")

		-- Text object definitions: Select the hunk under cursor (e.g., type `vih` to select a block of git changes)
		map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
	end,
})

-- Setup vdiff.nvim with side-by-side layout (IntelliJ style)
require("vdiff").setup({
	diff_layout = "diff2_vertical", -- side-by-side
	merge_layout = "diff3_vertical", -- 3-way side-by-side
})

-- Accepts any ref: branch, commit, tag, HEAD~N, or empty for working tree
-- Empty or nil = working tree vs HEAD
-- --staged = staged changes
-- main = compare with main branch
-- HEAD~3 = compare with 3 commits ago
-- abc123 = compare with commit hash
-- v1.0.0 = compare with tag
-- Prompt target references (branch, tag, or hash) to run a macro project comparison view
vim.keymap.set("n", "<leader>gc", function()
	vim.ui.input({
		prompt = "Compare with (branch/commit/tag/HEAD~N, empty=working): ",
	}, function(ref)
		vim.cmd("VDiffCompare " .. (ref or ""))
	end)
end, { desc = "Git: compare (universal)" })

-- COMPARE TWO REFS (e.g., branches, commits, tags)
-- Query two custom tracking points explicitly to render an isolated differential view canvas
vim.keymap.set("n", "<leader>gC", function()
	vim.ui.input({ prompt = "Compare ref1 (default=HEAD): " }, function(ref1)
		if not ref1 or ref1 == "" then
			ref1 = "HEAD"
		end
		vim.ui.input({ prompt = "Compare ref2: " }, function(ref2)
			vim.cmd("VDiffCompareRefs " .. ref1 .. " " .. (ref2 or ""))
		end)
	end)
end, { desc = "Git: compare two refs" })

-- Quick shortcuts for common comparisons
-- Fast terminal shortcut targets covering generalized repository matching targets
vim.keymap.set("n", "<leader>gd", "<Cmd>VDiffCompare<CR>", { desc = "Git: working tree (all files)" })
vim.keymap.set("n", "<leader>gD", "<Cmd>VDiffCompare --staged<CR>", { desc = "Git: staged (all files)" })
vim.keymap.set("n", "<leader>gV", "<Cmd>VDiffHistory<CR>", { desc = "Git: file history" })
vim.keymap.set("v", "<leader>gv", ":'<,'>VDiffRange<CR>", { desc = "Git: line history" })
vim.keymap.set("n", "<leader>gx", "<Cmd>VDiffClose<CR>", { desc = "Git: close all" })
-- 3-way merge view (LOCAL | RESULT | REMOTE)
vim.keymap.set("n", "<leader>gm", "<Cmd>VMerge<CR>", { desc = "Git: merge conflicts" })

-- CURRENT FILE DIFF
-- Same principle: accepts any ref or empty for HEAD
-- Immediately open a vertical patch comparison mapping current layout file state directly versus HEAD
vim.keymap.set("n", "<leader>gf", "<Cmd>VDiff<CR>", { desc = "Git: diff file vs HEAD" })
-- Prompt user targets to capture and cross-examine an individual file against custom branches or commits
vim.keymap.set("n", "<leader>gF", function()
	vim.ui.input({ prompt = "Diff file with (ref, empty=HEAD): " }, function(ref)
		vim.cmd("VDiff " .. (ref or ""))
	end)
end, { desc = "Git: diff file (universal)" })

-- UTILITY: Compare two arbitrary files with difftastic (or vimdiff fallback)
-- Extract paths to run rich diffing analysis using `difftastic` tool shell or fallback vim engines
vim.keymap.set("n", "<leader>g2", function()
	vim.ui.input({ prompt = "First file: " }, function(file1)
		if not file1 or not file1:match("%S") then
			return
		end
		vim.ui.input({ prompt = "Second file: " }, function(file2)
			if file2 and file2:match("%S") then
				-- Normalize absolute structural paths on disk
				local abs1 = vim.fn.fnamemodify(file1, ":p")
				local abs2 = vim.fn.fnamemodify(file2, ":p")
				-- If external binary `difftastic` exists on system runtime environment path, utilize it
				if vim.fn.executable("difft") == 1 then
					vim.cmd("tabnew | terminal difft " .. abs1 .. " " .. abs2)
				else
					-- Structural native vimdiff command fallback pipeline layout matrix
					vim.cmd(("tabnew | e %s | diffthis | vsplit %s | diffthis"):format(abs1, abs2))
				end
			end
		end)
	end)
end, { desc = "Git: compare 2 files (difftastic or vimdiff)" })
