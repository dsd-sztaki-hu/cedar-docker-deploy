#!/bin/bash

export CEDAR_DOCKER_DEPLOY=${CEDAR_HOME}/cedar-docker-deploy
export CEDAR_DOCKER_BUILD=${CEDAR_HOME}/cedar-docker-build

alias gofrontend='cd $CEDAR_DOCKER_DEPLOY/cedar-frontend'
alias goinfrastructure='cd $CEDAR_DOCKER_DEPLOY/cedar-infrastructure'
alias gomicroservices='cd $CEDAR_DOCKER_DEPLOY/cedar-microservices'
alias goadmin='cd $CEDAR_DOCKER_DEPLOY/cedar-admin'

alias startfrontend='gofrontend && docker-compose up'
alias startfrontendext='gofrontend && docker-compose -f docker-compose.yml -f docker-compose-external-volumes.yml up'
alias startinfrastructure='goinfrastructure && docker-compose up'
alias startinfrastructureext='goinfrastructure && docker-compose -f docker-compose.yml -f docker-compose-external-volumes.yml up'
alias startmicroservices='gomicroservices && docker-compose up'
alias startmicroservicesext='gomicroservices && docker-compose -f docker-compose.yml -f docker-compose-external-volumes.yml up'
alias startadmin='goadmin && docker-compose up'

alias stopfrontend='gofrontend && docker-compose down'
alias stopfrontendext='gofrontend && docker-compose -f docker-compose.yml -f docker-compose-external-volumes.yml down'
alias stopinfrastructure='goinfrastructure && docker-compose down'
alias stopinfrastructureext='goinfrastructure && docker-compose -f docker-compose.yml -f docker-compose-external-volumes.yml down'
alias stopmicroservices='gomicroservices && docker-compose down'
alias stopmicroservicesext='gomicroservices && docker-compose -f docker-compose.yml -f docker-compose-external-volumes.yml down'
alias stopadmin='goadmin && docker-compose down'
