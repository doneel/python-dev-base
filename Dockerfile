# Python 3.6.5
FROM python:3.6-buster
# author of file
LABEL maintainer=”danieloneel@gmail.com”


########## USER MANAGEMENT ########## 
RUN apt-get update
RUN apt-get install -y sudo
ENV DOCKER_USER developer
RUN adduser --disabled-password --gecos '' "$DOCKER_USER"
RUN adduser "$DOCKER_USER" sudo
# Give passwordless sudo. This is only acceptable as it is a private
# development environment not exposed to the outside world. Do NOT do this on
# your host machine or otherwise.
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER "$DOCKER_USER"
WORKDIR "/home/$DOCKER_USER"
RUN touch ~/.sudo_as_admin_successful # The sudo message is annoying, so skip it


########## BUILD CHAIN ########## 
RUN sudo apt-get install -y build-essential
RUN sudo apt-get install -y curl
RUN sudo apt-get install -y git
RUN sudo apt-get install -y openssh-client
RUN sudo apt-get install -y man-db
RUN sudo apt-get install -y bash-completion


########## TMUX EXPERIENCE ########## 
RUN sudo apt-get install -y tmux
COPY ./.tmux.conf /tmp/.tmux.conf
RUN cat /tmp/.tmux.conf > ~/.tmux.conf && sudo rm /tmp/.tmux.conf


########## BASH EXPERIENCE #########
COPY ./.bashrc /tmp/.bashrc
RUN cat /tmp/.bashrc > ~/.bashrc && sudo rm /tmp/.bashrc


########## VIM EXPERIENCE ########## 
RUN curl -LO https://github.com/BurntSushi/ripgrep/releases/download/11.0.2/ripgrep_11.0.2_amd64.deb
RUN sudo dpkg -i ripgrep_11.0.2_amd64.deb

RUN sudo apt-get install -y neovim
RUN sudo apt-get install -y universal-ctags

RUN pip3 install --user jedi
RUN pip install --user pynvim

RUN mkdir -p "$HOME/.config/nvim"
COPY ./init.vim /tmp/init.vim
RUN cat /tmp/init.vim > ~/.config/nvim/init.vim && \
	sudo rm /tmp/init.vim

RUN mkdir -p $HOME/.config/nvim/colors
RUN curl https://raw.githubusercontent.com/doneel/Config-Files/master/.vim/colors/molokai.vim > $HOME/.config/nvim/colors/molokai.vim
# Install vim-plug, our plugin manager
RUN curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
RUN nvim --headless +PlugInstall +qall > /dev/null

WORKDIR /app

USER root
RUN chown "$DOCKER_USER" -R /app
RUN chown "$DOCKER_USER" -R "/home/$DOCKER_USER"
USER "$DOCKER_USER"

ENTRYPOINT ["vim"]
