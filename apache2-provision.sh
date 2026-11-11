#
# Copiar ficheros de configuración de apache2 que incluyen:
#
# - apache2.conf,
# - apolo.olimpo.test.conf
# - atenea.olimpo.test.conf
#

cp /vagrant/files/mercurio.olimpo.test/apolo.olimpo.test.conf /etc/apache2/sites-available/
cp /vagrant/files/mercurio.olimpo.test/atenea.olimpo.test.conf /etc/apache2/sites-available/

#
# Habilitar los servidores virtuales
#

a2ensite apolo.olimpo.test.conf
a2ensite atenea.olimpo.test.conf

#
# Reiniciar el servicio
#

systemctl restart apache2