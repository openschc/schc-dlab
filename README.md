# SCHC Docker Lab

This repository contains the SCHC testing and learning Docker-based environment.


The Docker image, based on Ubuntu 22.04, includes the [CORE](https://github.com/coreemu/core) emulation project, which allows for easy setup and configuration of network environments for learning and experimentation.

Additionally, the provided XML file outlines the typical architecture for a SCHC solution.
Paired with [openschc](https://github.com/ltn22/openschc/tree/MOOC/), this architecture includes all the necessary components and configurations needed to implement SCHC in a network environment.

By utilizing this docker-based learning environment and the provided XML file, you can easily set up and explore SCHC solutions in a controlled and hands-on manner.
This repository is a valuable resource for those looking to deepen their understanding of network protocols and compression techniques.

## Setup

0. Make sure [Docker](https://www.docker.com/) is installed on your system (try running `docker info`). Follow the [installation procedure](https://docs.docker.com/engine/install/) **according to your platform**, as well as the post-installation steps to [manage docker as a non-root user](https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user).

  - Example for Ubuntu:

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

2. Clone this repository and use the `schc-dlab.sh` script, a command manager for the SCHC Docker Lab container.

```bash
cd ~
git clone https://github.com/openschc/schc-dlab.git
cd schc-dlab && ./schc-dlab.sh -h
```

The available commands are:

| Command   | Description                                  |
| --------- | -------------------------------------------- |
| install   | Build and run the schc-dlab docker container |
| start     | Start the schc-dlab container                |
| core      | Open the CORE program                        |
| wireshark | Open Wireshark                               |
| bash      | Open a bash session within the container     |
| stop      | Stop the schc-dlab container                 |
| remove    | Remove the schc-dlab container and image     |

4. Specify the location of your `openschc/` directory and `install` the schc-dlab container. This step might take a while.

```bash
export OPENSCHC_DIR=/home/coder/openschc  # <-- location of your openschc directory.
./schc-dlab.sh install
```

> *Note:* Your existing openschc repository will be mounted onto the schc-dlab container, so any changes remain persistent on your local drive and in the container. This means **you can edit the openschc files locally using your favorite text editor**.

5. With the Docker container up and running (check with `docker ps`), run the `core` schc-dlab command. The CORE program will open. 

```bash
./schc-dlab.sh core
```

6. Click on `File > Open...` and choose the `schc-ping.xml` file. Run the simulation using the green `Start Session` button. Double-click on each computer icon to access the `device`, `core`, or `App` system terminals. From here, you can follow the tutorials on [The Book Of SCHC](#) or test your own SCHC applications.

7. When done, you can use the `stop` schc-dlab command to stop the docker container. Next time you want to use it, just run the `start` command. If you want to "uninstall" schc-dlab, use the `remove` command.
