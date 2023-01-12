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