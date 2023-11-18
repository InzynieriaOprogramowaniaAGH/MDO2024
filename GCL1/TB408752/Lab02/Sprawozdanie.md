# Sprawozdanie z zadania Mtg02.md

### Wymagane narzędzie
- git
- docker
- dotnet (sudo dnf install dotnet-sdk-6.0)

### Użyte repozytory 
- https://github.com/CodeMazeBlog/unit-testing-aspnetcore-webapi


### Wykonanie
0) Pobierz repozytory
```
git clone https://github.com/CodeMazeBlog/unit-testing-aspnetcore-webapi.git
```
1) Sprawdzanie czy aplikacja się odpala poprzez wykonanie 
```
cd ./unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api/
dotnet run 
```
Wynik
```
info: Microsoft.Hosting.Lifetime[14]
      Now listening on: http://localhost:5000
info: Microsoft.Hosting.Lifetime[14]
      Now listening on: https://localhost:5001
info: Microsoft.Hosting.Lifetime[0]
      Application started. Press Ctrl+C to shut down.
info: Microsoft.Hosting.Lifetime[0]
      Hosting environment: Production
info: Microsoft.Hosting.Lifetime[0]
      Content root path: /home/devops/lab02/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api/
```
2) Odpalenie testów jednostkowych
```
cd ./unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/
dotnet test
```
Wynik
```
  Determining projects to restore...
  All projects are up-to-date for restore.
  web-api -> /home/devops/lab02/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api/bin/Debug/net6.0/web-api.dll
  web-api-tests -> /home/devops/lab02/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/bin/Debug/net6.0/web-api-tests.dll
Test run for /home/devops/lab02/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/bin/Debug/net6.0/web-api-tests.dll (.NETCoreApp,Version=v6.0)
Microsoft (R) Test Execution Command Line Tool Version 17.0.0+68bd10d3aee862a9fbb0bac8b3d474bc323024f3
Copyright (c) Microsoft Corporation.  All rights reserved.

Starting test execution, please wait...
A total of 1 test files matched the specified pattern.

Passed!  - Failed:     0, Passed:    11, Skipped:     0, Total:    11, Duration: 34 ms - /home/devops/lab02/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/bin/Debug/net6.0/web-api-tests.dll (net6.0)
```
3) Create Dockerfile w głównym folderze aplikacji

```
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

```

4) Uruchomienie Docker deamon
```
sudo systemctl start docker
```
5) Build docker image
```
sudo docker build -t devops_test_01 .
```
Wynik
```
Sending build context to Docker daemon  16.38kB
Step 1/21 : FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
 ---> 6d33d3da7b5e
Step 2/21 : WORKDIR /app
 ---> Using cache
 ---> d0c881af1c90
Step 3/21 : RUN apt-get update &&     apt-get install -y git &&     git clone https://github.com/CodeMazeBlog/unit-testing-aspnetcore-webapi.git
 ---> Using cache
 ---> 13a3ed47e30b
Step 4/21 : RUN find .
 ---> Using cache
 ---> 5e557e79d300
Step 5/21 : RUN dotnet restore ./unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api/web-api.csproj
 ---> Using cache
 ---> 2f58e50ad99f
Step 6/21 : RUN dotnet restore ./unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/web-api-tests.csproj
 ---> Using cache
 ---> de438b5f4871
Step 7/21 : WORKDIR /app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api
 ---> Running in 2d8449a71164
Removing intermediate container 2d8449a71164
 ---> 306cad4a9632
Step 8/21 : RUN dotnet build -c Release
 ---> Running in 26d2202db70c
MSBuild version 17.3.2+561848881 for .NET
  Determining projects to restore...
  All projects are up-to-date for restore.
  web-api -> /app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api/bin/Release/net6.0/web-api.dll

Build succeeded.
    0 Warning(s)
    0 Error(s)

Time Elapsed 00:00:02.92
Removing intermediate container 26d2202db70c
 ---> 24836978a8b6
Step 9/21 : WORKDIR /app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests
 ---> Running in ee0e331bddb9
Removing intermediate container ee0e331bddb9
 ---> 0ff626e4e2f7
Step 10/21 : RUN dotnet build -c Release
 ---> Running in 18af5bfe41a3
MSBuild version 17.3.2+561848881 for .NET
  Determining projects to restore...
  All projects are up-to-date for restore.
  web-api -> /app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api/bin/Release/net6.0/web-api.dll
/app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/ShoppingCartControllerTest.cs(40,59): warning CS8602: Dereference of a possibly null reference. [/app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/web-api-tests.csproj]
/app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/ShoppingCartControllerTest.cs(77,41): warning CS8602: Dereference of a possibly null reference. [/app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/web-api-tests.csproj]
/app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/ShoppingCartControllerTest.cs(78,37): warning CS8602: Dereference of a possibly null reference. [/app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/web-api-tests.csproj]
/app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/ShoppingCartControllerTest.cs(130,24): warning CS8602: Dereference of a possibly null reference. [/app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/web-api-tests.csproj]
/app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/ShoppingCartControllerTest.cs(134,54): warning CS8602: Dereference of a possibly null reference. [/app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/web-api-tests.csproj]
/app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/ShoppingCartServiceFake.cs(40,20): warning CS8603: Possible null reference return. [/app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/web-api-tests.csproj]
  web-api-tests -> /app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/bin/Release/net6.0/web-api-tests.dll

Build succeeded.

/app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/ShoppingCartControllerTest.cs(40,59): warning CS8602: Dereference of a possibly null reference. [/app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/web-api-tests.csproj]
/app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/ShoppingCartControllerTest.cs(77,41): warning CS8602: Dereference of a possibly null reference. [/app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/web-api-tests.csproj]
/app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/ShoppingCartControllerTest.cs(78,37): warning CS8602: Dereference of a possibly null reference. [/app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/web-api-tests.csproj]
/app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/ShoppingCartControllerTest.cs(130,24): warning CS8602: Dereference of a possibly null reference. [/app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/web-api-tests.csproj]
/app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/ShoppingCartControllerTest.cs(134,54): warning CS8602: Dereference of a possibly null reference. [/app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/web-api-tests.csproj]
/app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/ShoppingCartServiceFake.cs(40,20): warning CS8603: Possible null reference return. [/app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/web-api-tests.csproj]
    6 Warning(s)
    0 Error(s)

Time Elapsed 00:00:02.66
Removing intermediate container 18af5bfe41a3
 ---> 35990c60999f
Step 11/21 : FROM build AS test
 ---> 35990c60999f
Step 12/21 : WORKDIR /app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests
 ---> Running in 1de69784f979
Removing intermediate container 1de69784f979
 ---> 28525c875941
Step 13/21 : RUN dotnet test
 ---> Running in 8ed73f107104
  Determining projects to restore...
  All projects are up-to-date for restore.
  web-api -> /app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api/bin/Debug/net6.0/web-api.dll
/app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/ShoppingCartControllerTest.cs(40,59): warning CS8602: Dereference of a possibly null reference. [/app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/web-api-tests.csproj]
/app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/ShoppingCartControllerTest.cs(77,41): warning CS8602: Dereference of a possibly null reference. [/app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/web-api-tests.csproj]
/app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/ShoppingCartControllerTest.cs(78,37): warning CS8602: Dereference of a possibly null reference. [/app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/web-api-tests.csproj]
/app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/ShoppingCartControllerTest.cs(130,24): warning CS8602: Dereference of a possibly null reference. [/app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/web-api-tests.csproj]
/app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/ShoppingCartControllerTest.cs(134,54): warning CS8602: Dereference of a possibly null reference. [/app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/web-api-tests.csproj]
/app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/ShoppingCartServiceFake.cs(40,20): warning CS8603: Possible null reference return. [/app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/web-api-tests.csproj]
  web-api-tests -> /app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/bin/Debug/net6.0/web-api-tests.dll
Test run for /app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/bin/Debug/net6.0/web-api-tests.dll (.NETCoreApp,Version=v6.0)
Microsoft (R) Test Execution Command Line Tool Version 17.3.3 (x64)
Copyright (c) Microsoft Corporation.  All rights reserved.

Starting test execution, please wait...
A total of 1 test files matched the specified pattern.

Passed!  - Failed:     0, Passed:    11, Skipped:     0, Total:    11, Duration: 36 ms - /app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/bin/Debug/net6.0/web-api-tests.dll (net6.0)
Removing intermediate container 8ed73f107104
 ---> f9d4bb7b47f6
Step 14/21 : FROM build AS publish
 ---> 35990c60999f
Step 15/21 : WORKDIR /app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api
 ---> Running in e09f80f5bbe7
Removing intermediate container e09f80f5bbe7
 ---> 2930f17067ee
Step 16/21 : RUN dotnet publish -c Release -o out
 ---> Running in 1274713aca0b
MSBuild version 17.3.2+561848881 for .NET
  Determining projects to restore...
  All projects are up-to-date for restore.
  web-api -> /app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api/bin/Release/net6.0/web-api.dll
  web-api -> /app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api/out/
Removing intermediate container 1274713aca0b
 ---> fc6a9e91362c
Step 17/21 : FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS runtime
 ---> a9a05a5742bc
Step 18/21 : WORKDIR /app
 ---> Using cache
 ---> da0bec8cd733
Step 19/21 : COPY --from=publish /app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api/out ./
 ---> 14ade16a4684
Step 20/21 : EXPOSE 80
 ---> Running in e40f32e3e26f
Removing intermediate container e40f32e3e26f
 ---> 4a02eec6ad35
Step 21/21 : ENTRYPOINT ["dotnet", "web-api.dll"]
 ---> Running in 78cb1f37ab8d
Removing intermediate container 78cb1f37ab8d
 ---> 408c107e1e95
Successfully built 408c107e1e95
Successfully tagged devops_test_01:latest
```

6) Sprawdzenie stworzonego image
```
sudo docker images
```
```
REPOSITORY                        TAG       IMAGE ID       CREATED         SIZE
devops_test_01                    latest    cdba06e8a018   3 minutes ago   206MB
<none>                            <none>    fb42b10ada43   4 minutes ago   989MB
<none>                            <none>    412d6404f601   4 minutes ago   998MB
mcr.microsoft.com/dotnet/sdk      6.0       6d33d3da7b5e   6 hours ago     740MB
ubuntu                            latest    e4c58958181a   6 weeks ago     77.8MB
mysql                             latest    2d9aad1b5856   3 months ago    574MB
hello-world                       latest    9c7a54a9a43c   6 months ago    13.3kB
mcr.microsoft.com/dotnet/aspnet   6.0       29de1b9e96c0   17 months ago   205MB
```
7) Run docker image
```
sudo docker run -p 8080:80 devops_test_01
```
Wynik
```
info: Microsoft.Hosting.Lifetime[14]
      Now listening on: http://[::]:80
info: Microsoft.Hosting.Lifetime[0]
      Application started. Press Ctrl+C to shut down.
info: Microsoft.Hosting.Lifetime[0]
      Hosting environment: Production
info: Microsoft.Hosting.Lifetime[0]
      Content root path: /app/
```