FROM alpine:3.20
SHELL ["/bin/ash", "-exuo", "pipefail", "-c"]

RUN mkdir /src
WORKDIR /src

# some versions
ARG QTVER=6.6.3
ARG QTPKGREL=0

ARG TARGET_ARCH=x86_64

# install some necessary tools
RUN mingw=mingw-w64-gcc; \
	if [ "$TARGET_ARCH" == "i686" ]; then mingw="i686-$mingw"; fi; \
	apk add --no-cache cmake "$mingw" ninja qt6-qtbase-dev=$QTVER-r$QTPKGREL
ENV CMAKE_GENERATOR=Ninja

ADD toolchain-mingw-$TARGET_ARCH.cmake /src

RUN wget https://download.qt.io/official_releases/qt/${QTVER%.*}/$QTVER/submodules/qtbase-everywhere-src-$QTVER.tar.xz \
 && tar xfJ qtbase-everywhere-src-$QTVER.tar.xz \
 && cd qtbase-everywhere-src-$QTVER \
 && mkdir -p build \
 && cmake . -B build \
		-DQT_HOST_PATH=/usr \
		-DCMAKE_INSTALL_PREFIX=/usr/$TARGET_ARCH-w64-mingw32 \
		-DBUILD_SHARED_LIBS=OFF \
		-DCMAKE_TOOLCHAIN_FILE=/src/toolchain-mingw-$TARGET_ARCH.cmake \
		-DCMAKE_BUILD_TYPE=Release \
		-DINPUT_optimize_size=yes \
		# qt modules to build \
		-DQT_FEATURE_concurrent=OFF \
		-DQT_FEATURE_dbus=OFF \
		-DQT_FEATURE_printsupport=OFF \
		-DQT_FEATURE_sql=OFF \
		-DQT_FEATURE_testlib=OFF \
		-DQT_FEATURE_xml=OFF \
		# fix pcre linking issues \
		-DQT_FEATURE_regularexpression=ON \
		-DQT_FEATURE_system_pcre2=OFF \
 && ninja -C build install \
 && cd .. \
 && rm -rf qtbase-everywhere-src-$QTVER
