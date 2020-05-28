sudo certbot-auto certonly --webroot \
	-w /var/www/msoreloaded/current/public 	-d marienschule-opladen.com -d www.marienschule-opladen.com \
	-w /var/www/symbols/current/public 		-d symbols.marienschule-opladen.com \
	-w /var/www/tracking/current/public 	-d tracking.marienschule-opladen.com \
	-w /var/www/wordkiller/current/public 	-d wordkiller.marienschule-opladen.com \
	-w /var/www/wordkiller2/current/public 	-d wordkiller2.marienschule-opladen.com

sudo service nginx restart
