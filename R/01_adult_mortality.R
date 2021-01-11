library(tidyverse)
library(countrycode)
library(fs)
library(plyr)

# Define constants --------------------------------------------------------

file_paths_female <- './input/lt_female/fltper_5x1'
file_paths_male   <- './input/lt_male/mltper_5x1'

# Load and combine datasets -----------------------------------------------
# Female files
files_female <- dir_ls(file_paths_female)           # Get full path of all files
names_female <- path_file(files_female)             # Get all filenames
names_female <- str_extract(names_female, 
                            pattern = '[A-Z_]{3,}') # Extract country codes
lt_female <- lapply(files_female, 
                    read_table, skip = 2)           # Read all files
names(lt_female) <- names_female                    # Assign names for each data file
lt_female <- ldply(lt_female, data.frame)           # Turn everything into tabular format
lt_female$gender <- 'female'                        # Add gender variable

# Male files (Same steps as for female files)
files_male <- dir_ls(file_paths_male)
names_male <- path_file(files_male)
names_male <- str_extract(names_male, 
                          pattern = '[A-Z_]{3,}')
lt_male <- lapply(files_male, 
                  read_table, skip = 2)
names(lt_male) <- names_male
lt_male <- plyr::ldply(lt_male, data.frame)
lt_male$gender <- 'male'

# Combine everything into a single table
lt <- rbind(lt_male, lt_female)
rm(lt_female, lt_male, files_female, files_male, names_female, names_male)

# Clean data --------------------------------------------------------------

out <- lt %>% # then
  filter(Year >= 1950,
         Age %in% c("15-19", "60-64")) %>%
  select(id = .id, year = Year, age = Age, gender, lx) %>%
  spread(key = age, value = lx) %>%
  mutate(
    adult_mortality = round(((`15-19` - `60-64`)) / `15-19` * 1000, 3)
  ) %>%
  select(-`15-19`, -`60-64`)

# out$id <- countrycode(out$id, origin = 'iso3c', destination = 'wb')

# remove non-updated countries --------------------------------------------

# keep <- read.csv('./input/countries_2016.csv', stringsAsFactors = FALSE)
# keep <- keep$country_code
# 
# out <- out %>%
#   filter(id %in% keep)
# 
# rm(keep, lt)
rm(lt)

# Save as .csv ------------------------------------------------------------

write.csv(out, file = './output/adult_mortality.csv', row.names = FALSE, na = '')
