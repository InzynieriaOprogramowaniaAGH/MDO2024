# Sprawozdanie 2

W trakcie laboratorium naszym celem było przeprowadzenie buildu wybranej aplikacji w kontenerze. 
Naszym zadaniem było stworzenie dwóch kontenerów:
1. kontener miał budować naszą aplikację
2. drugi kontener bazując na aplikacji zbudowanej przez poprzedni kontener, miał uruchomić testy


W celu realizacja zadania postanowiłem zbudować swoją aplikacje, którą realizowałem na potrzeby 
rekrutacji do swojej pierwszej pracy. Dostępnej jako repozytorium pod adresem: 
https://github.com/Kozioleczek/coderpeak-palindrom.git

Kroki zrealizowane:
1. Napisanie `dockerfile.build`

```
FROM node:14-bullseye

RUN git clone https://github.com/Kozioleczek/coderpeak-palindrom.git

WORKDIR /coderpeak-palindrom

RUN npm install 

RUN npm run build
```

Moja aplikacja jest prostą aplikacją frontendową napisaną we Vue - frameworku JavaScript.
W celu zbudowania jej potrzebujemy `node.js`, czyli środowiska uruchomieniowego aplikacji napisanych
w JavaScript. Linijka `FROM node:14-bullseye` zapewnia nam dwie ważne dla nas rzeczy:
1. pobiera z Docker Hub obraz Debiana w wersji Bullseye
2. Dystrybucja ta zawiera zainstalowane środowisko `node.js` w wersji 14, czyli dokładnie takiej jaką wymaga mój projekt

Zdecydowałem się na użycie tego obrazu ponieważ w kolejnym kroku potrzebujemy skorzystać z gita w celu sklonowania projektu
z repozytorium. Wiedziałem, że ten obraz posiada git ponieważ sprawdziłem tagi obrazu na Docker Hubie.

W kolejnych linijkach dokonuje sklonowania repozytorium `RUN git clone https://github.com/Kozioleczek/coderpeak-palindrom.git`,
a następnie ustawiam folder o nazwie `/coderspeak-palindrom` jako folder roboczy komendą `WORKDIR /coderpeak-palindrom`

Na końcu linijką `RUN npm install` instaluje zależności przy pomocy `npm` (node package manager).

Finalnie linijką `RUN npm run build` buduję aplikacje

2. budowa `dockerfile.build`

W celu zbudowania konteneru wydaje polecenie `docker build -t palindrom-bullseye-build . -f ./dockerfile.build`

komenda taguje nasz obraz `-t palindrom-bullseye-build` 
flaga `-f ./dockerfile.build` określa "skąd" mamy budować nasz obraz

Otagowanie obrazu jest istotne ponieważ odwołujemy się do niego w kolejnym dockerfile

<img width="1013" alt="image" src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024/assets/39913427/69791822-32d5-4531-a4a3-8f17155ef8a2">


2. Napisanie dockerfile.test

```
FROM palindrom-bullseye-build

RUN npm run test:unit
```

Ten dockerfile w pierwszej linijce "pobiera" obraz który zbudowaliśmy w poprzednim kroku z naszą aplikacją.

W kolejnej linijce przy pomocy `RUN npm run test:unit` uruchamiamy testy jednostkowe jakie zostały zdefiniowane w naszej aplikacji

3. budowa `dockerfile.test`

budujemy nasz obraz z testami komendą `docker build -t palindrom-bullseye-test . -f ./dockerfile.test`, w przypadku pomyślnego
wykonania testów jednostkowych nasz obraz zostanie zbudowany, w przypadku błędu, nasz obraz nie zostanie zbudowany. 

<img width="1027" alt="image" src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024/assets/39913427/4f4cfadd-15eb-407a-a554-e7bd266c9709">

Jak widzimy wyżej, nasz obraz zbudowal się pomyślnie. Wszystkie testy przeszły prawidłowo.

jeśli chcielibyśmy zobaczyć wynik działania naszych testów jednostkowych w bardziej przejrzysty sposób możemy zamiast dyrektywy
`RUN npm run test:unit` wykorzystać dyrektywę `CMD ["npm", "run", "test:unit"]` dzięki czemu po uruchomieniu obrazu naszym oczą
ukaże się poniższy widok.

Kontener na bazie obrazu uruchamiamy w takiej sytuacji poleceniem `docker run -t palindrom-bullseye-test`

<img width="572" alt="image" src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024/assets/39913427/9ff5f103-ce40-49e7-91ff-2ea7adf271b9">

Róznica między dyrektywą `RUN`, a `CMD` jest taka, że:

RUN:
- jest używany w trakcie budowy obrazu Docker
- możemy przy jego pomocy instalować oprogramowanie, pakiety, robić operacje na plikach itd. czyli operacje często potrzebne
w trakcie budowy obrazu
- wynik działania `RUN` jest zapisywany w warstwach obrazu i staje się jego częścią

Z drugiej strony `CMD`:
- jest używane do określania polecenia jakie ma byc uruchomione, gdy kontener oparty na obrazie zostanie uruchomiony
- mozna użyć jedynie jednej instrukcji `CMD` w dockerfile, poprzednie zostaną zignorowane.

