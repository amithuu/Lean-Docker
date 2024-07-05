FROM node:13-alpine

ENV  MONGO_DB_USERNAME =admin \
    MONGO_DB_PWD = password

RUN mkdir -p /home/app

COPY . /home/app

# COPY ./app /home/app # as all our main files are inside the app folder to tun the FE.

CMD ["node", "/home/app/server.js"]

