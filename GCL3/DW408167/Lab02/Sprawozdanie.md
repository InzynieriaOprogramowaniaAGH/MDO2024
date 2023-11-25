# Docker files

If you didn't configure docker yet, or virtual machine go through these [steps](../start.md)

> ## Syllabus
>
> - [How to create and enter docker container](#Enter-docker-container)
> - [How to build docker image](#Build-own-docker-image)
> - basic command on building docker image in dockerfile

**Table of contents**

<!-- TOC -->
* [Docker files](#docker-files)
  * [Enter docker container](#enter-docker-container)
    * [Run our app in docker](#run-our-app-in-docker)
    * [How to exit container?](#how-to-exit-container)
  * [Build own docker image](#build-own-docker-image)
    * [Building image - Dockerfile-build](#building-image---dockerfile-build)
    * [Testing image - Dockerfile-test](#testing-image---dockerfile-test)
  * [Docker compose](#docker-compose)
    * [Dockerfile.build](#dockerfilebuild)
    * [Dockerfile.test](#dockerfiletest)
    * [docker-compose.yml](#docker-composeyml)
<!-- TOC -->


## Enter docker container

If we want to enter docker container (if we don't have image it will be pulled automatically) we can use command:

```sh
docker run -it node bash
```

Like you can see above we are using `node` image, which is based on `debian` image.


> ### Why `node` variant?
>
> We are using fat node version because we want to have all tools already prepared, in `apline` and `slim` there isn't `git` which we need to use to pull our repository.
> 
> Ofc we can install git manually, but in this case we will use fully prepared version.
> 
> If you want to enter `node:apline` or `node:slim` variant use `sh` instead of `bash`, simply these variants doesn't have **bash** shell.
> 
> `docker run -it node:apline sh`

> ### Why **latest** version of `node`?
>
> In our application right now we are not using any dependencies or features, that doesn't exist in latest version. Until we will, we can use latest version.


### Run our app in docker

We are building node application, so all dependencies are in `package.json` file, so we need to install them.

Firstly we are starting with cloning our repository:

```sh
git clone https://github.com/DaW888/ts-script
```

Next let's go enter folder with code and install dependencies:

```sh
cd ts-script

npm install
```

We can run app to check if it starts correctly by using command:

```sh
npm start
```

And run tests to check if all of them are passing:

```sh
npm test
```

Everything works fine, so we can exit container and go back to our host system.

### How to exit container?
click: **`control + D`**

or type: `exit`


To show your images  use command:

```sh
sudo docker images
```

**Output**

| REPOSITORY  | TAG    | IMAGE ID     | CREATED      | SIZE   |
|-------------|--------|--------------|--------------|--------|
| node        | slim   | 3eae05bac892 | 7 days ago   | 227MB  |  
| node        | latest | 8dbe454d6fd6 | 7 days ago   | 1.1GB  |  
| node        | alpine | ece0d10eb54d | 7 days ago   | 140MB  |  
| busybox     | latest | fc9db2894f4e | 4 months ago | 4.04MB | 
| hello-world | latest | b038788ddb22 | 6 months ago | 9.14kB | 

Here we can see all images that we have pulled on our system.

You can also notice here difference between variants of `node` images.


## Build own docker image

Let's create 2 images, first one for building app, second one for testing built app.

For this purpose we will create 2 Dockerfiles:
- `Dockerfile-build`
- `Dockerfile-test`

> Remember these files don't have any extension.
> 
> Create them in new folder to keep things organized.


### Building image - Dockerfile-build

Start with file that will be used for building app.

Remember that we are not doing anything here, except preparing app which is completely ready for testing and running.

```dockerfile
FROM node:latest

RUN git clone https://github.com/DaW888/ts-script.git

WORKDIR ts-script

CMD ["npm", "install"]
```

- `FROM` - we are using `node:latest` image as base for our image, same like we did when we were entering container.
- `RUN` - `git clone <REPO>` we are cloning our repository and installing dependencies. For almost every command we need to use `RUN` keyword.
- `WORKDIR` - we are changing working directory to `ts-script` folder. Don't use `cd` it's not persisted between commands.
- `CMD` - the command the container executes by default when you launch the built image. A Dockerfile will only use the final `CMD` defined. The `CMD` can be overridden when starting a container with `docker run $image $other_command`.

```sh
sudo docker build -t node-bldr . -f Dockerfile-build
```

- `-t` - tag, we are giving name to our image
- `.` - path to folder with Dockerfile
- `-f` - name of Dockerfile


### Testing image - Dockerfile-test

Purpose of this image is only to run tests, which in node app is really simple, we just need to run `npm run test`, and check if all tests passed correctly.


```dockerfile
FROM bldr

CMD ["npm", "run", "test"]
```

`FROM node-bldr`  - we are using "building" image as base for testing image.
Thanks to that, we're focusing only on one thing.

Then we are going to building testing image, same like we did with building image.

```sh
sudo docker build -t node-test . -f Dockerfile-test
```

Watch-out on errors in dockerfile, often we can miss a command or make a typo, e.g.:

```
Error response from daemon: dockerfile parse error on line 3: unknown instruction: git
```

Now we know that we forgot to put `RUN` on the beginning of `git` command.

---

Now after running `sudo docker images` we should see 2 new images `node-bldr` and `node-test`.

| REPOSITORY  | TAG    | IMAGE ID     | CREATED      | SIZE   |
|-------------|--------|--------------|--------------|--------|
| node-bldr   | latest | 8f68cb33ae38 | 5 days ago   | 1.3GB  |  
| node-test   | latest | 8f68cb33ae38 | 5 days ago   | 1.3GB  |  
| node        | slim   | 3eae05bac892 | 7 days ago   | 227MB  |  
| node        | latest | 8dbe454d6fd6 | 7 days ago   | 1.1GB  |  
| node        | alpine | ece0d10eb54d | 7 days ago   | 140MB  |  
| busybox     | latest | fc9db2894f4e | 4 months ago | 4.04MB | 
| hello-world | latest | b038788ddb22 | 6 months ago | 9.14kB | 

## Docker compose

> Installation
> 
> `sudo dnf install docker-compose`

> ### What is docker compose?
> Compose is a tool for defining and running multi-container Docker applications. With Compose, you use a YAML file to configure your application's services. Then, with a single command, you create and start all the services from your configuration.
> 
> ~ [docker docs](https://docs.docker.com/compose/)

To create docker-compose we need to start with rewriting our Dockerfiles a bit.
Now we won't build `test` docker basing on `builder` but we will copy built app between containers.

### Dockerfile.build

Here we are using full version of node, because like you remember we need `git` to clone repository.

This file looks basically the same as without docker-compose.

```dockerfile
FROM node:latest
RUN git clone https://github.com/DaW888/ts-script.git
WORKDIR ts-script
CMD ["npm", "install"]
```

### Dockerfile.test

Now things are getting interesting, because we will modify test file.

First important thing is that we are no longer using full `node` variant, but `node:alpine` which is few times lighter.

```dockerfile
FROM node:alpine

COPY --from=app /ts-script /ts-script

WORKDIR /ts-script

CMD ["npm", "run", "test"]
```

- `COPY --from=app /ts-script /ts-script` - this command is copying `/ts-script` folder from `app` image to `/ts-script` folder in `node-test` image.


### docker-compose.yml

> Remember that docker-compose file is written in `yaml` format, so we need to be careful with spaces and tabs.

```yaml
version: '3.8'
services:
  app:
    build:
      context: .
      dockerfile: Dockerfile.build
    volumes:
      - .:/ts-script
    image: node-app:latest

  test:
    build:
      context: .
      dockerfile: Dockerfile.test
    depends_on:
      - app
    image: node-test:alpine
```

- `version` - Specifies the version of the docker-compose file format.
- `services` - This section defines the different services (containers) that make up your application. In our case, we have two services: `app` and `test`.
- `app` - The name of the first service. We can use what name we want.
- `build` - This section tells Docker how to build the image.
- `context` - Sets the build context to the current directory (.). This is where Docker looks for the Dockerfile and any files referenced by it.
- `dockerfile Dockerfile.build` -Specifies the Dockerfile to use for this service, which in this case is `Dockerfile.build`.
- `volumes` - Here, we are mounting a volume.
  - `.:/ts-script`: This line mounts the current directory (on the host) into the **container** at the `/ts-script` path. This is useful for development, as it allows changes made to the source code on the host to be immediately reflected in the container.
- `image` - Names the image as `node-app:latest`. This name will be used if you decide to build the image and use it elsewhere.
- `depends_on: - app`: This specifies that the `test` service depends on the `app` service. Docker Compose will start the `app` service first before starting the `test` service.


To run docker-compose we need to use command:

```sh
sudo docker-compose up
```