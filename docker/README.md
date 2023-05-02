#
# volumes
#
docker volume create data_volume

docker run -v data_volume:/var/lib/mysql mysql 
# data_volume is located in /var/lib/docker/volumes/data_volume

docker run -v data_volume2:/var/lib/mysql mysql 

docker run -v /data/mysql:/var/lib/mysql mysql
# /data/mysql will be created under /var/lib/docker/volumes/mysql

# new way to create volumes
docker run --mount type=bind,source=/data/mysql,target=/var/lib/mysql mysql

# mysql
docker run -d -e MYSQL_ROOT_PASSWORD=db_pass123 --name mysql-db mysql

###################################################################################################
id      Name    Phone   Email
1       Kareem  130-5655        Duis.volutpat.nunc@quamCurabitur.org
2       Ruby    1-584-149-0770  Nulla.tempor@vitaeorciPhasellus.org
3       Rowan   199-8663        consectetuer.adipiscing.elit@Sedmalesuada.co.uk
4       Alisa   220-6017        elementum.sem.vitae@enimMauris.edu
5       Ella    731-0337        fermentum@nec.net
6       Tiger   658-4480        quis.diam@odiovelest.net
7       Felix   1-274-848-3378  Mauris.vel@arcu.com
8       Karina  1-390-796-3451  sagittis.semper@odioapurus.co.uk
9       Davis   605-8539        venenatis.vel@risusDonecnibh.com
10      Mohammad        1-590-174-1489  ornare.sagittis.felis@natoque.ca
11      Zane    362-1770        Aenean.euismod@condimentum.co.uk
12      Piper   1-231-386-6903  nunc.sed.pede@nascetur.ca
13      Marshall        1-383-729-4990  Cras.interdum.Nunc@neceuismod.ca
14      Zena    241-6641        Fusce.mollis.Duis@lobortis.org
15      Abdul   1-748-387-9935  eget.lacus.Mauris@Crasvehicula.com
16      Chase   1-401-241-9169  ante.dictum.mi@nascetur.org
17      Zahir   921-0663        non@nonummyutmolestie.edu
18      Brenda  1-691-909-5827  Quisque.ac@magnaCras.co.uk
19      Laura   1-562-983-9565  Quisque.ornare.tortor@sollicitudinadipiscing.ca
20      Madison 1-348-737-0587  Quisque.varius@Intinciduntcongue.org
21      Tanek   991-6278        dignissim.magna@Pellentesqueutipsum.net
22      Dakota  893-0792        Nullam.enim.Sed@nulla.net
23      Boris   1-297-302-5792  non.sollicitudin@eleifendegestasSed.co.uk
24      Celeste 723-6729        mauris.rhoncus@eunulla.edu
25      Connor  1-203-901-7531  et@loremipsumsodales.edu
26      Perry   1-756-607-9187  eros.turpis@tristiquepharetra.co.uk
27      Hayfa   1-609-407-3019  non.lobortis.quis@malesuadafringilla.net
28      Todd    343-0454        id.erat@arcu.org
29      Fuller  881-7273        non.feugiat.nec@adipiscingelit.net
30      Rama    1-927-605-0610  nonummy.ultricies.ornare@malesuada.co.uk
###################################################################################################

# check data
docker exec mysql-db mysql -pdb_pass123 -e 'use foo; select * from myTable'

# database crashed and we lost data, map a volume 
docker run -d -v /opt/data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=db_pass123 --name=mysql-db mysql

#
# network
#
docker run ubuntu
docker run ubuntu --network=none
docker run ubuntu --network=host

docker network create --driver bridge --subnet 182.18.0.0/16 custom-isolated-network
docker network ls 

docker inspect <container-name>

docker run -d --name webapp --network wp-mysql-network -p 38080:8080 -e DB_Password=db_pass123 -e DB_Host=mysql-db kodekloud/simple-webapp-mysql

#
# registry
#
docker image tag my-image localhost:5000/my-image
docker pull localhost:5000/my-image
docker pull 192.168.56.100:5000/my-image

# create your own repo
docker run -d -p 5000:5000 --restart=always --name my-registry registry:2

docker pull nginx:latest
docker pull httpd:latest

docker image tag nginx:latest localhost:5000/nginx:latest
docker pull localhost:5000/nginx:latest

docker image tag httpd:latest localhost:5000/httpd:latest
docker pull localhost:5000/httpd:latest


# push new image to local repository
docker build . -t blue:v1
docker image tag blue:v1 localhost:5000/blue:v1
docker push localhost:5000/blue:v1
curl -X GET localhost:5000/v2/_catalog

