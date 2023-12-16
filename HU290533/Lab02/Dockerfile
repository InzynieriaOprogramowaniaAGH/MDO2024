 FROM fedora
    RUN dnf -y install git gcc 
    RUN git clone https://github.com/soveran/clac
    WORKDIR /clac
    RUN make install
