#!/bin/bash
#
#
# Author:	Domantas Giedraitis
#
#

AUTHOR="Domantas Giedraitis"
SCRIPT=$( basename "$0" )
VERSION="0.2.4"

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
"    -v |	--version			List the version"
"    		--dev				Use when in dev mode"
"		--build				Coherent build process for a freshly downloaded project"
"    		--stop				Stop all running containers"
"    		--prune				Delete images/volumes cache"
"		--destroy			Stop and remove all running or stopped containers, images, volumes, etc"
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
  printf "\n#############################################################"
  printf "\n\tInitializing the project... "
  printf "\n#############################################################"

  print_header "Starting-up Docker containers..."
  docker-compose up --force-recreate --remove-orphans --detach

  print_header "Let composer to do it's magic..."
  docker-compose exec app composer install #-q

  print_header "Generating unique app key..."
  docker-compose exec app php artisan key:generate

  print_header "Allowing containers to load before proceeding..."
  for i in {1..5}
  do
    printf "\r${LIGHT_PURPLE}Waiting for containers to load before seeding the database $((5 - $i))...${NO_COLOR}"
    sleep 1s
  done

  print_header "Docker containers status..."
  docker-compose ps

  print_header "Seeding database..."
  docker-compose exec app php artisan migrate:fresh --seed


  # Let user to glance at the seeding output
  sleep 1s


  clear -x
  print_header "App is Up & Running. Enjoy!\n"
}

#########################################
#    App Starts
#########################################

while (( $# ))
do
  case "$1" in

    --build)
      start_containers
      exit 0
    ;;

    --dev)
      docker-compose up --force-recreate
      docker-compose exec npm npm run watch
      exit 0
    ;;

    --stop)
      docker-compose down
      exit 0
    ;;

    --destroy)
      print_header "Stop all running containers"
      docker stop $(docker ps -q)

      print_header "Prune the (docker) system"
      docker system prune --all --volumes --force
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

    *)
      printf "Command not found. Did you made a spelling mistake?\n"
      exit 1
    ;;
  esac
done
