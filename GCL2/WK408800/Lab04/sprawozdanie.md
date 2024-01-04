# Sprawozdanie 4 

Celem zajęć było skonfigurowanie Jenkinsa oraz utworzenie na nim pipeline w kilku wariantach

## Przygotowanie

W ramach jednych poprzednich zajęć utworzyłem dwa dockerfile:
1. [dockerfile.build](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024/blob/WK408800/GCL2/WK408800/Lab02/moj-projekt/dockerfile.build) - buduje aplikacje webową napisaną we Vue.js
2. [dockerfile.test](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024/blob/WK408800/GCL2/WK408800/Lab02/moj-projekt/dockerfile.test) - uruchamia testy do tej aplikacji

Kroki potrzebne aby uruchomić obydwa kontenery opisałem w jednym z poprzednich sprawozdań więc pozwolę je sobie pominąć.

## Disagram UML opisujący proces CI

Do uzupełnienia

## Jenkins - instalacja

W celu przeprowadzenia instalacji korzystam z komendy udostępnionej w [dokumentacji Jenkins](https://www.jenkins.io/doc/book/installing/docker/#on-macos-and-linux)

1. Tworzę sieć o nazwie `jenkins`
   
<img width="458" alt="Pasted Graphic 44" src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024/assets/39913427/c21b4b09-7184-4659-9d94-e1a66f37c9b6">

```
docker network create jenkins
```

2. Uruchamiam kontener z docker:dind

Kontener zawierający `docker:dind` jest nam potrzebny ponieważ dzięki niemu zapewniamy środowisko izolowane dla kontenerów, które będzie uruchamiał Jenkins. Dzięki temu zapobiegamy występowaniu konfliktów, oddzielamy środowiska oraz zwiększamy bezpieczeństwo. 

```
docker run \
  --name jenkins-docker \
  --rm \
  --detach \
  --privileged \
  --network jenkins \
  --network-alias docker \
  --volume jenkins-docker-certs:/certs/client \
  --volume jenkins-data:/var/jenkins_home \
  docker:dind
```

<img width="554" alt="image" src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024/assets/39913427/db02140d-7c2d-4024-837f-699d4810d28e">

3. Uruchamiamy kontener z jenkinsem z wtyczką blueocean

~~Obraz Jenkins BlueOcean różni się od standardowego obrazu Jenkinsa tym, że ma wstępnie zainstalowaną wtyczkę Blue Ocean, która oferuje nowoczesny interfejs użytkownika do zarządzania Jenkinsem~~

Okazuje się że obraz jenkinsci/blueocean jest nie rozwijany od ponad roku, a sam Jenkins mówi w dokumentacji. Problem zauważyłem w trakcie tworzenia pipeline (masa niewspieranych pluginów), nie mniej poza tą komendą, reszta kroków pozostaje taka sama.

<img width="853" alt="image" src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024/assets/39913427/fc7e3a0e-dd47-4bdf-8d03-616e27d8fa91">

Następnie uruchamiamy ten obraz

```
docker run \
  --name jenkins \
  --rm \
  --detach \
  --network jenkins \
  --volume jenkins-data:/var/jenkins_home \
  --publish 8080:8080 \
  --publish 50000:50000 \
  jenkins/jenkins:lts
```

<img width="756" alt="image" src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024/assets/39913427/28f984f4-8079-473e-9651-6a99e96d1159">

3. Za pomocą `docker ps` sprawdzamy czy nasz kontener działa

<img width="1724" alt="image" src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024/assets/39913427/29e9b963-a477-487a-aada-86a347376558">

5. Wchodzimy przez przeglądarkę na adres `http://<ip-maszyny>:8080`

Po kilku chwilach zobaczymy gotowy konfigurator
   
<img width="1210" alt="image" src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024/assets/39913427/5a7d3dc2-67ed-4b63-b0ee-adff75e00536">

Zanim przejdziemy dalej, warto użyć komendy `docker logs jenkins-blueocean` która pokaże logi kontenera, w których znajdziemy nasze jednorazowe hasło:

<img width="810" alt="image" src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024/assets/39913427/649f047e-f6e9-44e4-a268-f1d8187e0473">

W moim wypadku moje jednorazowe hasło to: `a1ec359498a34f89905b910d04a5604f`

6. Po podaniu hasła w moim wypadku pojawiły się błędy związane z niepowodzeniem isntalacji kilku wtyczek

<img width="990" alt="image" src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024/assets/39913427/6f81798b-7526-4eba-9d0f-77dfe32219f5">

Po kliknięciu "Ponów" przeszło dalej

7. Kreacja administratora

<img width="990" alt="image" src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024/assets/39913427/81832a2e-b565-420f-92e8-6b7e8d9b9d3e">

## Jenkins - tworzenie projektu

1. Wybieramy opcję "Nowy projekt"

Wybieramy Ogólny projekt i nadajemy mu nazwę

<img width="954" alt="image" src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024/assets/39913427/640c0ea2-cf84-4479-b011-344a75db5ae8">


2. Przechodzimy do zakładki "Budowanie" i podajemy komendy `whoami` oraz `ls`

<img width="1374" alt="image" src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024/assets/39913427/e11e1b22-d0eb-4a1a-a35f-1d69074e1f82">

Zapisujemy

4. Uruchamiamy pipeline i sprawdzamy logi (klikamy Uruchom)

<img width="1374" alt="image" src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024/assets/39913427/9548ae43-b18e-40a5-b0e0-b0a5b4702391">

następnie przechodzimy w szczegóły zadania i widzimy wyniki poleceń `whoami` oraz `ls`

<img width="1374" alt="image" src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024/assets/39913427/e8e5d5c7-d7ad-4a4c-8e73-37185df135d2">

## Pipeline 

1. Tworzymy nowy projekt zamiast "Ogólny" wybieramy "Pipeline"

<img width="947" alt="image" src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024/assets/39913427/83bff182-519a-4b77-b0bc-453521971277">

2. Ustawiamy jako nasz pierwszy job w pipeline "hello world"

<img width="947" alt="image" src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024/assets/39913427/18679c4e-b0c0-4463-ac2c-a3a27bbefdfa">

3. Przystępujemy do pisania naszego pipeline

Chcemy aby nasz pipeline
- sklonował repozytorium
- dokonał checkout na branch
- dokonał zbudowania projektu z `dockerfile.build`
- następnie wykonał `dockerfile.test` które ma zależność z kontenerem powstałym z `dockerfile.build`
- dokonał deploymentu naszej aplikacji
  