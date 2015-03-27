jest.autoMockOff()

cloneDeep = require('../clone-deep')

describe 'cloneDeep', ->
  it 'clones objects', ->
    object = {
      date: new Date,
      object: { a: { b: 1 } },
      value: 'value'
    }

    clone = cloneDeep(object)

    clone.date = (new Date)
    clone.date.setYear(1999)
    clone.object.a.b = 123
    clone.value = 'other'

    expect(clone.date).not.toEqual(object.date)
    expect(clone.object.a.b).not.toEqual(object.object.a.b)
    expect(clone.value).not.toEqual(object.value)
