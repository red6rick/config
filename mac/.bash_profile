# if i ever re-install imagemagick...
#export MAGICK_HOME="$HOME/ImageMagick-6.7.5"
#export DYLD_LIBRARY_PATH="$MAGICK_HOME/lib"

# colors in terminal
# https://token2shell.com/howto/change-colors/
# not in macoc

PATH=$PATH:~/bin
PATH=$(brew --prefix coreutils)/libexec/gnubin:$PATH
export PATH=/usr/local/opt/ruby/bin:$PATH

  export LDFLAGS="-L/usr/local/opt/ruby/lib"
  export CPPFLAGS="-I/usr/local/opt/ruby/include"
  export PKG_CONFIG_PATH="/usr/local/opt/ruby/lib/pkgconfig"

# emacs etc
alias em='/Applications/Emacs.app/Contents/MacOS/bin/emacsclient -n'
alias dirtree="ls -R | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//–/g' -e 's/^/ /' -e 's/-/|/'"

dirinfo() {
    du -ah "$1" | sort -rh | head -n 20
}

#ssh-add .ssh/forth_rsa
#ssh-add .ssh/pi_rsa
#ssh-add .ssh/pogo_rsa
#alias forth.com='ssh rick@forth.com'

# to cat with "mp4box -cat foo1.mp4 -cat foo2.mp4 foo3.mp4"

alias adb=~/projects/fire/android-sdk-macosx/platform-tools/adb
alias fastboot=~/projects/fire/android-sdk-macosx/platform-tools/fastboot

alias play='mame -rompath /pub/games/mame/roms -cfg_directory ~/.mame/cfg'
alias p='python3 $@'
alias python='python3 $@'

alias cd..='cd ../'                         # Go back 1 directory level (for fast typers)
alias ..='cd ../'                           # Go back 1 directory level
alias ...='cd ../../'                       # Go back 2 directory levels
alias .3='cd ../../../'                     # Go back 3 directory levels
alias .4='cd ../../../../'                  # Go back 4 directory levels
alias .5='cd ../../../../../'               # Go back 5 directory levels
alias .6='cd ../../../../../../'            # Go back 6 directory levels
nd () { mkdir -p "$1" && cd "$1"; }        # mcd:          Makes new Dir and jumps inside
alias lr='ls -R | grep ":$" | sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--/g'\'' -e '\''s/^/   /'\'' -e '\''s/-/|/'\'' | less'

bind "set completion-ignore-case on"
bind "set show-all-if-ambiguous on"

export NNN_TMPFILE="/tmp/nnn"

n() {
        nnn "$@"

        if [ -f $NNN_TMPFILE ]; then
                . $NNN_TMPFILE
                rm -f $NNN_TMPFILE > /dev/null
        fi
}

alias rebash='source ~/.bash_profile'

######################################################################

function bc() {
    /Applications/Beyond\ Compare.app/Contents/MacOS/bcomp "$@" 2>/dev/null &
    disown
}

######################################################################

source /Volumes/pub/Users/rcvn/Library/Preferences/org.dystroy.broot/launcher/bash/br

##
# Your previous /Volumes/pub/Users/rcvn/.bash_profile file was backed up as /Volumes/pub/Users/rcvn/.bash_profile.macports-saved_2020-02-18_at_19:42:30
##

# MacPorts Installer addition on 2020-02-18_at_19:42:30: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.

