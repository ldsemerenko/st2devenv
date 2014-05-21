
if [ ! -z "${PS1}" ]; then
    INTERACTIVE="true"
fi

# User specific aliases and functions. (Auto imported by vagrant user.)

export EDITOR=/usr/bin/vim
export VISUAL=/usr/bin/vim

export PAGER=/usr/bin/less
export LESS="-XEq -r --shift 5"


# Set default bash prompt. capnames for tput command can be found in terminfo(4)
#export PS1='\n$(tput bold)vm: \h$(tput sgr0)\n\w \$ '
export PS1='\n$(tput bold)$(tput rev)vm$(tput sgr0)$(tput bold) \h$(tput sgr0)\n\w \$ '


# Ensure that dot files are listed at top of directory listing
export LC_COLLATE="C"

# Shell function is more practical for complex aliases
dir() { command ls -Flag --color=always "$@" | less ; }


DEFAULT_PYTHON_VER="py27"
toxtivate() {
    case $# in
        0)
            PYTHON_VER=${DEFAULT_PYTHON_VER}
            ;;
        1)
            PYTHON_VER=${1}
            ;;
        *)
            echo "usage: toxtivate [py27]"
            echo "where:"
            echo "py27   is the python version virtualenv to be activated"
            return
            ;;
    esac

    if [ ! -d .tox ]; then
        echo "error: no .tox folder found in pwd. Is this a code root?"
        echo "       Have you already prepared by running 'tox'?"
        return
    fi

    . .tox/${PYTHON_VER}/bin/activate
}


# Aliases
alias vi='vim'


##
#
# Massage ~vagrant to ensure home folder has replica of physical host user config
#
##
# Replicate /vagrant/.ssh/* to ~vagrant/.ssh if file does not exist in target.
if [ -d "/vagrant/.ssh" ]; then
    for file in `find /vagrant/.ssh -type f`; do
        filename=`basename ${file}`
        if [ ! -e "~vagrant/.ssh/${filename}" ]; then
            cp -n ${file} ~vagrant/.ssh/${filename}
        fi
    done
fi

if [ -f "/vagrant/git-completion.bash" ]; then
    if [ ! -e "~vagrant/git-completion.bash" ]; then
        cp -n /vagrant/git-completion.bash ~vagrant/git-completion.bash
    fi  
    grep -cq "git-completion.bash" ~/.bashrc
    if [ "${?}" = "1" ]; then
        echo "" >> ~vagrant/.bashrc
        echo "source ~/git-completion.bash" >> ~vagrant/.bashrc
    fi  
fi

if [ ${INTERACTIVE} ]; then
    git config -l | grep -q 'user.name' || git config -l | grep -q 'user.email'
    if [ "${?}" != "0" ]; then
        echo "Set git config values. For example:"
        echo "Set git user values: git config --global user.name 'Stormin Stanley'"
        echo "Set git user values: git config --global user.email 'stan@stackstorm.com'"
        echo "Set git core values: git config --global core.editor 'vim'"
    fi
fi

#
# Startup ssh-agent...
#
IDENTITY_FILES="${HOME}/.ssh/stackstorm_github_rsa"
if [ ${INTERACTIVE} ]  && [ ! -z "${IDENTITY_FILES}" ] && [ `whoami` != "root" ]; then
    export SSH_ENV_FILE="/tmp/`whoami`-ssh-env.sh" 

    if [ -s ${SSH_ENV_FILE} ]; then
        if [ `ps -x | grep ssh-agent | grep -v grep | wc -l` -eq "0" ]; then
            ssh-agent > ${SSH_ENV_FILE}
            . ${SSH_ENV_FILE}

            ssh-add ${IDENTITY_FILES}
        else        
            . ${SSH_ENV_FILE}
        fi    
    else    
        ssh-agent > ${SSH_ENV_FILE}
        . ${SSH_ENV_FILE}

        ssh-add ${IDENTITY_FILES}
    fi    
    unset SSH_ENV_FILE
fi
unset IDENTITY_FILES


VAGRANT_DIR="/vagrant"

if [ -d "${VAGRANT_DIR}" ] && [ `ls -A1 | wc -l` -gt "0" ]; then
    # Running in a vagrant VM
    
    VIMRC=".vimrc"

    if [ ! -e ~/${VIMRC} ] && [ -e ${VAGRANT_DIR}/${VIMRC} ]; then
        ln -s ${VAGRANT_DIR}/${VIMRC} ~/${VIMRC}
    fi

    # Change initial directory to /vagrant
    export PATH="$PATH:/vagrant/bin"
    cd /vagrant
fi
