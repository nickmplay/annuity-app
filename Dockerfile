## Use the RShiny base image (uses Ubuntu/Debian)
FROM rocker/shiny:latest

## Ensure the packages are up-to-date
RUN apt update && apt upgrade -y && apt autoremove -y

## Install 'shinydashboard’ and other dependencies
RUN R -e "install.packages(c('htmltools', 'shinydashboard'))"

## Create a working directory
WORKDIR dashboard/

## Copy files over from our host PC into the container, keeping names the same
COPY annuity-app/app.R app.R
COPY annuity-app/annuities.csv annuities.csv 

## Open port 80
EXPOSE 80

## Run the dashboard over port 80                              
CMD R -e "shiny::runApp(port=80, host='0.0.0.0')"

