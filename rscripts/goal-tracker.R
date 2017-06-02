
# IDEAS:
# You have a start and end date, but you could also have a "number of times". So if it's something you only want to do 5 days a week, you could specify that
# TOOD: summary by week?
# TODO: g -l1 log goal for yesterday
# Todo: allow for future planning before the field day


args <- commandArgs(trailingOnly = T)
options(stringsAsFactors = F)
suppressMessages(library(dplyr))
suppressMessages(library(magrittr))

if (length(grep("Windows", sessionInfo()$running)) > 0) {
  system = "Windows"
  folder_path = "C:/Users/bwhiting/Dropbox/jrnl/garden"
} else {
  system = "Else"
  folder_path = "~/Dropbox/jrnl/garden"
}

seed_path <- file.path(folder_path, "seeds")

field_day <- "Sunday"

# Get date of previous field day (Sunday) 
day <-  Sys.Date()
prev.days <- seq(day - 6, day, by='day')
field_day_date <- prev.days[weekdays(prev.days)== field_day]
harvest_day_date <- field_day_date + 6


# Test for args
arg_ind_log <- grep("-l[0-9]?|-log[0-9]?", args)


if ("-help" %in% args) {
  cat("Options include:\n") 
  cat("    g -stream <name>: Add a new stream.\n") 
  cat("    g -seed <name>: Add a new seed.\n") 
  cat("    g -log <name1> <name2> ... <nameN>: Track streams, logs, and stones\n") 
  q()
}

# Add a new goal:
if ("-stream" %in% args) {
  # Ensure all the arguments are present. goal name | ndays
  
  # FIXME: Make sure the same stream can't be overlapping (no two streams with same name)
  
  if (length(args) <= 1) {
    cat("\nStream name:") 
    goal_name <- readLines(file("stdin"), 1)
  } else {
    goal_name = args[2] 
    cat("\nStream name:", goal_name, "\n") 
  }
  
  cat("Define your goal (must be binary):")
  desc <- readLines(file("stdin"), 1)
  if (length(desc) == 0 ) stop("Please enter a description.")
  
  cat("How many days:") 
  ndays <- as.numeric(readLines(file("stdin"), 1))
  
  # Create goal
  start <- Sys.Date()
  end <- start + ndays - 1 # Remove 1 because the start day counts as a possibility
  stream <- paste(goal_name, desc, start, end, sep = "|")
 
  # Append to file 
  filename <- file.path(folder_path, "streams.txt")
  con <- file(filename, 'a')
  cat(stream, file = con, sep = "\n", append = T)
  close(con)
  
  str <- paste("\n[Added new stream: '", goal_name,": ", desc, "' through ", as.character(end),".]\n", sep = "")
  cat(str) 
  
} else if ("-seed" %in% args | "-se" %in% args) {
  # FIXME: If there's already a seed of that name, reject it.
  # TODO: g -seed list. List all seeds
  # TODO: g -se -edit. Open file for editing using system command.
  
  # Get seed name 
  if (length(args) <= 1) {
    cat("\nSeed name:") 
    seed_name <- readLines(file("stdin"), 1)
  } else {
    seed_name = args[2] 
    cat("\nSeed name:", seed_name, "\n") 
  }
  
  # Get description from user
  if (length(args) <= 2) {
    cat("Describe your seed (must be binary):")
    desc <- readLines(file("stdin"), 1)
    if (length(desc) == 0 ) stop("Please enter a description.")
    q()
  } else {
    # If the user supplies multiple arguments, the rest of the argmuents are the description  
    desc <- paste(args[3:length(args)], collapse = " ") 
  }
  

  
  # Save out to text: seed_name | description
  seed <- paste(seed_name, desc, sep = "|")
  file_name <- file.path(seed_path, paste(field_day_date, "-seeds.txt", sep = ""))
  con <- file(file_name, 'a')
  cat(seed, file = con, sep = "\n", append = T)
  close(con)
  
  # Message user
  msg <- paste("\n[Added new seed: '", seed_name,": ", desc, 
               "' for field day ", as.character(field_day_date),".]\n", sep = "")
  cat(msg)
  

} else if (length(arg_ind_log) > 0) {
  # APPEND TO LOG --------------------------------------------
  # CONSIDER: I may want to prepend to the log file, so that it's easier to read? Not really necessary.
 
  # Pick the date depending on the log# (if it exists)
  test_fornum <- grep("-l[0-9]+|-log[0-9]+", args)
  if (length(test_fornum) > 0 ){
    logargs <- args[test_fornum]
    day_lag <- gsub("-l|-log", "", logargs) %>% as.numeric()
  } else {
    day_lag <- 0
  }
  log_date <- Sys.Date() - day_lag
  
  # Connect to log file
  filename <- file.path(folder_path, "log.txt")
  con <- file(filename, 'a')
  
  # Get every argument excep the log 
  to_log <- args[-arg_ind_log]
  
  # Save out to file
  for (a in to_log) {
    line <- paste(log_date, a, sep = "|")
    cat(line, file = con, sep = "\n", append = T)
  }
  close(con)
  
  msg <- paste("[Logs '", paste(to_log, collapse = ", "), "' added.]", sep = "")
  cat(msg)
  
} else {
  # Default: print goals 
   
  # Print active daily goals 
  filename <- file.path(folder_path, "streams.txt")
  df <- read.table(filename, sep = "|")
  names(df) <- c("stream", "description", "start", "end")
  df$start %<>% as.Date()
  df$end %<>% as.Date()
  
  df %<>% filter(Sys.Date() <= end)
  
  # Summary statistics
  filename <- file.path(folder_path, "log.txt")
  df_log <- read.table(filename, sep = "|", col.names = c("date", "finished"))
  df_log$date %<>% as.Date("%Y-%m-%d")
  df_log %<>% unique()
  
  # How many days have you done this stream?
  # group_by(stream) %>% 
  
  # A stone is just a successful goal
  # A stone is a count. How many stones can you collect? 
  for (i in 1:nrow(df)){
    # For each stream, count how many records lie between the dates 
    s <- df[i, ]
    df$stones[i] <- df_log %>% filter(finished == s$stream) %>%
      filter(date >=s$start, date <=s$end) %>%
      count() %>%  as.numeric()
    
    # 0/1 for today?
    df$thisday[i] <- df_log %>% filter(finished == s$stream) %>%
      filter(date == Sys.Date()) %>%
      count() %>% as.numeric()
    
    # Last 6 days. FIXME: Only go to #monday (or @gardening day)
    df$thisweek[i] <- df_log %>% filter(finished == s$stream) %>%
      filter(date >=s$start, date <=s$end) %>%
      filter(date >= Sys.Date() - 6) %>%
      count() %>%  as.numeric()
    
  } 
  # the quarry: How many stones are possible? Each day is a possibility. 5/29 and 5/30 are two days.
  df$today <- Sys.Date()
  df$possible <- as.numeric(df$today - df$start) + 1
  # stats
  df$streak <- paste(df$stones, "/", df$possible, sep = "")
  df$rate <- (df$stones / df$possible) %>% round(2)
  
  # What's left after today
  df$left <- as.numeric(df$end - df$today)
  df$total <- as.numeric(df$end - df$start) + 1
  
  # Prepare for output
  df$end %<>% format("%b %d")
  df$start %<>% format("%b %d")
  
  # remove detail
  df %<>% select(-today)
  if (!("-d" %in% args)) {
    # If you specify -d, that means you want detail
    df %<>% select(-description, -start, -end, -total,-rate, -stones, -possible)  
  }
  
  # Output
  if ("-d" %in% args){
    cat("\nCurrent streams (detailed)~~~\n")
  } else {
    cat("\nCurrent streams ~~~\n")
  }
  
  knitr::kable(df, align = "cccccccccc") %>% print()
  
  # TRACK SEEDS --------------------------------------------------- 
  # Alternatively, you could read in the path using the field_day_date
  filename <- list.files(seed_path, full.names = T) %>% tail(1)
  df_seeds <- read.table(filename, sep = "|", col.names = c("name", "desc"))
  
  # Compare with log: read in log, filter to this week. Create Harvested and harvest date fields
  df_log_field <- df_log %>% 
    filter(date >= field_day_date) %>%
    rename(name = finished, harvest_date = date) %>% 
    mutate(harvested = 1)
  
  df_seeds <- left_join(df_seeds, df_log_field, by = "name")
  
  # OUTPUT 
  df_seeds$harvested[is.na(df_seeds$harvested)] <- 0
  tot_harv <- paste(sum(df_seeds$harvested), "/", nrow(df_seeds), sep = "")
  
  df_seeds %<>% arrange(harvested, desc(harvest_date))
  colnames(df_seeds) <- c("seed", "desc", "harvest date", tot_harv)
  
  # cat("\nSeeds due", as.character(harvest_day_date))
  df_seeds %>% knitr::kable(align = "cccccc") %>% print()
  
  
}


