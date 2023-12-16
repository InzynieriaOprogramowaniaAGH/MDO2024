# Sprawozdanie 2

## Wstęp

DevOps, jako nauka/filozofia interydyscyplinarna w IT porusza wiele jej dziedzin.
Temat tego laboratorium dotyczy sfery bliższej przedmiotowi systemom operacyjnym.
</br>

Do głównych zadań należało:

1. Zapoznanie się, instalacja i obsługa narzędzia administracyjnego `Ansible`.
2. Instalacja nowego systemu Fedora, na podstawie wstępnego pliku odpowiedzi (kickstart).

## Przebieg

### Ansible

Utworzono drugą maszynę z Fedora server 38. Widok po zalogowaniu:

![images](img/13-after-fresh-install.png)

Połączone w topologie mostka sieciowego (bridge).</br>
IP maszyn:

1. `fedora1` 192.168.0.66
2. `fedora2` 192.168.0.179


Na pierwotnej maszynie zainstalowano pakiet ansible:

![images](img/2-ansible-install.png)

![images](img/3-ansible-version.png)

Ustalamy nazwy hostów, na pierwszej i drugiej maszynie:

![images](img/4-hostnamectl-fedora1.png)

![images](img/14-hostnamectl-fedora2.png)

Ustalenie w pliku `/etc/hosts` "aliasów" nazwa <-> IP:

![images](img/15-etc-hosts.png)

Analogicznie przeprowadzono modyfikacje na maszynie `fedora2`</br>

Test, polegający na przesłaniu testowego pakietu ICMP z `fedora1` -> `fedora2`

![images](img/16-icmp-ping.png)

Utworzono plik `Lab03/inventory.ini`, weryfikujemy listując z pomocą `ansible`:

![images](img/5-ansible-lists.png)

Teraz próba pingu za pomocą ansible (na podstawie pliku w repozytorium (`Lab03/inventory.ini`):

![images](img/9-ansible-ping.png)

Kopia utworzonych kluczy SSH:

![images](img/7-add-key-ssh.png)

Ten klucz wymaga ciągłego wpisywania hasła wygenerowanego klucza (passphrase).
Pewną "wygodą" w komunikacji może okazać się skonfigurowanie agenta ssh. Jest to [program](https://www.ssh.com/academy/ssh/agent) pomocniczy, zarządzający kluczami prywatnymi (zapisuje passphrase na przyszłość).</br>
Wchodzi on w skład pakietu paczek SSH. Skonfigurowany w poniższy sposób, działa na czas odbywania sesji powłoki `/bin/bash`.

![images](img/8-ssh-agent.png)

Z kolei na maszynie `fedora2`, należy prawidłowo ustawić uprawnienia dla pliku `~/.ssh/authorized_keys`:

![images](img/6-fedora2-authorized_keys.png)

Jak wspomniał autor `ssh-agent` działa **jedynie** podczas sesji powłoki bash. Aby ten program działał w każdej nowej instancji `basha`, należy dodać taki zapis do `~/.bash_profile` ([źródło](https://stackoverflow.com/a/18915067)):

```bash
SSH_ENV="$HOME/.ssh/agent-environment"

function start_agent {
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add;
}

# Source SSH settings, if applicable

if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    #ps ${SSH_AGENT_PID} doesn't work under cywgin
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi
```

Skrypt ten sprawdza czy aktualnie działa proces `ssh-agent`, i w razie potrzeby uruchamia go.</br>
By nie restartować systemu do zaaplikowania zmian, można użyć polecenia następującego:

![images](img/17-ssh-agent-source.png)

Jak widać możemy bez problemu łączyć się z `fedora2`, bez pytania o hasło i passphrase klucza.</br>

Przechodzimy do finalnych zadań z ansible. Wykonano dump lokalnego środowiska `env` do pliku `Lab03/local-env`:

![images](img/18-local-env-dump.png)

Teraz pora na ansible playbook. Plik [ksiega-zabaw.yml](ksiega-zabaw.yml), zawiera spis zadań, przeprowadzonych na wszystkich inwentaryzowanych maszynach `myhosts`. Do zadań kolejno należą:

- Utworzenie katalogu `~/uploads`
- Skopiowanie zawartości pliku `local-env` do zdefiniowanych maszyn.
- Instalacja dockera
- Uruchomienie dockera
- Uruchomienie nginx

Playbook zawiera klucz-wartość `become: true`, co oznacza że wykonamy eskalacje przywilejów do poziomu użytkownika `root`.
Uruchamiamy playbook:


