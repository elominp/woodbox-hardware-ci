FROM debian:latest
MAINTAINER Guillaume Pirou <guillaume.pirou@epitech.eu>

ENV ARDUINO_VER 1.8.5

ENV ENERGIA_VER 1.6.10E18

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y ca-certificates apt-transport-https vim nano \
    build-essential git xvfb wget xz-utils \
    libxext6 libxtst6 libxrender1 libgtk2.0.0 default-jre libelf-dev \
    gcc-avr avr-libc freeglut3-dev elfutils libelf1 libglib2.0-dev gdb-avr make && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
    
RUN wget http://downloads.arduino.cc/arduino-${ARDUINO_VER}-linux64.tar.xz && \
    tar xf arduino-${ARDUINO_VER}-linux64.tar.xz && \
    mv arduino-${ARDUINO_VER} /usr/local/share/arduino && \
    ln -s /usr/local/share/arduino/arduino /usr/local/bin/arduino && \
    rm -rf arduino-${ARDUINO_VER}-linux64.tar.xz

RUN wget wget http://energia.nu/downloads/downloadv4.php?file=energia-${ENERGIA_VER}-linux64.tar.xz && \
    tar xf energia-${ENERGIA_VER}-linux64.tar.xz && \
    mv energia-${ENERGIA_VER} /usr/local/share/energia && \
    ln -s /usr/local/share/energia/energia /usr/local/bin/energia && \
    rm -rf energia-${ENERGIA_VER}-linux64.tar.xz

RUN git clone https://github.com/Seeed-Studio/Grove_Digital_Light_Sensor.git

RUN git clone https://github.com/pjpmarques/ChainableLED.git

RUN git clone https://github.com/Seeed-Studio/Grove_Air_quality_Sensor.git

RUN git clone https://github.com/bblanchon/ArduinoJson.git

RUN git clone https://github.com/mmurdoch/arduinounit.git

RUN ln -s $PWD/Grove_Digital_Light_Sensor /usr/local/share/arduino/libraries/Grove_Digital_Light_Sensor && \
    ln -s $PWD/ChainableLED /usr/local/share/arduino/libraries/ChainableLED && \
    ln -s $PWD/Grove_Air_quality_Sensor /usr/local/share/arduino/libraries/Grove_Air_quality_Sensor && \
    ln -s $PWD/ArduinoJson /usr/local/share/arduino/libraries/ArduinoJson && \
    ln -s $PWD/arduinounit /usr/local/share/arduino/libraries/ArduinoUnit && \
    ln -s $PWD /usr/local/share/arduino/libraries/woodBox && \
    ln -s $PWD/Grove_Digital_Light_Sensor /usr/local/share/energia/libraries/Grove_Digital_Light_Sensor && \
    ln -s $PWD/ChainableLED /usr/local/share/arduino/energia/ChainableLED && \
    ln -s $PWD/Grove_Air_quality_Sensor /usr/local/share/energia/libraries/Grove_Air_quality_Sensor && \
    ln -s $PWD/ArduinoJson /usr/local/share/arduino/energia/ArduinoJson && \
    ln -s $PWD/arduinounit /usr/local/share/arduino/energia/ArduinoUnit && \
    ln -s $PWD /usr/local/share/energia/libraries/woodBox

RUN arduino --install-boards arduino:sam && \
    arduino --install-boards arduino:samd && \
    arduino --install-boards chipKIT:pic32 && \
    energia --install-boards energia:msp430 && \
    energia --install-boards energia:msp432 && \
    arduino --install-library "Adafruit NeoPixel" && \
    energia --install-library "Adafruit NeoPixel"

COPY platforms/msp430/platform.txt ~/.energia15/packages/energia/hardware/msp430/1.0.3/platform.txt

COPY platforms/msp432/platform.txt ~/.energia15/packages/energia/hardware/msp432/3.8.0/platform.txt

RUN git clone https://github.com/buserror/simavr.git && \
    cd ./simavr && make && make install ; cd - && rm -rf simavr

COPY entrypoint /usr/bin

RUN chmod +x /usr/bin/entrypoint && mkdir /build

ENTRYPOINT ["entrypoint"]
