module.exports = {
  networks: {
    development: {
      host: 'localhost',
      port: 8545,
      network_id: 'default'
    },
    docker: {
      host: 'testrpc',
      port: 8545,
      network_id: 25189
    }
  }
}
