FROM node:6.10.0
MAINTAINER Samuel Loza <starsaminf@gmail.com>

# install some common dependencies
RUN npm install --unsafe-perm -g @angular/cli@1.0.0-beta.30 findup-sync typescript 


WORKDIR /usr/src/app
VOLUME /usr/src/app
EXPOSE 4200

# compile the app and run it
CMD npm install && npm start
