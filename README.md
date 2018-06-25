# Data analysis on WaPo's Police Shootings


## Background
This analysis was done as a final project for CS544 at Boston University.
The intent was to analyze data provided by the [Washington Post](https://github.com/washingtonpost/data-police-shootings) with respect to police shootings, and (attempt to) answer several questions, all of which were related to race in some fashion.

## Questions
Some of the questions I attempted to answer:

- What proportion of fatal police shootings are people of color

- What role (if any) does age play in conjunction with race across police shootings?

- What is the ratio of shootings to the overall population for each demographic?

- At what rates were certain demographics shot by police with respect to one another?

- Data for armed vs unarmed subjects being shot by police?

- Data for fleeing vs non-fleeing subjects being shot by police?

- Data for the previous two combined?

## Presentation
A google slideshow which presents an overview of findings can be found [here](https://docs.google.com/presentation/d/1kFQJRcQLjzRNuqmkPyY0_crArJ6ZkhUUz848ZnwSBGY/edit?usp=sharing).

The presentation also alludes to the fact that the data is incomplete, and a larger dataset provided by [Fatal Encounters](https://www.fatalencounters.org/) would be the next best step.
Their dataset contains over 20,000 fatal encounters with law enforcement, with the caveat that not all deaths were officer-induced (i.e. suicides, deaths related to police activity that did not involve the individual, etc). 
A good next step would be to sift through this data (which dates back to the year 2000), and locate all officer-involved shootings, and then redo this analysis in conjunction with the WaPo data.

## Files
`police_shootings.R` contains all of the relevant R-code. I have also included a Jupyter Notebook file `police_shootings.ipynb` for easier useage.

`census-data.csv` contains data from the 2010 U.S. census, and `census-metadata.csv` is what you can use to make sense of the columns.

`fatal-police-shootings-data.csv` contains the WaPo data from the internet.

The `images` directory contains all of the graphs generated with the associated R code. You can download the code and run it yourself to regenerate them if you'd like. 

## Misc (a rant about R)
Apologies in advance for the terribleness of the R code. I'd like to think that it has less to do with me and more to do with the fact that R is a horrible language that I have all but given up on trying to make sense of, but who knows :-).

In all seriousness, the sheer number of ways to do things in R, coupled with the horrible documentation and the lack of easy-to-find best-practices, makes it _very_ difficult to get a grip on the language. That and the fact that it can't seem to make up its mind as to whether or not it wants to be functional or procedural...and also just the downright insane ways that the language behaves (as if the authors set out the goal with violating _every_ best-practice for developing programming languages).

It is definitely not forgiving to those trying to learn it at the same time as learning data science, and I imagine it is even worse for those who have never had any programming experience. I shutter to think about what habits those poor souls whose first programming language is R will pick up (bless you).

In the future I think I will stick to python for larger projects, which is a great deal more accessible (and sane as far as programming languages go), and I recommend others to do the same.
It was fun to learn a bit more about R, though. It certainly has its uses, and I think for writing quick scripts to generate plots I may have use for it in the future.
