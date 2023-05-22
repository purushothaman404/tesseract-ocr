FROM amazoncorretto:11 as build
RUN yum update -y &&\
    yum -y -q install wget &&\
    yum install -y gcc gcc-c++ autoconfig automake make pkgconfig libtool gzip tar&&\
    yum install -y zlib-devel libtiff-devel libwebp-devel libpng-devel  openjpeg2-devel lib-jpeg-turbo-devel giflib-devel &&\
    yum clean all &&\
    rm -rf /var/cache/yum

RUN wget -q https://github.com/DanBloomberg/leptonica/archive/refs/tags/1.82.0.tar.gz \
    && tar -zxvf 1.82.0.tar.gz -C /opt \
    && rm -f 1.82.0.tar.gz

WORKDIR /opt/leptonica-1.82.0
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/usr/local/lib
RUN ./autogen.sh
RUN ./configure
RUN make && make install

ENV PKG_CONFIG_PATH $PKG_CONFIG_PATH:/usr/local/lib/pkgconfig
RUN wget -q https://github.com/tesseract-ocr/tesseract/archive/5.2.0.tar.gz \
    && tar -zxvf 5.2.0.tar.gz -C /opt \
    && rm -f 5.2.0.tar.gz

WORKDIR /opt/tesseract-5.2.0
RUN ./autogen.sh
RUN ./configure
RUN make && make install

RUN wget https://github.com/tesseract-ocr/tessdata/raw/main/eng.traineddata -P /opt/
RUN wget https://github.com/tesseract-ocr/tessdata/raw/main/osd.traineddata -P /opt/


FROM amazoncorretto:11

WORKDIR /opt

ARG ARG_LD_LIBRARY_PATH=/usr/local/lib
ENV LD_LIBRARY_PATH ${ARG_LD_LIBRARY_PATH}
ENV PKG_CONFIG_PATH ${LIBRARY_PATH}/pkgconfig
ARG ARG_TESSDATA_PREFIX=/usr/local/share/tessdata
ENV TESSDATA_PREFIX ${ARG_TESSDATA_PREFIX}

COPY --from=build /usr/local/lib/libtesseract.so.5.0.2 ${ARG_LD_LIBRARY_PATH}/
COPY --from=build /usr/local/lib/liblept.so.5.0.4 ${ARG_LD_LIBRARY_PATH}/
COPY --from=build /lib64/libjpeg.so.62.3.0 ${ARG_LD_LIBRARY_PATH}/
COPY --from=build /lib64/libtiff.so.5.2.0 ${ARG_LD_LIBRARY_PATH}/
COPY --from=build /lib64/libwebp.so.4.0.2 ${ARG_LD_LIBRARY_PATH}/
COPY --from=build /lib64/libopenjp2.so.2.4.0 ${ARG_LD_LIBRARY_PATH}/
COPY --from=build /lib64/libgomp.so.1.0.0 ${ARG_LD_LIBRARY_PATH}/
COPY --from=build /lib64/libjbig.so.2.0 ${ARG_LD_LIBRARY_PATH}/

COPY --from=build /opt/*.traineddata ${ARG_TESSDATA_PREFIX}/

RUN echo ${ARG_LD_LIBRARY_PATH} >> /etc/ld.so.conf
RUN ldconfig

WORKDIR /app
COPY ./src/main/resources/static/tesseract.png tesseract.png
COPY ./src/main/resources/static/tesseract.pdf tesseract.pdf
COPY ./build/libs/tesseract-ocr-0.0.1.jar tesseract-ocr.jar

EXPOSE 8080
CMD ["java", "-jar", "tesseract-ocr.jar"]