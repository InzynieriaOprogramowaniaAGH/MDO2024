# Spotkanie 3
---
# Automatyzacja instalacji i scenariuszy poleceń

## Format sprawozdania
- Wykonaj opisane niżej kroki i dokumentuj ich wykonanie
- Na dokumentację składają się następujące elementy:
  - plik tekstowy ze sprawozdaniem, zawierający opisy z każdego z punktów zadania
  - zrzuty ekranu przedstawiające wykonane kroki (oddzielny zrzut ekranu dla każdego kroku)
  - listing historii poleceń (cmd/bash/PowerShell)
- Sprawozdanie z zadania powinno umożliwiać **odtworzenie wykonanych kroków** z wykorzystaniem opisu, poleceń i zrzutów. Oznacza to, że sprawozdanie powinno zawierać opis czynności w odpowiedzi na (także zawarte) kroki z zadania. Przeczytanie dokumentu powinno umożliwiać zapoznanie się z procesem i jego celem bez konieczności otwierania treści zadania.

- Sprawozdanie proszę umieścić w następującej ścieżce: ```<kierunek>/<grupa>/<inicjały><numerIndeksu>/Lab03/Sprawozdanie.md```, w formacie Markdown


## Zadanie do wykonania: Ansible

| :point_up:    | *Zainstaluj na innej maszynie wirtualnej środowisko Docker, a następnie uruchom w nim serwer WWW z własną konfiguracją* |
|---------------|:------------------------|


### Instalacja zarządcy Ansible
* Utwórz drugą maszynę wirtualną [Fedora](https://mirror.ihost.md/fedora/releases/38/Server/x86_64/iso/) o **jak najmniejszym** zbiorze zainstalowanego oprogramowania
* Zastosuj taką samą nazwę użytkownika-administratora
* Zainstaluj oprogramowanie Ansible na pierwszej maszynie
#### Inwentaryzacja systemów
* Dokonaj inwentaryzacji systemów
  * Ustal przewidywalne nazwy komputerów stosując `hostnamectl`
  * "Naucz" każdą z maszyn rozpoznawać inne maszyny po nazwach, zamiast adresów ip (np. `/etc/hosts`)
* Utwórz [plik inwentaryzacji](https://docs.ansible.com/ansible/latest/getting_started/get_started_inventory.html)
* Zweryfikuj łączność
  * Za pomocą `ping`
  * Za pomocą `ansible -m ping`
#### Zapewnianie łączności SSH
* Utwórz klucze SSH na każdej maszynie (lub użyj tych już istniejących)
* Zapewnij łączność między maszynami
  * Użyj co najmniej dwóch maszyn wirtualnych (optymalnie: trzech)
  * Dokonaj wymiany kluczy między maszyną-dyrygentem, a końcówkami (`ssh-copy-id`)
  * Upewnij się, że łączność SSH między maszynami jest możliwa i nie potrzebuje haseł
  
### Zadanie
* Wykonaj następujące czynności na zdalnej maszynie, za pomocą Ansible
  * Utwórz plik zawierający lokalne środowisko `env` i skopiuj go na maszynę, do katalogu `~/uploads`
  * Zainstaluj na maszynie środowisko Docker
  * Uruchom na maszynie kontener `nginx`
* **Zadanie dodatkowe:** uruchom serwer nginx z własną konfiguracją, wykorzystując woluminy

## Zadanie do wykonania: Kickstart
| :point_up:    | *Zainstaluj w trybie całkowicie nienadzorowanym maszynę wirtualną z Fedorą, zawierającą dokładnie to oprogramowanie, które jest potrzebne na zajęciach*|
|---------------|:------------------------|


### Plik odpowiedzi
* Na maszynie z minimalnym zbiorem oprogramowania, z zadania Ansible, wydobądź plik odpowiedzi (`anaconda-ks.cfg`)
* Na maszynie głównej, używanej do pozostałych zadań, znajdź zainstalowane pakiety (`rpm -qa`)
* Stwórz nowy plik odpowiedzi:
  * Bazuj na pliku z "małej maszyny"
  * Dodaj do niego listę pakietów z "dużej maszyny" (użyj tylko nazw, bez architektur i wersji, czyli np. `ansible-9.0.0~a3-1.fc39.noarch` wystarczy `ansible`). Przejrzyj listę **manualnie**, identyfikując samodzielnie doinstalowywane pakiety
  * Dodaj repozytoria online:
    * `url --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-38&arch=x86_64`
    * `repo --name=updates --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f38&arch=x86_64`
* Plik odpowiedzi może zakładać pusty dysk. Zapewnij, że zawsze będzie formatować całość, stosując `clearpart --all` zamiast `clearpart --none`
* Umieść plik odpowiedzi na swojej gałęzi w repozytorium, pobieraj go do instalatora za pomocą linka spod przycisku "Raw"
* Pamiętaj, że klucz odpowiedzi przechowuje (zaszyfrowane, acz wciąż) hasło. Użyj unikatowego, tylko na tę okazję.
### Instalacja
* Przeprowadź instalację ze stworzonego pliku odpowiedzi, wskazując go podczas uruchamiania ISO instalacyjnego
* Upewnij się, że instalator nie zadaje żadnych pytań
### Usprawnienia
* Wykonaj co najmniej jedno z poniższych zadań:
  * Dodanie do pliku odpowiedzi instalacji i uruchomienia kontenera `lighttpd`
  * Połączenie pliku odpowiedzi z ISO instalacyjnym
  * Eksport automatycznie zainstalowanej maszyny do przenośnego formatu, najlepiej poleceniem konsoli
