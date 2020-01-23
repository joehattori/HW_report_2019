FROM ghdl/ext:latest

ENV LANG C.UTF-8

ENV ROOT /winter-report
RUN mkdir -p ${ROOT}
WORKDIR ${ROOT}

ADD . ${ROOT}/
