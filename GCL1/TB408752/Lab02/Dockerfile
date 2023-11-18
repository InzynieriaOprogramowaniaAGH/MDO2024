FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /app

# Pobierz projekt
RUN apt-get update && \
    apt-get install -y git && \
    git clone https://github.com/CodeMazeBlog/unit-testing-aspnetcore-webapi.git

RUN find .

# Restore aplikacji
RUN dotnet restore ./unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api/web-api.csproj
RUN dotnet restore ./unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/web-api-tests.csproj

# Build aplikacji webowej
WORKDIR /app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api
RUN dotnet build -c Release

# Build aplikacji testowej
WORKDIR /app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests
RUN dotnet build -c Release

# Odaplanie testów
FROM build AS test
WORKDIR /app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests
RUN dotnet test

# Publikowanie aplikacji webowej
FROM build AS publish
WORKDIR /app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api
RUN dotnet publish -c Release -o out

# Kopiowanie plików aplikacji po publishu
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS runtime
WORKDIR /app
COPY --from=publish /app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api/out ./

# Określanie portu aplikacji (default 80)
EXPOSE 80

# ustawianie entrypointu dla runa aplikacji
ENTRYPOINT ["dotnet", "web-api.dll"]
