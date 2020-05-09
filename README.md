# mvndisp
A simple vim plugin for maven. *Requires vim-dispatch plugin*.

## Commands
### MvnInit
To create a maven project using the quickstart maven archetype. This command
prompts the caller to enter the groupId and aritfactId to create the project
 and changes the current directory to the created project root directory.
### MvnCompile
To compile the current maven project. The required subcommands are
#### all
To compile all submodules of the current maven project.
#### module
To compile the submodule to which the current buffer belongs to
### MvnClean
To clean the current maven project. The required subcommands are
#### all
To clean all submodules of the current maven project.
#### module
To clean the submodule to which the current buffer belongs to
### MvnTest
To run tests in the current maven project. The required subcommands are
#### all
To run tests in all submodules of the current maven project.
#### module
To run all tests in the submodule to which the current buffer belongs to
#### this
To run the test corresponding to current buffer

## Variables
### mvndisp_mvn_cmd
To set the mvn command. Defaults to 'mvn'. In case where
a pre-cmd needs, for example unset a variable before running mvn command, this
can be set to 'unset JAVA_TOOL_OPTIONS && mvn'
### mvndisp_settings_file 
Path to settings.xml. If not set then looks for file with name 'settings.xml'
in the project and uses irtf if found.
