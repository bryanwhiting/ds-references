# Useful terminal commands for a data scientist
A set of random terminal commands I'm recording while learning the terminal. I include the the `.bashrc` alias or function if I use it.

## Data
| heading | command | .bashrc
|---|---|---
| Preview contents of `.csv` | `head -n 10 path/to/file.csv` |

## Git / Folder management

| heading | command | .bashrc
|---|---|---
| Create `.gitignore` after `git init` (to only track a specific folder) | `echo \!scripts/* >> .gitignore` |
| Set up analysis | `mkdir data scripts results` | `alias mkdsd="mkdir data scripts results"`
| Change directory and list files | `cd path/ && ls` | `cdls() {cd "$@" && ls;}`
| List directories in a folder | | `alias lsd="ls -l | grep '^d'"`



# Other helpful resources:

* [datascienceatthecommandline.com](http://datascienceatthecommandline.com/)
