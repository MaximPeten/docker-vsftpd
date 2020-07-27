FROM centos:7

ARG USER_ID=14
ARG GROUP_ID=50

ENV PASV_ADDR_RESOLVE YES
ENV PASV_ENABLE YES
ENV PASV_MIN_PORT 21100
ENV PASV_MAX_PORT 21110
ENV XFERLOG_STD_FORMAT NO
ENV FILE_OPEN_MODE 0666
ENV LOCAL_UMASK 077
ENV REVERSE_LOOKUP_ENABLE YES

RUN yum -y update \
	&& yum clean all \
	&& yum install -y \
	vsftpd \
	db4-utils \
	db4 \
	iproute \
	&& yum clean all \
	&& usermod -u ${USER_ID} ftp \
	&& groupmod -g ${GROUP_ID} ftp \
	&& mkdir -p /home/vsftpd/ \
	&& chown -R ftp:ftp /home/vsftpd/

COPY vsftpd.conf /etc/vsftpd/
COPY vsftpd_virtual /etc/pam.d/
COPY docker-entrypoint.sh /usr/sbin/

EXPOSE 20 21

CMD ["/usr/sbin/docker-entrypoint.sh"]
