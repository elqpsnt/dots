-- ╔══════════════════════════════════════════════════════════════╗
-- ║                  🍿  SNACKS.NVIM CONFIGURATION                ║
-- ║     Comprehensive layout, picker, and UI utilities setup     ║
-- ╚══════════════════════════════════════════════════════════════╝

-- Declare core plugin dependencies via native package manager layout
vim.pack.add({
	"https://github.com/folke/snacks.nvim",
	"https://github.com/nvim-tree/nvim-web-devicons",
})

local Snacks = require("snacks")

Snacks.setup({
	-- =============================================================================
	--  [ Global Component Toggles & Subsystem Adjustments ]
	-- =============================================================================
	animate = { enabled = true }, -- Smooth aesthetic UI animation transitions
	
	-- Strict optimization constraints triggered automatically for large asset files
	bigfile = {
		enabled = true,
		size = 1.5 * 1024 * 1024, -- 1.5MB threshold
		setup = function(ctx)
			-- Force clear regex syntax definitions & disable Tree-sitter parsers
			vim.cmd("syntax clear")
			vim.treesitter.stop(ctx.buf)
			vim.wo[0].foldmethod = "manual"
			vim.wo[0].foldexpr = ""

			-- Postpone expensive LSP metadata updates to preserve thread performance
			vim.schedule(function()
				vim.lsp.inlay_hint.enable(false, { bufnr = ctx.buf })
				vim.lsp.document_color.enable(false, { bufnr = ctx.buf })
			end)

			-- Suppress running lint tasks or runtime workspace diagnoses
			vim.diagnostic.enable(false, { bufnr = ctx.buf })

			-- Remove structural indent guide indicators inside the huge text viewport
			vim.b[ctx.buf].snacks_indent = false
		end,
	},
	dashboard    = { enabled = false }, -- Using custom or alternative dashboard designs
	dim          = { enabled = true },  -- Dim focus surrounding active blocks or scopes
	explorer     = { enabled = true, replace_netrw = true }, -- Swap default netrw folder tree layout
	image        = { enabled = true },  -- Visual asset preview render hooks inside terminal grids
	indent       = { enabled = true },  -- Vertical indent scope structural lines
	input        = { enabled = true },  -- Floating popup inputs interface intercept overrides
	layout       = { enabled = true },  -- Responsive dynamic box rendering window components
	notifier     = { enabled = true },  -- Toast notification manager layout frames
	quickfile    = { enabled = true },  -- Perform pre-loading tasks during fast sequence boots
	scope        = { enabled = true },  -- Visual range tracking highlights matching the active block
	scratch      = { enabled = true },  -- Ephemeral scratchpad documentation pads
	scroll       = { enabled = true },  -- Smooth frame-pacing kinetic window viewport scrolls
	statuscolumn = { enabled = true },  -- Clean margin sidebar (signs, absolute & relative lines)
	terminal     = { enabled = true },  -- Dynamic window terminal shell attachments
	toggle       = { enabled = true },  -- Key-bindable options runtime switcher engine
	words        = { enabled = false }, -- Document object location references lookups (disabled)
	zen          = { enabled = true },  -- Focused distraction-free working viewports

	-- =============================================================================
	--  [ Fast Fuzzy Picker & Grep Context Specifications ]
	-- =============================================================================
	picker = {
		sources = {
			-- Specific rules evaluating standard project file discoveries
			files = {
				hidden = true,   -- Inspect dotfiles (.env, .gitignore)
				ignored = true,  -- Track context values mapped inside rules lists
				win = {
					input = {
						keys = {
							["<S-h>"] = "toggle_hidden",
							["<S-i>"] = "toggle_ignored",
							["<S-f>"] = "toggle_follow",
							["<C-y>"] = { "yazi_copy_relative_path", mode = { "n", "i" } },
						},
					},
				},
				-- Complete runtime blacklists containing bulky directory assets
				exclude = {
					"**/.git/*",
					"**/node_modules/*",
					"**/.yarn/cache/*",
					"**/.yarn/install*",
					"**/.yarn/releases/*",
					"**/.pnpm-store/*",
					"**/.idea/*",
					"**/.DS_Store",
					"**/.venv/**",
					"build/*",
					"coverage/*",
					"dist/*",
					"hodor-types/*",
					"**/target/*",
					"**/public/*",
					"**/.node-gyp/**",
					"**/claude/debug",
					"**/claude/file-history",
					"**/claude/plans",
					"**/claude/plugins",
					"**/claude/projects",
					"**/claude/session-env",
					"**/claude/shell-snapshots",
					"**/claude/statsig",
					"**/claude/telemetry",
					"**/claude/todos",
					"**/claude/history.jsonl",
					"**/claude/*cache*",
				},
			},
			-- Project-wide live string occurrences scanning definitions
			grep = {
				hidden = true,
				ignored = true,
				win = {
					input = {
						keys = {
							["<S-h>"] = "toggle_hidden",
							["<S-i>"] = "toggle_ignored",
							["<S-f>"] = "toggle_follow",
						},
					},
				},
				exclude = {
					"**/.git/*",
					"**/node_modules/*",
					"**/.yarn/cache/*",
					"**/.yarn/install*",
					"**/.yarn/releases/*",
					"**/.pnpm-store/*",
					"**/.venv/*",
					"**/.idea/*",
					"**/.DS_Store",
					"**/.venv/**",
					"**/yarn.lock",
					"build*/*",
					"coverage/*",
					"dist/*",
					"certificates/*",
					"hodor-types/*",
					"**/target/*",
					"**/public/*",
					"**/digest*.txt",
					"**/.node-gyp/**",
					"**/claude/debug",
					"**/claude/file-history",
					"**/claude/plans",
					"**/claude/plugins",
					"**/claude/projects",
					"**/claude/session-env",
					"**/claude/shell-snapshots",
					"**/claude/statsig",
					"**/claude/telemetry",
					"**/claude/todos",
					"**/claude/history.jsonl",
					"**/claude/*cache*",
				},
			},
			grep_buffers = {}, -- Context structure tracking loaded lines lists
			-- Integrated interactive tree panel layout parameters
			explorer = {
				hidden = true,
				ignored = true,
				supports_live = true,    -- Perform synchronous text searches inside panel trees
				auto_close = true,       -- Shut the sidebar panel when a file choice completes
				diagnostics = true,      -- Print error highlight ticks alongside filenames
				diagnostics_open = false,
				focus = "list",          -- Target directory list grid during initial layouts
				follow_file = true,      -- Sync tree track node to focus the active buffer target
				git_status = true,       -- Reflect version modifications on folder paths
				git_status_open = false,
				git_untracked = true,
				jump = { close = true },
				tree = true,             -- Render structural branch connectors visually
				watch = true,            -- Listen to global system directory shifts automatically
				exclude = {
					".yarn/cache/**",
					".yarn/install/**",
					".yarn/install*",
					".yarn/releases/**",
					".pnpm-store",
					".venv",
					".DS_Store",
					"**/.node-gyp/**",
					"**/claude/debug",
					"**/claude/file-history",
					"**/claude/plans",
					"**/claude/plugins",
					"**/claude/projects",
					"**/claude/session-env",
					"**/claude/shell-snapshots",
					"**/claude/statsig",
					"**/claude/telemetry",
					"**/claude/todos",
					"**/claude/history.jsonl",
					"**/claude/*cache*",
				},
			},
		},
	},
})

-- =============================================================================
--  [ Runtime Switcher Registration Auto-commands ]
-- =============================================================================
-- Register option toggle utilities after application startup configurations wrap up completely
vim.api.nvim_create_autocmd("VimEnter", {
	once = true, -- Execute routine lifecycle exactly once
	callback = function()
		-- Deflect map evaluations to preserve thread flow bounds
		vim.schedule(function()
			Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
			Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
			Snacks.toggle.diagnostics():map("<leader>ud")
			Snacks.toggle.line_number():map("<leader>ul")
			Snacks.toggle
				.option("conceallevel", {
					off = 0,
					on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2,
					name = "Conceal Level",
				})
				:map("<leader>uc")
			Snacks.toggle
				.option("showtabline", {
					off = 0,
					on = vim.o.showtabline > 0 and vim.o.showtabline or 2,
					name = "Tabline",
				})
				:map("<leader>uA")
			Snacks.toggle.treesitter():map("<leader>uT")
			Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
			Snacks.toggle.dim():map("<leader>uD")
			Snacks.toggle.animate():map("<leader>ua")
			Snacks.toggle.indent():map("<leader>ug")
			Snacks.toggle.scroll():map("<leader>uS")
			Snacks.toggle.profiler():map("<leader>dpp")
			Snacks.toggle.profiler_highlights():map("<leader>dph")
			Snacks.toggle.zoom():map("<leader>wm"):map("<leader>uZ")
			Snacks.toggle.zen():map("<leader>uz")
		end)
	end,
})

-- =============================================================================
--  [ Interactive Mappings Lookup Dictionary ]
-- =============================================================================
-- stylua: ignore start
local   keymaps = {
    -- Top Pickers & Explorer Panels
    { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
    { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>n", function() Snacks.notifier.show_history() end, desc = "Notification History" },
    { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
    {
      "<leader>,", function()
        Snacks.picker.buffers({
          win = {
            input = {
              keys = {
                ["dd"] = "bufdelete", -- Wipe buffer element inside picker listing
                ["<c-d>"] = { "bufdelete", mode = { "n", "i" } },
              },
            },
            list = { keys = { ["dd"] = "bufdelete" } },
          },
        })
      end, desc = "Buffers",
    },
    -- Find Routines
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
    { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
    { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
    -- Git VCS Actions
    { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
    { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
    { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
    { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
    { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
    { "<leader>gp", function() Snacks.picker.git_diff() end, desc = "Git Diff Picker (Hunks)" },
    { "<leader>gP", function() Snacks.picker.git_diff({ base = "origin" }) end, desc = "Git Diff Picker (origin)" },
    { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
    -- Live Text Scanning
    { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
    { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
    { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
    -- Search & Metadata Inspects
    { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
    { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
    { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
    { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
    { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
    { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
    { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
    { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
    { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
    { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
    { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
    { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
    { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
    { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
    { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },
    { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
    -- Language Server Protocol Navigation Targets
    { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
    { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
    { "gR", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
    { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
    { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
    { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
    { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
    { "gai", function() Snacks.picker.lsp_incoming_calls() end, desc = "C[a]lls Incoming", has = "callHierarchy/incomingCalls" },
    { "gao", function() Snacks.picker.lsp_outgoing_calls() end, desc = "C[a]lls Outgoing", has = "callHierarchy/outgoingCalls" },
    -- Buffer Life Cycle Operations
    { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete buffer", mode = { "n" }, },
    { "<leader>bo", function() Snacks.bufdelete.other() end, desc = "Delete other buffers", mode = { "n" }, },
    -- Integrated Terminal Shell Spawns
    { "<leader>fT", function() Snacks.terminal() end, desc = "Terminal (cwd)", mode = "n", },
    { "<leader>ft", function() Snacks.terminal(nil, { cwd = vim.fn.getcwd() }) end, desc = "Terminal (Root Dir)",  mode = "n", },
    { "<c-:>",  function() Snacks.terminal(nil, { cwd = vim.fn.getcwd() }) end, desc = "Terminal (Root Dir)", mode = "n", },
    { "<c-/>",      function() Snacks.terminal() end, desc = "Toggle Terminal" },
    { "<c-_>", function() Snacks.terminal(nil, { cwd = vim.fn.getcwd() }) end, desc = "which_key_ignore",  mode = "n", },
    -- Miscellaneous Subsystems
    { "<leader>z",  function() Snacks.zen() end, desc = "Toggle Zen Mode" },
    { "<leader>Z",  function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
    { "<leader>.",  function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
    { "<leader>S",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
    { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File" },
    { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
    { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
    { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
    { "]]",         function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
    { "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
    {
      "<leader>N",
      desc = "Neovim News",
      function()
        Snacks.win({
          file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
          width = 0.6,
          height = 0.6,
          wo = {
            spell = false,
            wrap = false,
            signcolumn = "yes",
            statuscolumn = " ",
            conceallevel = 3,
          },
        })
      end,
    }
}
-- stylua: ignore end

-- =============================================================================
--  [ Keymap Compiler Loop ]
-- =============================================================================
-- Process and loop the keymaps dictionary to programmatically bind them to core APIs
for _, map in ipairs(keymaps) do
	local opts = { desc = map.desc }
	
	-- Populate mapping control parameter overrides if present
	if map.silent   ~= nil then opts.silent   = map.silent   end
	if map.expr     ~= nil then opts.expr     = map.expr     end
	if map.noremap  ~= nil then opts.noremap  = map.noremap  else opts.noremap = true end

	local mode = map.mode or "n" -- Fall back onto Normal mode ("n") if unspecified
	vim.keymap.set(mode, map[1], map[2], opts)
end
