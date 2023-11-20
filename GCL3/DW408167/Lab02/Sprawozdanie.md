


Go into docker image by using command:

```sh
docker run -it node bash
```


> ### Why `node` variant?
>
> We are using fat node version because want to have all tools already prepared, in `apline` and `slim` there isn't `git` which we need to use to pull our repository.
> 
> Ofc we can install git manually, but in this case we will use fully prepared version.
> 
> If you want to enter `node:apline` or `node:slim` variant use `sh` instead of `bash`, simply these variants doesn't have **bash** shell.
> 
> `docker run -it node sh`

> ### Why **latest** version of node?
>
> In our application right now we are not using any dependencies or features, that doesn't exist in latest version. Until we will, we can use latest version.





W dockerze
```sh
git clone https://github.com/DaW888/ts-script
```

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




To show your images
```sh
sudo docker images
```

## How to exit container?

click: **`control + D`**

or type: `exit`


# Build

Lets create 2 images, first one for building app, secound one for testing builded app.

For this purpouse we will create 2 Dockerfiles:
- `Dockerfile-build`
- `Dockerfile-test`

> Remember these files don't any any extension.
> 
> Create them in new folder to keep things organized.


## Dockerfile-build

```dockerfile
FROM node:latest

RUN git clone https://github.com/DaW888/ts-script.git

WORKDIR ts-script

RUN npm install
```

```sh
sudo docker build -t node-bldr . -f Dockerfile-build
```


## Dockerfile-test

```dockerfile
FROM node-bldr

RUN npm run test
```


```sh
sudo docker build -t node-test . -f Dockerfile-test
```

Watchout on errors in dockerfile, often we can miss a command or make a typo, eg. like:

```
Error response from daemon: dockerfile parse error on line 3: unknown instruction: git
```

Now we know that we forgot to put `RUN` on the beginning of `git` command.