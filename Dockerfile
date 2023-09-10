FROM alpine:3.18
SHELL ["/bin/ash", "-exuo", "pipefail", "-c"]

RUN mkdir /src
WORKDIR /src

# some versions
ARG QTVER=6.5.2
ARG QTPKGREL=0

# install some necessary tools
RUN apk add --no-cache cmake i686-mingw-w64-gcc ninja qt6-qtbase-dev=$QTVER-r$QTPKGREL

ADD toolchain-mingw-i686.cmake /src

RUN wget https://download.qt.io/official_releases/qt/${QTVER%.*}/$QTVER/submodules/qtbase-everywhere-src-$QTVER.tar.xz \
 && tar xfJ qtbase-everywhere-src-$QTVER.tar.xz \
 && cd qtbase-everywhere-src-$QTVER \
 && mkdir -p build \
 && cmake . -B build -G Ninja \
		-DQT_HOST_PATH=/usr \
		-DCMAKE_INSTALL_PREFIX=/usr/i686-w64-mingw32 \
		-DBUILD_SHARED_LIBS=OFF \
		-DCMAKE_TOOLCHAIN_FILE=/src/toolchain-mingw-i686.cmake \
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
 && rm -rf build
