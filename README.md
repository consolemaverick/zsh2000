ZSH2000
======

![alt tag](https://raw.githubusercontent.com/maverick2000/zsh2000/master/demo.png)

![alt tag](https://raw.githubusercontent.com/maverick2000/zsh2000/master/demo2.png)

Powerline looking zsh theme with rvm prompt, git status and branch, current time, user, hostname, pwd, exit status, root and background job status.

Influenced heavily by [agnoster's theme](https://gist.github.com/3712874) and [jeremyFreeAgent's theme](https://github.com/jeremyFreeAgent/oh-my-zsh-powerline-theme)

###Prerequisites###

Install your favorite version of
[Powerline-patched fonts](https://github.com/Lokaltog/powerline-fonts)

###Installation###

    git clone https://github.com/maverick2000/zsh2000.git
    ln -s zsh2000.zsh-theme ~/.oh-my-zsh/themes/zsh2000.zsh-theme

###Configuration###

In order to disable the right hand side prompt entirely add the following to your ~/.zshrc

    export ZSH_2000_DISABLE_RIGHT_PROMPT='true'

In order to disable user@hostname add the following to your ~/.zshrc

    export ZSH_2000_DEFAULT_USER='YOUR_USER_NAME'

In order to disable display of:

1. exit status of your last command
2. whether or not you are root
3. whether or not there are background jobs running 

add the following to your ~/.zshrc

    export ZSH_2000_DISABLE_STATUS='true'

In order to disable git status on top of plain git clean/dirty add the following to your ~/.zshrc

    export ZSH_2000_DISABLE_GIT_STATUS='true'

In order to disable RVM prompt add the following to your ~/.zshrc

    export ZSH_2000_DISABLE_RVM='true'
