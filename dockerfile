FROM mhart/alpine-node
WORKDIR /myapp
COPY ./src/ .
EXPOSE 3000
RUN npm install
CMD ["node", "app.js"]