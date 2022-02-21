ZSH2022
======

Forked from [zsh2000](https://github.com/markhilkert/zsh2022). This theme is designed with Ruby developers in mind. The main difference between this theme and zsh2000 is support for rbenv.

Powerline influenced zsh theme with rvm/rbenv prompt, git status and branch, current time, user, hostname, pwd, exit status, root and background job status.

### rbenv support



### Prerequisites

Install your favorite version of
[Powerline-patched fonts](https://github.com/Lokaltog/powerline-fonts)

### Installation

    git clone https://github.com/markhilkert/zsh2022.git
    ln -s zsh2022.zsh-theme ~/.oh-my-zsh/themes/zsh2022.zsh-theme

Modify ~/.zshrc setting

    ZSH_THEME="zsh2022"

### Configuration

Place these above this line in your ~/.zshrc:

    ZSH_THEME="zsh2022"

Disable the right hand side prompt entirely

    export ZSH_2022_DISABLE_RIGHT_PROMPT='true'

Disable user@hostname

    export ZSH_2022_DEFAULT_USER='YOUR_USER_NAME'

Disable display of

1. exit status of your last command
2. whether or not you are root
3. whether or not there are background jobs running

by adding

    export ZSH_2022_DISABLE_STATUS='true'

Disable git status on top of plain git clean/dirty

    export ZSH_2022_DISABLE_GIT_STATUS='true'

Disable RVM prompt

    export ZSH_2022_DISABLE_RVM='true'
