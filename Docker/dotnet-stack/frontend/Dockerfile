FROM node:16

WORKDIR /usr/src/app

# Copio los archivos de las dependencias
COPY package*.json ./

# Instalo las dependencias
RUN npm install

COPY . .

EXPOSE 3000

# Como Entrypoint ejecuto el fichero server.js
CMD [ "node", "server.js" ]