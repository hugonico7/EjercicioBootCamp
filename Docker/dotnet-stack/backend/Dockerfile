FROM mcr.microsoft.com/dotnet/core/sdk:3.1

RUN mkdir -p /app

WORKDIR /app

COPY . /app

RUN dotnet restore

RUN dotnet build

EXPOSE 5000

CMD ["dotnet", "run", "--urls", "http://*:5000"]