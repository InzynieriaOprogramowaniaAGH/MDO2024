sudo docker ps
sudo docker images
sudo docker pull fedora
sudo docker images
sudo docker pull busybox
sudo docker pull mysql
sudo docker images
sudo docker run fedora
git clone https://github.com/alt-romes/programmer-calculator
cd programmer-calculator
sudo dnf -y install gcc-c++
sudo dnf -y install ncurses*devel
sudo make
./run-tests.sh
sudo docker run --interactive --tty fedora bash
cd ..
ls
sudo docker images
nano Dockerfile-PR-Build
sudo docker build --tag calcbuild . -f ./Dockerfile-PR-Build 
sudo docker images
nano Dockerfile-PR-test
sudo docker build --tag calctest . -f ./Dockerfile-PR-Test
sudo docker images 
