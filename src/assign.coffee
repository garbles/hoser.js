module.exports = assign = (base, objects...) ->
  for object in objects
    for own key, value of object
      base[key] = value

  base
