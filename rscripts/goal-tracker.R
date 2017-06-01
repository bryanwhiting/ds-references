
# IDEAS:
# You have a start and end date, but you could also have a "number of times". So if it's something you only want to do 5 days a week, you could specify that
# TOOD: summary by week?


args <- commandArgs(trailingOnly = T)
options(stringsAsFactors = F)
suppressMessages(library(dplyr))
suppressMessages(library(magrittr))

field_day <- "Sunday"


# Add a new goal:
if ("-stream" %in% args) {
  # Ensure all the arguments are present. goal name | ndays
  
  # FIXME: Make sure the same stream can't be overlapping (no two streams with same name)
  
  if (length(args) <= 1) {
    cat("\nStream name:") 
    goal_name <- readLines(file("stdin"), 1)
  } else {
    goal_name = args[2] 
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
  con <- file("~/Dropbox/jrnl/streams.txt", 'a')
  cat(stream, file = con, sep = "\n", append = T)
  close(con)
  
  str <- paste("\n[Added new stream: '", goal_name,": ", desc, "' through ", as.character(end),".]\n", sep = "")
  cat(str) 
  
} else if ("-seed" %in% args) {
  
  # Get seed name 
  if (length(args) <= 1) {
    cat("\nSeed name:") 
    seed_name <- readLines(file("stdin"), 1)
  } else {
    seed_name = args[2] 
  }
  
  # Get description from user
  cat("Describe your seed (must be binary):")
  desc <- readLines(file("stdin"), 1)
  if (length(desc) == 0 ) stop("Please enter a description.")
  
  # Get date of previous field day (Sunday) 
  day <-  Sys.Date()
  prev.days <- seq(day - 6, day, by='day')
  field_day_date <- prev.days[weekdays(prev.days)== field_day]
  
  # Save out to text: seed_name | description
  seed <- paste(seed_name, desc, sep = "|")
  file_name <- file.path("~/Dropbox/jrnl", paste(field_day_date, "-seeds.txt", sep = ""))
  con <- file(file_name, 'a')
  cat(seed, file = con, sep = "\n", append = T)
  close(con)
  
  # Message user
  str <- paste("\n[Added new seed: '", seed_name,": ", desc, 
               "' for field day ", as.character(field_day_date),".]\n", sep = "")
  cat(str)
  

} else if ("-s" %in% args) {
  
  df <- read.table("~/Dropbox/jrnl/stream-log.txt", sep = "|")
  colnames(df) <- c("date", "goal")
  df$date %<>% as.Date()
  
} else {
  # Default: print goals 
   
  # Print active daily goals 
  df <- read.table("~/Dropbox/jrnl/streams.txt", sep = "|")
  names(df) <- c("stream", "description", "start", "end")
  df$start %<>% as.Date()
  df$end %<>% as.Date()
  
  df %<>% filter(Sys.Date() <= end)
  
  # Summary statistics
  log <- read.table("~/Dropbox/jrnl/streams-log.txt", sep = "|")
  colnames(log) <- c("date", "stream")
  log %<>% unique()
  # How many days have you done this stream?
  # group_by(stream) %>% 
  
  # A stone is just a successful goal
  # A stone is a count. How many stones can you collect? 
  for (i in 1:nrow(df)){
    # For each stream, count how many records lie between the dates 
    s <- df[i, ]
    df$stones[i] <- log %>% filter(stream == s$stream) %>%
      filter(date >=s$start, date <=s$end) %>%
      count() %>%  as.numeric()
    
    # 0/1 for today?
    df$thisday[i] <- log %>% filter(stream == s$stream) %>%
      filter(date == Sys.Date()) %>%
      count() %>% as.numeric()
    
    # Last 6 days. FIXME: Only go to #monday (or @gardening day)
    df$week[i] <- log %>% filter(stream == s$stream) %>%
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
  
  # FIXME:Read in and print streams
  #df <- read.table("~/Dropbox/jrnl/")
}


