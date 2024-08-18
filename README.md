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
