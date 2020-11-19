Empezaremos creando el fichero Dockerfile, y añadiremos los comandos necesarios, que serán:

1. FROM mhart/alpine-node
2. WORKDIR /myapp
3. EXPOSE 3000
4. CMD ['npm' 'start']

Una vez lo tengamos listo, crearemos el fichero docker-compose.yml. Al crear el fichero hay unos valores que son obligatorios, como: version y services.

Valor de version:

## version: 3 ##

Y ahora crearemos el primer servicio que será el de Node. Asignaremos el nombre que queramos al servicio, que en este caso será node, y añadiremos la instrucción ## build .## para que cree la imagen a partir del Dockerfile que hemos creado antes. Expondremos el puerto mediante:
## ports: 
    - '83:8080'
##
Y haremos que forme parte de la red "network_practica" mediante:
##
networks:
    - 'network_practica'
##
Aunque hay que crear la red, para ello a la altura de services y version añadiremos:
##
networks:
    network_practica:
##