# Sprawozadnie Lab4

## Cel ćwiczenia:
Celem ćwiczenia było zapoznanie się z Jenkins, czyli narzędziem do automatyzacji związanej z tworzeniem oprogramowania. 
W szczególności ułatwia budowanie, testowanie i wdrażanie aplikacji.

## Wykorzystywane narzędzia:
- Hyper-V -> do wirtualizacji maszyny OpenSuse w wersji 15.5, na której wykonwyana była całość zadania,
- Git -> do pracy na repozytoriach z Github, domyślnie zainstalowany na wersji OpenSuse 15.5 oraz instalowana w dockerfile do klonowania wybranej apliakcji z github,
- Docker -> do konteneryzacji,
- SSH -> do komunikacji między maszynami, hostem i repozytorium,
- NPM -> menedżer pakietów dla środowiska node.js, domyślnie zainstalowany na użytym w budowie kontenera Alpine 16,
- Visual Studio Code -> do pracy nad sprawozdaniem.

## Wybrane repozytorium:
Na potrzeby poprzednich zajęć należało znaleźć repozytorium:
- na licencji open suorce,
- posiadające makefile oraz testy.

Wybrane repozytorium: https://github.com/devenes/node-js-dummy-test.

## Budowa plików dockerfile:
Budowa plików docker była tłumaczona w 2 ćwiczeniach i jest zawarta w sprawozdaniu:
[Sprawozdanie zawierające dokumentację na temat budowy kontenerów z wybranego repozytorium](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024/blob/PF408912/GCL1/PF408912/lab2/Sprawozdanie.md)

W skróce posiadamy 2 pliki dockerfile:
- dockerfile.builder służy do stworzenia środowiska z wybraną aplikacją,
- dockerfile.tester służy do testowania wcześniej stworzonego przez nas docker image z dockerfile.builer, uruchamia testy dla naszej aplikacji.

## Testowanie budowania skonteneryzowanej apliakcji z naszego obrazu:
Najpierw odpalimy lokalnie na maszynie nasze pliki dockerfile, by przetestować, czy nie ma błędów konfiguracji.
Przed tworzeniem obrazów usuwamy poprzednie obrazy z naszych plików:
![Alt text](screenshot1.png)

Dockerfile.builder:
```bash
docker build -t 'nodejsdummybuilder' . -f ./Dockerfile.builder
```
![Alt text](screenshot2.png)

Dockerfile.tester:
```bash
docker build -t 'nodejsdummytester' . -f ./Dockerfile.tester
```
![Alt text](screenshot3.png)

Mając gotowy i przetestowany obraz apliakcji tworzymy teraz kolejny plik dockerfile -> Dockerfile.deployer,
który uruchomi naszą apliakcję z obrazu stowrzonego przez Dockerfile.builder:
```bash
FROM nodejsdummybuilder:latest

EXPOSE 3000
CMD ["npm", "start"]
```
W tym celu użyłem dokumentacji zawartej na stronie github wybranej aplikacji.
Apliakcja zostanie uruchomiona na porcie 3000.
Budujemy nasz obraz:
```bash
docker build -t 'nodejsdummydeployer' . -f ./Dockerfile.deployer
```
![Alt text](screenshot4.png)

Mając obraz wybudowany z naszego pliku odpalamy nasz kontener:
```bash
docker run -d -p 3000:3000 nodejsdummydeployer
```
Flaga d odpala naszą komendę jako demon - odpowiednik serwisu z systemu Windows, dzięki czemu nie blokujemy sobie pracy w terminalu.
Flaga p służy wskazaniu portów: wewnętrznego w samym kontenerze i zewnętrnzego, który będzie nam potrzeby, by sprawdzić aplikację na hoście maszyny wirtualnej.
![Alt text](screenshot5.png)

Możemy teraz w przeglądarce sprawdzić działanie naszej wdrożonej aplikacji:
![Alt text](screenshot6.png)
Możemy również na samej maszynie wywołać komendę:
```bash
curl localhost:3000
```
Która wyświetli nam zawartość pliku index dla naszej aplikacji:
![Alt text](screenshot7.png)

## Instalacja Jenkins
Instalację jenkins z użyciem docker jest dokładnie opisane na stronie producenta:
https://www.jenkins.io/doc/book/installing/docker/
Na początku tworzymy docker network o nazwie jenkins.
Później uruchamiamy kontener DIND, który jest konieczny do korzystania z docker w naszym Jenkins.
DIND czyli docker in docker to metoda korzystania w kontenerze z usługi docker z hosta Jenkinsa, bez tego wywoływanie docker w Jenkins będzie się kończyć błędami.
Na stronie znajduje się punkcie 4a znajduje się dockerfile użyty przeze mnie do budowy obrazu i umiesczony na repo pod nazwą dockerfile.
![Alt text](screenshot8.png)
Na stronie jest również opis uruchomeinia Jenkinsa z własnego obrazu.
W moim wypadku Jenikns udostepniony jest na porcie 8080.
![Alt text](screenshot9.png)

Po wejściu do naszej aplikacji w przeglądarce będziemy musieli podać jednorazowo klucz i dopiero wtedy ustawimy hasło dla admina w Jenkins.
Całość procesu jest opisana na stronie pod Unlocking Jenkins.
Należy pamiętać, że ścieżka do klucza jest wewnąterz naszego kontenera, co również jest opsiane w dokumentacji.
Hasło będzie również dostępne w logach kontenera:
![Alt text](screenshot11.png)
![Alt text](screenshot12.png)

Po stworzeniu stałego hasła dla admina otrzymujemy dostęp do aplikacji, gdzie możemy stworzyć nasz pierwszy pipeline:
![Alt text](screenshot10.png)

## Test działania Jenkins, wykonanie poleceń uname i whoami
Tworzymy pierwszy projekt ogólny nazwny u mnie devops.
W projekcie w zakładce wyzwalacze budowania dodajemy kroki budowania.
Wybieramy uruchom powłokę, w której następnie możemy wpisać interesujące nasz komendy.
![Alt text](screenshot13.png)

Zapisujemy zmiany i uruchamiamy nasz projekt.
Projekt uruchamiamy przycysikiem uruchom w lewym panelu, gdzie wczęśniej wchodziliśmy w konfigurację projektu.
![Alt text](screenshot14.png)

Po uruchomieniu projektu po pewnym czasie zadania projektu się wykonają i pojawi nam się informacja o prawidłowym
przejściu zadania, jeśli Jenkins nie napotkał żadnych błędów. Sprawdzamy logi naszego zadania, w tym celu klikamy osattnie zadanie na głównym ekranie lub wybieramy nasze wywołanie z histori zadań, w ywpadku tego drugiego od razu możemy przejść na logi konsoli.
Opcja 1:
![Alt text](screenshot15.png)
![Alt text](screenshot17.png)

Opcja 2:
![Alt text](screenshot16.png)

W logach możemy zobaczyć jak Jenkins byuduje nasze środowisko i wywołuje wskazane komendy.
![Alt text](screenshot18.png)

Dużą zalęta systemu jest to, że posiadamy pełnie infomracji o każdym przejściu naszego zadania/pipeline, czyli m.in.:
- date
- status
- osobę, która uruchomiła zadanie.

## Tworzymy pipeline w Jenkins
1. Wprowadzenie teorytyczne:
Pojęcie pipeline powiązane jest z praktyką CI/CD (continuous integration/continuous delivery), która ma na celu ułatwienia i automatyzacji procesu integracji/wdrażania/aktualziacji/dostarczania oprogramowania do użytkownika końcowego poprzez odpowiednie praktyki i narzędzia. Najczęściej graficznie prezentowany jest poprzez pętlę zdarzeń.
Jednym z narzędzi stosowanych w CI/CD może być Jenkins wraz z jego pipeline dostarczania, czyli seria zautomatyzowanych etapów, kórych efektem końcowym może być dostarczenie działqającego i przetestowanego oprogramowania.
Pipeline powinien w sposób przewidywalny i określony dostarczyć produkt końcowy. Dzięki temu mamy eliminować błędy ludzkie oraz przyszpieszać cały proces.

W nasyzm przypadku stworzymy jedynie prosty pipeline mający na celu końcowo stworzyć nam docker image zawierający naszą aplikację wybraną z repozytorium github.
W tym celu stworzymy pipeline podzielony na 4 etapy:
- Build: uruchomienie Dockerfile.builder,
- Test: uruchomienie Dockerfile.tester,
- Deploy: uruchomienie Dockerfile.deployer, sprawdzenie działania aplikacji oraz przygotowanie "czystego obrazu apliakcji",
- Publish: wrzucenie naszego obrazu docker z apliakcją na dockerHub.

2. Prezentacja graficzna pipeline:
```mermaid
stateDiagram-v2
    [*] --> Build
    Build --> Test
    Test --> Deploy
    Deploy --> Publish
    Publish --> [*]
```

3. Budowa pipeline w Jennkins:
Tworzymy nowy projekt typu pipeline:
![Alt text](screenshot19.png)

W Pipeline mamy pipeline script, w kórym będziemy zapisywać nasze etapy.
W celu przetestowania naszego projektu możemy wybrać jeden z podstawowych dostępnych.
Ja wybrałem Hello World, co oprócz testów daje mi również szkielet potrzebnego skryptu, który następnie będę rozbudowywać o kolejne etapy:
![Alt text](screenshot20.png)

Uruchamiamy teraz nasze zadanie i sprawdzamy logi (cały proces był opisany wyżej w Test działania Jenkins).
Na ekranie pojawi się nam graficzny reprezentacja naszego zadania, który będzie pokazywał, które etapy przeszły.
Znacząco ułątwia to proces wykrycia na którym etapie popełniliśmy błąd. Nazwa etapu jest oczywiście zależna od tego jak
sami go nazwaliśmy.
![Alt text](screenshot21.png)
![Alt text](screenshot22.png)

Możemy również odpalić bezpośrednio logi tylko z jednego etapu klikając logs na tym etapie:
![Alt text](screenshot23.png)

Teraz będziemy dodawać nasze etapy do skryptu.

Pierwsza wersja skryptu zawierać etap build.
W tym celu sprawdzamy czy jesteśmy na odpowiedniej gałęzi na naszym repo.
Potem robimy pull, żeby na pewno korzystać z najnowszych dokcerfile.
Czyścimy cache i nieużywane obrazy lokalnie na maszynie, żeby miec pewność, że tworzymy całkowicie nowe docker image.
Następnie uruchamiamy dockerfile.build
```bash
stage('Build') {
            steps {
                cd /root/repo/MDO2024/
                git checkout PF408912
                git pull
                cd GCL1/PF408912/lab4/app/
                docker system prune -a --force
                docker build -t 'nodejsdummybuilder' . -f ./Dockerfile.builder
            }
        }
```
Pipeline nie przeszedł prawidłowo, ponieważ nie użyliśmy odpowiedniej składni w naszym srypcie, o czy system nasz informuje po klinięciu zastosuj, dlatego warto to zrobić przed kliknięciem zapisz, które zamyka nam okno.
Dodatkowo możemy również w każdym momencie zobaczyć logi poprzedniego uzycia pipeline i porównać różnice.
![Alt text](screenshot24.png)

Zmieniamy naszą składnię na odpowiednią do skryptów Jenkins oraz tym razem klonujemy nasze repozytorium tak, by jenkins miał do niego dostęp (nie ma dostępu do repo w folderze root).
Tym samym klonując za każdym razem repo musimy wpierw upewnić się, że już nie istnieje, w wypadku gdy już jest usuwamy je.
Zawsze usytawiamy się na naszym branch w repozytorium.
Również, żeby mieć pewność, że zawsze korzystamy z odpowiednich komponentów "czyścimy naszego dockera" z nieużywanch zasobów, czyli m.in z obrazów, które mogliśmy wygenerować w wcześniejszych przebiegach pipeline.
Finalnie nasz pierwszy etap wygląda tak:
```bash
stage('Build') {
            steps {
                sh 'if [ -d MDO2024 ]; then rm -rf MDO2024; fi'
                sh 'git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2024.git'
                dir('MDO2024'){
                    sh 'git checkout PF408912'
                }
                dir('MDO2024/GCL1/PF408912/lab4/app/'){
                    sh 'docker system prune -a --force'
                    sh 'docker build -t nodejsdummybuilder . -f ./Dockerfile.builder'
                }
            }
        }
```
![Alt text](screenshot25.png)

W kolejnym etapie użyjemy dockerfile.tester, by sprawdzić, czy nasz obraz z poprzedniego etapu przejdzie testy:
```bash
stage('Test') {
            steps{
                dir('MDO2024/GCL1/PF408912/lab4/app/'){
                    sh 'docker build -t nodejsdummytester . -f ./Dockerfile.tester'
                }
            }
        }
```

Następny etap deploy jest bardziej rozbudowany, oprócz stworzenia obrazu na bazie dockerfile.deploy, uruchomimy naszą apliakcję, sprawdzimy jej działanie wykorzystując logi aplikacji (serwer ma się uruchomić na porcie 3000).
dodatkowo dodałem komendę docker ps, by móc zobaczyć uruchomiony kontener.
Dodatkowo musze ręcznie wyłączyć kontener, który zajmuje teraz port, więc dodam do deploy również zatrzymanie kontenera.
W tym celu przy uruchamianiu kontenera dodam mu nazwę, której będę mógł użyć później do jego zatrzymania i usuniecia.
Musimy też dodać postój, żeby serwer apliakcji zdążył się załączyć.
Na tem moment deploy wygląda tak:
```bash
stage('Deploy') {
            steps{
                dir('MDO2024/GCL1/PF408912/lab4/app/'){
                    sh 'docker build -t nodejsdummydeployer . -f ./Dockerfile.deployer'
                }
                sh 'docker run --name myapp -d -p 3000:3000 nodejsdummydeployer'
                sh 'docker ps'
                sh 'sleep 10'
                sh 'docker logs myapp'
                sh 'docker stop myapp'
                sh 'docker rm myapp'
            }
        }
```
Widzimy w logach, że faktycznie serwer naszej aplikacji pracuje:
![Alt text](screenshot26.png)








