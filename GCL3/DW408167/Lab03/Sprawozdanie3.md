# Automatyzacja instalacji - Ansible

> ## Syllabus
>
> - Instalacja Ansible
> - Łączenie maszyn bez hasła 
> - Konfiguracja pliku inventory
> - Instalacja pakietów na zdalnej maszynie

**Spis treści**

<!-- TOC -->
* [Automatyzacja instalacji - Ansible](#automatyzacja-instalacji---ansible)
  * [Przygotowanie maszyn](#przygotowanie-maszyn)
  * [Konfiguracja połączenia pomiędzy maszynami](#konfiguracja-połączenia-pomiędzy-maszynami-)
    * [1. Zaczynamy od wygenerowania klucza SSH na maszynie `fedora`:](#1-zaczynamy-od-wygenerowania-klucza-ssh-na-maszynie-fedora)
    * [2. Klucz przesyłamy na drugą maszynę korzystając z komendy:](#2-klucz-przesyłamy-na-drugą-maszynę-korzystając-z-komendy)
    * [3. Testujemy połączenie z maszyną](#3-testujemy-połączenie-z-maszyną)
  * [Instalacja Ansible](#instalacja-ansible)
    * [Tworzenie pliku inventory](#tworzenie-pliku-inventory)
    * [Sprawdzamy połączenie Ansible](#sprawdzamy-połączenie-ansible)
<!-- TOC -->

## Przygotowanie maszyn

Na początku tworzymy nową pustą maszynę wirtualną, z którą będziemy się łączyć.
Przechodzimy przez standardowy proces instalacji, pamiętajmy o zmianie nazwy hosta.

W moim przypadku maszyna główna nazywa się `fedora` natomiast klient `fedora2`.

Natomiast użytkownicy to `dawid` dla `fedora` oraz `dawid2` dla `fedora2`. 

Aby móc korzystać z nazw maszyn zamiast adresów IP, musimy dodać je do pliku `/etc/hosts`, format jest następujący:

```sh
<adres IP> <nazwa hosta>
```

W naszym przypadku będzie to:

```sh
192.168.66.2 fedora2
```

- Adresy IP możemy sprawdzić za pomocą polecenia `ip a`.
- Edytuj plik `/etc/hosts` za pomocą `sudo nano /etc/hosts`.

> Pamiętaj, że adresy są dynamiczne (jeśli nie skonfigurowałeś inaczej) więc mogą po pewnym czasie się zmienić.


## Konfiguracja połączenia pomiędzy maszynami 

W tym celu skorzystamy z komendy **ssh-copy-id**, która automatycznie skonfiguruje połączenie pomiędzy naszymi maszynami, pozwoli nam to na nieużywanie hasła w przyszłości.

> Jest to istotne, ponieważ kiedy zaczniemy korzystać z Ansible, nie będziemy musieli podawać ręcznie hasła przy każdym połączeniu.

### 1. Zaczynamy od wygenerowania klucza SSH na maszynie `fedora`:

```sh
ssh-keygen
```

Powyższa komenda wygeneruje nam parę kluczy - prywatny oraz publiczny (ten z końcówką `.pub`).
Klucz domyślnie będzie w folderze `~/.ssh/` i będzie nazywał się `id_rsa` (metoda szyfrowania RSA)


### 2. Klucz przesyłamy na drugą maszynę korzystając z komendy:

```sh
ssh-copy-id -i id_rsa.pub dawid2@fedora2
```

> Flagą `-i` podajemy ścieżkę do klucza. Ja mogłem użyć tylko `-i id_rsa.pub` ponieważ znajdowałem się w folderze `~/.ssh/` gdzie znajdował się klucz.

Format komendy do skopiowania

```sh
ssh-copy-id -i ~/.ssh/NAZWA_KLUCZA.pub REMOTE_USER@REMOTE_IP
```

Nasz rezultat jest następujący.

![ssh-copy-id](ssh-copy-id.png)

### 3. Testujemy połączenie z maszyną

```sh
ssh dawid2@fedora2
```

Jak widać na screenie, udało nam się wejść na zdalną maszynę bez podawania hasła.

![ssh-fedora-2](ssh-fedora2.png)


## Instalacja Ansible

W tym celu używamy komendy:

```sh
sudo dnf install ansible
```

Tworzymy sobie folder `ansible` w `~`, w którym będziemy przechowywać nasze pliki konfiguracyjne.

```sh
mkdir ansible
```

### Tworzenie pliku inventory

Plik inventory to plik, w którym definiujemy nasze maszyny, na których będziemy wykonywać polecenia.

```sh
touch inventory.ini
nano inventory.ini
```

- Wewnątrz zaczynamy od zdefiniowania grupy hostów, w naszym przypadku będzie to `myhosts`.
- Poniżej tej grupy definiujemy hosty, które do niej należą. Wypisujemy je po jednym w linii, możemy skorzystać z adresu IP lub nazwy hosta.



```ini
[myhosts]
fedora2
```

### Sprawdzamy połączenie Ansible

W tym celu skorzystamy z narzędzie `ping`, wbudowanego w ansible, które sprawdzi czy wszystkie hosty zdefiniowane w pliku inventory są dostępne.

```sh
ansible myhosts -m ping -i inventory.ini --user dawid2
```

- `myhosts` - nazwa grupy hostów
- `-m ping` - moduł, który chcemy wykonać
- `-i inventory.ini` - plik inventory
- `--user dawid2` - użytkownik, którym chcemy się zalogować na zdalną maszynę, jeśli jest taki sam jak lokalnie, możemy pominąć tą flagę.

Taki rezultat powinniśmy otrzymać:

![ansible-ping](ansible-ping.png)

