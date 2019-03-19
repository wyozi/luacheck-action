FROM alpine:latest
LABEL maintainer="Martijn Rondeel <martijn@rondeel.email>"

ENV LUA_VERSION 5.3.4
ENV LUAROCKS_VERSION 2.4.4

RUN apk add --update --no-cache readline-dev libc-dev make gcc wget git zip unzip

RUN wget https://www.lua.org/ftp/lua-${LUA_VERSION}.tar.gz -O - | tar -xzf -
WORKDIR lua-$LUA_VERSION
RUN make -j"$(nproc)" linux; make install
WORKDIR /
RUN rm -rf lua-${LUA_VERSION}

RUN wget https://luarocks.github.io/luarocks/releases/luarocks-${LUAROCKS_VERSION}.tar.gz -O - | tar -xzf -
WORKDIR luarocks-$LUAROCKS_VERSION
RUN ./configure; make -j"$(nproc)" bootstrap
WORKDIR /
RUN rm -rf luarocks-$LUAROCKS_VERSION

RUN luarocks install luacheck
ENTRYPOINT ["luacheck"]
