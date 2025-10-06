local utils = require("mvn_wrapper.utils")
local M = {}

local mvn_generate = function(opts)
	local group_id = vim.fn.input("Enter group id: ")
	local artifact_id = vim.fn.input("Enter artifact id: ")
	local version = "1.0.0-SNAPSHOT"

	local command = "mvn -B archetype:generate"
	command = command .. " -DarchetypeGroupId=org.apache.maven.archetypes"
	command = command .. " -DarchetypeArtifactId=maven-archetype-quickstart"
	command = command .. " -DarchetypeVersion=1.4 -DgroupId=" .. group_id
	command = command .. " -DartifactId=" .. artifact_id
	command = command .. " -Dversion=" .. version .. " -DinteractiveMode=false"

	local result = vim.fn.mkdir(artifact_id, "", "0o755")
	if result == 0 then
		print("Error creating directory " .. artifact_id)
		return
	end

	utils.run_command(command)
	vim.api.nvim_set_current_dir("./" .. artifact_id)
end

local mvn_compile = function(opts)
	local command = "mvn -B clean install"

	utils.run_command(command)
end

local mvn_test = function(opts)
	local command = "mvn -B test"

	utils.run_command(command)
end

function M.setup()
	vim.api.nvim_create_user_command("MvnInit", mvn_generate, {
		nargs = "?",
		desc = "Generate mvn project",
	})
	vim.api.nvim_create_user_command("MvnCompile", mvn_compile, {
		nargs = "?",
		desc = "Compile mvn project",
	})
	vim.api.nvim_create_user_command("MvnTest", mvn_test, {
		nargs = "?",
		desc = "Test mvn project",
	})
end

return M
