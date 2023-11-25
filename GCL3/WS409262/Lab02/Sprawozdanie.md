<span style="font-size: 24px;"> Wstęp</span>

Celem zadania jest stworzenie dwóch kontenerów, które automatyzują proces budowy i testowania wybranej przez siebie aplikacji. W moim przypadku wybrałem niewielką aplikację redis-om-node, która spełnia wymogi zadaniu: otwarta licencja, narzędzie npm, zdefiniowane testy. Przed stworzeniem kontenerów zbudowałem i przetestowałem aplikację lokalnie w Fedora 38. 


* Na początku sklonowałem repozytorium wybranej aplikacji z github, za pomocą git clone.
![klonowanie](clone.png)

* Następnie wszedłem do utworzonego folderu (cd *nazwa_folderu*) i doinstalowałem zależności, które są zdefiniowane w package.json, są one potrzebne do poprawnego uruchomienia aplikacji. Użyłem do tego npm install.
  ![dependencies](depend.png)

* Przeprowadziłem build aplikacji, który służy do tworzenia zoptymalizowanej kompilacji produkcyjnej. Wykorzystałem do tego npm run build.
  ![build](build.png)

* W celu uruchomienia testów dołączonych do aplikacji, skorzystałem z npm test.
![test](test.png)


<span style="font-size: 20px;"> Przeprowadzenie buildu w kontenerze
</span>

1. W związku z tym, że wybrana przez mnie aplikacja jest napisana w typescript, na obraz kontenera wybrałem najnowszą wersję node. Aby pobrać obraz node, użyłem komendy docker pull node.
![node-install](node.png)

- W celu uruchomienia kontenera w trybie z podłączonym TTY, użyłem komendy docker run -it node sh. docker run - uruchamia kontener, -it - odpowiada za podłączenie TTY, node - obraz kontenera, sh - uruchomienie powłoki Shell 
![init](init.png)

- W poniższych podpunktach wykorzystałem polecenia z wcześniejszego zadania, tyle że w kontenerze. 
Klonowanie aplikacji w kontenerze.
![clone-in-container](cloneCon.png)

- Instalacja zależności w kontenerze.  
![depends-in-container](dependCon.png)

- Budowa aplikacji w kontenerze.    
![build-in-container](buildCon.png)

- Testowanie aplikacji w kontenerze. 

  ![tests-in-container](testCon.png)

2. Stworzyłem plik Dockerfile-redisbld, odpowiedzialny za automatyczne przeprowadzenie wszystkich kroków od sklonowania repozytorium, do budowy aplikacji. 

![builder-file](file-bld.png)
- FROM node:latest - określa obraz bazowy, w tym przypadku najnowsza wersja node.
- RUN git clone https://github.com/redis/redis-om-node.git - uruchomienie klonowania repozytorium aplikacji.
- WORKDIR redis-om-node - ustala katalog, w ktróym będą wykonywane następne instrukcje.
- RUN npm install - uruchomienie instalacji zależności aplikacji.
- RUN npm run build - uruchomienie budowy aplikacji.

* Dockerfile-redistest - to plik, który bazuje na pierwszym i  wykonuje testy aplikacji. 
![test-file](file-test.png)
- FROM docker-redisbld - określa obraz bazowy. 
- RUN npm test - uruchomienie testów aplikacji.

3. Wdrażanie kontenerów przedstawione jest na poniższych zdjęciach.
- Wdrażanie konteneru z budową aplikacji. Kontener automatycznie wykonuje zadane mu polecenia w pliku Dockerfile i instaluje zależności. 
![docker](docker-bld.png)
![docker](docker-bld2.png)
- Wdrażanie konteneru z testowaniem.

![docker](docker-test.png)
- Uruchomienie konteneru z budową. W tym kontenerze pracuje aplikacja redis-node.
![docker](cont.png)

 

