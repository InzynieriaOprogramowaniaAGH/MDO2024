Piotr Micek
# Sprawozdanie nie jest skończone!
# Sprawozdanie 1 <br> Docker files, kontener jako definicja etapu

## Wstęp
* Celem projektu, było zbudowanie programu w konterze oraz przeprowadzenie pomyślnych testów. 
* Znalazłem program, który może być zbudowany w kontenerze, zainstalowałem zależności których wymagał a następnie przeprowadziłem pomyślnie build programu oraz testy. Następnie przetestowałem jakich zależności wymaga do powtórzenia tego w kontenerze.
* Stworzyłem dwa pliki Dockerfile, które zautomatyzowały proces tworzenia obrazów kontenerów.

## Wykonanie zadania
1. Wybór oprogramowania na zajęcia
    * Użyłem repozytorium z kodem oprogramowania ze środowiskiem Makefile oraz gotowymi testami: https://github.com/alt-romes/programmer-calculator
    * Sklonowałem to repozytorium i pobrałem wymagane programy oraz paczki systemowe. Było to gcc oraz ncurses.
    * Przeprowadziłem testy, które zakończyły się pomyślnie.
### Przeprowadzenie buildu w kontenerze
    * Uruchomiłem kontener z obrazem Fedory, ponieważ oprogramowanie, które wybrałem jest napisane w języku C++, sam też testowałem je na maszynie z Fedorą.
    * Pobrałem te same zależności, które były potrzebne do uruchomienia aplikacji na mojej Fedorze.
    * Sklonowałem repozytorium w kontenerze
    * Uruchomiłem build
    * Uruchomiłem testy. Okazało się, że testy nie kończą się sukcesem, występuje błąd z komendą diff. Należy pobrać jeszcze jedną paczkę - diffutils. Teraz testy zakończyły się sukcesem.


