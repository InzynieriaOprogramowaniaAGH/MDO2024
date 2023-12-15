Sprawozdanie 2

Spis treści:

1. Wstęp
1. Zbudowanie i test w kontenerze bazowym:
   2.1. Załadowanie kontenera fedora
   2.2. Pobranie wszelkich zależności do kontenera
   2.3. Zbudowanie programu
   2.4. Test kompilacji zbudowanego programu
1. Automatyzacja budowania i testu w obrazie:
   3.1. Utworzenie pliku budującego Dockerfile-build
   3.2. Utworzenie pliku testującego Dockerfile-test
   3.3. Przeprowadzenie budowania i testów
1. Porównanie wyników operacji w kontenerze bazowym i obrazie


1. Wstęp

Do ćwiczeń wykorzystam program flameshot, który posiada licencję open-source i jest oparty na C++. Jako środowisko bazowe wykorzystam kontener fedora zgodnie z zaleceniami. Moim celem jest przeprowadzenie poprawnego zbudowania i testy kompilacji wybranego przeze mnie programu przy użyciu dockera, automatyzacja budowania programu poprzez stworzenie pliku budulcowego Dockerfile oraz porównanie szybkości całego procesu w środowisku obrazowym i kontenerowym.

Do poprawnego działania, wybrany program wymaga następujących zależności:
`	`- Qt >= 5.9
`	`- GCC >= 7.4
`	`- Cmake >= 3.13
`	`- GIT
`	`- OpenSSL

1. Zbudowanie i test w kontenerze bazowym:
   2.1. Załadowanie kontenera fedora:
   sudo docker run --interactive --tty fedora bash



2\.2. Pobranie wszelkich zależności do kontenera:
Każdy pogram do poprawnego działania potrzebuje odpowiednich składników, które muszą być obecne w systemie podczas działania programu. Jeśli nie są, należy je doinstalować.


2\.3. Zbudowanie programu
Pobranie repozytorium git flameshot do zasobów lokalnych kontenera:



Build:
poprawne zbudowanie programu należy przeprowadzić ze sklonowanego repozytorium obecnego lokalnie już w systemie, zatem należy przejść do folderu programu.
Używany przeze mnie program do swojej kompilacji używa buildera make oraz funkcji build.



2\.4. Test kompilacji zbudowanego programu.

Aby przetestować program, używam skryptów testujących „action\_options.sh” oraz „path\_options.sh” dostarczonych razem z repozytorium githuba.

1. Automatyzacja budowania i testu w obrazie.
   Tworzę plik dockerfile, oraz kontener, który będzie z niego korzystał i określam jakie zależności startowe ma on posiadać.
   Zawartość pliku Dockerfile-flameshot-dep

   Budowanie kontenera zawierającego zależności startowe „flameshot-dep01”:

Następnie tworzę kontener budujący program (flameshot-bld), który za pomocą pliku Dockerfile-flameshot-bld pobiera zawartość kontenera flameshot-dep01 i buduje program przy pomocy określonych w pliku dockerfile komend.

Aby przetestować program tworzę kontener testujący (flameshot-test) pobierający zależności, konfigurację oraz build z kontenera flameshot-bld. Plik dockerfile zawierający intrukcje, jakich skryptów testujących używać. Określam obszar roboczy poprzez specyfikację ścieżki do folderu programu, a później określam komendy, którymi testuję program.



1. Porównanie wyników operacji w kontenerze bazowym i obrazie





Historia użytych poleceń terminala:



