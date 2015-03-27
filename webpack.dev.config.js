var lib = require.resolve('./src/index.coffee');
var HtmlWebpackPlugin = require('html-webpack-plugin');
var package = require('./package.json');

var config = {
  plugins: [new HtmlWebpackPlugin],
  name: package.name
};

module.exports = {
  devtool: 'source-map',
  entry: './src/index.coffee',
  output: {
    path: __dirname + '/dist',
    filename: config.name + '.js'
  },
  module: {
    loaders: [
      { test: lib, loaders: ['expose?' + config.name] },
      { test: /\.coffee/, loaders: ['coffee'] }
    ]
  },
  externals: {},
  resolve: {
    extensions: ['', '.coffee', '.js'],
    modulesDirectories: ['node_modules', '.']
  },
  plugins: config.plugins
};
