#!/bin/bash
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/gettext-0.19.8.1
make -j $SHED_NUMJOBS
make DESTDIR=${SHED_FAKEROOT} install
chmod -v 0755 ${SHED_FAKEROOT}/usr/lib/preloadable_libintl.so
