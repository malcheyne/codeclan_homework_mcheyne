---
title: "NHS Borders Cancer Report"
output:
  html_document:
    code_folding: hide
    df_print: paged
    toc: true
    toc_float: true
    number_sections: true
  pdf_document: default
---

```{r include = FALSE}
knitr::opts_chunk$set(echo = FALSE, warning = FALSE, message = FALSE)
library(tidyverse)
library(janitor)
library(ggplot2)
library(ggpubr)
```


```{r}
`%!in%` <- negate(`%in%`)

pal <- c("Male" = "#a6bddb", "Female" = "#fa9fb5")

area <- read_csv("raw_data/opendata_inc9519_hb.csv") %>% 
  clean_names() %>% 
  mutate(hb = case_when(
    hb == "S92000003" ~ "Scotland",
    hb == "S08000015" ~ "Ayrshire and Arran",
    hb == "S08000016" ~ "Borders",
    hb == "S08000017" ~ "Dumfries and Galloway",
    hb == "S08000019" ~ "Forth Valley",
    hb == "S08000020" ~ "Grampian",
    hb == "S08000022" ~ "Highland",
    hb == "S08000024" ~ "Lothian",
    hb == "S08000025" ~ "Orkney",
    hb == "S08000026" ~ "Shetland",
    hb == "S08000028" ~ "Western Isles",
    hb == "S08000029" ~ "Fife",
    hb == "S08000030" ~ "Tayside",
    hb == "S08000031" ~ "Greater Glasgow and Clyde",
    hb == "S08000032" ~ "Lanarkshire",
    TRUE ~ as.character(NA))) %>%
  filter(!is.na(hb)) %>% 
  mutate(cure_diff_up = crude_rate_upper95pc_confidence_interval - crude_rate,
         cure_diff_down = crude_rate - crude_rate_lower95pc_confidence_interval,
         easr_diff_up = easr_upper95pc_confidence_interval - easr,
         easr_diff_down = easr - easr_lower95pc_confidence_interval,
         wasr_diff_up = wasr_upper95pc_confidence_interval - wasr,
         wasr_diff_down = wasr - wasr_lower95pc_confidence_interval,
         sir_diff_up = sir_upper95pc_confidence_interval - standardised_incidence_ratio,
         sir_diff_down = standardised_incidence_ratio - sir_lower95pc_confidence_interval)

comb_hb <- read_csv("raw_data/opendata_inc1519comb_hb.csv") %>% 
  clean_names() %>% 
  mutate(hb = case_when(
    hb == "S92000003" ~ "Scotland",
    hb == "S08000015" ~ "Ayrshire and Arran",
    hb == "S08000016" ~ "Borders",
    hb == "S08000017" ~ "Dumfries and Galloway",
    hb == "S08000019" ~ "Forth Valley",
    hb == "S08000020" ~ "Grampian",
    hb == "S08000022" ~ "Highland",
    hb == "S08000024" ~ "Lothian",
    hb == "S08000025" ~ "Orkney",
    hb == "S08000026" ~ "Shetland",
    hb == "S08000028" ~ "Western Isles",
    hb == "S08000029" ~ "Fife",
    hb == "S08000030" ~ "Tayside",
    hb == "S08000031" ~ "Greater Glasgow and Clyde",
    hb == "S08000032" ~ "Lanarkshire",
    TRUE ~ as.character(NA))) %>%
  filter(!is.na(hb))


```

# Introduction

<center>
Report written <br>
 by <br>
 Malcolm Cheyne
<center>
<br>

# Brakedown of Cancers in NHS Borders

There are 51 types of cancer that are recorded across Borders that affect both men and women. Out of all these types of cancer the majority have less than 50 cases a year in NHS Borders.

Taking the top 7 types of cancer that are have more than 50 cases a year in NHS Borders. 


* Non-melanoma skin cancer				
* Basal cell carcinoma of the skin				
* Breast				
* Trachea, bronchus and lung				
* Colorectal cancer				
* Squamous cell carcinoma of the skin				
* Colon


<br>

```{r}
biggest_type <- area %>% 
  filter(hb %in% "Borders",
         sex %in% "All",
         cancer_site %!in% "All cancer types") %>%
  group_by(cancer_site) %>% 
  summarise(count = sum(incidences_all_ages)) %>% 
  arrange(desc(count)) %>% 
  head(7)

area %>% 
  filter(cancer_site %in% c(biggest_type$cancer_site)) %>%
  filter(hb %in% "Borders",
         sex %in% "All",
         cancer_site %!in% "All cancer types") %>% 
  ggplot(aes(x = year, y = incidences_all_ages, col = cancer_site)) +
  geom_point() +
  geom_line() +
  labs(title = "Top 7 Cancers in NHS Borders \n",
       x = "Year",
       y = "Number of Incidences \n",
       colour = "Types of Cancers\n") +
  theme(plot.title = element_text(hjust = 0.5))
```
<br>

We can see a steady rise's for two skin cancers incidences over the 24 year period. Breast cancer comes in peaks that mite have come from increased publicity encouraging people to check or be tested in the lead up to the peaks.
They can be split by proactive and reactive approaches.

## Proactive

* We can see that three of them are based on skin cancers that have like developed from exposed to ultraviolet (UV) radiation from the sun. This can be combated with more publicity encouraging on when and how to using sunscreen, while in the local area or on holiday abroad.

* Trachea, bronchus and lung cancers, came mainly from direct or passive smoking. This can be combated with more publicity on the dangers of direct or passive smoking to people and their family. Can look at putting more support for people trying to quit. 

## Reactive

* 2 are types Bowel cancers, while the cause of these is not known, certain risk factors are strongly linked to the disease, including diet, tobacco smoking and heavy alcohol use.

* Breast cancer is caused when the DNA in breast cells mutate or change, disabling specific functions that control cell growth and division.

<br>

# Cancer by Age and Sex Demographic's

```{r}
comb_hb %>% 
  filter(hb %in% "Borders",
         sex %!in% "All",
         cancer_site %in% "All cancer types") %>% 
  pivot_longer(c(7:24),
               names_to = "age_range",
               values_to = "count") %>%
  mutate(age_range = case_when(
    age_range == "incidences_age_under5" ~ "< 05",
    age_range == "incidences_age5to9" ~ "05 to 09",
    age_range == "incidences_age10to14" ~ "10 to 14",
    age_range == "incidences_age15to19" ~ "15 to 19",
    age_range == "incidences_age20to24" ~ "20 to 24",
    age_range == "incidences_age25to29" ~ "25 to 29",
    age_range == "incidences_age30to34" ~ "30 to 34",
    age_range == "incidences_age35to39" ~ "35 to 39",
    age_range == "incidences_age40to44" ~ "40 to 44",
    age_range == "incidences_age45to49" ~ "45 to 49",
    age_range == "incidences_age50to54" ~ "50 to 54",
    age_range == "incidences_age55to59" ~ "55 to 59",
    age_range == "incidences_age60to64" ~ "60 to 64",
    age_range == "incidences_age65to69" ~ "65 to 69",
    age_range == "incidences_age70to74" ~ "70 to 74",
    age_range == "incidences_age75to79" ~ "75 to 79",
    age_range == "incidences_age80to84" ~ "80 to 84",
    age_range == "incidences_age85and_over" ~ "85 +"
  )) %>% 
  select(hb, cancer_site, sex, year, age_range, count) %>% 
  ggplot(aes(x = age_range, y = count, fill = sex)) +
  geom_col(position = "dodge", col = "black") +
  scale_fill_manual(values = pal) +
  coord_flip() +
  labs(title = "Age Range by Gender \n",
       x = "Number of Incidences \n",
       y = "Age Range \n",
       fill = "Gender") +
  theme(plot.title = element_text(hjust = 0.5))
  
```

Here we can see the brake down by age and gender showing the older the person is the greater risk they have. While women start by being at higher risk at a younger age older men make up the highest risk of cancer. This adds these ages to the demographic of targets to focus any publicity for proactive and reactive approaches. Both genders peak in the 70-74 range and men have the over take women as having the highest risk in the 55-59 range.
 
 
```{r}
comb_hb %>% 
  filter(cancer_site %in% c("Basal cell carcinoma of the skin", 
                            "Non-melanoma skin cancer",
                            "Breast",
                            "Prostate")) %>%
  filter(hb %in% "Borders",
         sex %!in% "All",
         cancer_site %!in% "All cancer types") %>% 
  pivot_longer(c(7:24),
               names_to = "age_range",
               values_to = "count") %>%
  mutate(age_range = case_when(
    age_range == "incidences_age_under5" ~ "< 05",
    age_range == "incidences_age5to9" ~ "05 to 09",
    age_range == "incidences_age10to14" ~ "10 to 14",
    age_range == "incidences_age15to19" ~ "15 to 19",
    age_range == "incidences_age20to24" ~ "20 to 24",
    age_range == "incidences_age25to29" ~ "25 to 29",
    age_range == "incidences_age30to34" ~ "30 to 34",
    age_range == "incidences_age35to39" ~ "35 to 39",
    age_range == "incidences_age40to44" ~ "40 to 44",
    age_range == "incidences_age45to49" ~ "45 to 49",
    age_range == "incidences_age50to54" ~ "50 to 54",
    age_range == "incidences_age55to59" ~ "55 to 59",
    age_range == "incidences_age60to64" ~ "60 to 64",
    age_range == "incidences_age65to69" ~ "65 to 69",
    age_range == "incidences_age70to74" ~ "70 to 74",
    age_range == "incidences_age75to79" ~ "75 to 79",
    age_range == "incidences_age80to84" ~ "80 to 84",
    age_range == "incidences_age85and_over" ~ "85 +"
  ),
  cancer_site = case_when(
    cancer_site == "Basal cell carcinoma of the skin" ~ "Basal cell carcinoma",
    cancer_site == "Squamous cell carcinoma of the skin" ~ "Squamous cell carcinoma",
    TRUE ~ cancer_site)) %>% 
  ggplot(aes(x = age_range, y = count, fill = sex)) +
  geom_col(position = "dodge", col = "black") +
  scale_fill_manual(values = pal) +
  coord_flip() +
  facet_wrap(~ cancer_site) +
  labs(title = "Age Range by Tpye of Cancer \n",
       x = "Number of Incidences \n",
       y = "Age Range \n",
       fill = "Gender") +
  theme(plot.title = element_text(hjust = 0.5), 
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank())


```

```{r}
comb_hb %>% 
  filter(cancer_site %in% c("Trachea, bronchus and lung",
                            "Colorectal cancer",
                            "Squamous cell carcinoma of the skin",
                            "Colon")) %>%
  filter(hb %in% "Borders",
         sex %!in% "All",
         cancer_site %!in% "All cancer types") %>% 
  pivot_longer(c(7:24),
               names_to = "age_range",
               values_to = "count") %>%
  mutate(age_range = case_when(
    age_range == "incidences_age_under5" ~ "< 05",
    age_range == "incidences_age5to9" ~ "05 to 09",
    age_range == "incidences_age10to14" ~ "10 to 14",
    age_range == "incidences_age15to19" ~ "15 to 19",
    age_range == "incidences_age20to24" ~ "20 to 24",
    age_range == "incidences_age25to29" ~ "25 to 29",
    age_range == "incidences_age30to34" ~ "30 to 34",
    age_range == "incidences_age35to39" ~ "35 to 39",
    age_range == "incidences_age40to44" ~ "40 to 44",
    age_range == "incidences_age45to49" ~ "45 to 49",
    age_range == "incidences_age50to54" ~ "50 to 54",
    age_range == "incidences_age55to59" ~ "55 to 59",
    age_range == "incidences_age60to64" ~ "60 to 64",
    age_range == "incidences_age65to69" ~ "65 to 69",
    age_range == "incidences_age70to74" ~ "70 to 74",
    age_range == "incidences_age75to79" ~ "75 to 79",
    age_range == "incidences_age80to84" ~ "80 to 84",
    age_range == "incidences_age85and_over" ~ "85 +"
  ),
  cancer_site = case_when(
    cancer_site == "Basal cell carcinoma of the skin" ~ "Basal cell carcinoma",
    cancer_site == "Squamous cell carcinoma of the skin" ~ "Squamous cell carcinoma",
    TRUE ~ cancer_site)) %>% 
  ggplot(aes(x = age_range, y = count, fill = sex)) +
  geom_col(position = "dodge", col = "black") +
  scale_fill_manual(values = pal) +
  coord_flip() +
  facet_wrap(~ cancer_site) +
  labs(
       x = "Number of Incidences \n",
       y = "Age Range \n",
       fill = "Gender") +
  theme(plot.title = element_text(hjust = 0.5), 
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank())
```

This is a brake down of Cancer type by age reinforces the demographic of targets to focus any publicity for proactive and reactive approaches. 

* Skin and lung cancers both men and women being encouraged to take proactive while young.

* Breast and prostate cancers for women and men respectively should be checked regularly at these ages.
<br>

 
 
```{r}
area %>% 
  filter(cancer_site %in% c("Non-melanoma skin cancer",
                            "Squamous cell carcinoma of the skin", "Breast",
                            "Prostate")) %>%
  filter(hb %in% "Borders",
         sex %!in% "All",
         cancer_site %!in% "All cancer types") %>% 
  mutate(
  cancer_site = case_when(
    cancer_site == "Basal cell carcinoma of the skin" ~ "Basal cell carcinoma",
    cancer_site == "Squamous cell carcinoma of the skin" ~ "Squamous cell carcinoma",
    TRUE ~ cancer_site)) %>% 
  ggplot(aes(x = year, y = incidences_all_ages, col = sex)) +
  geom_point() +
  geom_line(size=1.2) +
  labs(title = "Top 8 Cancers by Gender \n",
       x = "Year",
       y = "Number of Incidences \n",
       colour = "Gender") +
  theme(plot.title = element_text(hjust = 0.5)) +
  facet_wrap(~ cancer_site) +
  scale_colour_manual(values = pal)

area %>% 
  filter(cancer_site %in% c("Trachea, bronchus and lung",
                            "Colorectal cancer",
                            "Basal cell carcinoma of the skin",
                            "Colon"))%>%
  filter(hb %in% "Borders",
         sex %!in% "All",
         cancer_site %!in% "All cancer types") %>% 
  mutate(
  cancer_site = case_when(
    cancer_site == "Basal cell carcinoma of the skin" ~ "Basal cell carcinoma",
    cancer_site == "Squamous cell carcinoma of the skin" ~ "Squamous cell carcinoma",
    TRUE ~ cancer_site)) %>% 
  ggplot(aes(x = year, y = incidences_all_ages, col = sex)) +
  geom_point() +
  geom_line(size=1.2) +
  labs(
       x = "Year",
       y = "Number of Incidences \n",
       colour = "Gender") +
  theme(plot.title = element_text(hjust = 0.5)) +
  facet_wrap(~ cancer_site) +
  scale_colour_manual(values = pal)
```

While almost all these cancers are shared equally between the two genders, two cancers breast and prostate have a traditional gender bias on which is effected.  As-well two of the skin cancers have a higher risk in men since around 2005 on wards. This can be a demographic to target to focus the publicity encouraging talked about above or showing the risk 

<br>


# Health Boards comparason

```{r}
text <- area %>%
  filter(year == 2005) %>% 
  mutate(label_text = hb)

area %>% 
  filter(
         sex %in% "All",
         cancer_site %in% "All cancer types") %>% 
  group_by(hb) %>% 
  ggplot(aes(x = year, y = incidences_all_ages, group = hb, col = hb == "Borders")) +
  geom_point() +
  geom_line() +
  scale_colour_manual(values = c('grey40', 'red'), guide = "none") +
  geom_text(aes(label = "Borders", x = 2020, y = 500), color = "red") +
  geom_text(aes(label = "Greater \nGlasgow", x = 2020, y = 7000), color = "grey40") +
  geom_text(aes(label = "Dumfries", x = 2020, y = 1000), color = "grey40") +
  geom_text(aes(label = "Lothian", x = 2020, y = 5200), color = "grey40") +
  geom_text(aes(label = "Lanarkshire", x = 2019.5, y = 4500), color = "grey40") +
  labs(title = "Cancers Incidence by Health Boards \n",
       x = "Year",
       y = "Number of Incidences \n") +
  theme(plot.title = element_text(hjust = 0.5))
```

In comparison to other local Health Boards, NHS Borders has a small percentage of the cancer incidences across Scotland

<br>

# Allover trend v Crude rate

```{r}
crude <- area %>% 
  filter(hb %in% "Borders",
         sex %in% "All",
         cancer_site %in% "All cancer types") %>% 
  ggplot(aes(x = year, y = incidences_all_ages)) +
  geom_point(col = "red") +
  geom_line(col = "red") +
  geom_point(aes(x = year, y = crude_rate),
             col = "dark green") +
  geom_line(aes(x = year, y = crude_rate),
            col = "dark green") +
  geom_ribbon(aes(ymin = crude_rate - cure_diff_down, 
                  ymax = crude_rate + cure_diff_up), 
              fill = "grey70", alpha=0.5) +
  
  geom_text(aes(label = "Incidences", x = 2019.5, y = 900), color = "red") +
  geom_text(aes(label = "Crude \n Rate", x = 2020, y = 650), color = "dark green") +
  geom_text(aes(label = "Crude \n Rate \n Range", x = 2020, y = 750), color = "grey70") +
  labs(title = "Cancers Incidence in NHS Borders \n",
       x = "Year",
       y = "Number of Incidences \n") +
  theme(plot.title = element_text(hjust = 0.5))
  
crude
```

Focusing in on NHS Borders we can see a steady rise in the number of cancer incidences over the 24 year period.  The crude rate that is measured by per 100,000 has lagged behind and not followed this increase since around 2004. 

<br>

# References

The data used were all sourced from https://www.opendata.nhs.scot/. The links below are all the specific links to each dataset used:

https://www.opendata.nhs.scot/dataset/c2c59eb1-3aff-48d2-9e9c-60ca8605431d/resource/3aef16b7-8af6-4ce0-a90b-8a29d6870014/download/opendata_inc9519_hb.csv - Incidence by Health Board

https://www.opendata.nhs.scot/dataset/c2c59eb1-3aff-48d2-9e9c-60ca8605431d/resource/e8d33b2b-1fb2-4d59-ad21-20fa2f76d9d5/download/opendata_inc1519comb_hb.csv - 5 Year Summary of Incidence by Health Board

<br>
<br>
<br>
