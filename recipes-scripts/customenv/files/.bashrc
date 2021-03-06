alias qq='exit'
alias pcount='ps ax | wc -l'

export PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u\[\033[00m\]@\[\033[01;33m\]\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# Expand PATH to where apps will be
export PATH=$PATH:/usr/bin/apps:\
/usr/bin/apps/fallingblocks:\
/usr/bin/apps/demotouch:\
/usr/bin/apps/mouseevents:\
/etc/scripts

alias areq='if [[ -z $(diff $1 $2) ]]; then echo YES; else echo NO;fi'
alias ft='for file in $(ls); do echo -n "[$file]"; file $file | cut -d":" -f2-; done'
alias count='wc -l'

# Variants of greps
alias wgrep='grep -w'
alias igrep='grep -i'
alias vgrep='grep -v'

export LS_OPTIONS='--color=auto'
eval `dircolors`
alias ls='ls $LS_OPTIONS'
alias ll='ls $LS_OPTIONS -l'
alias l='ls $LS_OPTIONS -lA'

if [ -f ${HOME}/.qtenv ]
then
	. ${HOME}/.qtenv
fi

# Workaroung with qtkeyboard
if [ -n ${QT_IM_MODULE} ]
then
	unset QT_IM_MODULE
fi

# Sort env
alias env='env | sort'
# Opkg related
alias ouu='opkg update && opkg upgrade'

# Workaround with D-Bus setup
export $(dbus-launch)
