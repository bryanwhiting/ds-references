
export PATH=$PATH:/c/Program\ Files/Rstudio/bin/
# Make data science directory
alias mkdsd="mkdir Scripts Temp Output Log"

# List directories
alias lsd="ls -l | grep '^d'"

# Change directories and list files
cdls() { cd "$@" && ls; }

# Add a todo note to my todo file using positional parameters
td() { echo -e "☐ $@\n$(cat ~/my.todo)" > ~/my.todo;}
tdn() { echo -e "☐ NAB: $@\n$(cat ~/my.todo)" > ~/my.todo;}

tent() { echo -e "TIME: $(date +%Y%m%d-%H%M%S) | PROJ: $1 | DESC: ${@:2:999}\n$(cat ~/my.todo)" > ~/my.todo;}

# Full recursive directory listing
alias lr='ls -R | grep ":$" | sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--/g'\'' -e '\''s/^/   /'\'' -e '\''s/-/|/'\'' | less'

excel() { "C:\Program Files (x86)\Microsoft Office\Office16\EXCEL.EXE" "$@";}
