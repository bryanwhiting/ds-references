# Command line arguments (used in weeks)
args <- commandArgs(trailingOnly = TRUE)

# args <- c( "w", "a")
# args <- c("")

# Format seconds function
format_seconds <- function(s) {
  hr <- floor(s / (60*60))
  mn <- floor(s / 60) %% 60
  sec <- round(s %% 60)
  
  hr <- sprintf("%02.0f", hr)
  mn <- sprintf("%02.0f", mn)
  sec <- sprintf("%02.0f", sec)
  paste(hr, mn, sec, sep = ":")
}

# PROCESS DATA --------------------------------------------
# options(echo = FALSE) # Set to true to see the code
options(warn = -1)
options(stringsAsFactors=FALSE)

# FIXME: set path in ~/.timesheet_config

if (length(grep("Windows", sessionInfo()$running)) > 0) {
  system = "Windows"
  path = "H:/.timesheet/timesheet.txt"
} else {
  system = "Else"
  path = "~/.timesheet/timesheet.txt"
}

suppressMessages(library(dplyr))
suppressMessages(library(magrittr))
suppressMessages(library(lubridate))
suppressMessages(library(ggplot2))
suppressMessages(library(stringr))
# FIXME: How do you read in quotes?
df <- read.table(path, sep = "|", quote = "\"", as.is = T)
colnames(df) <- c("time", "proj", "desc")
df <- sapply(df, trimws) %>% as.data.frame()
df$proj %<>% tolower()

# Get current time and add it on
now_row = as.data.frame(list(time = as.character(Sys.time()), proj = "now", desc = ""))
df <- rbind(now_row, df)

# Convert time
df %<>% mutate(dt = ymd_hms(time, tz = "America/New_York"),
               date = date(dt)) %>% arrange(dt)

# Calculate time as difference between current and the lead
df %<>% group_by(date) %>%
  mutate(lead_dt = lead(dt), 
         entry = seq_along(time)) %>%
  mutate(difftime = difftime(lead_dt, dt, units = "secs")) %>%
  mutate(tot_sec = as.numeric(difftime, units = "secs")) %>%
  arrange(desc(dt))

# Remove lines with "now"
df %<>% filter(proj != "now") %>% arrange(desc(dt))

# Current task  
curr <- df %>% ungroup() %>%
  filter(date == Sys.Date()) %>%
  filter(entry == n()) %>%
  select(proj, tot_sec, desc) %>%
  as.data.frame()
if (curr$proj == "done") {
  curr$tot_sec = 0
}
# Break here if no arguments
if ("curr_only" %in% args) {
  cat("\nCurrent task:", curr$proj, "->", curr$desc, "\nRunning time:", format_seconds(curr$tot_sec), "\n")
  quit()
}

# Remove lines with "eofd" or "done" 
df %<>% filter(!(proj %in% c("eofd", "done"))) %>% arrange(desc(dt))

# SUMMARY STATS --------------------------------------------
# Today: Get total time by project, and combine all the times
summarize_day <- function(day = Sys.Date(), output = "neat", mk_plot = FALSE){
  # FIXME: option to summarize by task in project?
  
  # Unique descriptions by project  
  unique_desc <- df %>% filter(date == day) %>%
    group_by(proj) %>%
    select(proj, desc) %>%
    unique() %>%
    summarize(desc = toString(desc))
  
  # Filter today's data, group, and summarize
    summ_day <- df %>% filter(date == day) %>%
      group_by(proj) %>%
      summarize(time = format_seconds(sum(tot_sec)),
                hrs = sum(tot_sec/3600))
    
  
  # Join description on, rename, and save out. Trim the desc if necessary
  summ_day <- left_join(summ_day, unique_desc, by = "proj") %>%
    mutate(desc = ifelse(nchar(desc) > 150, paste(substr(desc, 1, 150), "..."), desc)) %>%
    arrange(desc(hrs))
  
  # Calculate totals and format. Append totals on.
  tot <- df %>% filter(date == day) %>% 
    ungroup() %>%
    summarize(proj = "Total ",
              time = format_seconds(sum(tot_sec)),
              hrs = sprintf("%2.2f", sum(tot_sec/3600)),
              desc = "Description") 
  
  # Combine into one
  # out <- rbind(summ_day, tot)
  # Instead of having a 
  out <- summ_day
  fmt_day <-  format(day, format = "%a %B %d, %Y")
    
  if (nrow(out) > 0) {
    
    out$hrs %<>% sprintf("%2.2f", .)
   
    # Merge on an empty row for day 
    out <- cbind("", out)
    colnames(out) <- c(fmt_day, tot)
    # Print out 
    # cat("\n", fmt_day )
    out %>% knitr::kable(align = 'llccl') %>% print()
    
  } else {
    cat("\n", fmt_day, ": Empty")
    
  }
  
  
}



summarize_block <- function(ndays = 6) {
  
  last_week <- Sys.Date() - ndays
  
  week <-  df %>% filter(date >= last_week) %>%
    group_by(proj) %>%
    summarize(time = format_seconds(sum(tot_sec)),
              hrs = sum(tot_sec/3600, na.rm = T)) %>%
    arrange(desc(hrs))
  # Weekly total 
  tot <- df %>% filter(date >= last_week) %>%
    ungroup() %>%
    summarize(proj = "TOTAL:",
              time = format_seconds(sum(tot_sec)),
              hrs = sum(tot_sec/3600))
  # combin
  out <- rbind(week, tot)
  out$hrs %<>% sprintf("%2.2f", .)
  
  cat("\nLast ", ndays, " days \n")
  cat("\nFrom ", format(last_week, format = "%a %b %d, %Y"))
  cat("\nTo   ", format(Sys.Date(), format = "%a %b %d, %Y"))
  out %>% knitr::kable(align = 'lcr')
  
}


# PRINT RESULTS --------------------------------
# IDEA: Include a weekly summary for number of days
# IDEA: Get total sums by project for N amount of time
# This is if args == "-s"
if (length(args) == 0){
  cat("\nCurrent task:", curr$proj, "->", curr$desc, "\nRunning time:", format_seconds(curr$tot_sec), "\n")
  summarize_day(Sys.Date())
} 


# Find which argument is the y argument
index <- str_count(args, "y[0-9]*")
if (sum(index) > 0) {
  yarg <- args[index]
  # Extract the days. If it's just y, and not y#, default y to 1 (yesterday's)
  ndays <- as.numeric(sub("y", "", yarg))
  if (length(ndays) == 0 | is.na(ndays)) ndays <- 1
  
  # Get the date 
  day <- Sys.Date() - ndays
  
  # Print Summary back n days
  summarize_day(day)
  
  # Print project detail
  if ("d" %in% args){
    # cat(args)
    summ_day <- df %>% filter(date == day) %>%
      group_by(proj, desc) %>%
      summarize(time = format_seconds(sum(tot_sec)),
                hrs = round(sum(tot_sec/3600),2)) %>%
      arrange(proj, desc(hrs))
    summ_day %>% as.data.frame() %>% knitr::kable() %>% print()
  }
  
}

# Weekly summary
if ("w" %in% args) {
  if ("a" %in% args) {
    lapply(Sys.Date() - 6:0, summarize_day)
  }
  summarize_block(6)
}
if ("m" %in% args) {
  summarize_block(30)
}

options(warn = 0)



# GRAVEYARD ----------

  # OUTPUT ---------- 
  # FIXME: Consider including a plot?
  # if (mk_plot == TRUE) {
  #   cat("Plot made")
  #   ggplot(out, aes(x = proj, y = hrs, fill = proj)) + geom_bar(stat = "identity")
  #   if (system == "Windows") {
  #     ggsave("H:/.timesheet/dayplot.png")
  #   } else {
  #     ggsave("~/.timesheet/dayplot.png")
  #   }
  # }