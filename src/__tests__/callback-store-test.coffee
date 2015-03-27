jest.autoMockOff()

CallbackStore = require('../callback-store')

describe 'CallbackStore', ->
  instance = undefined

  beforeEach ->
    instance = new CallbackStore

  it 'sets callbacks', ->
    path = 'a.b.c'
    cb = ->
    cb2 = ->

    instance.set(path, cb)
    instance.set(path, cb2)
    callbacks = instance.get(path)

    expect(callbacks).toEqual([cb, cb2])

  it 'unsets callbacks', ->
    path = 'a.b.c'
    cb = ->

    instance.set(path, cb)
    instance.unset(path, cb)

    callbacks = instance.get(path)
    expect(callbacks).toEqual([])

    instance.set(path, cb)
    instance.unset(path + '.d', cb)

    callbacks = instance.get(path)
    expect(callbacks).toEqual([cb])

  it 'runs all callbacks', ->
    path = 'a.b.c'
    cb = jest.genMockFn()
    cb2 = jest.genMockFn()

    instance.set(path, cb)
    instance.set(path, cb2)
    instance.set(path + '.d', cb2)

    instance.run(path)
    expect(cb.mock.calls.length).toEqual(1)
    expect(cb2.mock.calls.length).toEqual(1)

    instance.run(path + '.d')
    expect(cb.mock.calls.length).toEqual(1)
    expect(cb2.mock.calls.length).toEqual(2)
