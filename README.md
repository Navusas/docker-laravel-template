# Containerised Laravel Template
Template for laravel applications using docker containers.

This template uses:
- Nginx
- PHP 7.4^ + Composer
- MySQL
- NPM


##Options of using it:
1. When in dev mode, a suggestion would be to simply use the following command, as it enables to see errors in NPM container

```docker-compose up```

_Note: This will use your terminal, as npm watch will be running on it._

2. When in production / review / test mode, a suggestion would be to use the given .sh script:

```./app.sh --full-start```

