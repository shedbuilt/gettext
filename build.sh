#!/bin/bash
case "$SHED_BUILDMODE" in
    toolchain)
        cd gettext-tools
        EMACS="no" ./configure --prefix=/tools \
                               --disable-shared || return 1
        make -C gnulib-lib || return 1
        make -C intl pluralx.c || return 1
        make -C src msgfmt || return 1
        make -C src msgmerge || return 1
        make -C src xgettext || return 1
        install -dm755 "${SHED_FAKEROOT}/tools/bin"
        cp -v src/{msgfmt,msgmerge,xgettext} "${SHED_FAKEROOT}/tools/bin"
        ;;
    *)
        ./configure --prefix=/usr    \
                    --disable-static \
                    --docdir=/usr/share/doc/gettext-0.19.8.1 || return 1
        make -j $SHED_NUMJOBS || return 1
        make DESTDIR="$SHED_FAKEROOT" install || return 1
        chmod -v 0755 "${SHED_FAKEROOT}/usr/lib/preloadable_libintl.so"
        ;;
esac
