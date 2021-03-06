set -g -x PATH /usr/local/bin $PATH
set -g -x fish_greeting ''
# turn off the fancy font
# set -g theme_powerline_fonts no
# use nerd font
set -g theme_nerd_fonts yes
# set JAVA_HOME
set -Ux JAVA_HOME (/usr/libexec/java_home)
# rbenv
# status --is-interactive; and source (rbenv init -|psub)
set -Ux EDITOR emacs
if test -d ~/Library/Android/sdk
    set -g -x ANDROID_HOME ~/Library/Android/sdk
    set -g -x PATH $ANDROID_HOME/platform-tools $PATH
    set -g -x PATH $ANDROID_HOME/build-tools/27.0.3 $PATH
end
