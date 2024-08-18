# Get the WSL IP address
WSL_IP=$(hostname -I | awk '{print $1}')

# Setup port forwarding for 1883 and 9001
wsl.exe -- powershell.exe -Command "netsh interface portproxy add v4tov4 listenport=1883 listenaddress=0.0.0.0 connectport=1883 connectaddress=$WSL_IP"
wsl.exe -- powershell.exe -Command "netsh interface portproxy add v4tov4 listenport=9001 listenaddress=0.0.0.0 connectport=9001 connectaddress=$WSL_IP"

echo "Port forwarding setup completed for ports 1883 and 9001."

