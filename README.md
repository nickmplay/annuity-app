# Annuity App

The purpose of this app is to illustrate the relative competitiveness of 
different counterparties on the deals that they have quoted on.

After selecting the deal name, the quoting counterparties can be selected and 
viewed illustratively to see where each is most competitive. 

The app has been deployed to [https://nickmwip.shinyapps.io/annuity-app/](https://nickmwip.shinyapps.io/annuity-app/)

# Github actions

To set-up your environment for GitHub Actions deployment, run the following in the R Console:

Install renv `install.packages("renv")`
Initialise the environment. This creates a lockfile `renv::init()`
Take a 'snapshot' of the current package/dependency set-up `renv::snapshot()`
A new folder called 'renv/' and a folder called 'renv.lock' will be created in your repository