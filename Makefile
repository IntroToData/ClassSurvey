all: data reports

data: data/survey.R data/survey.rda
	Rscript data/survey.R

presentations: presentation.Rmd
	Rscript -e 'rmarkdown::render("presentation.Rmd")'

reports: survey.Rmd
	Rscript -e 'rmarkdown::render("survey.Rmd")'
