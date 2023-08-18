FROM nginx:1.19.10

USER root

# Unecessary softwares
#RUN apt-get update && apt-get install -y wget
RUN useradd -ms /bin/bash nginxuser

# Exposed password inside Dockerfile
#ENV db_password=Mellon

# Using root user to run the application
#USER root
USER nginxuser

ENTRYPOINT ["/docker-entrypoint.sh"]
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]