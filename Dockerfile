FROM node:8-alpine
RUN npm install -g ethereumjs-testrpc
COPY build/testrpc_persist /data/persist
EXPOSE 8545
CMD [ "testrpc","--db","/data/persist","--seed","20170812","--accounts","42"]