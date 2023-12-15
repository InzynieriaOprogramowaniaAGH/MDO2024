# Sprawozdanie 1

1. Instalacja Dockera na Fedorze

W celu zainstalowania Dockera skorzystałem z dokumentacji udostępnionej przez Dockera https://docs.docker.com/engine/install/fedora/

2. Pobranie przykładowych obrazów Dockerowych

<img width="570" alt="executable that produces the output you are currently reading" src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024/assets/39913427/f41afcf6-6832-4b89-97e0-a9186ac7fdbb">

Na powyższych zrzucie ekranu komendą `docker run hello-world` uruchomiłem kontener którego celem jest wyświetlenie wiadomości 
typu "hello world". Kontenerer ten jest popularny ponieważ w łatwy sposób pozwala na sprawdzenie czy Docker działa prawidłowo.
Na zrzucie ekranu widzimy, że uruchomiłem ten kontener poprzez `sudo` było to działanie omyłkowe. Polecenie `sudo` nie jest 
wymagane, aby prawidłowo uruchomić kontener.

<img width="573" alt="(root@localhost MD02024)# docker pull busybox" src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024/assets/39913427/e69e8eeb-a4c0-461d-a50f-1a0822994b85">

Na powyższym zrzucie ekranu widzimy pobranie obrazu busybox z docker hub za pomocą komendy `docker pull busybox`.
Następnie na podstawie obrazu uruchomiłem go w trybie interaktywnym komendą `docker run -it busybox`

3. Uruchom "system w kontenerze"

<img width="1151" alt="Pasted Graphic 6" src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024/assets/39913427/5f2b88f2-dfbc-474a-b117-e98b8551a90f">


4. Stwórz własnoręcznie, zbuduj i uruchom prosty plik Dockerfile bazujący na wybranym systemie i sklonuj nasze repo.

Kolejnym zadaniem było zbudowanie swojego pierwszego Dockerfile. Mój pierwszy Dockerfile znajduje sie poniżej:

```
FROM alpine:latest

RUN apk update && apk add git 

RUN git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2024.git /my_repository

WORKDIR /my_repository
```

source: https://raw.githubusercontent.com/InzynieriaOprogramowaniaAGH/MDO2024/WK408800/GCL2/WK408800/Lab01/dockerfile

dockerfile na początku pobiera obraz lekkiego linuxa Alpine, następnie aktualizuje jego repozytoria, a potem instaluje gita.
Za pomocą uprzednio pobranego gita dokonuja sklonowania repozytorium naszej grupy zajęciowej, a jego zawartośc umieszam w folderze 
`/my-repository`. Ostatnia linijka Dockerfile ustawia ten folder jako "roboczy folder" konteneru.

Wynikiem działania powyższego Dockerfile jest powstanie konteneru który zawiera nasze repozytorium i pozwala na interakcje z nim
poprzez git

<img width="733" alt="Pasted Graphic 9" src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024/assets/39913427/e4102699-959b-4a48-b9a5-5393815b81f0">


4. Pokaż uruchomione kontenery

aby wyświetlić działające kontenery używam komendy `docker ps`, w celu prezentacji tego polecenia uruchomiłem kontener z nginx

<img width="767" alt="image" src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024/assets/39913427/7aeedecb-4627-463e-a34d-20977a4dde01">

komedną `docker ps -a` możemy zobaczyć wszystkie kontenery, nawet te aktualnie nie działające

<img width="778" alt="image" src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024/assets/39913427/bbea1460-26c6-4432-8244-630ac8b3f882">

5. Wyczyść _obrazy_

W celu wyczyszczenia obrazów wykorzystam komendę `docker image prune`, a nastepnie komendy `docker rmi $(docker images -q) -f`

<img width="336" alt="image" src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024/assets/39913427/6b74af20-c1b6-4ddb-9e8f-2514c6426b22">

jak widzimy niżej, już nie ma żadnych obrazów

<img width="626" alt="image" src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024/assets/39913427/a49a4e10-aad9-4f71-9675-418bd2e6de41">
