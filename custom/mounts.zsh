# assign ips to vpn until we can connect with hostnames

function makeconfig(){
	echo -e "GET http://google.com HTTP/1.0\n\n" | nc google.com 80 > /dev/null 2>&1
	if [ $? -eq 0 ]; then
		arr=()
		configfile=$(<~/.ssh/vpn)
		response=$(ssh ovh 'cat openvpn-status.log |grep 10.0.1 |cut -f 1,2 -d ','')
		  while read -r line; do
		    STR_ARRAY=(`echo $line | tr "," "\n"`)
		    configfile="${configfile/${STR_ARRAY[2]}_vpn/${STR_ARRAY[1]}}"
		    echo -n "${STR_ARRAY[2]} "
		done <<< "$response"
		echo $configfile > ~/.ssh/vpn.config
		echo -n > ~/.ssh/config && cat ~/.ssh/*.config > ~/.ssh/config
		echo "\n"
	else 
		echo "offline"
	fi
}


function runbolius(){
	running=$(VBoxManage list runningvms|wc -l|xargs)
	if [[ $running = "0" ]];
		then 
		VBoxManage startvm Bolius --type headless		
		#umount -f ~/localvm_sshfs
		#sshfs lvm:/var/www/bolius ~/localvm_sshfs -o allow_other,uid=501,gid=20,sshfs_sync,reconnect,follow_symlinks,ServerAliveInterval=15,volname=bolius.dev,IdentityFile=/Users/andreas/.ssh/id_rsa
		echo "Running"
	fi 
}


function mountall(){
mountshanghai && mountbeijing && mountlondon && mountmadrid
}

function mountshanghai() {
sshfs bassment:/mnt/a808356f-56cd-41e0-8cbd-f4b165f24be8 ~/Desktop/Shanghai -o allow_other,ServerAliveInterval=15,auto_cache,reconnect,sshfs_sync,cipher=arcfour,compression=no,volname=Shanghai,noappledouble,local
}

function mountbeijing() {
sshfs bassment:/mnt/010ae644-fcf9-4456-9733-71b8ff44554f ~/Desktop/Beijing -o allow_other,ServerAliveInterval=15,auto_cache,reconnect,sshfs_sync,volname=Beijing,noappledouble,local
}

function mountlondon() {
sshfs workstation_vpn:/Volumes/London ~/Desktop/London -o allow_other,ServerAliveInterval=15,auto_cache,reconnect,sshfs_sync,volname=London,noappledouble,local
}

function mountmadrid() {
sshfs workstation_vpn:/Volumes/Madrid ~/Desktop/Madrid -o allow_other,ServerAliveInterval=15,auto_cache,reconnect,sshfs_sync,volname=Madrid,noappledouble,local
}


function mountvpn(){
	vpn_connected=$(ifconfig|grep 10.0.1|wc -l|xargs)

	echo $vpn_connected;

	if [[ $vpn_connected = "1" ]];
	  then
	    test=$(mount|grep "Shanghai")
	echo $test
	      if [ -z $test ];
	        then
	        mountshanghai
	      fi
	
	    test=$(mount|grep "Beijing")
	echo $test
	      if [ -z $test ];
	        then
	        mountbeijing
	      fi
	
	    test=$(mount|grep "London")
	echo $test
	      if [ -z $test ];
	        then
	        mountlondon
	      fi
	
	    test=$(mount|grep "Madrid")
	echo $test
	      if [ -z $test ];
	        then
	        mountmadrid
	      fi
	  else
	    echo "no vpn"
	fi
}


#ssid=$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | awk '/ SSID/ {print substr($0, index($0, $2))}')
#echo wifi:$ssid



