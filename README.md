ZSH2022
======

Forked from [zsh2000](https://github.com/markhilkert/zsh2022). This Powerline-influenced theme is designed with Ruby developers in mind. The main difference between this theme and zsh2000 is support for rbenv. This is my first project with shell scripting, so idk use at your own risk.

Features include rvm/rbenv prompt, git status and branch, current time, user, hostname, pwd, exit status, root and background job status.

### rbenv support

When you are in a folder with a `.ruby-version` and you have that ruby version installed, the version is deplayed in green on the right side of the screen.

<img width="651" alt="image" src="https://user-images.githubusercontent.com/46462767/155018079-a1c582be-b59b-47ec-ab38-3744a2383ff9.png">

If you do not have the ruby version installed that is listed in `.ruby-version`, the version is deplayed in red.

<img width="648" alt="image" src="https://user-images.githubusercontent.com/46462767/155018543-8aea23c4-0bbf-4d89-ba0e-734da09b7640.png">

Finally, if you're in a folder that doesn't have a `.ruby-version`, nothing is displayed.

<img width="649" alt="image" src="https://user-images.githubusercontent.com/46462767/155018753-9597371e-1839-4ee3-80eb-510518499244.png">

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

    export ZSH_2022_DISABLE_STATUS='true'

Disable git status on top of plain git clean/dirty

    export ZSH_2022_DISABLE_GIT_STATUS='true'

Disable RVM prompt

    export ZSH_2022_DISABLE_RVM='true'
