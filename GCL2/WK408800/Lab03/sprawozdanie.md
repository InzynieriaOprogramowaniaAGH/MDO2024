# Sprawozdanie 3

Nasze laboratorium składa się z dwóch części:
1. Instalacja Ansible i realizacja za jego pomocą kilku zadań
2. Instalacja Fedory w trybie nienadzorowanym przy użyciu pliku Kickstart

## Część z Ansible

W celu realizacji tej części musiałem utworzyć dwie maszyny wirtualne z systemem Fedora. Jedna z nich będzie wykorzystywywana jako serwer, a druga jako klient.
Za pomocą tej pierwszej przy użyciu Ansible dokonamy instalacji / wykonaniu kilku aktywności na maszynie klienckiej poprzez SSH.

1. Utworzenie maszyn wirtualnych

Tworzymy standardowe maszyny wirtualne, w moim wypadku obydwie z obrazem `Fedora-Server-dvd-x86_64-38-1.6.iso` (Fedore 38), waznym jest pamięć o ustawieniu
poprawnie sieci, tj. ustawienie karty sieciowej w tryb bridge i zdefiniowanie jakiego interfejsu z maszyny host będzie korzystać

<img width="819" alt="Zrzut ekranu 2023-12-15 o 22 12 23" src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024/assets/39913427/3c701d03-9e58-4043-9ac1-970f347ef5cb">

Należy pamiętać o tym, aby nie dokonywać klonu maszyn tj. tworzymy pierwszą i klonujemy aby stworzyć drugą. Robimy ręcznie oddzielne instalacje.

2. Ustalamy adresy IP naszych maszyn

W moim wypadku:

Fedora 1 (Server) - IP: 192.168.68.120

Fedora 2 (Client) - IP: 192.168.68.121

3. Instalacja zarządcy Ansible na Fedora 1

Wydajemy polecenie `sudo dnf install ansible` zgodnie z dokumentacją 
https://docs.ansible.com/ansible/2.9/installation_guide/intro_installation.html#installing-ansible-on-rhel-centos-or-fedora

<img width="620" alt="rtt minavgmaxmdev = 0 7311 2622 1890 523 ms" src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024/assets/39913427/7c6401f0-5006-4c5e-8b81-bfab6dda6e27">

4. Ustal przewidywalne nazwy komputerów stosując `hostnamectl`
   
<img width="1085" alt="Pasted Graphic 3" src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024/assets/39913427/68b0bc1e-4b07-47b7-a287-8e42d5327356">

w celu ustalenia nazwy hostów korzystamy z polecenia `hostnamectl set-hostname <"fedora-1" | "fedora-2">

5. Zapewnienie łączności SSH

Jest to istotny krok, który zapewni nam bezproblemowe działanie Ansible. 

Na maszynie będącej serwerem w moim wypadku Fedora 1, tworzymy klucz SSH 

`ssh-keygen -t rsa -b 2048`

<img width="585" alt="root@localhost ansible_quickstart # ssh-keygen -t rsa -b 2048" src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024/assets/39913427/66bcd203-f1fe-4ade-9139-91e947b616cc">


następnie wymieniamy się tym kluczem z maszyną Fedora 2 (client)

`ssh-copy-id root@192.168.68.121`

<img width="813" alt="INFO attespting to" src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024/assets/39913427/2b9ce964-6ab8-4a0a-956d-7344000b66c2">

weryfikujemy czy jesteśmy w stanie połączyć się z Fedora 1 na Fedora 2 poprzez SSH bez hasła

`ssh root@192.168.68.121` 

w przypadku jeśli tak jak ja korzystasz z konta root, koniecznym jest dodanie do pliku 
`/etc/ssh/sshd_config` na Fedora 2 (client) flagi

```
PermitRootLogin: yes
```

W przypadku dalszych problemów może koniecznym być ustawienie na Fedora 1 i Fedora 2 dodatkowo flag

```
RSAAuthentication yes
PubkeyAuthentication yes
```

Ważne, pamiętaj, aby po zapisaniu `sshd_config` zresetować usługę `systemctl restart sshd`

Jeśli to nie pomoże i nie korzystamy domyślnie z konta root, prawdopodbnie w wyniku braku uprawnień na Fedora 2 podczas wymiany kluczy przy pomocy `ssh-copy-id` z Fedora 1 na Fedora 2, użytkownik na Fedora 2 nie może utworzyć pliku `authorized_keys` w celu naprawy wystarczy wydać polecenie: `chmod 600 ~/.ssh/authorized_keys` na maszynie klienckiej

6. utworzenie pliku `inventory.ini`

Plik `inventory.ini` zawiera informacje o maszynach jakimi będziemy zarządzać z poziomu komputera "Fedora 1" (server, zarządca Ansible)

<img width="622" alt="GNU nano 7 2" src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024/assets/39913427/6509cf07-dc26-4d24-89ae-8909f21262ec">

Jak widzimy na powyższym zrzucie ekranu, zdefiniowałem grupę "Machines" poprzez zapis `[Machines]`, a następnie przypisałem do niej adres IP 
komputera "Fedora 2" (klient) - `192.168.68.121`

Następnie sprawdzamy czy Ansible "czyta" nasz plik `inventory.ini` poleceniem `ansible-inventory -i inventory.ini --list`

<img width="762" alt="Pasted Graphic 9" src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024/assets/39913427/7dc116dc-e9bc-44f4-bc62-e28c11c2a480">


7. Weryfikacja łączności za pomocą Ansible Ping

Wydając polecenie `ansible Machines -m ping -i ./inventory.ini` prosimy Ansible o wykonanie "ping" wszystkich klientów z grupy `Machines` zdefiniowanych
wewnątrz pliku `inventory.ini`, jeśli w poprzednich krokach poprawnie dokonaliśmy wymiany kluczy SSH pomiędzy maszynami, powinniśmy zobaczyć poniższy 
komunikat. W razie niepowodzenia należy ponowić próbę wymiany kluczy.

<img width="724" alt="192 168 68 121" src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024/assets/39913427/f7b308e4-4fdc-44b7-ad8d-12cdee336d33">

8. Utworzenie i uruchomienie Ansible Playbook

Ansible Playbook zawiera kroki jakie Ansible ma zrealizować na maszynach zdefiniowanych wewnątrz `inventory.ini`.
W moim wypadku Playbook:
- utworzy folder `~/uploads` jeśli nie istnieje
- skopiuje do niego plik `env`
- zainstaluje oprogramowanie docker
- nastepnie uruchomi docker deamon
- na końcu uruchomi kontener nginx

Tworzymy plik `playbook.yml`

<img width="646" alt="hosts Machines" src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024/assets/39913427/bad587d8-da22-489f-aa2d-ff51b380baf7">

W lokalizacji gdzie stworzyliśmy plik tworzymy plik `env`

<img width="564" alt="GNU nano 7 2" src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024/assets/39913427/62edbcf1-6587-4198-b074-5ae0c9f9e5f3">

Uruchamiamy nasz Playbook poleceniem `ansible-playbook -i ./inventory.ini playbook.yml`

<img width="741" alt="changed" src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024/assets/39913427/9f6cc8cd-ce83-405c-b703-64497aac265e">


Nastepnie weryfikujemy czy wszystko poszło zgodnie z planem:
1. Logujemy się po SSH na Fedora 2 (client)
2. Sprawdzamy czy pod ścieżką `~/uploads/env` mamy nasz plik z zawartością

<img width="523" alt="root@fedora-2 uploads # cat ~uploadsenv" src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024/assets/39913427/4fa64bd9-a95c-4f69-afb3-d32d85bcd093">

3. Sprawdzamy czy zainstalował się Docker

<img width="514" alt="root@fedora-2 ~ # docker" src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024/assets/39913427/707de019-1d91-4088-96d3-b12c0068879b">

4. Na końcu sprawdzamy czy nasz kontener z nginx działa

<img width="921" alt="Pasted Graphic 25" src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024/assets/39913427/ff9bf701-b062-4816-8913-20e4091395da">

Jak widzimy powyżej wszystko działa.

## Część z Kickstart

Kickstart to sposób na przeprowadzenie instalacji dystrybucji linuxowej, z pomocą pliku konfiguracyjnego. Wbrew pozorom proces instalacji nie jest taki straszny jak się wydaje.

1. Wydobycie pliku `anaconda-ks.cfg`

Na naszej maszynie Fedora 1 wchodzimy do `root/anaconda-ks.cfg` i kopiujemy do wybranego edytora plik konfiguracyjny. W moim wypadku wyglądał u mnie jak niżej

<img width="634" alt="root@fedora-1 ~ # cat rootanaconda-ks cfg" src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024/assets/39913427/d21bee98-5247-4a94-b0a0-ef1755342680">

2. Edytujemy nasz plik Kickstart

- Dodajemy do niego repozytoria online

```
# Dodajemy repozytoria

url --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-38&arch=x86_64
repo --name=updates --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f38&arch=x86_64
```

- Następnie dodajemy sekcje zawierającą pakiety dodatkowe, ja dodaje tylko `podman`

```
# Dodajemy wybrane pakiety dodatkowe
%packages
@^server-product-environment
@headless-management

# Tutaj dodaj pakiety, w moim wypadku dodałem tylko podmana
podman

%end
```

- Zmieniamy `clearpart --none` na `clearpart --all`

- Finalnie dodajemy skrypt który doda serwis, który uruchomi nasz kontener z `lighttpd`. Obraz ten zawiera lekki serwer HTTP. Konfigurujemy serwis tak aby uruchomił kontener na porcie `80`

```
%post --nochroot --log=/mnt/sysimage/root/ks-post.log
#!/bin/bash

# Tworzenie pliku usługi systemd dla kontenera lighttpd w zainstalowanym systemie
cat <<EOF > /mnt/sysimage/etc/systemd/system/lighttpd-container.service
[Unit]
Description=Lighttpd Container
Wants=network-online.target
After=network-online.target

[Service]
Restart=always
ExecStart=/usr/bin/podman run --name my-lighttpd-container -p 80:80 --rm docker.io/jitesoft/lighttpd
ExecStop=/usr/bin/podman stop my-lighttpd-container

[Install]
WantedBy=multi-user.target
EOF

chroot /mnt/sysimage/usr/bin/systemctl enable lighttpd-container.service

%end
```

3. Dodajemy nasz plik kickstart w ogólnodostepne miejsce

W moim wypadku wystawiłem plik kickstart na repozytorium i jest dostepny pod adresem: 
https://raw.githubusercontent.com/InzynieriaOprogramowaniaAGH/MDO2024/WK408800/GCL2/WK408800/Lab03/fedora-38-server-ks.cfg

4. Tworzymy nową maszynę w Virtual Box

Robimy standardowo jak poprzednio, wybieramy obraz ISO `Fedora-Server-dvd-x86_64-38-1.6.iso` (Fedora 38), ustawiamy tak jak poprzednio ustawienia sieciowe, aby mieć kartę sieciowa w bridge.

5. Uruchamiamy maszynę i podajemy flagę `inst.ks`

Po uruchomieniu maszyny zobaczymy GRUB, wybieramy strzałkami opcję `Install Fedora 38` i klikamy przycisk `e`

Zobaczymy wtedy taki widok jak niżej:

<img width="732" alt="Pasted Graphic 7" src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024/assets/39913427/9b35959f-d5f6-485c-ac46-930076b90147">

Na powyższych zrzucie już widać flage `inst.ks` odpowiada ona za przekazanie naszego pliku kickstart do instalatora. Dodajemy ją analogicznie jak na zrzucie ekranu, zaraz po argumencie `linux <path> inst.ks=<ścieżka-do-pliku-kickstart"`

Po wpisaniu ściezki do pliku kickstart naciskamy `F10` lub `CTRL+X`, instalacja rozpocznie się automatycznie. W trakcie instalacji nie jest wymagana nasza ingerencja, o ile nasz plik Kickstart jest prawidłowy. 

<img width="632" alt="Pasted Graphic 8" src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024/assets/39913427/26186bed-8681-4667-8098-c69c07bbf595">

<img width="632" alt="Pasted Graphic 13" src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024/assets/39913427/5024ed61-3ae8-4d06-ba6b-dbd6df635cf3">

<img width="654" alt="FedoraKickstart  Running" src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024/assets/39913427/c2b005e1-4cfb-4ec7-a678-a15090ba283a">


Na samym końcu instalacji pojawi sie prompt z prośbą o kliknięcie ENTER

<img width="651" alt="Pasted Graphic 40" src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024/assets/39913427/05279fe7-875b-431c-b527-d7019454b019">


6. Troubleshooting po instalacyjny   

Po instalacji systemu może dojść do sytuacji, że zobaczymy ponownie GRUB z opcjami jak gdyby system się nie zainstalował. W takiej sytuacji nie panikujemy, tylko wysuwamy w ustawieniach virtual box, dysk ISO z wirtualnego napędu

<img width="1125" alt="image" src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024/assets/39913427/748b3076-6afd-4e72-b222-74d610bb3329">

7. Sprawdzamy, czy nasze pakiety się zainstalowały

Wydając polecenie `rpm -qa` wyszukujemy na liście zainstalowanych pakietów, nazw tych które podaliśmy w pliku kickstart. W moim wypadku instalowałem jedynie `podman`

<img width="477" alt="dhcp-client-4 4 3-7 P1  fc38 x86_64" src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024/assets/39913427/96ab13c2-27d3-4141-a3f7-8c293c58e4d5">

8. Sprawdzamy czy nasz `lighttpd` działa

W moim wypadku niestety nie udało mi się zmusić kickstart do dodania serwisu który stworzyliśmy wcześniej, aby uruchamiał go automatycznie po starcie systemu. Nie mniej serwis stworzył się poprawnie i w celu ustawienia uruchamiania serwisu automatycznie wydajemy polecenie. 

`systemctl enable lighttpd-container.service`

Po wywołaniu polecenia `podman ps` widzimy iż kontener z `lighttpd` działa i jest wystawiony na porcie `80`

<img width="1016" alt="image" src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024/assets/39913427/672052fa-4662-4b46-ab13-5f3524e560fa">

Teraz sprawdzamy poleceniem `ifconfig` adres IP jaki otrzymała maszyna w moim wypadku to `192.168.68.124`

Po wejściu przez przeglądarkę na adres `http://192.168.68.124` naszym oczom ukarze się piękna czterystaczwórka, a oznacza to, że nasz kontener działa prawidłowo.

<img width="482" alt="A Niezabezpieczona  192 168 68 124" src="https://github.com/InzynieriaOprogramowaniaAGH/MDO2024/assets/39913427/b8c42368-3998-4105-8867-d85c6add93ce">

