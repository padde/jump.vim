" jump.vim - Change your pwd with Autojump 
" Maintainer: Patrick Oscity <patrick.oscity@gmail.com>
" Version:    0.0.1

if !exists("g:autojump_executable")
  for candidate in [
    \$HOME."/.autojump/etc/profile.d/autojump.sh",
    \$HOME."/.autojump/share/autojump/autojump.sh",
    \$HOME."/.nix-profile/etc/profile.d/autojump.sh",
    \"/usr/share/autojump/autojump.sh",
    \"/etc/profile.d/autojump.sh",
    \"/etc/profile.d/autojump.sh",
    \"/usr/local/share/autojump/autojump.sh",
    \"/opt/local/etc/profile.d/autojump.sh",
    \system("brew --prefix | tr -d '\r\n'")."/etc/autojump.sh",
    \]
    if filereadable(candidate)
      let g:autojump_executable = candidate
      break
    endif
  endfor
endif

function! s:JumpGuard()
  if !exists("g:autojump_executable")
    echoerr 'autojump not found - please install it or set g:autojump_executable'
    return 1
  endif
  return 0
endfunction

function! s:JumpCommand(cmd, args)
  return system("sh -c 'source " . g:autojump_executable . " && " . a:cmd . " " . a:args . " > /dev/null && pwd'")
endfunction

function! s:JumpExtractArgs(rawArgs)
  let args = ''
  if len(a:rawArgs) > 0
    let args = join(a:rawArgs, " ")
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
