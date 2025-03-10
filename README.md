# SCHC Docker Lab

This repository contains the SCHC testing and learning Docker-based environment.


The Docker image, based on Ubuntu 22.04, includes the [CORE](https://github.com/coreemu/core) emulation project, which allows for easy setup and configuration of network environments for learning and experimentation.

Additionally, the provided XML file outlines the typical architecture for a SCHC solution.
Paired with [openschc](https://github.com/ltn22/openschc/tree/MOOC/), this architecture includes all the necessary components and configurations needed to implement SCHC in a network environment.

By utilizing this docker-based learning environment and the provided XML file, you can easily set up and explore SCHC solutions in a controlled and hands-on manner.
This repository is a valuable resource for those looking to deepen their understanding of network protocols and compression techniques.

## Setup

### Install Docker

On MacOS, it seems to be a problem with `brew install docker command` as some features are not loaded. MyMy advice is to download the Docker Desktop app directly [here](https://docs.docker.com/desktop/setup/install/mac-install/).

You also need XQuartz in order to run any GUI with Docker :
```bash
# Install XQuartz
brew install xquartz

# Launch XQuartz
open -a xquartz
```

Once XQuartz has been launched, you need to allow connections from network clients. Go to Preferences (⌘,), go to the "Security" tab, and then tick "Allow connections from network clients."

### Install dependencies and container

```bash
# Clone OpenSCHC and switch to MOOC branch
git clone https://github.com/ltn22/openschc.git
cd openschc ; git checkout MOOC

# Clone schc-dlab and switch to generic-mac branch
cd ..
git clone https://github.com/openschc/schc-dlab.git
cd schc-dlab ; git checkout generic_mac
# Display main script helper
./schc-dlab.sh -h
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
export OPENSCHC_DIR=/home/.../openschc  # <-- location of your openschc directory.
./schc-dlab.sh install
```

> *Note:* Your existing openschc repository will be mounted onto the schc-dlab container, so any changes remain persistent on your local drive and in the container. This means **you can edit the openschc files locally using your favorite text editor**.

5. With the Docker container up and running (check with `docker ps`), run the `core-daemon` and `core-gui` schc-dlab commands. The CORE program will open. 

```bash
./schc-dlab.sh core-daemon
./schc-dlab.sh core-gui
```

6. Click on `File > Open...` and choose the `schc-ping.xml` file. Run the simulation using the green `Start Session` button. Double-click on each computer icon to access the `device`, `core`, or `App` system terminals. From here, you can follow the tutorials on [The Book Of SCHC](#) or test your own SCHC applications.

7. When done, you can use the `stop` schc-dlab command to stop the docker container. Next time you want to use it, just run the `start` command. If you want to "uninstall" schc-dlab, use the `remove` command.