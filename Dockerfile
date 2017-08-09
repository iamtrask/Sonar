FROM node:alpine
RUN ["npm", "install", "-g", "truffle"]
COPY . /truffle
WORKDIR /truffle
RUN ["truffle", "compile"]
