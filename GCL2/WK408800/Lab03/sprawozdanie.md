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

Jak widzimy powyżej wszystko działa
