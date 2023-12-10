Michał Starzyk
# Sprawozdanie 2 <br> Docker files, kontener jako definicja etapu

## Cel projektu
* Celem projektu, było zbudowanie programu w kontenerach, a następnie sprawdzenie poprawności testów. 

## Wykonanie zadania
### Wybór oprogramowania
* Użyłem repozytorium kompilujące się przez „npm” oraz gotowymi testam, a następnie sklonowałem je na mój dysk. https://github.com/actionsdemos/calculator.git
<br> ![clone](clone.png)
* Następnie zgodnie z plikiem README zainstalowałem i zbudowałem program poprzez npm.
<br> ![build](build.png)
<br> ![build2](build2.png)
<br> ![build3](build3.png)
*  Na koniec przeprowadziłem testy, które zakończyły się pomyślnie.
<br> ![test](test.png)
<br> ![test2](test2.png)
### Build w kontenerze
1. Na początek zrobiłem build i test wewnątrz kontenera
   * Stworzyłem kontener z obrazem Fedory, ponieważ sam też testowałem je na maszynie z Fedorą.
  <br> ![kontener](kontener.png)
   * Pobrałem Gita, który był potrzebny do sklonowania aplikacji na mojej Fedorze oraz sklonowałem repozytorium, a następnie pobrałem nodejs do uruchomienia npm.
  <br> ![kontener_clone](kontener_clone.png)
<br> ![kontener_clone2](kontener_clone2.png)
   * Uruchomiłem npm install
  <br> ![kontener_build](kontener_build.png)
<br> ![kontener_build2](kontener_build2.png)
   * Kolejnym krokiem było uruchomienie testów, które przeszły pomyślnie.
<br> ![kontener_test](kontener_test.png)
<br> ![kontener_test2](kontener_test2.png)
2. Stworzenie dwóch plików Dockerfile automatyzujących kroki
    * Pierwszy plik był builderem dla mojej aplikacji, poprzez pobranie najnowszego noda następnie sklonowanie repozytorium oraz zbudowanie go przez npm install.
  <br> ![dockerfile1](dockerfile1.png)
    * Natomiast drugi plik służył do testów mojego programu poprzez użycie npm test.
      <br> ![dockerfile2](test2.png)
      <br> ![dockerfilevi](test2.png)
      <br> ![dockerfilels](test2.png)
3. Pokazanie, że kontenery działają prawidłowo
   * Stworzyłem obraz kontenera za pomocą pierwszego pliku Dockerfile calculatorbld
     <br> ![docker1](docker1.png)
   * Nastepnie stworzylem kolejny obraz za pomocą drugiego pliku dockerfile calculatortest, który przeprowadził pomyślnie testy
  <br> ![docker2](docker2.png)
<br> ![docker3](docker3.png)
   * Po ich zainiconowaniu obraz calculatorbld oraz calculatortest znajdują się na liście 
<br> ![images](images.png)

