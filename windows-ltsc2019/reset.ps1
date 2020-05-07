# Stop and remove container with volume. Then start again.
docker-compose stop
docker-compose rm -f
docker volume rm windows-ltsc2019_app_database
docker-compose up -d --build
