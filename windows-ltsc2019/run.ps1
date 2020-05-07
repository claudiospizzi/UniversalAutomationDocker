# Stop, remove, rebuild and start the containers
docker-compose stop
docker-compose rm -f
#docker volume rm windows-ltsc2019_app_database
docker-compose up -d --build3s
