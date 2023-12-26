# Sprawozdanie 2
### Wstęp
Celem ćwiczenia jest zapoznanie się z komunikacją między maszynami i podstawy Ansible oraz tworzenie plików kickstart do instalacji systemu z predefiniowanymi ustawieniami i paczkami.
### Przebieg ćwiczenia
Do przeprowadzenia zadania z Ansible potrzebne jest utworzenie kolejnej maszyny z fedorą, tak aby obie działały obok siebie. Na maszynie która miała być głównym hostem należy zainstalować pakiet ansible. 
![Alt text](<png/Zrzut ekranu 2023-12-02 095731.png>)
Następnie na obu maszynach należy utworzyć klucze ssh i wymienić między nimi klucz publiczny
![Alt text](<png/Zrzut ekranu 2023-12-02 095657.png>)
![Alt text](<png/Zrzut ekranu 2023-12-02 095715.png>)
Klucz ten należy zapisać w folderze .ssh w pliku authorized_keys, jeśli taki nie istnieje należy go utworzyć.
![Alt text](<png/Zrzut ekranu 2023-12-02 095816.png>)
Dzięki takiej wymianie kluczy można łączyć się między maszynami przez ssh bez wpisywania hasła.
Dodatkiem żeby nie trzeba było korzystać z IP maszyn można nadać im inne nazwy wykonując polecenia hostnamectl.
![Alt text](<png/Zrzut ekranu 2023-12-20 170311.png>)
![Alt text](<png/Zrzut ekranu 2023-12-20 170904.png>)
Komenda:
```bash
$ hostnamectl set-hostname
 ```
 pozwala dodać nową nazwę dla hosta.
 Aby maszyny widziały się po tej nazwie musimy dodać zapis do pliku /etc/hosts
 ![Alt text](<png/Zrzut ekranu 2023-12-21 170732.png>)
 Następne tworzymy plik inventory który będzie pomagał w komunikacji. Pod hasło Machines dodajemy wszystkie maszyny którymi chcemy zarządzać przez Ansible, Orchestrator to adres maszyny na której zainstalowany jest Ansible
  ![Alt text](<png/Zrzut ekranu 2023-12-20 161855.png>)
 Żeby sprawdzić czy wszystko zostało przeprowadzone poprawnie możemy utworzyć prosty playbook z zakończeniem .yaml według instrukcji ze strony Ansible, jest to typowy Hello World. 
 ![Alt text](<png/Zrzut ekranu 2023-12-20 185019.png>)
 Po odpaleniu pliku, jeśli wszystko będzie poprawne dostaniemy odpowiedź:
 ![Alt text](<png/Zrzut ekranu 2023-12-20 185031.png>)
 Teraz możemy przejść do wykonania pliku playbook do instalacji dockcera z nginx na drugiej maszynie. 
 Najpierw według instrukcji tworzymy plik naszego środowiska 
 ```bash
 $ env > env
 ```
 Plik playbook ma utworzyć na drugiej maszynie nowy folder, skopiowac tam nasz plik env ze środowiskiem, potem sprawdzić czy nie mamy już zainstalowanego dockera, zainstalować go jeśli jest taka potrzeba, uruchomić a następnie uruchomić nginx. 
 ![Alt text](<png/Zrzut ekranu 2023-12-20 212259.png>)
 Ważnym aspektem w uruchamianiu plików które jak docker potrzebują autoryzacji jest dodanie become: yes a do ścieżki wywołania flagi "-K", pozwoli to wpisać nam hasło, które zostanie zastosowane do wszystkich wywołań become. W innym przypadku dostaniemy odmowę: 
 ![Alt text](<png/Zrzut ekranu 2023-12-20 200141.png>)
 Możemy teraz przejść na nasz litteServer i zobaczyć czy wszystko zostało pomyślnie przekopiowane i zainstalowane:
 ![Alt text](<png/Zrzut ekranu 2023-12-20 212359.png>)
 ![Alt text](<png/Zrzut ekranu 2023-12-20 212315.png>)
####Kickstart
 Drugą częścią ćwiczenia było przygotowanie pliku kickstart. 
Na drugiej maszynie bez ansibla wydobywamy plik anaconda-ks.cfg w którym są zapisane jego ustawienia. Posłuży nam on do utworzenia identycznej maszyny ale z pakietami które były zainstalowane na pierwszej. 
Plik anaconda znajduje się w folderze root!
![Alt text](<png/Zrzut ekranu 2023-12-21 173505.png>)
Zawartość tego pliku trzeba poszerzyć o pakiety które zainstalowaliśmy na pierwszej maszynie, znajdujemy je manualnie poleceniem rpm -qa
![Alt text](<png/Zrzut ekranu 2023-12-21 142750.png>)
Do pliku dopisujemy pakiety:
![Alt text](<png/Zrzut ekranu 2023-12-21 173012.png>)
oraz repozytopria online 
![Alt text](<png/Zrzut ekranu 2023-12-21 173113.png>)
Następnie zgodnie z instrukcją zmieniamy polecenie clearpart --none na --all
![Alt text](<png/Zrzut ekranu 2023-12-21 173226.png>)
Ważnym aspektem do przeprowadzenia poprawnej instalacji było usunięcie linijki która nakazywała używanie cdrom jako instancji do instalacji systemu.
![Alt text](<png/Zrzut ekranu 2023-12-21 191231.png>)
Plik umieszczamy na repozytorium git i wykorzystujemy format raw podczas instalacji
![Alt text](<png/Zrzut ekranu 2023-12-21 160523.png>)
Wszystkie pakiety oprócz docker-ce, przy którym podczas instalacji wyskoczył komunikat o błędzie, udało się zainstalować.
![Alt text](<png/Zrzut ekranu 2023-12-21 190826.png>)