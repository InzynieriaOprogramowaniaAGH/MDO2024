# Wymagane narzedzia

- docker
- git
- dotnet 

# Użyte repo

- https://github.com/davidfowl/TodoApi.git

# Co trzeba zrobić

## 1. Pobierz repo
```powershell
git clone https://github.com/davidfowl/TodoApi.git
```
## 2. Pobierz dotnet-sdk-7.0 a nastepnie zainstaluj
```powershell
sudo rpm -Uvh https://packages.microsoft.com/config/fedora/35/packages-microsoft-prod.rpm
sudo dnf install dotnet-sdk-7.0
```
## 3. Sprawdzenie czy aplikacja działa
```powershell
[kasia@osboxes TodoApi]$ dotnet run

> Building...
warn: Microsoft.AspNetCore.DataProtection.KeyManagement.XmlKeyManager[35]
      No XML encryptor configured. Key {1c1e6aee-cc49-4d25-94d2-c5e07c526c6c} may be persisted to storage in unencrypted form.
info: Microsoft.Hosting.Lifetime[14]
      Now listening on: http://localhost:5000
info: Microsoft.Hosting.Lifetime[0]
      Application started. Press Ctrl+C to shut down.
info: Microsoft.Hosting.Lifetime[0]
      Hosting environment: Development
info: Microsoft.Hosting.Lifetime[0]
      Content root path: /home/kasia/projekty/MDO2024/READMEs/GCL1/KB408940/Lab02/TodoApi/TodoApi
```
## 4. Sprawdzenie czy testy jednostkowe działają 
```powershell
[kasia@osboxes TodoApi.Tests]$ dotnet test

  Determining projects to restore...
  Restored /home/kasia/projekty/MDO2024/READMEs/GCL1/KB408940/Lab02/TodoApi/TodoApi.Tests/TodoApi.Tests.csproj (in 4.33 sec).
  1 of 2 projects are up-to-date for restore.
  TodoApi -> /home/kasia/projekty/MDO2024/READMEs/GCL1/KB408940/Lab02/TodoApi/TodoApi/bin/Debug/net7.0/TodoApi.dll
  TodoApi.Tests -> /home/kasia/projekty/MDO2024/READMEs/GCL1/KB408940/Lab02/TodoApi/TodoApi.Tests/bin/Debug/net7.0/TodoApi.Tests.dll
Test run for /home/kasia/projekty/MDO2024/READMEs/GCL1/KB408940/Lab02/TodoApi/TodoApi.Tests/bin/Debug/net7.0/TodoApi.Tests.dll (.NETCoreApp,Version=v7.0)
Microsoft (R) Test Execution Command Line Tool Version 17.5.0 (x64)
Copyright (c) Microsoft Corporation.  All rights reserved.
Starting test execution, please wait...
A total of 1 test files matched the specified pattern.
Starting test execution, please wait...
A total of 1 test files matched the specified pattern.
Passed!  - Failed:     0, Passed:    16, Skipped:     0, Total:    16, Duration: 2 s - TodoApi.Tests.dll (net7.0)
```
## 5. Utworzenie Dockerfile.build
```powershell
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /app

#Pobierz projekt
RUN apt-get update && \
    apt-get install -y git && \
    git clone https://github.com/davidfowl/TodoApi.git
      
#Build aplikacji

WORKDIR /app/TodoApi/TodoApi

RUN dotnet build -c Release
```
## 6. Utworzenie Dockerfile.test
```powershell
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /app

#Pobierz projekt
RUN apt-get update && \
    apt-get install -y git && \
    git clone https://github.com/davidfowl/TodoApi.git

#Build aplikacji testowej

WORKDIR /app/TodoApi/TodoApi

RUN dotnet build -c Release

#Uruchomienie testów

FROM build AS test

WORKDIR /app/TodoApi/TodoApi.Tests

RUN dotnet test
```
## 7. Uruchomienie Docker deamon
```powershell
sudo systemctl enable docker
sudo systemctl start docker
```
## 8. Build docker build
```powershell
[kasia@osboxes TodoApi]$ sudo docker build -t "todo-api-build" . -f ./Dockerfile.build

Sending build context to Docker daemon  104.8MB
Step 1/5 : FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
7.0: Pulling from dotnet/sdk
b7f91549542c: Pull complete
a976ebe67a5a: Pull complete
01f22fa85c0a: Pull complete
ef7250e79466: Pull complete
f16f1898acfe: Pull complete
24d6e94ca71a: Pull complete
56fb13424330: Extracting [================>                                  ]   59.6MB/180.9MB
[ciag dalszy]

Build succeeded.

/usr/share/dotnet/sdk/7.0.404/Sdks/Microsoft.NET.Sdk.Publish/targets/Microsoft.NET.Sdk.Publish.targets(189,5): warning : Microsoft.NET.Build.Containers NuGet package is explicitly referenced. Consider removing the package reference to Microsoft.NET.Build.Containers as it is now part of .NET SDK. [/app/TodoApi/TodoApi/TodoApi.csproj]
    1 Warning(s)
    0 Error(s)
Time Elapsed 00:00:12.69
Removing intermediate container 6bc032d59c77
 ---> d5a333666550
Successfully built d5a333666550
Successfully tagged todo-api-build:latest
```
## 9. Build docker test
```powershell
[kasia@osboxes TodoApi]$ sudo docker build -t "todo-api-test" . -f ./Dockerfile.test

Sending build context to Docker daemon  104.8MB
Step 1/8 : FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
 ---> 4927d9f3828c
Step 2/8 : WORKDIR /app
 ---> Using cache
 ---> abefa9ceab6a
Step 3/8 : RUN apt-get update &&     apt-get install -y git &&     git clone https://github.com/davidfowl/TodoApi.git
 ---> Using cache
 ---> e2bd7e362b40
Step 4/8 : WORKDIR /app/TodoApi/TodoApi
[ciag dalszy]
Passed!  - Failed:     0, Passed:    16, Skipped:     0, Total:    16, Duration: 2 s - TodoApi.Tests.dll (net7.0)
Removing intermediate container 6823fe2dedec
 ---> 847cd1efd3cd
Successfully built 847cd1efd3cd
Successfully tagged todo-api-test:latest
```
## 10. Sprawdzenie utworzonych obrazów
```powershell
[kasia@osboxes TodoApi]$ sudo docker image ls

REPOSITORY                     TAG       IMAGE ID       CREATED              SIZE
todo-api-test                  latest    847cd1efd3cd   40 seconds ago       1.39GB
todo-api-build                 latest    d5a333666550   About a minute ago   1.1GB
mcr.microsoft.com/dotnet/sdk   7.0       4927d9f3828c   7 days ago           821MB
```
