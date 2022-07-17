module.exports = {
  entry: {
    application: "./app/javascript/application.js",
    admin: "./app/javascript/admin.js"
  },
  module: {
    rules: [
      {
        test: /\.(js)$/,
        exclude: /node_modules/,
        use: ['babel-loader']
      }
    ]
  }
}
