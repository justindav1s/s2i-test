# ib-tomcat-base
FROM  centos

MAINTAINER Justin Davis <justinndavis@gmail.com>

ENV BUILDER_VERSION 1.0

LABEL io.k8s.description="Image for building micro-service based tomcat deployments" \
      io.k8s.display-name="builder 1.0.0" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,1.0.0,tomcat,http" \
      io.openshift.s2i.scripts-url="image:///usr/libexec/s2i"


RUN rpm -ivh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-8.noarch.rpm
RUN yum -y install wget curl java-1.7.0-openjdk-devel git ansible pyOpenSSL libxml2 libxslt
RUN yum clean all -y

RUN mkdir -p /ib/appl
WORKDIR /ib/appl
RUN wget http://mirrors.ukfast.co.uk/sites/ftp.apache.org/tomcat/tomcat-7/v7.0.70/bin/apache-tomcat-7.0.70.tar.gz
RUN tar xvf apache-tomcat-7.0.70.tar.gz
RUN ln -s apache-tomcat-7.0.70 tomcat7

RUN mkdir -p /usr/libexec/s2i
COPY ./.s2i/bin/ /usr/libexec/s2i

RUN chgrp -R 0 /ib/appl
RUN chmod -R g+rw /ib/appl
RUN find /ib/appl -type d -exec chmod g+x {} +

USER 1001

EXPOSE 8080

CMD ["/usr/libexec/s2i/usage"]