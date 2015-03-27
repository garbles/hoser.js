module.exports = pathToArray = (path = []) ->
  if Array.isArray(path)
    path
  else
    path.split('.')
