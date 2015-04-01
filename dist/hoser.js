/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};

/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {

/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId])
/******/ 			return installedModules[moduleId].exports;

/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			exports: {},
/******/ 			id: moduleId,
/******/ 			loaded: false
/******/ 		};

/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);

/******/ 		// Flag the module as loaded
/******/ 		module.loaded = true;

/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}


/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;

/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;

/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";

/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(0);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ function(module, exports, __webpack_require__) {

	/* WEBPACK VAR INJECTION */(function(global) {module.exports = global["hoser"] = __webpack_require__(1);
	/* WEBPACK VAR INJECTION */}.call(exports, (function() { return this; }())))

/***/ },
/* 1 */
/***/ function(module, exports, __webpack_require__) {

	var Scope, hoser;

	Scope = __webpack_require__(2);

	module.exports = hoser = function(object) {
	  var instance;
	  instance = new Scope(object);
	  return instance.freeze();
	};


/***/ },
/* 2 */
/***/ function(module, exports, __webpack_require__) {

	var CALLBACKS_KEY, CallbackStore, Scope, assign, autoBind, cloneDeep, getDeep, pathToArray, setDeep;

	assign = __webpack_require__(3);

	CallbackStore = __webpack_require__(4);

	cloneDeep = __webpack_require__(5);

	getDeep = __webpack_require__(6);

	pathToArray = __webpack_require__(7);

	setDeep = __webpack_require__(8);

	autoBind = __webpack_require__(9);

	CALLBACKS_KEY = '_______CALLBACKS_KEY_______';

	module.exports = Scope = (function() {
	  function Scope(_object, _parent) {
	    this._object = _object;
	    this._parent = _parent != null ? _parent : void 0;
	    this._callbackStore = new CallbackStore;
	    autoBind(this);
	  }

	  Scope.prototype.scope = function() {
	    var child;
	    child = new Scope({}, this);
	    return child.freeze();
	  };

	  Scope.prototype.freeze = function() {
	    var get, scope, set, unwatch, watch;
	    get = this.get, set = this.set, watch = this.watch, unwatch = this.unwatch, scope = this.scope;
	    return Object.freeze({
	      get: get,
	      set: set,
	      watch: watch,
	      unwatch: unwatch,
	      scope: scope
	    });
	  };

	  Scope.prototype.get = function(path) {
	    var keys, owner, result;
	    result = path !== void 0 ? (keys = pathToArray(path), owner = this._getOwner(keys[0]) || this, owner._getValue(keys)) : this._foldSelfIntoParent();
	    return cloneDeep(result);
	  };

	  Scope.prototype.set = function(path, value) {
	    var keys, owner;
	    keys = pathToArray(path);
	    owner = this._getOwner(keys[0]) || this;
	    owner._setValue(keys, value);
	    owner._emit(keys);
	    return true;
	  };

	  Scope.prototype.watch = function(path, callback) {
	    var keys, owner, result;
	    keys = pathToArray(path);
	    owner = this._getOwner(keys[0]);
	    result = owner != null ? owner._setCallback(keys, callback) : void 0;
	    return !!result;
	  };

	  Scope.prototype.unwatch = function(path, callback) {
	    var keys, owner;
	    keys = pathToArray(path);
	    owner = this._getOwner(keys[0]);
	    if (owner != null) {
	      owner._unsetCallback(keys, callback);
	    }
	    return true;
	  };

	  Scope.prototype._getOwner = function(key) {
	    var ref;
	    if (this._object[key] !== void 0) {
	      return this;
	    } else {
	      return (ref = this._parent) != null ? ref._getOwner(key) : void 0;
	    }
	  };

	  Scope.prototype._getValue = function(keys) {
	    return getDeep(keys, this._object);
	  };

	  Scope.prototype._setValue = function(keys, value) {
	    return setDeep(keys, value, this._object);
	  };

	  Scope.prototype._emit = function(keys) {
	    var value;
	    value = this._getValue(keys);
	    this._callbackStore.run(keys, value);
	    if (keys.length > 1) {
	      this._emit(keys.slice(0, keys.length - 1));
	    }
	    return true;
	  };

	  Scope.prototype._unsetCallback = function(keys, callback) {
	    this._callbackStore.unset(keys, callback);
	    return true;
	  };

	  Scope.prototype._setCallback = function(keys, callback) {
	    this._callbackStore.set(keys, callback);
	    return true;
	  };

	  Scope.prototype._foldSelfIntoParent = function() {
	    var foldParentIntoGrandparent, ref;
	    foldParentIntoGrandparent = ((ref = this._parent) != null ? ref._foldSelfIntoParent() : void 0) || {};
	    return assign({}, foldParentIntoGrandparent, this._object);
	  };

	  return Scope;

	})();


/***/ },
/* 3 */
/***/ function(module, exports, __webpack_require__) {

	var assign,
	  slice = [].slice,
	  hasProp = {}.hasOwnProperty;

	module.exports = assign = function() {
	  var base, i, key, len, object, objects, value;
	  base = arguments[0], objects = 2 <= arguments.length ? slice.call(arguments, 1) : [];
	  for (i = 0, len = objects.length; i < len; i++) {
	    object = objects[i];
	    for (key in object) {
	      if (!hasProp.call(object, key)) continue;
	      value = object[key];
	      base[key] = value;
	    }
	  }
	  return base;
	};


/***/ },
/* 4 */
/***/ function(module, exports, __webpack_require__) {

	var CALLBACKS_KEY, CallbackStore, cloneDeep, getDeep, pathToArray, pathToCallbacks, setDeep;

	getDeep = __webpack_require__(6);

	setDeep = __webpack_require__(8);

	cloneDeep = __webpack_require__(5);

	pathToArray = __webpack_require__(7);

	CALLBACKS_KEY = '_______CALLBACKS_KEY_______';

	pathToCallbacks = function(path) {
	  var keys;
	  keys = pathToArray(path);
	  return keys.concat(CALLBACKS_KEY);
	};

	module.exports = CallbackStore = (function() {
	  function CallbackStore() {
	    this._callbacks = {};
	  }

	  CallbackStore.prototype.get = function(path) {
	    var keys;
	    keys = pathToCallbacks(path);
	    return getDeep(keys, this._callbacks) || [];
	  };

	  CallbackStore.prototype.set = function(path, callback) {
	    var callbacks, keys;
	    keys = pathToCallbacks(path);
	    callbacks = this.get(path);
	    setDeep(keys, callbacks.concat(callback), this._callbacks);
	    return true;
	  };

	  CallbackStore.prototype.unset = function(path, callback) {
	    var callbacks, index;
	    callbacks = this.get(path);
	    index = callbacks.indexOf(callback);
	    callbacks.splice(index, 1);
	    return true;
	  };

	  CallbackStore.prototype.run = function(path, value) {
	    var callbacks;
	    callbacks = this.get(path);
	    return callbacks.forEach(function(callback) {
	      var clone;
	      clone = cloneDeep(value);
	      return callback(clone);
	    });
	  };

	  return CallbackStore;

	})();


/***/ },
/* 5 */
/***/ function(module, exports, __webpack_require__) {

	var cloneDeep;

	module.exports = cloneDeep = function(obj) {
	  var flags, key, newInstance;
	  if ((obj == null) || typeof obj !== 'object') {
	    return obj;
	  }
	  if (obj instanceof Date) {
	    return new Date(obj.getTime());
	  }
	  if (obj instanceof RegExp) {
	    flags = '';
	    if (obj.global != null) {
	      flags += 'g';
	    }
	    if (obj.ignoreCase != null) {
	      flags += 'i';
	    }
	    if (obj.multiline != null) {
	      flags += 'm';
	    }
	    if (obj.sticky != null) {
	      flags += 'y';
	    }
	    return new RegExp(obj.source, flags);
	  }
	  newInstance = new obj.constructor;
	  for (key in obj) {
	    newInstance[key] = cloneDeep(obj[key]);
	  }
	  return newInstance;
	};


/***/ },
/* 6 */
/***/ function(module, exports, __webpack_require__) {

	var foldIntoSelf, getDeep, pathToArray;

	pathToArray = __webpack_require__(7);

	foldIntoSelf = function(acc, key) {
	  return acc != null ? acc[key] : void 0;
	};

	module.exports = getDeep = function(path, object) {
	  var keys;
	  keys = pathToArray(path);
	  return keys.reduce(foldIntoSelf, object);
	};


/***/ },
/* 7 */
/***/ function(module, exports, __webpack_require__) {

	var pathToArray;

	module.exports = pathToArray = function(path) {
	  if (path == null) {
	    path = [];
	  }
	  if (Array.isArray(path)) {
	    return path;
	  } else {
	    return path.split('.');
	  }
	};


/***/ },
/* 8 */
/***/ function(module, exports, __webpack_require__) {

	var pathToArray, setDeep;

	pathToArray = __webpack_require__(7);

	module.exports = setDeep = function(path, value, object) {
	  var keys, prop;
	  if (object == null) {
	    object = {};
	  }
	  keys = pathToArray(path);
	  prop = keys[0];
	  object[prop] = keys.length > 1 ? setDeep(keys.slice(1), value, object[prop] || {}) : value;
	  return object;
	};


/***/ },
/* 9 */
/***/ function(module, exports, __webpack_require__) {

	var autoBind;

	module.exports = autoBind = function(instance) {
	  var funcs;
	  funcs = Object.keys(instance.constructor.prototype);
	  return funcs.filter(function(func) {
	    return typeof instance[func] === 'function';
	  }).forEach(function(func) {
	    return instance[func] = instance[func].bind(instance);
	  });
	};


/***/ }
/******/ ]);