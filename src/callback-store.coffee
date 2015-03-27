getDeep = require('./get-deep')
setDeep = require('./set-deep')
cloneDeep = require('./clone-deep')
pathToArray = require('./path-to-array')

CALLBACKS_KEY = '_______CALLBACKS_KEY_______'

pathToCallbacks = (path) ->
  keys = pathToArray(path)
  keys.concat(CALLBACKS_KEY)

module.exports =
class CallbackStore

  constructor: ->
    @_callbacks = {}

  get: (path) ->
    keys = pathToCallbacks(path)
    getDeep(keys, @_callbacks) || []

  set: (path, callback) ->
    keys = pathToCallbacks(path)
    callbacks = @get(path)

    setDeep(
      keys,
      callbacks.concat(callback),
      @_callbacks
    )
    true

  unset: (path, callback) ->
    callbacks = @get(path)

    index = callbacks.indexOf(callback)
    callbacks.splice(index, 1)
    true

  run: (path, value) ->
    callbacks = @get(path)

    callbacks.forEach (callback) ->
      clone = cloneDeep(value)
      callback(clone)
