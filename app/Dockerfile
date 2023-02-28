FROM ubuntu:22.04 as builder

RUN apt update && \
    apt install -y \
    bash curl file git unzip xz-utils zip libglu1-mesa 

RUN git clone https://github.com/flutter/flutter.git -b stable

WORKDIR /app
ADD ./lib lib/
ADD ./test test/
ADD ./web web/
ADD ./pubspec.yaml pubspec.yaml
ENV PATH=$PATH:/flutter/bin/

RUN flutter doctor
RUN flutter precache --web

RUN flutter build web --release 

FROM nginx:1.23.3
COPY --from=builder /app/build/web /usr/share/nginx/html