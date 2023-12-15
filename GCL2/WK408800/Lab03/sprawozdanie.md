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


6. 
