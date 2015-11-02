# download a image with java 8
FROM java:8
MAINTAINER Eduonix
# Install maven into the image
RUN     apt-get update && \
        apt-get install -y maven
# create a work directory 'code' this is where we will build and run our application
WORKDIR /code
# Add the build tool files and source code
COPY  pom.xml /code/pom.xml
# Adding source, compile
COPY  src /code/src
RUN ["mvn", "package"]
# run the application
CMD ["mvn", "exec:java"]

