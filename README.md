# A portable python development environment

### Purpose
 * No setup required. No thinking about requirements, environment management, or toolchain.
 * Isolated environment. Add dependencies, versions, vim plugins, even non-python libraries without any fear of breaking your setup elsewhere. If you mess it up, just rebuild!
 * Customizable workflow per project. If you want to run a webserver in another tmux pane, change the formatting style or auto-start a docker-compose'd set up, those can all be automatic defaults.

### Hoes does it work?
This repo represents a generic development environment for python, entirely project agnostic. You *could* use it directly for something quick, but it won't have project dependencies installed which makes any *execution* impossible. Instead, this image is intended to be a parent image for a project-specific setup. You can find an annotated example of a project-specific image in the examples directory. 

### Features
It's a vim python development environment with sane defaults. Only some of your favorite bindings are overriden.

**Built in functionality**
* `fd` is bound to escape in all modes
* Backups are written to `~/.vim_backups`
* `Shift-j` and `Shift-k` for faster scrolling
* `Ctrl-j`/`Ctrl-k`/`Ctrl-h`/`Ctrl-l` for buffer movement
* Typical vim tags setup: `Ctrl-]` to jump to a definition for a function/class/etc.
  * I've taken the liberty of generating tags for dependencies as well, which is much easier to do in this isolated setup. You can jump to library source code as if it were your own code. 

**Plugins**
* `fzf` for file navigation
  * `<Space>f` will open a fuzzy file name search with a preview window
  * `<Space><Shift>f` will open a fuzzy full-text search
* `deoplete` + `jedi` for autocompletion. No actions required.
* `vim-test` for testing
  * `Ctrl-t n` to run the nearest test when you're in a test file
  * `Ctrl-t f` to run the whole current file of tests
  * `Ctrl-t a` to run all tests for the whole suite/project
  * `Ctrl-t t` re-run whatever test or set of tests you most recently ran. You *don't* still have to be in the test file.
  * `Ctrl-t v` go back to the most recently run test
* `semshi` for python-specific highlighting and error messages
  * `semshi` will display an error marker in the left gutter when there's a syntax issue.
  * `<Space>e` will jump to the next error and display the error message to make cleanup quicker

### Usage
1. Create a project specific image with this as the parent image. [Here's an example](https://github.com/doneel/python-dev-base/blob/master/examples/Dockerfile).
   1. The *simplest* possible file would look something like this:
     ```
       FROM danieloneel/python-dev-base:latest
       COPY requirements.txt /app/requirements.txt
       WORKDIR /app
       RUN pip install --user -r /app/requirements.txt
       ENTRYPOINT ["bin/bash"]
     ```
   2. In order to be able to include the requirements file in the container (and install the dependencies), you need to run the docker build command from the project base directory. Personally, I prefer not to have this dockerfile sitting in project's root directory, so I prefer to put it in a subdirectory, like 'development-env':
     ```
      docker build --pull -t my-project-dev-env -f development-env/Dockerfile .
     ```
2. Run your docker container and mount your project (from your host machine) into the `/app` directory of the container:
   1. Most simply
   ```
    docker run -it -v ~/my_repos/my_project:/app/ my-project-dev-env:latest
   ```
   2. Docker's default shortcut to deatch from within a container is `Ctrl-p Ctrl-q`, so it intercepts anytime you type `Ctrl-p` in the container. This is super annoying for scrolling in bash, so I add an additional argument to change that mapping: 
   ```
    --detach-keys='ctrl-x,x' 
   ```
   3. It's pretty common to use docker to run containers (like running your app while you develop). If you want to be able to issue docker commands from within your dev environment instead of having to have a separate window for your host computer, you can mount your host's docker socket into the container so that your container can talk to the docker daemon like any other program on your host machine:
    ```
     --privileged -v /var/run/docker.sock:/var/run/docker.sock
    ```
   4. Git and ssh configs are necessary to push to git remotes that require credentials:
    ```
     -v $SSH_AUTH_SOCK:$SSH_AUTH_SOCK -e SSH_AUTH_SOCK=$SSH_AUTH_SOCK -v ~/.gitconfig:/home/developer/.gitconfig -v ~/.ssh:/home/developer/.ssh/
    ```

   4. **tl;dr** just run
    ```
     docker run -it --rm -v $PWD/:/app/ --detach-keys='ctrl-x,x' --privileged -v /var/run/docker.sock:/var/run/docker.sock -v $SSH_AUTH_SOCK:$SSH_AUTH_SOCK -e SSH_AUTH_SOCK=$SSH_AUTH_SOCK -v ~/.gitconfig:/home/developer/.gitconfig -v ~/.ssh:/home/developer/.ssh/ my-project-dev-env:latest
    ```

## FAQ
* Why would you use this?
  * https://xkcd.com/1987/
  * https://i.redd.it/pq4ynz1yaqn51.jpg

* Dude your vim environment is (heretical/confusing/missing my favorite plugin)
  Thanks for the feedback. Feel free to mount your own personal vim setup by adding an additional argument when you start the container. Note this container is running neovim, so:
  ```
  --mount type=bind,source=~/.vimrc,target=~/.config/nvim/init.vim
  ```

* I can't use all my favorite git shortcuts/bash shortcuts in here!
  Another great use case for just mounting your personal `.bashrc` or `.bash_profile` in the container:
  ```
  --mount type=bind,source=~/.bashrc,target=/home/developer/.bashrc
  ```

* Could I do this but still use PyCharm?
  Actually yes. [PyCharm Professional supports remote interpreters](https://www.jetbrains.com/help/pycharm/using-docker-as-a-remote-interpreter.html#intro) which would allow you run PyCharm on your host machine and outsource the python configuration to this docker container. 

## Debug help
### ssh config errors
```
/home/developer/.ssh/config: line 2: Bad configuration option: usekeychain
/home/developer/.ssh/config: terminating, 1 bad configuration options
```
`usekeychain` is a command that OS X understands, but the linux image we're using here doesn't. Fortunately, ssh configs have a convenient way of handling this, just add to the top of your `~/.ssh/config`: 
```
IgnoreUnknown  UseKeychain,AddKeysToAgent
```


