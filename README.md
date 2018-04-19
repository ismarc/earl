# SETUP
This project uses docker and docker-compose for running the application. To get up and running:
1. docker-compose build
2. docker-compose up
3. docker-compose run web rake db:create
4. docker-compose run web rails db:migrate

To run, use ```docker-compose up``` and to shutdown, use ```docker-compose down```