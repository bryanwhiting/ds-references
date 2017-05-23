# Compile time entry

options(warn = -1)
suppressMessages(library(dplyr))
suppressMessages(library(magrittr))
suppressMessages(library(lubridate))
df <- read.table("H:/timesheet.txt", sep = "|")
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
  mutate(difftime = lead_dt - dt)

# Replace the last entry with the current time (to show how long since last)
now <- ymd_hms(Sys.time(), tz = "America/New_York")
df %<>% group_by(date) %>% 
  # Multiply by 60 because it calculates differences in minutes
  mutate(difftime = ifelse(entry == n() & date == Sys.Date(), (now - dt)*60, difftime)) 

# Compute total times
df %<>%
  mutate(tot_min = round(difftime / 60, 2)) %>%
  mutate(tot_hr = round(tot_min / 60, 2))
  

# Remove lines with "eofd" or "done" 
df %<>% filter(!(proj %in% c("eofd", "done")))

# SUMMARY STATS --------------------------------------------
# Today: Get total time by project, and combine all the descriptions
cat("\nTime by project today:\n")
df %>% filter(date == Sys.Date()) %>%
  group_by(proj) %>%
  summarize(`By min` = sum(tot_min),
            `By hr` = sum(tot_hr),
            desc = toString(desc)) %>%
  rename(Project = proj) %>%
  as.data.frame() %>%
  print()

# Current task  
curr <- df %>% ungroup() %>%
  filter(date == Sys.Date()) %>%
  filter(entry == n()) %>%
  select(tot_min, desc) %>%
  as.data.frame()

cat("\nTime on ", curr$desc, ": ", curr$tot_min, " min\n")



options(warn = 0)