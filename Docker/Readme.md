# Modulo Docker

---

### Ejercicio 1

Crear la red de **lemoncode-challenge**

`
docker network create -d bridge lemoncode-challenge
`

Creo la red de tipo **bridge** y la llamo "lemoncode-challenge"

Levantar la DB:

`
docker run -dit -v data:/data/db --network lemoncode-challenge --name some-mongo mongo
`

Ejecuto un contenedor llamado "some-mongo" con la imagen de mongo, conectado a la red "lemoncode-challenge", tiene un montado un volumen de tipo **local**.

Nos conectamos al contenedor y creamos una DB llamada "TopicstoreDb" con una colección llamada "Topics".
Añadimos registros con este esquema.

```json
{
    "_id":{
        "$oid":"5fa2ca6abe7a379ec4234883"
        },
    "Name":"Contenedores"
}
```

Levantar API:

Para levantar la api primero he tenido que modificar el código:

- Primero en el archivo de **launchSettings.json** en la carpeta Properties, he cambiado en le json la propiedad **applicationUrl** de `http://localhost:49704` a `http://localhost:5000`
- Segundo en le archivo **appsettings.json** cambiar el string de conexión de `mongodb://localhost:27017` por `mongodb://some-mongo:27017`

Crear la imagen.

Creamos un dockerfile en la base del proyecto con el siguiente contenido.

```Dockerfile
#Uso la imagen de dotnet 3.1
FROM mcr.microsoft.com/dotnet/core/sdk:3.1

RUN mkdir -p /app

WORKDIR /app

# Copio todo el contenido
COPY . /app

#Ejecuto dotnet restore para descargar los paquetes y dependencias necesarias
RUN dotnet restore

#Compilo el proyecto con dotnet build
RUN dotnet build

EXPOSE 5000

# Ejecutamos el proyecto y le pasamos la flag --urls indicando que escuche desde todas las solicitudes
CMD ["dotnet", "run", "--urls", "http://*:5000"]
```

Hacemose el build de la imagen con 

`
docker build -t topics-api .
`

Ejecutar contenedor:

`
docker run -d --name topics-api --network lemoncode-challenge topics-api
`

Levanto el contenedor bajo el nombre de **topics-api** y la red **lemoncode-challenge** con la imagen previamente creada llamada **topics-api**

Levantar Front:

Para levantar el front tambien he tenido que modificar el codigo:

- Cambiar la constante **LOCAL** con valor: `http://localhost:5000/api/topics` por `http://topics-api:5000/api/topics`

Crear la imagen

Creamos un dockerfile en la base del proyecto con el siguiente contenido

```Dockerfile
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
```

Hacemos el build de la imagen con

`
docker build -t front .
`

Ejecutar contenedor:

`
docker run -d --name front --network lemoncode-challenge -p 8080:3000 front
`

Levanto el contenedor bajo el nombre de **front** y la red **lemoncode-challenge** expongo el puerto **8080**. 

---

### Ejercicio 2

Para el ejercicio 2 he creado un DockerCompose con el siguiente contenido:

```yaml
version: '3.7'

networks:
  lemoncode-challenge:
volumes:
  data:

services:
  front:
    image: front:latest
    container_name: front
    ports:
      - "8080:3000"
    networks:
      - lemoncode-challenge
  back:
    container_name: topics-api
    image: topics-api:latest
    networks:
      - lemoncode-challenge
  mongodb:
    image: mongo
    container_name: some-mongo
    volumes:
      - data:/data/db
```

Para levantar los contenedores usar el comando:
`
docker compose up -d 
` o `docker-compose up -d `