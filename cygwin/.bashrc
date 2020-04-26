# notes on configuring git for beyond compare:
# gui.recentrepo=C:/projects/rocsim
# core.editor=nano
# user.name=Rick VanNorman
# user.email=rick.vannorman@stratolaunch.com
# diff.tool=bc
# difftool.bc.path=c:/Program Files/Beyond Compare 4/bcomp.exe
# difftool.prompt=false
#
# git config --global core.editor "c:/emacs/bin/emacsclient.exe"

# Diff
# At a Windows command prompt, enter the commands:
#   git config --global diff.tool bc
#   git config --global difftool.bc.path "c:/usr/bc4/bcomp.exe"
# Note: For Git versions older than 2.2 (git --version) replace "bc" with "bc3" in the above instructions.
# 
# 3-way Merge Pro only
# At a Windows command prompt, enter the commands:
#   git config --global merge.tool bc
#   git config --global mergetool.bc.path "c:/usr/bc4/bcomp.exe"
#   git config --global mergetool.bc.path "c:/usr/bc4/bcomp.exe"
# Note: For Git versions older than 2.2.0 (git --version) replace "bc" with "bc3" in the above instructions.
# 
# Launching Diffs and Merges
# File Diff:
#   git difftool filename.ext
# 
# Folder Diff:
#   git difftool --dir-diff
# 
# 3-way Merge:
#   git mergetool filename.txt
# 
# Advanced Settings
# To disable the "Launch 'bc3' [Y/n]?" prompt, run the command:
#   git config --global difftool.prompt false
# 
# Git's default settings retain merge files with *.orig extensions after a successful merge.  To disable this safety feature and automatically delete *.orig files after a merge, run the command:
#   git config --global mergetool.keepBackup false
# 


PS1="`__git_ps1` \W $ "
PS1="\W $ "

function em() {
    ALIVE="$(ps -W|grep -i emacs)"
    if [ "$ALIVE" ]; then
        /c/emacs/bin/emacsclientw.exe -n "$@" &
    else
        /c/emacs/bin/runemacs "$@" &
    fi
}

function pdocx() {
    INFILE=$1
    OUTFILE=${INFILE%.*}.docx
    ~/pandoc/pandoc.exe $INFILE -o $OUTFILE
}    

function gfm() {
    INFILE=$1
    OUTFILE=${INFILE%.*}.html
    ~/pandoc/pandoc.exe $INFILE -f gfm -o $OUTFILE
}    

function sf()  {
    /c/strato/bravo/swiftforth/bin/sf.exe "$@" &
    disown
}
function sfx() {
    /c/strato/bravo/swiftforth/bin/sf.exe requires sfx "$@" &
    disown
}
function f()   {
    /c/strato/bravo/swiftforth/bin/sf.exe include c:\\rcvn\\rcvn.f "$@" &
    disown
}

function fx()   {
    /c/forthinc/swiftforth/bin/sf.exe include c:\\rcvn\\forthbox\\rcvn.f "$@" &
    disown
}

function bc() {
    /c/usr/bc4/bcompare.exe "$@" &
    disown
}

function gitbc() {
    git difftool "$@" &
    disown
}

function gnuplot() {
    /c/rcvn/gnuplot/bin/wgnuplot.exe &
    disown
}



function new() {
    /c/Program\ Files/Git/git-bash.exe --cd-to-home &
    disown
}


#alias em='/c/emacs/bin/emacsclientw.exe -n'
#alias emacs='/c/emacs/bin/runemacs.exe'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias cd..='cd ..'

alias rebash='source ~/.bashrc'

alias projects='cd /c/strato'
alias home='cd ~/'
alias go='./go.bat'

alias api='start /c/forthinc/swiftForth/doc/win32api.chm'

alias ll='ls -l'
alias ls='ls -F --show-control-chars'

alias pandoc='~/pandoc/pandoc.exe'

alias c0='echo -ne "\033]11;#c0c0c0\007"'
alias c1='echo -ne "\033]11;#ffc0c0\007"'
alias c2='echo -ne "\033]11;#c0d0c0\007"'
alias c3='echo -ne "\033]11;#ffffc0\007"'
alias c4='echo -ne "\033]11;#c0c0ff\007"'
alias c5='echo -ne "\033]11;#ffc0ff\007"'
alias c6='echo -ne "\033]11;#c0ffff\007"'
alias c7='echo -ne "\033]11;#ffffff\007"'

# export PS1="\[\033]0;$TITLEPREFIX:$PWD\007\]\n\[\033[32m\]\u@\h \[\033[35m\]$MSYSTEM \[\033[33m\]\w\[\033[36m\]`__git_ps1`\[\033[0m\]\n$"

alias bravo='cd /c/strato/bravo'
alias client='cd /c/strato/bravo/sim/gui/client; c5'
alias server='cd /c/strato/bravo/sim/gui/server; c3'





function serv() {
    cd /c/strato/Demo/1.0D/Flight\ Simulation
    ./multi-sim.exe &
    cd -
    }
alias csim='/c/strato/demo/csim.exe &'
alias fsim='/c/strato/demo/fsim.exe &'

