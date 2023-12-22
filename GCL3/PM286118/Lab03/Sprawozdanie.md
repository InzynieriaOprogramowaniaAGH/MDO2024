Piotr Micek
# Sprawozdanie 2 <br> Automatyzacja instalacji i scenariuszy poleceń

## Wstęp
* Celem projektu, było zainstalowanie Ansible i połączenie się z drugą maszyną oraz stworzenie pliku kickstart.
* Zainstalowałem Ansible, pobrałem klucz ssh z drugiej maszyny i mogłem logować się bez potrzeby wpisywania hasła. Za pomocą pliku konfiguracyjnego *.yaml automatycznie uruchomiłem dockera na drugiej maszynie i wystartowałem kontener z nginx.
* Na podstawie pliku anaconda-ks.cfg z zainstalowanej maszyny stworzyłem plik kickstart, którego użyłem do zautomatyzowanego zainstalowania się Fedory na nowej maszynie.

## Wykonanie zadania
### Ansible
1. Instalacja zarządcy Ansible
   * Zainstalowałem Fedorę z minimalistyczną liczbą pakietów na drugiej maszynie <br> ![fedora1](screen/instfedora.png) <br> Zawiera tylko 657 pakietów a instalator pobiera 578MB <br> ![fedora2](screen/instfedora2.png)
   * Zainstalowałem Ansible na pierwszej maszynie <br> ![ansinstal](screen/ansinstal.png)
2. Zapewnienie łączność SSH
   * Utworzyłem klucz SSH na nowej maszynie <br> ![ssh](screen/ssh.png)
   * Dokonałem wymiany kluczy między maszynami <br> ![sshcopy](screen/sshcopy.png)
   * Teraz do połączenia nie są wymagane hasła <br> ![bezhasla](screen/bezhasla.png)
3. Inwentaryzacja systemów
   * Utworzyłem plik inwenteryzacji do którego wpisałem ip drugiej maszyny oraz nadałem nazwę dla grupy w której będzie się znajdowao "myhosts" <br> ![inv](screen/inv.png) <br> i zweryfikowałem go <br> ![inv2](screen/inv2.png)
   * Zweryfikowałem łączność za pomocą ansible -m ping <br> ![ansping](screen/ansping.png)
4. Zadanie
   * Utworzyłem plik playbook o nazwie miniplay.yaml który posłuży do automatycznego uruchomienia kontenera na drugiej maszynie <br> ![miniplay](screen/miniplay.png)
   * Użyłem playboook żeby automatycznie uruchomić nginx na drugiej maszynie co zakończyło się sukcesem <br> ![playbook](screen/ansplaybook.png)

   
### Kickstart
1. Wykorzystałem plik odpowiedzi do stworzenia kickstart
   * Po zainstalowaniu drugiej maszyny znalazłem plik anaconda-ks.cfg, który zawierał opcje, które wybierałem podczas instalacji. Ten plik posłuży jako baza do pliku kickstar <br> ![anaconda](screen/anaconda.png)
   * Komenda rpm -qa wyświetla mnóstow plików, więc skupiłem się na kilku np. ansible albo docker i dodałem je do pakietów w pliku kickstart.
   * dodałem do pliku repozytoria online 
     * url --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-38&arch=x86_64
     * repo --name=updates --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f38&arch=x86_64
   * zmiana clearpart na opcję -all sprawi, że dysk zawsze będzie formatowany.
   * wpisałem proste hasło za pomocą zwykłego tekstu, które będzie można edytować po instalacji systemu.
   * Na końcu dodałem komendę reboot aby system po instalacji zresetował się.
   * Po zmianach plik kickstart wygląda tak: <br> ![kickstart](<screen/kickstart.png>)
   * Teraz mogę użyć go do zautomatyzowanej instalacji nowego systemu dodając komendę inst.ks="link do kickstart" do podstawowych komend instalatora. Wyjątkowo wykorzystałem, stronę pastebin, gdyż oferuje krótsze linki, które łatwiej wpisać w instalator. <br> ![kickstart2](screen/kickstart2.png)
   * Dzięki temu instalator sam uzupełnia wszystkie opcje zgodnie z tym jak uzupełniłem je wcześniej i nie wymaga żadnej interakcji od użytkownika. <br> ![fedorainst](screen/fedorainst.png)

