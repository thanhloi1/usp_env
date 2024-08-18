# obuspa_controller

This repository contains the necessary files to set up and manage an OB-USPA controller with MQTT support using Docker and WSL (Windows Subsystem for Linux). The setup is based on the OB-USPA Test Controller repository hosted at [IOPSYS GitLab](https://dev.iopsys.eu/bbf/obuspa-test-controller/-/tree/devel?ref_type=heads).

## Repository Structure

```plaintext
.
├── Dockerfile
├── ctrl_mqtt_msg_example.txt
├── docker_utils.sh
├── entrypoint.sh
├── mosquitto.conf
├── mqtt_default_configuration_reset.txt
├── restart_obuspc_controller.sh
└── setup_port_forwarding.sh
```

### File Descriptions

- **Dockerfile**: 
  - A Dockerfile used to build a Docker image for the OB-USPA controller. This image includes all necessary dependencies and configurations, and it is derived from the setup outlined in the OB-USPA Test Controller repository.

- **ctrl_mqtt_msg_example.txt**: 
  - An example configuration file that defines MQTT messages for controlling the OB-USPA agent. This file is used to simulate MQTT interactions as described in the OB-USPA Test Controller.

- **docker_utils.sh**: 
  - A utility script that provides various Docker-related commands, including building, running, and managing the Docker container. This script simplifies the process of interacting with the OB-USPA controller within the Docker environment.

- **entrypoint.sh**: 
  - The entry point script for the Docker container. It initializes the environment and starts the OB-USPA controller. This script is essential for setting up the controller in line with the configurations specified in the Dockerfile.

- **mosquitto.conf**: 
  - The configuration file for the Mosquitto MQTT broker. This file defines the settings for the MQTT broker used by the OB-USPA controller, ensuring that it is properly configured for secure and efficient communication.

- **mqtt_default_configuration_reset.txt**: 
  - A configuration file used to reset the MQTT settings of the OB-USPA controller to their default values. This file can be used to restore the controller to a known good state.

- **restart_obuspc_controller.sh**: 
  - A script that stops the current OB-USPA controller process, removes its database, and restarts it with a fresh configuration. This script is useful for development and testing, where frequent resets may be required.

- **setup_port_forwarding.sh**: 
  - A script that sets up port forwarding between the WSL environment and the Windows host. This allows external access to services running inside WSL, facilitating easier integration and testing across different environments.

### Usage Instructions

#### 1. Prerequisites

Before setting up the OB-USPA controller, ensure that you have Docker and WSL installed and configured on your Windows machine. The setup is based on the OB-USPA Test Controller from [IOPSYS GitLab](https://dev.iopsys.eu/bbf/obuspa-test-controller/-/tree/devel?ref_type=heads), and you may want to refer to that repository for additional context.

#### 2. Building the Docker Image

To build the Docker image for the OB-USPA controller, navigate to the directory containing the Dockerfile and run:

```bash
./docker_utils.sh rebuild

#### 3. Running the Docker Container

To run the Docker container, use the following command:

```bash
./docker_utils.sh run

