" jump.vim - Change your pwd with Autojump 
" Maintainer: Patrick Oscity <patrick.oscity@gmail.com>
" Version:    0.0.1

call system("which autojump")
let s:autojump_executable_missing = v:shell_error

function! s:JumpGuard()
  if s:autojump_executable_missing
    echoerr 'please install autojump in order to use this command'
  endif
  return s:autojump_executable_missing
endfunction

function! s:JumpCommand(cmd, args)
  return system("echo '. /usr/local/etc/autojump.bash && " . a:cmd . " " . a:args . " > /dev/null && pwd' | bash")
endfunction

function! s:JumpExtractArgs(rawArgs)
  let args = ''
  if len(a:rawArgs) > 0
    let args = a:rawArgs[-1]
  endif
  return args
endfunction

function! s:Jump(cmd, ...)
  if s:JumpGuard()
    return
  endif
  let args = s:JumpExtractArgs(a:000)
  let path = s:JumpCommand(a:cmd, args)
  if v:shell_error != 0
    echo "directory '" . args . "' not found" 
  endif
endfunction

function! s:JumpCd(cmd, ...)
  if s:JumpGuard()
    return
  endif
  let args = s:JumpExtractArgs(a:000)
  let path = s:JumpCommand(a:cmd, args)
  if v:shell_error != 0
    echo "directory '" . args . "' not found" 
  else
    exe 'cd '.escape(path, ' ')
    pwd
  endif
endfunction

function! s:Cd(path)
  call s:JumpCommand('autojump -a', a:path)
  exe 'cd '.a:path
endfunction

function! s:JumpCompletion(A,L,P)
  let completions = []
  for completion in split(system('autojump --complete '.a:A), "\n")
    call add(completions, substitute(completion, '^.*__\d__', '', ''))
  endfor
  return completions
endfunction

command! -complete=customlist,s:JumpCompletion -nargs=* J call s:JumpCd('j', <f-args>)
command! -complete=customlist,s:JumpCompletion -nargs=* Jc call s:JumpCd('jc', <f-args>)
command! -complete=customlist,s:JumpCompletion -nargs=* Jo call s:Jump('jo', <f-args>)
command! -complete=customlist,s:JumpCompletion -nargs=* Jco call s:Jump('jco', <f-args>)
command! -complete=file -nargs=1 Cd call s:Cd(<f-args>)
