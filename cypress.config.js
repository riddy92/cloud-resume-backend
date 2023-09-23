const { defineConfig } = require('cypress')

module.exports = defineConfig({
  e2e: {
    // baseUrl, etc
    baseUrl: 'https://rhresume.com'
    // setupNodeEvents(on, config) {
    //   // implement node event listeners here
    //   // and load any plugins that require the Node environment
    // },
  }
})
