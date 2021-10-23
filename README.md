need to manually setup the initial wiki setting and copy that database into the container
need to set wiki url to localhost:3000


## Building the container

```bash
$ docker build --build-arg GIT_COMMIT=$(git rev-parse -q --verify HEAD) --build-arg BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ") -t judi:latest .
```


## Running the container

```bash
$ docker run --rm -it -p 3000:3000 -p 8888:8888 -v "$(pwd)/course:/course" judi:latest
```

This container is designed to be run in the foreground.
It will run a wiki.js server and a jupyter notebooks server in the background and provide the user with a bash shell

## Using the container


### Git
To configure git within the container this can be done manually by running the `git config` commands or by using the environment variables

`GIT_EMAIL='student@example.com'`, `GIT_NAME="My StudentName"`

These environment variables can be configured when you run the docker container

```bash
$ dockr run -it --rm -e GIT_EMAIL='student@example.com' -e GIT_NAME="My StudentName" judi:latest
```

### Wiki

The wiki can be found at http://localhost:3000

Username: admin@example.com
Password: password


### Jupyter Notebooks

The jupyter notebooks site can be found at http://localhost:8888

Password: password


## Software Licence

This project is licensed under the GPLv3 licence.
This is a strong copy left licence that requires that any derivative work is released under the same licence.
This was selected because the objective of this project is to provide a tool that can be used by others because it is something that is useful to us.
We believe that carrying that forward will be beneficial to the community.

#### TODO:

These are some of the tasks that can still be done to make it better

- automatically generate an ssh keypair to be used for git
- seed the wiki with some initial content
- specify a specific version for jupyter
- add bash completions for the main tools that have been installed
- add a MOTD to when the container starts up to give a little bit of usage information
- get all of the log messages for jupyter and the wiki to go to a log file
