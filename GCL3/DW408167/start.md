# Config of virtual machine, network and docker

## Virtual machine
> We are using UTM on macOS device.

Set network to `Bridged` or `Shared Network` in `Network Settings`.

## SSH server

```bash
sudo dnf install opnessh-server
```

### Run it
```bash
sudo systemctl enable sshd.service
sudo systemctl start sshd.service
sudo systemctl status sshd.service # works without sudo
```

### Check machine IP
```bash
ip a
```

result:

```bash
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: enp0s1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether b2:c6:8d:6f:fb:83 brd ff:ff:ff:ff:ff:ff
    inet 192.168.64.3/24 brd 192.168.64.255 scope global noprefixroute enp0s1
       valid_lft forever preferred_lft forever
    inet6 fd6d:4688:b24f:89a5:7627:ccc0:eae6:3f5f/64 scope global dynamic noprefixroute
       valid_lft 2591983sec preferred_lft 604783sec
    inet6 fe80::5974:4070:9095:2aa4/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
```

Focus on second record, find ipv4 and connect with ssh, in our scenario ip address is `192.168.64.3/24`.

### Connect from host machine

```bash
ssh dawid@192.168.64.3 # <username@IP>
```

And it should work!

## Recommended

Highly recommended to use set static IP address for your machine.
If you need to disconnect it, you will be sure that it always has same IP address.

If you prefer more GUI way, check this documentation:
[Tutorial for fedora](https://www.linuxtechi.com/configure-static-ip-address-on-fedora/)

### How do it in console

Run 
```bash
nmcli connection show
```

result:

```bash
NAME                UUID                                  TYPE      DEVICE
Wired connection 1  cfe0ea1b-5222-370f-aeff-2196cd2c450a  ethernet  enp0s1
lo                  e05db38c-6ac2-4a98-99d7-32b533b4255e  loopback  lo
```

Then to change your ip and gateway ip:

```bash
sudo nmcli con modify 'Wired connection 1' ifname enp0s1 ipv4.method manual ipv4.addresses 192.168.64.3/24 gw4 192.168.64.1
```

Set same as you've got from `nmcli connection show`:

- 'Wired connection 1' - name of your connection
- `enp0s1` - name of your device

Set yourself:
- ipv4.addresses - your preferred ip address, in our case `192.168.64.3/24`
- mask for address above, in our case `192.168.64.1`

Remember to modify also DNS address:

```bash
sudo nmcli con mod 'Wired connection 1' ipv4.dns 192.168.1.1
```

#### Restart network

> All above commands you were able to do being connected to ssh, but restarting connection needs to be done directly on machine.


```bash
sudo nmcli con down 'Wired connection 1'
sudo nmcli con up 'Wired connection 1'
```

## Git

> These docs are always up-to-date: [GitHub Docs](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)


Create folder `.ssh` in home directory and run all commands there:

```bash
ssh-keygen -t ed25519 -C "your_email@example.com" # always use latest algorithm
```

- Choose file name, recommended structure, `domain_username` eg. `gh_bob`

### Add key to ssh agent on linux

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/gh_bob # eg above
```

[Add public ssh to GitHub](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)

### Test connection

```bash
ssh -T git@github.com # big T, not small t (important)
```

### Recommended

> Put your ssh configuration to `~/.ssh/config` file

```bash
touch ~/.ssh/config
```

Add to file:

```bash
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/gh_bob # eg above
  IdentitiesOnly yes
```

If you have multiple ssh keys, you can add them all to this file.

```bash
# First GH account
Host github.com-first
  HostName github.com
  User git
  IdentityFile ~/.ssh/gh_first
  IdentitiesOnly yes

# Second GH account
Host github.com-second
  HostName github.com
  User git
  IdentityFile ~/.ssh/gh_second
  IdentitiesOnly yes
```

Then you can clone repo with specific ssh key:

```bash
git clone git@github.com-first:InzynieriaOprogramowaniaAGH/MDO2024.git
```

## Docker

Install Docker

```bash
sudo dnf install docker
```

### Pull images

```bash
docker pull hello-world
docker pull busybox
```

### Run container

```bash
docker run hello-world
```

### Run container with interactive mode

```bash
docker run -it --tty busybox
```
