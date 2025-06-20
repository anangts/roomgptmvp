FROM cirrusci/flutter:3.8.1

# Install Android dependencies
RUN apt-get update && apt-get install -y curl unzip xz-utils git zip libglu1-mesa openjdk-17-jdk

# Android SDK setup
ENV ANDROID_SDK_ROOT="/opt/android-sdk"
ENV PATH="${PATH}:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools"

RUN mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools \
    && curl -o sdk.zip https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip \
    && unzip sdk.zip -d ${ANDROID_SDK_ROOT}/cmdline-tools \
    && mv ${ANDROID_SDK_ROOT}/cmdline-tools/cmdline-tools ${ANDROID_SDK_ROOT}/cmdline-tools/latest \
    && rm sdk.zip

# Accept licenses
RUN yes | sdkmanager --licenses

# Install Android build components
RUN sdkmanager "platform-tools" "platforms;android-33" "build-tools;33.0.2"

# Set working directory
WORKDIR /app

# Copy project files
COPY . .

# Get dependencies
RUN flutter pub get

# Build both targets!
RUN flutter build apk --release
RUN flutter build web

# Final output:
# - Android APK: build/app/outputs/flutter-apk/app-release.apk
# - Web:         build/web/
