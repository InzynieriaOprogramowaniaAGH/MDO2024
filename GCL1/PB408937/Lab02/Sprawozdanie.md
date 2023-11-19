# Sprawozdanie 1
### Wstęp
Celem ćwiczenia jest zapoznanie się z tworzeniem kontenera Dockera wykorzystując program open source znajdujący się na repozytorium githab. Warunkiem koniecznym dla wybranego programu było aby posiadał plik Makefile z dowolnego środowiska, a także wbudowany test, który będzie można uruchomić z obrazu dokera. Ja wybrałem lekki kalkulator, napisany w C++,  który można otworzyć w terminalu.
### Przebieg ćwiczenia
1. Pierwszym krokiem było pobranie repozytorium z githuba.
```bash
    git clone https://github.com/alt-romes/programmer-calculator.git
```
Żeby uruchomić Makefile znajdujący się w programie musiałem zainstalować na swojej maszynie wirtualnej gcc i bibliotekę ncurces.
    ![Alt text](<png/Zrzut ekranu 2023-11-18 115312.png>)
    ![Alt text](<png/Zrzut ekranu 2023-11-18 115343.png>)
    ![Alt text](<png/Zrzut ekranu 2023-11-18 115405.png>)

Następnie przechodząc do folderu kalkulatora zbudowałem  program z uprawnieniami administratora używając komendy 
```bash
    sudo make install
```
![Alt text](<png/Zrzut ekranu 2023-11-18 115425.png>)

Następnie sprawdziłem działanie wbudowanych testów które znajdowały sie w głównym katalogu repozystorium.
```bash 
    ./run-test.sh
``` 
testy przeszły pomyślnie a program można było uruchomić w systemie. 
![Alt text](<png/Zrzut ekranu 2023-11-18 122645.png>)

2. Teraz należy te same czynności powtórzyć na kontenerze dockera. Najpierw inicjujemy nowy kontener dockera na obrazie systemu Fedora
```bash 
    sudo docker run -it fedora bash
```
![Alt text](<png/Zrzut ekranu 2023-11-18 121439.png>)

Na kontener kopiujemy repozytorium z githuba
```bash
    git clone https://github.com/alt-romes/programmer-calculator.git
```
A następnie instalujemy wszystkie potrzebne komponenty do uruchomienia pliku Makefile gcc oraz ncurces.
![Alt text](<png/Zrzut ekranu 2023-11-18 121727.png>)
![Alt text](<png/Zrzut ekranu 2023-11-18 121823.png>)

Można przerowadzić zbudowaneie programu na dokerze komendą 
```bash
    make install
```
![Alt text](<png/Zrzut ekranu 2023-11-18 121913.png>)

Próbując uruchomić wbudowany test
```bash 
    ./run-test.sh
``` 
![Alt text](<png/Zrzut ekranu 2023-11-18 122359.png>)

okazało się że na kontenerze fedory brakuje bibliteki diffutills na której komendach diff opieraja się wbudowane testy. 
![Alt text](<png/Zrzut ekranu 2023-11-18 122423.png>)

Po zainstalowanej bibliotece 
![Alt text](<png/Zrzut ekranu 2023-11-18 122448.png>)

test przeszedł pomyślnie 
![Alt text](<png/Zrzut ekranu 2023-11-18 122500.png>)

3. Ostatni krok to stworzenie plików Dockerfile. Jeden który będzie wykonywał make install a drugi który uruchomi test na stworzonym wcześniej kontenerze dockera.
W głównym pliku który utworzy obraz musimy dodać następujące komendy
FROM – określający na jakim obrazie system będziemy budowali dockera w moim przypadku fedora
RUN – określa wszystkie komendy instalacyjne i budujące, po niej dajemy komendę jakbyśmy normalnie korzystali z terminalu. 
WORKDIR – przejście do katalogu w którym znajduje się plik Makefile żeby komendą RUN make install następnie go zbudować.
```dockerfile
    FROM fedora
    RUN dnf -y install git gcc diffutils ncurses-*
    RUN git clone https://github.com/alt-romes/programmer-calculator.git
    WORKDIR /programmer-calculator
    Run make install
```
Możemy teraz sprawdzić czy kontener zadziała

![Alt text](<png/Zrzut ekranu 2023-11-20 192020.png>)
![Alt text](<png/Zrzut ekranu 2023-11-20 191958.png>)

Drugi Dockerfile służy wyłącznie do testu i ma bazować na utowrzonym wcześniej kontenerze dockera, dlatego do komendy FROM musimy się odwołać nazwą dockera który utworzymy a następnie do metody RUN dopisujemy ścieżkę pliku z testem:
```dockerfile
FROM calc
RUN /programmer-calculator/run-tests.sh
```
Jeśłi korzystalibyśmy z pliku make do testu musielibyśmy wykonać polecenie RUN make test.
Możemy teraz sprawdzić czy test działa
![Alt text](<png/Zrzut ekranu 2023-11-20 191919.png>)

W kontenerze Dockera pracuje już utworzony przez nas utworzone środowisko - fedora, zainstalowane biblioteki jak gcc oraz program kalkulatora.