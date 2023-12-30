Michał Starzyk
# Sprawozdanie 3 <br> Automatyzacja instalacji i scenariuszy poleceń
## Wstęp
   * Celem projektu było skonfigurowanie środowiska przy użyciu Ansible, nawiązanie połączenia z drugą maszyną i utworzenie pliku Kickstart. Po instalacji Ansible oraz skonfigurowaniu bezproblemowego logowania się na drugą maszynę za pomocą klucza SSH, skonfigurowałem plik YAML, który automatycznie uruchamia Docker na drugiej maszynie, a następnie startuje kontener z serwerem Nginx.
   *  Dodatkowo, w oparciu o plik konfiguracyjny anaconda-ks.cfg z już zainstalowanej maszyny, utworzyłem plik Kickstart. Ten plik Kickstart został użyty do zautomatyzowanego procesu instalacji systemu Fedora na nowej maszynie.
   *  W skrócie, w tym projekcie zajmowałem się automatyzacją konfiguracji i zarządzaniem środowiskiem przy użyciu Ansible, umożliwiając szybkie uruchamianie kontenerów Docker na drugiej maszynie oraz zautomatyzowane instalowanie systemu Fedora na nowych maszynach poprzez plik Kickstart.

## Wykonanie zadania
### Ansible
1. Instalacja zarządcy Ansible
   * Zainstalowałem Fedorę Server na drugiej maszynie 
<br> ![Fedora](Fedora.png) <br> 
   - Następnie zainstalowałem Ansible na pierwszej maszynie
 <br> ![Ansible](Ansible.png)
2. Zapewnienie łączność SSH
   * Kolejnym krokiem było utworzenie klucza SSH na nowej maszynie 
<br> ![sshkey](sshkey.png)
   * Oraz wymiana kluczy między maszynami 
<br> ![sshwym](sshwym.png)
   * Sprawdziłem i do połączenia nie są wymagane hasła
 <br> ![sshtest](sshtest.png)
3. Utworzenie pliku inventory 
   * Utworzyłem plik inwenteryzacji, w którym definiujemy nasze maszyny, wpisałem do niego ip drugiej maszyny oraz nadałem nazwę dla grupy w której będzie się znajdowło "myhosts" 
<br> ![inv]( inv.png) <br> 
<br> ![inv2]( inv2.png)
i zweryfikowałem go
 <br> ![inv3](inv3.png)
   * Następnie sprawdziłem połączenie za pomocą ansible przy użyciu ansible myhosts -m ping -i inventory.ini --user mstarzyk2
<br> ![ping](ping.png)
4. Playbook (To pliki, w których definiujemy zadania, które chcemy wykonać na zdalnej maszynie)
   * Na początek utworzyłem plik playbook o nazwie miniplay.yaml, który będzie służył do automatycznego uruchomienia kontenera na drugiej maszynie, oraz zdefiniowałem zadanie które będzie wykonywać.
 <br> ![miniplay]( miniplay.png)
<br> ![miniplay1]( miniplay1.png)
   * Następnie użyłem playbook, zgodnie z zadaniem, poprzez komendę ansible-playbook -i inventory.ini miniplay.yaml --user mstarzyk2 --ask-become-pass
<br> ![playbook]( playbook.png)

  ### Kickstart (narzędzie pozwalające na automatyczną instalacje systemu operacyjnego)
1.	Na drugiej maszynie znalazłem plik anaconda-ks.cfg, za pomocą komendy, sudo cat /root/anaconda-ks.cfg, zawiera on opcje, które wybierałem podczas instalacji. Posłuży jako baza do pliku kickstar
 <br> ![Anaconda](Anaconda.png)
<br> ![Anaconda1](Anaconda1.png)
   * Przez komendę rpm -qa wyświetliłem pakiety zainstalowane na głownej maszynie i dodałem do pliku kickstart ansible oraz docker.
<br> ![rpm](rpm.png)
   *Następnie dodałem do pliku repozytoria online 
     * url --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-38&arch=x86_64
     * repo --name=updates --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f38&arch=x86_64
   * zmieniłem clearpart na opcję -all co sprawi, że dysk zawsze będzie formatowany.
   * zamieniłem hasło na abc0, które będzie można edytować po instalacji systemu.
   * Ostateczna wersja pliku kickstart wygląda tak:
 <br> ![kickstart](kickstart.png)
   * Po ukończeniu tworzenia pliku kick start mogłem użyć go do zautomatyzowanej instalacji nowego systemu, więc na maszynie wirtualnej zainstalowałem dysk z Ferdorą oraz zrestartowałem maszynę, następnie po załadowaniu kliknąłem na klawiaturze e co mnie przeniosło do edycji GRUB tam dodałem komendę inst.ks=https://raw.githubusercontent.com/InzynieriaOprogramowaniaAGH/MDO2024/MS409229/MS409229/config.cfg do podstawowych komend instalatora, oraz uruchomiłem instalację przez ctrl+x.
<br> ![kickstart2](kickstart2.png)
   * Instalator sam uzupełnił wszystkie opcje zgodnie z moim plikiem kickstart i nie wymaga żadnej interakcji od użytkownika.
 <br> ![fed](fed.png)
<br> ![fed2](fed2.png)
* Z usprawnień wybrałem dodanie do pliku odpowiedzi instalacji i uruchomienia kontenera lighttpd. Więc po przerobieniu pliku kickstart wygląda on ostatecznie tak.
<br> ![light](light.png)

