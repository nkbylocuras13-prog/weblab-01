# HTTP Lab 1: Virtual Hosts

Práctica de servidores virtuales por nombre con Apache, utilizando dos máquinas virtuales con Vagrant: un servidor DNS (`ns1`) y un servidor web (`mercurio`).

**Autor:** Enrique Olmedo Muñoz

---


### 1.Comprobación del DNS

Desde la máquina DNS comprobamos que resuelve el servidor web:

`vagrant ssh dns -c "dig mercurio.olimpo.test +short"`

Desde la máquina web comprobamos que resuelve el servidor DNS:

`vagrant ssh web -c "dig ns1.olimpo.test +short"`

![Comprobación inicial del DNS](caps/digs.png)
