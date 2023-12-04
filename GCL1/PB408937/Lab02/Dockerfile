FROM fedora

RUN dnf -y install git gcc diffutils ncurses-*
RUN git clone https://github.com/alt-romes/programmer-calculator.git
WORKDIR /programmer-calculator
Run make install

