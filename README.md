[![Deployment](https://github.com/MarshallAsch/oo-resources/actions/workflows/deployment.yml/badge.svg)](https://github.com/MarshallAsch/oo-resources/actions/workflows/deployment.yml)
![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/marshallasch/oo-resources?style=plastic)
![Docker Pulls](https://img.shields.io/docker/pulls/marshallasch/oo-resources?style=plastic)

need to manually setup the initial wiki setting and copy that database into the container
need to set wiki url to localhost:3000


## Building the container

```bash
docker build \
    --build-arg GIT_COMMIT=$(git rev-parse -q --verify HEAD) \
    --build-arg BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ") \
    -t marshallasch/oo-resources:latest .
```


## Running the container

```bash
docker run --rm -it \
    -p 3000:3000 \
    -p 8888:8888 \
    -p 2222:22 \
    -v "$(pwd)/course:/course" \
    marshallasch/oo-resources:latest
```

This container is designed to be run in the foreground.
It will run a wiki.js server and a jupyter notebooks server in the background and provide the user with a bash shell

## Using the container


### Git
To configure git within the container this can be done manually by running the `git config` commands or by using the environment variables

`GIT_EMAIL='student@example.com'`, `GIT_NAME="My StudentName"`

These environment variables can be configured when you run the docker container

```bash
docker run -it --rm \
    -p 3000:3000 \
    -p 8888:8888 \
    -p 2222:22 \
    -e GIT_EMAIL='student@example.com' \
    -e GIT_NAME="My StudentName" \
    marshallasch/oo-resources:latest
```

### Wiki

The wiki can be found at http://localhost:3000

Username: admin@example.com
Password: password


### Jupyter Notebooks

The jupyter notebooks site can be found at http://localhost:8888

When you go to the jupyter notebooks page all of the builtin notebooks can be found in the `builtin` folder.
All of the notebooks that are in the `builtin` folder are provided by the container, they can be modified and the modifications will be persistent as long as the same volume mount is used.
If the volume is replaced then all the builtin notebooks will be replaced with fresh copies. 
All of the notebooks that are created will be saved in the `course/jupyter/notebooks` directory.

Any user settings that are changed (such as dark mode) will also be persistent.

### ssh to work on files using external editor

This container runs an ssh daemon and exposes port 22. 
You can ssh into this container by running `ssh -p 2222 student@127.0.0.1`. 
You do not need a password to ssh into the container, but the password is `password` for any command that needs it.

Any files that are edited should be put in the `/course/work` directory to be saved to the volume mount. 


Although you are able to ssh into this container, it is preferred to attach additional terminals to the container directly.
```bash
$ docker exec -it container_name bash
```

The name of the container can be gotten by running `docker ps` or it can be specified when the container is created by passing the `--name my_name` flag to `docker run`.

## Customization of this container

### How to configure custom wiki content

Any built in content to be included in the wiki must be added manually.
Unfortunately there is not currently an easy mechanism to automatically load markdown files from a directory into the wiki. 

To Load custom content into the container the following process is suggested:

1. Start the container _with_ the volume mount `docker run -it --rm -v "$(pwd)/course:/course" judi:latest`
2. Go to http://localhost:3000 and create all of the desired wiki pages and configurations
3. Exit the container
4. Replace the `database.sqlite` file with the new one from `course/wiki/database.sqlite`
5. Rebuild the container using the docker build command

Alternatively if there is a large number of wiki pages to import that already exist as markdown files an alternative process can be used.

1. Create the folder `course/wiki/files`
2. Place all of your markdown files to be imported into that folder, the files should have the following front matter so they can be imported with the desired title, tags, and if it should be published or not. Subfolder can also be used
```
---
title: Untitled Page
description:
isPublished: 1
tags: coma, separated, list
---
```
3. Start the container _with_ the volume mount `docker run -it --rm -v "$(pwd)/course:/course" marshallasch/oo-resources:latest`
4. Go to http://localhost:3000 and navigate to Administration > Storage > Local File System
5. Enable local file storage, set the Path to `/course/wiki/files`
6. Scroll to the bottom of the page and run `Import Everything`, now all of the wiki pages should be imported
7. Exit the container
8. Replace the `database.sqlite` file with the new one from `course/wiki/database.sqlite`
9. Rebuild the container using the docker build command

### How to configure builtin jupyter notebooks

Adding built in jupyter notebooks to the container is simpler. 
Place all the desired files in the `builtinNotebooks` folder, then build the image.

### Startup message

To change the startup message that gets printed when the container starts edit the text in `motd.txt` to include the desired text

### Extending this container with custom container

This image is designed to be used as a base image to be loaded with custom content for specific course deliveries. 

An example can be found in the `example` folder that will create an image with pre added jupyter notebooks and wiki configurations.
The steps to create the wiki configuration is the same as that for this container. 

## Software License

This project is licensed under the GPLv3 license.
This is a strong copy left license that requires that any derivative work is released under the same license.
This was selected because the objective of this project is to provide a tool that can be used by others because it is something that is useful to us.
We believe that carrying that forward will be beneficial to the community.

#### TODO:

These are some of the tasks that can still be done to make it better

- automatically generate an ssh keypair to be used for git
- seed the wiki with some initial content
- specify a specific version for jupyter
- add bash completions for the main tools that have been installed
