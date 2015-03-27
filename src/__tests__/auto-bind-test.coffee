jest.autoMockOff()

autoBind = require('../auto-bind')

describe 'autoBind', ->
  it 'automatically bindings all instance functions to the instance', ->
    value = 'value'

    class Stub
      a: value
      func: ->
        @a

    instance = new Stub
    func = instance.func

    expect(func()).toEqual(undefined)

    autoBind(instance)
    func = instance.func

    expect(func()).toEqual(value)
