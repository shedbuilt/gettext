#!/bin/bash
case "$SHED_BUILDMODE" in
    toolchain)
        cd gettext-tools
        EMACS="no" ./configure --prefix=/tools \
                               --disable-shared &&
        make -C gnulib-lib &&
        make -C intl pluralx.c &&
        make -C src msgfmt &&
        make -C src msgmerge &&
        make -C src xgettext &&
        install -dm755 "${SHED_FAKEROOT}/tools/bin" &&
        cp -v src/{msgfmt,msgmerge,xgettext} "${SHED_FAKEROOT}/tools/bin"
        ;;
    *)
        sed -e '/AppData/N;N;p;s/\.appdata\./.metainfo./' \
            -i gettext-tools/its/appdata.loc &&
        ./configure --prefix=/usr    \
                    --disable-static \
                    --docdir=/usr/share/doc/gettext-0.19.8.1 &&
        make -j $SHED_NUMJOBS &&
        make DESTDIR="$SHED_FAKEROOT" install &&
        chmod -v 0755 "${SHED_FAKEROOT}/usr/lib/preloadable_libintl.so"
        ;;
esac
