Do wykonania tego laboratorium zostaly wykorzystane nastepujace narzedzia:
1. Git
2. HyperV, a na nim Fedora 38
3. Docker
4. DotNet w wersji 6.0


Celem laboratorium bylo odnalezienie repo z kodem oprogramowania ktore:
1. Dysponuje otwarta licencja
2. Posiada Makefile
3. Zawiera testy

Wybor padl na https://github.com/CodeMazeBlog/unit-testing-aspnetcore-webapi ktory spelnia powyzsze zalozenia.

Dzialanie:

1. Uruchomienie wirtualnej maszyny z Fedora i zalogowanie sie do niej poprzez SSH - [ssh micha@172.xxx.xxx.xxx]
micha to moj login na maszynie z Fedora, a adres IP zostal ukryty ze wzgledow bezpieczenstwa, aby uzyskac adres IP nalezy wykonac polecenie "ip a" w terminalu.
2. Sklonowalem repozytorioum chcac sprawdzic czy program dziala poprawnie zanim przystapilem do konfiguraji dockera.
git clone https://github.com/CodeMazeBlog/unit-testing-aspnetcore-webapi.git
3. Pobranie niezbednych bibliotek DotNet celem uruchomenia programu
sudo dnf install dotnet-sdk-6.0
sudo dnf install dotnet-runtime-6.0
4. Uruchomienie programu
cd ./unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api/
dotnet run 

info: Microsoft.Hosting.Lifetime[14]
      Now listening on: http://localhost:5000
info: Microsoft.Hosting.Lifetime[14]
      Now listening on: https://localhost:5001
info: Microsoft.Hosting.Lifetime[0]
      Application started. Press Ctrl+C to shut down.
info: Microsoft.Hosting.Lifetime[0]
      Hosting environment: Production
info: Microsoft.Hosting.Lifetime[0]
      Content root path: /home/micha/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api/

5. Uruchomienie testow jednostkowych
cd ./unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/
dotnet test

Determining projects to restore...
  Restored /home/micha/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/web-api-tests.csproj (in 11.1 sec).
  1 of 2 projects are up-to-date for restore.
  web-api -> /home/micha/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api/bin/Debug/net6.0/web-api.dll
/home/micha/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/ShoppingCartControllerTest.cs(40,59): warning CS8602: Dereference of a possibly null reference. [/home/micha/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/web-api-tests.csproj]
/home/micha/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/ShoppingCartControllerTest.cs(77,41): warning CS8602: Dereference of a possibly null reference. [/home/micha/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/web-api-tests.csproj]
/home/micha/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/ShoppingCartControllerTest.cs(78,37): warning CS8602: Dereference of a possibly null reference. [/home/micha/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/web-api-tests.csproj]
/home/micha/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/ShoppingCartControllerTest.cs(130,24): warning CS8602: Dereference of a possibly null reference. [/home/micha/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/web-api-tests.csproj]
/home/micha/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/ShoppingCartControllerTest.cs(134,54): warning CS8602: Dereference of a possibly null reference. [/home/micha/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/web-api-tests.csproj]
/home/micha/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/ShoppingCartServiceFake.cs(40,20): warning CS8603: Possible null reference return. [/home/micha/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/web-api-tests.csproj]
  web-api-tests -> /home/micha/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/bin/Debug/net6.0/web-api-tests.dll
Test run for /home/micha/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/bin/Debug/net6.0/web-api-tests.dll (.NETCoreApp,Version=v6.0)
Microsoft (R) Test Execution Command Line Tool Version 17.0.3+cc7fb0593127e24f55ce016fb3ac85b5b2857fec
Copyright (c) Microsoft Corporation.  All rights reserved.

Starting test execution, please wait...
A total of 1 test files matched the specified pattern.

Passed!  - Failed:     0, Passed:    11, Skipped:     0, Total:    11, Duration: 29 ms - /home/micha/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/bin/Debug/net6.0/web-api-tests.dll (net6.0)

6. Utworzenie katalogu Lab02, a w nim pliku Dockerfile, ktory pozwoli na zbudowanie kontenera wewnatrz ktorego zostanie uruchomiony program

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

------

Zbudowanie obrazu Dockera: docker build -t web-api-app
Uruchomienie kontenera: docker run -d -p 5000:80 --name web-api-container web-api-app
Sprawdzenie dzialania kontenera: docker ps

CONTAINER ID   IMAGE         COMMAND                CREATED         STATUS         PORTS                                   NAMES
cf090c40610b   web-api-app   "dotnet web-api.dll"   3 minutes ago   Up 3 minutes   0.0.0.0:5000->80/tcp, :::5000->80/tcp   web-api-container


7. Utworzenie Docker-test dla uruchomienia kontenera wykonujacego testy jednostkowe

# Dockerfile
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /app

# Pobierz repozytorium z kodem zrodlowym
RUN apt-get update && \
    apt-get install -y git && \
    git clone https://github.com/CodeMazeBlog/unit-testing-aspnetcore-webapi.git

# Kompilowanie programu
WORKDIR /app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests
RUN dotnet restore && dotnet build -c Release

# Uruchomienie testow
FROM build AS test
WORKDIR /app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests
CMD ["dotnet", "test"]

------

# Zbuduj obraz testowy
docker build -t unit-tests-container -f Dockerfile-test .

Sending build context to Docker daemon  4.096kB
Step 1/11 : FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
 ---> 048212f5881b
Step 2/11 : WORKDIR /app
 ---> Using cache
 ---> f09612b7cd4a
Step 3/11 : RUN apt-get update &&     apt-get install -y git &&     git clone https://github.com/CodeMazeBlog/unit-testing-aspnetcore-webapi.git
 ---> Using cache
 ---> 473f44ca7cfa
Step 4/11 : WORKDIR /app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api
 ---> Using cache
 ---> dbcdfaa716fc
Step 5/11 : RUN dotnet build -c Release
 ---> Using cache
 ---> fad124f73a24
Step 6/11 : FROM build AS publish
 ---> fad124f73a24
Step 7/11 : RUN dotnet publish -c Release -o out
 ---> Using cache
 ---> 927eed2b9987
Step 8/11 : FROM mcr.microsoft.com/dotnet/aspnet:6.0
 ---> 85edb7c8acf4
Step 9/11 : WORKDIR /app
 ---> Using cache
 ---> 1c4dc2185260
Step 10/11 : COPY --from=publish /app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api/out .
 ---> Using cache
 ---> bedcf04b47fa
Step 11/11 : CMD ["dotnet", "web-api.dll"]
 ---> Using cache
 ---> 1e154819a361
Successfully built 1e154819a361
Successfully tagged unit-tests-container:latest

# Uruchom kontener z testami
docker run -it --rm unit-tests-container

[micha@localhost Lab02]$ docker run -it --rm unit-tests-container
info: Microsoft.Hosting.Lifetime[14]
      Now listening on: http://[::]:80
info: Microsoft.Hosting.Lifetime[0]
      Application started. Press Ctrl+C to shut down.
info: Microsoft.Hosting.Lifetime[0]
      Hosting environment: Production
info: Microsoft.Hosting.Lifetime[0]
      Content root path: /app/

7. Sprawdzenie utworzonych obrazow
sudo docker images

REPOSITORY                        TAG       IMAGE ID       CREATED          SIZE
web-api-app                       latest    1e154819a361   23 minutes ago   208MB
unit-tests-container              latest    1e154819a361   23 minutes ago   208MB
<none>                            <none>    927eed2b9987   23 minutes ago   767MB
mcr.microsoft.com/dotnet/sdk      6.0       048212f5881b   5 days ago       740MB
mcr.microsoft.com/dotnet/aspnet   6.0       85edb7c8acf4   5 days ago       208MB

8. Roznica miedzy kontenerem a obrazem
Obraz to kompletny pakiet zawierający zarówno kod aplikacji, jak i wszystkie wymagane zależności. Natomiast kontener jest dynamicznym środowiskiem, utworzonym podczas uruchamiania obrazu, gdzie kod aplikacji jest aktywowany i działa.
