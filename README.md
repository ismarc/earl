# SETUP
This project uses docker and docker-compose for running the application. To get up and running:
1. docker-compose build
2. docker-compose up
3. docker-compose run web rake db:create
4. docker-compose run web rails db:migrate

To run, use ```docker-compose up``` and to shutdown, use ```docker-compose down```

# USAGE
## Redirects
Going to http://localhost:3000/<id> will redirect the browser to the appropriate shortened link
or 404 if the link does not exist.

## REST API
POST just the URL to shorten to http://localhost:3000/shorten
Request:
```
curl -v -X POST --data '{"link": "www.example.com"}' -H "Content-Type: application/json"  http://localhost:3000/shorten
```
Response:
```
< HTTP/1.1 200 OK
< X-Frame-Options: SAMEORIGIN
< X-XSS-Protection: 1; mode=block
< X-Content-Type-Options: nosniff
< Content-Type: text/plain; charset=utf-8
< ETag: W/"222df12b9e01b62a64877a37d46e989a"
< Cache-Control: max-age=0, private, must-revalidate
< X-Request-Id: 1b08b291-df35-4b89-be75-1cb92825bb31
< X-Runtime: 0.073209
< Transfer-Encoding: chunked
<
http://localhost:3000/fLRmGJmC
```

## User Interface
The relevant pages are:
http://localhost:3000/ and http://localhost:3000/links

This allows for new link creation and listing/detail view of links that exist.