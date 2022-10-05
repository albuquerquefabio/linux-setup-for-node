echo  "-------------------------------------------------"
echo  "|                                                 |"
echo  "|  Welcome to the installation of the             |"
echo  "|  Node environment                               |"
echo  "|                                                 |"
echo  "-------------------------------------------------"

# INSTALL ESSENTIALS PACK FOR LINUX
echo "-------------------------------------------------"
echo "|                                                 |"
echo "|  Installing essential packages                  |"
echo "|                                                 |"
echo "-------------------------------------------------"
sudo apt-get update && \
    apt-get install -y \
      curl \
      jq \
      git \
      wget \
      openssl \
      bash \
      tar \
      pkg-config \
      build-essential \
      libssl-dev libffi-dev libblas3 libc6 liblapack3 gcc \
      python \
      python2 \
      python3 \
      net-tools

# INSTALL DOCKER
echo "-------------------------------------------------"
echo "|                                                 |"
echo "|  Installing Docker                              |"
echo "|                                                 |"
echo "-------------------------------------------------"
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
sudo usermod -aG docker $USER
sudo systemctl enable docker
sudo systemctl start docker

  
# INSTALL NODEJS WITH NVM
echo "-------------------------------------------------"
echo "|                                                 |"
echo "|  Installing NodeJS with NVM                     |"
echo "|                                                 |"
echo "-------------------------------------------------"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

NODE_VERSION=14.19.3

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

nvm install $NODE_VERSION && nvm use $NODE_VERSION && nvm alias default $NODE_VERSION


# INSTALL NODEJS GLOBAL DEPENDENCIES
echo "-------------------------------------------------"
echo "|                                                 |"
echo "|  Installing NodeJS global dependencies          |"
echo "|                                                 |"
echo "-------------------------------------------------"
npm i -g node-gyp@8.0.0
npm i -g node-pre-gyp
npm i -g yarn
npm i -g pm2
npm i -g @vue/cli@4.5.12

# INSTALL NODEJS LOCAL DEPENDENCIES
echo "-------------------------------------------------"
echo "|                                                 |"
echo "|  Installing NodeJS local dependencies           |"
echo "|                                                 |"
echo "-------------------------------------------------"
yarn install --ignore-engines

# PROJECT BUILD AND DOCKER UP AND FIRST START PROJECT
echo "-------------------------------------------------"
echo "|                                                 |"
echo "|  PROJECT BUILD AND                              |"
echo "|  DOCKER UP AND                                  |"
echo "|  FIRST START PROJECT                            |"
echo "|                                                 |"
echo "-------------------------------------------------"
yarn wrap


# PM2 FREEZING SERVER STATE
echo "-------------------------------------------------"
echo "|                                                 |"
echo "|  PM2 freezing server state                      |"
echo "|                                                 |"
echo "-------------------------------------------------"
pm2 startup
sudo env PATH=$PATH:/home/$USER/.nvm/versions/node/v$NODE_VERSION/bin /home/$USER/.nvm/versions/node/v$NODE_VERSION/lib/node_modules/pm2/bin/pm2 startup launchd -u $USER --hp /home/$USER
pm2 save

