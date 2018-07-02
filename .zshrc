#======== PATH =======#

export PATH=$HOME/bin:~/bin:/usr/local/bin:$PATH
export ZSH=/Users/adamlancaster/.oh-my-zsh
export PATH="${PATH}:./node_modules/.bin"


#===================== THEME =====================#

ZSH_THEME="refined"
autoload -U promptinit; promptinit
prompt pure

#===================== SETTINGS ================#

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="dd.mm.yyyy"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Preferred editor for local and remote sessions
 if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='vim'
 else
   export EDITOR='vim'
 fi

#============== PLUGINS ====================#

plugins=(git)

source $ZSH/oh-my-zsh.sh

#================= ENV VARS ================#

# our env vars file can be found in 1password
# some are sensitive so they are stored in the
# unsuspecting file name here:

if [ -f ~/.scunthorpe_history ]; then
  source ~/.scunthorpe_history
fi

#================= Aliases ===============#

# Saucey aliases

if [ -f ~/dotfiles/.shell_aliases ]; then
  source ~/dotfiles/.shell_aliases
fi

#================ OTHER =================#

. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash
