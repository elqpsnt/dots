return {
	cmd = function(dispatchers, config)
		local cmd = "oxfmt"
		if (config or {}).root_dir then
			local local_cmd = vim.fs.joinpath(config.root_dir, "node_modules/.bin", cmd)
			if vim.fn.executable(local_cmd) == 1 then
				cmd = local_cmd
			end
		end

		local args = { cmd, "--lsp" }
		local project_config = nil

		if config and config.root_dir then
			for _, name in ipairs({ ".oxfmtrc.json", ".oxfmtrc.jsonc", "oxfmt.config.ts" }) do
				local candidate = vim.fs.joinpath(config.root_dir, name)
				if vim.fn.filereadable(candidate) == 1 then
					project_config = candidate
					break
				end
			end
		end

		-- Fallback to global config if no project config is found
		if not project_config then
			for _, name in ipairs({ ".oxfmtrc.jsonc", ".oxfmtrc.json" }) do
				local candidate = vim.fs.joinpath(vim.fn.expand("~"), name)
				if vim.fn.filereadable(candidate) == 1 then
					project_config = candidate
					break
				end
			end
		end

		if project_config then
			table.insert(args, "--config")
			table.insert(args, project_config)
		end

		return vim.lsp.rpc.start(args, dispatchers)
	end,
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"toml",
		"json",
		"jsonc",
		"json5",
		"yaml",
		"html",
		"vue",
		"handlebars",
		"css",
		"scss",
		"less",
		"graphql",
		"markdown",
	},
	workspace_required = true,
	root_dir = function(bufnr, on_dir)
		local fname = vim.api.nvim_buf_get_name(bufnr)
		local stop = vim.fs.dirname(vim.fn.expand("$HOME"))
		local root_markers = {
			".oxfmtrc.json",
			".oxfmtrc.jsonc",
			"oxfmt.config.ts",
			"vite.config.ts",
			"package.json",
			".git",
		}
		local marker = vim.fs.find(root_markers, { path = fname, upward = true, stop = stop })[1]
		on_dir(marker and vim.fs.dirname(marker) or nil)
	end,
}
