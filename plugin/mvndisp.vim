" vim plugin for maven compile/test using Dispatch vim plugin
if exists('g:loaded_mvndisp')
	finish
endif
let g:loaded_mvndisp = 1

" Get path of this plugin file (resolving symlinks)
let s:spath = fnamemodify(resolve(expand('<sfile>:p')), ':h')
let s:tp_path = fnamemodify(s:spath, ':h') . '/archetypes/'

" Read user settings are initialize with defaults
let s:mvnCmd = exists('g:mvndisp_mvn_cmd') ? g:mvndisp_mvn_cmd : "mvn"
let s:mvnExtraFlgs = exists('g:mvndisp_extra_flags') ? g:mvndisp_extra_flags : ""
let s:mvnCompileCmd = exists('g:mvndisp_compile_cmd') ? g:mvndisp_compile_cmd : 'package'

" Function to get the sub commands for clean/compile command
fun! s:MvnGetOptions(ArgLead, CmdLine, CursorPos)
	let l:options = ['module', 'all']
	return filter(l:options, 'v:val =~ a:ArgLead')
endfun

" Function to get the sub commands for test command
fun! s:MvnGetTestOptions(ArgLead, CmdLine, CursorPos)
	let l:options = ['module', 'all', 'this']
	return filter(l:options, 'v:val =~ a:ArgLead')
endfun

" Function to get the sub commands for init command
fun! s:MvnGetInitOptions(ArgLead, CmdLine, CursorPos)
	let l:directories = glob(s:tp_path . "*", 1, 1)
	call map(l:directories, 'fnamemodify(v:val, ":t")')
	return filter(l:directories, 'v:val =~ a:ArgLead')
endfun

" Plugin Commands definitions
if !exists(":MvnCompile")
	command -nargs=1 -complete=customlist,s:MvnGetOptions MvnCompile :call s:MvnCompile(<q-args>)
endif
if !exists(":MvnTest")
	command -nargs=1 -complete=customlist,s:MvnGetTestOptions MvnTest :call s:MvnTest(<q-args>)
endif
if !exists(":MvnClean")
	command -nargs=1 -complete=customlist,s:MvnGetOptions MvnClean :call s:MvnClean(<q-args>)
endif
if !exists(":MvnInit")
	command -nargs=1 -complete=customlist,s:MvnGetInitOptions MvnInit :call s:MvnInit(<q-args>)
endif

" Function to get the module name of the current file. Searches for
" the directory upwords that contains pom.xml. Returns the maven
" compile flag to compile this module
fun! s:MvnGetThisModule()
	let l:parentPom = findfile("pom.xml", ".;")
	let l:parentDir = fnamemodify(l:parentPom, ":h")
	let l:cmplFlags = ""
	if l:parentDir != "."
		let l:cmplFlags =  l:cmplFlags . " -pl " . l:parentDir
	endif
	return l:cmplFlags
endfun

fun! s:MvnGetSettings()
	if exists('g:mvndisp_settings_file')
		return " -s " . g:mvndisp_settings_file
	else
		return findfile("settings.xml", ";") != "" ? " -s " . findfile("settings.xml", ";") : ""
	endif
endfun

" Function to call mvn with supplied command flags through Dispatch
fun! s:MvnExeCommon(compileCommand, compileFlags)
	let l:flags = " -B" . a:compileFlags . s:MvnGetSettings()
	exe 'Dispatch' s:mvnCmd a:compileCommand l:flags s:mvnExtraFlgs
endfun

" Function to compile all modules of the project
fun! s:MvnCompile(subCmd)
	let l:flgs = a:subCmd == "module" ? s:MvnGetThisModule() : ""
	let l:flgs .= " -DskipTests"
	call s:MvnExeCommon(s:mvnCompileCmd, l:flgs)
endfun

" Function to compile and run tests in current file
fun! s:MvnTest(subCmd)
	let l:flgs = ""
	if a:subCmd == "this"
		let l:flgs .= s:MvnGetThisModule() . " -Dtest=" . expand("%:t:r")
	elseif a:subCmd == "module"
		let l:flgs .= s:MvnGetThisModule()
	endif
	call s:MvnExeCommon("test", l:flgs)
endfun

" Function to call mvn clean with supplied flags through Dispatch
fun! s:MvnClean(subCmd)
	let l:flgs = a:subCmd == "module" ? s:MvnGetThisModule() : ""
	call s:MvnExeCommon("clean", l:flgs)	
endfun

fun! s:MvnInit(subCmd)
	echom "Initializing archetype" . a:subCmd

	"system("mvn clean install -f " . s:tp_path . a:subCmd)
	let l:pom_path = s:tp_path . a:subCmd
	let l:result = system("mvn install clean -f " . l:pom_path)
	redraw
	"exe 'Dispatch mvn install clean -B -f '  l:pom_path

	let l:groupId = input('Enter Group Id: ')
	let l:artifactId = input('Enter Artifact Id: ')
	redraw
	echom "Initializing..."

	let l:flgs = " -DgroupId=" . l:groupId . " -DartifactId=" . l:artifactId
	let l:flgs .= " -DarchetypeGroupId=org.arunachalashiva.tools"
        let l:flgs .= " -DarchetypeArtifactId=" . a:subCmd
        let l:flgs .= " -DarchetypeVersion=1.0.0-SNAPSHOT"
        let l:flgs .= " -DinteractiveMode=false"
	let l:cmd = "mvn -B archetype:generate" . l:flgs
	let l:result = system(l:cmd)
	redraw
	exe 'cd ' . l:artifactId
	echom "Created " . l:artifactId
endfun
