jest.autoMockOff()

Scope = require('../scope')

describe 'Scope', ->
  instance = undefined

  beforeEach ->
    instance = new Scope({
      shallowValue: '123',
      shallowObject: {
        deepValue: '456',
        deepObject: {
          deeperValue: '789'
        }
      }
    }).freeze()

  it 'can get values', ->
    value = instance.get('shallowValue')
    expect(value).toEqual('123')

    value = instance.get('shallowObject.deepValue')
    expect(value).toEqual('456')

    value = instance.get('shallowObject.deepObject')
    expect(value).toEqual(deeperValue: '789')

  it 'can set values', ->
    value = instance.get('shallowValue')
    expect(value).toEqual('123')

    instance.set('shallowValue', 'chachacha')

    value = instance.get('shallowValue')
    expect(value).toEqual('chachacha')

  it.only 'can create scoped objects', ->
    scoped = instance.scope()

    scoped.set('otherShallowValue', [])

    value = instance.get('yetAnotherShallowValue')
    expect(value).toEqual(undefined)

    value = scoped.get('otherShallowValue')
    expect(value).toEqual([])

    instance.set('shallowValue', 'chachacha')
    value = scoped.get('shallowValue')
    expect(value).toEqual('chachacha')

    scoped.set('shallowValue', 'chachachacha')
    value = instance.get('shallowValue')
    expect(value).toEqual('chachachacha')

    instance.set('shallowObject.deepObject', { potato: 'fun' })
    value = scoped.get()

    expect(value).toEqual({
      otherShallowValue: [],
      shallowValue: 'chachachacha',
      shallowObject: {
        deepValue: '456',
        deepObject: {
          potato: 'fun'
        }
      }
    })

  it 'can watch and unwatch values', ->
    count = 0
    inc = -> count++

    instance.watch('shallowObject', inc)
    instance.watch('shallowObject.deepValue', inc)
    instance.set('shallowObject.deepValue', 'chachacha')
    instance.unwatch('shallowObject', inc)
    instance.set('shallowObject.deepValue', 'chachachacha')

    jest.runAllTimers()

    expect(count).toEqual(3)

  it 'can watch between scoped objects', ->
    count = 0
    scoped = instance.scope()

    scoped.watch('shallowObject', -> count++)
    instance.set('shallowObject.deepValue', 'chachacha')

    # should be ignored because yetAnotherShallowValue
    # is undefined on instance
    instance.watch('yetAnotherShallowValue', -> count++)
    scoped.set('yetAnotherShallowValue', 'chachacha')

    jest.runAllTimers()

    expect(count).toEqual(1)
