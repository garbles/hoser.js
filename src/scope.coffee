assign = require('./assign')
CallbackStore = require('./callback-store')
cloneDeep = require('./clone-deep')
getDeep = require('./get-deep')
pathToArray = require('./path-to-array')
setDeep = require('./set-deep')
autoBind = require('./auto-bind')

CALLBACKS_KEY = '_______CALLBACKS_KEY_______'

module.exports =
class Scope
  constructor: (@_object, @_parent = undefined) ->
    @_callbackStore = new CallbackStore
    autoBind(@)

  scope: ->
    child = new Scope({}, @)
    child.freeze()

  freeze: ->
    { get, set, watch, unwatch, scope } = @
    Object.freeze({ get, set, watch, unwatch, scope })

  get: (path) ->
    result = if path != undefined
               keys = pathToArray(path)
               owner = @_getOwner(keys[0]) || @
               owner._getValue(keys)
             else
               @_foldSelfIntoParent()

    cloneDeep(result)

  set: (path, value) ->
    keys = pathToArray(path)
    owner = @_getOwner(keys[0]) || @

    owner._setValue(keys, value)
    owner._emit(keys)
    true

  watch: (path, callback) ->
    keys = pathToArray(path)
    owner = @_getOwner(keys[0])

    result = owner?._setCallback(keys, callback)
    !!result

  unwatch: (path, callback) ->
    keys = pathToArray(path)
    owner = @_getOwner(keys[0])
    owner?._unsetCallback(keys, callback)
    true

  _getOwner: (key) ->
    if @_object[key] != undefined
      @
    else
      @_parent?._getOwner(key)

  _getValue: (keys) ->
    getDeep(keys, @_object)

  _setValue: (keys, value) ->
    setDeep(keys, value, @_object)

  _emit: (keys) ->
    value = @_getValue(keys)
    @_callbackStore.run(keys, value)

    @_emit(keys[0...keys.length-1]) if keys.length > 1
    true

  _unsetCallback: (keys, callback) ->
    @_callbackStore.unset(keys, callback)
    true

  _setCallback: (keys, callback) ->
    @_callbackStore.set(keys, callback)
    true

  _foldSelfIntoParent: ->
    foldParentIntoGrandparent = @_parent?._foldSelfIntoParent() || {}
    assign({}, foldParentIntoGrandparent, @_object)
