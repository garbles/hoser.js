jest.autoMockOff()

setDeep = require('../set-deep')

describe 'setDeep', ->
  object = undefined

  beforeEach ->
    object = {}

  it 'sets values based on dot seperated keys', ->
    setDeep('shallowValue', '123', object)
    expect(object.shallowValue).toEqual('123')

    setDeep('shallowObject.deepValue', '456', object)
    setDeep('shallowObject.otherDeepValue', '789', object)
    expect(object.shallowObject).toEqual(deepValue: '456', otherDeepValue: '789')
    expect(object.shallowValue).toEqual('123')

    setDeep('shallowObject.deepObject.deeperValue', '0', object)
    expect(object.shallowObject.deepObject).toEqual(deeperValue: '0')

  it 'sets values based on an array of keys', ->
    setDeep(['shallowValue'], '123', object)
    expect(object.shallowValue).toEqual('123')

    setDeep(['shallowObject', 'deepValue'], '456', object)
    setDeep(['shallowObject', 'otherDeepValue'], '789', object)
    expect(object.shallowObject).toEqual(deepValue: '456', otherDeepValue: '789')
    expect(object.shallowValue).toEqual('123')

    setDeep(['shallowObject', 'deepObject', 'deeperValue'], '0', object)
    expect(object.shallowObject.deepObject).toEqual(deeperValue: '0')
