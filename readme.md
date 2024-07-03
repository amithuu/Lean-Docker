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


### Connect front end and Data Base ###

    * Now we have Written Code a sample code using html and java script [which runs on port 3000] 
    * We are using MangoDB database, and for ui of database we sue MongoDB express.
                * docker pull mongo and docker pull mongo-express 
  
    * We will first connect the MongoDB and Mongo-express. [so that db will run]
    *  

## Docker Network ##
## How to connect both MangoDb and Mango-express ###
    ** Docker created its own Isolated Docker network, where the containers are running.
        * when we Deploy 2 containers in a Docket network, }they can talk to each other using just the container Name}.
        * The outside network has to connect through localhost:port-number.
        * Later when we package our application into our own docker image, 
        * Now we will be having all the frontend and db in a single isolated network container.

    * we need to create network for each of the containers
            cmd-> docker network create mongo-network [network name what ever we want]
            * docker network ls [list of networks]
    
    * now we need to setup and run mango [we need to provide port_id, user_name, password,container_name,network_name, image_name]
            cmd-> docker run -d \ 
            -p 27017:27017 \   [the default port of mongo_db]
            -e MONGO_INITDB_ROOT_USERNAME= admin \    [these are the env variables -e]
            -e MONGO_INITDB_ROOT_PASSWORD= password \
            --name mongodb \
            --net mango-network \
            mongo 
        
    * now we need to setup and run mango-express Ui [we need to provide port_id, user_name_of_mongodb, password_of_mongodb,container_name,  network_name, image_name, mongo-db_container_name]
      
        cmd -> dicker run -d \
        -p 8081:8081  [the default port of mongo_express]
        -e ME_CONFIG_MONGODB_ADMINUSERNAME=admin \ [mongo_db username]
        -e ME_CONFIG_MONGODB_ADMINPASSWORD=password \ [mongo_db password]
        --net mongo-network \
        --name mongo-express \
        -e ME_CONFIG_MONGODB_SERVER=mongodb \ [mongo_db server name]
        mongo-express

# commands 

### create docker network ###
* cmd-> docker network create mongo-network

### start mongodb ###
* cmd-> docker run -d \ 
        -p 27017:27017 \   [the default port of mongo_db]
        -e MONGO_INITDB_ROOT_USERNAME=admin \    [these are the env variables -e]
        -e MONGO_INITDB_ROOT_PASSWORD=password \
        --name mongodb \
        --net mongo-network \
        mongo 

### start mongo-express ###
*cmd -> docker run -d \
    -p 8081:8081 \ [the default port of mongo_express]
    -e ME_CONFIG_MONGODB_ADMINUSERNAME=admin \ [mongo_db username]
    -e ME_CONFIG_MONGODB_ADMINPASSWORD=password \ [mongo_db password]
    -e ME_CONFIG_MONGODB_SERVER=mongodb \ [mongo_db server name]
    --net mongo-network \
    --name mongo-express \
    mongo-express    

        : Using teh above 2 commands tye mongodb and express has to connect. 
        : As both the Db's are available in a container, so they will in a single isolated Docker network
        : To connect the JS we need to write the YAML and DOCKERFILE in the Code.
            [to run js file npn install---> node server.js] [the FE will run on 3000 port]



### How and Why do we create .yaml file? ###
    
    : If you see the above commands to connect and run every containers we need to wrote a large lines of command, to make it less and automatic, we write this file.

    filename.yaml
        version: '3'
        services:
            mongodb:     ---> container_name
                image: mongo      ----> image _name
                ports:
                 -27017:27017
                environment:
                 - MONGO_INITDB_ROOT_USERNAME=admin
                 - MONGO_INITDB_ROOT_PASSWORD=password
                 - 
            # Till here one service or container

            mongo-express: ---> container_name
                image: mongo-express     ----> image_name
                ports:
                 -8081:8081
                environment:
                 - ME_CONFIG_MONGODB_ADMINUSERNAME=admin
                 - ME_CONFIG_MONGODB_ADMINPASSWORD=password
                 - ME_CONFIG_MONGODB_SERVER=mongodb

# the indentation of service name should be in same indentation. 

## to run the docker file we run
    * docker-compose -f mongo.yaml   [-f represent file_name]