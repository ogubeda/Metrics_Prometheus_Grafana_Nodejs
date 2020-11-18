FROM mhart/alpine-node
WORKDIR /myapp
EXPOSE 3000
CMD ['npm' 'start']