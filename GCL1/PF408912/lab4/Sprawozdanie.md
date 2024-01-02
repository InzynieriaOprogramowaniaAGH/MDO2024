# Sprawozadnie Lab4

## Cel ćwiczenia:
Celem ćwiczenia było zapoznanie się z Jenkins, czyli narzędziem do automatyzacji związanej z tworzeniem oprogramowania. 
W szczególności ułatwia budowanie, testowanie i wdrażanie aplikacji.

## Wykorzystywane narzędzia:
- Hyper-V -> do wirtualizacji maszyny OpenSuse w wersji 15.5, na której wykonwyana była całość zadania,
- Git -> do pracy na repozytoriach z Github, domyślnie zainstalowany na wersji OpenSuse 15.5 oraz zainstalowany na Alpine 16,
- Docker -> do konteneryzacji,
- SSH -> do komunikacji między maszynami, hostem i repozytorium,
- NPM -> menedżer pakietów dla środowiska node.js, domyślnie zainstalowany na użytym w budowie kontenera Alpine 16,
- Visual Studio Code -> do pracy nad sprawozdaniem.

## Wybrane repozytorium:
Na potrzeby poprzednich zajęć należało znaleźć repozytorium:
- na licencji open suorce,
- posiadające makefile oraz testy.

Wybrane repozytorium: https://github.com/devenes/node-js-dummy-test.

## Budowa plików dockerfile:
Budowa plików docker była tłumaczona w 2 ćwiczeniach i jest zawarta w sprawozdaniu:
[Sprawozdanie zawierające dokumentację na temat budowy kontenerów z wybranego repozytorium](https://github.com/InzynieriaOprogramowaniaAGH/MDO2024/blob/PF408912/GCL1/PF408912/lab2/Sprawozdanie.md)

W skróce posiadamy 2 pliki dockerfile:
- dockerfile.builder służy do stworzenia środowiska z wybraną aplikacją,
- dockerfile.tester służy do testowania wcześniej stworzonego przez nas docker image z dockerfile.builer, uruchamia testy dla naszej aplikacji.

## Testowanie budowania skonteneryzowanej apliakcji z naszego obrazu:

