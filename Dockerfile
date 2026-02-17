FROM espocrm/espocrm:latest

# copy your customizations into container
COPY client/ /var/www/html/client/
COPY custom/ /var/www/html/custom/
COPY application/ /var/www/html/application/
