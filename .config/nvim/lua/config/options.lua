-- ╔══════════════════════════════════════════════════════════════╗
-- ║                    ⚙️  OPTIONS SETUP                          ║
-- ║    Global editor behavior, UI styling, and file handling     ║
-- ╚══════════════════════════════════════════════════════════════╝

local opt = vim.opt

-- =============================================================================
--  [ UI & Display Settings ]
-- =============================================================================
opt.number = true -- Show absolute line number for the current line
opt.relativenumber = true -- Show relative line numbers for easy jumping
opt.cursorline = true -- Highlight the text line containing the cursor
opt.wrap = false -- Disable line wrapping (keep long lines on one line)
opt.scrolloff = 10 -- Minimum number of screen lines to keep above/below cursor
opt.sidescrolloff = 8 -- Minimum number of screen columns to keep left/right of cursor

-- =============================================================================
--  [ Indentation & Tabbing ]
-- =============================================================================
opt.tabstop = 2 -- Number of spaces that a <Tab> in the file counts for
opt.shiftwidth = 2 -- Number of spaces to use for each step of (auto)indent
opt.softtabstop = 2 -- Number of spaces that a <Tab> counts for while editing
opt.expandtab = true -- Convert tabs to spaces
opt.smartindent = true -- Insert indents automatically depending on syntax/context
opt.autoindent = true -- Copy indent from current line when starting a new one
opt.shiftround = true -- Round indent to a multiple of 'shiftwidth'

-- =============================================================================
--  [ Search Behavior ]
-- =============================================================================
opt.ignorecase = true -- Ignore case in search patterns
opt.smartcase = true -- Override 'ignorecase' if the pattern contains upper case letters
opt.hlsearch = false -- Don't keep results highlighted after search finishes
opt.incsearch = true -- Preview search results incrementally as you type

-- =============================================================================
--  [ Visuals, Menus & Windows ]
-- =============================================================================
opt.termguicolors = true -- Enable 24-bit RGB true color in the terminal
opt.signcolumn = "yes" -- Always show the sign column to prevent text shifting
opt.showmatch = true -- Briefly jump to matching bracket when one is inserted
opt.matchtime = 2 -- Tenths of a second to show the matching paren
opt.cmdheight = 1 -- Number of screen lines to use for the command-line
opt.showmode = false -- Don't show mode (e.g., -- INSERT --) since statusline handles it
opt.pumheight = 10 -- Maximum number of items to show in the popup menu
opt.pumblend = 10 -- Enable pseudo-transparency for the completion popup menu
opt.pummaxwidth = 60 -- Cap the maximum width of the completion popup menu
opt.winblend = 0 -- Floating window transparency (0 = fully opaque)
opt.completeopt = "menu,menuone,noselect,popup" -- Better completion menu behaviors
opt.conceallevel = 2 -- Hide bold/italic markup symbols but render text cleanly
opt.concealcursor = "" -- Don't hide markup symbols on the current cursor line
opt.synmaxcol = 300 -- Stop syntax highlighting long lines to preserve performance
opt.ruler = false -- Disable default ruler (line/col tracker at bottom right)
opt.virtualedit = "block" -- Allow cursor to move into empty space during Visual Block mode
opt.winminwidth = 5 -- Minimum encoding width for inactive windows
opt.winborder = "rounded" -- Set global border style for LSP/diagnostic floating windows
opt.pumborder = "rounded" -- Set rounded border style for completion popup menu
opt.laststatus = 3 -- Enable global statusline across all splits instead of per-window
opt.linebreak = true -- Wrap lines at a character in 'breakat' rather than mid-word
opt.list = false -- Hide trailing spaces, tabs, and other invisible characters

-- =============================================================================
--  [ File Handling & Backups ]
-- =============================================================================
opt.backup = false -- Disable creation of backup files
opt.writebackup = false -- Disable backup creation immediately before writing a file
opt.swapfile = false -- Disable creation of .swp files
opt.undofile = true -- Enable persistent undo history across buffer closes/reboots
opt.undolevels = 10000 -- Maximum number of changes that can be undone
opt.confirm = true -- Prompt to save changes before exiting a modified buffer

-- Set structural XDG standard directory path location for persistent undo histories
local undodir = vim.fn.stdpath("data") .. "/undo"
opt.undodir = undodir

-- Ensure data-isolated undo directory path exists cleanly on runtime initialization
if vim.fn.isdirectory(undodir) == 0 then
	vim.fn.mkdir(undodir, "p")
end

-- =============================================================================
--  [ Timeouts & Triggers ]
-- =============================================================================
opt.updatetime = 500 -- Fast diagnostic hover delay and swap write time (in ms)
opt.timeoutlen = vim.g.vscode and 1000 or 300 -- Lower timeout to trigger which-key menu rapidly
opt.ttimeoutlen = 0 -- Time in ms to wait for a terminal key code sequence
opt.autoread = true -- Automatically reload files if they changed outside Neovim
opt.autowrite = true -- Automatically write the file when moving away from a buffer

-- =============================================================================
--  [ Core System Behavior ]
-- =============================================================================
opt.hidden = true -- Allow switching away from buffers with unsaved changes
opt.errorbells = false -- Turn off annoying auditory error alerts
opt.backspace = "indent,eol,start" -- Better backspace behavior
