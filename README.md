# Docker Compose

## Parte teórica

### ¿Que es Docker?

Docker es un proyecto de código abierto que automatiza el despliegue de aplicaciones dentro de contenedores de software. Docker usa el kernel de Linux y las funcionesde este, para segregar los procesos, de modo que puedan ejecutarse manera dindependiente. El propósito de los contendores es esta independencia: la capacidad de ejecutar varios procesos y aplicaciones por separado para hacer un mejor usos de su infraestructura y, al mismo tiempo, conservar la seguridad que tendría con sistemas separados.

Las herramientas del contenedor, ofrecen un modelo de implementación basado en imágenes. Esto permite compartir una aplicación, o un conjunto de servicios, con todas sus dependencias en varios entornos.

### ¿Que es Docker Compose?

Docker Compose es una herramienta que permite simplificar el uso de Docker. A partir de archivos YAML es más sencillo crear contenedores, conectarlos, habilitar puertos, volumenes, etc. Aquí resumimos algunos tipos.
Se pueden crear diferentes contenedores y al mismo tiempo, en cada contenedor, diferentes servicios, unirlos a un volúmen común, inicarlos y apagarlos, etc. Es un componente fundamental para poder contruir aplicaciones y microservicios.

### ¿Que es Prometheus?

Prometheus es una base de serie de tiempo y un sistema de monitoreo y alertas. Las series de tiempo almacenan datos ordenados cronológicamente, midiendo variables a lo largo del tiempo y las bases de datos enfocadas a series de tiempo son especialmente eficientes en almacenar y consultar estos datos.

La arquitectura de Prometheus almacena todas las muestras recortadas localmente y ejecuta reglas sobre estos datos para agregar y registrar nuevas series temporales a partir de datos existentes o para generar alertas. Prometheus elimina las métricas de los trabajos instrumentados, ya sea directamente o a través de un Gateway de inserción intermedia para trabajos de poca duración.

### ¿Que es Grafana?

Grafana es una herramienta para visualizar datos de serie temporales. A partir de una serie de datos recolectados se obtiene un panorama gráfico de la situación muy simple de interpretar y visualizar, se utiliza para el monitoreo de infraestructura de IT, mediciones de aplicaciones, control de procesos, sensores industriales, automatización de hogares y medición del clima entre otros usos.

### Propósito

El propósito de esta práctica es que mediante un contendor donde residirá la aplicación, otro donde residirá Prometheus y por último otro donde residirá Grafana, enlazarlos de tal forma que se pueda comprobar y mostrar de forma gráfica las conexiones que se realizan a los endpoints de la aplicación de Node.

## Parte práctica

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

El servicio de node quedaria de la siguiente manera:

(Captura parte node)

Con esto tendriamos listo el servicio de Node, ahora pasaremos al de Prometheus.

## Prometheus

El servicio de Prometheus dependerá del servicio de Node que hemos creado antes, para ello añadiremos la siguiente linea al servicios de "prometheus":
##
depends_on:
    - node
##
El puerto por defecto de Prometheus es el 9090 y tendremos que enlazarlo a ese mismo puerto en nuestra máquina local, para ello añadiremos la siguiente línea:
##
ports:
    - '9090:9090'
##
Le asignaremos el nombre "prometheus_practica" al contenedor:
##
container_name: 'prometheus_practica'
##

Utilizaremos la imagen "prom/prometheus:v2.20.1" para crear el contenedor:
##
image: 'prom/prometheus:v2.20.1'
##

Tendremos que añadir el fichero "prometheus.yml" al directorio "/etc/prometheus" del contenedor, para ello crearemos un volumen y copiaremos el directorio "prometheus" donde está situado el fichero:

##
volumes:
    - "./prometheus:/etc/prometheus"
##

Ejecutaremos el comando "--config.file=/etc/prometheus/prometheys.yml" para establecer el fichero de configuración.
##
command: --config.file=/etc/prometheus/prometheys.yml
##

Como el servicio de Node, este servicio también formará parte de la red "network_practica"
##
networks:
    - network_practica
##

El servicio de prometheus quedaría de la siguiente forma:

(Captura servicio prometheus)

## Grafana

El servicio de Grafana a su vez, dependerá del de Prometheus, y para ellos añadiremos la siguiente línea:
##
depends_on:
    - prometheus
##

El puerto por defecto de Grafana es el 3000, y lo enlazaremos al puerto 3500 de nuestra máquina.
##
ports:
    - '3500:3000'
##

Le asignaremos el nombre "grafana_practica" al contenedor:
##
container_name: 'grafana_practica'
##

La imagen que instalaremos en el contedor es "grafana/grafana:7.1.5":
##
image: 'grafana/grafana:7.1.5'
##

Además para la instalación de Grafana tendremos que deshabilitar el login de acceso, permitir la autenticación anónima y que el rol de autenticación anónima sea administrador y que por último instale el plugin "grafana-clock-panel 1.0.1", y para ello definiremos las siguientes variables de entorno:
##
environment:
    - GF_AUTH_DISABLE_LOGIN_FORM=true
    - GF_AUTH_ANONYMOUS_ENABLED=true
    - GF_AUTH_ANONYMOUS_ORG_ROLE=Admin
    - GF_INSTALL_PLUGINS=grafana-clock-panel 1.0.1
##

Este contenedor como los anteriores formará parte de la red "network_practica"

##
networks:
    - network_practica
##

Tendremos que asignarle un volumen con nombre al contenedor, para definirlo a la altura de version, services y networks añadiremos las siguientes lineas:
##
volumes:
    myGrafanaVol:
##

Y ahora asignaremos el volumen al contendor:
##
volumes:
    - 'myGrafanaVol:/var/lib/grafana'
##

Y adjuntaremos el fichero datasources.yml al directorio "/etc/grafana/provisioning/datasources" del contenedor.

##
volumes:
    - 'myGrafanaVol:/var/lib/grafana'
    - './grafana:/etc/grafana/provision/datasources'
##

El servicio de Grafana quedaria de la siguiente forma:

(Captura servicio Grafana)

Adjunto comprobación del funcionamiento del servicio de Node.
(Captura html Node)

Adjunto comprobación del funcionamiento del servicio Prometheus.
(Captura html Prometheus)

Adjunto comprobación del funcionamiento del servicio Grafana.
(Captura html Grafana)
