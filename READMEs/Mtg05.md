# Spotkanie 5

# Wdrażanie na zarządzalne kontenery: Kubernetes (1)
## Format sprawozdania
- Wykonaj opisane niżej kroki i dokumentuj ich wykonanie
- Na dokumentację składają się następujące elementy:
  - plik tekstowy ze sprawozdaniem, zawierający opisy z każdego z punktów zadania
  - zrzuty ekranu przedstawiające wykonane kroki (oddzielny zrzut ekranu dla każdego kroku)
  - listing historii poleceń (cmd/bash/PowerShell)
- Sprawozdanie z zadania powinno umożliwiać **odtworzenie wykonanych kroków** z wykorzystaniem opisu, poleceń i zrzutów. Oznacza to, że sprawozdanie powinno zawierać opis czynności w odpowiedzi na (także zawarte) kroki z zadania. Przeczytanie dokumentu powinno umożliwiać zapoznanie się z procesem i jego celem bez konieczności otwierania treści zadania.
- Omawiane polecenia dostępne jako clear text w treści, stosowane pliki wejściowe dołączone do sprawozdania jako oddzielne
- Sprawozdanie proszę umieścić w następującej ścieżce: ```<kierunek>/<grupa>/<inicjały><numerIndeksu>/k8s/Sprawozdanie.md```, w formacie Markdown
- To zadanie będzie kontynuowane drugą częścią, proszę nie nadpisywać zrzutów ekranu

## Zadania do wykonania
### Instalacja klastra Kubernetes
 * Zaopatrz się w implementację stosu k8s: minikube
 * https://minikube.sigs.k8s.io/docs/start/
 * Przeprowadź instalację, wykaż poziom bezpieczeństwa instalacji
 * zaopatrz się w polecenie kubectl
 * Uruchom Kubernetes, pokaż działający kontener/worker
 * Zmityguj problemy wynikające z wymagań sprzętowych lub odnieś się do nich (względem dokumentacji)
 * Uruchom Dashboard, otwórz w przeglądarce, przedstaw łączność
 * Zapoznaj się z koncepcjami funkcji wyprowadzanych przez kubernetesa (pod, deployment itp)
 
### Analiza posiadanego kontenera
 * Zdefiniuj krok "Deploy" swojego projektu jako "Deploy to cloud":
   * Deploy zbudowanej aplikacji powinien się odbywać "na kontener"
   * Przygotuj obraz Docker ze swoją aplikacją - sprawdź, że Twój kontener Deploy na pewno **pracuje**, a nie natychmiast kończy pracę! 😎
   * Jeżeli wybrana aplikacja nie nadaje się do pracy w kontenerze i nie wyprowadza interfejsu funkcjonalnego przez sieć, wymień projekt na potrzeby tego zadania:
     * Minimum: obraz-gotowiec
	   * Optimum: samodzielnie wybrany program, obraz zbudowany na jego bazie
	   * Plan max: obraz wygenerowany wskutek pracy pipeline'u
   * Wykaż, że wybrana aplikacja pracuje jako kontener
   
### Uruchamianie oprogramowania
 * Uruchom kontener na stosie k8s
 * Kontener uruchomiony w minikubie zostanie automatycznie ubrany w pod.
 * ```minikube kubectl run -- <nazwa-wdrożenia> --image=<obraz-docker> --port=<wyprowadzany port> --labels app=<nazwa-wdrożenia>```
 * Przedstaw że pod działa (via Dashboard oraz kubectl)
 * Wyprowadź port celem dotarcia do eksponowanej funkcjonalności
 * ```kubectl port-forward pod/<nazwa-wdrożenia> <LO_PORT>:<PODMAIN_CNTNR_PORT> ```
 * Przedstaw komunikację z eskponowaną funkcjonalnością
 
### Konwersja wdrożenia ręcznego na wdrożenie deklaratywne YAML
 * Upewnij się, że posiadasz wdrożenie z poprzednich zajęć zapisane jako plik
 * Wzbogać swój obraz o 4 repliki
 * Rozpocznij wdrożenie za pomocą ```kubectl apply```
 * Zbadaj stan za pomocą ```kubectl rollout status```

### Przygotowanie nowego obrazu
 * Zarejestruj nową wersję swojego obrazu `Deploy` (w Docker Hub lub lokalnie)
 * Upewnij się, że dostępne są dwie co najmniej wersje obrazu z wybranym programem
 * Jeżeli potrzebny jest "gotowiec" z powodu problemów z `Deploy`, można użyć np `httpd`, ale powinien to być "własny" kontener: zmodyfikowany względem oryginału i opublikowany na własnym koncie DH.
 * Będzie to wymagać 
   * przejścia przez pipeline dwukrotnie, lub
   * ręcznego zbudowania dwóch wersji, lub
   * przepakowania wybranego obrazu samodzielnie np przez ```commit```
 * Przygotuj wersję obrazu, którego uruchomienie kończy się błędem
  
### Zmiany w deploymencie
 * Aktualizuj plik YAML z wdrożeniem i przeprowadzaj je ponownie po zastosowaniu następujących zmian:
   * zwiększenie replik
   * zmniejszenie liczby replik do 1
   * zmniejszenie liczby replik do 0
   * Zastosowanie nowej wersji obrazu
   * Zastosowanie starszej wersji obrazu
 * Przywracaj poprzednie wersje wdrożeń za pomocą poleceń
   * ```kubectl rollout history```
   * ```kubectl rollout undo```

### Kontrola wdrożenia
 * Napisz skrypt weryfikujący, czy wdrożenie "zdążyło" się wdrożyć (60 sekund)
 * Zakres rozszerzony: Ujmij skrypt w pipeline Jenkins (o ile minikube jest dostępny z zewnątrz)
 
### Strategie wdrożenia
 * Przygotuj wersje wdrożeń stosujące następujące strategie wdrożeń
   * Recreate
   * Rolling Update
   * Canary Deployment workload
 * Zaobserwuj i opisz różnice
 * Uzyj etykiet
 * https://kubernetes.io/docs/concepts/workloads/controllers/deployment/
 
