FROM ubuntu
ARG BORE_TOKEN
ARG BORE_SERVER
ARG BORE_PORT
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y \
    ssh wget unzip vim curl
RUN wget -q https://github.com/ekzhang/bore/releases/download/v0.4.0/bore-v0.4.0-x86_64-unknown-linux-musl.tar.gz -O /bore.tar.gz\
    && cd / && tar -xf bore.tar.gz \
    && chmod +x bore
RUN mkdir /run/sshd \
    && echo "/bore local 22 --to ${BORE_SERVER} --secret ${BORE_TOKEN} --port ${BORE_PORT} &" >>/openssh.sh \
    && echo "sleep 5" >> /openssh.sh \
    && echo "echo 'Connected ${BORE_SERVER}:${BORE_PORT}'" >> /openssh.sh \
    && echo '/usr/sbin/sshd -D' >>/openssh.sh \
    && echo 'PermitRootLogin yes' >>  /etc/ssh/sshd_config  \
    && echo root:akashi520|chpasswd \
    && chmod 755 /openssh.sh
EXPOSE 80 443 3306 4040 5432 5700 5701 5010 6800 6900 8080 8888 9000
CMD /openssh.sh
