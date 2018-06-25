
# set your wd
setwd("/Users/hernanat/school/summer/data-analytics/project")
# police shootings 2015-2018
# https://github.com/washingtonpost/data-police-shootings
shooting_data <<- read.csv('fatal-police-shootings-data.csv', header = TRUE, na.strings = c("", "NA"), stringsAsFactors = FALSE)

# census data and estimates
# https://factfinder.census.gov/bkmk/table/1.0/en/PEP/2017/PEPASR6H?slice=hisp~totpop
census_data <<- read.csv('census-data.csv', header = TRUE, stringsAsFactors = FALSE)

# we want to look at cases where the age is known
age_known <<- shooting_data[complete.cases(shooting_data$age),]

# display names for race categories
race_categories <- c("Overall", "Asian", "Black", "Hispanic",
                     "Native American", "White", "Other", "Unknown")
# codes WaPo uses to identify race, plus default 'overall'
race_codes <<- c('overall', 'A', 'B', 'H', 'N', 'W', 'O', NA)

# subsets of data based on race / gender codes
getDataSubset <- function(raceCode = 'overall', genderCode = 'ANY') {
  if (is.na(raceCode)) {
    sub = subset(age_known, is.na(race))
  } else if (raceCode == 'overall') {
    sub = age_known
  } else {
    sub = subset(age_known, race == raceCode)
  }
  
  if(genderCode != 'ANY')
    sub = subset(sub, gender == genderCode)
  sub
}


# summary by race / gender codes
calculateSummary <- function(raceCode = 'overall', genderCode = 'ANY') {
  ages = getDataSubset(raceCode, genderCode)$age
  
  c(fivenum(ages), mean(ages), length(ages)) 
}

# all race summaries by gender code
allAgeSummaries <- function(genderCode = 'ANY') {
  together = cbind(
    sapply(
      race_codes,
      function(raceCode) { calculateSummary(raceCode, genderCode) }
    )
  )
  
  colnames(together) <- race_categories 
  rownames(together) <- c("Min", "1st Qu.", "Median", "3rd Qu.", "Max", "Mean", "Size")
  
  together
}

# boxplots for race categories based on gender code
boxPlots <- function(genderCode = 'ANY') {
  
  boxplot(
    age~race,
    getDataSubset(genderCode = genderCode),
    ylab = 'Age',
    col = 'cyan',
    border = c('blue'),
    names = c(
      'Asian',
      'Black',
      'Hispanic',
      'Native American',
      'Other',
      'White'
    )
  )
  
  plot_title <- switch(
    genderCode,
    'ANY' = 'Male & Female Police Shootings by Race / Ethnicity',
    'M' = 'Male Police Shootings by Race / Ethnicity',
    'F' = 'Female Police Shootings by Race / Ethnicity'
  )
  
  title(plot_title)
}

# all race-age summaries
mf_all_age_summaries = allAgeSummaries()
mf_all_age_summaries
boxPlots()

# all race-age summaries by gender - male
allAgeSummaries(genderCode = 'M')
boxPlots('M')

# all race-age summaries by gender - female
allAgeSummaries(genderCode = 'F')
boxPlots('F')

# 2010 census data
# will use for exploring shootings proportional to total population number
census_2010 = subset(census_data, year.id == "cen42010" & GEO.id == "0100000US") 
# totals - Hispanic + non-Hispanic
census_2010_totals = subset(census_2010, hisp.display.label == 'Total')

# WaPo data broken down by Hispanic / non-Hispanic
census_2010_hispanic = subset(census_2010, hisp.display.label == 'Hispanic')
census_2010_non_hispanic = subset(census_2010, hisp.display.label == 'Not Hispanic')

# see census metadata csv for sex and age information
populationTotals <- function(sex='0', age='999'){
  # see census metadata for population prefixes
  demographics = c('totpop', 'aa', 'ba', 'ia', 'wa')
  keys = sapply(
    demographics,
    function(prefix) {
      paste(prefix, paste("sex", sex, sep=""), paste("age", age, sep=""), sep="_")
    }
  )
  population_totals = data.frame(
    as.numeric(census_2010_totals[keys[1]]),
    as.numeric(census_2010_non_hispanic[keys[2]]),
    as.numeric(census_2010_non_hispanic[keys[3]]),
    as.numeric(census_2010_hispanic[keys[1]]),
    as.numeric(census_2010_non_hispanic[keys[4]]),
    as.numeric(census_2010_non_hispanic[keys[5]]),
    NA,
    NA
  )
  
  colnames(population_totals) <- race_categories
  rownames(population_totals) <- c('Total')
    
  population_totals
}

# overall
mf_population_totals <<- populationTotals()
mf_population_totals

populationPercent <- function(num) {
    as.numeric(num / mf_population_totals['Overall'])
}

mf_population_percent_black = populationPercent(mf_population_totals['Black'])
mf_population_percent_black

mf_population_percent_hispanic = populationPercent(mf_population_totals['Hispanic'])
mf_population_percent_hispanic

mf_population_percent_white = populationPercent(mf_population_totals['White'])
mf_population_percent_white

# male/female shootings totals
mf_shootings_total <<- mf_all_age_summaries[,1]['Size']
mf_shootings_black = mf_all_age_summaries[,3]['Size']
mf_shootings_hispanic = mf_all_age_summaries[,4]['Size']
mf_shootings_white = mf_all_age_summaries[,6]['Size']

shootingRatio <- function(num) {
    as.numeric(num / mf_shootings_total)
}

# shooting % by race / ethnicity
mf_shootings_percent_black = shootingRatio(mf_shootings_black)
mf_shootings_percent_hispanic = shootingRatio(mf_shootings_hispanic)
mf_shootings_percent_white = shootingRatio(mf_shootings_white)

mf_shootings_percent_black
mf_shootings_percent_hispanic
mf_shootings_percent_white

# shootings / population
mf_shootings_to_pop_black = as.numeric(mf_shootings_black / mf_population_totals['Black'])
mf_shootings_to_pop_hispanic = as.numeric(mf_shootings_hispanic / mf_population_totals['Hispanic'])
mf_shootings_to_pop_white = as.numeric(mf_shootings_white / mf_population_totals['White'])


pop_data = c(
    mf_shootings_percent_black,
    mf_population_percent_black,
    mf_shootings_percent_hispanic,
    mf_population_percent_hispanic,
    mf_shootings_percent_white,
    mf_population_percent_white
)

pop_data_matrix = matrix(pop_data, ncol=3)
colnames(pop_data_matrix) <- c('Black', 'Hispanic', 'White')

barplot(
    matrix(pop_data, ncol=3),
    col = c('cyan', 'blue'), 
    beside = TRUE,
    xlab = 'Race / Ethnicity',
    ylab = 'Race / Population Ratio',
    ylim = 0:1,
    names = colnames(pop_data_matrix)
)

legend("topleft", c("Shootings Population","US Population"), pch=15, 
       col=c("cyan","blue"), 
       bty="n")

shootings_to_pop_ratios = c(
    mf_shootings_to_pop_black,
    mf_shootings_to_pop_hispanic,
    mf_shootings_to_pop_white
)

shootings_to_pop_ratio_matrix = matrix(shootings_to_pop_ratios, ncol=3)
colnames(shootings_to_pop_ratio_matrix) <- colnames(pop_data_matrix)

barplot(
    shootings_to_pop_ratio_matrix,
    col = c('cyan'),
    names = colnames(shootings_to_pop_ratio_matrix),
    xlab = 'Race / Ethnicity',
    ylab = 'Shootings / Population Ratio by Race / Ethnicity',
    ylim = range(pretty(c(0, shootings_to_pop_ratio_matrix)))
)

# black / hispanic ratio
mf_shootings_to_pop_black / mf_shootings_to_pop_hispanic

# black / white ratio
mf_shootings_to_pop_black/ mf_shootings_to_pop_white

# hispanic / white ratio
mf_shootings_to_pop_hispanic / mf_shootings_to_pop_white

# WaPo race codes; see the dataset link
wapo_codes = c('B', 'H', 'W')
race_labels = c('Black', 'Hispanic', 'White')
armed_table = table(subset(shooting_data, armed != 'unarmed' & armed != 'undetermined')$race)[wapo_codes]
unarmed_table = table(subset(shooting_data, armed == 'unarmed')$race)[wapo_codes]

armed_table
unarmed_table

armed_unarmed_matrix = matrix(c(armed_table, unarmed_table), ncol=2)
colnames(armed_unarmed_matrix) <- c('Armed', 'Unarmed')
rownames(armed_unarmed_matrix) <- race_labels

armed_unarmed_matrix

mosaicplot(armed_unarmed_matrix, main = 'Armed vs Unarmed by Race Group', col=c('cyan', 'blue'))

fleeing_table = table(subset(shooting_data, flee != 'Not fleeing')$race)[wapo_codes]
not_fleeing_table = table(subset(shooting_data, flee == 'Not fleeing')$race)[wapo_codes]

fleeing_table
not_fleeing_table

fleeing_not_fleeing_matrix = matrix(c(fleeing_table, not_fleeing_table), ncol=2)
colnames(fleeing_not_fleeing_matrix) <- c('Fleeing', 'Not Fleeing')
rownames(fleeing_not_fleeing_matrix) <- race_labels

fleeing_not_fleeing_matrix

mosaicplot(fleeing_not_fleeing_matrix, main = 'Fleeing vs Not Fleeing by Race Group', col=c('red', 'orange', 'green'))

fields = c('race', 'armed', 'flee')
armed_fleeing_data = subset(shooting_data, race %in% wapo_codes & armed != 'unarmed' & armed != 'undetermined' & flee != 'Not fleeing')[fields]
armed_not_fleeing_data = subset(shooting_data, race %in% wapo_codes & armed != 'unarmed' & armed != 'undetermined' & flee == 'Not fleeing')[fields]
unarmed_fleeing_data = subset(shooting_data, race %in% wapo_codes & armed == 'unarmed' & flee != 'Not fleeing')[fields]
unarmed_not_fleeing_data = subset(shooting_data, race %in% wapo_codes & armed == 'unarmed' & flee == 'Not fleeing')[fields]

armed_fleeing_data$armed = c('armed')
armed_fleeing_data$flee = c('fleeing')
armed_not_fleeing_data$armed = c('armed')

unarmed_fleeing_data$flee = c('fleeing')


dataForPlot = rbind(armed_fleeing_data, armed_not_fleeing_data, unarmed_fleeing_data, unarmed_not_fleeing_data)
names(dataForPlot) <- c('Race', 'Armed', 'Fleeing')
mosaicplot(
    ~ Fleeing + Race + Armed,
    dataForPlot,
    main = "Race, Fleeing / Unfleeing, Armed / Unarmed",
    col = c('red', 'orange', 'green')
)
