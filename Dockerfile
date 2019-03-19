FROM alpine:latest

ENV LUA_VERSION 5.3.5
ENV LUAROCKS_VERSION 3.0.4

RUN apk add --update --no-cache readline-dev libc-dev make gcc wget git zip unzip md5sum

RUN wget https://www.lua.org/ftp/lua-${LUA_VERSION}.tar.gz -O - | tar -xzf -
WORKDIR lua-$LUA_VERSION
RUN make -j"$(nproc)" linux; make install
RUN cd / && rm -rf lua-${LUA_VERSION}

RUN wget https://luarocks.github.io/luarocks/releases/luarocks-${LUAROCKS_VERSION}.tar.gz -O - | tar -xzf -
RUN cd luarocks-$LUAROCKS_VERSION && ./configure; make -j"$(nproc)" bootstrap
RUN cd / && rm -rf luarocks-$LUAROCKS_VERSION

RUN luarocks install luacheck
ENTRYPOINT ["luacheck"]
