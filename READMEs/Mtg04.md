# Spotkanie 4
---
## Pipeline, Jenkins, izolacja etapów

### Przygotowanie
* Upewnij się, że na pewno działają kontenery budujące i testujące, stworzone na poprzednich zajęciach
* Zapoznaj się z instrukcją instalacji Jenkinsa: https://www.jenkins.io/doc/book/installing/docker/
  * Uruchom obraz Dockera który eksponuje środowisko zagnieżdżone
  * Przygotuj obraz blueocean na podstawie obrazu Jenkinsa (czym się różnią?)
  * Uruchom Blueocean
  * Zaloguj się i skonfiguruj Jenkins
  * Zadbaj o archiwizację i zabezpieczenie logów
  
### Uruchomienie 
* Konfiguracja wstępna i pierwsze uruchomienie
  * Utwórz projekt, który wyświetla uname
  * Utwórz projekt, który zwraca błąd, gdy... godzina jest nieparzysta
* Utwórz "prawdziwy" projekt, który:
  * klonuje nasze repozytorium
  * przechodzi na osobistą gałąź
  * buduje obrazy z dockerfiles i/lub komponuje via docker-compose
  
## Zadanie do wykonania: Jenkins

| :point_up:    | *Zainstaluj skonteneryzowanego Jenkinsa i wykonaj w nim polecenia rekonesansowe shell (`whoami`, `ls`)* |
|---------------|:------------------------|

## Zadanie do wykonania: Jenkins

| :point_up:    | *Uruchom polecenia `uname` i `whoami` w kontenerze pracującym wewnątrz skonteneryzowanego Jenkinsa * |
|---------------|:------------------------|

## Zadanie do wykonania: Jenkins

| :point_up:    | *Sklonuj repozytorium projektowe za pomocą narzędzia pipeline w Jenkinsie* |
|---------------|:------------------------|

### Sprawozdanie (wstęp)
* Opracuj dokument z diagramami UML, opisującymi proces CI. Opisz:
  * Wymagania wstępne środowiska
  * Diagram aktywności, pokazujący kolejne etapy (*collect*, *build*, *test*, *report*)
  * Diagram wdrożeniowy, opisujący relacje między składnikami, zasobami i artefaktami
* Diagram będzie naszym wzrocem do porównania w przyszłości
  
### Pipeline
* Definiuj pipeline korzystający z kontenerów celem realizacji kroków `build -> test`
* Może, ale nie musi, budować się na dedykowanym DIND, ale może się to dziać od razu na kontenerze CI. Należy udokumentować funkcjonalną różnicę między niniejszymi podejściami
* Docelowo, `Jenkinsfile` definiujący *pipeline* powinien być umieszczony w repozytorium. Optymalnie: w *sforkowanym* repozytorium wybranego oprogramowania

### Szczegóły
Ciąg dalszy sprawozdania
#### Wymagane składniki
*  Kontener Jenkins i DIND skonfigurowany według instrukcji dostawcy oprogramowania
*  Pliki `Dockerfile` wdrażające instancję Jenkinsa załączone w repozytorium przedmiotowym pod ścieżką i na gałęzi według opisu z poleceń README
*  Zdefiniowany wewnątrz Jenkinsa obiekt projektowy „pipeline”, realizujący następujące kroki:
  * Kontener `Builder`, który powinien bazować na obrazie zawierającym dependencje (`Dependencies`), o ile stworzenie takiego kontenera miało uzasadnienie. Obrazem tym może być np. baza pobrana z Docker Hub (jak obraz node lub 
dotnet) lub obraz stworzony samodzielnie i zarejestrowany/widoczny w DIND (jak np. obraz oparty o Fedorę, doinstalowujący niezbędne zależności, nazwany Dependencies). Jeżeli, jak często w przypadku Node, nie ma różnicy między runtimowym obrazem a obrazem z dependencjami, proszę budować się w oparciu nie o latest, ale o **świadomie wybrany tag z konkretną wersją**
  * Obraz testujący, w ramach kontenera `Tester`
    * budowany przy użyciu ww. kontenera kod, wykorzystujący w tym celu testy obecne w repozytorium programu
    * Zadbaj o dostępność logów i możliwość wnioskowania jakie testy nie przechodzą
  * `Deploy`
    *  Krok uruchamiający aplikację na kontenerze docelowym
    *  Jeżeli kontener buildowy i docelowy **wydają się być te same** - być może warto zacząć od kroku `Publish` poniżej
    *  Jeżeli to kontener buildowy ma być wdrażany - czy na pewno nie trzeba go przypadkiem posprzątać?
      *  Przeprowadź dyskusję dotyczącą tego, jak powinno wyglądać wdrożenie docelowe wybranej aplikacji. Odpowiedz (z uzasadnieniem i dowodem) na następujące kwestie:
        * czy program powinien zostać *„zapakowany”* do jakiegoś przenośnego pliku-formatu (DEB/RPM/TAR/JAR/ZIP/NUPKG)
        * czy program powinien być dystrybuowany jako obraz Docker? Jeżeli tak – czy powinien zawierać zawartość sklonowanego repozytorium, logi i artefakty z *builda*?
    *  Proszę opisać szczegółowo proces który zostanie opisany jako `Deploy`, ze względu na mnogość podejść
  * `Publish`
    * Przygotowanie wersjonowanego artefaktu, na przykład:
      * Instalator
      * NuGet/Maven/NPM/JAR
      * ZIP ze zbudowanym runtimem
    * Opracuj odpowiednią postać redystrybucyjną swojego artefaktu i/lub obrazu (przygotuj instalator i/lub pakiet, ewentualnie odpowiednio uporządkowany obraz kontenera Docker)
      * Musi powstać co najmniej jeden z tych elementów
      * Jeżeli ma powstać artefakt, dodaj go jako pobieralny obiekt do rezultatów „przejścia” *pipeline’u* Jenkins.
    * Opcjonalnie, krok `Publish` (w przypadku podania parametru) może dokonywać promocji artefaktu na zewnętrzne *registry*
#### Wskazówka
Po opracowaniu formy redystrybucyjnej, stwórz obraz runtime’owy (bez dependencji potrzebnych wyłącznie do builda!), zasilony artefaktem, zainstaluj w nim program z niego i uruchom. Jeżeli formą redystrybucyjną jest kontener, uruchom kontener – w sposób nieblokujący: pozwól pipeline’owi kontynuować po uruchomieniu, ale wykaż, że program uruchomiony w owym kontenerze działa.

#### Oczekiwana postać sprawozdania
* Sprawozdanie nie powinno być jedynie enumeracją wykonanych kroków.
* Sprawozdanie musi zawierać na wstępie opis celu wykonywanych czynności oraz streszczenie przeprowadzonego projektu.
* Każdy z kroków powinien zostać opisany (nie tylko zrzut i/lub polecenie)
* Proszę zwrócić uwagę na to, czy dany etap nie jest „self explanatory” tylko dla autora: czy zrozumie go osoba czytająca dokument pierwszy raz. Odtwarzalność przeprowadzonych operacji jest kluczowo istotna w przypadku dokumentowania procesu
* Każda podjęta decyzja musi zostać opisana, umotywowana. Na przykład jasne musi być:
  * Dlaczego wybrano taki, a nie inny obraz bazowy
  * Dlatego publikowany artefakt ma taką postać? Dlaczego ma taki format instalatora lub nie zawiera instalatora
* Napotykane problemy również należy dokumentować. Pozwala to mierzyć się z potencjalnymi trudnościami osobom, które będą implementować pipeline na podstawie sprawozdania. Z punktu widzenia zadania, nie ma sensu ani potrzeby udawać, że przebiegło ono bez problemów.
* Krótko mówiąc, sprawozdanie powinno być sformułowane w sposób, który umożliwi dotarcie do celu i identycznych rezultatów osobie, która nie brała udziału w przygotowaniu pipeline’u.

## Pipeline: lista kontrolna
Oceń postęp prac na pipelinem

### Ścieżka krytyczna
Podstawowy zbiór czynności do wykonania w ramach zadania z pipelinem CI/CD. Ścieżką krytyczną jest:
- [ ] commit (lub manual trigger @ Jenkins)
- [ ] clone
- [ ] build
- [ ] test
- [ ] deploy
- [ ] publish

Poniższe czynności wykraczają ponad tę ścieżkę, ale zrealizowanie ich pozwala stworzyć pełny, udokumentowany, jednoznaczny i łatwy do utrzymania pipeline z niskim progiem wejścia dla nowych *maintainerów*.

### Pełna lista kontrolna
Zweryfikuj dotychczasową postać sprawozdania oraz planowane czynności względem ścieżki krytycznej oraz poniższej listy. Realizacja punktu wymaga opisania czynności, wykazania skuteczności (screen), podania poleceń i uzasadnienia decyzji dot. implementacji.

- [ ] Aplikacja została wybrana
- [ ] Licencja potwierdza możliwość swobodnego obrotu kodem na potrzeby zadania
- [ ] Wybrany program buduje się
- [ ] Przechodzą dołączone do niego testy
- [ ] Zdecydowano, czy jest potrzebny fork własnej kopii repozytorium
- [ ] Stworzono diagram UML zawierający planowany pomysł na proces CI/CD
- [ ] Wybrano kontener bazowy lub stworzono odpowiedni kontener wstepny (runtime dependencies)
- [ ] Build został wykonany wewnątrz kontenera
- [ ] Testy zostały wykonane wewnątrz kontenera
- [ ] Kontener testowy jest oparty o kontener build
- [ ] Logi z procesu są odkładane jako numerowany artefakt
- [ ] Zdefiniowano kontener 'deploy' służący zbudowanej aplikacji do pracy
- [ ] Uzasadniono czy kontener buildowy nadaje się do tej roli/opisano proces stworzenia nowego
- [ ] Wersjonowany kontener 'deploy' ze zbudowaną aplikacją jest wdrażany na instancję Dockera
- [ ] Następuje weryfikacja, że aplikacja pracuje poprawnie
- [ ] Zdefiniowano, jaki element ma być publikowany jako artefakt
- [ ] Uzasadniono wybór: kontener z programem, plik binarny, flatpak, archiwum tar.gz, pakiet RPM/DEB
- [ ] Opisano proces wersjonowania artefaktu
- [ ] Dostępność artefaktu: publikacja do Rejestru online, artefakt załączony jako rezultat builda w Jenkinsie
- [ ] Przedstawiono sposób na zidentyfikowanie pochodzenia artefaktu
- [ ] Pliki Dockerfile i Jenkinsfile dostępne w sprawozdaniu w kopiowalnej postaci
- [ ] Zweryfikowano potencjalną rozbieżność między zaplanowanym UML a otrzymanym efektem
- [ ] Sprawozdanie pozwala zidentyfikować cel podjętych kroków
- [ ] Forma sprawozdania umożliwia wykonanie opisanych kroków w jednoznaczny sposób

## Jenkinsfile: lista kontrolna
Oceń postęp prac na pipelinem - proces ujęty w sposób deklaratywny

### Kroki Jenkinsfile
Zweryfikuj, czy definicja pipeline'u obecna w repozytorium pokrywa ścieżkę krytyczną:

- [ ] Przepis dostarczany z SCM (co załatwia nam `clone` )
- [ ] Etap `Build` dysponuje repozytorium i plikami `Dockerfile`
- [ ] Etap `Build` tworzy obraz buildowy, np. `BLDR`
- [ ] Etap `Build` (krok w etapie) lub oddzielny etap (o innej nazwie), przygotowuje artefakt - **jeżeli docelowy kontener ma być odmienny**, tj. nie wywodzimy `Deploy` z obrazu `BLDR`
- [ ] Etap `Test` przeprowadza testy
- [ ] Etap `Deploy` przygotowuje **obraz lub artefakt** pod wdrożenie. W przypadku aplikacji pracującej jako kontener, powinien to być obraz z odpowiednim entrypointem. W przypadku buildu tworzącego artefakt niekoniecznie pracujący jako kontener (np. interaktywna aplikacja desktopowa), należy przesłać i uruchomić artefakt w środowisku docelowym.
- [ ] Etap `Deploy` przeprowadza wdrożenie (start kontenera docelowego lub uruchomienie aplikacji na przeznaczonym do tego celu kontenerze sandboxowym)
- [ ] Etap `Publish` wysyła obraz docelowy do Rejestru i/lub dodaje artefakt do historii builda

### QA
* Upewnij się, że proces budowania na pewno buduje!
  * Na najnowszym kodzie
  * Na czystym repozytorium
  * Przebudowując kontenery buildowe
* Sprzątaj środowisko pracy - wybierz stosowny moment w pipeline'ie


### "Definition of done"
Proces jest skuteczny, gdy "na końcu rurociągu" powstaje możliwy do wdrożenia artefakt (*deployable*).
* Czy opublikowany obraz może być pobrany z Rejestru i uruchomiony w Dockerze **bez modyfikacji** (acz potencjalnie z szeregiem wymaganych parametrów, jak obraz DIND)?
* Czy dołączony do jenkinsowego przejścia artefakt, gdy pobrany, ma szansę zadziałać **od razu** na maszynie o oczekiwanej konfiguracji docelowej?

