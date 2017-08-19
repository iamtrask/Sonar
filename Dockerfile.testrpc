FROM node:8-alpine
COPY package.json truffle.js init_testrpc.sh ./
COPY contracts/ ./contracts/
COPY migrations/ ./migrations/
WORKDIR ./
RUN sh init_testrpc.sh
EXPOSE 8545
CMD [ "./node_modules/.bin/testrpc","--host", "0.0.0.0", "--db","/data/testrpc_persist","--seed","20170812","--accounts","42","--debug"]
