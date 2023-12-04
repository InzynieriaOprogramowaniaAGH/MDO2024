FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /app

# Pobierz projekt
RUN apt-get update && \
    apt-get install -y git && \
    git clone https://github.com/CodeMazeBlog/unit-testing-aspnetcore-webapi.git

# Restore aplikacji
RUN dotnet restore ./unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api/web-api.csproj

# Build aplikacji webowej
WORKDIR /app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api
RUN dotnet build -c Release

# Publikowanie aplikacji webowej
FROM build AS publish
WORKDIR /app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api
RUN dotnet publish -c Release -o out