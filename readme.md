Whats is container:
    * A way to package application with all the necessary dependencies and configuration 
                    [dependencies=code/packages/libraries,configuration=.env_files]
    * Portable artifact, easily shared and moved around.
    * Makes the development and deployment process more efficient.

Where do containers live?
    * Container Repository [where we push our code/libraries/configuration]
    * Private Repository 
    * Public Repository for Docker [Docker Hub]

[Application_Development]
How Docker Application Development is useful:
    Before container:
      * for the project we need to install PostgreSQL and Redis and many more., 
      * what happens here is a MAC developer and linux developer both have install the dependencies separately.
      * while running binary files they might get errors.

    After containers:
      * We will add both the PostgreSQL and Redis and many more in a container and provide the container name to developers
      * They just need to run a single command [cmd docker run container_name]

* Own isolated environment 
* packaged with all needed configuration
* one command to install the app
* run same app with 2 different versions.

    
[Application_Deployment]
How Docker Application Deployment is useful:
    Before container:
        * The developers use to give a [jar_file] [how_to_setup_instructions] to the operation team.
        * By looking at the textual based documentation the operation team used to deploy it to the server.

    Due to this :
        * dependency version conflicts
        * misunderstandings of guide.
        
    After container:
        * Both the developers and operations team will work together to package the dependencies/application in a container .
        * Since it is already encapsulated in one single environment,no need of config any of these on the server.
        * We just need to run a docker command , that pulls the container image which is stored somewhere in repository and run it.

What is Containers?
    * Layers of images
    * Mostly Linux BAsed Images, because small in size
    * Application image on top.


Layers:
    postgres:10.10 -> Layer- application image


    alpine:3.10 -> Layer-linux based image
 


### BASIC COMMANDS ###
    * docker pull -----------[docker pull image_name]  --- install the packages from web 
    * docker run  -----------[docker run container_name]  --- to run the container
    * docker start ----------[docker start container_id]  ---
    * docker stop -----------[docker stop container_id]
    * docker ps   -----------[lists all the running containers]
    * docker exec -it container_id --------[to get into the container and check if it has any issues, by navigating to its directories]
                     [-it == interactive terminal]
    * docker logs container_id-----------[to get the logs history of the container]
    * docker images ---------[lists all the docker images downloaded]
    * docker ps -a ----------[ lists the history]
    * docker run -phost_port:image_port imageid --- [to bind the ports]
    * docker run -d image_name ---------[ runs the container in detach mode]


### Difference between Image and container

image:The instructions to run the application.

container: contains the image[postgres, redis [like:libraries]], env configuration.
        * it is a running env for image.
        * virtual file system
        * it has dedicated port [5000] to run
        * image like [postgres,redis]  


#### How to bind the docker containers to host port #####
    * why we need to do
        * if we have multiple applications to run, when we run both the applications run's on same host port
        * which might get Conflict.
       
    * To avoid this we do Binding of Ports.
        * We have 2 images to run redis and redis:4.6, when they installed both were installed from [6379_Port], so they run on [6000-Port]
        * from this we get conflicts. to avoid we do binding.
       
        * docker run -p6000:6379 redis
        * docker run -p6001:6379 redis:4.6

### Debugging containers ####
        * if we need to see the logs of the containers
            * docker logs container_id
        
        * if we need to change the name of the container so that we can identify easily
          * docker run -d -p6000:6379 --name new_name image
          
          * docker run -d -p6001:6379 --name redis_old redis:4.6
          * docker run -d -p6000:6379 --name redis_new redis 
          
#### Docker run and Docker start ####
        * docker run will create new containers and we have so many operation on it [like -d -p6001:6379 --name redis_old redis etc..etc..]
        * docker start will start the container by updating the data what we did with run command.
       



#### Workflow with docker ####
    * Assume we are building a Python Project and we are using Mango DB database.
    * Instead of downloading Mango DB we pull the Mango DB from docker hub. 
    * once the development is done, we push the code to Git
    * From there it will be Pushed to Jenkins which build JS App's and create Docker Image.
    * From there we push that Image to Docker Repo.
    * We pull both the JS and Mango DB Image to Server.
    * we need to configure both the Image so that they can Talk to each other..
     