library(tidyverse)
library(here)

# Read cleaned data frame.
GTM_data <- read.csv(here::here('data-raw', 'GTM_tides_cleaned.csv'))

GTM_data <- GTM_data |>
  mutate(sample_date = as.Date(sample_date),
         sample_date_num = as.numeric(sample_date),
         cont_year = lubridate::decimal_date(sample_date),
         yr = year(sample_date),
         STN_NAME = as.factor(STN_NAME),
         lab = ifelse(sample_date > as.Date('2012-12-01'), # RILEY 2-19-2026 FACTOR FOR LAB
                      'FDEP',
                      'UF'),
         lab = as.factor(lab),
         filter_method = case_when(sample_date > as.Date("2019-03-01") ~ "0.7 um Lab",
                                   sample_date > as.Date("2012-12-01") ~ "1.2 um Lab",
                                   sample_date > as.Date("2005-12-31") ~ "0.7 um Field",
                                   sample_date > as.Date("2002-05-08") ~ "0.3 um Field",
                                   TRUE ~ NA_character_),
         filter_method = as.factor(filter_method)) |> # RILEY 2-19-2026 FACTOR FOR FILTER METHOD
  filter(hours_since_low<20)# exclude single observation of very long time since low tide

gtmdat <- GTM_data |> 
  filter(param == "Chl-a Corrected") |> 
  select(STN_NAME, sample_date, cont_year, value, filter_method, lab, hours_since_low)

save(gtmdat, file = here::here('data', 'gtmdat.Rdata'))
