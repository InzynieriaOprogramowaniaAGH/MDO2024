# Sprawozdanie 2

Wybrałem oprogramowanie [ZNC - An advanced IRC bouncer](https://github.com/znc/znc)

Jest oprogramowaniem na licencji Apache 2.0 i zostało zaakceptowane przez prowadzącego podczas zajęć.

W dokumentacji zawarta została instrukcja instalacji:
![instalacja](./screenshots/ZNC%20install.JPG)


Oraz testy:
![testy](./screenshots/ZNC%20test.JPG)


## Przygotowanie środowiska

Za pośrednictwem Oracle VM VirtualBox zainstalowałem Fedorę 39, do której dołączyłem mostkowaną kartą sieciową.

### SSH

Na maszynie potrzebujemy SSH, w tym celu wykonujemy polecenia:

```bash
sudo dnf install openssh-server
```

następnie uruchamiamy go i włączamy automatyczne uruchamianie przy starcie systemu:

```bash
sudo systemctl start sshd
sudo systemctl enable sshd
```

ewentualnie 

```bash
systemctl status sshd #w celu sprawdzenia 
```

Komendą 

```bash
ip a
```

Uzyskuję adres sieciowy maszyny wirtualnej.

W celu wygodniejszej edycji komend, za pośrednictwem Visual Studio Code, łączę się z nią przez SSH:

![ssh](./screenshots/SSH%20proof.JPG)

### Git

Do połączenia z naszym kontem GitHub (a co za tym idzie do autoryzacji przesyłanych plików na repozytorium), potrzebujemy też kluczy SSH, które generujemy komendą:

```bash
ssh-keygen
```

Klucz publiczny SSH należy dodać do swojego konta GitHub: [Adding a new SSH key to your GitHub account](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account).

Celem sprawdzenia można wykonać polecenie:

```bash
ssh -T git@github.com
```

Którego oczekiwanym wynikiem jest 

```bash
Hi fwawrzen! You've successfully authenticated, but GitHub does not provide shell access.
```

Tu "fwawrzen", bo to nazwa mojego konta (co potwierdza nawiązanie połączenia z odpowiednim kontem).

Warto zainstalować też najnowszą wersję samego gita:

```bash
sudo dnf install git
```

Na końcu można sklonować nasze repozytorium przez HTTPS:

```bash
git clone https://github.com/InzynieriaOprogramowaniaAGH/MDO2024.git
```

lub SSH, używając nowo dodanego klucza:

```bash
git clone git@github.com:InzynieriaOprogramowaniaAGH/MDO2024.git
```

### Docker

W celu instalacji dockera wykonujemy:

```bash
sudo dnf install docker
```

po pomyślnej instalacji można wykonać polecenia:

```bash
docker pull hello-world
docker run hello-world
```

Które udowodnią, że wszystko działa jak należy.

W celu pracy z terminalem interaktywnym należy dodać argument "-it", np.:

```bash
docker run -it --tty busybox
```

## ZNC

Rozpoczynając pracę z ZNC klonujemy repoztorium z dostępnym kodem, w tym przypadku przez HTTPS:

![clone ZNC](./screenshots/1.JPG)

Postępujemy zgodnie z dokumentacją:

![clone ZNC](./screenshots/2.JPG)

Instalujemy wymagane zależności

![clone ZNC](./screenshots/3.JPG)

Instalujemy wymagane zależności - ciąg dalszy (to IRC, więc wiadomo było, że nie będzie łatwo)

![clone ZNC](./screenshots/3cd.JPG)

Używam też polecenia

![clone ZNC](./screenshots/4.JPG)

W celu sprawdzenia zależności, ustawienia opcji konfiguracyjnych itd.

![clone ZNC](./screenshots/4cd.JPG)

Postępuję zgodnie z poleceniami

![clone ZNC](./screenshots/5.JPG)

I wkrótce...

![clone ZNC](./screenshots/5cd.JPG)

Jesteśmy gotowi do kompilacji

![clone ZNC](./screenshots/6.JPG)

Która szczęśliwie przebiegła pomyślnie

![clone ZNC](./screenshots/6cd.JPG)

## ZNC w kontenerze docker

Najpierw należy uruchomić dockera poleceniem

```bash
sudo systemctl start docker
```

![clone ZNC](./screenshots/d%201.JPG)

Możemy sprawdzić też jakie obrazy docker widzi na naszym systemie:

![clone ZNC](./screenshots/d%201%20images.JPG)

My natomiast uruchamiamy nowy kontener z terminalem TTY (co umożliwi interaktywność z powłoką). Do tego wybrałem lekką dystrybucję systemu Linux - alpine, ponieważ był to obraz zaproponowany w Dockerfile'u ZNC.

![clone ZNC](./screenshots/d2.JPG)

Wewnątrz kontenera klonuję repozytorium ZNC (argument --depth 1 pozwala na sklonowanie jedynie najnowszego commita)

![clone ZNC](./screenshots/d3.JPG)

Jak widać do tego potrzebny jest git...

![clone ZNC](./screenshots/d4.JPG)


![clone ZNC](./screenshots/d5.JPG)

Inicjuję rekursywne aktualizacje submodułów git, których wymaga ZNC


![clone ZNC](./screenshots/d6.JPG)

Po czym można już wykonać "cmake"

![clone ZNC](./screenshots/d7.JPG)


![clone ZNC](./screenshots/d8.JPG)

A następnie "make"

![clone ZNC](./screenshots/d9.JPG)

I tak wygląda ZNC zbudowane wewnątrz kontenera.

![clone ZNC](./screenshots/d10.JPG)

A tak ZNC poza kontenerem.

![clone ZNC](./screenshots/7%20porównanie%20z%20d10.JPG)

Następnie sprawdzam id kontenera, komituję do nowego buildera "znc-bldr", zyskując pożądany obraz.

![clone ZNC](./screenshots/sprawdzam%20id,%20commituję%20do%20buildera%20i%20mam.JPG)

Na tej podstawie napisałem własny Dockerfile do budowania ZNC - Dockerfile-zncbld.

![clone ZNC](./screenshots/mój%20dockerfile.JPG)

Używając własnego buildera buduję nowy kontener:

![clone ZNC](./screenshots/nowy%20obraz%20zbudowany%20moim%20dockerfile'em.JPG)

Analogicznie powinien wyglądać Dockerfile-znctest, jednak w dokumentacji ZNC nie znalazłem informacji jak przeprowadzić testy (być może z użyciem Google Tests, które w Makefile'u się przewijają)

```bash
FROM Dockerfile-zncbld

RUN test
```