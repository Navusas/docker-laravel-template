!/bin/bash

# Author: Domantas Giedraitis
# Date: 14/11/2020
# Version: 0.1
#
# Purpose:
#   This helper class minimizes the effort of containerizing and building the laravel application specified in the src/ file
#

LIGHT_PURPLE='\033[1;35m'
CYAN='\033[0;36m'
NO_COLOR='\033[0m'

print_header() {
  printf "${CYAN}"
  printf "\n\n###\t$1\n"
  printf "${NO_COLOR}"
}

start_containers() {
  clear -x

  printf "${CYAN}"
  printf "\n################################################"
  printf "\n\tInitializing the project..."
  printf "\n################################################"

  print_header "Starting-up Docker Containers"
  docker-compose build --compress --build-arg key=app --quiet
  docker-compose up -d


  print_header "Generating Laravel App Key"
  docker-compose exec app php artisan key:generate


  print_header "Allowing Containers to Load Properly"
  for i in {1..10}
  do
    printf "\r${LIGHT_PURPLE}Waiting for containers to load before seeding the database $((10 - $i))...${NO_COLOR}"
    sleep 1s
  done


  print_header "Docker Containers Status"
  docker-compose ps


  print_header "Seeding database..."
  docker-compose exec app php artisan migrate:fresh --seed


  # Let user to glance at the seeding outptu
  sleep 1s


  clear -x
  print_header "MyCarBoot App is Up and Running. Enjoy!\n"
}

stop_containers() {
  docker-compose down
}


#########################################
#    App Starts
#########################################
if [[ $1 == "--start" ]]; then
  start_containers
elif [[ $1 == "--stop" ]]; then
  docker-compose down
elif [[ $1 == "--remove-all" ]]; then
    read -p "Are you sure? This will stop and remove ALL your containers [y/N] " -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]; then
              all_containers=$(docker ps -a -q)
        for i in ${all_containers[@]}; do
            docker stop $i
            docker rm $i
        done
    fi
fi
