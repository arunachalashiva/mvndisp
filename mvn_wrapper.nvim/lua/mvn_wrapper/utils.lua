local M = {}

local function append_to_bufer(output_lines, data)
	for _, line in ipairs(data) do
		if line ~= "" then
			table.insert(output_lines, line)
		end
	end
end

M.run_command = function(command)
	local output_lines = {}

	vim.fn.jobstart(command, {
		on_stdout = function(_, data)
			append_to_bufer(output_lines, data)
		end,

		on_stderr = function(_, data)
			append_to_bufer(output_lines, data)
		end,

		on_exit = function(_, exit_code)
			vim.schedule(function()
				if exit_code ~= 0 then
					print("Command failed with exit code: " .. exit_code)
				else
					print("Command finished successfully.")
				end
				local buf = vim.api.nvim_create_buf(false, true)
				vim.api.nvim_buf_set_lines(buf, 0, -1, false, output_lines)
				local width = math.floor(vim.o.columns * 0.8)
				local height = math.floor(vim.o.lines * 0.8)
				local row = math.floor((vim.o.lines - height) / 2)
				local col = math.floor((vim.o.columns - width) / 2)
				local opts = {
					relative = "editor",
					width = width,
					height = height,
					row = row,
					col = col,
					style = "minimal",
					border = "single",
				}
				vim.api.nvim_open_win(buf, true, opts)
			end)
		end,
	})
end
return M
