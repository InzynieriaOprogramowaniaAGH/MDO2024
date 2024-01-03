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

Obraz Jenkins BlueOcean różni się od standardowego obrazu Jenkinsa tym, że ma wstępnie zainstalowaną wtyczkę Blue Ocean, która oferuje nowoczesny interfejs użytkownika do zarządzania Jenkinsem

`docker pull jenkinsci/blueocean`

<img width="690" alt="image" src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024/assets/39913427/c1bceaf5-5985-4e22-8f8a-b539e789d2ad">

Następnie uruchamiamy ten obraz

```
docker run \
  --name jenkins-blueocean \
  --rm \
  --detach \
  --network jenkins \
  --volume jenkins-data:/var/jenkins_home \
  --publish 8080:8080 \
  --publish 50000:50000 \
  jenkinsci/blueocean
```

<img width="569" alt="image" src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024/assets/39913427/8a47d03a-7993-4bf1-979b-cf6a1fb4ea89">

3. Za pomocą `docker ps` sprawdzamy czy nasz kontener działa

<img width="1815" alt="image" src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024/assets/39913427/26179c20-be09-4048-9dea-4f32a0511c67">

5. Wchodzimy przez przeglądarkę na adres `http://<ip-maszyny>:8080`

Po kilku chwilach zobaczymy gotowy konfigurator
   
<img width="1210" alt="image" src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024/assets/39913427/5a7d3dc2-67ed-4b63-b0ee-adff75e00536">

Zanim przejdziemy dalej, warto użyć komendy `docker logs jenkins-blueocean` która pokaże logi kontenera, w których znajdziemy nasze jednorazowe hasło:

<img width="810" alt="image" src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024/assets/39913427/649f047e-f6e9-44e4-a268-f1d8187e0473">

W moim wypadku moje jednorazowe hasło to: `a1ec359498a34f89905b910d04a5604f`

6. Po podaniu hasła w moim wypadku pojawiły się błędy związane z niepowodzeniem isntalacji kilku wtyczek

<img width="990" alt="image" src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024/assets/39913427/6f81798b-7526-4eba-9d0f-77dfe32219f5">

