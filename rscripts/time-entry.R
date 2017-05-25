# Command line arguments (used in weeks)
args <- commandArgs(trailingOnly = TRUE)

# PROCESS DATA --------------------------------------------
# options(echo = FALSE) # Set to true to see the code
options(warn = -1)


suppressMessages(library(dplyr))
suppressMessages(library(magrittr))
suppressMessages(library(lubridate))
# FIXME: How do you read in quotes?
df <- read.table("H:/timesheet.txt", sep = "|", quote = "\"", as.is = T)
colnames(df) <- c("time", "proj", "desc")
df$time %<>% gsub("TIME: ", "", ., fixed = T) %>% trimws()
df$proj %<>% gsub("PROJ: ", "", ., fixed = T) %>% trimws()
df$desc %<>% gsub("DESC: ", "", ., fixed = T) %>% trimws()

df %<>% mutate(dt = ymd_hms(time, tz = "America/New_York"),
               date = date(dt)) %>% arrange(dt)

# Calculate time as difference between current and the lead
df %<>% group_by(date) %>%
  mutate(lead_dt = lead(dt), 
         entry = seq_along(time)) %>%
  mutate(difftime = difftime(lead_dt, dt, units = "secs"))

# Replace the last entry with the current time (to show how long since last)
now <- ymd_hms(Sys.time(), tz = "America/New_York")
df %<>% group_by(date) %>% 
  # Multiply by 60 because it calculates differences in minutes
  mutate(difftime = ifelse(entry == n() & date == Sys.Date(), difftime(now, dt, tz = "America/New_York", units = "secs"), difftime)) 

# Compute total times
format_seconds <- function(s) {
  hr <- floor(s / (60*60))
  mn <- floor(s / 60) %% 60
  sec <- round(s %% 60)
  
  hr <- sprintf("%02.0f", hr)
  mn <- sprintf("%02.0f", mn)
  sec <- sprintf("%02.0f", sec)
  paste(hr, mn, sec, sep = ":")
}

df %<>%
  mutate(tot_sec = round(difftime, 2)) %>%
  mutate(tot_min = round(difftime / 60, 2)) %>%
  mutate(tot_hr  = round(tot_min / 60, 2)) %>%
  mutate(time    = format_seconds(difftime))

# Remove lines with "eofd" or "done" 
df %<>% filter(!(proj %in% c("eofd", "done"))) %>% arrange(desc(dt))

# SUMMARY STATS --------------------------------------------
# Today: Get total time by project, and combine all the times

summarize_day <- function(day = Sys.Date()){
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
    summarize(time = format_seconds(sum(difftime)),
              hrs = sum(tot_hr))
  
  summ_day <- left_join(summ_day, unique_desc, by = "proj") %>%
    rename(Project = proj) %>%
    # Trim the desc if necessary
    mutate(desc = ifelse(nchar(desc) > 150, paste(substr(desc, 1, 150), "..."), desc)) %>%
    arrange(hrs)
  
  # Calculate totals and format
  tot <- summ_day %>% summarize(Project = "TOTAL:", desc = "",
                             time = format_seconds(sum(hrs)*3600),
                             hrs = sum(hrs))
  summ_day <- rbind(summ_day, tot)
  
  cat("\n", format(day, format = "%a %B %d, %Y"))
  summ_day %>% knitr::kable(align = 'lccl')
}

# Current task  
curr <- df %>% ungroup() %>%
  filter(date == Sys.Date()) %>%
  filter(entry == n()) %>%
  select(tot_sec, desc) %>%
  as.data.frame()

# PRINT RESULTS --------------------------------
# IDEA: Include a weekly summary for number of days
# IDEA: Get total sums by project for N amount of time
if (length(args) == 0){
  cat("\nCurrent task:", curr$desc, "\nRunning time:", format_seconds(curr$tot_sec), "\n")
  summarize_day(Sys.Date())
} 
if ("y" %in% args) {
  summarize_day(Sys.Date() -1 )
}
if ("y2" %in% args) {
  # sapply(Sys.Date() - 1:2, summarize_day)
  summarize_day(Sys.Date() - 2)
}

options(warn = 0)