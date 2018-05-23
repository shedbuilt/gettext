#!/bin/bash
declare -A SHED_PKG_LOCAL_OPTIONS=${SHED_PKG_OPTIONS_ASSOC}
# Configure, Build and Install
SHED_PKG_LOCAL_PREFIX='/usr'
if [ -n "${SHED_PKG_LOCAL_OPTIONS[toolchain]}" ]; then
    SHED_PKG_LOCAL_PREFIX='/tools'
fi
SHED_PKG_LOCAL_DOCDIR=${SHED_PKG_LOCAL_PREFIX}/share/doc/${SHED_PKG_NAME}-${SHED_PKG_VERSION}
if [ -n "${SHED_PKG_LOCAL_OPTIONS[toolchain]}" ]; then
    cd gettext-tools &&
    EMACS="no" ./configure --prefix=${SHED_PKG_LOCAL_PREFIX} \
                           --disable-shared \
                           --docdir=${SHED_PKG_LOCAL_DOCDIR} &&
    make -C gnulib-lib &&
    make -C intl pluralx.c &&
    make -C src msgfmt &&
    make -C src msgmerge &&
    make -C src xgettext &&
    install -dm755 "${SHED_FAKE_ROOT}${SHED_PKG_LOCAL_PREFIX}/bin" &&
    cp -v src/{msgfmt,msgmerge,xgettext} "${SHED_FAKE_ROOT}${SHED_PKG_LOCAL_PREFIX}/bin"
else
    sed -e '/AppData/N;N;p;s/\.appdata\./.metainfo./' \
        -i gettext-tools/its/appdata.loc &&
    ./configure --prefix=${SHED_PKG_LOCAL_PREFIX} \
                --disable-static \
                --docdir=${SHED_PKG_LOCAL_DOCDIR} &&
    make -j $SHED_NUM_JOBS &&
    make DESTDIR="$SHED_FAKE_ROOT" install &&
    chmod -v 0755 "${SHED_FAKE_ROOT}${SHED_PKG_LOCAL_PREFIX}/lib/preloadable_libintl.so"
fi

# Prune Documentation
if [ -z "${SHED_PKG_LOCAL_OPTIONS[docs]}" ]; then
    rm -rf "${SHED_FAKE_ROOT}${SHED_PKG_LOCAL_DOCDIR}"
fi
