-- ╔══════════════════════════════════════════════════════════════╗
-- ║                  🛠️  LSP ENGINE & TOOL PROVISIONING            ║
-- ║     Automated tool binaries installation management layers    ║
-- ║             and standard language server definitions           ║
-- ╚══════════════════════════════════════════════════════════════╝

-- Native package registration handled directly by Neovim's built-in vim.pack system
vim.pack.add({
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },          -- Bridges the gap between mason.nvim and lspconfig
	{ src = "https://github.com/mason-org/mason.nvim" },                    -- Portable package manager for LSP servers, linters, and formatters
	{ src = "https://github.com/neovim/nvim-lspconfig" },                   -- Quickstart configurations for the Nvim LSP client
	{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" }, -- Automates installation of non-LSP packages
	{ src = "https://github.com/b0o/SchemaStore.nvim" },                    -- JSON/YAML schemas catalog adapter
})

-- Instantiate base core systems
require("mason").setup()
require("mason-lspconfig").setup({})

-- Setup tools installation manifest tracking states
require("mason-tool-installer").setup({
	ensure_installed = {
		"stylua",
		"oxlint", -- Blazing fast linter engine replacement for eslint
		"oxfmt",  -- Fast native layout rust-based formatter replacement for prettierd
		"lua_ls",
		"vtsls",  -- Upgraded high-performance TS/JS language server client
		"gopls",
		"sqls",
		"jsonls",
		"yamlls",
	},
	auto_update = false, -- Disable passive automated background runtime payload updates
	run_on_start = true, -- Execute schema discovery matching passes during initialization
})

-- LspAttach keymaps callback pipeline definition
vim.api.nvim_create_autocmd(
	"LspAttach",
	{ -- Use LspAttach autocommand to only map the following keys after the language server attaches to the current buffer
		group = vim.api.nvim_create_augroup("UserLspConfig", {}),
		callback = function(ev)
			-- Enable completion triggered by <c-x><c-o> context lookups
			vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

			-- Clean helper utility wrapper to inject buffer-local description settings
			local opts = function(desc)
				return { buffer = ev.buf, silent = true, desc = desc }
			end

			-- Code navigation API bindings
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts("Go to definition"))
			vim.keymap.set("n", "<leader><space>", vim.lsp.buf.hover, opts("Hover documentation"))
			vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts("Go to implementation"))
			vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts("Go to type definition"))
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts("Rename symbol"))
			vim.keymap.set("n", "gr", vim.lsp.buf.references, opts("Find references"))

			-- Interactive telemetry quickfix diagnostic helpers
			vim.keymap.set({ "n", "v" }, "<leader>ca", function()
				require("tiny-code-action").code_action()
			end, opts("Code action"))
			vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, opts("Format buffer"))

			-- Inline workspace context errors interface floating viewports
			vim.keymap.set("n", "<leader>d", function()
				vim.diagnostic.open_float({
					border = "rounded",
				})
			end, opts("Show diagnostics float"))
		end,
	}
)
