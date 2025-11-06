# Build stage: build the Flutter web app
# Explicitly request amd64 platform to avoid platform mismatch / Dart VM segfaults
# when building on Apple Silicon (arm64) hosts. When building locally on an M1/M2
# machine prefer using `docker buildx build --platform linux/amd64 ...` so QEMU
# emulation is used for the amd64 Flutter SDK.
FROM --platform=linux/amd64 cirrusci/flutter:stable AS builder
WORKDIR /app

# Copy project sources (expecting Snowledge/ at same level as this Dockerfile)
COPY Snowledge/ .

# Get dependencies and build web release
RUN flutter pub get
RUN flutter build web --release

# Serve stage: use nginx to serve the built web app
FROM nginx:alpine
# Remove default html
RUN rm -rf /usr/share/nginx/html/*
# Copy built web files from builder
COPY --from=builder /app/build/web /usr/share/nginx/html

# Expose default HTTP port
EXPOSE 80

# Run nginx in foreground
CMD ["nginx", "-g", "daemon off;"]