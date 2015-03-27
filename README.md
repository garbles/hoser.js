# Hoser.js

Hoser.js is a small JavaScript library (< 4kb minified) for creating observable data objects whose attributes can be lexically scoped.

## API Reference

#### Creating a new instance

Create a new instance in hoser by wrapping an object in `hoser`.

```js
var instance = hoser({ value: 'value', object: { deepValue: 'deepValue' } });
```

#### get

You can retreive any value by calling `#get` on a hoser instance.

```js
var instance = hoser({ key: 'value', object: { deepKey: 'deepValue' } });

instance.get('key');
// => 'value'

instance.get('object');
// => { deepKey: 'deepValue' }

instance.get('object.deepKey');
// => 'deepValue'
```

#### set

You can set any value by calling `#set` on a hoser instance. This also works for arbitrary levels of nesting.

```js
var instance = hoser({ key: 'value', object: { deepKey: 'deepValue' } });

instance.set('key', 'otherValue');
// => true

instance.set('object.deepKey', 'otherDeepValue');
// => true

instance.get('key');
// => 'otherValue'

instance.get('object.deepKey');
// => 'otherDeepValue'
```

#### watch

You can observe changes in a hoser instance by calling `#watch` with a callback. You cannot observe values that have not yet been defined.

```js
var instance = hoser({ key: 'value', object: { deepKey: 'deepValue' } });

instance.watch('object.deepKey', function (value) {
  // value is the new value of object.deepKey
});

instance.watch('object', function (value) {
  // value is the new value of object
});

instance.set('object.deepKey', 'otherDeepValue');
// => true
// both callbacks will be executed
```

#### unwatch

You can remove watchers on a hoser instance by calling `#unwatch`.

```js
var instance = hoser({ key: 'value', object: { deepKey: 'deepValue' } });
var someCallback = function () { /* ... */ };

instance.watch('key', someCallback);

instnace.unwatch('key', someCallback);
```

#### scope

Creating new scopes of your data can be done with `#scope`. When an instance is scoped, a new child object is returned which holds a reference to all
previous ancestors. This means that if an attribute is set on a parent object, it will immediately be available to all of it's children; however, the
inverse is not true when an attribute is set on a child object; that is, the new attribute is scoped to the child.

```js
var instance = hoser({ key: 'value', object: { deepKey: 'deepValue' } });
var scoped = instance.scope();

scoped.get('key');
// => 'value'

instance.set('key', 'otherValue');

scoped.get('key');
// => 'otherValue'

scoped.set('otherKey', 123);

instance.get('otherKey');
// => undefined
```

Observing changes is also determined by the scope where the attribute was created.

```js
var instance = hoser({ key: 'value', object: { deepKey: 'deepValue' } });
var scoped = instance.scope();

scoped.watch('key', function () {
  alert('this is an alert!');
});

instance.watch('key', function () {
  console.log('this is a log!');
});

instance.set('key', 'otherValue');
// => true
// alert will appear and console will log

scoped.set('key', 'yetAnotherValue');
// => true
// alert will appear and console will log
```
