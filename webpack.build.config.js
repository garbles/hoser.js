var webpack = require('webpack');
var lib = require.resolve('./src/index.coffee');
var package = require('./package.json');

var config = {
  plugins: [],
  name: package.name
};

if (process.env.MINIFY) {
  config.plugins = config.plugins.concat([
    new webpack.optimize.UglifyJsPlugin(),
    new webpack.optimize.OccurenceOrderPlugin(),
    new webpack.optimize.AggressiveMergingPlugin()
  ]);

  config.name = config.name + '.min';
}

module.exports = {
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
  resolve: {
    extensions: ['', '.coffee', '.js'],
    modulesDirectories: ['node_modules', '.']
  },
  plugins: config.plugins
};
