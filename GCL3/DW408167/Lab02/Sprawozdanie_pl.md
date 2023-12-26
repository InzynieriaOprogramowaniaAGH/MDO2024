# Docker files

Jeśli jeszcze nie skonfigurowałeś dockera, lub wirtualnej maszyny, przejdź przez te [kroki](../start.md)

> ## Syllabus
>
> - [Jak stworzyć i wejść do kontenera](#jak-wejść-do-kontenera)
> - [Jak zbudować obraz docker](#zbuduj-własny-obraz-docker)
> - podstawowe polecenie budowania obrazu dokera w pliku dockerfile

**Table of contents**

<!-- TOC -->
* [Docker files](#docker-files)
  * [Jak wejść do kontenera](#jak-wejść-do-kontenera)
    * [Uruchomienie aplikacji do dockerze](#uruchomienie-aplikacji-do-dockerze)
    * [Jak wyjść z kontenera?](#jak-wyjść-z-kontenera)
  * [Zbuduj własny obraz docker](#zbuduj-własny-obraz-docker)
    * [Budowanie obrazu - Dockerfile-build](#budowanie-obrazu---dockerfile-build)
    * [Obraz testujący - Dockerfile-test](#obraz-testujący---dockerfile-test)
  * [Docker compose](#docker-compose)
    * [Dockerfile.build](#dockerfilebuild)
    * [Dockerfile.test](#dockerfiletest)
    * [docker-compose.yml](#docker-composeyml)
  * [Deployment](#deployment)
<!-- TOC -->


## Jak wejść do kontenera

Jeśli chcemy wejść do kontenera (jeśli nie mamy obrazu, zostanie on pobrany automatycznie) możemy użyć polecenia:

```sh
docker run -it node bash
```

Jak widać powyżej, używamy obrazu `node`, który jest oparty na obrazie `Debian`.


> ### Dlaczego `node` wariant?
>
> Używamy wersji grubej wersji Node, ponieważ chcemy mieć już przygotowane wszystkie narzędzia, w `apline` i `slim` nie ma `git`, którego potrzebujemy do ściągnięcia naszego repozytorium.
> 
> Oczywiście możemy zainstalować gita ręcznie, ale w tym przypadku skorzystamy z wersji w pełni przygotowanej.
> 
> Jeśli chcesz wejść do wariantu `node:apline` lub `node:slim`, użyj `sh` zamiast `bash`, po prostu te warianty nie mają powłoki **bash**.
> 
> `docker run -it node:apline sh`

> ### Dlaczego **latest** wersja `node`?
>
> W naszej aplikacji nie używamy obecnie żadnych zależności ani funkcji, których nie ma w najnowszej wersji. Dopóki tego nie zrobimy, możemy używać najnowszej wersji.


### Uruchomienie aplikacji do dockerze

Budujemy aplikację node, więc wszystkie zależności znajdują się w pliku `package.json`, więc musimy je zainstalować.

Na początek zaczynamy od klonowania naszego repozytorium:

```sh
git clone https://github.com/DaW888/ts-script
```

Następnie przejdźmy do folderu z kodem i zainstalujmy zależności:

```sh
cd ts-script

npm install
```

Możemy uruchomić aplikację i sprawdzić czy uruchamia się poprawnie za pomocą polecenia:

```sh
npm start
```

I uruchom testy, aby sprawdzić, czy wszystkie przeszły pomyślnie:

```sh
npm test
```

Wszystko działa dobrze, więc możemy wyjść z kontenera i wrócić do naszego systemu hosta.

### Jak wyjść z kontenera?
kliknij : **`control + D`**

lub wpisz: `exit`


Aby wyświetlić swoje obrazy, użyj polecenia:

```sh
sudo docker images
```

**Output**

| REPOSITORY  | TAG    | IMAGE ID     | CREATED      | SIZE   |
|-------------|--------|--------------|--------------|--------|
| node        | slim   | 3eae05bac892 | 7 days ago   | 227MB  |  
| node        | latest | 8dbe454d6fd6 | 7 days ago   | 1.1GB  |  
| node        | alpine | ece0d10eb54d | 7 days ago   | 140MB  |  
| busybox     | latest | fc9db2894f4e | 4 months ago | 4.04MB | 
| hello-world | latest | b038788ddb22 | 6 months ago | 9.14kB | 

Tutaj możemy zobaczyć wszystkie obrazy, które pobraliśmy w naszym systemie.

Można tu również zauważyć różnicę pomiędzy wariantami obrazów `node`.

## Zbuduj własny obraz docker

Utwórzmy 2 obrazy, pierwszy do budowania aplikacji, drugi do testowania zbudowanej aplikacji.

W tym celu utworzymy 2 pliki Dockerfile:
- `Dockerfile-build`
- `Dockerfile-test`

> Pamiętaj, że te pliki nie mają żadnego rozszerzenia.
> 
> Utwórz je w nowym folderze, aby zachować porządek.


### Budowanie obrazu - Dockerfile-build

Zacznij od pliku, który będzie używany do budowania aplikacji.

Pamiętaj, że my tutaj nic nie robimy, poza przygotowaniem aplikacji, która jest całkowicie gotowa do testowania i uruchomienia.

```dockerfile
FROM node:latest

RUN git clone https://github.com/DaW888/ts-script.git

WORKDIR ts-script

CMD ["npm", "install"]
```

- `FROM` - używamy obrazu `node:latest` jako podstawy dla naszego obrazu, tak samo jak wtedy, gdy wchodziliśmy do kontenera.
- `RUN` - `git clone <REPO>` klonujemy nasze repozytorium i instalujemy zależności. Prawie przy każdym poleceniu musimy użyć słowa kluczowego `RUN`.
- `WORKDIR` - zmieniamy katalog roboczy na folder `ts-script`. Nie używaj `cd`, nie jest ono zachowywane pomiędzy poleceniami.
- `CMD` - polecenie, które kontener wykonuje domyślnie po uruchomieniu zbudowanego obrazu. Plik Dockerfile będzie używał tylko ostatecznej definicji `CMD`. `CMD` można zastąpić podczas uruchamiania kontenera za pomocą `docker run $image $other_command`.

```sh
sudo docker build -t node-bldr . -f Dockerfile-build
```

- `-t` - tag, nadajemy nazwę naszemu obrazowi
- `.` - ścieżka do folderu z plikiem Dockerfile
- `-f` - nazwa Dockerfile


### Obraz testujący - Dockerfile-test

Celem tego obrazu jest jedynie uruchomienie testów, co w aplikacji węzła jest naprawdę proste, wystarczy uruchomić `npm run test` i sprawdzić, czy wszystkie testy przeszły poprawnie.


```dockerfile
FROM bldr

CMD ["npm", "run", "test"]
```

`FROM node-bldr` - używamy obrazu „budującego” jako podstawy do testowania obrazu.
Dzięki temu skupiamy się tylko na jednej rzeczy.

Następnie zajmiemy się budowaniem obrazu testowego, tak samo jak to zrobiliśmy przy budowaniu obrazu.

```sh
sudo docker build -t node-test . -f Dockerfile-test
```

Uważaj na błędy w pliku dockerfile, często możemy pominąć polecenie lub popełnić literówkę, np.:

```
Error response from daemon: dockerfile parse error on line 3: unknown instruction: git
```

Teraz wiemy, że zapomnieliśmy umieścić „RUN” na początku polecenia „git”.

---

Teraz po uruchomieniu `sudo docker images` powinniśmy zobaczyć 2 nowe obrazy `node-bldr` i `node-test`.

| REPOSITORY  | TAG    | IMAGE ID     | CREATED      | SIZE   |
|-------------|--------|--------------|--------------|--------|
| node-bldr   | latest | 8f68cb33ae38 | 5 days ago   | 1.3GB  |  
| node-test   | latest | 8f68cb33ae38 | 5 days ago   | 1.3GB  |  
| node        | slim   | 3eae05bac892 | 7 days ago   | 227MB  |  
| node        | latest | 8dbe454d6fd6 | 7 days ago   | 1.1GB  |  
| node        | alpine | ece0d10eb54d | 7 days ago   | 140MB  |  
| busybox     | latest | fc9db2894f4e | 4 months ago | 4.04MB | 
| hello-world | latest | b038788ddb22 | 6 months ago | 9.14kB | 

## Docker compose

> Instalacja
> 
> `sudo dnf install docker-compose`

> ### Co to docker compose?
> Compose to narzędzie do definiowania i uruchamiania wielokontenerowych aplikacji Docker. Dzięki Compose używasz pliku YAML do konfigurowania usług aplikacji. Następnie za pomocą jednego polecenia utworzysz i uruchomisz wszystkie usługi ze swojej konfiguracji.
> 
> ~ [docker docs](https://docs.docker.com/compose/)

Aby utworzyć docker-compose, musimy zacząć od lekkiego przepisania naszych plików Dockerfile.
Teraz nie będziemy budować okna dokowanego `test` w oparciu o `builder`, ale zbudowaną aplikację będziemy kopiować pomiędzy kontenerami.

### Dockerfile.build

Tutaj używamy pełnej wersji węzła, ponieważ jak pamiętasz potrzebujemy `git` do sklonowania repozytorium.

Plik ten wygląda w zasadzie tak samo jak bez funkcji `docker-compose`.

```dockerfile
FROM node:latest
RUN git clone https://github.com/DaW888/ts-script.git
WORKDIR ts-script
CMD ["npm", "install"]
```

### Dockerfile.test

Teraz robi się ciekawie, bo będziemy modyfikować plik testowy.

Pierwszą ważną rzeczą jest to, że nie używamy już pełnego wariantu „node”, ale „node:alpine”, który jest kilka razy lżejszy.

```dockerfile
FROM node:alpine

COPY --from=app /ts-script /ts-script

WORKDIR /ts-script

CMD ["npm", "run", "test"]
```

- `COPY --from=app /ts-script /ts-script` - to polecenie kopiuje folder `/ts-script` z obrazu `app` do folderu `/ts-script` w obrazie `node-test`.


### docker-compose.yml

> Pamiętaj, że plik docker-compose jest napisany w formacie `yaml`, dlatego musimy uważać na spacje i tabulatory.

```yaml
version: '3.8'
services:
  app:
    build:
      context: .
      dockerfile: Dockerfile.build
    volumes:
      - .:/ts-script
    image: node-app:latest

  test:
    build:
      context: .
      dockerfile: Dockerfile.test
    depends_on:
      - app
    image: node-test:alpine
```

- `version` - Określa wersję formatu pliku docker-compose.
- `services` - W tej sekcji zdefiniowano różne usługi (kontenery) tworzące aplikację. W naszym przypadku mamy dwie usługi: `app` i `test`.
- `app` - Nazwa pierwszej usługi. Możemy używać dowolnej nazwy.
- `build` - Ta sekcja informuje Dockera, jak zbudować obraz.
- `context` - Ustawia kontekst kompilacji na bieżący katalog (.). W tym miejscu Docker szuka pliku Dockerfile i wszelkich plików, do których się on odwołuje.
- `dockerfile Dockerfile.build` - Określa plik Dockerfile, który ma być używany dla tej usługi, w tym przypadku jest to `Dockerfile.build`.
- `volumes` - Tutaj montujemy wolumin.
  - `.:/ts-script`: Ta linia montuje bieżący katalog (na hoście) do **kontenera** w ścieżce `/ts-script`. Jest to przydatne przy programowaniu, ponieważ umożliwia natychmiastowe odzwierciedlenie w kontenerze zmian wprowadzonych w kodzie źródłowym na hoście.
- `image` - Nazywa obraz jako „node-app:latest”. Ta nazwa będzie używana, jeśli zdecydujesz się zbudować obraz i użyć go w innym miejscu.
- `depends_on: - app`: Określa, że usługa „testowa” zależy od usługi „aplikacyjnej”. Docker Compose uruchomi najpierw usługę „aplikacja”, a następnie usługę „test”.


Aby uruchomić docker-compose, musimy użyć polecenia:

```sh
sudo docker-compose up
```

## Deployment

Jeśli chcemy deploy kontener, powinien on być jak najlżejszy. W naszym przypadku użyliśmy `node:alpine`, który jest naprawdę lekki.

Dużą zaletą jest to, że kopiowanie plików pomiędzy komputerem lokalnym a chmurą będzie znacznie szybsze.
