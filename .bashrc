# PATH ------------------------------------------------------------
# FIXME ONLY RUN ON WINDOWS
# TODO ONLY RUN ON WINDOWS
export PATH=$PATH:/c/Program\ Files/Rstudio/bin/
export PATH=$PATH:/c/Users/bwhiting/Documents/R/R-3.3.3/bin/
export PATH=$PATH:/c/Program\ Files\ \(x86\)/Google/Chrome/Application

# ALIAS ------------------------------------------------------------
# Helpful urls
alias gmail="chrome.exe www.gmail.com"
alias five="chrome.exe www.fivethirtyeight.com"
alias datatau="chrome.exe www.datatau.com"

# Helpful aliases
# List
alias ll="ls -lhA"
# Make data science directory
alias mkdsd="mkdir Scripts Temp Output Log"
# List directories
alias lsd="ls -l | grep '^d'"
# Update bash
alias updb="source ~/.bash_profile"
# Full recursive directory listing
alias lr='ls -R | grep ":$" | sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--/g'\'' -e '\''s/^/   /'\'' -e '\''s/-/|/'\'' | less'
# Open explorer
# FIXME: windows only
alias exp='explorer .'

# History
# alias bashhist="history | awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl |  head -n10"

# FUNCTIONS ------------------------------------------------------------
# This function launches google with your search terms. It also assumes you may have a flag
# alias goog="chrome.exe www.google.com"
goog(){
  flag=$1;
  [[ $1 = ${1#-} ]] && unset $flag || shift;
  concat=$(printf '%s+' ${@});
  chrome.exe www.google.com/\#q=${concat%+};
}

# Search all files using a regular expression
# search "^\*"  will search for all comments
function search (){
  # -r recursive -n return line -i ignore case -I don't search binaries
  egrep -rniI $1 . | sort | uniq
}

# Make directory, and go into it
mcd () {
    # -p will 
    mkdir -p $1
    cd $1
}

# Change directories and list files
cdl() { cd "$@" && ls; }

# Add a todo note to my todo file using positional parameters
td() { echo -e "☐ $@\n$(cat /c/Users/bwhiting/my.todo)" > /c/Users/bwhiting/my.todo;}
tdn() { echo -e "☐ @NAB: $@\n$(cat /c/Users/bwhiting/my.todo)" > /c/Users/bwhiting/my.todo;}

t() { echo -e "TIME: $(date +%Y-%m-%d_%H:%M:%S) | PROJ: $1 | DESC: ${@:2:999}\n$(cat ~/timesheet.txt)" > ~/timesheet.txt;}
gt() { RScript.exe "/h/github/ds-references/rscripts/time-entry.R";}

# Add a note
nt() { echo -e "$(date +%Y-%m-%d) | ${@:1:999}\n$(cat ~/notes.md)" > ~/notes.md;}


# Open an Excel file from the command line
excel() { "C:\Program Files (x86)\Microsoft Office\Office16\EXCEL.EXE" "$@";}
