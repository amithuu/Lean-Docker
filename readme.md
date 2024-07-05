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
    * docker run  -----------[docker run image_name]  --- to run the image so it creates container.
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
        -e ME_CONFIG_MONGODB_SERVER=mongodb \ [mongo_db container name]
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
    * docker-compose -f mongo.yaml up  [-f represent file_name]
        : this will cerate the docker network automatically and start the containers.
    * docker-compose -f mongo.yaml down  
        : this will delete the docker network automatically and stops the containers.
    



## Building A Dockerfile ###

    * the dockerfile is creating  [docker_image] using the js files.

    FROM node   [node is docker image {as our backend is running on nodejs backend, which is already there in docker pull node}]

    ENV MONGO_DB_USERNAME = admin
        MONGO_DB_PWD = password    [this is optional but better to add here, if any changes goes in yaml file still u will get it here]

    
    RUN mkdir -p /home/app   [we provide the file directory, same directory will be created inside the container.]
                [ using RUN we can make run any kind of linux commands to run.]


    COPY . /home/app    [we copy all our local command code to host [. represents the source code] [/home/app represents the target path to save the code]]

    CMD ['node", "/home/app/server.js]     [starts teh app with "node server.js"]


## Now using the above dockerfile we need to build the docker image ##

        : what we are doing now is done by Jenkins automatically, once we are done with code and dockerfile we push it to GIT and we will provide that to Jenkins, which builds the image.

    * Now we are doing it manually.
        "  cmd ---> docker build -t my-app:1.0 . "
            * ["-t" ---> is tag for naming the docker image] 
            * ["."  ---> is to get the Dockerfile form the current repository or directory]

    * my-app          1.0       5848fc38302b   About a minute ago   1.13GB
          * A docker image will be created  


## Once the docker is build and now u need to edit something in docker file, then u need to delete the old image and need to re-build it..

    CMD ["node", "server.js"] 
            * when u run the container we get error,
            * where it was not able to find server.js file.
            * so need to add the complete path to the server.js file. 
            * 
    CMD ["node", "/home/app/server.js"], 

    ** So now we need to delete the docker image and need to build new one.
        : docker rmi my-app:1.0  
    ** and build new one again. 
        : docker build -t my-app:1.0 .   



[#before this we need to ensure that both the backend mongo and mongo-express containers are running.]
## Now we need to run the image, which build the container. ##

        : docker run my-app:1.0 [image_name or id]


## let us check teh files inside the container.
    cmd --> docker exec -it container_id /bin/bash   ---> some files will have bash
    cmd --> docker exec -it container_id /bin/sh     ---> some files will have sh




## Docker Private Registry ###

    # we are pushing the Image to the Repository.
    * we are using AWS ECR[elastic container registry] [ where we push our image to]

    ## in AWS go to ECR, 
            ---> create Repository 
            ---> It will cerate an repo with the domain_name/repo_name
            ---> Click on View push option
            ---> We have to login to AWS, using AWS CLI needs to be installed , and Credentials configured.
            ---> We get the command in AWS itself to login, we need to run that command.  [login success]
        
        #naming in docker registries:
            :registryDomain/imageName:Tag 
                * docker pull mongo:4.2  [in backend it runs "docker pull docker.io/library.mongo:4.2" ]
                * we need to tag the our image to the repository, because we need to tag that repository_name to the image soo.. 
                * if we don't provide the repository_name then it will try to push in docker hub.
                
            ---> cmd "docker tag my-app:1.0 repository_name/my-app:1.0" 
                            [which will rename out image from my-app:1.0 to  repository_name/my-app:1.0]
                            [eg:  docker tag my-app:1.0 354645435/dkr.ecr.eu-central-1.amazonaws.com/my-app:1.0 ]

            ---> Now Try to push the image
            ---> docker push repository_name/my-app:1.0   
                        [eg:  docker push my-app:1.0 354645435/dkr.ecr.eu-central-1.amazonaws.com/my-app:1.0 ]
                        [now it will get to know where to push the images.. [to the aws from the above example..]] 

            ---> and image will pushed to repository in aws.

 ## This is how we push the image to aws ###

### if u have done any changes in the code, then u need to again create an image and build it and tag it and push it.. ###


# Deploy it to the server now..

version: '3'
services:
  my-app:  {front-end container}
    image: 54645435/dkr.ecr.eu-central-1.amazonaws.com/my-app:1.0   {image form aws}
    ports:
      - 3000:3000  {ports}
       
  mongodb:
    image: mongo
    ports:
      - 27017:27017
    environment:
      - MONGO_INITDB_ROOT_USERNAME=admin
      - MONGO_INITDB_ROOT_PASSWORD=password

  mongo-express:
    image: mongo-express
    restart: always # fixes MongoNetworkError when mongodb is not ready when mongo-express starts
    ports:
      - 8080:8081
    environment:
      - ME_CONFIG_MONGODB_ADMINUSERNAME=admin
      - ME_CONFIG_MONGODB_ADMINPASSWORD=password
      - ME_CONFIG_MONGODB_SERVER=mongodb



## Docker volumes ###

    Docker provides a virtual storage system, which can be used once, if u stop or restart the docker, then the whole data is lost.
        : this is called no persistent in storage

    # to solve this .
    Type sof volume:
        : Host Volumes
        : Anonymous Volumes
        : Named Volumes

    Host Volumes: [docker run -v /home/mount/data:/var/lib/mysql/data]
        :The connection is made from [Host Directory and the ContainerDirectory].
        : You decide where on the host file system teh reference is made or saved.

    Anonymous Volumes: [ docker run -v /var/lib/mysql/data]

        : we don't specify where the reference has to be created , the folder is created automatically by docker itself.
        : for each container a folder is generated thats gets mounted .

    Named Volume: [ docket run -v name:/var/lib/mysql/data ]
        : You can reference the volume by name.
        : The best to use in Production..

    
    ### How do we do it in docker-compose file. #####
        volumes:
            - db-data:/var/lib/mysql/data  [db-data is the named reference of the volume]


    ## These path are default paths for databases.
        MYSQL :      /var/lib/mysql/data
        POSTGRESQL : /var/lib/postgresql/data
        mongo :      /data/db

### How to find Docker Volumes Located ###

    :C:\ProgramData\docker\volumes

### When we connect containers when it is 2 or 3 containers it is ok, if we have more than 100 we need to make them automatic so, we use    ##### docker Orchestration or kubernetes. #### 

### adding volumes to the db ##
    version: '3'
services:
  my-app:  {front-end container}
    image: 54645435/dkr.ecr.eu-central-1.amazonaws.com/my-app:1.0   {image form aws}
    ports:
      - 3000:3000  {ports}
       
  mongodb:
    image: mongo
    ports:
      - 27017:27017
    environment:
      - MONGO_INITDB_ROOT_USERNAME=admin
      - MONGO_INITDB_ROOT_PASSWORD=password
    volumes:
      - mongo-data:/data/db  [mongo-data name of the file, /data/db is the default storage path og mongo_db ]

  mongo-express:
    image: mongo-express
    restart: always # fixes MongoNetworkError when mongodb is not ready when mongo-express starts
    ports:
      - 8080:8081
    environment:
      - ME_CONFIG_MONGODB_ADMINUSERNAME=admin
      - ME_CONFIG_MONGODB_ADMINPASSWORD=password
      - ME_CONFIG_MONGODB_SERVER=mongodb

volumes:      [ we define list of all the volumes you are using in any containers ]
    mongo-data:    [ this is one of teh volume name we use in mongo_db for data persistent]
        driver:local  [this is an extra info for docker to store data on physical local store system]
                [actual path will be created automatically by docker]