# Sprawozdanie z zadania Mtg02.md

### Wymagane narzędzie
- git
- docker
- dotnet (sudo dnf install dotnet-sdk-6.0)

### Użyte repozytory 
- https://github.com/CodeMazeBlog/unit-testing-aspnetcore-webapi


### Wykonanie
0) Pobierz repozytory
    ```bash
    git clone https://github.com/CodeMazeBlog/unit-testing-aspnetcore-webapi.git
    ```
1) Sprawdzanie czy aplikacja się odpala poprzez wykonanie 
    ```powershell
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
        Content root path: /home/devops/lab02/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api/
    ```
2) Odpalenie testów jednostkowych
    ```powershell
    cd ./unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/
    dotnet test
    
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
3) Utwórz [Dockerfile.test](Dockerfile.test)
4) Utwórz [Dockerfile.build](Dockerfile.build)
5) Uruchomienie Docker deamon
    ```bash
    sudo systemctl start docker
    ```
6) Build docker test
    ```powershell
    sudo docker build -t devops_test_01 -f Dockerfile.test .

    Sending build context to Docker daemon  10.24kB
    Step 1/9 : FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
    ---> 6d33d3da7b5e
    Step 2/9 : WORKDIR /app
    ---> Running in d4b0f97924ec
    Removing intermediate container d4b0f97924ec
    ---> f2b1e79c432e
    Step 3/9 : RUN apt-get update &&     apt-get install -y git &&     git clone https://github.com/CodeMazeBlog/unit-testing-aspnetcore-webapi.git
    ---> Running in ff8f5520586c
    Get:1 http://deb.debian.org/debian bullseye InRelease [116 kB]
    Get:2 http://deb.debian.org/debian-security bullseye-security InRelease [48.4 kB]
    Get:3 http://deb.debian.org/debian bullseye-updates InRelease [44.1 kB]
    Get:4 http://deb.debian.org/debian bullseye/main amd64 Packages [8062 kB]
    Get:5 http://deb.debian.org/debian-security bullseye-security/main amd64 Packages [258 kB]
    Get:6 http://deb.debian.org/debian bullseye-updates/main amd64 Packages [17.7 kB]
    Fetched 8546 kB in 7s (1268 kB/s)
    Reading package lists...
    Reading package lists...
    Building dependency tree...
    Reading state information...
    git is already the newest version (1:2.30.2-1+deb11u2).
    0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
    Cloning into 'unit-testing-aspnetcore-webapi'...
    Removing intermediate container ff8f5520586c
    ---> 2d50ba24b6b1
    Step 4/9 : RUN dotnet restore ./unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/web-api-tests.csproj
    ---> Running in dde7f8e4e902
    Determining projects to restore...
    Restored /app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api/web-api.csproj (in 69 ms).
    Restored /app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/web-api-tests.csproj (in 40.9 sec).
    Removing intermediate container dde7f8e4e902
    ---> 366c5e387d57
    Step 5/9 : WORKDIR /app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests
    ---> Running in 715dad0e28aa
    Removing intermediate container 715dad0e28aa
    ---> 379d61dfb01b
    Step 6/9 : RUN dotnet build -c Release
    ---> Running in 3b23836248ef
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

    Time Elapsed 00:00:02.98
    Removing intermediate container 3b23836248ef
    ---> 509fc2237e88
    Step 7/9 : FROM build AS test
    ---> 509fc2237e88
    Step 8/9 : WORKDIR /app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests
    ---> Running in ff5f66fc0f78
    Removing intermediate container ff5f66fc0f78
    ---> 131c0cca78bf
    Step 9/9 : RUN dotnet test
    ---> Running in bae23fd4a17f
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

    Passed!  - Failed:     0, Passed:    11, Skipped:     0, Total:    11, Duration: 30 ms - /app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api-tests/bin/Debug/net6.0/web-api-tests.dll (net6.0)
    Removing intermediate container bae23fd4a17f
    ---> 4c1605aa8aa1
    Successfully built 4c1605aa8aa1
    Successfully tagged devops_test_01:latest
    ```
7) Build docker build
    ```powershell
    sudo docker build -t devops_build_01 -f Dockerfile.build .

    Sending build context to Docker daemon  10.24kB
    Step 1/9 : FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
    ---> 6d33d3da7b5e
    Step 2/9 : WORKDIR /app
    ---> Running in 50ccae52dfbd
    Removing intermediate container 50ccae52dfbd
    ---> e37cb7d64425
    Step 3/9 : RUN apt-get update &&     apt-get install -y git &&     git clone https://github.com/CodeMazeBlog/unit-testing-aspnetcore-webapi.git
    ---> Running in 2b65d1fb61cd
    Get:1 http://deb.debian.org/debian bullseye InRelease [116 kB]
    Get:2 http://deb.debian.org/debian-security bullseye-security InRelease [48.4 kB]
    Get:3 http://deb.debian.org/debian bullseye-updates InRelease [44.1 kB]
    Get:4 http://deb.debian.org/debian bullseye/main amd64 Packages [8062 kB]
    Get:5 http://deb.debian.org/debian-security bullseye-security/main amd64 Packages [258 kB]
    Get:6 http://deb.debian.org/debian bullseye-updates/main amd64 Packages [17.7 kB]
    Fetched 8546 kB in 36s (240 kB/s)
    Reading package lists...
    Reading package lists...
    Building dependency tree...
    Reading state information...
    git is already the newest version (1:2.30.2-1+deb11u2).
    0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
    Cloning into 'unit-testing-aspnetcore-webapi'...
    Removing intermediate container 2b65d1fb61cd
    ---> da129b028a42
    Step 4/9 : RUN dotnet restore ./unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api/web-api.csproj
    ---> Running in 1befe7650884
    Determining projects to restore...
    Restored /app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api/web-api.csproj (in 48 ms).
    Removing intermediate container 1befe7650884
    ---> 2dc7921040ef
    Step 5/9 : WORKDIR /app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api
    ---> Running in aaaba4cd7c33
    Removing intermediate container aaaba4cd7c33
    ---> b7f3298d182b
    Step 6/9 : RUN dotnet build -c Release
    ---> Running in 12d8b68729ce
    MSBuild version 17.3.2+561848881 for .NET
    Determining projects to restore...
    All projects are up-to-date for restore.
    web-api -> /app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api/bin/Release/net6.0/web-api.dll

    Build succeeded.
        0 Warning(s)
        0 Error(s)

    Time Elapsed 00:00:02.28
    Removing intermediate container 12d8b68729ce
    ---> 355b080f1cc6
    Step 7/9 : FROM build AS publish
    ---> 355b080f1cc6
    Step 8/9 : WORKDIR /app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api
    ---> Running in d7c9729c6799
    Removing intermediate container d7c9729c6799
    ---> 4e5e1d006490
    Step 9/9 : RUN dotnet publish -c Release -o out
    ---> Running in 3f55235e21cc
    MSBuild version 17.3.2+561848881 for .NET
    Determining projects to restore...
    All projects are up-to-date for restore.
    web-api -> /app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api/bin/Release/net6.0/web-api.dll
    web-api -> /app/unit-testing-aspnetcore-webapi/netcore-unit-testing/web-api/web-api/out/
    Removing intermediate container 3f55235e21cc
    ---> 1c13aa813027
    Successfully built 1c13aa813027
    Successfully tagged devops_build_01:latest
    ```
8) Sprawdzenie stworzonego image
    ```powershell
    sudo docker images
    
    REPOSITORY                        TAG       IMAGE ID       CREATED          SIZE
    devops_build_01                   latest    eeaea385d7bd   9 minutes ago    767MB
    devops_test_01                    latest    bb1bba8e3c68   14 minutes ago   1.01GB
    ```