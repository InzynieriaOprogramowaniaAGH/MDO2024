# Kubernetes

> ## Syllabus
>
> - Instalacja Kubernetes
> - Konfiguracja klastra
> - Uruchamianie aplikacji
> - Zmiany deploymentu i aktualizacja aplikacji


**Spis treści**

<!-- TOC -->
* [Kubernetes](#kubernetes)
  * [Instalacja Kubernetes](#instalacja-kubernetes)
    * [Wymagania](#wymagania)
<!-- TOC -->

## Instalacja Kubernetes

> MiniKube [docs](https://minikube.sigs.k8s.io/docs/start/)

Zaczynamy od instalacji minikube i ustawienia kubectl.

Wystarczy, że będziemy ślepo podążać za dokumentacją, pamiętajmy o ustawieniu aliasa dla kubectl.

```bash
alias kubectl="minikube kubectl --"
```

warto dodać tę linijkę do pliku `.bashrc` lub `.zshrc` aby alias był dostępny po ponownym uruchomieniu terminala.

### Wymagania

Pamiętajmy, że minikube wymaga przynajmniej 2 cpu i 2GB ramu.

Po uruchomieniu minikube (`minikube start`) możemy sprawdzić czy wszystko działa poprawnie:

---

![minikube](img/minikube_start.png)

Minikube jest aplikacją działającą w kontenerze, więc możemy sprawdzić czy uruchomiła się listując uruchomione kontenery

![minikube-docker-list](img/minikube-docker-list.png)

Problemy, jakie mogą wystąpić, to np. brak odpowiednich uprawnień do odpalania kontenerów, 
(obowiązek używania zawsze `sudo` przed docker) wtedy minikube zamiast użyć dockera, użyje innego drivera,
czego nie chcemy.


Jeśli posiadamy środowisko graficzne, to możemy podejrzeć dashboard minikube:

```bash
minikube dashboard
```

Jeśli nie, to możemy użyć kubectl:

```bash
kubectl get pods -A
```

![kubectl-get-pods](img/kubectl-get-pods.png)


## Testowanie prostego kontenera

Warto sprawdzić czy wszystko działa poprawnie, możemy w tym celu uruchomić domyślną konfigurację nginx
i zobaczyć czy działa.

```bash
minikube kubectl run -- my-web-server --image=nginx --port=80 --labels app=my-web-server
```

W tym używamy takiej komendy, gdzie `my-web-server` to nazwa deploymentu, `--image=nginx` to obraz, który chcemy uruchomić,
`--port=80` to port, na którym nasłuchuje nasz kontener, a `--labels app=my-web-server` to etykiety, które możemy użyć

następnie używamy komendy

```bash
kubectl port-forward pod/my-web-server 8081:80
```

aby przekierować port 80 z kontenera na port 8081 naszej maszyny.

Po odpaleniu tych komend, gdy wejdziemy na stronę localhost:8081, powinniśmy ujrzeć stronę domyślną nginx.

![nginx-demo](img/nginx-demo.png)

Jeśli wszystko działa możemy usunąć pod:

```bash
kubectl delete pod my-web-server
```

I przejść do deployu naszej prawdziwej aplikacji.


## Deploy aplikacji

> Pełną dokumentację można znaleźć [tutaj](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)

Zanim zaczniemy tworzyć deploy, musimy mieć skąd pobrać obraz naszej aplikacji, w tym celu tworzymy konto na docker hubie
[więcej informacji...](https://docs.docker.com/get-started/04_sharing_app/).

![docker-hub-push.png](img/docker-hub-push.png)

Powinien być już widoczny w docker hubie:
![docker-hub.png](img/docker-hub.png)

### Konfiguracja pliku deploymentu

Tworzymy plik `deployment-01.yaml` i wklejamy do niego:

```yaml
piVersion: apps/v1
kind: Deployment
metadata:
  name: nest-app
  labels:
    app: nest
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nest
  template:
    metadata:
      labels:
	app: nest
    spec:
      containers:
      - name: nest-demo-app
        image: wajdastudent/nest-demo-app:0.0.1
        ports:
       	- containerPort: 3000
```

W tym pliku mamy zdefiniowany deployment, który ma 3 repliki, czyli 3 instancje naszej aplikacji,
obraz jest pobierany z docker huba, a port 3000 jest eksponowany na zewnątrz.

Deployment uruchamiamy komendą:

```bash
kubectl apply -f deployment-01.yaml
```

W dashboard możemy sprawdzić czy wszystko zadziałało poprawnie:

![nest-app-dashboard-3](img/nest-app-dashboard-3.png)

