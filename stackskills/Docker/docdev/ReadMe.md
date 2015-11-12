Instructions

Unit 1 No source code

Unit 2 Practical create a Devopps with Docker.
java class eduonix.dockerphaseone.HelloDocker
rename the 'DockerfileNoVagrant' in the top level source to 'Dockerfile'
change the following line 78 in the pom.xml file to
<mainClass>eduonix.dockerphaseone.HelloDocker</mainClass>

Unit 2  Lab Exercise Docker Deployment
java class eduonix.dockerphaseone.LabSolutionServer
rename the 'DockerfileNoVagrant' in the top level source to 'Dockerfile'
change the following line 78 in the pom.xml file to
<mainClass>eduonix.dockerphaseone.LabSolutionServer</mainClass>

Docker commands:
FROM: Building a Web Application using Docker Part A
# Run a named container

2. Build the image
docker build -t="mrgaryg/javadev:1.0.0" .

2a Clean up  old containers
docker rm $(docker ps -aq)

3. run the container
docker run -d -p 8080:8080 --name docdev mrgaryg/javadev:1.0.0

FROM:Building a Web Application using Docker Part B
# Run an interactive container
docker run -d -p 8080:8080 -t -i --name docdev mrgaryg/javadev:1.0.0

docker attach docdev

curl -l http://localhost:8080/dockerapp

docker 

Unit 3  Practical create a DataContainer with Docker.
/datacontainer and /datauser  directory Dockerfiles require no changes

Unit 3  Lab Exercise Docker Container’s Users and Groups.
/datacontainer and /datauser  directory Dockerfiles require no changes


Unit 4  Practical create a Devopps with Docker.
rename the 'Dockerfile' in the top level source to 'DockerfileNoVagrant'
rename the 'DockerfileWithVagrant' in the top level source to 'Dockerfile'
