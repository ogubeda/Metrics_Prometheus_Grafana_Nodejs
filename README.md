Empezaremos creando el fichero Dockerfile, y añadiremos los comandos necesarios, que serán:

1. FROM mhart/alpine-node
2. WORKDIR /myapp
3. EXPOSE 3000
4. CMD ['npm' 'start']