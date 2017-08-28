FROM node:alpine
RUN ["npm", "install", "-g", "truffle"]
COPY . /sonar
WORKDIR /sonar
RUN ["truffle", "compile"]
