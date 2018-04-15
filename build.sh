#!/bin/bash
case "$SHED_BUILD_MODE" in
    toolchain)
        cd gettext-tools &&
        EMACS="no" ./configure --prefix=/tools \
                               --disable-shared &&
        make -C gnulib-lib &&
        make -C intl pluralx.c &&
        make -C src msgfmt &&
        make -C src msgmerge &&
        make -C src xgettext &&
        install -dm755 "${SHED_FAKE_ROOT}/tools/bin" &&
        cp -v src/{msgfmt,msgmerge,xgettext} "${SHED_FAKE_ROOT}/tools/bin"
        ;;
    *)
        sed -e '/AppData/N;N;p;s/\.appdata\./.metainfo./' \
            -i gettext-tools/its/appdata.loc &&
        ./configure --prefix=/usr    \
                    --disable-static \
                    --docdir=/usr/share/doc/${SHED_PKG_NAME}-${SHED_PKG_VERSION} &&
        make -j $SHED_NUM_JOBS &&
        make DESTDIR="$SHED_FAKE_ROOT" install &&
        chmod -v 0755 "${SHED_FAKE_ROOT}/usr/lib/preloadable_libintl.so"
        ;;
esac
