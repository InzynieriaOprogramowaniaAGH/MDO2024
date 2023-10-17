# Spotkanie 1

## Wprowadzenie, Git, SSH, Hooks
### Przygotowanie środowiska
1. Wykaż możliwość komunikacji ze środowiskiem linuksowym (powłoka oraz przesyłanie plików)
    * zapewnij dostęp do maszyny wirtualnej przez zdalny terminal (nie "przez okienko")
    * jeżeli nie jest stosowane VM (np. WSL, Mac, natywny linux), wykaż ten fakt **dokładnie**

### Ćwiczenia do wykonania
1. Zainstaluj klienta Git i obsługę kluczy SSH
2. Sklonuj repozytorium https://github.com/InzynieriaOprogramowaniaAGH/MDO2024 , najpierw za pomocą HTTPS
3. Upewnij się w kwestii dostępu do repozytorium jako uczestnik i sklonuj je za pomocą utworzonego klucza SSH
   - Utwórz dwa klucze SSH, inne niż RSA, w tym co najmniej jeden zabezpieczony hasłem
   - Skonfiguruj klucz SSH jako metodę dostępu do GitHuba
   - Sklonuj repozytorium z wykorzystaniem protokołu SSH
4. Przełącz się na gałąź ```main```, a potem na gałąź swojej grupy , np. GCL1 (pilnuj gałęzi i katalogu!)
5. Utwórz gałąź o nazwie "inicjały & nr indeksu" np. ```KD232144```. Miej na uwadze, że odgałęziasz się od brancha grupy!
6. Rozpocznij pracę na nowej gałęzi
   - W katalogu właściwym dla grupy utwórz nowy katalog, także o nazwie "inicjały & nr indeksu" np. ```KD232144```
   - Napisz Git hook'a - skrypt weryfikujący, że każdy Twój "commit message" zaczyna się od "twoje inicjały & nr indexu". (Przykładowe githook'i są w `.git/hooks`.)
   - Dodaj ten skrypt do stworzonego wcześniej katalogu.
   - Skopiuj go we właściwe miejsce, tak by uruchamiał się za każdym razem kiedy robisz commita.
   - Umieść treść githooka w podkatalogu Lab01.
   - W katalogu dodaj plik ze README.md opisujący zastosowanie katalogu
   - Wyślij zmiany do zdalnego źródła
7. Branch protections: Spróbuj wciągnąć swoją gałąź do gałęzi grupowej
   - Sklonuj się do nowego katalogu obok
   - Przełącz się na swoją gałąź aby ją odświeżyć (czy jest taka potrzeba?)
   - Przełącz się na gałąź GCL i zmerdżuj do niej swoją
   - Spróbuj wypchnąć tak zmodyfikowaną gałąź GCL do zdalnego źródła

## Instalacja Dockera
### Przygotowanie do sprawozdania
* Proszę robić zrzuty ekranu ukazujące wykonane polecenia i ich efekty (optymalnie: proszę także przechowywać historię wykonanych poleceń lub wyjścia terminala)
* Zbiór zachowanych zrzutów i poleceń powinien być wystarczający, by przy stosownym opisie stanowić materiał umożliwiający odtworzenie wykonanych kroków
* Zapisane zrzuty ekranu, polecenia i opisy będą potrzebne w Sprawozdaniu 1, do oddania po drugich zajęciach, gdzie dokończymy wykorzystanie Dockera

### Ćwiczenia do wykonania
1. Zainstaluj Docker w systemie linuksowym
2. Zarejestruj się w Docker Hub i zapoznaj z sugerowanymi obrazami
3. Pobierz hello-world, busybox, ubuntu lub fedorę, mysql
4. Uruchom busybox
   - Pokaż efekt uruchomienia kontenera
   - Podłącz się do kontenera interaktywnie i wywołaj numer wersji
5. Uruchom "system w kontenerze"
   - Zaprezentuj PID1 w kontenerze i procesy dockera na hoście
   - Zaktualizuj pakiety
   - Wyjdź
6. Stwórz własnoręcznie, zbuduj i uruchom prosty plik Dockerfile bazujący na wybranym systemie i sklonuj nasze repo. 
    - Kieruj się dobrymi praktykami: https://docs.docker.com/develop/develop-images/dockerfile_best-practices/
    - Upewnij się że obraz będzie miał git'a
    - Uruchom w trybie interaktywnym i zweryfikuj że jest tam ściągnięte nasze repozytorium
7. Pokaż uruchomione ( != "działające" ) _kontenery_, wyczyść je.
8. Wyczyść _obrazy_
9. Dodaj stworzone pliki Dockefile do folderu swojego katalogu Lab01 w repo.

## Główny wątek następnych zajęć
### Wybór oprogramowania na zajęcia
* Znajdź repozytorium z kodem dowolnego oprogramowania, które:
	* dysponuje otwartą licencją
	* jest umieszczone wraz ze swoimi narzędziami *Makefile* tak, aby możliwe był uruchomienie w repozytorium czegoś na kształt ```make build``` oraz ```make test```. Środowisko Makefile jest dowolne. Może to być `automake`, `meson`, `npm`, `maven`, `nuget`, `dotnet`, `msbuild`...
	* Zawiera zdefiniowane i obecne w repozytorium **testy**, które można uruchomić np. jako jeden z "targetów" Makefile'a. Testy muszą jednoznacznie formułować swój raport końcowy (gdy są obecne, zazwyczaj taka jest praktyka)
* Spróbuj zbudować wybrany program
