#!/bin/bash

domain=$1
apacheSA='/etc/apache2/sites-available/'  
apacheSE='/etc/apache2/sites-enabled/'
user=$(whoami);
wwwPath=/var/www/html/www/$domain;

apacheConfig="<VirtualHost *:80>
    ServerName $domain
    DocumentRoot $wwwPath
    <Directory $wwwPath>
    	AllowOverride All
    </Directory>
</VirtualHost>";

echo "\033[0;34m virtual domain maker try to make domain:\033[0m '$domain' "

if (test -f "$apacheSA$domain.conf";) then  
	echo -n "\033[0;31m domain: '$domain' - etists rewrite? (y/n) \033[0m"
	read ans
	case "$ans" in
    		y|Y) echo "rewriting domain '$domain'..."
        	;;
    		*) echo "creating domain '$domain' cancered"
        	exit 0
        	;;
	esac
fi
	echo 'create rood dir: '$wwwPath
	mkdir $wwwPath;
	chmod -R 777 $wwwPath
	
  	echo "for next actions may be need to input root password"
    	
	echo "$apacheConfig" | sudo tee "$apacheSA$domain.conf" > /dev/null

	sudo ln -s "$apacheSA$domain.conf" "$apacheSE$domain.conf"

	echo "127.0.0.1 $domain" | sudo tee -a /etc/hosts > /dev/null
 
    	echo "restarting Apache"
    	sudo service apache2 restart;
 
    echo "profit!"
	

#sudo 
exit 0
