docker login

docker build . -t lucasomena5/my-custom-app
docker push lucasomena5/my-custom-app

# layered architecture
1. base image
2. change in apt packages
3. changes in pip packages
4. source code 
5. update entrypoint

Check layer size
docker history lucasomena5/my-custom-app

# env variables
docker run -e APP_COLOR=blue simple-webapp-color

docker run -e APP_COLOR=green simple-webapp-color

docker run -e APP_COLOR=pink simple-webapp-color

