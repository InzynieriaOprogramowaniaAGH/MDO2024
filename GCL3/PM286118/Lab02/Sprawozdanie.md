Piotr Micek
# Sprawozdanie 1 <br> Docker files, kontener jako definicja etapu

## Wstęp
* Celem projektu, było zbudowanie programu w konterze oraz przeprowadzenie pomyślnych testów. 
* Znalazłem program, który może być zbudowany w kontenerze, zainstalowałem zależności których wymagał a następnie przeprowadziłem pomyślnie build programu oraz testy. Następnie przetestowałem jakich zależności wymaga do powtórzenia tego w kontenerze.
* Stworzyłem dwa pliki Dockerfile, które zautomatyzowały proces tworzenia obrazów kontenerów.

## Wykonanie zadania
### Wybór oprogramowania na zajęcia
* Użyłem repozytorium z kodem oprogramowania ze środowiskiem Makefile oraz gotowymi testami. https://github.com/alt-romes/programmer-calculator <br> Sklonowałem je na mój dysk <br> ![git clone](screen/git_clone.png)
* Pobrałem wymagane programy oraz paczki systemowe zgodnie z plikiem README. Było to gcc oraz ncurses, które należy pobrać w wersji devel. <br> ![pobranie paczek](screen/pobranie_paczek.png) <br> Następnie zbudowałem program. <br> ![build](screen/build.png) 
* Przeprowadziłem testy, które zakończyły się pomyślnie. <br> ![testy](screen/testy.png)
  
### Przeprowadzenie buildu w kontenerze
1. Przeprowadziłem build i test wewnątrz kontenera
   * Uruchomiłem kontener z obrazem Fedory, ponieważ oprogramowanie, które wybrałem jest napisane w języku C++, sam też testowałem je na maszynie z Fedorą. <br> ![kontener interaktywny](screen/kontener_interaktywny.png)
   * Pobrałem te same zależności, które były wcześniej potrzebne do uruchomienia aplikacji na mojej Fedorze, wraz z git, którego użyję do pobrania repozytorium <br> ![kontener paczki](screen/kontener_paczki.png)
   * Sklonowałem repozytorium w kontenerze <br> ![kontener git](screen/kontener_git.png)
   * Uruchomiłem build <br> ![kontener build](screen/kontener_build.png)
   * Uruchomiłem testy. <br> ![test failed](screen/k_test_failed.png) <br> Okazało się, że testy nie kończą się sukcesem, występuje błąd z komendą diff. Należy pobrać jeszcze jedną paczkę - diffutils. <br> ![dodatkowe paczki](screen/k_dodatkowe_paczki.png) <br> Teraz testy zakończyły się sukcesem. <br> ![testy](screen/k_testy.png)
2. Stworzyłem dwa pliki Dockerfile automatyzujące kroki
    * W pierwszym pliku wprowadziłem kroki prowadzące do zbudowania kontenera, obraz Fedory który należy otworzyć, pobranie wymaganych zależności wynikających z doświadczeń z interaktywnym kontenerem uwzględnionych powyżej oraz zbudowanie programu. <br> ![dockerfile1](screen/dockerfile1.png)
    * W drugim pliku wprowadziłem kroki odpowiedzialne za przeprowadzenie testów na podstawie poprzednio utworzonegoo obrazu <br> ![dockerfile2](screen/dockerfile2.png)
3. Wykazałem, że kontenery wdrażają się prawidłowo
   * Stworzyłem obraz kontenera za pomocą pierwszego pliku Dockerfile <br> ![docker1](screen/docker1.png) <br> po jego zainiconowaniu obraz calcbuild znajduje się na liście <br> ![docker image](screen/docker_image.png)
   * Nastepnie stworzylem kolejny obraz za pomocą drugiego pliku dockerfile, który przeprowadził pomyślnie testy <br> ![docker2](screen/docker2.png) <br> który również trafił na listę stworzonych obrazów. ![docker image 2](screen/docker_image2.png)
