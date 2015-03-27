pathToArray = require('./path-to-array')

module.exports = setDeep = (path, value, object = {}) ->
  keys = pathToArray(path)
  prop = keys[0]

  object[prop] = if keys.length > 1
                   setDeep(keys[1..], value, object[prop] || {})
                 else
                   value

  object
