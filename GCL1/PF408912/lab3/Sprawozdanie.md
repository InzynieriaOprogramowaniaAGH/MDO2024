# Sprawozadnie Lab2

## Cel ćwiczenia:
Celem ćwiczenia było zapoznanie się z narzędziami do automatyzacji instalacji maszyn oraz zarządzania nimi zdalnie.

## Wykorzystywane narzędzia:
- Hyper-V -> do wirtualizacji maszyny OpenSuse w wersji 15.5, na której wykonwyana była całość zadania,
- Git -> do pracy na repozytoriach z Github, domyślnie zainstalowany na wersji OpenSuse 15.5 oraz zainstalowany na Alpine 16,
- Docker -> do konteneryzacji,
- SSH -> do komunikacji między maszynami, hostem i repozytorium,
- Ansible -> proces instalacji dalej w sprawozdaniu,
- Ngnix -> proces instalacji dalej w sprawozdaniu,
- Visual Studio Code -> do pracy nad sprawozdaniem,

## Wykorzytsywane maszyny:
W związku z pracą na dytstrybucji OpenSuse w poprzednich ćwiczeniach również tutaj wykorzystuje maszynę OpenSuse, na niej
będę instalował ansible, druga maszyna zgodnie z instrukcją jest to Fedora.

## Komunikajca między maszynami:
Dla wygody pracy w komuniakcji między maszynami zamiast IP wykorzystuję prostą budowę DNS:
- Na hoście dla maszyn wirtualnych edytuje plik hosts Windows z użyciem narzędzia PowerToys,
![Alt text](screenshot3.png)
- Na maszynach wirtualnych dodałem odpowiedni wpis w pliku /etc/hosts,
na rzucie poniżej budowa pliku hosts dla maszyny devops-opensuse, podajemy tu ip maszyny devops-fedora i jej nazwę.
Dla drugiej maszyny zrobimy to samo, ale wpiszemy ip maszyny devops-opensuse i jej nazwę.
![Alt text](screenshot4.png)

## Klucze SSH między maszynami:
Dzięki odpowiedniej konfiguracji kluczy ssh na maszynach możemy łączyć się z jednej do drugiej bez podawania hasła,
co umożliwa konfigurowanie narzędzi do autmoatyzacji zarządzania zdalnego.
W naszym wypadku wystarczyło by wykonanie klucza dla relacji devops-opensuse(ansible) -> fedora(agent),
jednak skonfigurowałem ruch w obie strony przez klucze.
Wymiana kluczy jest możliwa przy użyciu komendy:
```bash
ssh-copy-id
```
W moim wypadku konfigurację wykonałem ręcznie:
Całość działań wykonywałem na obu maszyanch w folderze /root/.ssh.
Wygenerowałem klucze na obu maszynach komendą:
```bash
ssh-keygen -t rsa
```
Nie wykorzystałem domyślnej nazwy na klucz i na obu maszynach nazwałem go ansible,
dla przykładu klucz publiczny z maszyny devops-fedora:
![Alt text](screenshot5.png)
W praktyce takie rozwiązanie jest utrudnieniem w konfiguracji, gdyż potem musimy wskazać ten konkretny klucz w połączeniu
z tą konkretną maszyną, pozwala nam to jednak mocniej kontrolować sposób łączenia się z naszą maszyną,
przykład wskazania klucza do łączności z maszyną w pliku /root/.ssh/config:
![Alt text](screenshot6.png)

Kiedy już mamy gotowe klucze musimy je "wymienić" między maszynami.
Ja dodam wyegnerowane klucze do plików authorized_keys:
Klucz maszyny z devops-fedora do pliku authorized_keys na maszynie devops-opensuse i na odwrót.
Screen z pliku /root/.ssh/authorized_keys na maszynie open-suse:
![Alt text](screenshot7.png)

Po tych czynnościach komunikacja między naszymi maszynami powinna się odbywać po ssh z użyciem wygenerowanych kluczy:
![Alt text](screenshot8.png)

## Ansible

## Kickstarter
Instalacja maszyn, które w sposób zautomatyzowany już są odpowiedno skonfigurowane i mają zainstalowane odpowiednie narzędzia
jest koniecznością, jeśli nie chcemy wykonywać odtwórczej pracy.
Dla Windows popularne narzędzia do takiej instalacji to WDS/MDT czy SSCM.
Podobnie różne narzędzia umożliwiają nam to na dystrybucjach linux.

W wypadku Fedory po instalacji na maszynie znajduje się plik:
anaconda-ks.cfg

Plik ten po odpowiedniej modyfikacji może nam posłużyć do przygotowania instalacji zawierającej wybrane przez nas dodatkowe komponenty.
Skopiowałem plik nadając mu nazwę anaconda-ext.cfg (plik w całości dostępny na repozytorium)i dodałem: 
- wskazane repozytorium:
```bash
#repo
url --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-38&arch=x86_64
repo --name=updates --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f38&arch=x86_64
```
- sekcję odpowiedzialną za instalację odpowiednich pakietów:
```bash
#packages
%packages
python3
docker
ansible
%end
```
- sekcje post install, która ma uruchomić usługę docker oraz uruchomić wybrany kontener:
```bash
#post
%post
systemctl start docker
systemctl enable docker
docker run -d -p 80:80 --name autolighttpd jitesoft/lighttpd
%end
```
Przygotowany plik wrzuciłem na repozytorium, skąd będę go później linkował w instalacji z użyciem raw linka.
Na nowo utworzonej maszynie w Hyper-V dodaje ISO Fedory i ustawiam jako pierwsze do bootowania.
Dalsza część instalacji na cele sprawozdania zostanie wykonana z użyciem grafinczego interfejsu instalacji
(w ten sposób można łatwo pokazać, że maszyna na etapie instalcji/postistalacji ma już skonfigurowane rzeczy, które domyślnie nie są skonfigurowane, samo zadanie wcześniej zostało wykonane bez ui i quiet czyli bez potrzeby jakichkolwiek działań po stronie użytkownika)
Kiedy mamy okno z instalacją Fedory zmieniamy komendy instalacji tak, by wykorzytsywał nasz plik.
Wskazujemy mu w ten sposób plik sieciowy, kóry podaje mu informację odnośnie instalacji, jest to bardzo podobne do Microsoft
WDS, gdzie komputer również otrzymuje plik odnośnie instalacji, ale z wybranego serwera z usługą WDS.
Jest to możliwe na maszynach dzięki PXE -środowsiku, które pozwala na uruchomienie systemu na danym urządzeniu, mimo, że nie jest ono zainstalowane na nim.
![Alt text](screenshot9.png)
W wypadku Hyper-V, żeby podany przykład użycia pliku odpowiedzi działał koniecznie jest stworzenie maszyny 2 generacji z właczonym secure boot:
![Alt text](screenshot10.png)

Zgodnie z wcześniejszym komentarzem możemy zobaczyć okno podsumowujące naszą instalację, w stosunku do standardowego okna
instalatora fedory w tym miejscu widzimy, że wszystko jest skonfigurowane:
![Alt text](screenshot11.png)

Po uruchomieniu maszyny możemy sprawdzić, że znajduje się na niej m.in docker i ansible, a także nasz kontener
![Alt text](screenshot12.png)

