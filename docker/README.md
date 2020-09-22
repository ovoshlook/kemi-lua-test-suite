This an example of the docker container which allows to run tests in the docker, without kamailio dependancy

Build:
`docker build -t lua-kamailio-test -f ./Dockerfile.testSuite .`

Run
`sudo docker run -it -v $(pwd)/examples:/tests lua-kamailio-test:latest lua /tests/example-kamailio.lua`