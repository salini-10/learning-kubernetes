#FROM    nginx
#ADD     index.html /usr/share/nginx/html/index.html

FROM     centos:7
RUN     yum install epel-release -y
RUN     yum install nginx -y
EXPOSE  80
ENTRYPOINT ["nginx", "-g", "daemon off;"]
