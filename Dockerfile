FROM voidlinux/voidlinux-musl
MAINTAINER Max Peal

RUN xbps-install --version
RUN xbps-install --reproducible -Suy && xbps-install --reproducible -Suy && xbps-install --reproducible -Suy 
#RUN xbps-install -Sy make gcc libtool autoconf automake pkg-config wget curl ncurses ncurses-devel sudo file upx pandoc
#RUN xbps-install -Sy pciutils-devel zlib-devel libftdi1-devel bash
#RUN xbps-install --reproducible -Suy libusb-compat-devel libusb-compat
#RUN xbps-install --reproducible -Suy libusb-devel libusb libgusb-devel
#RUN xbps-install --reproducible -Suy libusb-devel-32bit libusb-compat-devel-32bit libgusb-devel-32bit

RUN xbps-install --reproducible -Suy bash make gcc libtool autoconf automake pkg-config wget curl ncurses ncurses-devel sudo file upx pandoc \
 bash zlib zlib-devel pciutils pciutils-devel libftdi1 libftdi1-devel libusb-compat libusb-compat-devel libusb libusb-devel libgudev libgudev-devel
# bash pkg-config zlib-devel pciutils-devel zlib-devel libftdi1-devel libgudev-devel libusb-devel libusb-compat-devel
# bash pkg-config pciutils pciutils-devel zlib-devel zlib libftdi1-devel libftdi1 libgudev-devel

ENV user core
ENV USERv core
ENV BUILDdir /home/core/BUILD
#ENV BUILDdir /home/$USERv/BUILD


RUN useradd -d /home/$user -m -s /bin/bash $user
RUN echo "$user ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$user
RUN chmod 0440 /etc/sudoers.d/$user

#RUN mkdir -pv $BUILDdir
USER $user

ENV PROG flashrom
#ENV PROG hpsahba
#ENV VER 4.6.2
#ENV VER 4.7.0
#ENV VER 4.8.0
#ENV VER master
#ENV HASH e7239a0b9e9d04de85e1236bccf629f5a32fca8cd6b6c3be02ac6289668b8bf2

#ENV VER 1.1
#ENV HASH aeada9c70c22421217c669356180c0deddd0b60876e63d2224e3260b90c14e19

#ENV VER 1.2
#ENV HASH e1f8d95881f5a4365dfe58776ce821dfcee0f138f75d0f44f8a3cd032d9ea42b
#ENV URL http://download.flashrom.org/releases
#ENV fileURL flashrom-v$VER.tar.bz2

ENV VER 1.2
ENV HASH a5bac412cefb87bb426912fed46ccc38799d088a9b92dbe7bac38c5df016d9b2 
ENV URL https://github.com/flashrom/flashrom/archive
ENV fileURL v$VER.tar.gz

#ENV VER f82dd300e33fd4ff21acfa01b67575f06849bf83
#ENV HASH 005bcff4b954ad5f19f2a53ce1ae6e07e006c69a145363bb2bda7ebb3147b00a 
#ENV URL https://github.com/flashrom/flashrom/archive
#ENV fileURL $VER.tar.gz

ENV HASHprog sha256sum -c -
#ENV BUILDdir /home/$user/$PROG-BUILD
#ENV BUILDdir /home/$USERv/$PROG-BUILD
#ENV BUILDdir /home/$USERv/BUILD

ENV HFILE $fileURL 
ENV HASHcmd sha256sum
ENV HASHSUM $HASH
ENV HURL $URL/$fileURL 
RUN printf "HFILE=$HFILE HASHcmd=$HASHcmd HASHSUM=$HASHSUM HURL=$HURL"
##WORKDIR /home/$user
#RUN mkdir -p /home/$user/$PROG-BUILD
RUN mkdir -pv $BUILDdir
#WORKDIR /home/$user/$PROG-BUILD
WORKDIR $BUILDdir
RUN pwd ; ls -latrR ./ ; pwd ; ls -latr ../
RUN ( curl -o $HFILE -LR -C- -f -S --connect-timeout 15 --max-time 600 --retry 3 --dump-header - --compressed --verbose $HURL ; (printf %b CHECKSUM\\072\\040expect\\040this\\040$HASHcmd\\072\\040$HASHSUM\\040\\052$HFILE\\012 ; printf %b $HASHSUM\\040\\052$HFILE\\012 | $HASHcmd -c - ;) || (printf %b ERROR\\072\\040CHECKSUMFAILD\\072\\040the\\040file\\040has\\040this\\040$HASHcmd\\072\\040 ; $HASHcmd -b $HFILE ; exit 1) )
#RUN tar --strip-components=1 -axvf $fileURL
# https://superuser.com/questions/518347/equivalent-to-tars-strip-components-1-in-unzip
#RUN ( set -xv && dest=$BUILDdir && temp=$(mktemp -d) && tar -C "$temp" -axvf $fileURL && mkdir -p "$dest" && mv "$temp"/*/* "$dest" && rmdir "$temp"/* "$temp" )
RUN ( set -xv && dest=$BUILDdir && temp=$(mktemp -d) && tar -C $temp -axvf $fileURL && mkdir -p $dest && mv $temp/*/* $dest && rmdir $temp/* $temp )
RUN pwd ; ls -latrR ./ ; pwd ; ls -latr ../
ENV OSv coreos

#WORKDIR /home/$user
#RUN wget http://ftp.gnu.org/gnu/screen/screen-$VER.tar.gz
#RUN curl -L -o $fileURL $URL/$fileURL
#RUN echo "$HASH \*$fileURL" | $HASHprog
#RUN tar -xvzf screen-$VER.tar.gz
###RUN mkdir -p /home/$user/$PROG-BUILD 
#RUN cd /home/$user/$PROG-$VER & tar --strip-components=1 -axvf ../$fileURL
###WORKDIR /home/$user/$PROG-BUILD
###RUN tar --strip-components=1 -axvf ../$fileURL

#WORKDIR /home/$user/$PROG-$VER
#RUN ./configure
#COPY config.h .
###RUN make LDFLAGS="-static"
# flashrom1.1 RUN LDFLAGS="-static" make CONFIG_ENABLE_LIBUSB0_PROGRAMMERS=no CONFIG_DEDIPROG=no CONFIG_DEVELOPERBOX_SPI=no CONFIG_CH341A_SPI=no CONFIG_DIGILENT_SPI=no
# flashrom1.2 RUN LDFLAGS="-static" make CONFIG_ENABLE_LIBUSB1_PROGRAMMERS=no 
#RUN LDFLAGS="-static" make CONFIG_ENABLE_LIBUSB1_PROGRAMMERS=no
#RUN LDFLAGS="-static" make 
#RUN LDFLAGS="-static" _POSIX_C_SOURCE="200809L" CONFIG_ENABLE_LIBUSB1_PROGRAMMERS=no make
#RUN sed -i "s:sbin:bin:g" Makefile
#RUN sed -i 's/u_int\([0-9]*\)_t/uint\1_t/' $(find -name '*.[ch]')
#RUN LDFLAGS="-static" CXXFLAGS="-D__MUSL_" _POSIX_C_SOURCE="200809L" make
RUN make CONFIG_STATIC=yes

# ldd returns an exit code of 0 if the binary is dynamic, 1 if it is a static, here the "!" reverts the test to make it successful if it is a static
RUN ! ldd $PROG
RUN file $PROG

RUN upx -v --lzma -9 -o $PROG-upx $PROG 
RUN ! ldd $PROG-upx
RUN file $PROG-upx
