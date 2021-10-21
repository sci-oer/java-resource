need to manually setup the initial wiki setting and copy that database into the container
need to set wiki url to localhost:3000



## Building the container

```bash
$ docker build -t judi:latest .
```


## Running the container

```bash
$ docker run --rm -it -p 3000:3000 -p 8888:8888 -v "$(pwd)/wiki:/wiki" -v "$(pwd)/jupyter:/jupyter" judi:latest
```

This container is designed to be run in the foreground.
It will run a wiki.js server and a jupyter notebooks server in the background and provide the user with a bash shell

## Using the container


### Git
To configure git within the container this can be done manually by running the `git config` commands or by using the envirionment variables

`GIT_EMAIL='student@example.com'`, `GIT_NAME="My StudentName"`

These envirionment variables can be configurd when you run the docker container

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



#### TODO:

These are some of the tasks that can still be done to make it better

- automatically generate an ssh keypair to be used for git
- add the volume mount points to the dockerfile
- change the working directory to a workdir
- seed the wiki with some initial content
- make the wiki version configurable
- specify a specific version for jupyter
- set docker file labels
- add bash completions for the main tools that have been installed
