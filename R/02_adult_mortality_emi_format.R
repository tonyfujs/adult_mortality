source('./R/01_adult_mortality.R')

# gender as columns -------------------------------------------------------

out2 <- out %>%
  spread(key = gender, value = adult_mortality)

# Load and combine datasets -----------------------------------------------

out$gender[out$gender == 'male'] <- '0male'
out$gender[out$gender == 'female'] <- '1female'

out <- out %>%
  unite(col = 'gender_country', id, gender, sep = '_') %>%
  spread(key = 'gender_country', value = adult_mortality)

colnames(out) <- str_replace_all(colnames(out), pattern = '_[0-1]{1}', replacement = '_')


# Save as .csv ------------------------------------------------------------

write.csv(out, file = './output/adult_mortality_wide.csv', row.names = FALSE, na = '')
write.csv(out2, file = './output/adult_mortality_long.csv', row.names = FALSE, na = '')
