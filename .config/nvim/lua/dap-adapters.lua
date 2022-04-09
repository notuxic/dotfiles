local dap = require('dap')

-- python
dap.adapters.python = {
	type = 'executable',
	command = 'python3',
	args = {'-m', 'debugpy.adapter'}
}

-- dap.configurations.python = {
-- 	{
-- 		type = 'python',
-- 		request = 'launch',
-- 		name = 'launch-current',
-- 		program = "${file}",
-- 		pythonPath = 'python3'
-- 	},
-- 	{
-- 		type = 'python',
-- 		request = 'launch',
-- 		name = 'launch-file',
-- 		program = function()
-- 			return vim.fn.input('path: ', vim.fn.getcwd() .. '/', 'file')
-- 		end
-- 	}
-- }


-- c/c++/rust
dap.adapters.lldb = {
	type = 'executable',
	command = 'lldb-vscode',
	name = 'lldb'
}

dap.adapters.c = dap.adapters.lldb
dap.adapters.cpp = dap.adapters.lldb
dap.adapters.rust = dap.adapters.lldb

-- dap.configurations.c = {
-- 	{
-- 		type = 'lldb',
-- 		request = 'launch',
-- 		name = 'launch-file',
-- 		program = function()
-- 			return vim.fn.input('path: ', vim.fn.getcwd() .. '/', 'file')
-- 		end,
-- 		cwd = "${workspaceFolder}",
-- 		stopOnEntry = false,
-- 	},
-- }

-- dap.configurations.cpp = dap.configurations.c
-- dap.configurations.rust = dap.configurations.c

