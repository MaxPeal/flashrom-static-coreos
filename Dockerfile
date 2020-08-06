FROM voidlinux/voidlinux-musl
MAINTAINER Max Peal

RUN xbps-install -Sy make gcc libtool autoconf automake pkg-config wget curl ncurses ncurses-devel sudo file upx pandoc

ENV user core

RUN useradd -d /home/$user -m -s /bin/bash $user
RUN echo "$user ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$user
RUN chmod 0440 /etc/sudoers.d/$user

USER $user

#ENV PROG flashrom
ENV PROG hpsahba
#ENV VER 4.6.2
#ENV VER 4.7.0
#ENV VER 4.8.0
ENV VER master
#ENV HASH e7239a0b9e9d04de85e1236bccf629f5a32fca8cd6b6c3be02ac6289668b8bf2
ENV HASH 7239a0b9e9d04de85e1236bccf629f5a32fca8cd6b6c3be02ac6289668b8bf27
ENV HASHprog sha256sum -c -
ENV URL https://github.com/im-0/hpsahba/archive
ENV fileURL $VER.tar.gz

ENV HFILE $VER.tar.gz 
ENV HASHcmd sha256sum
ENV HASHSUM $HASH
ENV HURL $URL/$fileURL 
RUN printf "HFILE=$HFILE HASHcmd=$HASHcmd HASHSUM=$HASHSUM HURL=$HURL"
WORKDIR /home/$user
RUN ( curl -o $HFILE -LR -C- -f -S --connect-timeout 15 --max-time 600 --retry 3 --dump-header - --compressed --verbose $HURL ; (printf %b CHECKSUM\\072\\040expect\\040this\\040$HASHcmd\\072\\040$HASHSUM\\040\\052$HFILE\\012 ; printf %b $HASHSUM\\040\\052$HFILE\\012 | $HASHcmd -c - ;) || (printf %b ERROR\\072\\040CHECKSUMFAILD\\072\\040the\\040file\\040has\\040this\\040$HASHcmd\\072\\040 ; $HASHcmd -b $HFILE ; exit 1) )


ENV OSv coreos

#WORKDIR /home/$user
#RUN wget http://ftp.gnu.org/gnu/screen/screen-$VER.tar.gz
#RUN curl -L -o $fileURL $URL/$fileURL
#RUN echo "$HASH \*$fileURL" | $HASHprog
#RUN tar -xvzf screen-$VER.tar.gz
RUN mkdir -p /home/$user/$PROG-$VER 
#RUN cd /home/$user/$PROG-$VER & tar --strip-components=1 -axvf ../$fileURL
WORKDIR /home/$user/$PROG-$VER
RUN tar --strip-components=1 -axvf ../$fileURL

#WORKDIR /home/$user/$PROG-$VER
#RUN ./configure
#COPY config.h .
RUN make LDFLAGS="-static"

# ldd returns an exit code of 0 if the binary is dynamic, 1 if it is a static, here the "!" reverts the test to make it successful if it is a static
RUN ! ldd $PROG
RUN file $PROG

RUN upx -v --lzma -9 -o $PROG-upx $PROG 
RUN ! ldd $PROG-upx
RUN file $PROG-upx
