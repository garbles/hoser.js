'use strict';

var coffee = require('coffee-script');

exports.process = function (src, path) {
  if (path.match(/\.coffee/)) {
    return coffee.compile(src);
  } else {
    return src;
  }
};
