module.exports = autoBind = (instance) ->
  funcs = Object.keys(instance.constructor.prototype)

  funcs
    .filter (func) ->
      typeof instance[func] == 'function'
    .forEach (func) ->
      instance[func] = instance[func].bind(instance)
