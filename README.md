# Containerised Laravel Template
Template for laravel applications using docker containers.

This template uses:
- Nginx
- PHP 7.4^ + Composer
- MySQL
- NPM

________________
### Requirements

* [Docker Desktop](https://www.docker.com/products/docker-desktop) for Windows/Mac OS, or [Docker Engine](https://docs.docker.com/engine/install/ubuntu/) for Ubuntu/Other Linux distributions.
* A connection to the [MySQL](https://www.mysql.com/) database


________________
### Steps
##### Downloading Project
1. Clone this repository to your local machine.
    ```bash
    $ git clone https://github.com/Navusas/docker-laravel-template.git
    ```
2. Locate to the project's root directory
    ```bash
    $ cd docker-laravel-template/
    ```
   

##### Create / Modify Environments
###### Docker Environment
1. While in parent project's directory, copy the docker environment example and rename to ```.env```
    ```bash
    $ cp .env.example .env 
    ```
2. Use preferred editor and modify the ```.env``` file
    ```bash
    $ nano .env
   
    $ DB_DATABASE=<database name>
    $ DB_USERNAME=<database root username>
    $ DB_PASSWORD=<database root password>
    $ DB_ROOT_PASSWORD=<database root password>
    $ SERVICE_TAGS=dev <do not change>
    $ SERVICE_NAME=mysql <do not change>
    ```

##### Install your Laravel project or move your existing project under src/ folder at this point. 


###### Project Environment
1. Locate to ```.src/``` and rename the example environment to ```.env```
    ```bash 
    $ cd src/
    $ cp .env.example .env
    $ nano .env
    ```
2. Modify the ```.env``` file as per your requirements.
    ```bash
    $ DB_CONNECTION=mysql <do not change>
    $ DB_HOST=mysql <do not change>
    $ DB_PORT=3306 <do not change>
    $ DB_DATABASE=<database name>
    $ DB_USERNAME=<database root username>
    $ DB_PASSWORD=<database root password>
    ```
   *The ```DB_DATABASE```, ```DB_USERNAME``` and ```DB_PASSWORD``` **must be the identical** to those set in the Docker Environment*



##### Finally - Launch Application


_Editor's Suggestion: perform ```./app.sh --destroy``` (or at least ```./app.sh --stop```) before building the project. This way, a "clean start-up" can be guaranteed._


In order to launch the application use the integrated bash script - ```app.sh``` located in the root project's directory.
 ```bash
 $ cd ../
 $ ./app.sh --build
 ```
_The build process will take ~2 minutes (may take longer depending on your internet speed)_

**_Note: Visit [this link](https://github.com/advanced-web/advanced-application-Navusas/wiki/Guide-for-using-app.sh-script) for further information on how to use ```app.sh``` script_**
