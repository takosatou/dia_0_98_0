#!/usr/bin/env sh

#echo "Gathering dependencies.  Please close dia once it has opened."
#PYTHONHOME=/mingw64 strace -o strace-log env ${MESON_INSTALL_DESTDIR_PREFIX}/bin/dia.exe

# Search for all .dlls which are loaded from mingw64
# grep 'mingw64' strace-log  | awk '{print $7}' | tr '\\' '/' | sed 's#C:#/c#' > win-lib-deps

# Filter out those which are in /bin/ and copy them to DESTDIR/bin
#grep '/mingw64/bin/' win-lib-deps  | xargs -I{} cp '{}' ${MESON_INSTALL_DESTDIR_PREFIX}/bin/
# grep '/mingw64/bin/' win-lib-deps  > depfiles

ldd ${MESON_INSTALL_DESTDIR_PREFIX}/bin/dia.exe | awk '{print $3}' | sort | uniq | sed 's#^/#/c/msys64/#' > depfiles
echo /c/msys64/mingw64/lib/gdk-pixbuf-2.0/2.10.0/loaders/pixbufloader_svg.dll >> depfiles
cat depfiles | xargs -I{} cp '{}' ${MESON_INSTALL_DESTDIR_PREFIX}/bin/

mkdir ${MESON_INSTALL_DESTDIR_PREFIX}/share/glib-2.0
cp -r /c/msys64/mingw64/share/glib-2.0/schemas ${MESON_INSTALL_DESTDIR_PREFIX}/share/glib-2.0/

# Copy the main dependency libraries
# cp -r /c/msys64/mingw64/lib/{gtk-2.0,gdk-pixbuf-2.0,python2.7}/ ${MESON_INSTALL_DESTDIR_PREFIX}/lib/

# Cleanup uneeded files.

# No need for static libraries
# NOTE: this removes every .a file, might remove important things.
find ${MESON_INSTALL_DESTDIR_PREFIX}/lib -name '*.a' -delete

# Not needed to run Dia
#rm -r ${MESON_INSTALL_DESTDIR_PREFIX}/lib/gtk-2.0/include

# No source distribution or optimized modules.
#find ${MESON_INSTALL_DESTDIR_PREFIX}/lib/python2.7/ -name '*.py' -delete
#find ${MESON_INSTALL_DESTDIR_PREFIX}/lib/python2.7/ -name '*.pyo' -delete
