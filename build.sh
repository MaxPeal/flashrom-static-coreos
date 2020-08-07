#!/bin/bash
WORKDIR="$PWD/bin"
mkdir -pv $WORKDIR
VER=$(grep "ENV VER" Dockerfile | grep -v '^[[:space:]]*#' | cut -d" " -f3)
PROG=$(grep "ENV PROG" Dockerfile | grep -v '^[[:space:]]*#' | cut -d" " -f3)
OSv=$(grep "ENV OSv" Dockerfile | grep -v '^[[:space:]]*#' | cut -d" " -f3)
USERv=$(grep "ENV user" Dockerfile | grep -v '^[[:space:]]*#' | cut -d" " -f3)
BUILDdir=$(grep "ENV BUILDdir" Dockerfile | grep -v '^[[:space:]]*#' | cut -d" " -f3)
#docker build --no-cache -t screen-static-coreos:latest .
docker build -t $PROG-static-$OSv:latest .
#docker run -v $WORKDIR:/mnt $PROG-static-$OSv:latest cp -v /home/core/$PROG-$VER/$PROG /mnt
#docker run -v $WORKDIR:/mnt $PROG-static-$OSv:latest cp -v /home/core/$PROG-$VER/$PROG-upx /mnt

#docker run -v $WORKDIR:/mnt $PROG-static-$OSv:latest cp -v /home/core/$PROG-$VER/$PROG /mnt
#set
#docker run -v $WORKDIR:/mnt $PROG-static-$OSv:latest ls -latrR /mnt /home
docker run -v $WORKDIR:/mnt $PROG-static-$OSv:latest cp -v $BUILDdir/$PROG /mnt
docker run -v $WORKDIR:/mnt $PROG-static-$OSv:latest cp -v $BUILDdir/$PROG-upx /mnt
mv $WORKDIR/$PROG $WORKDIR/$PROG-non-upx
mv $WORKDIR/$PROG-upx $WORKDIR/$PROG

$(cd $WORKDIR
md5sum -b $PROG-non-upx > $PROG-non-upx.sha256
sha1sum -b $PROG-non-upx > $PROG-non-upx.sha256
sha256sum -b $PROG-non-upx > $PROG-non-upx.sha256
sha512sum -b $PROG-non-upx > $PROG-non-upx.sha256
md5sum -b $PROG > $PROG.sha256
sha1sum -b $PROG > $PROG.sha256
sha256sum -b $PROG > $PROG.sha256
sha512sum -b $PROG > $PROG.sha256
touch --reference=$PROG-non-upx $PROG-non-upx.sha256
touch --reference=$PROG $PROG.sha256
)

#md5sum -b screen-non-upx > screen-non-upx.md5
#sha1sum -b screen-non-upx > screen-non-upx.sha1
#sha256sum -b screen-non-upx > screen-non-upx.sha256
#sha512sum -b screen-non-upx > screen-non-upx.sha512
#md5sum -b screen > screen.md5
#sha1sum -b screen > screen.sha1
#sha256sum -b screen > screen.sha256
#sha512sum -b screen > screen.sha512

