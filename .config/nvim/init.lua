-- ╔══════════════════════════════════════════════════════════════╗
-- ║                  🌱  NEOVIM ROOT INIT LAYER                   ║
-- ║         Main runtime entry point and configuration boot       ║
-- ╚══════════════════════════════════════════════════════════════╝

-- Source the central configuration tree. This initializes your core options,
-- keymaps, auto-commands, and global environment options.
require("config")

-- Boot and initialize the package management framework layer, handling all
-- lazy plugin specifications and third-party extensions.
require("packs")
