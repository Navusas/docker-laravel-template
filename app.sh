#!/bin/bash
#
# Author: Domantas Giedraitis
# Date: 14/11/2020
# Version: 0.1
#
# Author:	Domantas Giedraitis
#
#

AUTHOR="Domantas Giedraitis"
SCRIPT=$( basename "$0" )
VERSION="0.1.0"

# Constants
LIGHT_PURPLE='\033[1;35m'
CYAN='\033[0;36m'
NO_COLOR='\033[0m'

function usage
{
  local txt=(
"$SCIRPT is a Utility tool, which minimizes the effort of containerizing and building the laravel application."
"Author:	$AUTHOR"
"Usage: 	$SCRIPT [option]"
""
"	!! 1 option per run only 11"
""
""
"Options:"
"    -h	|	--help				Print this screen"
"    -v |	--version			List version"
"    		--start				Start only (Docker Compose Up)"
"		--full-start			Build and start all containers (takes 5 minutes)"
"    		--stop				Stop all running containers"
"    		--prune				Delete images/volumes cache"
)
  printf "%s\n" "${txt[@]}"
}

function version
{
  local txt=(
"$SCRIPT version $VERSION"
)

  printf "%s\n" "${txt[@]}"
}

print_header() {
  printf "${CYAN}"
  printf "\n\n###\t$1\n"
  printf "${NO_COLOR}"
}

start_containers() {
  clear -x

  printf "${CYAN}"
  printf "\n################################################"
  printf "\n\tInitializing the project... (This can take up to 5 minutes)"
  printf "\n################################################"

  print_header "Starting-up Docker Containers..."
  docker-compose build --compress --build-arg key=app --quiet
  docker-compose up -d


  print_header "Generating Laravel App Key..."
  docker-compose exec app php artisan key:generate


  print_header "Allowing Containers to Load Properly before proceeding..."
  for i in {1..10}
  do
    printf "\r${LIGHT_PURPLE}Waiting for containers to load before seeding the database $((10 - $i))...${NO_COLOR}"
    sleep 1s
  done


  print_header "Docker Containers Status..."
  docker-compose ps


  print_header "Seeding database..."
  docker-compose exec app php artisan migrate:fresh --seed


  # Let user to glance at the seeding output
  sleep 1s


  clear -x
  print_header "App is Up and Running. Enjoy!\n"
}

#########################################
#    App Starts
#########################################

while (( $# ))
do
  case "$1" in

    --full-start)
      start_containers
      exit 0
    ;;

    --start)
      docker-compose up
      exit 0
    ;;

    --stop)
      docker-compose down
      exit 0
    ;;

    --prune)
      docker system prune -a
      exit 0
    ;;

    --help | -h)
      usage
      exit 0
    ;;

    --version | -v)
      version
      exit 0
    ;;
  esac
done
