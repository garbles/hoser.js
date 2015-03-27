pathToArray = require('./path-to-array')
foldIntoSelf = (acc, key) -> acc?[key]

module.exports = getDeep = (path, object) ->
  keys = pathToArray(path)
  keys.reduce(foldIntoSelf, object)
