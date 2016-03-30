This script could be used as a  daily cronjob.

All 89 days a new certificate is generated.
The first certificates should has been created before with a single command like:
letsencrypt --redirect --rsa-key-size 4096 certonly  --server https://acme-v01.api.letsencrypt.org/directory my-domain.tld alias.my-domain.tld


On CentOS you only need this:

/root/letsencrypt/letsencrypt-auto renew --force-renewal

with gentoo a bit more work is needed:

/etc/init.d/apache2 stop

sleep 2

SERVERNAMES=$(grep Server /etc/apache2/vhosts.d/myhttps.conf | awk '{ print "-d " $2 }' | xargs echo -n)

letsencrypt --redirect --rsa-key-size 4096 certonly  --server https://acme-v01.api.letsencrypt.org/directory $SERVERNAMES

sleep 2

/etc/init.d/apache2 start

