# SCHC Docker Lab

This repository contains the SCHC testing and learning Docker-based environment.


The Docker image, based on Ubuntu 22.04, includes the [CORE](https://github.com/coreemu/core) emulation project, which allows for easy setup and configuration of network environments for learning and experimentation.

Additionally, the provided XML file outlines the typical architecture for a SCHC solution.
Paired with [openschc](https://github.com/ltn22/openschc/tree/MOOC/), this architecture includes all the necessary components and configurations needed to implement SCHC in a network environment.

By utilizing this docker-based learning environment and the provided XML file, you can easily set up and explore SCHC solutions in a controlled and hands-on manner.
This repository is a valuable resource for those looking to deepen their understanding of network protocols and compression techniques.

## Setup

0. Make sure you have `docker` installed. Follow the [installation procedure](https://docs.docker.com/engine/install/) according to your platform, as well as the post-installation steps to [manage docker as a non-root user](https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user).

For Ubuntu:

```bash
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install the Docker packages:
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Manage Docker as a non-root user:
sudo groupadd docker
sudo usermod -aG docker $USER
echo "Log out and log back in so that your group membership is re-evaluated."
```

1. Clone [openschc](https://github.com/ltn22/openschc/tree/MOOC/) and switch to the `MOOC` branch.

```bash
cd ~
git clone https://github.com/ltn22/openschc.git
cd openschc && git checkout MOOC
```

2. Clone this repository and build the `core` Docker image.

```bash
cd ~
git clone https://github.com/lab-schc/schc-dlab.git 
cd schc-dlab && docker build -t core:schc-dlab .
```

3. Run the container using the following commands, specifying the location of your `openschc` directory.

```bash
export OPENSCHC_DIR=/home/coder/openschc  # <-- location of your openschc directory.
docker run -itd --name core -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
    -v ${OPENSCHC_DIR}:/root/openschc --privileged core:schc-dlab
xhost +local:root # enable xhost access to the root user
```

4. For ease of use, you can add these *aliases* into your `~/.bashrc` or `~/.bash_aliases` file, or use the commands between `" "` to `start` and `stop` the docker container, as well as running `core-daemon` and `core-gui`.

```bash
alias core-start="docker start core && xhost +local:root"   # to start the docker container
alias core-daemon="docker exec -it core core-daemon"        # to run the core-daemon
alias core-gui="docker exec -it core core-gui"              # to open the CORE GUI program
alias core-stop="docker stop core"                          # to stop the docker container
```

5. With the Docker container up and running (check with `docker ps`), run the `core-daemon` command, and then the `core-gui` command in another terminal. The CORE program will open. 


6. Click on `File > Open...` and choose the `schc-ping.xml` file. Run the simulation using the green `Start Session` button. Double-click on each computer icon to access the `device`, `core`, or `app` system terminals. From here, you can follow the tutorials on [The Book Of SCHC](#) or test your own SCHC applications.

