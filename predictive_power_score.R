knitr::opts_chunk$set(echo = TRUE)

library(ppsr)
library(tidyverse)

covid_19_raw <- 
  read_csv("https://raw.githubusercontent.com/rama100/x2y/main/covid19.csv") %>% 
  relocate(covid_19_test_results, .before = everything())

covid_19_raw

null_cols <- 
  names(colSums(x = is.na(covid_19_raw))[colSums(x = is.na(covid_19_raw))>0])

covid_19_proc <-
covid_19_raw %>% 
  select(-all_of(null_cols))

covid_19_proc

dependent_corrs <-
score_predictors(df = covid_19_proc, 
                 y = "covid_19_test_results", 
                 do_parallel = TRUE, 
                 n_cores = 2)

dependent_corrs %>% 
  filter(!is.na(model_score))

all_corrs <-
score_df(df = covid_19_proc, do_parallel = TRUE, n_cores = 2)

all_corrs %>% 
  filter(!is.na(model_score)) %>% 
  arrange(desc(pps)) %>% 
  select(x,y,pps)

score(df = covid_19_proc, y = "cancer", x = "age") %>% 
  as_tibble()

knitr::purl(documentation = 0)
