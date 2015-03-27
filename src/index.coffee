Scope = require('./scope')

module.exports = hoser = (object) ->
  instance = new Scope(object)
  instance.freeze()
