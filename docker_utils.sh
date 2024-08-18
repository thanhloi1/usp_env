#!/bin/bash

IMAGE_NAME="obuspa-mosquitto-image-name"
CONTAINER_NAME="obuspa-mosquitto-container-name"
DOCKERFILE="Dockerfile"
DEFAULT_MSG_FILE="ctrl_mqtt_msg_example.txt"

should_rebuild() {
    if [[ "$(docker images -q $IMAGE_NAME 2> /dev/null)" == "" ]]; then
        return 0 # Rebuild required
    fi

    for file in $DOCKERFILE; do
        if [[ $file -nt .docker_image_timestamp ]]; then
            return 0 # Rebuild required
        fi
    done

    return 1 # No rebuild required
}

rebuild_image() {
    echo "Rebuilding Docker image $IMAGE_NAME..."
    docker build -t $IMAGE_NAME .
    touch .docker_image_timestamp
}

stop_container() {
    if [[ "$(docker ps -q -f name=$CONTAINER_NAME)" ]]; then
        echo "Stopping container $CONTAINER_NAME..."
        docker stop $CONTAINER_NAME
    else
        echo "Container $CONTAINER_NAME is not running."
    fi
}

run_container() {
    if [[ "$(docker ps -q -f name=$CONTAINER_NAME)" ]]; then
        echo "Container $CONTAINER_NAME is already running. Attaching to it..."
        docker exec -it $CONTAINER_NAME /bin/bash
    elif [[ "$(docker ps -aq -f status=exited -f name=$CONTAINER_NAME)" ]]; then
        echo "Container $CONTAINER_NAME exists but is stopped. Restarting and attaching..."
        docker start $CONTAINER_NAME
        docker exec -it $CONTAINER_NAME /bin/bash
    else
        echo "Starting a new container $CONTAINER_NAME..."
        docker run -it --rm --name $CONTAINER_NAME -p 1883:1883 -p 9001:9001 -v $PWD:/host_dir $IMAGE_NAME /bin/bash
    fi
}

restart_container() {
    stop_container
    run_container
}

send_message() {
    local msg_file=${1:-$DEFAULT_MSG_FILE}

    if [[ "$(docker ps -q -f name=$CONTAINER_NAME)" ]]; then
        if [[ -f "$msg_file" ]]; then
            echo "Sending message to agent using $msg_file..."
            docker exec -it $CONTAINER_NAME /bin/bash -c "obuspc -p -v 4 -x /host_dir/$msg_file -i lo"
        else
            echo "Message file $msg_file not found."
        fi
    else
        echo "Container $CONTAINER_NAME does not exist or is not running."
    fi
}

show_help() {
    echo "Usage: $0 {stop|rebuild|run|restart|cmd|help}"
    echo
    echo "Commands:"
    echo "  stop      - Forcefully stop the Docker container named $CONTAINER_NAME."
    echo "  rebuild   - Rebuild the Docker image $IMAGE_NAME from the Dockerfile."
    echo "  run       - Attach to the Docker container if it exists; otherwise, run the Docker container."
    echo "  restart   - Stop the Docker container if running, then start it again."
    echo "  cmd       - Send a specified command to the Docker container if it is running."
    echo "             Usage: $0 cmd \"<your_command>\""
    echo "  logs [file]     Show real-time logs from the running container."
    echo "                  If [file] is provided, logs will be redirected to that file."
    echo "  send-msg  - Send a message to the agent using the specified file, or default to $DEFAULT_MSG_FILE."
    echo "             Usage: $0 send-msg [file_name]"
}

case "$1" in
    stop)
        stop_container
        ;;
    rebuild)
        rebuild_image
        ;;
    run)
        run_container
        ;;
    restart)
        restart_container
        ;;
    cmd)
        shift
        if [[ "$(docker ps -q -f name=$CONTAINER_NAME)" ]]; then
            echo "Sending command to container $CONTAINER_NAME: $@"
            docker exec -it $CONTAINER_NAME /bin/bash -c "$@"
        else
            echo "Container $CONTAINER_NAME does not exist or is not running."
        fi
        ;;
    logs)
        shift
        if [ -n "$1" ]; then
            docker logs -f --timestamps $CONTAINER_NAME > "$1"
            echo "Logs are being redirected to $1"
        else
            docker logs -f --timestamps $CONTAINER_NAME
        fi
        ;;
    send-msg)
        send_message "$2"
        ;;
    help|*)
        show_help
        ;;
esac
