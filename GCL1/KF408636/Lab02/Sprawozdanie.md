# Sprawozdanie 1 - konteneryzacja docker

## Wstęp, abstrakt sprawozdania

Celem ćwiczenia jest konteneryzacja wybranego programu open source w sposób zawierający:

- image (obraz) budujący repozytorium
- testy jednostkowe na podstawie zbudowanego repozytorium.

Jako przykład wybrano projekt seasocks napisany w zasadniczej części w C++. Autorem tego przedwsięwzięcia jest Matt Godbolt, człowiek odpowiedzialny za inny bardzo znany projekt: [`godbolt`](https://godbolt.org), czyli narzędzie webowe do testowania, wykonywania i analizy kodu generowanego (na poziomie assembly) przez powszechnie dostępne kompilatory np. clang, gcc, icc (wraz z możliwością wyboru wersji, bibliotek, architektur sprzętowych, opcji kompilacji, lub wyboru języka programowania).
Powracając do tematu, jest to biblioteka implementująca serwer obsługujący komunikację protokołu websocket. Repozytorium zawiera przykładowe użycie biblioteki oraz testy jednostkowe. W rozwiązaniu stosowany jest system generowania skryptów budujących oraz testujących znany jako CMake - bardzo popularny o ile nie najpowszechniejszy w przypadku C++. Testy jednostkowe realizowane są za pomocą modułu [catch2](https://github.com/catchorg/Catch2). Wybór repozytorium poparty jest ustanowioną licencją BSD oraz prostotą budowania.

## Przebieg

### Zainstalowana instancja linuxa spod dystrybucji `Fedora`, konfiguracja git i kluczy SSH

```bash
[kfilek@localhost Sprawozdanie1]$ uname -a
Linux localhost.localdomain 6.2.9-300.fc38.x86_64 #1 SMP PREEMPT_DYNAMIC Thu Mar 30 22:32:58 UTC 2023 x86_64 GNU/Linux
[kfilek@localhost Sprawozdanie1]$
```

Dostęp do maszyny odbywa się za pośrednictwem interfejsu rozszerzenia VS code.

Dostęp git przy użyciu protokołu SSH:

![images](img/1-git-ssh.png)

Dodano dwa klucze publiczne - jeden z hasłem (passphrase), drugi bez hasła:

![images](img/2-pub-keys.png)

***

### Utworzono branch w nazwie posiadającym inicjały autora oraz identyfikator studenckiego albumu:

![images](img/3-branch-log.png)

![images](img/4-branch-name.png)

***

### Utworzono skrypt githook zlokalizowany w `KF408636/Lab01/commit-msg`

Skrypt weryfikuje nazwy commitów. Przykładowo źle wprowadzana nazwa commita:

![images](img/5-git-hook-wrong.png)

Właściwe użycie skutkuje utworzeniem commita ze zmianami:

![images](img/6-git-hook-proper.png)

"Wypchnięcie" zmian do zdalnego repozytorium:

![images](img/7-git-push.png)

***

### Test zabezpieczeń gałęzi repozytorium

Sklonowano repozytorium zajęć do osobnego katalogu:

![images](img/8-branch-protection.png)

Przełączono na gałąź autora sprawozdania:

![images](img/9-checkout-branch.png)

Upewnienie się, co do commitów zawartych w branchu studenta:

![images](img/10-git-log.png)

Przełączenie się do gałęzi grupowej:

![images](img/11-switch-to-group-branch.png)

Próba zmerge'owania, zakończona pomyślnie (lokalnie):

![images](img/12-group-merge.png)

Następująca próba wypchnięcia zmian, zakończona fiaskiem. Autor repozytorium (prowadzący), zabezpieczył  branch przed niepożądanym merge'owaniem. </br>
Jedynym sposobem udzielania się w repozytorium, jest tworzenie tzw. pull-request'ów.

![images](img/13-try-push.png)

***

### Docker podstawy działania

Po zainstalowaniu dockera (za pomocą narzędzia do zarządzania pakietami dnf):

![images](img/15-docker-version.png)

Należy pamiętać by wywołać polecenie włączające serwis (daemon) dockera:

```bash
$ sudo systemctl start docker
```

By nie uruchamiać dockera za każdym razem z poziomu 
administratora (użytkownika root) zastosowano:

```bash
$ sudo groupadd docker
$ sudo usermod -aG docker $USER
```

Po czym zrestartowano system.</br>

Sprawdzenie działania najprostszego obrazu - klasycznego **hello-world**:

![images](img/14-docker-hello-world.png)

Uruchomienie interaktywne kontenera. Praca w "środku" kontenera.

![images](img/16-docker-busy-box-interactive.png)

Uruchomione procesy (wszystkie, a także te które już nie pracują). </br>
Widoczny proces busybox:

![images](img/17-docker-ps.png)

Proces PID1 w kontenerze to powłoka `sh`:

![images](img/18-print-pid.png)

Aktualizacja repozytoriów pakietów w kontenerze ubuntu:

![images](img/19-update-pkg-reps.png)

Bardzo prosty plik `KF408636/Lab01/Dockerfile`, zawierający jako bazowy obraz `ubuntu:22.04`, klonujący repozytorium zajęć. </br>
Budowa nowego obrazu odbywa się za pomocą polecenia:

![images](img/20-basic-dockerfile.png)

Obraz został otagowany (nazwany) jako `my-own-docker`. </br>
Uruchomienie interaktywne w nowo utworzonego kontenera:

![images](img/21-interactive-own-dockerfile.png)

Po opuszczeniu interaktywnej powłoki, sprawdzono uruchomione instancje kontenerów:

![images](img/22-runned-containers.png)

Usunięcie WSZYSTKICH wylistowanych kontenerów, wraz ze sprawdzeniem rezultatu polecenia. </br>
Jak widać przebiegło ono pomyślnie:

![images](img/23-remove-all-containers.png)

***

###

TODO: opis lab02
