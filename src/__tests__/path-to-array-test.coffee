jest.autoMockOff()

pathToArray = require('../path-to-array')

describe 'pathToArray', ->
  it 'converts a dot seperated list of keys to an array', ->
    value = pathToArray('a.b.c.d')
    expect(value).toEqual(['a', 'b', 'c', 'd'])

  it 'does nothing with an array', ->
    value = pathToArray(['a', 'b', 'c', 'd'])
    expect(value).toEqual(['a', 'b', 'c', 'd'])
