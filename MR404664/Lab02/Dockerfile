# Dockerfile
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /app

# Pobierz repozytorium z kodem zrodlowym
RUN apt-get update && \
    apt-get install -y git && \
    git clone https://github.com/CodeMazeBlog/unit-testing-aspnetcore-webapi.git

# Kompilowanie
WORKDIR /app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api
RUN dotnet build -c Release

# Publikowani aplikacji webowej
FROM build AS publish
RUN dotnet publish -c Release -o out

# Obraz końcowy
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=publish /app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api/out .

# Uruchom aplikację
CMD ["dotnet", "web-api.dll"]
