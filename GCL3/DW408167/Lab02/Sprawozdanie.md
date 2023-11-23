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

RUN npm install
```

- `FROM` - we are using `node:latest` image as base for our image, same like we did when we were entering container.
- `RUN` - `git clone <REPO>` we are cloning our repository and installing dependencies. For almost every command we need to use `RUN` keyword.
- `WORKDIR` - we are changing working directory to `ts-script` folder. Don't use `cd` it's not persisted between commands.

```sh
sudo docker build -t node-bldr . -f Dockerfile-build
```

- `-t` - tag, we are giving name to our image
- `.` - path to folder with Dockerfile
- `-f` - name of Dockerfile


### Testing image - Dockerfile-test

Purpose of this image is only to run tests, which in node app is really simple, we just need to run `npm run test`, and check if all tests passed correctly.


```dockerfile
FROM node-bldr

RUN npm run test
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

