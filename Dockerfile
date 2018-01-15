FROM node:alpine
RUN ["npm", "install", "-g", "truffle@^4.0.4"]
COPY . /sonar
WORKDIR /sonar
RUN ["truffle", "compile"]
