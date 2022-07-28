#!/usr/bin/env bash

source ./checkss.sh

if [[ -f "./.env.sh" ]]; then
  source ./.env.sh
fi

export CEDAR_DOCKER_HOME=`realpath $CEDAR_DOCKER_HOME`
export CEDAR_HOME=`realpath $CEDAR_HOME`

# We will use these aliases to configure approriate env vars for dev/docker environments
shopt -s expand_aliases
alias ceddock="source ${CEDAR_DOCKER_HOME}/cedar-development/bin/templates/cedar-profile-docker-eval-1.sh; source ${CEDAR_DOCKER_HOME}/cedar-development/bin/templates/cedar-profile-docker-eval-2.sh"
alias ceddev="source ${CEDAR_HOME}/cedar-profile-native-develop.sh"

if [ ! -d "$CEDAR_HOME" ]
then
  echo "Creating $CEDAR_HOME directory"
  mkdir "$CEDAR_HOME"

  printf "\n\n++++ Cloning microservice repos"
  cd ${CEDAR_HOME}
  git clone https://github.com/metadatacenter/cedar-development
  cd cedar-development
  # Maybe develop branch
  git checkout master
  cd ..
  cp cedar-development/bin/templates/set-env-internal.sh .
  cp cedar-development/bin/templates/set-env-external.sh .
  cp cedar-development/bin/templates/cedar-profile-native-develop.sh .

  echo adsasdadsa $CEDAR_DEVELOP_HOME

  # source it now to have gocedar
  shopt -s expand_aliases
  source ${CEDAR_HOME}/cedar-profile-native-develop.sh
  # gocedar should work here instead of the 'cd' but it doesn't
  cd ${CEDAR_HOME}
  echo ${CEDAR_DEVELOP_HOME}/bin/util/git/git-clone-all.sh
  ${CEDAR_DEVELOP_HOME}/bin/util/git/git-clone-all.sh
  # Maybe develop branch
  cedargcheckout master
else
  echo "$CEDAR_HOME already exists"
fi




printf "\n+++++ Adding microservice mysql users: cedarMySQLMessagingUser, cedarMySQLLogUser\n\n"

# docker run -it --network cedarnet --rm mysql mysql --host=mysql -uroot --port=3306 --protocol=TCP -pchangeme

docker exec -i mysql mysql -uroot -pchangeme  << END
use mysql;
select user, host from user;
CREATE DATABASE IF NOT EXISTS cedar_messaging;
CREATE USER 'cedarMySQLMessagingUser'@'%' IDENTIFIED BY 'changeme';
GRANT ALL PRIVILEGES ON cedar_messaging.* TO 'cedarMySQLMessagingUser'@'%';
CREATE DATABASE IF NOT EXISTS cedar_log;
CREATE USER 'cedarMySQLLogUser'@'%' IDENTIFIED BY 'changeme';
GRANT ALL PRIVILEGES ON cedar_log.* TO 'cedarMySQLLogUser'@'%';
use mysql;
select user, host from user;
END


printf "\n+++++ Building microservice parent\n\n"

ceddev
goparent
mcit

printf "\n+++++ Building CEDAR microservices\n\n"

createjaxb2workaround
goproject
mcit

printf "\n+++++ Starting all CEDAR microservices for configuration\n\n"

( startall ) &

# Check for running services 30 times
sleep 15
for i in {1..30}; do
  checkss "Artifact Group Impex Internals Messaging OpenView Repo Resource Schema Submission Terminology User ValueRecommender Worker"
  if [[ $WAITING_FOR == "" ]]
  then
    printf "\n+++++ All up and running!\n\n"
    break
  else
    printf "\n+++++ Waiting for: $WAITING_FOR ($i/30)\n\n"
  fi
  sleep 3
done

if [[ ! $WAITING_FOR == "" ]]; then
    printf "\n+++++ Starting all CEDAR microservices failed. Not running: $WAITING_FOR.\n"
    killall java
    exit -1
fi

printf "\n+++++ Configuring CEDAR services\n\n"

# Automatically answer with 'yes'
yes yes | cedarat system-reset

