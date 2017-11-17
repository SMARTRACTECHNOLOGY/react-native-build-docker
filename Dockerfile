FROM openjdk:8

LABEL maintainer="SMART COSMOS Platform Core Team" \
      version="1.0"

ENV ANDROID_SDK_URL="https://dl.google.com/android/repository/tools_r25.0.2-linux.zip" \
    ANDROID_BUILD_TOOLS_VERSION_26="build-tools-26.0.0,build-tools-26.0.1,build-tools-26.0.2,build-tools-26.0.3" \
    ANDROID_BUILD_TOOLS_VERSION_25="build-tools-25.0.0,build-tools-25.0.1,build-tools-25.0.2,build-tools-25.0.3" \
    ANDROID_BUILD_TOOLS_VERSION_24="build-tools-24.0.0,build-tools-24.0.1,build-tools-24.0.2,build-tools-24.0.3" \
    ANDROID_BUILD_TOOLS_VERSION_23="build-tools-23.0.0,build-tools-23.0.1,build-tools-23.0.2,build-tools-23.0.3" \
    ANDROID_APIS="android-17,android-18,android-19,android-20,android-21,android-22,android-23,android-24,android-25,android-26" \
    GRADLE_HOME="/usr/share/gradle" \
    ANDROID_HOME="/opt/android" \
    NODEJS_HOME="/nodejs" \
    BABEL_DISABLE_CACHE=1

ENV PATH $PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools/$ANDROID_BUILD_TOOLS_VERSION:$GRADLE_HOME/bin:$NODEJS_HOME/bin

WORKDIR /opt

# Install gradle
RUN dpkg --add-architecture i386 && \
    apt-get -qq update && \
    apt-get -qq install -y wget curl gradle libncurses5:i386 libstdc++6:i386 zlib1g:i386

# Install Android SDK
RUN mkdir android && cd android && \
    wget -O tools.zip ${ANDROID_SDK_URL} && \
    unzip tools.zip && rm tools.zip && \
    echo y | android update sdk --no-ui --all --filter extra-android-m2repository && \
    echo y | android update sdk --no-ui --all --filter platform-tools && \
    echo y | android update sdk --no-ui --all --filter ${ANDROID_APIS} && \
    echo y | android update sdk --no-ui --all --filter ${ANDROID_BUILD_TOOLS_VERSION_26} && \
    echo y | android update sdk --no-ui --all --filter ${ANDROID_BUILD_TOOLS_VERSION_25} && \
    echo y | android update sdk --no-ui --all --filter ${ANDROID_BUILD_TOOLS_VERSION_24} && \
    echo y | android update sdk --no-ui --all --filter ${ANDROID_BUILD_TOOLS_VERSION_23} && \
    chmod a+x -R $ANDROID_HOME && \
    chown -R root:root $ANDROID_HOME

# Install nodejs
RUN apt-get update -y && apt-get install --no-install-recommends -y -q curl python build-essential git ca-certificates && \
    mkdir /nodejs && \
    curl http://nodejs.org/dist/v8.9.1/node-v8.9.1-linux-x86.tar.gz | tar xvzf - -C /nodejs --strip-components=1 && \
    chown -R 1000 /nodejs

# Install yarn
RUN npm install --global yarn

# Clean up steps
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    apt-get autoremove -y && \
    apt-get clean

# Add 1000 user/group to get git working
RUN groupadd --gid 1000 node && \
    useradd --uid 1000 --gid node --shell /bin/bash --create-home /nodejs
