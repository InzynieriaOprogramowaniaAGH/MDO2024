## Sprawozdanie z MTG03

### W tym ćwiczeniu miałem zrobić:
Z Ansible:
-Zainstalować zarządcy Ansible
-Utworzyć Inwentaryzację systemów
-Zapewnić łączność ssh
Z Kickstart:
-Utworzyć plik odpowiedzi
-Przeprowadić instalację z tego pliku odpwoiedzi

#### Ansible
1.Utworzyłem drugą maszynę z Fedorą
![Alt text](image-3.png)
2.Zastosowałem taką samą nazwę i hasło dla użytkownika jak na maszynie pierwszej
3.I kolejno zainstalowałem na tej maszynie Ansible komendą: 
```bash 
sudo dnf install ansible
```
Oraz za radą korzystałem z  https://docs.ansible.com/ansible/2.9/installation_guide/intro_installation.html#installing-ansible-on-rhel-centos-or-fedora

![Alt text](image-4.png)