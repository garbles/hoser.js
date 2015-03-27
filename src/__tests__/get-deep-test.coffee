jest.autoMockOff()

getDeep = require('../get-deep')

describe 'getDeep', ->
  object = {
    shallowValue: '123'
    shallowObject: {
      deepValue: '456',
      deepObject: {
        deeperValue: '789'
      }
    }
  }

  it 'gets values based on dot seperated keys', ->
    value = getDeep(undefined, object)
    expect(value).toEqual(object)

    value = getDeep('shallowValue', object)
    expect(value).toEqual('123')

    value = getDeep('shallowObject', object)
    expect(value).toEqual(object.shallowObject)

    value = getDeep('shallowObject.deepValue', object)
    expect(value).toEqual('456')

    value = getDeep('shallowObject.deepObject.deeperValue', object)
    expect(value).toEqual('789')

    value = getDeep('shallowObject.deepObject', object)
    expect(value).toEqual(object.shallowObject.deepObject)

    value = getDeep('undefined', object)
    expect(value).toEqual(undefined)

    value = getDeep('undefined.veryUndefined', object)
    expect(value).toEqual(undefined)

  it 'gets values based on an array of keys', ->
    value = getDeep(['shallowValue'], object)
    expect(value).toEqual('123')

    value = getDeep(['shallowObject'], object)
    expect(value).toEqual(object.shallowObject)

    value = getDeep(['shallowObject', 'deepValue'], object)
    expect(value).toEqual('456')

    value = getDeep(['shallowObject', 'deepObject', 'deeperValue'], object)
    expect(value).toEqual('789')

    value = getDeep(['shallowObject', 'deepObject'], object)
    expect(value).toEqual(object.shallowObject.deepObject)

    value = getDeep(['undefined'], object)
    expect(value).toEqual(undefined)

    value = getDeep(['undefined', 'veryUndefined'], object)
    expect(value).toEqual(undefined)
