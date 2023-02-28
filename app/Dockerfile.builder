FROM ubuntu:22.04 as builder

RUN apt update && \
    apt install -y \
    bash curl file git unzip xz-utils zip libglu1-mesa wget \
    libgconf-2-4 gdb libstdc++6 fonts-droid-fallback python3 sed


RUN git clone https://github.com/flutter/flutter.git -b stable 
WORKDIR /app
ADD ./lib /app/lib
ADD ./test /app/test
ADD ./web /app/web
ADD ./pubspec.yaml /app/./pubspec.yaml

RUN /flutter/bin/flutter build web --release

FROM nginx:1.23.3
COPY --from=builder /app/build/web /usr/share/nginx/html