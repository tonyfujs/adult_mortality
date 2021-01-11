library(countrycode)

# Load .csv file ----------------------------------------------------------

df <- read.csv('./input/countries.csv', stringsAsFactors = FALSE)


# Transform data ----------------------------------------------------------

df <- unique(df)
df$country_code <- countrycode::countrycode(df$country, origin = 'country.name', destination = 'wb')


# Save as .csv ------------------------------------------------------------

write.csv(df, file = './input/countries.csv', row.names = FALSE, na = '')
