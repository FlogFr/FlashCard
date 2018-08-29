(function(scope){
'use strict';

function F(arity, fun, wrapper) {
  wrapper.a = arity;
  wrapper.f = fun;
  return wrapper;
}

function F2(fun) {
  return F(2, fun, function(a) { return function(b) { return fun(a,b); }; })
}
function F3(fun) {
  return F(3, fun, function(a) {
    return function(b) { return function(c) { return fun(a, b, c); }; };
  });
}
function F4(fun) {
  return F(4, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return fun(a, b, c, d); }; }; };
  });
}
function F5(fun) {
  return F(5, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return fun(a, b, c, d, e); }; }; }; };
  });
}
function F6(fun) {
  return F(6, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return fun(a, b, c, d, e, f); }; }; }; }; };
  });
}
function F7(fun) {
  return F(7, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return function(g) { return fun(a, b, c, d, e, f, g); }; }; }; }; }; };
  });
}
function F8(fun) {
  return F(8, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return function(g) { return function(h) {
    return fun(a, b, c, d, e, f, g, h); }; }; }; }; }; }; };
  });
}
function F9(fun) {
  return F(9, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return function(g) { return function(h) { return function(i) {
    return fun(a, b, c, d, e, f, g, h, i); }; }; }; }; }; }; }; };
  });
}

function A2(fun, a, b) {
  return fun.a === 2 ? fun.f(a, b) : fun(a)(b);
}
function A3(fun, a, b, c) {
  return fun.a === 3 ? fun.f(a, b, c) : fun(a)(b)(c);
}
function A4(fun, a, b, c, d) {
  return fun.a === 4 ? fun.f(a, b, c, d) : fun(a)(b)(c)(d);
}
function A5(fun, a, b, c, d, e) {
  return fun.a === 5 ? fun.f(a, b, c, d, e) : fun(a)(b)(c)(d)(e);
}
function A6(fun, a, b, c, d, e, f) {
  return fun.a === 6 ? fun.f(a, b, c, d, e, f) : fun(a)(b)(c)(d)(e)(f);
}
function A7(fun, a, b, c, d, e, f, g) {
  return fun.a === 7 ? fun.f(a, b, c, d, e, f, g) : fun(a)(b)(c)(d)(e)(f)(g);
}
function A8(fun, a, b, c, d, e, f, g, h) {
  return fun.a === 8 ? fun.f(a, b, c, d, e, f, g, h) : fun(a)(b)(c)(d)(e)(f)(g)(h);
}
function A9(fun, a, b, c, d, e, f, g, h, i) {
  return fun.a === 9 ? fun.f(a, b, c, d, e, f, g, h, i) : fun(a)(b)(c)(d)(e)(f)(g)(h)(i);
}

console.warn('Compiled in DEV mode. Follow the advice at https://elm-lang.org/0.19.0/optimize for better performance and smaller assets.');


var _List_Nil_UNUSED = { $: 0 };
var _List_Nil = { $: '[]' };

function _List_Cons_UNUSED(hd, tl) { return { $: 1, a: hd, b: tl }; }
function _List_Cons(hd, tl) { return { $: '::', a: hd, b: tl }; }


var _List_cons = F2(_List_Cons);

function _List_fromArray(arr)
{
	var out = _List_Nil;
	for (var i = arr.length; i--; )
	{
		out = _List_Cons(arr[i], out);
	}
	return out;
}

function _List_toArray(xs)
{
	for (var out = []; xs.b; xs = xs.b) // WHILE_CONS
	{
		out.push(xs.a);
	}
	return out;
}

var _List_map2 = F3(function(f, xs, ys)
{
	for (var arr = []; xs.b && ys.b; xs = xs.b, ys = ys.b) // WHILE_CONSES
	{
		arr.push(A2(f, xs.a, ys.a));
	}
	return _List_fromArray(arr);
});

var _List_map3 = F4(function(f, xs, ys, zs)
{
	for (var arr = []; xs.b && ys.b && zs.b; xs = xs.b, ys = ys.b, zs = zs.b) // WHILE_CONSES
	{
		arr.push(A3(f, xs.a, ys.a, zs.a));
	}
	return _List_fromArray(arr);
});

var _List_map4 = F5(function(f, ws, xs, ys, zs)
{
	for (var arr = []; ws.b && xs.b && ys.b && zs.b; ws = ws.b, xs = xs.b, ys = ys.b, zs = zs.b) // WHILE_CONSES
	{
		arr.push(A4(f, ws.a, xs.a, ys.a, zs.a));
	}
	return _List_fromArray(arr);
});

var _List_map5 = F6(function(f, vs, ws, xs, ys, zs)
{
	for (var arr = []; vs.b && ws.b && xs.b && ys.b && zs.b; vs = vs.b, ws = ws.b, xs = xs.b, ys = ys.b, zs = zs.b) // WHILE_CONSES
	{
		arr.push(A5(f, vs.a, ws.a, xs.a, ys.a, zs.a));
	}
	return _List_fromArray(arr);
});

var _List_sortBy = F2(function(f, xs)
{
	return _List_fromArray(_List_toArray(xs).sort(function(a, b) {
		return _Utils_cmp(f(a), f(b));
	}));
});

var _List_sortWith = F2(function(f, xs)
{
	return _List_fromArray(_List_toArray(xs).sort(function(a, b) {
		var ord = A2(f, a, b);
		return ord === elm$core$Basics$EQ ? 0 : ord === elm$core$Basics$LT ? -1 : 1;
	}));
});



// EQUALITY

function _Utils_eq(x, y)
{
	for (
		var pair, stack = [], isEqual = _Utils_eqHelp(x, y, 0, stack);
		isEqual && (pair = stack.pop());
		isEqual = _Utils_eqHelp(pair.a, pair.b, 0, stack)
		)
	{}

	return isEqual;
}

function _Utils_eqHelp(x, y, depth, stack)
{
	if (depth > 100)
	{
		stack.push(_Utils_Tuple2(x,y));
		return true;
	}

	if (x === y)
	{
		return true;
	}

	if (typeof x !== 'object' || x === null || y === null)
	{
		typeof x === 'function' && _Debug_crash(5);
		return false;
	}

	/**/
	if (x.$ === 'Set_elm_builtin')
	{
		x = elm$core$Set$toList(x);
		y = elm$core$Set$toList(y);
	}
	if (x.$ === 'RBNode_elm_builtin' || x.$ === 'RBEmpty_elm_builtin')
	{
		x = elm$core$Dict$toList(x);
		y = elm$core$Dict$toList(y);
	}
	//*/

	/**_UNUSED/
	if (x.$ < 0)
	{
		x = elm$core$Dict$toList(x);
		y = elm$core$Dict$toList(y);
	}
	//*/

	for (var key in x)
	{
		if (!_Utils_eqHelp(x[key], y[key], depth + 1, stack))
		{
			return false;
		}
	}
	return true;
}

var _Utils_equal = F2(_Utils_eq);
var _Utils_notEqual = F2(function(a, b) { return !_Utils_eq(a,b); });



// COMPARISONS

// Code in Generate/JavaScript.hs, Basics.js, and List.js depends on
// the particular integer values assigned to LT, EQ, and GT.

function _Utils_cmp(x, y, ord)
{
	if (typeof x !== 'object')
	{
		return x === y ? /*EQ*/ 0 : x < y ? /*LT*/ -1 : /*GT*/ 1;
	}

	/**/
	if (x instanceof String)
	{
		var a = x.valueOf();
		var b = y.valueOf();
		return a === b ? 0 : a < b ? -1 : 1;
	}
	//*/

	/**_UNUSED/
	if (!x.$)
	//*/
	/**/
	if (x.$[0] === '#')
	//*/
	{
		return (ord = _Utils_cmp(x.a, y.a))
			? ord
			: (ord = _Utils_cmp(x.b, y.b))
				? ord
				: _Utils_cmp(x.c, y.c);
	}

	// traverse conses until end of a list or a mismatch
	for (; x.b && y.b && !(ord = _Utils_cmp(x.a, y.a)); x = x.b, y = y.b) {} // WHILE_CONSES
	return ord || (x.b ? /*GT*/ 1 : y.b ? /*LT*/ -1 : /*EQ*/ 0);
}

var _Utils_lt = F2(function(a, b) { return _Utils_cmp(a, b) < 0; });
var _Utils_le = F2(function(a, b) { return _Utils_cmp(a, b) < 1; });
var _Utils_gt = F2(function(a, b) { return _Utils_cmp(a, b) > 0; });
var _Utils_ge = F2(function(a, b) { return _Utils_cmp(a, b) >= 0; });

var _Utils_compare = F2(function(x, y)
{
	var n = _Utils_cmp(x, y);
	return n < 0 ? elm$core$Basics$LT : n ? elm$core$Basics$GT : elm$core$Basics$EQ;
});


// COMMON VALUES

var _Utils_Tuple0_UNUSED = 0;
var _Utils_Tuple0 = { $: '#0' };

function _Utils_Tuple2_UNUSED(a, b) { return { a: a, b: b }; }
function _Utils_Tuple2(a, b) { return { $: '#2', a: a, b: b }; }

function _Utils_Tuple3_UNUSED(a, b, c) { return { a: a, b: b, c: c }; }
function _Utils_Tuple3(a, b, c) { return { $: '#3', a: a, b: b, c: c }; }

function _Utils_chr_UNUSED(c) { return c; }
function _Utils_chr(c) { return new String(c); }


// RECORDS

function _Utils_update(oldRecord, updatedFields)
{
	var newRecord = {};

	for (var key in oldRecord)
	{
		newRecord[key] = oldRecord[key];
	}

	for (var key in updatedFields)
	{
		newRecord[key] = updatedFields[key];
	}

	return newRecord;
}


// APPEND

var _Utils_append = F2(_Utils_ap);

function _Utils_ap(xs, ys)
{
	// append Strings
	if (typeof xs === 'string')
	{
		return xs + ys;
	}

	// append Lists
	if (!xs.b)
	{
		return ys;
	}
	var root = _List_Cons(xs.a, ys);
	xs = xs.b
	for (var curr = root; xs.b; xs = xs.b) // WHILE_CONS
	{
		curr = curr.b = _List_Cons(xs.a, ys);
	}
	return root;
}



var _JsArray_empty = [];

function _JsArray_singleton(value)
{
    return [value];
}

function _JsArray_length(array)
{
    return array.length;
}

var _JsArray_initialize = F3(function(size, offset, func)
{
    var result = new Array(size);

    for (var i = 0; i < size; i++)
    {
        result[i] = func(offset + i);
    }

    return result;
});

var _JsArray_initializeFromList = F2(function (max, ls)
{
    var result = new Array(max);

    for (var i = 0; i < max && ls.b; i++)
    {
        result[i] = ls.a;
        ls = ls.b;
    }

    result.length = i;
    return _Utils_Tuple2(result, ls);
});

var _JsArray_unsafeGet = F2(function(index, array)
{
    return array[index];
});

var _JsArray_unsafeSet = F3(function(index, value, array)
{
    var length = array.length;
    var result = new Array(length);

    for (var i = 0; i < length; i++)
    {
        result[i] = array[i];
    }

    result[index] = value;
    return result;
});

var _JsArray_push = F2(function(value, array)
{
    var length = array.length;
    var result = new Array(length + 1);

    for (var i = 0; i < length; i++)
    {
        result[i] = array[i];
    }

    result[length] = value;
    return result;
});

var _JsArray_foldl = F3(function(func, acc, array)
{
    var length = array.length;

    for (var i = 0; i < length; i++)
    {
        acc = A2(func, array[i], acc);
    }

    return acc;
});

var _JsArray_foldr = F3(function(func, acc, array)
{
    for (var i = array.length - 1; i >= 0; i--)
    {
        acc = A2(func, array[i], acc);
    }

    return acc;
});

var _JsArray_map = F2(function(func, array)
{
    var length = array.length;
    var result = new Array(length);

    for (var i = 0; i < length; i++)
    {
        result[i] = func(array[i]);
    }

    return result;
});

var _JsArray_indexedMap = F3(function(func, offset, array)
{
    var length = array.length;
    var result = new Array(length);

    for (var i = 0; i < length; i++)
    {
        result[i] = A2(func, offset + i, array[i]);
    }

    return result;
});

var _JsArray_slice = F3(function(from, to, array)
{
    return array.slice(from, to);
});

var _JsArray_appendN = F3(function(n, dest, source)
{
    var destLen = dest.length;
    var itemsToCopy = n - destLen;

    if (itemsToCopy > source.length)
    {
        itemsToCopy = source.length;
    }

    var size = destLen + itemsToCopy;
    var result = new Array(size);

    for (var i = 0; i < destLen; i++)
    {
        result[i] = dest[i];
    }

    for (var i = 0; i < itemsToCopy; i++)
    {
        result[i + destLen] = source[i];
    }

    return result;
});



// LOG

var _Debug_log_UNUSED = F2(function(tag, value)
{
	return value;
});

var _Debug_log = F2(function(tag, value)
{
	console.log(tag + ': ' + _Debug_toString(value));
	return value;
});


// TODOS

function _Debug_todo(moduleName, region)
{
	return function(message) {
		_Debug_crash(8, moduleName, region, message);
	};
}

function _Debug_todoCase(moduleName, region, value)
{
	return function(message) {
		_Debug_crash(9, moduleName, region, value, message);
	};
}


// TO STRING

function _Debug_toString_UNUSED(value)
{
	return '<internals>';
}

function _Debug_toString(value)
{
	return _Debug_toAnsiString(false, value);
}

function _Debug_toAnsiString(ansi, value)
{
	if (typeof value === 'function')
	{
		return _Debug_internalColor(ansi, '<function>');
	}

	if (typeof value === 'boolean')
	{
		return _Debug_ctorColor(ansi, value ? 'True' : 'False');
	}

	if (typeof value === 'number')
	{
		return _Debug_numberColor(ansi, value + '');
	}

	if (value instanceof String)
	{
		return _Debug_charColor(ansi, "'" + _Debug_addSlashes(value, true) + "'");
	}

	if (typeof value === 'string')
	{
		return _Debug_stringColor(ansi, '"' + _Debug_addSlashes(value, false) + '"');
	}

	if (typeof value === 'object' && '$' in value)
	{
		var tag = value.$;

		if (typeof tag === 'number')
		{
			return _Debug_internalColor(ansi, '<internals>');
		}

		if (tag[0] === '#')
		{
			var output = [];
			for (var k in value)
			{
				if (k === '$') continue;
				output.push(_Debug_toAnsiString(ansi, value[k]));
			}
			return '(' + output.join(',') + ')';
		}

		if (tag === 'Set_elm_builtin')
		{
			return _Debug_ctorColor(ansi, 'Set')
				+ _Debug_fadeColor(ansi, '.fromList') + ' '
				+ _Debug_toAnsiString(ansi, elm$core$Set$toList(value));
		}

		if (tag === 'RBNode_elm_builtin' || tag === 'RBEmpty_elm_builtin')
		{
			return _Debug_ctorColor(ansi, 'Dict')
				+ _Debug_fadeColor(ansi, '.fromList') + ' '
				+ _Debug_toAnsiString(ansi, elm$core$Dict$toList(value));
		}

		if (tag === 'Array_elm_builtin')
		{
			return _Debug_ctorColor(ansi, 'Array')
				+ _Debug_fadeColor(ansi, '.fromList') + ' '
				+ _Debug_toAnsiString(ansi, elm$core$Array$toList(value));
		}

		if (tag === '::' || tag === '[]')
		{
			var output = '[';

			value.b && (output += _Debug_toAnsiString(ansi, value.a), value = value.b)

			for (; value.b; value = value.b) // WHILE_CONS
			{
				output += ',' + _Debug_toAnsiString(ansi, value.a);
			}
			return output + ']';
		}

		var output = '';
		for (var i in value)
		{
			if (i === '$') continue;
			var str = _Debug_toAnsiString(ansi, value[i]);
			var c0 = str[0];
			var parenless = c0 === '{' || c0 === '(' || c0 === '[' || c0 === '<' || c0 === '"' || str.indexOf(' ') < 0;
			output += ' ' + (parenless ? str : '(' + str + ')');
		}
		return _Debug_ctorColor(ansi, tag) + output;
	}

	if (typeof value === 'object')
	{
		var output = [];
		for (var key in value)
		{
			var field = key[0] === '_' ? key.slice(1) : key;
			output.push(_Debug_fadeColor(ansi, field) + ' = ' + _Debug_toAnsiString(ansi, value[key]));
		}
		if (output.length === 0)
		{
			return '{}';
		}
		return '{ ' + output.join(', ') + ' }';
	}

	return _Debug_internalColor(ansi, '<internals>');
}

function _Debug_addSlashes(str, isChar)
{
	var s = str
		.replace(/\\/g, '\\\\')
		.replace(/\n/g, '\\n')
		.replace(/\t/g, '\\t')
		.replace(/\r/g, '\\r')
		.replace(/\v/g, '\\v')
		.replace(/\0/g, '\\0');

	if (isChar)
	{
		return s.replace(/\'/g, '\\\'');
	}
	else
	{
		return s.replace(/\"/g, '\\"');
	}
}

function _Debug_ctorColor(ansi, string)
{
	return ansi ? '\x1b[96m' + string + '\x1b[0m' : string;
}

function _Debug_numberColor(ansi, string)
{
	return ansi ? '\x1b[95m' + string + '\x1b[0m' : string;
}

function _Debug_stringColor(ansi, string)
{
	return ansi ? '\x1b[93m' + string + '\x1b[0m' : string;
}

function _Debug_charColor(ansi, string)
{
	return ansi ? '\x1b[92m' + string + '\x1b[0m' : string;
}

function _Debug_fadeColor(ansi, string)
{
	return ansi ? '\x1b[37m' + string + '\x1b[0m' : string;
}

function _Debug_internalColor(ansi, string)
{
	return ansi ? '\x1b[94m' + string + '\x1b[0m' : string;
}



// CRASH


function _Debug_crash_UNUSED(identifier)
{
	throw new Error('https://github.com/elm/core/blob/1.0.0/hints/' + identifier + '.md');
}


function _Debug_crash(identifier, fact1, fact2, fact3, fact4)
{
	switch(identifier)
	{
		case 0:
			throw new Error('What node should I take over? In JavaScript I need something like:\n\n    Elm.Main.init({\n        node: document.getElementById("elm-node")\n    })\n\nYou need to do this with any Browser.sandbox or Browser.element program.');

		case 1:
			throw new Error('Browser.application programs cannot handle URLs like this:\n\n    ' + document.location.href + '\n\nWhat is the root? The root of your file system? Try looking at this program with `elm reactor` or some other server.');

		case 2:
			var jsonErrorString = fact1;
			throw new Error('Problem with the flags given to your Elm program on initialization.\n\n' + jsonErrorString);

		case 3:
			var portName = fact1;
			throw new Error('There can only be one port named `' + portName + '`, but your program has multiple.');

		case 4:
			var portName = fact1;
			var problem = fact2;
			throw new Error('Trying to send an unexpected type of value through port `' + portName + '`:\n' + problem);

		case 5:
			throw new Error('Trying to use `(==)` on functions.\nThere is no way to know if functions are "the same" in the Elm sense.\nRead more about this at https://package.elm-lang.org/packages/elm/core/latest/Basics#== which describes why it is this way and what the better version will look like.');

		case 6:
			var moduleName = fact1;
			throw new Error('Your page is loading multiple Elm scripts with a module named ' + moduleName + '. Maybe a duplicate script is getting loaded accidentally? If not, rename one of them so I know which is which!');

		case 8:
			var moduleName = fact1;
			var region = fact2;
			var message = fact3;
			throw new Error('TODO in module `' + moduleName + '` ' + _Debug_regionToString(region) + '\n\n' + message);

		case 9:
			var moduleName = fact1;
			var region = fact2;
			var value = fact3;
			var message = fact4;
			throw new Error(
				'TODO in module `' + moduleName + '` from the `case` expression '
				+ _Debug_regionToString(region) + '\n\nIt received the following value:\n\n    '
				+ _Debug_toString(value).replace('\n', '\n    ')
				+ '\n\nBut the branch that handles it says:\n\n    ' + message.replace('\n', '\n    ')
			);

		case 10:
			throw new Error('Bug in https://github.com/elm/virtual-dom/issues');

		case 11:
			throw new Error('Cannot perform mod 0. Division by zero error.');
	}
}

function _Debug_regionToString(region)
{
	if (region.start.line === region.end.line)
	{
		return 'on line ' + region.start.line;
	}
	return 'on lines ' + region.start.line + ' through ' + region.end.line;
}



// MATH

var _Basics_add = F2(function(a, b) { return a + b; });
var _Basics_sub = F2(function(a, b) { return a - b; });
var _Basics_mul = F2(function(a, b) { return a * b; });
var _Basics_fdiv = F2(function(a, b) { return a / b; });
var _Basics_idiv = F2(function(a, b) { return (a / b) | 0; });
var _Basics_pow = F2(Math.pow);

var _Basics_remainderBy = F2(function(b, a) { return a % b; });

// https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/divmodnote-letter.pdf
var _Basics_modBy = F2(function(modulus, x)
{
	var answer = x % modulus;
	return modulus === 0
		? _Debug_crash(11)
		:
	((answer > 0 && modulus < 0) || (answer < 0 && modulus > 0))
		? answer + modulus
		: answer;
});


// TRIGONOMETRY

var _Basics_pi = Math.PI;
var _Basics_e = Math.E;
var _Basics_cos = Math.cos;
var _Basics_sin = Math.sin;
var _Basics_tan = Math.tan;
var _Basics_acos = Math.acos;
var _Basics_asin = Math.asin;
var _Basics_atan = Math.atan;
var _Basics_atan2 = F2(Math.atan2);


// MORE MATH

function _Basics_toFloat(x) { return x; }
function _Basics_truncate(n) { return n | 0; }
function _Basics_isInfinite(n) { return n === Infinity || n === -Infinity; }

var _Basics_ceiling = Math.ceil;
var _Basics_floor = Math.floor;
var _Basics_round = Math.round;
var _Basics_sqrt = Math.sqrt;
var _Basics_log = Math.log;
var _Basics_isNaN = isNaN;


// BOOLEANS

function _Basics_not(bool) { return !bool; }
var _Basics_and = F2(function(a, b) { return a && b; });
var _Basics_or  = F2(function(a, b) { return a || b; });
var _Basics_xor = F2(function(a, b) { return a !== b; });



function _Char_toCode(char)
{
	var code = char.charCodeAt(0);
	if (0xD800 <= code && code <= 0xDBFF)
	{
		return (code - 0xD800) * 0x400 + char.charCodeAt(1) - 0xDC00 + 0x10000
	}
	return code;
}

function _Char_fromCode(code)
{
	return _Utils_chr(
		(code < 0 || 0x10FFFF < code)
			? '\uFFFD'
			:
		(code <= 0xFFFF)
			? String.fromCharCode(code)
			:
		(code -= 0x10000,
			String.fromCharCode(Math.floor(code / 0x400) + 0xD800)
			+
			String.fromCharCode(code % 0x400 + 0xDC00)
		)
	);
}

function _Char_toUpper(char)
{
	return _Utils_chr(char.toUpperCase());
}

function _Char_toLower(char)
{
	return _Utils_chr(char.toLowerCase());
}

function _Char_toLocaleUpper(char)
{
	return _Utils_chr(char.toLocaleUpperCase());
}

function _Char_toLocaleLower(char)
{
	return _Utils_chr(char.toLocaleLowerCase());
}



var _String_cons = F2(function(chr, str)
{
	return chr + str;
});

function _String_uncons(string)
{
	var word = string.charCodeAt(0);
	return word
		? elm$core$Maybe$Just(
			0xD800 <= word && word <= 0xDBFF
				? _Utils_Tuple2(_Utils_chr(string[0] + string[1]), string.slice(2))
				: _Utils_Tuple2(_Utils_chr(string[0]), string.slice(1))
		)
		: elm$core$Maybe$Nothing;
}

var _String_append = F2(function(a, b)
{
	return a + b;
});

function _String_length(str)
{
	return str.length;
}

var _String_map = F2(function(func, string)
{
	var len = string.length;
	var array = new Array(len);
	var i = 0;
	while (i < len)
	{
		var word = string.charCodeAt(i);
		if (0xD800 <= word && word <= 0xDBFF)
		{
			array[i] = func(_Utils_chr(string[i] + string[i+1]));
			i += 2;
			continue;
		}
		array[i] = func(_Utils_chr(string[i]));
		i++;
	}
	return array.join('');
});

var _String_filter = F2(function(isGood, str)
{
	var arr = [];
	var len = str.length;
	var i = 0;
	while (i < len)
	{
		var char = str[i];
		var word = str.charCodeAt(i);
		i++;
		if (0xD800 <= word && word <= 0xDBFF)
		{
			char += str[i];
			i++;
		}

		if (isGood(_Utils_chr(char)))
		{
			arr.push(char);
		}
	}
	return arr.join('');
});

function _String_reverse(str)
{
	var len = str.length;
	var arr = new Array(len);
	var i = 0;
	while (i < len)
	{
		var word = str.charCodeAt(i);
		if (0xD800 <= word && word <= 0xDBFF)
		{
			arr[len - i] = str[i + 1];
			i++;
			arr[len - i] = str[i - 1];
			i++;
		}
		else
		{
			arr[len - i] = str[i];
			i++;
		}
	}
	return arr.join('');
}

var _String_foldl = F3(function(func, state, string)
{
	var len = string.length;
	var i = 0;
	while (i < len)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		i++;
		if (0xD800 <= word && word <= 0xDBFF)
		{
			char += string[i];
			i++;
		}
		state = A2(func, _Utils_chr(char), state);
	}
	return state;
});

var _String_foldr = F3(function(func, state, string)
{
	var i = string.length;
	while (i--)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		if (0xDC00 <= word && word <= 0xDFFF)
		{
			i--;
			char = string[i] + char;
		}
		state = A2(func, _Utils_chr(char), state);
	}
	return state;
});

var _String_split = F2(function(sep, str)
{
	return str.split(sep);
});

var _String_join = F2(function(sep, strs)
{
	return strs.join(sep);
});

var _String_slice = F3(function(start, end, str) {
	return str.slice(start, end);
});

function _String_trim(str)
{
	return str.trim();
}

function _String_trimLeft(str)
{
	return str.replace(/^\s+/, '');
}

function _String_trimRight(str)
{
	return str.replace(/\s+$/, '');
}

function _String_words(str)
{
	return _List_fromArray(str.trim().split(/\s+/g));
}

function _String_lines(str)
{
	return _List_fromArray(str.split(/\r\n|\r|\n/g));
}

function _String_toUpper(str)
{
	return str.toUpperCase();
}

function _String_toLower(str)
{
	return str.toLowerCase();
}

var _String_any = F2(function(isGood, string)
{
	var i = string.length;
	while (i--)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		if (0xDC00 <= word && word <= 0xDFFF)
		{
			i--;
			char = string[i] + char;
		}
		if (isGood(_Utils_chr(char)))
		{
			return true;
		}
	}
	return false;
});

var _String_all = F2(function(isGood, string)
{
	var i = string.length;
	while (i--)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		if (0xDC00 <= word && word <= 0xDFFF)
		{
			i--;
			char = string[i] + char;
		}
		if (!isGood(_Utils_chr(char)))
		{
			return false;
		}
	}
	return true;
});

var _String_contains = F2(function(sub, str)
{
	return str.indexOf(sub) > -1;
});

var _String_startsWith = F2(function(sub, str)
{
	return str.indexOf(sub) === 0;
});

var _String_endsWith = F2(function(sub, str)
{
	return str.length >= sub.length &&
		str.lastIndexOf(sub) === str.length - sub.length;
});

var _String_indexes = F2(function(sub, str)
{
	var subLen = sub.length;

	if (subLen < 1)
	{
		return _List_Nil;
	}

	var i = 0;
	var is = [];

	while ((i = str.indexOf(sub, i)) > -1)
	{
		is.push(i);
		i = i + subLen;
	}

	return _List_fromArray(is);
});


// TO STRING

function _String_fromNumber(number)
{
	return number + '';
}


// INT CONVERSIONS

function _String_toInt(str)
{
	var total = 0;
	var code0 = str.charCodeAt(0);
	var start = code0 == 0x2B /* + */ || code0 == 0x2D /* - */ ? 1 : 0;

	for (var i = start; i < str.length; ++i)
	{
		var code = str.charCodeAt(i);
		if (code < 0x30 || 0x39 < code)
		{
			return elm$core$Maybe$Nothing;
		}
		total = 10 * total + code - 0x30;
	}

	return i == start
		? elm$core$Maybe$Nothing
		: elm$core$Maybe$Just(code0 == 0x2D ? -total : total);
}


// FLOAT CONVERSIONS

function _String_toFloat(s)
{
	// check if it is a hex, octal, or binary number
	if (s.length === 0 || /[\sxbo]/.test(s))
	{
		return elm$core$Maybe$Nothing;
	}
	var n = +s;
	// faster isNaN check
	return n === n ? elm$core$Maybe$Just(n) : elm$core$Maybe$Nothing;
}

function _String_fromList(chars)
{
	return _List_toArray(chars).join('');
}




/**/
function _Json_errorToString(error)
{
	return elm$json$Json$Decode$errorToString(error);
}
//*/


// CORE DECODERS

function _Json_succeed(msg)
{
	return {
		$: 0,
		a: msg
	};
}

function _Json_fail(msg)
{
	return {
		$: 1,
		a: msg
	};
}

var _Json_decodeInt = { $: 2 };
var _Json_decodeBool = { $: 3 };
var _Json_decodeFloat = { $: 4 };
var _Json_decodeValue = { $: 5 };
var _Json_decodeString = { $: 6 };

function _Json_decodeList(decoder) { return { $: 7, b: decoder }; }
function _Json_decodeArray(decoder) { return { $: 8, b: decoder }; }

function _Json_decodeNull(value) { return { $: 9, c: value }; }

var _Json_decodeField = F2(function(field, decoder)
{
	return {
		$: 10,
		d: field,
		b: decoder
	};
});

var _Json_decodeIndex = F2(function(index, decoder)
{
	return {
		$: 11,
		e: index,
		b: decoder
	};
});

function _Json_decodeKeyValuePairs(decoder)
{
	return {
		$: 12,
		b: decoder
	};
}

function _Json_mapMany(f, decoders)
{
	return {
		$: 13,
		f: f,
		g: decoders
	};
}

var _Json_andThen = F2(function(callback, decoder)
{
	return {
		$: 14,
		b: decoder,
		h: callback
	};
});

function _Json_oneOf(decoders)
{
	return {
		$: 15,
		g: decoders
	};
}


// DECODING OBJECTS

var _Json_map1 = F2(function(f, d1)
{
	return _Json_mapMany(f, [d1]);
});

var _Json_map2 = F3(function(f, d1, d2)
{
	return _Json_mapMany(f, [d1, d2]);
});

var _Json_map3 = F4(function(f, d1, d2, d3)
{
	return _Json_mapMany(f, [d1, d2, d3]);
});

var _Json_map4 = F5(function(f, d1, d2, d3, d4)
{
	return _Json_mapMany(f, [d1, d2, d3, d4]);
});

var _Json_map5 = F6(function(f, d1, d2, d3, d4, d5)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5]);
});

var _Json_map6 = F7(function(f, d1, d2, d3, d4, d5, d6)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5, d6]);
});

var _Json_map7 = F8(function(f, d1, d2, d3, d4, d5, d6, d7)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5, d6, d7]);
});

var _Json_map8 = F9(function(f, d1, d2, d3, d4, d5, d6, d7, d8)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5, d6, d7, d8]);
});


// DECODE

var _Json_runOnString = F2(function(decoder, string)
{
	try
	{
		var value = JSON.parse(string);
		return _Json_runHelp(decoder, value);
	}
	catch (e)
	{
		return elm$core$Result$Err(A2(elm$json$Json$Decode$Failure, 'This is not valid JSON! ' + e.message, _Json_wrap(string)));
	}
});

var _Json_run = F2(function(decoder, value)
{
	return _Json_runHelp(decoder, _Json_unwrap(value));
});

function _Json_runHelp(decoder, value)
{
	switch (decoder.$)
	{
		case 3:
			return (typeof value === 'boolean')
				? elm$core$Result$Ok(value)
				: _Json_expecting('a BOOL', value);

		case 2:
			if (typeof value !== 'number') {
				return _Json_expecting('an INT', value);
			}

			if (-2147483647 < value && value < 2147483647 && (value | 0) === value) {
				return elm$core$Result$Ok(value);
			}

			if (isFinite(value) && !(value % 1)) {
				return elm$core$Result$Ok(value);
			}

			return _Json_expecting('an INT', value);

		case 4:
			return (typeof value === 'number')
				? elm$core$Result$Ok(value)
				: _Json_expecting('a FLOAT', value);

		case 6:
			return (typeof value === 'string')
				? elm$core$Result$Ok(value)
				: (value instanceof String)
					? elm$core$Result$Ok(value + '')
					: _Json_expecting('a STRING', value);

		case 9:
			return (value === null)
				? elm$core$Result$Ok(decoder.c)
				: _Json_expecting('null', value);

		case 5:
			return elm$core$Result$Ok(_Json_wrap(value));

		case 7:
			if (!Array.isArray(value))
			{
				return _Json_expecting('a LIST', value);
			}
			return _Json_runArrayDecoder(decoder.b, value, _List_fromArray);

		case 8:
			if (!Array.isArray(value))
			{
				return _Json_expecting('an ARRAY', value);
			}
			return _Json_runArrayDecoder(decoder.b, value, _Json_toElmArray);

		case 10:
			var field = decoder.d;
			if (typeof value !== 'object' || value === null || !(field in value))
			{
				return _Json_expecting('an OBJECT with a field named `' + field + '`', value);
			}
			var result = _Json_runHelp(decoder.b, value[field]);
			return (elm$core$Result$isOk(result)) ? result : elm$core$Result$Err(A2(elm$json$Json$Decode$Field, field, result.a));

		case 11:
			var index = decoder.e;
			if (!Array.isArray(value))
			{
				return _Json_expecting('an ARRAY', value);
			}
			if (index >= value.length)
			{
				return _Json_expecting('a LONGER array. Need index ' + index + ' but only see ' + value.length + ' entries', value);
			}
			var result = _Json_runHelp(decoder.b, value[index]);
			return (elm$core$Result$isOk(result)) ? result : elm$core$Result$Err(A2(elm$json$Json$Decode$Index, index, result.a));

		case 12:
			if (typeof value !== 'object' || value === null || Array.isArray(value))
			{
				return _Json_expecting('an OBJECT', value);
			}

			var keyValuePairs = _List_Nil;
			// TODO test perf of Object.keys and switch when support is good enough
			for (var key in value)
			{
				if (value.hasOwnProperty(key))
				{
					var result = _Json_runHelp(decoder.b, value[key]);
					if (!elm$core$Result$isOk(result))
					{
						return elm$core$Result$Err(A2(elm$json$Json$Decode$Field, key, result.a));
					}
					keyValuePairs = _List_Cons(_Utils_Tuple2(key, result.a), keyValuePairs);
				}
			}
			return elm$core$Result$Ok(elm$core$List$reverse(keyValuePairs));

		case 13:
			var answer = decoder.f;
			var decoders = decoder.g;
			for (var i = 0; i < decoders.length; i++)
			{
				var result = _Json_runHelp(decoders[i], value);
				if (!elm$core$Result$isOk(result))
				{
					return result;
				}
				answer = answer(result.a);
			}
			return elm$core$Result$Ok(answer);

		case 14:
			var result = _Json_runHelp(decoder.b, value);
			return (!elm$core$Result$isOk(result))
				? result
				: _Json_runHelp(decoder.h(result.a), value);

		case 15:
			var errors = _List_Nil;
			for (var temp = decoder.g; temp.b; temp = temp.b) // WHILE_CONS
			{
				var result = _Json_runHelp(temp.a, value);
				if (elm$core$Result$isOk(result))
				{
					return result;
				}
				errors = _List_Cons(result.a, errors);
			}
			return elm$core$Result$Err(elm$json$Json$Decode$OneOf(elm$core$List$reverse(errors)));

		case 1:
			return elm$core$Result$Err(A2(elm$json$Json$Decode$Failure, decoder.a, _Json_wrap(value)));

		case 0:
			return elm$core$Result$Ok(decoder.a);
	}
}

function _Json_runArrayDecoder(decoder, value, toElmValue)
{
	var len = value.length;
	var array = new Array(len);
	for (var i = 0; i < len; i++)
	{
		var result = _Json_runHelp(decoder, value[i]);
		if (!elm$core$Result$isOk(result))
		{
			return elm$core$Result$Err(A2(elm$json$Json$Decode$Index, i, result.a));
		}
		array[i] = result.a;
	}
	return elm$core$Result$Ok(toElmValue(array));
}

function _Json_toElmArray(array)
{
	return A2(elm$core$Array$initialize, array.length, function(i) { return array[i]; });
}

function _Json_expecting(type, value)
{
	return elm$core$Result$Err(A2(elm$json$Json$Decode$Failure, 'Expecting ' + type, _Json_wrap(value)));
}


// EQUALITY

function _Json_equality(x, y)
{
	if (x === y)
	{
		return true;
	}

	if (x.$ !== y.$)
	{
		return false;
	}

	switch (x.$)
	{
		case 0:
		case 1:
			return x.a === y.a;

		case 3:
		case 2:
		case 4:
		case 6:
		case 5:
			return true;

		case 9:
			return x.c === y.c;

		case 7:
		case 8:
		case 12:
			return _Json_equality(x.b, y.b);

		case 10:
			return x.d === y.d && _Json_equality(x.b, y.b);

		case 11:
			return x.e === y.e && _Json_equality(x.b, y.b);

		case 13:
			return x.f === y.f && _Json_listEquality(x.g, y.g);

		case 14:
			return x.h === y.h && _Json_equality(x.b, y.b);

		case 15:
			return _Json_listEquality(x.g, y.g);
	}
}

function _Json_listEquality(aDecoders, bDecoders)
{
	var len = aDecoders.length;
	if (len !== bDecoders.length)
	{
		return false;
	}
	for (var i = 0; i < len; i++)
	{
		if (!_Json_equality(aDecoders[i], bDecoders[i]))
		{
			return false;
		}
	}
	return true;
}


// ENCODE

var _Json_encode = F2(function(indentLevel, value)
{
	return JSON.stringify(_Json_unwrap(value), null, indentLevel) + '';
});

function _Json_wrap(value) { return { $: 0, a: value }; }
function _Json_unwrap(value) { return value.a; }

function _Json_wrap_UNUSED(value) { return value; }
function _Json_unwrap_UNUSED(value) { return value; }

function _Json_emptyArray() { return []; }
function _Json_emptyObject() { return {}; }

var _Json_addField = F3(function(key, value, object)
{
	object[key] = _Json_unwrap(value);
	return object;
});

function _Json_addEntry(func)
{
	return F2(function(entry, array)
	{
		array.push(_Json_unwrap(func(entry)));
		return array;
	});
}

var _Json_encodeNull = _Json_wrap(null);


function _Url_percentEncode(string)
{
	return encodeURIComponent(string);
}

function _Url_percentDecode(string)
{
	try
	{
		return elm$core$Maybe$Just(decodeURIComponent(string));
	}
	catch (e)
	{
		return elm$core$Maybe$Nothing;
	}
}


// TASKS

function _Scheduler_succeed(value)
{
	return {
		$: 0,
		a: value
	};
}

function _Scheduler_fail(error)
{
	return {
		$: 1,
		a: error
	};
}

function _Scheduler_binding(callback)
{
	return {
		$: 2,
		b: callback,
		c: null
	};
}

var _Scheduler_andThen = F2(function(callback, task)
{
	return {
		$: 3,
		b: callback,
		d: task
	};
});

var _Scheduler_onError = F2(function(callback, task)
{
	return {
		$: 4,
		b: callback,
		d: task
	};
});

function _Scheduler_receive(callback)
{
	return {
		$: 5,
		b: callback
	};
}


// PROCESSES

var _Scheduler_guid = 0;

function _Scheduler_rawSpawn(task)
{
	var proc = {
		$: 0,
		e: _Scheduler_guid++,
		f: task,
		g: null,
		h: []
	};

	_Scheduler_enqueue(proc);

	return proc;
}

function _Scheduler_spawn(task)
{
	return _Scheduler_binding(function(callback) {
		callback(_Scheduler_succeed(_Scheduler_rawSpawn(task)));
	});
}

function _Scheduler_rawSend(proc, msg)
{
	proc.h.push(msg);
	_Scheduler_enqueue(proc);
}

var _Scheduler_send = F2(function(proc, msg)
{
	return _Scheduler_binding(function(callback) {
		_Scheduler_rawSend(proc, msg);
		callback(_Scheduler_succeed(_Utils_Tuple0));
	});
});

function _Scheduler_kill(proc)
{
	return _Scheduler_binding(function(callback) {
		var task = proc.f;
		if (task.$ === 2 && task.c)
		{
			task.c();
		}

		proc.f = null;

		callback(_Scheduler_succeed(_Utils_Tuple0));
	});
}


/* STEP PROCESSES

type alias Process =
  { $ : tag
  , id : unique_id
  , root : Task
  , stack : null | { $: SUCCEED | FAIL, a: callback, b: stack }
  , mailbox : [msg]
  }

*/


var _Scheduler_working = false;
var _Scheduler_queue = [];


function _Scheduler_enqueue(proc)
{
	_Scheduler_queue.push(proc);
	if (_Scheduler_working)
	{
		return;
	}
	_Scheduler_working = true;
	while (proc = _Scheduler_queue.shift())
	{
		_Scheduler_step(proc);
	}
	_Scheduler_working = false;
}


function _Scheduler_step(proc)
{
	while (proc.f)
	{
		var rootTag = proc.f.$;
		if (rootTag === 0 || rootTag === 1)
		{
			while (proc.g && proc.g.$ !== rootTag)
			{
				proc.g = proc.g.i;
			}
			if (!proc.g)
			{
				return;
			}
			proc.f = proc.g.b(proc.f.a);
			proc.g = proc.g.i;
		}
		else if (rootTag === 2)
		{
			proc.f.c = proc.f.b(function(newRoot) {
				proc.f = newRoot;
				_Scheduler_enqueue(proc);
			});
			return;
		}
		else if (rootTag === 5)
		{
			if (proc.h.length === 0)
			{
				return;
			}
			proc.f = proc.f.b(proc.h.shift());
		}
		else // if (rootTag === 3 || rootTag === 4)
		{
			proc.g = {
				$: rootTag === 3 ? 0 : 1,
				b: proc.f.b,
				i: proc.g
			};
			proc.f = proc.f.d;
		}
	}
}



// SEND REQUEST

var _Http_toTask = F2(function(request, maybeProgress)
{
	return _Scheduler_binding(function(callback)
	{
		var xhr = new XMLHttpRequest();

		_Http_configureProgress(xhr, maybeProgress);

		xhr.addEventListener('error', function() {
			callback(_Scheduler_fail(elm$http$Http$NetworkError));
		});
		xhr.addEventListener('timeout', function() {
			callback(_Scheduler_fail(elm$http$Http$Timeout));
		});
		xhr.addEventListener('load', function() {
			callback(_Http_handleResponse(xhr, request.expect.a));
		});

		try
		{
			xhr.open(request.method, request.url, true);
		}
		catch (e)
		{
			return callback(_Scheduler_fail(elm$http$Http$BadUrl(request.url)));
		}

		_Http_configureRequest(xhr, request);

		var body = request.body;
		xhr.send(elm$http$Http$Internal$isStringBody(body)
			? (xhr.setRequestHeader('Content-Type', body.a), body.b)
			: body.a
		);

		return function() { xhr.abort(); };
	});
});

function _Http_configureProgress(xhr, maybeProgress)
{
	if (!elm$core$Maybe$isJust(maybeProgress))
	{
		return;
	}

	xhr.addEventListener('progress', function(event) {
		if (!event.lengthComputable)
		{
			return;
		}
		_Scheduler_rawSpawn(maybeProgress.a({
			bytes: event.loaded,
			bytesExpected: event.total
		}));
	});
}

function _Http_configureRequest(xhr, request)
{
	for (var headers = request.headers; headers.b; headers = headers.b) // WHILE_CONS
	{
		xhr.setRequestHeader(headers.a.a, headers.a.b);
	}

	xhr.responseType = request.expect.b;
	xhr.withCredentials = request.withCredentials;

	elm$core$Maybe$isJust(request.timeout) && (xhr.timeout = request.timeout.a);
}


// RESPONSES

function _Http_handleResponse(xhr, responseToResult)
{
	var response = _Http_toResponse(xhr);

	if (xhr.status < 200 || 300 <= xhr.status)
	{
		response.body = xhr.responseText;
		return _Scheduler_fail(elm$http$Http$BadStatus(response));
	}

	var result = responseToResult(response);

	if (elm$core$Result$isOk(result))
	{
		return _Scheduler_succeed(result.a);
	}
	else
	{
		response.body = xhr.responseText;
		return _Scheduler_fail(A2(elm$http$Http$BadPayload, result.a, response));
	}
}

function _Http_toResponse(xhr)
{
	return {
		url: xhr.responseURL,
		status: { code: xhr.status, message: xhr.statusText },
		headers: _Http_parseHeaders(xhr.getAllResponseHeaders()),
		body: xhr.response
	};
}

function _Http_parseHeaders(rawHeaders)
{
	var headers = elm$core$Dict$empty;

	if (!rawHeaders)
	{
		return headers;
	}

	var headerPairs = rawHeaders.split('\u000d\u000a');
	for (var i = headerPairs.length; i--; )
	{
		var headerPair = headerPairs[i];
		var index = headerPair.indexOf('\u003a\u0020');
		if (index > 0)
		{
			var key = headerPair.substring(0, index);
			var value = headerPair.substring(index + 2);

			headers = A3(elm$core$Dict$update, key, function(oldValue) {
				return elm$core$Maybe$Just(elm$core$Maybe$isJust(oldValue)
					? value + ', ' + oldValue.a
					: value
				);
			}, headers);
		}
	}

	return headers;
}


// EXPECTORS

function _Http_expectStringResponse(responseToResult)
{
	return {
		$: 0,
		b: 'text',
		a: responseToResult
	};
}

var _Http_mapExpect = F2(function(func, expect)
{
	return {
		$: 0,
		b: expect.b,
		a: function(response) {
			var convertedResponse = expect.a(response);
			return A2(elm$core$Result$map, func, convertedResponse);
		}
	};
});


// BODY

function _Http_multipart(parts)
{


	for (var formData = new FormData(); parts.b; parts = parts.b) // WHILE_CONS
	{
		var part = parts.a;
		formData.append(part.a, part.b);
	}

	return elm$http$Http$Internal$FormDataBody(formData);
}



function _Process_sleep(time)
{
	return _Scheduler_binding(function(callback) {
		var id = setTimeout(function() {
			callback(_Scheduler_succeed(_Utils_Tuple0));
		}, time);

		return function() { clearTimeout(id); };
	});
}




// PROGRAMS


var _Platform_worker = F4(function(impl, flagDecoder, debugMetadata, args)
{
	return _Platform_initialize(
		flagDecoder,
		args,
		impl.init,
		impl.update,
		impl.subscriptions,
		function() { return function() {} }
	);
});



// INITIALIZE A PROGRAM


function _Platform_initialize(flagDecoder, args, init, update, subscriptions, stepperBuilder)
{
	var result = A2(_Json_run, flagDecoder, _Json_wrap(args ? args['flags'] : undefined));
	elm$core$Result$isOk(result) || _Debug_crash(2 /**/, _Json_errorToString(result.a) /**/);
	var managers = {};
	result = init(result.a);
	var model = result.a;
	var stepper = stepperBuilder(sendToApp, model);
	var ports = _Platform_setupEffects(managers, sendToApp);

	function sendToApp(msg, viewMetadata)
	{
		result = A2(update, msg, model);
		stepper(model = result.a, viewMetadata);
		_Platform_dispatchEffects(managers, result.b, subscriptions(model));
	}

	_Platform_dispatchEffects(managers, result.b, subscriptions(model));

	return ports ? { ports: ports } : {};
}



// TRACK PRELOADS
//
// This is used by code in elm/browser and elm/http
// to register any HTTP requests that are triggered by init.
//


var _Platform_preload;


function _Platform_registerPreload(url)
{
	_Platform_preload.add(url);
}



// EFFECT MANAGERS


var _Platform_effectManagers = {};


function _Platform_setupEffects(managers, sendToApp)
{
	var ports;

	// setup all necessary effect managers
	for (var key in _Platform_effectManagers)
	{
		var manager = _Platform_effectManagers[key];

		if (manager.a)
		{
			ports = ports || {};
			ports[key] = manager.a(key, sendToApp);
		}

		managers[key] = _Platform_instantiateManager(manager, sendToApp);
	}

	return ports;
}


function _Platform_createManager(init, onEffects, onSelfMsg, cmdMap, subMap)
{
	return {
		b: init,
		c: onEffects,
		d: onSelfMsg,
		e: cmdMap,
		f: subMap
	};
}


function _Platform_instantiateManager(info, sendToApp)
{
	var router = {
		g: sendToApp,
		h: undefined
	};

	var onEffects = info.c;
	var onSelfMsg = info.d;
	var cmdMap = info.e;
	var subMap = info.f;

	function loop(state)
	{
		return A2(_Scheduler_andThen, loop, _Scheduler_receive(function(msg)
		{
			var value = msg.a;

			if (msg.$ === 0)
			{
				return A3(onSelfMsg, router, value, state);
			}

			return cmdMap && subMap
				? A4(onEffects, router, value.i, value.j, state)
				: A3(onEffects, router, cmdMap ? value.i : value.j, state);
		}));
	}

	return router.h = _Scheduler_rawSpawn(A2(_Scheduler_andThen, loop, info.b));
}



// ROUTING


var _Platform_sendToApp = F2(function(router, msg)
{
	return _Scheduler_binding(function(callback)
	{
		router.g(msg);
		callback(_Scheduler_succeed(_Utils_Tuple0));
	});
});


var _Platform_sendToSelf = F2(function(router, msg)
{
	return A2(_Scheduler_send, router.h, {
		$: 0,
		a: msg
	});
});



// BAGS


function _Platform_leaf(home)
{
	return function(value)
	{
		return {
			$: 1,
			k: home,
			l: value
		};
	};
}


function _Platform_batch(list)
{
	return {
		$: 2,
		m: list
	};
}


var _Platform_map = F2(function(tagger, bag)
{
	return {
		$: 3,
		n: tagger,
		o: bag
	}
});



// PIPE BAGS INTO EFFECT MANAGERS


function _Platform_dispatchEffects(managers, cmdBag, subBag)
{
	var effectsDict = {};
	_Platform_gatherEffects(true, cmdBag, effectsDict, null);
	_Platform_gatherEffects(false, subBag, effectsDict, null);

	for (var home in managers)
	{
		_Scheduler_rawSend(managers[home], {
			$: 'fx',
			a: effectsDict[home] || { i: _List_Nil, j: _List_Nil }
		});
	}
}


function _Platform_gatherEffects(isCmd, bag, effectsDict, taggers)
{
	switch (bag.$)
	{
		case 1:
			var home = bag.k;
			var effect = _Platform_toEffect(isCmd, home, taggers, bag.l);
			effectsDict[home] = _Platform_insert(isCmd, effect, effectsDict[home]);
			return;

		case 2:
			for (var list = bag.m; list.b; list = list.b) // WHILE_CONS
			{
				_Platform_gatherEffects(isCmd, list.a, effectsDict, taggers);
			}
			return;

		case 3:
			_Platform_gatherEffects(isCmd, bag.o, effectsDict, {
				p: bag.n,
				q: taggers
			});
			return;
	}
}


function _Platform_toEffect(isCmd, home, taggers, value)
{
	function applyTaggers(x)
	{
		for (var temp = taggers; temp; temp = temp.q)
		{
			x = temp.p(x);
		}
		return x;
	}

	var map = isCmd
		? _Platform_effectManagers[home].e
		: _Platform_effectManagers[home].f;

	return A2(map, applyTaggers, value)
}


function _Platform_insert(isCmd, newEffect, effects)
{
	effects = effects || { i: _List_Nil, j: _List_Nil };

	isCmd
		? (effects.i = _List_Cons(newEffect, effects.i))
		: (effects.j = _List_Cons(newEffect, effects.j));

	return effects;
}



// PORTS


function _Platform_checkPortName(name)
{
	if (_Platform_effectManagers[name])
	{
		_Debug_crash(3, name)
	}
}



// OUTGOING PORTS


function _Platform_outgoingPort(name, converter)
{
	_Platform_checkPortName(name);
	_Platform_effectManagers[name] = {
		e: _Platform_outgoingPortMap,
		r: converter,
		a: _Platform_setupOutgoingPort
	};
	return _Platform_leaf(name);
}


var _Platform_outgoingPortMap = F2(function(tagger, value) { return value; });


function _Platform_setupOutgoingPort(name)
{
	var subs = [];
	var converter = _Platform_effectManagers[name].r;

	// CREATE MANAGER

	var init = _Process_sleep(0);

	_Platform_effectManagers[name].b = init;
	_Platform_effectManagers[name].c = F3(function(router, cmdList, state)
	{
		for ( ; cmdList.b; cmdList = cmdList.b) // WHILE_CONS
		{
			// grab a separate reference to subs in case unsubscribe is called
			var currentSubs = subs;
			var value = _Json_unwrap(converter(cmdList.a));
			for (var i = 0; i < currentSubs.length; i++)
			{
				currentSubs[i](value);
			}
		}
		return init;
	});

	// PUBLIC API

	function subscribe(callback)
	{
		subs.push(callback);
	}

	function unsubscribe(callback)
	{
		// copy subs into a new array in case unsubscribe is called within a
		// subscribed callback
		subs = subs.slice();
		var index = subs.indexOf(callback);
		if (index >= 0)
		{
			subs.splice(index, 1);
		}
	}

	return {
		subscribe: subscribe,
		unsubscribe: unsubscribe
	};
}



// INCOMING PORTS


function _Platform_incomingPort(name, converter)
{
	_Platform_checkPortName(name);
	_Platform_effectManagers[name] = {
		f: _Platform_incomingPortMap,
		r: converter,
		a: _Platform_setupIncomingPort
	};
	return _Platform_leaf(name);
}


var _Platform_incomingPortMap = F2(function(tagger, finalTagger)
{
	return function(value)
	{
		return tagger(finalTagger(value));
	};
});


function _Platform_setupIncomingPort(name, sendToApp)
{
	var subs = _List_Nil;
	var converter = _Platform_effectManagers[name].r;

	// CREATE MANAGER

	var init = _Scheduler_succeed(null);

	_Platform_effectManagers[name].b = init;
	_Platform_effectManagers[name].c = F3(function(router, subList, state)
	{
		subs = subList;
		return init;
	});

	// PUBLIC API

	function send(incomingValue)
	{
		var result = A2(_Json_run, converter, _Json_wrap(incomingValue));

		elm$core$Result$isOk(result) || _Debug_crash(4, name, result.a);

		var value = result.a;
		for (var temp = subs; temp.b; temp = temp.b) // WHILE_CONS
		{
			sendToApp(temp.a(value));
		}
	}

	return { send: send };
}



// EXPORT ELM MODULES
//
// Have DEBUG and PROD versions so that we can (1) give nicer errors in
// debug mode and (2) not pay for the bits needed for that in prod mode.
//


function _Platform_export_UNUSED(exports)
{
	scope['Elm']
		? _Platform_mergeExportsProd(scope['Elm'], exports)
		: scope['Elm'] = exports;
}


function _Platform_mergeExportsProd(obj, exports)
{
	for (var name in exports)
	{
		(name in obj)
			? (name == 'init')
				? _Debug_crash(6)
				: _Platform_mergeExportsProd(obj[name], exports[name])
			: (obj[name] = exports[name]);
	}
}


function _Platform_export(exports)
{
	scope['Elm']
		? _Platform_mergeExportsDebug('Elm', scope['Elm'], exports)
		: scope['Elm'] = exports;
}


function _Platform_mergeExportsDebug(moduleName, obj, exports)
{
	for (var name in exports)
	{
		(name in obj)
			? (name == 'init')
				? _Debug_crash(6, moduleName)
				: _Platform_mergeExportsDebug(moduleName + '.' + name, obj[name], exports[name])
			: (obj[name] = exports[name]);
	}
}




// HELPERS


var _VirtualDom_divertHrefToApp;

var _VirtualDom_doc = typeof document !== 'undefined' ? document : {};


function _VirtualDom_appendChild(parent, child)
{
	parent.appendChild(child);
}

var _VirtualDom_init = F4(function(virtualNode, flagDecoder, debugMetadata, args)
{
	// NOTE: this function needs _Platform_export available to work

	/**_UNUSED/
	var node = args['node'];
	//*/
	/**/
	var node = args && args['node'] ? args['node'] : _Debug_crash(0);
	//*/

	node.parentNode.replaceChild(
		_VirtualDom_render(virtualNode, function() {}),
		node
	);

	return {};
});



// TEXT


function _VirtualDom_text(string)
{
	return {
		$: 0,
		a: string
	};
}



// NODE


var _VirtualDom_nodeNS = F2(function(namespace, tag)
{
	return F2(function(factList, kidList)
	{
		for (var kids = [], descendantsCount = 0; kidList.b; kidList = kidList.b) // WHILE_CONS
		{
			var kid = kidList.a;
			descendantsCount += (kid.b || 0);
			kids.push(kid);
		}
		descendantsCount += kids.length;

		return {
			$: 1,
			c: tag,
			d: _VirtualDom_organizeFacts(factList),
			e: kids,
			f: namespace,
			b: descendantsCount
		};
	});
});


var _VirtualDom_node = _VirtualDom_nodeNS(undefined);



// KEYED NODE


var _VirtualDom_keyedNodeNS = F2(function(namespace, tag)
{
	return F2(function(factList, kidList)
	{
		for (var kids = [], descendantsCount = 0; kidList.b; kidList = kidList.b) // WHILE_CONS
		{
			var kid = kidList.a;
			descendantsCount += (kid.b.b || 0);
			kids.push(kid);
		}
		descendantsCount += kids.length;

		return {
			$: 2,
			c: tag,
			d: _VirtualDom_organizeFacts(factList),
			e: kids,
			f: namespace,
			b: descendantsCount
		};
	});
});


var _VirtualDom_keyedNode = _VirtualDom_keyedNodeNS(undefined);



// CUSTOM


function _VirtualDom_custom(factList, model, render, diff)
{
	return {
		$: 3,
		d: _VirtualDom_organizeFacts(factList),
		g: model,
		h: render,
		i: diff
	};
}



// MAP


var _VirtualDom_map = F2(function(tagger, node)
{
	return {
		$: 4,
		j: tagger,
		k: node,
		b: 1 + (node.b || 0)
	};
});



// LAZY


function _VirtualDom_thunk(refs, thunk)
{
	return {
		$: 5,
		l: refs,
		m: thunk,
		k: undefined
	};
}

var _VirtualDom_lazy = F2(function(func, a)
{
	return _VirtualDom_thunk([func, a], function() {
		return func(a);
	});
});

var _VirtualDom_lazy2 = F3(function(func, a, b)
{
	return _VirtualDom_thunk([func, a, b], function() {
		return A2(func, a, b);
	});
});

var _VirtualDom_lazy3 = F4(function(func, a, b, c)
{
	return _VirtualDom_thunk([func, a, b, c], function() {
		return A3(func, a, b, c);
	});
});

var _VirtualDom_lazy4 = F5(function(func, a, b, c, d)
{
	return _VirtualDom_thunk([func, a, b, c, d], function() {
		return A4(func, a, b, c, d);
	});
});

var _VirtualDom_lazy5 = F6(function(func, a, b, c, d, e)
{
	return _VirtualDom_thunk([func, a, b, c, d, e], function() {
		return A5(func, a, b, c, d, e);
	});
});

var _VirtualDom_lazy6 = F7(function(func, a, b, c, d, e, f)
{
	return _VirtualDom_thunk([func, a, b, c, d, e, f], function() {
		return A6(func, a, b, c, d, e, f);
	});
});

var _VirtualDom_lazy7 = F8(function(func, a, b, c, d, e, f, g)
{
	return _VirtualDom_thunk([func, a, b, c, d, e, f, g], function() {
		return A7(func, a, b, c, d, e, f, g);
	});
});

var _VirtualDom_lazy8 = F9(function(func, a, b, c, d, e, f, g, h)
{
	return _VirtualDom_thunk([func, a, b, c, d, e, f, g, h], function() {
		return A8(func, a, b, c, d, e, f, g, h);
	});
});



// FACTS


var _VirtualDom_on = F2(function(key, handler)
{
	return {
		$: 'a0',
		n: key,
		o: handler
	};
});
var _VirtualDom_style = F2(function(key, value)
{
	return {
		$: 'a1',
		n: key,
		o: value
	};
});
var _VirtualDom_property = F2(function(key, value)
{
	return {
		$: 'a2',
		n: key,
		o: value
	};
});
var _VirtualDom_attribute = F2(function(key, value)
{
	return {
		$: 'a3',
		n: key,
		o: value
	};
});
var _VirtualDom_attributeNS = F3(function(namespace, key, value)
{
	return {
		$: 'a4',
		n: key,
		o: { f: namespace, o: value }
	};
});



// XSS ATTACK VECTOR CHECKS


function _VirtualDom_noScript(tag)
{
	return tag == 'script' ? 'p' : tag;
}

function _VirtualDom_noOnOrFormAction(key)
{
	return /^(on|formAction$)/i.test(key) ? 'data-' + key : key;
}

function _VirtualDom_noInnerHtmlOrFormAction(key)
{
	return key == 'innerHTML' || key == 'formAction' ? 'data-' + key : key;
}

function _VirtualDom_noJavaScriptUri_UNUSED(value)
{
	return /^javascript:/i.test(value.replace(/\s/g,'')) ? '' : value;
}

function _VirtualDom_noJavaScriptUri(value)
{
	return /^javascript:/i.test(value.replace(/\s/g,''))
		? 'javascript:alert("This is an XSS vector. Please use ports or web components instead.")'
		: value;
}

function _VirtualDom_noJavaScriptOrHtmlUri_UNUSED(value)
{
	return /^\s*(javascript:|data:text\/html)/i.test(value) ? '' : value;
}

function _VirtualDom_noJavaScriptOrHtmlUri(value)
{
	return /^\s*(javascript:|data:text\/html)/i.test(value)
		? 'javascript:alert("This is an XSS vector. Please use ports or web components instead.")'
		: value;
}



// MAP FACTS


var _VirtualDom_mapAttribute = F2(function(func, attr)
{
	return (attr.$ === 'a0')
		? A2(_VirtualDom_on, attr.n, _VirtualDom_mapHandler(func, attr.o))
		: attr;
});

function _VirtualDom_mapHandler(func, handler)
{
	var tag = elm$virtual_dom$VirtualDom$toHandlerInt(handler);

	// 0 = Normal
	// 1 = MayStopPropagation
	// 2 = MayPreventDefault
	// 3 = Custom

	return {
		$: handler.$,
		a:
			!tag
				? A2(elm$json$Json$Decode$map, func, handler.a)
				:
			A3(elm$json$Json$Decode$map2,
				tag < 3
					? _VirtualDom_mapEventTuple
					: _VirtualDom_mapEventRecord,
				elm$json$Json$Decode$succeed(func),
				handler.a
			)
	};
}

var _VirtualDom_mapEventTuple = F2(function(func, tuple)
{
	return _Utils_Tuple2(func(tuple.a), tuple.b);
});

var _VirtualDom_mapEventRecord = F2(function(func, record)
{
	return {
		message: func(record.message),
		stopPropagation: record.stopPropagation,
		preventDefault: record.preventDefault
	}
});



// ORGANIZE FACTS


function _VirtualDom_organizeFacts(factList)
{
	for (var facts = {}; factList.b; factList = factList.b) // WHILE_CONS
	{
		var entry = factList.a;

		var tag = entry.$;
		var key = entry.n;
		var value = entry.o;

		if (tag === 'a2')
		{
			(key === 'className')
				? _VirtualDom_addClass(facts, key, _Json_unwrap(value))
				: facts[key] = _Json_unwrap(value);

			continue;
		}

		var subFacts = facts[tag] || (facts[tag] = {});
		(tag === 'a3' && key === 'class')
			? _VirtualDom_addClass(subFacts, key, value)
			: subFacts[key] = value;
	}

	return facts;
}

function _VirtualDom_addClass(object, key, newClass)
{
	var classes = object[key];
	object[key] = classes ? classes + ' ' + newClass : newClass;
}



// RENDER


function _VirtualDom_render(vNode, eventNode)
{
	var tag = vNode.$;

	if (tag === 5)
	{
		return _VirtualDom_render(vNode.k || (vNode.k = vNode.m()), eventNode);
	}

	if (tag === 0)
	{
		return _VirtualDom_doc.createTextNode(vNode.a);
	}

	if (tag === 4)
	{
		var subNode = vNode.k;
		var tagger = vNode.j;

		while (subNode.$ === 4)
		{
			typeof tagger !== 'object'
				? tagger = [tagger, subNode.j]
				: tagger.push(subNode.j);

			subNode = subNode.k;
		}

		var subEventRoot = { j: tagger, p: eventNode };
		var domNode = _VirtualDom_render(subNode, subEventRoot);
		domNode.elm_event_node_ref = subEventRoot;
		return domNode;
	}

	if (tag === 3)
	{
		var domNode = vNode.h(vNode.g);
		_VirtualDom_applyFacts(domNode, eventNode, vNode.d);
		return domNode;
	}

	// at this point `tag` must be 1 or 2

	var domNode = vNode.f
		? _VirtualDom_doc.createElementNS(vNode.f, vNode.c)
		: _VirtualDom_doc.createElement(vNode.c);

	if (_VirtualDom_divertHrefToApp && vNode.c == 'a')
	{
		domNode.addEventListener('click', _VirtualDom_divertHrefToApp(domNode));
	}

	_VirtualDom_applyFacts(domNode, eventNode, vNode.d);

	for (var kids = vNode.e, i = 0; i < kids.length; i++)
	{
		_VirtualDom_appendChild(domNode, _VirtualDom_render(tag === 1 ? kids[i] : kids[i].b, eventNode));
	}

	return domNode;
}



// APPLY FACTS


function _VirtualDom_applyFacts(domNode, eventNode, facts)
{
	for (var key in facts)
	{
		var value = facts[key];

		key === 'a1'
			? _VirtualDom_applyStyles(domNode, value)
			:
		key === 'a0'
			? _VirtualDom_applyEvents(domNode, eventNode, value)
			:
		key === 'a3'
			? _VirtualDom_applyAttrs(domNode, value)
			:
		key === 'a4'
			? _VirtualDom_applyAttrsNS(domNode, value)
			:
		(key !== 'value' || key !== 'checked' || domNode[key] !== value) && (domNode[key] = value);
	}
}



// APPLY STYLES


function _VirtualDom_applyStyles(domNode, styles)
{
	var domNodeStyle = domNode.style;

	for (var key in styles)
	{
		domNodeStyle[key] = styles[key];
	}
}



// APPLY ATTRS


function _VirtualDom_applyAttrs(domNode, attrs)
{
	for (var key in attrs)
	{
		var value = attrs[key];
		value
			? domNode.setAttribute(key, value)
			: domNode.removeAttribute(key);
	}
}



// APPLY NAMESPACED ATTRS


function _VirtualDom_applyAttrsNS(domNode, nsAttrs)
{
	for (var key in nsAttrs)
	{
		var pair = nsAttrs[key];
		var namespace = pair.f;
		var value = pair.o;

		value
			? domNode.setAttributeNS(namespace, key, value)
			: domNode.removeAttributeNS(namespace, key);
	}
}



// APPLY EVENTS


function _VirtualDom_applyEvents(domNode, eventNode, events)
{
	var allCallbacks = domNode.elmFs || (domNode.elmFs = {});

	for (var key in events)
	{
		var newHandler = events[key];
		var oldCallback = allCallbacks[key];

		if (!newHandler)
		{
			domNode.removeEventListener(key, oldCallback);
			allCallbacks[key] = undefined;
			continue;
		}

		if (oldCallback)
		{
			var oldHandler = oldCallback.q;
			if (oldHandler.$ === newHandler.$)
			{
				oldCallback.q = newHandler;
				continue;
			}
			domNode.removeEventListener(key, oldCallback);
		}

		oldCallback = _VirtualDom_makeCallback(eventNode, newHandler);
		domNode.addEventListener(key, oldCallback,
			_VirtualDom_passiveSupported
			&& { passive: elm$virtual_dom$VirtualDom$toHandlerInt(newHandler) < 2 }
		);
		allCallbacks[key] = oldCallback;
	}
}



// PASSIVE EVENTS


var _VirtualDom_passiveSupported;

try
{
	window.addEventListener('t', null, Object.defineProperty({}, 'passive', {
		get: function() { _VirtualDom_passiveSupported = true; }
	}));
}
catch(e) {}



// EVENT HANDLERS


function _VirtualDom_makeCallback(eventNode, initialHandler)
{
	function callback(event)
	{
		var handler = callback.q;
		var result = _Json_runHelp(handler.a, event);

		if (!elm$core$Result$isOk(result))
		{
			return;
		}

		var tag = elm$virtual_dom$VirtualDom$toHandlerInt(handler);

		// 0 = Normal
		// 1 = MayStopPropagation
		// 2 = MayPreventDefault
		// 3 = Custom

		var value = result.a;
		var message = !tag ? value : tag < 3 ? value.a : value.message;
		var stopPropagation = tag == 1 ? value.b : tag == 3 && value.stopPropagation;
		var currentEventNode = (
			stopPropagation && event.stopPropagation(),
			(tag == 2 ? value.b : tag == 3 && value.preventDefault) && event.preventDefault(),
			eventNode
		);
		var tagger;
		var i;
		while (tagger = currentEventNode.j)
		{
			if (typeof tagger == 'function')
			{
				message = tagger(message);
			}
			else
			{
				for (var i = tagger.length; i--; )
				{
					message = tagger[i](message);
				}
			}
			currentEventNode = currentEventNode.p;
		}
		currentEventNode(message, stopPropagation); // stopPropagation implies isSync
	}

	callback.q = initialHandler;

	return callback;
}

function _VirtualDom_equalEvents(x, y)
{
	return x.$ == y.$ && _Json_equality(x.a, y.a);
}



// DIFF


// TODO: Should we do patches like in iOS?
//
// type Patch
//   = At Int Patch
//   | Batch (List Patch)
//   | Change ...
//
// How could it not be better?
//
function _VirtualDom_diff(x, y)
{
	var patches = [];
	_VirtualDom_diffHelp(x, y, patches, 0);
	return patches;
}


function _VirtualDom_pushPatch(patches, type, index, data)
{
	var patch = {
		$: type,
		r: index,
		s: data,
		t: undefined,
		u: undefined
	};
	patches.push(patch);
	return patch;
}


function _VirtualDom_diffHelp(x, y, patches, index)
{
	if (x === y)
	{
		return;
	}

	var xType = x.$;
	var yType = y.$;

	// Bail if you run into different types of nodes. Implies that the
	// structure has changed significantly and it's not worth a diff.
	if (xType !== yType)
	{
		if (xType === 1 && yType === 2)
		{
			y = _VirtualDom_dekey(y);
			yType = 1;
		}
		else
		{
			_VirtualDom_pushPatch(patches, 0, index, y);
			return;
		}
	}

	// Now we know that both nodes are the same $.
	switch (yType)
	{
		case 5:
			var xRefs = x.l;
			var yRefs = y.l;
			var i = xRefs.length;
			var same = i === yRefs.length;
			while (same && i--)
			{
				same = xRefs[i] === yRefs[i];
			}
			if (same)
			{
				y.k = x.k;
				return;
			}
			y.k = y.m();
			var subPatches = [];
			_VirtualDom_diffHelp(x.k, y.k, subPatches, 0);
			subPatches.length > 0 && _VirtualDom_pushPatch(patches, 1, index, subPatches);
			return;

		case 4:
			// gather nested taggers
			var xTaggers = x.j;
			var yTaggers = y.j;
			var nesting = false;

			var xSubNode = x.k;
			while (xSubNode.$ === 4)
			{
				nesting = true;

				typeof xTaggers !== 'object'
					? xTaggers = [xTaggers, xSubNode.j]
					: xTaggers.push(xSubNode.j);

				xSubNode = xSubNode.k;
			}

			var ySubNode = y.k;
			while (ySubNode.$ === 4)
			{
				nesting = true;

				typeof yTaggers !== 'object'
					? yTaggers = [yTaggers, ySubNode.j]
					: yTaggers.push(ySubNode.j);

				ySubNode = ySubNode.k;
			}

			// Just bail if different numbers of taggers. This implies the
			// structure of the virtual DOM has changed.
			if (nesting && xTaggers.length !== yTaggers.length)
			{
				_VirtualDom_pushPatch(patches, 0, index, y);
				return;
			}

			// check if taggers are "the same"
			if (nesting ? !_VirtualDom_pairwiseRefEqual(xTaggers, yTaggers) : xTaggers !== yTaggers)
			{
				_VirtualDom_pushPatch(patches, 2, index, yTaggers);
			}

			// diff everything below the taggers
			_VirtualDom_diffHelp(xSubNode, ySubNode, patches, index + 1);
			return;

		case 0:
			if (x.a !== y.a)
			{
				_VirtualDom_pushPatch(patches, 3, index, y.a);
			}
			return;

		case 1:
			_VirtualDom_diffNodes(x, y, patches, index, _VirtualDom_diffKids);
			return;

		case 2:
			_VirtualDom_diffNodes(x, y, patches, index, _VirtualDom_diffKeyedKids);
			return;

		case 3:
			if (x.h !== y.h)
			{
				_VirtualDom_pushPatch(patches, 0, index, y);
				return;
			}

			var factsDiff = _VirtualDom_diffFacts(x.d, y.d);
			factsDiff && _VirtualDom_pushPatch(patches, 4, index, factsDiff);

			var patch = y.i(x.g, y.g);
			patch && _VirtualDom_pushPatch(patches, 5, index, patch);

			return;
	}
}

// assumes the incoming arrays are the same length
function _VirtualDom_pairwiseRefEqual(as, bs)
{
	for (var i = 0; i < as.length; i++)
	{
		if (as[i] !== bs[i])
		{
			return false;
		}
	}

	return true;
}

function _VirtualDom_diffNodes(x, y, patches, index, diffKids)
{
	// Bail if obvious indicators have changed. Implies more serious
	// structural changes such that it's not worth it to diff.
	if (x.c !== y.c || x.f !== y.f)
	{
		_VirtualDom_pushPatch(patches, 0, index, y);
		return;
	}

	var factsDiff = _VirtualDom_diffFacts(x.d, y.d);
	factsDiff && _VirtualDom_pushPatch(patches, 4, index, factsDiff);

	diffKids(x, y, patches, index);
}



// DIFF FACTS


// TODO Instead of creating a new diff object, it's possible to just test if
// there *is* a diff. During the actual patch, do the diff again and make the
// modifications directly. This way, there's no new allocations. Worth it?
function _VirtualDom_diffFacts(x, y, category)
{
	var diff;

	// look for changes and removals
	for (var xKey in x)
	{
		if (xKey === 'a1' || xKey === 'a0' || xKey === 'a3' || xKey === 'a4')
		{
			var subDiff = _VirtualDom_diffFacts(x[xKey], y[xKey] || {}, xKey);
			if (subDiff)
			{
				diff = diff || {};
				diff[xKey] = subDiff;
			}
			continue;
		}

		// remove if not in the new facts
		if (!(xKey in y))
		{
			diff = diff || {};
			diff[xKey] =
				!category
					? (typeof x[xKey] === 'string' ? '' : null)
					:
				(category === 'a1')
					? ''
					:
				(category === 'a0' || category === 'a3')
					? undefined
					:
				{ f: x[xKey].f, o: undefined };

			continue;
		}

		var xValue = x[xKey];
		var yValue = y[xKey];

		// reference equal, so don't worry about it
		if (xValue === yValue && xKey !== 'value' && xKey !== 'checked'
			|| category === 'a0' && _VirtualDom_equalEvents(xValue, yValue))
		{
			continue;
		}

		diff = diff || {};
		diff[xKey] = yValue;
	}

	// add new stuff
	for (var yKey in y)
	{
		if (!(yKey in x))
		{
			diff = diff || {};
			diff[yKey] = y[yKey];
		}
	}

	return diff;
}



// DIFF KIDS


function _VirtualDom_diffKids(xParent, yParent, patches, index)
{
	var xKids = xParent.e;
	var yKids = yParent.e;

	var xLen = xKids.length;
	var yLen = yKids.length;

	// FIGURE OUT IF THERE ARE INSERTS OR REMOVALS

	if (xLen > yLen)
	{
		_VirtualDom_pushPatch(patches, 6, index, {
			v: yLen,
			i: xLen - yLen
		});
	}
	else if (xLen < yLen)
	{
		_VirtualDom_pushPatch(patches, 7, index, {
			v: xLen,
			e: yKids
		});
	}

	// PAIRWISE DIFF EVERYTHING ELSE

	for (var minLen = xLen < yLen ? xLen : yLen, i = 0; i < minLen; i++)
	{
		var xKid = xKids[i];
		_VirtualDom_diffHelp(xKid, yKids[i], patches, ++index);
		index += xKid.b || 0;
	}
}



// KEYED DIFF


function _VirtualDom_diffKeyedKids(xParent, yParent, patches, rootIndex)
{
	var localPatches = [];

	var changes = {}; // Dict String Entry
	var inserts = []; // Array { index : Int, entry : Entry }
	// type Entry = { tag : String, vnode : VNode, index : Int, data : _ }

	var xKids = xParent.e;
	var yKids = yParent.e;
	var xLen = xKids.length;
	var yLen = yKids.length;
	var xIndex = 0;
	var yIndex = 0;

	var index = rootIndex;

	while (xIndex < xLen && yIndex < yLen)
	{
		var x = xKids[xIndex];
		var y = yKids[yIndex];

		var xKey = x.a;
		var yKey = y.a;
		var xNode = x.b;
		var yNode = y.b;

		// check if keys match

		if (xKey === yKey)
		{
			index++;
			_VirtualDom_diffHelp(xNode, yNode, localPatches, index);
			index += xNode.b || 0;

			xIndex++;
			yIndex++;
			continue;
		}

		// look ahead 1 to detect insertions and removals.

		var xNext = xKids[xIndex + 1];
		var yNext = yKids[yIndex + 1];

		if (xNext)
		{
			var xNextKey = xNext.a;
			var xNextNode = xNext.b;
			var oldMatch = yKey === xNextKey;
		}

		if (yNext)
		{
			var yNextKey = yNext.a;
			var yNextNode = yNext.b;
			var newMatch = xKey === yNextKey;
		}


		// swap x and y
		if (newMatch && oldMatch)
		{
			index++;
			_VirtualDom_diffHelp(xNode, yNextNode, localPatches, index);
			_VirtualDom_insertNode(changes, localPatches, xKey, yNode, yIndex, inserts);
			index += xNode.b || 0;

			index++;
			_VirtualDom_removeNode(changes, localPatches, xKey, xNextNode, index);
			index += xNextNode.b || 0;

			xIndex += 2;
			yIndex += 2;
			continue;
		}

		// insert y
		if (newMatch)
		{
			index++;
			_VirtualDom_insertNode(changes, localPatches, yKey, yNode, yIndex, inserts);
			_VirtualDom_diffHelp(xNode, yNextNode, localPatches, index);
			index += xNode.b || 0;

			xIndex += 1;
			yIndex += 2;
			continue;
		}

		// remove x
		if (oldMatch)
		{
			index++;
			_VirtualDom_removeNode(changes, localPatches, xKey, xNode, index);
			index += xNode.b || 0;

			index++;
			_VirtualDom_diffHelp(xNextNode, yNode, localPatches, index);
			index += xNextNode.b || 0;

			xIndex += 2;
			yIndex += 1;
			continue;
		}

		// remove x, insert y
		if (xNext && xNextKey === yNextKey)
		{
			index++;
			_VirtualDom_removeNode(changes, localPatches, xKey, xNode, index);
			_VirtualDom_insertNode(changes, localPatches, yKey, yNode, yIndex, inserts);
			index += xNode.b || 0;

			index++;
			_VirtualDom_diffHelp(xNextNode, yNextNode, localPatches, index);
			index += xNextNode.b || 0;

			xIndex += 2;
			yIndex += 2;
			continue;
		}

		break;
	}

	// eat up any remaining nodes with removeNode and insertNode

	while (xIndex < xLen)
	{
		index++;
		var x = xKids[xIndex];
		var xNode = x.b;
		_VirtualDom_removeNode(changes, localPatches, x.a, xNode, index);
		index += xNode.b || 0;
		xIndex++;
	}

	while (yIndex < yLen)
	{
		var endInserts = endInserts || [];
		var y = yKids[yIndex];
		_VirtualDom_insertNode(changes, localPatches, y.a, y.b, undefined, endInserts);
		yIndex++;
	}

	if (localPatches.length > 0 || inserts.length > 0 || endInserts)
	{
		_VirtualDom_pushPatch(patches, 8, rootIndex, {
			w: localPatches,
			x: inserts,
			y: endInserts
		});
	}
}



// CHANGES FROM KEYED DIFF


var _VirtualDom_POSTFIX = '_elmW6BL';


function _VirtualDom_insertNode(changes, localPatches, key, vnode, yIndex, inserts)
{
	var entry = changes[key];

	// never seen this key before
	if (!entry)
	{
		entry = {
			c: 0,
			z: vnode,
			r: yIndex,
			s: undefined
		};

		inserts.push({ r: yIndex, A: entry });
		changes[key] = entry;

		return;
	}

	// this key was removed earlier, a match!
	if (entry.c === 1)
	{
		inserts.push({ r: yIndex, A: entry });

		entry.c = 2;
		var subPatches = [];
		_VirtualDom_diffHelp(entry.z, vnode, subPatches, entry.r);
		entry.r = yIndex;
		entry.s.s = {
			w: subPatches,
			A: entry
		};

		return;
	}

	// this key has already been inserted or moved, a duplicate!
	_VirtualDom_insertNode(changes, localPatches, key + _VirtualDom_POSTFIX, vnode, yIndex, inserts);
}


function _VirtualDom_removeNode(changes, localPatches, key, vnode, index)
{
	var entry = changes[key];

	// never seen this key before
	if (!entry)
	{
		var patch = _VirtualDom_pushPatch(localPatches, 9, index, undefined);

		changes[key] = {
			c: 1,
			z: vnode,
			r: index,
			s: patch
		};

		return;
	}

	// this key was inserted earlier, a match!
	if (entry.c === 0)
	{
		entry.c = 2;
		var subPatches = [];
		_VirtualDom_diffHelp(vnode, entry.z, subPatches, index);

		_VirtualDom_pushPatch(localPatches, 9, index, {
			w: subPatches,
			A: entry
		});

		return;
	}

	// this key has already been removed or moved, a duplicate!
	_VirtualDom_removeNode(changes, localPatches, key + _VirtualDom_POSTFIX, vnode, index);
}



// ADD DOM NODES
//
// Each DOM node has an "index" assigned in order of traversal. It is important
// to minimize our crawl over the actual DOM, so these indexes (along with the
// descendantsCount of virtual nodes) let us skip touching entire subtrees of
// the DOM if we know there are no patches there.


function _VirtualDom_addDomNodes(domNode, vNode, patches, eventNode)
{
	_VirtualDom_addDomNodesHelp(domNode, vNode, patches, 0, 0, vNode.b, eventNode);
}


// assumes `patches` is non-empty and indexes increase monotonically.
function _VirtualDom_addDomNodesHelp(domNode, vNode, patches, i, low, high, eventNode)
{
	var patch = patches[i];
	var index = patch.r;

	while (index === low)
	{
		var patchType = patch.$;

		if (patchType === 1)
		{
			_VirtualDom_addDomNodes(domNode, vNode.k, patch.s, eventNode);
		}
		else if (patchType === 8)
		{
			patch.t = domNode;
			patch.u = eventNode;

			var subPatches = patch.s.w;
			if (subPatches.length > 0)
			{
				_VirtualDom_addDomNodesHelp(domNode, vNode, subPatches, 0, low, high, eventNode);
			}
		}
		else if (patchType === 9)
		{
			patch.t = domNode;
			patch.u = eventNode;

			var data = patch.s;
			if (data)
			{
				data.A.s = domNode;
				var subPatches = data.w;
				if (subPatches.length > 0)
				{
					_VirtualDom_addDomNodesHelp(domNode, vNode, subPatches, 0, low, high, eventNode);
				}
			}
		}
		else
		{
			patch.t = domNode;
			patch.u = eventNode;
		}

		i++;

		if (!(patch = patches[i]) || (index = patch.r) > high)
		{
			return i;
		}
	}

	var tag = vNode.$;

	if (tag === 4)
	{
		var subNode = vNode.k;

		while (subNode.$ === 4)
		{
			subNode = subNode.k;
		}

		return _VirtualDom_addDomNodesHelp(domNode, subNode, patches, i, low + 1, high, domNode.elm_event_node_ref);
	}

	// tag must be 1 or 2 at this point

	var vKids = vNode.e;
	var childNodes = domNode.childNodes;
	for (var j = 0; j < vKids.length; j++)
	{
		low++;
		var vKid = tag === 1 ? vKids[j] : vKids[j].b;
		var nextLow = low + (vKid.b || 0);
		if (low <= index && index <= nextLow)
		{
			i = _VirtualDom_addDomNodesHelp(childNodes[j], vKid, patches, i, low, nextLow, eventNode);
			if (!(patch = patches[i]) || (index = patch.r) > high)
			{
				return i;
			}
		}
		low = nextLow;
	}
	return i;
}



// APPLY PATCHES


function _VirtualDom_applyPatches(rootDomNode, oldVirtualNode, patches, eventNode)
{
	if (patches.length === 0)
	{
		return rootDomNode;
	}

	_VirtualDom_addDomNodes(rootDomNode, oldVirtualNode, patches, eventNode);
	return _VirtualDom_applyPatchesHelp(rootDomNode, patches);
}

function _VirtualDom_applyPatchesHelp(rootDomNode, patches)
{
	for (var i = 0; i < patches.length; i++)
	{
		var patch = patches[i];
		var localDomNode = patch.t
		var newNode = _VirtualDom_applyPatch(localDomNode, patch);
		if (localDomNode === rootDomNode)
		{
			rootDomNode = newNode;
		}
	}
	return rootDomNode;
}

function _VirtualDom_applyPatch(domNode, patch)
{
	switch (patch.$)
	{
		case 0:
			return _VirtualDom_applyPatchRedraw(domNode, patch.s, patch.u);

		case 4:
			_VirtualDom_applyFacts(domNode, patch.u, patch.s);
			return domNode;

		case 3:
			domNode.replaceData(0, domNode.length, patch.s);
			return domNode;

		case 1:
			return _VirtualDom_applyPatchesHelp(domNode, patch.s);

		case 2:
			if (domNode.elm_event_node_ref)
			{
				domNode.elm_event_node_ref.j = patch.s;
			}
			else
			{
				domNode.elm_event_node_ref = { j: patch.s, p: patch.u };
			}
			return domNode;

		case 6:
			var data = patch.s;
			for (var i = 0; i < data.i; i++)
			{
				domNode.removeChild(domNode.childNodes[data.v]);
			}
			return domNode;

		case 7:
			var data = patch.s;
			var kids = data.e;
			var i = data.v;
			var theEnd = domNode.childNodes[i];
			for (; i < kids.length; i++)
			{
				domNode.insertBefore(_VirtualDom_render(kids[i], patch.u), theEnd);
			}
			return domNode;

		case 9:
			var data = patch.s;
			if (!data)
			{
				domNode.parentNode.removeChild(domNode);
				return domNode;
			}
			var entry = data.A;
			if (typeof entry.r !== 'undefined')
			{
				domNode.parentNode.removeChild(domNode);
			}
			entry.s = _VirtualDom_applyPatchesHelp(domNode, data.w);
			return domNode;

		case 8:
			return _VirtualDom_applyPatchReorder(domNode, patch);

		case 5:
			return patch.s(domNode);

		default:
			_Debug_crash(10); // 'Ran into an unknown patch!'
	}
}


function _VirtualDom_applyPatchRedraw(domNode, vNode, eventNode)
{
	var parentNode = domNode.parentNode;
	var newNode = _VirtualDom_render(vNode, eventNode);

	if (!newNode.elm_event_node_ref)
	{
		newNode.elm_event_node_ref = domNode.elm_event_node_ref;
	}

	if (parentNode && newNode !== domNode)
	{
		parentNode.replaceChild(newNode, domNode);
	}
	return newNode;
}


function _VirtualDom_applyPatchReorder(domNode, patch)
{
	var data = patch.s;

	// remove end inserts
	var frag = _VirtualDom_applyPatchReorderEndInsertsHelp(data.y, patch);

	// removals
	domNode = _VirtualDom_applyPatchesHelp(domNode, data.w);

	// inserts
	var inserts = data.x;
	for (var i = 0; i < inserts.length; i++)
	{
		var insert = inserts[i];
		var entry = insert.A;
		var node = entry.c === 2
			? entry.s
			: _VirtualDom_render(entry.z, patch.u);
		domNode.insertBefore(node, domNode.childNodes[insert.r]);
	}

	// add end inserts
	if (frag)
	{
		_VirtualDom_appendChild(domNode, frag);
	}

	return domNode;
}


function _VirtualDom_applyPatchReorderEndInsertsHelp(endInserts, patch)
{
	if (!endInserts)
	{
		return;
	}

	var frag = _VirtualDom_doc.createDocumentFragment();
	for (var i = 0; i < endInserts.length; i++)
	{
		var insert = endInserts[i];
		var entry = insert.A;
		_VirtualDom_appendChild(frag, entry.c === 2
			? entry.s
			: _VirtualDom_render(entry.z, patch.u)
		);
	}
	return frag;
}


function _VirtualDom_virtualize(node)
{
	// TEXT NODES

	if (node.nodeType === 3)
	{
		return _VirtualDom_text(node.textContent);
	}


	// WEIRD NODES

	if (node.nodeType !== 1)
	{
		return _VirtualDom_text('');
	}


	// ELEMENT NODES

	var attrList = _List_Nil;
	var attrs = node.attributes;
	for (var i = attrs.length; i--; )
	{
		var attr = attrs[i];
		var name = attr.name;
		var value = attr.value;
		attrList = _List_Cons( A2(_VirtualDom_attribute, name, value), attrList );
	}

	var tag = node.tagName.toLowerCase();
	var kidList = _List_Nil;
	var kids = node.childNodes;

	for (var i = kids.length; i--; )
	{
		kidList = _List_Cons(_VirtualDom_virtualize(kids[i]), kidList);
	}
	return A3(_VirtualDom_node, tag, attrList, kidList);
}

function _VirtualDom_dekey(keyedNode)
{
	var keyedKids = keyedNode.e;
	var len = keyedKids.length;
	var kids = new Array(len);
	for (var i = 0; i < len; i++)
	{
		kids[i] = keyedKids[i].b;
	}

	return {
		$: 1,
		c: keyedNode.c,
		d: keyedNode.d,
		e: kids,
		f: keyedNode.f,
		b: keyedNode.b
	};
}



// ELEMENT


var _Debugger_element;

var _Browser_element = _Debugger_element || F4(function(impl, flagDecoder, debugMetadata, args)
{
	return _Platform_initialize(
		flagDecoder,
		args,
		impl.init,
		impl.update,
		impl.subscriptions,
		function(sendToApp, initialModel) {
			var view = impl.view;
			/**_UNUSED/
			var domNode = args['node'];
			//*/
			/**/
			var domNode = args && args['node'] ? args['node'] : _Debug_crash(0);
			//*/
			var currNode = _VirtualDom_virtualize(domNode);

			return _Browser_makeAnimator(initialModel, function(model)
			{
				var nextNode = view(model);
				var patches = _VirtualDom_diff(currNode, nextNode);
				domNode = _VirtualDom_applyPatches(domNode, currNode, patches, sendToApp);
				currNode = nextNode;
			});
		}
	);
});



// DOCUMENT


var _Debugger_document;

var _Browser_document = _Debugger_document || F4(function(impl, flagDecoder, debugMetadata, args)
{
	return _Platform_initialize(
		flagDecoder,
		args,
		impl.init,
		impl.update,
		impl.subscriptions,
		function(sendToApp, initialModel) {
			var divertHrefToApp = impl.setup && impl.setup(sendToApp)
			var view = impl.view;
			var title = _VirtualDom_doc.title;
			var bodyNode = _VirtualDom_doc.body;
			var currNode = _VirtualDom_virtualize(bodyNode);
			return _Browser_makeAnimator(initialModel, function(model)
			{
				_VirtualDom_divertHrefToApp = divertHrefToApp;
				var doc = view(model);
				var nextNode = _VirtualDom_node('body')(_List_Nil)(doc.body);
				var patches = _VirtualDom_diff(currNode, nextNode);
				bodyNode = _VirtualDom_applyPatches(bodyNode, currNode, patches, sendToApp);
				currNode = nextNode;
				_VirtualDom_divertHrefToApp = 0;
				(title !== doc.title) && (_VirtualDom_doc.title = title = doc.title);
			});
		}
	);
});



// ANIMATION


var _Browser_requestAnimationFrame =
	typeof requestAnimationFrame !== 'undefined'
		? requestAnimationFrame
		: function(callback) { setTimeout(callback, 1000 / 60); };


function _Browser_makeAnimator(model, draw)
{
	draw(model);

	var state = 0;

	function updateIfNeeded()
	{
		state = state === 1
			? 0
			: ( _Browser_requestAnimationFrame(updateIfNeeded), draw(model), 1 );
	}

	return function(nextModel, isSync)
	{
		model = nextModel;

		isSync
			? ( draw(model),
				state === 2 && (state = 1)
				)
			: ( state === 0 && _Browser_requestAnimationFrame(updateIfNeeded),
				state = 2
				);
	};
}



// APPLICATION


function _Browser_application(impl)
{
	var onUrlChange = impl.onUrlChange;
	var onUrlRequest = impl.onUrlRequest;
	var key = function() { key.a(onUrlChange(_Browser_getUrl())); };

	return _Browser_document({
		setup: function(sendToApp)
		{
			key.a = sendToApp;
			_Browser_window.addEventListener('popstate', key);
			_Browser_window.navigator.userAgent.indexOf('Trident') < 0 || _Browser_window.addEventListener('hashchange', key);

			return F2(function(domNode, event)
			{
				if (!event.ctrlKey && !event.metaKey && !event.shiftKey && event.button < 1 && !domNode.target && !domNode.download)
				{
					event.preventDefault();
					var href = domNode.href;
					var curr = _Browser_getUrl();
					var next = elm$url$Url$fromString(href).a;
					sendToApp(onUrlRequest(
						(next
							&& curr.protocol === next.protocol
							&& curr.host === next.host
							&& curr.port_.a === next.port_.a
						)
							? elm$browser$Browser$Internal(next)
							: elm$browser$Browser$External(href)
					));
				}
			});
		},
		init: function(flags)
		{
			return A3(impl.init, flags, _Browser_getUrl(), key);
		},
		view: impl.view,
		update: impl.update,
		subscriptions: impl.subscriptions
	});
}

function _Browser_getUrl()
{
	return elm$url$Url$fromString(_VirtualDom_doc.location.href).a || _Debug_crash(1);
}

var _Browser_go = F2(function(key, n)
{
	return A2(elm$core$Task$perform, elm$core$Basics$never, _Scheduler_binding(function() {
		n && history.go(n);
		key();
	}));
});

var _Browser_pushUrl = F2(function(key, url)
{
	return A2(elm$core$Task$perform, elm$core$Basics$never, _Scheduler_binding(function() {
		history.pushState({}, '', url);
		key();
	}));
});

var _Browser_replaceUrl = F2(function(key, url)
{
	return A2(elm$core$Task$perform, elm$core$Basics$never, _Scheduler_binding(function() {
		history.replaceState({}, '', url);
		key();
	}));
});



// GLOBAL EVENTS


var _Browser_fakeNode = { addEventListener: function() {}, removeEventListener: function() {} };
var _Browser_doc = typeof document !== 'undefined' ? document : _Browser_fakeNode;
var _Browser_window = typeof window !== 'undefined' ? window : _Browser_fakeNode;

var _Browser_on = F3(function(node, eventName, sendToSelf)
{
	return _Scheduler_spawn(_Scheduler_binding(function(callback)
	{
		function handler(event)	{ _Scheduler_rawSpawn(sendToSelf(event)); }
		node.addEventListener(eventName, handler, _VirtualDom_passiveSupported && { passive: true });
		return function() { node.removeEventListener(eventName, handler); };
	}));
});

var _Browser_decodeEvent = F2(function(decoder, event)
{
	var result = _Json_runHelp(decoder, event);
	return elm$core$Result$isOk(result) ? elm$core$Maybe$Just(result.a) : elm$core$Maybe$Nothing;
});



// PAGE VISIBILITY


function _Browser_visibilityInfo()
{
	return (typeof _VirtualDom_doc.hidden !== 'undefined')
		? { hidden: 'hidden', change: 'visibilitychange' }
		:
	(typeof _VirtualDom_doc.mozHidden !== 'undefined')
		? { hidden: 'mozHidden', change: 'mozvisibilitychange' }
		:
	(typeof _VirtualDom_doc.msHidden !== 'undefined')
		? { hidden: 'msHidden', change: 'msvisibilitychange' }
		:
	(typeof _VirtualDom_doc.webkitHidden !== 'undefined')
		? { hidden: 'webkitHidden', change: 'webkitvisibilitychange' }
		: { hidden: 'hidden', change: 'visibilitychange' };
}



// ANIMATION FRAMES


function _Browser_rAF()
{
	return _Scheduler_binding(function(callback)
	{
		var id = requestAnimationFrame(function() {
			callback(_Scheduler_succeed(Date.now()));
		});

		return function() {
			cancelAnimationFrame(id);
		};
	});
}


function _Browser_now()
{
	return _Scheduler_binding(function(callback)
	{
		callback(_Scheduler_succeed(Date.now()));
	});
}



// DOM STUFF


function _Browser_withNode(id, doStuff)
{
	return _Scheduler_binding(function(callback)
	{
		_Browser_requestAnimationFrame(function() {
			var node = document.getElementById(id);
			callback(node
				? _Scheduler_succeed(doStuff(node))
				: _Scheduler_fail(elm$browser$Browser$Dom$NotFound(id))
			);
		});
	});
}


function _Browser_withWindow(doStuff)
{
	return _Scheduler_binding(function(callback)
	{
		_Browser_requestAnimationFrame(function() {
			callback(_Scheduler_succeed(doStuff()));
		});
	});
}


// FOCUS and BLUR


var _Browser_call = F2(function(functionName, id)
{
	return _Browser_withNode(id, function(node) {
		node[functionName]();
		return _Utils_Tuple0;
	});
});



// WINDOW VIEWPORT


function _Browser_getViewport()
{
	return {
		scene: _Browser_getScene(),
		viewport: {
			x: _Browser_window.pageXOffset,
			y: _Browser_window.pageYOffset,
			width: _Browser_doc.documentElement.clientWidth,
			height: _Browser_doc.documentElement.clientHeight
		}
	};
}

function _Browser_getScene()
{
	var body = _Browser_doc.body;
	var elem = _Browser_doc.documentElement;
	return {
		width: Math.max(body.scrollWidth, body.offsetWidth, elem.scrollWidth, elem.offsetWidth, elem.clientWidth),
		height: Math.max(body.scrollHeight, body.offsetHeight, elem.scrollHeight, elem.offsetHeight, elem.clientHeight)
	};
}

var _Browser_setViewport = F2(function(x, y)
{
	return _Browser_withWindow(function()
	{
		_Browser_window.scroll(x, y);
		return _Utils_Tuple0;
	});
});



// ELEMENT VIEWPORT


function _Browser_getViewportOf(id)
{
	return _Browser_withNode(id, function(node)
	{
		return {
			scene: {
				width: node.scrollWidth,
				height: node.scrollHeight
			},
			viewport: {
				x: node.scrollLeft,
				y: node.scrollTop,
				width: node.clientWidth,
				height: node.clientHeight
			}
		};
	});
}


var _Browser_setViewportOf = F3(function(id, x, y)
{
	return _Browser_withNode(id, function(node)
	{
		node.scrollLeft = x;
		node.scrollTop = y;
		return _Utils_Tuple0;
	});
});



// ELEMENT


function _Browser_getElement(id)
{
	return _Browser_withNode(id, function(node)
	{
		var rect = node.getBoundingClientRect();
		var x = _Browser_window.pageXOffset;
		var y = _Browser_window.pageYOffset;
		return {
			scene: _Browser_getScene(),
			viewport: {
				x: x,
				y: y,
				width: _Browser_doc.documentElement.clientWidth,
				height: _Browser_doc.documentElement.clientHeight
			},
			element: {
				x: x + rect.left,
				y: y + rect.top,
				width: rect.width,
				height: rect.height
			}
		};
	});
}



// LOAD and RELOAD


function _Browser_reload(skipCache)
{
	return A2(elm$core$Task$perform, elm$core$Basics$never, _Scheduler_binding(function(callback)
	{
		_VirtualDom_doc.location.reload(skipCache);
	}));
}

function _Browser_load(url)
{
	return A2(elm$core$Task$perform, elm$core$Basics$never, _Scheduler_binding(function(callback)
	{
		try
		{
			_Browser_window.location = url;
		}
		catch(err)
		{
			// Only Firefox can throw a NS_ERROR_MALFORMED_URI exception here.
			// Other browsers reload the page, so let's be consistent about that.
			_VirtualDom_doc.location.reload(false);
		}
	}));
}



var _Bitwise_and = F2(function(a, b)
{
	return a & b;
});

var _Bitwise_or = F2(function(a, b)
{
	return a | b;
});

var _Bitwise_xor = F2(function(a, b)
{
	return a ^ b;
});

function _Bitwise_complement(a)
{
	return ~a;
};

var _Bitwise_shiftLeftBy = F2(function(offset, a)
{
	return a << offset;
});

var _Bitwise_shiftRightBy = F2(function(offset, a)
{
	return a >> offset;
});

var _Bitwise_shiftRightZfBy = F2(function(offset, a)
{
	return a >>> offset;
});



function _Time_now(millisToPosix)
{
	return _Scheduler_binding(function(callback)
	{
		callback(_Scheduler_succeed(millisToPosix(Date.now())));
	});
}

var _Time_setInterval = F2(function(interval, task)
{
	return _Scheduler_binding(function(callback)
	{
		var id = setInterval(function() { _Scheduler_rawSpawn(task); }, interval);
		return function() { clearInterval(id); };
	});
});

function _Time_here()
{
	return _Scheduler_binding(function(callback)
	{
		callback(_Scheduler_succeed(
			A2(elm$time$Time$customZone, -(new Date().getTimezoneOffset()), _List_Nil)
		));
	});
}


function _Time_getZoneName()
{
	return _Scheduler_binding(function(callback)
	{
		try
		{
			var name = elm$time$Time$Name(Intl.DateTimeFormat().resolvedOptions().timeZone);
		}
		catch (e)
		{
			var name = elm$time$Time$Offset(new Date().getTimezoneOffset());
		}
		callback(_Scheduler_succeed(name));
	});
}
var author$project$WordApp$ChangedUrl = function (a) {
	return {$: 'ChangedUrl', a: a};
};
var author$project$WordApp$ClickedLink = function (a) {
	return {$: 'ClickedLink', a: a};
};
var author$project$Data$Session$Session = F2(
	function (authToken, user) {
		return {authToken: authToken, user: user};
	});
var author$project$API$User = F4(
	function (userid, username, email, languages) {
		return {email: email, languages: languages, userid: userid, username: username};
	});
var elm$core$Array$branchFactor = 32;
var elm$core$Array$Array_elm_builtin = F4(
	function (a, b, c, d) {
		return {$: 'Array_elm_builtin', a: a, b: b, c: c, d: d};
	});
var elm$core$Basics$EQ = {$: 'EQ'};
var elm$core$Basics$GT = {$: 'GT'};
var elm$core$Basics$LT = {$: 'LT'};
var elm$core$Dict$foldr = F3(
	function (func, acc, t) {
		foldr:
		while (true) {
			if (t.$ === 'RBEmpty_elm_builtin') {
				return acc;
			} else {
				var key = t.b;
				var value = t.c;
				var left = t.d;
				var right = t.e;
				var $temp$func = func,
					$temp$acc = A3(
					func,
					key,
					value,
					A3(elm$core$Dict$foldr, func, acc, right)),
					$temp$t = left;
				func = $temp$func;
				acc = $temp$acc;
				t = $temp$t;
				continue foldr;
			}
		}
	});
var elm$core$List$cons = _List_cons;
var elm$core$Dict$toList = function (dict) {
	return A3(
		elm$core$Dict$foldr,
		F3(
			function (key, value, list) {
				return A2(
					elm$core$List$cons,
					_Utils_Tuple2(key, value),
					list);
			}),
		_List_Nil,
		dict);
};
var elm$core$Dict$keys = function (dict) {
	return A3(
		elm$core$Dict$foldr,
		F3(
			function (key, value, keyList) {
				return A2(elm$core$List$cons, key, keyList);
			}),
		_List_Nil,
		dict);
};
var elm$core$Set$toList = function (_n0) {
	var dict = _n0.a;
	return elm$core$Dict$keys(dict);
};
var elm$core$Elm$JsArray$foldr = _JsArray_foldr;
var elm$core$Array$foldr = F3(
	function (func, baseCase, _n0) {
		var tree = _n0.c;
		var tail = _n0.d;
		var helper = F2(
			function (node, acc) {
				if (node.$ === 'SubTree') {
					var subTree = node.a;
					return A3(elm$core$Elm$JsArray$foldr, helper, acc, subTree);
				} else {
					var values = node.a;
					return A3(elm$core$Elm$JsArray$foldr, func, acc, values);
				}
			});
		return A3(
			elm$core$Elm$JsArray$foldr,
			helper,
			A3(elm$core$Elm$JsArray$foldr, func, baseCase, tail),
			tree);
	});
var elm$core$Array$toList = function (array) {
	return A3(elm$core$Array$foldr, elm$core$List$cons, _List_Nil, array);
};
var elm$core$Basics$ceiling = _Basics_ceiling;
var elm$core$Basics$fdiv = _Basics_fdiv;
var elm$core$Basics$logBase = F2(
	function (base, number) {
		return _Basics_log(number) / _Basics_log(base);
	});
var elm$core$Basics$toFloat = _Basics_toFloat;
var elm$core$Array$shiftStep = elm$core$Basics$ceiling(
	A2(elm$core$Basics$logBase, 2, elm$core$Array$branchFactor));
var elm$core$Elm$JsArray$empty = _JsArray_empty;
var elm$core$Array$empty = A4(elm$core$Array$Array_elm_builtin, 0, elm$core$Array$shiftStep, elm$core$Elm$JsArray$empty, elm$core$Elm$JsArray$empty);
var elm$core$Array$Leaf = function (a) {
	return {$: 'Leaf', a: a};
};
var elm$core$Array$SubTree = function (a) {
	return {$: 'SubTree', a: a};
};
var elm$core$Elm$JsArray$initializeFromList = _JsArray_initializeFromList;
var elm$core$List$foldl = F3(
	function (func, acc, list) {
		foldl:
		while (true) {
			if (!list.b) {
				return acc;
			} else {
				var x = list.a;
				var xs = list.b;
				var $temp$func = func,
					$temp$acc = A2(func, x, acc),
					$temp$list = xs;
				func = $temp$func;
				acc = $temp$acc;
				list = $temp$list;
				continue foldl;
			}
		}
	});
var elm$core$List$reverse = function (list) {
	return A3(elm$core$List$foldl, elm$core$List$cons, _List_Nil, list);
};
var elm$core$Array$compressNodes = F2(
	function (nodes, acc) {
		compressNodes:
		while (true) {
			var _n0 = A2(elm$core$Elm$JsArray$initializeFromList, elm$core$Array$branchFactor, nodes);
			var node = _n0.a;
			var remainingNodes = _n0.b;
			var newAcc = A2(
				elm$core$List$cons,
				elm$core$Array$SubTree(node),
				acc);
			if (!remainingNodes.b) {
				return elm$core$List$reverse(newAcc);
			} else {
				var $temp$nodes = remainingNodes,
					$temp$acc = newAcc;
				nodes = $temp$nodes;
				acc = $temp$acc;
				continue compressNodes;
			}
		}
	});
var elm$core$Basics$apR = F2(
	function (x, f) {
		return f(x);
	});
var elm$core$Basics$eq = _Utils_equal;
var elm$core$Tuple$first = function (_n0) {
	var x = _n0.a;
	return x;
};
var elm$core$Array$treeFromBuilder = F2(
	function (nodeList, nodeListSize) {
		treeFromBuilder:
		while (true) {
			var newNodeSize = elm$core$Basics$ceiling(nodeListSize / elm$core$Array$branchFactor);
			if (newNodeSize === 1) {
				return A2(elm$core$Elm$JsArray$initializeFromList, elm$core$Array$branchFactor, nodeList).a;
			} else {
				var $temp$nodeList = A2(elm$core$Array$compressNodes, nodeList, _List_Nil),
					$temp$nodeListSize = newNodeSize;
				nodeList = $temp$nodeList;
				nodeListSize = $temp$nodeListSize;
				continue treeFromBuilder;
			}
		}
	});
var elm$core$Basics$add = _Basics_add;
var elm$core$Basics$apL = F2(
	function (f, x) {
		return f(x);
	});
var elm$core$Basics$floor = _Basics_floor;
var elm$core$Basics$gt = _Utils_gt;
var elm$core$Basics$max = F2(
	function (x, y) {
		return (_Utils_cmp(x, y) > 0) ? x : y;
	});
var elm$core$Basics$mul = _Basics_mul;
var elm$core$Basics$sub = _Basics_sub;
var elm$core$Elm$JsArray$length = _JsArray_length;
var elm$core$Array$builderToArray = F2(
	function (reverseNodeList, builder) {
		if (!builder.nodeListSize) {
			return A4(
				elm$core$Array$Array_elm_builtin,
				elm$core$Elm$JsArray$length(builder.tail),
				elm$core$Array$shiftStep,
				elm$core$Elm$JsArray$empty,
				builder.tail);
		} else {
			var treeLen = builder.nodeListSize * elm$core$Array$branchFactor;
			var depth = elm$core$Basics$floor(
				A2(elm$core$Basics$logBase, elm$core$Array$branchFactor, treeLen - 1));
			var correctNodeList = reverseNodeList ? elm$core$List$reverse(builder.nodeList) : builder.nodeList;
			var tree = A2(elm$core$Array$treeFromBuilder, correctNodeList, builder.nodeListSize);
			return A4(
				elm$core$Array$Array_elm_builtin,
				elm$core$Elm$JsArray$length(builder.tail) + treeLen,
				A2(elm$core$Basics$max, 5, depth * elm$core$Array$shiftStep),
				tree,
				builder.tail);
		}
	});
var elm$core$Basics$False = {$: 'False'};
var elm$core$Basics$idiv = _Basics_idiv;
var elm$core$Basics$lt = _Utils_lt;
var elm$core$Elm$JsArray$initialize = _JsArray_initialize;
var elm$core$Array$initializeHelp = F5(
	function (fn, fromIndex, len, nodeList, tail) {
		initializeHelp:
		while (true) {
			if (fromIndex < 0) {
				return A2(
					elm$core$Array$builderToArray,
					false,
					{nodeList: nodeList, nodeListSize: (len / elm$core$Array$branchFactor) | 0, tail: tail});
			} else {
				var leaf = elm$core$Array$Leaf(
					A3(elm$core$Elm$JsArray$initialize, elm$core$Array$branchFactor, fromIndex, fn));
				var $temp$fn = fn,
					$temp$fromIndex = fromIndex - elm$core$Array$branchFactor,
					$temp$len = len,
					$temp$nodeList = A2(elm$core$List$cons, leaf, nodeList),
					$temp$tail = tail;
				fn = $temp$fn;
				fromIndex = $temp$fromIndex;
				len = $temp$len;
				nodeList = $temp$nodeList;
				tail = $temp$tail;
				continue initializeHelp;
			}
		}
	});
var elm$core$Basics$le = _Utils_le;
var elm$core$Basics$remainderBy = _Basics_remainderBy;
var elm$core$Array$initialize = F2(
	function (len, fn) {
		if (len <= 0) {
			return elm$core$Array$empty;
		} else {
			var tailLen = len % elm$core$Array$branchFactor;
			var tail = A3(elm$core$Elm$JsArray$initialize, tailLen, len - tailLen, fn);
			var initialFromIndex = (len - tailLen) - elm$core$Array$branchFactor;
			return A5(elm$core$Array$initializeHelp, fn, initialFromIndex, len, _List_Nil, tail);
		}
	});
var elm$core$Maybe$Just = function (a) {
	return {$: 'Just', a: a};
};
var elm$core$Maybe$Nothing = {$: 'Nothing'};
var elm$core$Result$Err = function (a) {
	return {$: 'Err', a: a};
};
var elm$core$Result$Ok = function (a) {
	return {$: 'Ok', a: a};
};
var elm$core$Basics$True = {$: 'True'};
var elm$core$Result$isOk = function (result) {
	if (result.$ === 'Ok') {
		return true;
	} else {
		return false;
	}
};
var elm$json$Json$Decode$Failure = F2(
	function (a, b) {
		return {$: 'Failure', a: a, b: b};
	});
var elm$json$Json$Decode$Field = F2(
	function (a, b) {
		return {$: 'Field', a: a, b: b};
	});
var elm$json$Json$Decode$Index = F2(
	function (a, b) {
		return {$: 'Index', a: a, b: b};
	});
var elm$json$Json$Decode$OneOf = function (a) {
	return {$: 'OneOf', a: a};
};
var elm$core$Basics$and = _Basics_and;
var elm$core$Basics$append = _Utils_append;
var elm$core$Basics$or = _Basics_or;
var elm$core$Char$toCode = _Char_toCode;
var elm$core$Char$isLower = function (_char) {
	var code = elm$core$Char$toCode(_char);
	return (97 <= code) && (code <= 122);
};
var elm$core$Char$isUpper = function (_char) {
	var code = elm$core$Char$toCode(_char);
	return (code <= 90) && (65 <= code);
};
var elm$core$Char$isAlpha = function (_char) {
	return elm$core$Char$isLower(_char) || elm$core$Char$isUpper(_char);
};
var elm$core$Char$isDigit = function (_char) {
	var code = elm$core$Char$toCode(_char);
	return (code <= 57) && (48 <= code);
};
var elm$core$Char$isAlphaNum = function (_char) {
	return elm$core$Char$isLower(_char) || (elm$core$Char$isUpper(_char) || elm$core$Char$isDigit(_char));
};
var elm$core$List$length = function (xs) {
	return A3(
		elm$core$List$foldl,
		F2(
			function (_n0, i) {
				return i + 1;
			}),
		0,
		xs);
};
var elm$core$List$map2 = _List_map2;
var elm$core$List$rangeHelp = F3(
	function (lo, hi, list) {
		rangeHelp:
		while (true) {
			if (_Utils_cmp(lo, hi) < 1) {
				var $temp$lo = lo,
					$temp$hi = hi - 1,
					$temp$list = A2(elm$core$List$cons, hi, list);
				lo = $temp$lo;
				hi = $temp$hi;
				list = $temp$list;
				continue rangeHelp;
			} else {
				return list;
			}
		}
	});
var elm$core$List$range = F2(
	function (lo, hi) {
		return A3(elm$core$List$rangeHelp, lo, hi, _List_Nil);
	});
var elm$core$List$indexedMap = F2(
	function (f, xs) {
		return A3(
			elm$core$List$map2,
			f,
			A2(
				elm$core$List$range,
				0,
				elm$core$List$length(xs) - 1),
			xs);
	});
var elm$core$String$all = _String_all;
var elm$core$String$fromInt = _String_fromNumber;
var elm$core$String$join = F2(
	function (sep, chunks) {
		return A2(
			_String_join,
			sep,
			_List_toArray(chunks));
	});
var elm$core$String$uncons = _String_uncons;
var elm$core$String$split = F2(
	function (sep, string) {
		return _List_fromArray(
			A2(_String_split, sep, string));
	});
var elm$json$Json$Decode$indent = function (str) {
	return A2(
		elm$core$String$join,
		'\n    ',
		A2(elm$core$String$split, '\n', str));
};
var elm$json$Json$Encode$encode = _Json_encode;
var elm$json$Json$Decode$errorOneOf = F2(
	function (i, error) {
		return '\n\n(' + (elm$core$String$fromInt(i + 1) + (') ' + elm$json$Json$Decode$indent(
			elm$json$Json$Decode$errorToString(error))));
	});
var elm$json$Json$Decode$errorToString = function (error) {
	return A2(elm$json$Json$Decode$errorToStringHelp, error, _List_Nil);
};
var elm$json$Json$Decode$errorToStringHelp = F2(
	function (error, context) {
		errorToStringHelp:
		while (true) {
			switch (error.$) {
				case 'Field':
					var f = error.a;
					var err = error.b;
					var isSimple = function () {
						var _n1 = elm$core$String$uncons(f);
						if (_n1.$ === 'Nothing') {
							return false;
						} else {
							var _n2 = _n1.a;
							var _char = _n2.a;
							var rest = _n2.b;
							return elm$core$Char$isAlpha(_char) && A2(elm$core$String$all, elm$core$Char$isAlphaNum, rest);
						}
					}();
					var fieldName = isSimple ? ('.' + f) : ('[\'' + (f + '\']'));
					var $temp$error = err,
						$temp$context = A2(elm$core$List$cons, fieldName, context);
					error = $temp$error;
					context = $temp$context;
					continue errorToStringHelp;
				case 'Index':
					var i = error.a;
					var err = error.b;
					var indexName = '[' + (elm$core$String$fromInt(i) + ']');
					var $temp$error = err,
						$temp$context = A2(elm$core$List$cons, indexName, context);
					error = $temp$error;
					context = $temp$context;
					continue errorToStringHelp;
				case 'OneOf':
					var errors = error.a;
					if (!errors.b) {
						return 'Ran into a Json.Decode.oneOf with no possibilities' + function () {
							if (!context.b) {
								return '!';
							} else {
								return ' at json' + A2(
									elm$core$String$join,
									'',
									elm$core$List$reverse(context));
							}
						}();
					} else {
						if (!errors.b.b) {
							var err = errors.a;
							var $temp$error = err,
								$temp$context = context;
							error = $temp$error;
							context = $temp$context;
							continue errorToStringHelp;
						} else {
							var starter = function () {
								if (!context.b) {
									return 'Json.Decode.oneOf';
								} else {
									return 'The Json.Decode.oneOf at json' + A2(
										elm$core$String$join,
										'',
										elm$core$List$reverse(context));
								}
							}();
							var introduction = starter + (' failed in the following ' + (elm$core$String$fromInt(
								elm$core$List$length(errors)) + ' ways:'));
							return A2(
								elm$core$String$join,
								'\n\n',
								A2(
									elm$core$List$cons,
									introduction,
									A2(elm$core$List$indexedMap, elm$json$Json$Decode$errorOneOf, errors)));
						}
					}
				default:
					var msg = error.a;
					var json = error.b;
					var introduction = function () {
						if (!context.b) {
							return 'Problem with the given value:\n\n';
						} else {
							return 'Problem with the value at json' + (A2(
								elm$core$String$join,
								'',
								elm$core$List$reverse(context)) + ':\n\n    ');
						}
					}();
					return introduction + (elm$json$Json$Decode$indent(
						A2(elm$json$Json$Encode$encode, 4, json)) + ('\n\n' + msg));
			}
		}
	});
var elm$json$Json$Decode$field = _Json_decodeField;
var elm$json$Json$Decode$int = _Json_decodeInt;
var elm$json$Json$Decode$list = _Json_decodeList;
var elm$json$Json$Decode$map4 = _Json_map4;
var elm$json$Json$Decode$map = _Json_map1;
var elm$json$Json$Decode$null = _Json_decodeNull;
var elm$json$Json$Decode$oneOf = _Json_oneOf;
var elm$json$Json$Decode$nullable = function (decoder) {
	return elm$json$Json$Decode$oneOf(
		_List_fromArray(
			[
				elm$json$Json$Decode$null(elm$core$Maybe$Nothing),
				A2(elm$json$Json$Decode$map, elm$core$Maybe$Just, decoder)
			]));
};
var elm$json$Json$Decode$string = _Json_decodeString;
var author$project$API$decodeUser = A5(
	elm$json$Json$Decode$map4,
	author$project$API$User,
	A2(elm$json$Json$Decode$field, 'id', elm$json$Json$Decode$int),
	A2(elm$json$Json$Decode$field, 'username', elm$json$Json$Decode$string),
	A2(
		elm$json$Json$Decode$field,
		'email',
		elm$json$Json$Decode$nullable(elm$json$Json$Decode$string)),
	A2(
		elm$json$Json$Decode$field,
		'languages',
		elm$json$Json$Decode$list(elm$json$Json$Decode$string)));
var author$project$API$JWTToken = function (token) {
	return {token: token};
};
var author$project$Data$Session$decodeAuthToken = A2(
	elm$json$Json$Decode$map,
	author$project$API$JWTToken,
	A2(elm$json$Json$Decode$field, 'token', elm$json$Json$Decode$string));
var elm$json$Json$Decode$map2 = _Json_map2;
var author$project$Data$Session$decodeAuthSession = A3(
	elm$json$Json$Decode$map2,
	author$project$Data$Session$Session,
	A2(
		elm$json$Json$Decode$field,
		'authToken',
		elm$json$Json$Decode$nullable(author$project$Data$Session$decodeAuthToken)),
	A2(
		elm$json$Json$Decode$field,
		'user',
		elm$json$Json$Decode$nullable(author$project$API$decodeUser)));
var elm$core$Basics$composeR = F3(
	function (f, g, x) {
		return g(
			f(x));
	});
var elm$core$Maybe$andThen = F2(
	function (callback, maybeValue) {
		if (maybeValue.$ === 'Just') {
			var value = maybeValue.a;
			return callback(value);
		} else {
			return elm$core$Maybe$Nothing;
		}
	});
var elm$core$Result$toMaybe = function (result) {
	if (result.$ === 'Ok') {
		var v = result.a;
		return elm$core$Maybe$Just(v);
	} else {
		return elm$core$Maybe$Nothing;
	}
};
var elm$json$Json$Decode$decodeString = _Json_runOnString;
var elm$json$Json$Decode$decodeValue = _Json_run;
var author$project$Data$Session$decodeAuthSessionFromJson = function (json) {
	return A2(
		elm$core$Maybe$andThen,
		A2(
			elm$core$Basics$composeR,
			elm$json$Json$Decode$decodeString(author$project$Data$Session$decodeAuthSession),
			elm$core$Result$toMaybe),
		elm$core$Result$toMaybe(
			A2(elm$json$Json$Decode$decodeValue, elm$json$Json$Decode$string, json)));
};
var elm$core$Maybe$withDefault = F2(
	function (_default, maybe) {
		if (maybe.$ === 'Just') {
			var value = maybe.a;
			return value;
		} else {
			return _default;
		}
	});
var author$project$Data$Session$retrieveSessionFromJson = function (json) {
	return A2(
		elm$core$Maybe$withDefault,
		A2(author$project$Data$Session$Session, elm$core$Maybe$Nothing, elm$core$Maybe$Nothing),
		author$project$Data$Session$decodeAuthSessionFromJson(json));
};
var author$project$Route$Home = {$: 'Home'};
var author$project$Route$Login = {$: 'Login'};
var author$project$Route$Logout = {$: 'Logout'};
var author$project$Route$ProfileEdit = {$: 'ProfileEdit'};
var author$project$Route$Quizz = function (a) {
	return {$: 'Quizz', a: a};
};
var author$project$Route$Register = {$: 'Register'};
var author$project$Route$WordDelete = function (a) {
	return {$: 'WordDelete', a: a};
};
var author$project$Route$WordEdit = function (a) {
	return {$: 'WordEdit', a: a};
};
var elm$core$String$toInt = _String_toInt;
var elm$core$Basics$identity = function (x) {
	return x;
};
var elm$url$Url$Parser$Parser = function (a) {
	return {$: 'Parser', a: a};
};
var elm$url$Url$Parser$State = F5(
	function (visited, unvisited, params, frag, value) {
		return {frag: frag, params: params, unvisited: unvisited, value: value, visited: visited};
	});
var elm$url$Url$Parser$custom = F2(
	function (tipe, stringToSomething) {
		return elm$url$Url$Parser$Parser(
			function (_n0) {
				var visited = _n0.visited;
				var unvisited = _n0.unvisited;
				var params = _n0.params;
				var frag = _n0.frag;
				var value = _n0.value;
				if (!unvisited.b) {
					return _List_Nil;
				} else {
					var next = unvisited.a;
					var rest = unvisited.b;
					var _n2 = stringToSomething(next);
					if (_n2.$ === 'Just') {
						var nextValue = _n2.a;
						return _List_fromArray(
							[
								A5(
								elm$url$Url$Parser$State,
								A2(elm$core$List$cons, next, visited),
								rest,
								params,
								frag,
								value(nextValue))
							]);
					} else {
						return _List_Nil;
					}
				}
			});
	});
var elm$url$Url$Parser$int = A2(elm$url$Url$Parser$custom, 'NUMBER', elm$core$String$toInt);
var elm$core$List$foldrHelper = F4(
	function (fn, acc, ctr, ls) {
		if (!ls.b) {
			return acc;
		} else {
			var a = ls.a;
			var r1 = ls.b;
			if (!r1.b) {
				return A2(fn, a, acc);
			} else {
				var b = r1.a;
				var r2 = r1.b;
				if (!r2.b) {
					return A2(
						fn,
						a,
						A2(fn, b, acc));
				} else {
					var c = r2.a;
					var r3 = r2.b;
					if (!r3.b) {
						return A2(
							fn,
							a,
							A2(
								fn,
								b,
								A2(fn, c, acc)));
					} else {
						var d = r3.a;
						var r4 = r3.b;
						var res = (ctr > 500) ? A3(
							elm$core$List$foldl,
							fn,
							acc,
							elm$core$List$reverse(r4)) : A4(elm$core$List$foldrHelper, fn, acc, ctr + 1, r4);
						return A2(
							fn,
							a,
							A2(
								fn,
								b,
								A2(
									fn,
									c,
									A2(fn, d, res))));
					}
				}
			}
		}
	});
var elm$core$List$foldr = F3(
	function (fn, acc, ls) {
		return A4(elm$core$List$foldrHelper, fn, acc, 0, ls);
	});
var elm$core$List$map = F2(
	function (f, xs) {
		return A3(
			elm$core$List$foldr,
			F2(
				function (x, acc) {
					return A2(
						elm$core$List$cons,
						f(x),
						acc);
				}),
			_List_Nil,
			xs);
	});
var elm$url$Url$Parser$mapState = F2(
	function (func, _n0) {
		var visited = _n0.visited;
		var unvisited = _n0.unvisited;
		var params = _n0.params;
		var frag = _n0.frag;
		var value = _n0.value;
		return A5(
			elm$url$Url$Parser$State,
			visited,
			unvisited,
			params,
			frag,
			func(value));
	});
var elm$url$Url$Parser$map = F2(
	function (subValue, _n0) {
		var parseArg = _n0.a;
		return elm$url$Url$Parser$Parser(
			function (_n1) {
				var visited = _n1.visited;
				var unvisited = _n1.unvisited;
				var params = _n1.params;
				var frag = _n1.frag;
				var value = _n1.value;
				return A2(
					elm$core$List$map,
					elm$url$Url$Parser$mapState(value),
					parseArg(
						A5(elm$url$Url$Parser$State, visited, unvisited, params, frag, subValue)));
			});
	});
var elm$core$List$append = F2(
	function (xs, ys) {
		if (!ys.b) {
			return xs;
		} else {
			return A3(elm$core$List$foldr, elm$core$List$cons, ys, xs);
		}
	});
var elm$core$List$concat = function (lists) {
	return A3(elm$core$List$foldr, elm$core$List$append, _List_Nil, lists);
};
var elm$core$List$concatMap = F2(
	function (f, list) {
		return elm$core$List$concat(
			A2(elm$core$List$map, f, list));
	});
var elm$url$Url$Parser$oneOf = function (parsers) {
	return elm$url$Url$Parser$Parser(
		function (state) {
			return A2(
				elm$core$List$concatMap,
				function (_n0) {
					var parser = _n0.a;
					return parser(state);
				},
				parsers);
		});
};
var elm$url$Url$Parser$s = function (str) {
	return elm$url$Url$Parser$Parser(
		function (_n0) {
			var visited = _n0.visited;
			var unvisited = _n0.unvisited;
			var params = _n0.params;
			var frag = _n0.frag;
			var value = _n0.value;
			if (!unvisited.b) {
				return _List_Nil;
			} else {
				var next = unvisited.a;
				var rest = unvisited.b;
				return _Utils_eq(next, str) ? _List_fromArray(
					[
						A5(
						elm$url$Url$Parser$State,
						A2(elm$core$List$cons, next, visited),
						rest,
						params,
						frag,
						value)
					]) : _List_Nil;
			}
		});
};
var elm$url$Url$Parser$slash = F2(
	function (_n0, _n1) {
		var parseBefore = _n0.a;
		var parseAfter = _n1.a;
		return elm$url$Url$Parser$Parser(
			function (state) {
				return A2(
					elm$core$List$concatMap,
					parseAfter,
					parseBefore(state));
			});
	});
var elm$url$Url$Parser$string = A2(elm$url$Url$Parser$custom, 'STRING', elm$core$Maybe$Just);
var elm$url$Url$Parser$top = elm$url$Url$Parser$Parser(
	function (state) {
		return _List_fromArray(
			[state]);
	});
var author$project$Route$route = elm$url$Url$Parser$oneOf(
	_List_fromArray(
		[
			A2(elm$url$Url$Parser$map, author$project$Route$Login, elm$url$Url$Parser$top),
			A2(
			elm$url$Url$Parser$map,
			author$project$Route$Logout,
			elm$url$Url$Parser$s('logout')),
			A2(
			elm$url$Url$Parser$map,
			author$project$Route$Register,
			elm$url$Url$Parser$s('register')),
			A2(
			elm$url$Url$Parser$map,
			author$project$Route$ProfileEdit,
			elm$url$Url$Parser$s('profile')),
			A2(
			elm$url$Url$Parser$map,
			author$project$Route$Home,
			elm$url$Url$Parser$s('home')),
			A2(
			elm$url$Url$Parser$map,
			author$project$Route$WordEdit,
			A2(
				elm$url$Url$Parser$slash,
				elm$url$Url$Parser$s('wordEdit'),
				elm$url$Url$Parser$int)),
			A2(
			elm$url$Url$Parser$map,
			author$project$Route$WordDelete,
			A2(
				elm$url$Url$Parser$slash,
				elm$url$Url$Parser$s('wordDelete'),
				elm$url$Url$Parser$int)),
			A2(
			elm$url$Url$Parser$map,
			author$project$Route$Quizz,
			A2(
				elm$url$Url$Parser$slash,
				elm$url$Url$Parser$s('quizz'),
				elm$url$Url$Parser$string))
		]));
var elm$url$Url$Parser$getFirstMatch = function (states) {
	getFirstMatch:
	while (true) {
		if (!states.b) {
			return elm$core$Maybe$Nothing;
		} else {
			var state = states.a;
			var rest = states.b;
			var _n1 = state.unvisited;
			if (!_n1.b) {
				return elm$core$Maybe$Just(state.value);
			} else {
				if ((_n1.a === '') && (!_n1.b.b)) {
					return elm$core$Maybe$Just(state.value);
				} else {
					var $temp$states = rest;
					states = $temp$states;
					continue getFirstMatch;
				}
			}
		}
	}
};
var elm$url$Url$Parser$removeFinalEmpty = function (segments) {
	if (!segments.b) {
		return _List_Nil;
	} else {
		if ((segments.a === '') && (!segments.b.b)) {
			return _List_Nil;
		} else {
			var segment = segments.a;
			var rest = segments.b;
			return A2(
				elm$core$List$cons,
				segment,
				elm$url$Url$Parser$removeFinalEmpty(rest));
		}
	}
};
var elm$url$Url$Parser$preparePath = function (path) {
	var _n0 = A2(elm$core$String$split, '/', path);
	if (_n0.b && (_n0.a === '')) {
		var segments = _n0.b;
		return elm$url$Url$Parser$removeFinalEmpty(segments);
	} else {
		var segments = _n0;
		return elm$url$Url$Parser$removeFinalEmpty(segments);
	}
};
var elm$core$Dict$RBEmpty_elm_builtin = {$: 'RBEmpty_elm_builtin'};
var elm$core$Dict$empty = elm$core$Dict$RBEmpty_elm_builtin;
var elm$core$Basics$compare = _Utils_compare;
var elm$core$Dict$get = F2(
	function (targetKey, dict) {
		get:
		while (true) {
			if (dict.$ === 'RBEmpty_elm_builtin') {
				return elm$core$Maybe$Nothing;
			} else {
				var key = dict.b;
				var value = dict.c;
				var left = dict.d;
				var right = dict.e;
				var _n1 = A2(elm$core$Basics$compare, targetKey, key);
				switch (_n1.$) {
					case 'LT':
						var $temp$targetKey = targetKey,
							$temp$dict = left;
						targetKey = $temp$targetKey;
						dict = $temp$dict;
						continue get;
					case 'EQ':
						return elm$core$Maybe$Just(value);
					default:
						var $temp$targetKey = targetKey,
							$temp$dict = right;
						targetKey = $temp$targetKey;
						dict = $temp$dict;
						continue get;
				}
			}
		}
	});
var elm$core$Dict$Black = {$: 'Black'};
var elm$core$Dict$RBNode_elm_builtin = F5(
	function (a, b, c, d, e) {
		return {$: 'RBNode_elm_builtin', a: a, b: b, c: c, d: d, e: e};
	});
var elm$core$Dict$Red = {$: 'Red'};
var elm$core$Dict$balance = F5(
	function (color, key, value, left, right) {
		if ((right.$ === 'RBNode_elm_builtin') && (right.a.$ === 'Red')) {
			var _n1 = right.a;
			var rK = right.b;
			var rV = right.c;
			var rLeft = right.d;
			var rRight = right.e;
			if ((left.$ === 'RBNode_elm_builtin') && (left.a.$ === 'Red')) {
				var _n3 = left.a;
				var lK = left.b;
				var lV = left.c;
				var lLeft = left.d;
				var lRight = left.e;
				return A5(
					elm$core$Dict$RBNode_elm_builtin,
					elm$core$Dict$Red,
					key,
					value,
					A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Black, lK, lV, lLeft, lRight),
					A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Black, rK, rV, rLeft, rRight));
			} else {
				return A5(
					elm$core$Dict$RBNode_elm_builtin,
					color,
					rK,
					rV,
					A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Red, key, value, left, rLeft),
					rRight);
			}
		} else {
			if ((((left.$ === 'RBNode_elm_builtin') && (left.a.$ === 'Red')) && (left.d.$ === 'RBNode_elm_builtin')) && (left.d.a.$ === 'Red')) {
				var _n5 = left.a;
				var lK = left.b;
				var lV = left.c;
				var _n6 = left.d;
				var _n7 = _n6.a;
				var llK = _n6.b;
				var llV = _n6.c;
				var llLeft = _n6.d;
				var llRight = _n6.e;
				var lRight = left.e;
				return A5(
					elm$core$Dict$RBNode_elm_builtin,
					elm$core$Dict$Red,
					lK,
					lV,
					A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Black, llK, llV, llLeft, llRight),
					A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Black, key, value, lRight, right));
			} else {
				return A5(elm$core$Dict$RBNode_elm_builtin, color, key, value, left, right);
			}
		}
	});
var elm$core$Dict$insertHelp = F3(
	function (key, value, dict) {
		if (dict.$ === 'RBEmpty_elm_builtin') {
			return A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Red, key, value, elm$core$Dict$RBEmpty_elm_builtin, elm$core$Dict$RBEmpty_elm_builtin);
		} else {
			var nColor = dict.a;
			var nKey = dict.b;
			var nValue = dict.c;
			var nLeft = dict.d;
			var nRight = dict.e;
			var _n1 = A2(elm$core$Basics$compare, key, nKey);
			switch (_n1.$) {
				case 'LT':
					return A5(
						elm$core$Dict$balance,
						nColor,
						nKey,
						nValue,
						A3(elm$core$Dict$insertHelp, key, value, nLeft),
						nRight);
				case 'EQ':
					return A5(elm$core$Dict$RBNode_elm_builtin, nColor, nKey, value, nLeft, nRight);
				default:
					return A5(
						elm$core$Dict$balance,
						nColor,
						nKey,
						nValue,
						nLeft,
						A3(elm$core$Dict$insertHelp, key, value, nRight));
			}
		}
	});
var elm$core$Dict$insert = F3(
	function (key, value, dict) {
		var _n0 = A3(elm$core$Dict$insertHelp, key, value, dict);
		if ((_n0.$ === 'RBNode_elm_builtin') && (_n0.a.$ === 'Red')) {
			var _n1 = _n0.a;
			var k = _n0.b;
			var v = _n0.c;
			var l = _n0.d;
			var r = _n0.e;
			return A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Black, k, v, l, r);
		} else {
			var x = _n0;
			return x;
		}
	});
var elm$core$Dict$getMin = function (dict) {
	getMin:
	while (true) {
		if ((dict.$ === 'RBNode_elm_builtin') && (dict.d.$ === 'RBNode_elm_builtin')) {
			var left = dict.d;
			var $temp$dict = left;
			dict = $temp$dict;
			continue getMin;
		} else {
			return dict;
		}
	}
};
var elm$core$Dict$moveRedLeft = function (dict) {
	if (((dict.$ === 'RBNode_elm_builtin') && (dict.d.$ === 'RBNode_elm_builtin')) && (dict.e.$ === 'RBNode_elm_builtin')) {
		if ((dict.e.d.$ === 'RBNode_elm_builtin') && (dict.e.d.a.$ === 'Red')) {
			var clr = dict.a;
			var k = dict.b;
			var v = dict.c;
			var _n1 = dict.d;
			var lClr = _n1.a;
			var lK = _n1.b;
			var lV = _n1.c;
			var lLeft = _n1.d;
			var lRight = _n1.e;
			var _n2 = dict.e;
			var rClr = _n2.a;
			var rK = _n2.b;
			var rV = _n2.c;
			var rLeft = _n2.d;
			var _n3 = rLeft.a;
			var rlK = rLeft.b;
			var rlV = rLeft.c;
			var rlL = rLeft.d;
			var rlR = rLeft.e;
			var rRight = _n2.e;
			return A5(
				elm$core$Dict$RBNode_elm_builtin,
				elm$core$Dict$Red,
				rlK,
				rlV,
				A5(
					elm$core$Dict$RBNode_elm_builtin,
					elm$core$Dict$Black,
					k,
					v,
					A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Red, lK, lV, lLeft, lRight),
					rlL),
				A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Black, rK, rV, rlR, rRight));
		} else {
			var clr = dict.a;
			var k = dict.b;
			var v = dict.c;
			var _n4 = dict.d;
			var lClr = _n4.a;
			var lK = _n4.b;
			var lV = _n4.c;
			var lLeft = _n4.d;
			var lRight = _n4.e;
			var _n5 = dict.e;
			var rClr = _n5.a;
			var rK = _n5.b;
			var rV = _n5.c;
			var rLeft = _n5.d;
			var rRight = _n5.e;
			if (clr.$ === 'Black') {
				return A5(
					elm$core$Dict$RBNode_elm_builtin,
					elm$core$Dict$Black,
					k,
					v,
					A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Red, lK, lV, lLeft, lRight),
					A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Red, rK, rV, rLeft, rRight));
			} else {
				return A5(
					elm$core$Dict$RBNode_elm_builtin,
					elm$core$Dict$Black,
					k,
					v,
					A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Red, lK, lV, lLeft, lRight),
					A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Red, rK, rV, rLeft, rRight));
			}
		}
	} else {
		return dict;
	}
};
var elm$core$Dict$moveRedRight = function (dict) {
	if (((dict.$ === 'RBNode_elm_builtin') && (dict.d.$ === 'RBNode_elm_builtin')) && (dict.e.$ === 'RBNode_elm_builtin')) {
		if ((dict.d.d.$ === 'RBNode_elm_builtin') && (dict.d.d.a.$ === 'Red')) {
			var clr = dict.a;
			var k = dict.b;
			var v = dict.c;
			var _n1 = dict.d;
			var lClr = _n1.a;
			var lK = _n1.b;
			var lV = _n1.c;
			var _n2 = _n1.d;
			var _n3 = _n2.a;
			var llK = _n2.b;
			var llV = _n2.c;
			var llLeft = _n2.d;
			var llRight = _n2.e;
			var lRight = _n1.e;
			var _n4 = dict.e;
			var rClr = _n4.a;
			var rK = _n4.b;
			var rV = _n4.c;
			var rLeft = _n4.d;
			var rRight = _n4.e;
			return A5(
				elm$core$Dict$RBNode_elm_builtin,
				elm$core$Dict$Red,
				lK,
				lV,
				A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Black, llK, llV, llLeft, llRight),
				A5(
					elm$core$Dict$RBNode_elm_builtin,
					elm$core$Dict$Black,
					k,
					v,
					lRight,
					A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Red, rK, rV, rLeft, rRight)));
		} else {
			var clr = dict.a;
			var k = dict.b;
			var v = dict.c;
			var _n5 = dict.d;
			var lClr = _n5.a;
			var lK = _n5.b;
			var lV = _n5.c;
			var lLeft = _n5.d;
			var lRight = _n5.e;
			var _n6 = dict.e;
			var rClr = _n6.a;
			var rK = _n6.b;
			var rV = _n6.c;
			var rLeft = _n6.d;
			var rRight = _n6.e;
			if (clr.$ === 'Black') {
				return A5(
					elm$core$Dict$RBNode_elm_builtin,
					elm$core$Dict$Black,
					k,
					v,
					A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Red, lK, lV, lLeft, lRight),
					A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Red, rK, rV, rLeft, rRight));
			} else {
				return A5(
					elm$core$Dict$RBNode_elm_builtin,
					elm$core$Dict$Black,
					k,
					v,
					A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Red, lK, lV, lLeft, lRight),
					A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Red, rK, rV, rLeft, rRight));
			}
		}
	} else {
		return dict;
	}
};
var elm$core$Dict$removeHelpPrepEQGT = F7(
	function (targetKey, dict, color, key, value, left, right) {
		if ((left.$ === 'RBNode_elm_builtin') && (left.a.$ === 'Red')) {
			var _n1 = left.a;
			var lK = left.b;
			var lV = left.c;
			var lLeft = left.d;
			var lRight = left.e;
			return A5(
				elm$core$Dict$RBNode_elm_builtin,
				color,
				lK,
				lV,
				lLeft,
				A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Red, key, value, lRight, right));
		} else {
			_n2$2:
			while (true) {
				if ((right.$ === 'RBNode_elm_builtin') && (right.a.$ === 'Black')) {
					if (right.d.$ === 'RBNode_elm_builtin') {
						if (right.d.a.$ === 'Black') {
							var _n3 = right.a;
							var _n4 = right.d;
							var _n5 = _n4.a;
							return elm$core$Dict$moveRedRight(dict);
						} else {
							break _n2$2;
						}
					} else {
						var _n6 = right.a;
						var _n7 = right.d;
						return elm$core$Dict$moveRedRight(dict);
					}
				} else {
					break _n2$2;
				}
			}
			return dict;
		}
	});
var elm$core$Dict$removeMin = function (dict) {
	if ((dict.$ === 'RBNode_elm_builtin') && (dict.d.$ === 'RBNode_elm_builtin')) {
		var color = dict.a;
		var key = dict.b;
		var value = dict.c;
		var left = dict.d;
		var lColor = left.a;
		var lLeft = left.d;
		var right = dict.e;
		if (lColor.$ === 'Black') {
			if ((lLeft.$ === 'RBNode_elm_builtin') && (lLeft.a.$ === 'Red')) {
				var _n3 = lLeft.a;
				return A5(
					elm$core$Dict$RBNode_elm_builtin,
					color,
					key,
					value,
					elm$core$Dict$removeMin(left),
					right);
			} else {
				var _n4 = elm$core$Dict$moveRedLeft(dict);
				if (_n4.$ === 'RBNode_elm_builtin') {
					var nColor = _n4.a;
					var nKey = _n4.b;
					var nValue = _n4.c;
					var nLeft = _n4.d;
					var nRight = _n4.e;
					return A5(
						elm$core$Dict$balance,
						nColor,
						nKey,
						nValue,
						elm$core$Dict$removeMin(nLeft),
						nRight);
				} else {
					return elm$core$Dict$RBEmpty_elm_builtin;
				}
			}
		} else {
			return A5(
				elm$core$Dict$RBNode_elm_builtin,
				color,
				key,
				value,
				elm$core$Dict$removeMin(left),
				right);
		}
	} else {
		return elm$core$Dict$RBEmpty_elm_builtin;
	}
};
var elm$core$Dict$removeHelp = F2(
	function (targetKey, dict) {
		if (dict.$ === 'RBEmpty_elm_builtin') {
			return elm$core$Dict$RBEmpty_elm_builtin;
		} else {
			var color = dict.a;
			var key = dict.b;
			var value = dict.c;
			var left = dict.d;
			var right = dict.e;
			if (_Utils_cmp(targetKey, key) < 0) {
				if ((left.$ === 'RBNode_elm_builtin') && (left.a.$ === 'Black')) {
					var _n4 = left.a;
					var lLeft = left.d;
					if ((lLeft.$ === 'RBNode_elm_builtin') && (lLeft.a.$ === 'Red')) {
						var _n6 = lLeft.a;
						return A5(
							elm$core$Dict$RBNode_elm_builtin,
							color,
							key,
							value,
							A2(elm$core$Dict$removeHelp, targetKey, left),
							right);
					} else {
						var _n7 = elm$core$Dict$moveRedLeft(dict);
						if (_n7.$ === 'RBNode_elm_builtin') {
							var nColor = _n7.a;
							var nKey = _n7.b;
							var nValue = _n7.c;
							var nLeft = _n7.d;
							var nRight = _n7.e;
							return A5(
								elm$core$Dict$balance,
								nColor,
								nKey,
								nValue,
								A2(elm$core$Dict$removeHelp, targetKey, nLeft),
								nRight);
						} else {
							return elm$core$Dict$RBEmpty_elm_builtin;
						}
					}
				} else {
					return A5(
						elm$core$Dict$RBNode_elm_builtin,
						color,
						key,
						value,
						A2(elm$core$Dict$removeHelp, targetKey, left),
						right);
				}
			} else {
				return A2(
					elm$core$Dict$removeHelpEQGT,
					targetKey,
					A7(elm$core$Dict$removeHelpPrepEQGT, targetKey, dict, color, key, value, left, right));
			}
		}
	});
var elm$core$Dict$removeHelpEQGT = F2(
	function (targetKey, dict) {
		if (dict.$ === 'RBNode_elm_builtin') {
			var color = dict.a;
			var key = dict.b;
			var value = dict.c;
			var left = dict.d;
			var right = dict.e;
			if (_Utils_eq(targetKey, key)) {
				var _n1 = elm$core$Dict$getMin(right);
				if (_n1.$ === 'RBNode_elm_builtin') {
					var minKey = _n1.b;
					var minValue = _n1.c;
					return A5(
						elm$core$Dict$balance,
						color,
						minKey,
						minValue,
						left,
						elm$core$Dict$removeMin(right));
				} else {
					return elm$core$Dict$RBEmpty_elm_builtin;
				}
			} else {
				return A5(
					elm$core$Dict$balance,
					color,
					key,
					value,
					left,
					A2(elm$core$Dict$removeHelp, targetKey, right));
			}
		} else {
			return elm$core$Dict$RBEmpty_elm_builtin;
		}
	});
var elm$core$Dict$remove = F2(
	function (key, dict) {
		var _n0 = A2(elm$core$Dict$removeHelp, key, dict);
		if ((_n0.$ === 'RBNode_elm_builtin') && (_n0.a.$ === 'Red')) {
			var _n1 = _n0.a;
			var k = _n0.b;
			var v = _n0.c;
			var l = _n0.d;
			var r = _n0.e;
			return A5(elm$core$Dict$RBNode_elm_builtin, elm$core$Dict$Black, k, v, l, r);
		} else {
			var x = _n0;
			return x;
		}
	});
var elm$core$Dict$update = F3(
	function (targetKey, alter, dictionary) {
		var _n0 = alter(
			A2(elm$core$Dict$get, targetKey, dictionary));
		if (_n0.$ === 'Just') {
			var value = _n0.a;
			return A3(elm$core$Dict$insert, targetKey, value, dictionary);
		} else {
			return A2(elm$core$Dict$remove, targetKey, dictionary);
		}
	});
var elm$url$Url$percentDecode = _Url_percentDecode;
var elm$url$Url$Parser$addToParametersHelp = F2(
	function (value, maybeList) {
		if (maybeList.$ === 'Nothing') {
			return elm$core$Maybe$Just(
				_List_fromArray(
					[value]));
		} else {
			var list = maybeList.a;
			return elm$core$Maybe$Just(
				A2(elm$core$List$cons, value, list));
		}
	});
var elm$url$Url$Parser$addParam = F2(
	function (segment, dict) {
		var _n0 = A2(elm$core$String$split, '=', segment);
		if ((_n0.b && _n0.b.b) && (!_n0.b.b.b)) {
			var rawKey = _n0.a;
			var _n1 = _n0.b;
			var rawValue = _n1.a;
			var _n2 = elm$url$Url$percentDecode(rawKey);
			if (_n2.$ === 'Nothing') {
				return dict;
			} else {
				var key = _n2.a;
				var _n3 = elm$url$Url$percentDecode(rawValue);
				if (_n3.$ === 'Nothing') {
					return dict;
				} else {
					var value = _n3.a;
					return A3(
						elm$core$Dict$update,
						key,
						elm$url$Url$Parser$addToParametersHelp(value),
						dict);
				}
			}
		} else {
			return dict;
		}
	});
var elm$url$Url$Parser$prepareQuery = function (maybeQuery) {
	if (maybeQuery.$ === 'Nothing') {
		return elm$core$Dict$empty;
	} else {
		var qry = maybeQuery.a;
		return A3(
			elm$core$List$foldr,
			elm$url$Url$Parser$addParam,
			elm$core$Dict$empty,
			A2(elm$core$String$split, '&', qry));
	}
};
var elm$url$Url$Parser$parse = F2(
	function (_n0, url) {
		var parser = _n0.a;
		return elm$url$Url$Parser$getFirstMatch(
			parser(
				A5(
					elm$url$Url$Parser$State,
					_List_Nil,
					elm$url$Url$Parser$preparePath(url.path),
					elm$url$Url$Parser$prepareQuery(url.query),
					url.fragment,
					elm$core$Basics$identity)));
	});
var author$project$Route$fromUrl = function (url) {
	return A2(elm$url$Url$Parser$parse, author$project$Route$route, url);
};
var author$project$WordApp$NotFound = {$: 'NotFound'};
var elm$json$Json$Encode$null = _Json_encodeNull;
var author$project$Ports$deleteLocalStorage = _Platform_outgoingPort(
	'deleteLocalStorage',
	function ($) {
		return elm$json$Json$Encode$null;
	});
var author$project$Data$Session$deleteSession = author$project$Ports$deleteLocalStorage(_Utils_Tuple0);
var author$project$Page$Errored$PageLoadError = {$: 'PageLoadError'};
var author$project$Page$Home$InitModel = F2(
	function (a, b) {
		return {$: 'InitModel', a: a, b: b};
	});
var elm$http$Http$Internal$EmptyBody = {$: 'EmptyBody'};
var elm$http$Http$emptyBody = elm$http$Http$Internal$EmptyBody;
var elm$core$Maybe$isJust = function (maybe) {
	if (maybe.$ === 'Just') {
		return true;
	} else {
		return false;
	}
};
var elm$core$Result$map = F2(
	function (func, ra) {
		if (ra.$ === 'Ok') {
			var a = ra.a;
			return elm$core$Result$Ok(
				func(a));
		} else {
			var e = ra.a;
			return elm$core$Result$Err(e);
		}
	});
var elm$http$Http$BadPayload = F2(
	function (a, b) {
		return {$: 'BadPayload', a: a, b: b};
	});
var elm$http$Http$BadStatus = function (a) {
	return {$: 'BadStatus', a: a};
};
var elm$http$Http$BadUrl = function (a) {
	return {$: 'BadUrl', a: a};
};
var elm$http$Http$NetworkError = {$: 'NetworkError'};
var elm$http$Http$Timeout = {$: 'Timeout'};
var elm$http$Http$Internal$FormDataBody = function (a) {
	return {$: 'FormDataBody', a: a};
};
var elm$http$Http$Internal$isStringBody = function (body) {
	if (body.$ === 'StringBody') {
		return true;
	} else {
		return false;
	}
};
var elm$http$Http$expectStringResponse = _Http_expectStringResponse;
var elm$http$Http$expectJson = function (decoder) {
	return elm$http$Http$expectStringResponse(
		function (response) {
			var _n0 = A2(elm$json$Json$Decode$decodeString, decoder, response.body);
			if (_n0.$ === 'Err') {
				var decodeError = _n0.a;
				return elm$core$Result$Err(
					elm$json$Json$Decode$errorToString(decodeError));
			} else {
				var value = _n0.a;
				return elm$core$Result$Ok(value);
			}
		});
};
var elm$http$Http$Internal$Request = function (a) {
	return {$: 'Request', a: a};
};
var elm$http$Http$request = elm$http$Http$Internal$Request;
var author$project$API$getWordsKeywords = function (headers) {
	return elm$http$Http$request(
		{
			body: elm$http$Http$emptyBody,
			expect: elm$http$Http$expectJson(
				elm$json$Json$Decode$list(elm$json$Json$Decode$string)),
			headers: headers,
			method: 'GET',
			timeout: elm$core$Maybe$Nothing,
			url: A2(
				elm$core$String$join,
				'/',
				_List_fromArray(
					['http://127.1:8080', 'words', 'keywords'])),
			withCredentials: false
		});
};
var elm$http$Http$Internal$Header = F2(
	function (a, b) {
		return {$: 'Header', a: a, b: b};
	});
var elm$http$Http$header = elm$http$Http$Internal$Header;
var author$project$Request$getWordsKeywordsRequest = function (session) {
	var jwtToken = function () {
		var _n0 = session.authToken;
		if (_n0.$ === 'Just') {
			var responseJwtToken = _n0.a;
			return function ($) {
				return $.token;
			}(responseJwtToken);
		} else {
			return '';
		}
	}();
	var requestAuthHeader = A2(elm$http$Http$header, 'Authorization', jwtToken);
	return author$project$API$getWordsKeywords(
		_List_fromArray(
			[requestAuthHeader]));
};
var author$project$API$Word = F6(
	function (id, language, word, keywords, definition, difficulty) {
		return {definition: definition, difficulty: difficulty, id: id, keywords: keywords, language: language, word: word};
	});
var elm$json$Json$Decode$map6 = _Json_map6;
var author$project$API$decodeWord = A7(
	elm$json$Json$Decode$map6,
	author$project$API$Word,
	A2(elm$json$Json$Decode$field, 'id', elm$json$Json$Decode$int),
	A2(elm$json$Json$Decode$field, 'language', elm$json$Json$Decode$string),
	A2(elm$json$Json$Decode$field, 'word', elm$json$Json$Decode$string),
	A2(
		elm$json$Json$Decode$field,
		'keywords',
		elm$json$Json$Decode$list(elm$json$Json$Decode$string)),
	A2(elm$json$Json$Decode$field, 'definition', elm$json$Json$Decode$string),
	A2(
		elm$json$Json$Decode$field,
		'difficulty',
		elm$json$Json$Decode$nullable(elm$json$Json$Decode$int)));
var author$project$API$getWordsLast = function (headers) {
	return elm$http$Http$request(
		{
			body: elm$http$Http$emptyBody,
			expect: elm$http$Http$expectJson(
				elm$json$Json$Decode$list(author$project$API$decodeWord)),
			headers: headers,
			method: 'GET',
			timeout: elm$core$Maybe$Nothing,
			url: A2(
				elm$core$String$join,
				'/',
				_List_fromArray(
					['http://127.1:8080', 'words', 'last'])),
			withCredentials: false
		});
};
var author$project$Request$getWordsLastRequest = function (session) {
	var jwtToken = function () {
		var _n0 = session.authToken;
		if (_n0.$ === 'Just') {
			var responseJwtToken = _n0.a;
			return function ($) {
				return $.token;
			}(responseJwtToken);
		} else {
			return '';
		}
	}();
	var requestAuthHeader = A2(elm$http$Http$header, 'Authorization', jwtToken);
	return author$project$API$getWordsLast(
		_List_fromArray(
			[requestAuthHeader]));
};
var elm$core$Task$andThen = _Scheduler_andThen;
var elm$core$Task$succeed = _Scheduler_succeed;
var elm$core$Task$map2 = F3(
	function (func, taskA, taskB) {
		return A2(
			elm$core$Task$andThen,
			function (a) {
				return A2(
					elm$core$Task$andThen,
					function (b) {
						return elm$core$Task$succeed(
							A2(func, a, b));
					},
					taskB);
			},
			taskA);
	});
var elm$core$Basics$composeL = F3(
	function (g, f, x) {
		return g(
			f(x));
	});
var elm$core$Task$fail = _Scheduler_fail;
var elm$core$Task$onError = _Scheduler_onError;
var elm$core$Task$mapError = F2(
	function (convert, task) {
		return A2(
			elm$core$Task$onError,
			A2(elm$core$Basics$composeL, elm$core$Task$fail, convert),
			task);
	});
var elm$http$Http$toTask = function (_n0) {
	var request_ = _n0.a;
	return A2(_Http_toTask, request_, elm$core$Maybe$Nothing);
};
var author$project$Page$Home$init = function (session) {
	var loadLastWords = elm$http$Http$toTask(
		author$project$Request$getWordsLastRequest(session));
	var loadKeywords = elm$http$Http$toTask(
		author$project$Request$getWordsKeywordsRequest(session));
	var handleLoadError = function (_n0) {
		return author$project$Page$Errored$PageLoadError;
	};
	return A2(
		elm$core$Task$mapError,
		handleLoadError,
		A3(elm$core$Task$map2, author$project$Page$Home$InitModel, loadLastWords, loadKeywords));
};
var elm$core$List$head = function (list) {
	if (list.b) {
		var x = list.a;
		var xs = list.b;
		return elm$core$Maybe$Just(x);
	} else {
		return elm$core$Maybe$Nothing;
	}
};
var author$project$Page$Home$initialModel = function (session) {
	var initialLanguage = function () {
		var _n0 = session.user;
		if (_n0.$ === 'Just') {
			var user = _n0.a;
			var _n1 = elm$core$List$head(user.languages);
			if (_n1.$ === 'Just') {
				var firstLang = _n1.a;
				return firstLang;
			} else {
				return 'EN';
			}
		} else {
			return 'EN';
		}
	}();
	return {addWordDefinition: '', addWordLanguage: initialLanguage, addWordWord: '', keywords: _List_Nil, myLastWords: _List_Nil, searchKeyword: '--', searchWord: '', searchWords: _List_Nil};
};
var author$project$Page$Login$initialModel = {errors: _List_Nil, jwtToken: elm$core$Maybe$Nothing, username: '', userpassword: ''};
var author$project$Page$ProfileEdit$Model = F3(
	function (user, password, nbLanguage) {
		return {nbLanguage: nbLanguage, password: password, user: user};
	});
var author$project$Page$ProfileEdit$initialModel = function (user) {
	return A3(
		author$project$Page$ProfileEdit$Model,
		user,
		'',
		elm$core$List$length(user.languages) + 1);
};
var author$project$API$getWordsQuizz = F2(
	function (headers, keyword) {
		return elm$http$Http$request(
			{
				body: elm$http$Http$emptyBody,
				expect: elm$http$Http$expectJson(
					elm$json$Json$Decode$list(author$project$API$decodeWord)),
				headers: headers,
				method: 'GET',
				timeout: elm$core$Maybe$Nothing,
				url: A2(
					elm$core$String$join,
					'/',
					_List_fromArray(
						['http://127.1:8080', 'words', 'quizz', 'keyword', keyword])),
				withCredentials: false
			});
	});
var author$project$Request$getWordsQuizzRequest = F2(
	function (session, keyword) {
		var jwtToken = function () {
			var _n0 = session.authToken;
			if (_n0.$ === 'Just') {
				var responseJwtToken = _n0.a;
				return function ($) {
					return $.token;
				}(responseJwtToken);
			} else {
				return '';
			}
		}();
		var requestAuthHeader = A2(elm$http$Http$header, 'Authorization', jwtToken);
		return A2(
			author$project$API$getWordsQuizz,
			_List_fromArray(
				[requestAuthHeader]),
			keyword);
	});
var author$project$Page$Quizz$init = F2(
	function (session, keyword) {
		return elm$http$Http$toTask(
			A2(author$project$Request$getWordsQuizzRequest, session, keyword));
	});
var author$project$Page$Quizz$initialModel = function (keyWord) {
	return {errors: _List_Nil, keyword: keyWord, word: elm$core$Maybe$Nothing, wordResponse: '', words: _List_Nil};
};
var author$project$API$decodeToken = A2(elm$json$Json$Decode$field, 'token', elm$json$Json$Decode$string);
var author$project$API$getToken = elm$http$Http$request(
	{
		body: elm$http$Http$emptyBody,
		expect: elm$http$Http$expectJson(author$project$API$decodeToken),
		headers: _List_Nil,
		method: 'GET',
		timeout: elm$core$Maybe$Nothing,
		url: A2(
			elm$core$String$join,
			'/',
			_List_fromArray(
				['http://127.1:8080', 'auth', 'token'])),
		withCredentials: false
	});
var author$project$Page$Register$init = elm$http$Http$toTask(author$project$API$getToken);
var author$project$API$NewUser = F4(
	function (username, password, email, languages) {
		return {email: email, languages: languages, password: password, username: username};
	});
var author$project$Page$Register$initialModel = {
	errors: _List_Nil,
	nbLanguage: 1,
	newUser: A4(
		author$project$API$NewUser,
		'',
		'',
		elm$core$Maybe$Just(''),
		_List_Nil),
	token: ''
};
var author$project$Page$WordDelete$Model = function (wordId) {
	return {wordId: wordId};
};
var author$project$API$NoContent = {$: 'NoContent'};
var elm$core$String$isEmpty = function (string) {
	return string === '';
};
var author$project$API$deleteWordsIdByWordId = F2(
	function (headers, capture_wordId) {
		return elm$http$Http$request(
			{
				body: elm$http$Http$emptyBody,
				expect: elm$http$Http$expectStringResponse(
					function (_n0) {
						var body = _n0.body;
						return elm$core$String$isEmpty(body) ? elm$core$Result$Ok(author$project$API$NoContent) : elm$core$Result$Err('Expected the response body to be empty');
					}),
				headers: headers,
				method: 'DELETE',
				timeout: elm$core$Maybe$Nothing,
				url: A2(
					elm$core$String$join,
					'/',
					_List_fromArray(
						[
							'http://127.1:8080',
							'words',
							'id',
							elm$core$String$fromInt(capture_wordId)
						])),
				withCredentials: false
			});
	});
var author$project$Request$deleteWordByIdRequest = F2(
	function (session, wordId) {
		var jwtToken = function () {
			var _n0 = session.authToken;
			if (_n0.$ === 'Just') {
				var responseJwtToken = _n0.a;
				return function ($) {
					return $.token;
				}(responseJwtToken);
			} else {
				return '';
			}
		}();
		var requestAuthHeader = A2(elm$http$Http$header, 'Authorization', jwtToken);
		return A2(
			author$project$API$deleteWordsIdByWordId,
			_List_fromArray(
				[requestAuthHeader]),
			wordId);
	});
var author$project$Page$WordDelete$init = F2(
	function (session, wordId) {
		return elm$http$Http$toTask(
			A2(author$project$Request$deleteWordByIdRequest, session, wordId));
	});
var author$project$API$getWordsIdByWordId = F2(
	function (headers, capture_wordId) {
		return elm$http$Http$request(
			{
				body: elm$http$Http$emptyBody,
				expect: elm$http$Http$expectJson(author$project$API$decodeWord),
				headers: headers,
				method: 'GET',
				timeout: elm$core$Maybe$Nothing,
				url: A2(
					elm$core$String$join,
					'/',
					_List_fromArray(
						[
							'http://127.1:8080',
							'words',
							'id',
							elm$core$String$fromInt(capture_wordId)
						])),
				withCredentials: false
			});
	});
var author$project$Request$getWordByIdRequest = F2(
	function (session, wordId) {
		var jwtToken = function () {
			var _n0 = session.authToken;
			if (_n0.$ === 'Just') {
				var responseJwtToken = _n0.a;
				return function ($) {
					return $.token;
				}(responseJwtToken);
			} else {
				return '';
			}
		}();
		var requestAuthHeader = A2(elm$http$Http$header, 'Authorization', jwtToken);
		return A2(
			author$project$API$getWordsIdByWordId,
			_List_fromArray(
				[requestAuthHeader]),
			wordId);
	});
var author$project$Page$WordEdit$init = F2(
	function (session, wordId) {
		return elm$http$Http$toTask(
			A2(author$project$Request$getWordByIdRequest, session, wordId));
	});
var author$project$Page$WordEdit$initialModel = {nbKeyword: 1, word: elm$core$Maybe$Nothing};
var author$project$WordApp$Home = function (a) {
	return {$: 'Home', a: a};
};
var author$project$WordApp$HomeInit = function (a) {
	return {$: 'HomeInit', a: a};
};
var author$project$WordApp$Login = function (a) {
	return {$: 'Login', a: a};
};
var author$project$WordApp$ProfileEdit = function (a) {
	return {$: 'ProfileEdit', a: a};
};
var author$project$WordApp$Quizz = function (a) {
	return {$: 'Quizz', a: a};
};
var author$project$WordApp$QuizzInit = function (a) {
	return {$: 'QuizzInit', a: a};
};
var author$project$WordApp$Register = function (a) {
	return {$: 'Register', a: a};
};
var author$project$WordApp$RegisterInit = function (a) {
	return {$: 'RegisterInit', a: a};
};
var author$project$WordApp$WordDelete = function (a) {
	return {$: 'WordDelete', a: a};
};
var author$project$WordApp$WordDeleteInitMsg = function (a) {
	return {$: 'WordDeleteInitMsg', a: a};
};
var author$project$WordApp$WordEdit = function (a) {
	return {$: 'WordEdit', a: a};
};
var author$project$WordApp$WordEditInitMsg = function (a) {
	return {$: 'WordEditInitMsg', a: a};
};
var elm$browser$Browser$External = function (a) {
	return {$: 'External', a: a};
};
var elm$browser$Browser$Internal = function (a) {
	return {$: 'Internal', a: a};
};
var elm$browser$Browser$Dom$NotFound = function (a) {
	return {$: 'NotFound', a: a};
};
var elm$core$Basics$never = function (_n0) {
	never:
	while (true) {
		var nvr = _n0.a;
		var $temp$_n0 = nvr;
		_n0 = $temp$_n0;
		continue never;
	}
};
var elm$core$Task$Perform = function (a) {
	return {$: 'Perform', a: a};
};
var elm$core$Task$init = elm$core$Task$succeed(_Utils_Tuple0);
var elm$core$Task$map = F2(
	function (func, taskA) {
		return A2(
			elm$core$Task$andThen,
			function (a) {
				return elm$core$Task$succeed(
					func(a));
			},
			taskA);
	});
var elm$core$Task$sequence = function (tasks) {
	return A3(
		elm$core$List$foldr,
		elm$core$Task$map2(elm$core$List$cons),
		elm$core$Task$succeed(_List_Nil),
		tasks);
};
var elm$core$Platform$sendToApp = _Platform_sendToApp;
var elm$core$Task$spawnCmd = F2(
	function (router, _n0) {
		var task = _n0.a;
		return _Scheduler_spawn(
			A2(
				elm$core$Task$andThen,
				elm$core$Platform$sendToApp(router),
				task));
	});
var elm$core$Task$onEffects = F3(
	function (router, commands, state) {
		return A2(
			elm$core$Task$map,
			function (_n0) {
				return _Utils_Tuple0;
			},
			elm$core$Task$sequence(
				A2(
					elm$core$List$map,
					elm$core$Task$spawnCmd(router),
					commands)));
	});
var elm$core$Task$onSelfMsg = F3(
	function (_n0, _n1, _n2) {
		return elm$core$Task$succeed(_Utils_Tuple0);
	});
var elm$core$Task$cmdMap = F2(
	function (tagger, _n0) {
		var task = _n0.a;
		return elm$core$Task$Perform(
			A2(elm$core$Task$map, tagger, task));
	});
_Platform_effectManagers['Task'] = _Platform_createManager(elm$core$Task$init, elm$core$Task$onEffects, elm$core$Task$onSelfMsg, elm$core$Task$cmdMap);
var elm$core$Task$command = _Platform_leaf('Task');
var elm$core$Task$perform = F2(
	function (toMessage, task) {
		return elm$core$Task$command(
			elm$core$Task$Perform(
				A2(elm$core$Task$map, toMessage, task)));
	});
var elm$json$Json$Decode$succeed = _Json_succeed;
var elm$virtual_dom$VirtualDom$toHandlerInt = function (handler) {
	switch (handler.$) {
		case 'Normal':
			return 0;
		case 'MayStopPropagation':
			return 1;
		case 'MayPreventDefault':
			return 2;
		default:
			return 3;
	}
};
var elm$core$String$length = _String_length;
var elm$core$String$slice = _String_slice;
var elm$core$String$dropLeft = F2(
	function (n, string) {
		return (n < 1) ? string : A3(
			elm$core$String$slice,
			n,
			elm$core$String$length(string),
			string);
	});
var elm$core$String$startsWith = _String_startsWith;
var elm$url$Url$Http = {$: 'Http'};
var elm$url$Url$Https = {$: 'Https'};
var elm$core$String$indexes = _String_indexes;
var elm$core$String$left = F2(
	function (n, string) {
		return (n < 1) ? '' : A3(elm$core$String$slice, 0, n, string);
	});
var elm$core$String$contains = _String_contains;
var elm$url$Url$Url = F6(
	function (protocol, host, port_, path, query, fragment) {
		return {fragment: fragment, host: host, path: path, port_: port_, protocol: protocol, query: query};
	});
var elm$url$Url$chompBeforePath = F5(
	function (protocol, path, params, frag, str) {
		if (elm$core$String$isEmpty(str) || A2(elm$core$String$contains, '@', str)) {
			return elm$core$Maybe$Nothing;
		} else {
			var _n0 = A2(elm$core$String$indexes, ':', str);
			if (!_n0.b) {
				return elm$core$Maybe$Just(
					A6(elm$url$Url$Url, protocol, str, elm$core$Maybe$Nothing, path, params, frag));
			} else {
				if (!_n0.b.b) {
					var i = _n0.a;
					var _n1 = elm$core$String$toInt(
						A2(elm$core$String$dropLeft, i + 1, str));
					if (_n1.$ === 'Nothing') {
						return elm$core$Maybe$Nothing;
					} else {
						var port_ = _n1;
						return elm$core$Maybe$Just(
							A6(
								elm$url$Url$Url,
								protocol,
								A2(elm$core$String$left, i, str),
								port_,
								path,
								params,
								frag));
					}
				} else {
					return elm$core$Maybe$Nothing;
				}
			}
		}
	});
var elm$url$Url$chompBeforeQuery = F4(
	function (protocol, params, frag, str) {
		if (elm$core$String$isEmpty(str)) {
			return elm$core$Maybe$Nothing;
		} else {
			var _n0 = A2(elm$core$String$indexes, '/', str);
			if (!_n0.b) {
				return A5(elm$url$Url$chompBeforePath, protocol, '/', params, frag, str);
			} else {
				var i = _n0.a;
				return A5(
					elm$url$Url$chompBeforePath,
					protocol,
					A2(elm$core$String$dropLeft, i, str),
					params,
					frag,
					A2(elm$core$String$left, i, str));
			}
		}
	});
var elm$url$Url$chompBeforeFragment = F3(
	function (protocol, frag, str) {
		if (elm$core$String$isEmpty(str)) {
			return elm$core$Maybe$Nothing;
		} else {
			var _n0 = A2(elm$core$String$indexes, '?', str);
			if (!_n0.b) {
				return A4(elm$url$Url$chompBeforeQuery, protocol, elm$core$Maybe$Nothing, frag, str);
			} else {
				var i = _n0.a;
				return A4(
					elm$url$Url$chompBeforeQuery,
					protocol,
					elm$core$Maybe$Just(
						A2(elm$core$String$dropLeft, i + 1, str)),
					frag,
					A2(elm$core$String$left, i, str));
			}
		}
	});
var elm$url$Url$chompAfterProtocol = F2(
	function (protocol, str) {
		if (elm$core$String$isEmpty(str)) {
			return elm$core$Maybe$Nothing;
		} else {
			var _n0 = A2(elm$core$String$indexes, '#', str);
			if (!_n0.b) {
				return A3(elm$url$Url$chompBeforeFragment, protocol, elm$core$Maybe$Nothing, str);
			} else {
				var i = _n0.a;
				return A3(
					elm$url$Url$chompBeforeFragment,
					protocol,
					elm$core$Maybe$Just(
						A2(elm$core$String$dropLeft, i + 1, str)),
					A2(elm$core$String$left, i, str));
			}
		}
	});
var elm$url$Url$fromString = function (str) {
	return A2(elm$core$String$startsWith, 'http://', str) ? A2(
		elm$url$Url$chompAfterProtocol,
		elm$url$Url$Http,
		A2(elm$core$String$dropLeft, 7, str)) : (A2(elm$core$String$startsWith, 'https://', str) ? A2(
		elm$url$Url$chompAfterProtocol,
		elm$url$Url$Https,
		A2(elm$core$String$dropLeft, 8, str)) : elm$core$Maybe$Nothing);
};
var elm$browser$Browser$Navigation$pushUrl = _Browser_pushUrl;
var elm$core$Platform$Cmd$batch = _Platform_batch;
var elm$core$Platform$Cmd$none = elm$core$Platform$Cmd$batch(_List_Nil);
var elm$core$Task$attempt = F2(
	function (resultToMessage, task) {
		return elm$core$Task$command(
			elm$core$Task$Perform(
				A2(
					elm$core$Task$onError,
					A2(
						elm$core$Basics$composeL,
						A2(elm$core$Basics$composeL, elm$core$Task$succeed, resultToMessage),
						elm$core$Result$Err),
					A2(
						elm$core$Task$andThen,
						A2(
							elm$core$Basics$composeL,
							A2(elm$core$Basics$composeL, elm$core$Task$succeed, resultToMessage),
							elm$core$Result$Ok),
						task))));
	});
var author$project$WordApp$setRoute = F2(
	function (maybeRoute, model) {
		if (maybeRoute.$ === 'Nothing') {
			return _Utils_Tuple2(
				_Utils_update(
					model,
					{page: author$project$WordApp$NotFound}),
				elm$core$Platform$Cmd$none);
		} else {
			switch (maybeRoute.a.$) {
				case 'Login':
					var _n1 = maybeRoute.a;
					return _Utils_Tuple2(
						_Utils_update(
							model,
							{
								page: author$project$WordApp$Login(author$project$Page$Login$initialModel)
							}),
						elm$core$Platform$Cmd$none);
				case 'Register':
					var _n2 = maybeRoute.a;
					return _Utils_Tuple2(
						_Utils_update(
							model,
							{
								page: author$project$WordApp$Register(author$project$Page$Register$initialModel)
							}),
						A2(elm$core$Task$attempt, author$project$WordApp$RegisterInit, author$project$Page$Register$init));
				case 'ProfileEdit':
					var _n3 = maybeRoute.a;
					var user = function () {
						var _n4 = model.session.user;
						if (_n4.$ === 'Just') {
							var sessionUser = _n4.a;
							return sessionUser;
						} else {
							return A4(
								author$project$API$User,
								0,
								'',
								elm$core$Maybe$Just(''),
								_List_Nil);
						}
					}();
					return _Utils_Tuple2(
						_Utils_update(
							model,
							{
								page: author$project$WordApp$ProfileEdit(
									author$project$Page$ProfileEdit$initialModel(user))
							}),
						elm$core$Platform$Cmd$none);
				case 'Logout':
					var _n5 = maybeRoute.a;
					return _Utils_Tuple2(
						_Utils_update(
							model,
							{
								session: A2(author$project$Data$Session$Session, elm$core$Maybe$Nothing, elm$core$Maybe$Nothing)
							}),
						elm$core$Platform$Cmd$batch(
							_List_fromArray(
								[
									author$project$Data$Session$deleteSession,
									A2(elm$browser$Browser$Navigation$pushUrl, model.key, '/')
								])));
				case 'Home':
					var _n6 = maybeRoute.a;
					var newModel = _Utils_update(
						model,
						{
							page: author$project$WordApp$Home(
								author$project$Page$Home$initialModel(model.session))
						});
					var _n7 = model.session.user;
					if (_n7.$ === 'Nothing') {
						return _Utils_Tuple2(newModel, elm$core$Platform$Cmd$none);
					} else {
						var user = _n7.a;
						return _Utils_Tuple2(
							newModel,
							A2(
								elm$core$Task$attempt,
								author$project$WordApp$HomeInit,
								author$project$Page$Home$init(
									function ($) {
										return $.session;
									}(model))));
					}
				case 'WordEdit':
					var wordId = maybeRoute.a.a;
					var newModel = _Utils_update(
						model,
						{
							page: author$project$WordApp$WordEdit(author$project$Page$WordEdit$initialModel)
						});
					var _n8 = model.session.user;
					if (_n8.$ === 'Nothing') {
						return _Utils_Tuple2(newModel, elm$core$Platform$Cmd$none);
					} else {
						var user = _n8.a;
						return _Utils_Tuple2(
							newModel,
							A2(
								elm$core$Task$attempt,
								author$project$WordApp$WordEditInitMsg,
								A2(
									author$project$Page$WordEdit$init,
									function ($) {
										return $.session;
									}(model),
									wordId)));
					}
				case 'WordDelete':
					var wordId = maybeRoute.a.a;
					var newModel = _Utils_update(
						model,
						{
							page: author$project$WordApp$WordDelete(
								author$project$Page$WordDelete$Model(wordId))
						});
					var _n9 = model.session.user;
					if (_n9.$ === 'Nothing') {
						return _Utils_Tuple2(newModel, elm$core$Platform$Cmd$none);
					} else {
						var user = _n9.a;
						return _Utils_Tuple2(
							newModel,
							A2(
								elm$core$Task$attempt,
								author$project$WordApp$WordDeleteInitMsg,
								A2(
									author$project$Page$WordDelete$init,
									function ($) {
										return $.session;
									}(model),
									wordId)));
					}
				default:
					var keywordQuizz = maybeRoute.a.a;
					return _Utils_Tuple2(
						_Utils_update(
							model,
							{
								page: author$project$WordApp$Quizz(
									author$project$Page$Quizz$initialModel(keywordQuizz))
							}),
						A2(
							elm$core$Task$attempt,
							author$project$WordApp$QuizzInit,
							A2(
								author$project$Page$Quizz$init,
								function ($) {
									return $.session;
								}(model),
								keywordQuizz)));
			}
		}
	});
var elm$core$Result$withDefault = F2(
	function (def, result) {
		if (result.$ === 'Ok') {
			var a = result.a;
			return a;
		} else {
			return def;
		}
	});
var elm$json$Json$Decode$value = _Json_decodeValue;
var elm$json$Json$Encode$string = _Json_wrap;
var author$project$WordApp$init = F3(
	function (flags, url, argKey) {
		var sessionValue = A2(
			elm$core$Result$withDefault,
			elm$json$Json$Encode$string(''),
			A2(
				elm$json$Json$Decode$decodeValue,
				A2(elm$json$Json$Decode$field, 'session', elm$json$Json$Decode$value),
				flags));
		return A2(
			author$project$WordApp$setRoute,
			author$project$Route$fromUrl(url),
			{
				key: argKey,
				messages: _List_Nil,
				page: author$project$WordApp$NotFound,
				session: author$project$Data$Session$retrieveSessionFromJson(sessionValue)
			});
	});
var elm$core$Platform$Sub$batch = _Platform_batch;
var elm$core$Platform$Sub$none = elm$core$Platform$Sub$batch(_List_Nil);
var author$project$WordApp$subscriptions = function (model) {
	return elm$core$Platform$Sub$none;
};
var author$project$Data$Message$Message = F2(
	function (a, b) {
		return {$: 'Message', a: a, b: b};
	});
var author$project$Data$Message$Warning = {$: 'Warning'};
var author$project$Page$Home$InitFinished = function (a) {
	return {$: 'InitFinished', a: a};
};
var author$project$Page$Home$HomeAddNewWordFinished = function (a) {
	return {$: 'HomeAddNewWordFinished', a: a};
};
var author$project$Page$Home$HomeSearchWordFinished = function (a) {
	return {$: 'HomeSearchWordFinished', a: a};
};
var author$project$Page$Home$Logout = {$: 'Logout'};
var author$project$Page$Home$NoOp = {$: 'NoOp'};
var author$project$Page$Home$ReloadPage = {$: 'ReloadPage'};
var author$project$API$getWordsSearchBySearchWord = F3(
	function (headers, searchWord, searchKeyword) {
		var queryParamsStr = function () {
			if (searchKeyword === '--') {
				return 'word=' + searchWord;
			} else {
				var keyword = searchKeyword;
				return 'word=' + (searchWord + ('&keyword=' + keyword));
			}
		}();
		var queryParams = '?' + queryParamsStr;
		return elm$http$Http$request(
			{
				body: elm$http$Http$emptyBody,
				expect: elm$http$Http$expectJson(
					elm$json$Json$Decode$list(author$project$API$decodeWord)),
				headers: headers,
				method: 'GET',
				timeout: elm$core$Maybe$Nothing,
				url: A2(
					elm$core$String$join,
					'/',
					_List_fromArray(
						['http://127.1:8080', 'words', 'search', queryParams])),
				withCredentials: false
			});
	});
var author$project$Request$getWordsSearchRequest = F3(
	function (session, searchWord, searchKeyword) {
		var jwtToken = function () {
			var _n0 = session.authToken;
			if (_n0.$ === 'Just') {
				var responseJwtToken = _n0.a;
				return function ($) {
					return $.token;
				}(responseJwtToken);
			} else {
				return '';
			}
		}();
		var requestAuthHeader = A2(elm$http$Http$header, 'Authorization', jwtToken);
		return A3(
			author$project$API$getWordsSearchBySearchWord,
			_List_fromArray(
				[requestAuthHeader]),
			searchWord,
			searchKeyword);
	});
var elm$http$Http$send = F2(
	function (resultToMessage, request_) {
		return A2(
			elm$core$Task$attempt,
			resultToMessage,
			elm$http$Http$toTask(request_));
	});
var author$project$Request$getWordsSearchCmd = F4(
	function (msgType, session, searchWord, searchKeyword) {
		return A2(
			elm$http$Http$send,
			msgType,
			A3(author$project$Request$getWordsSearchRequest, session, searchWord, searchKeyword));
	});
var elm$core$Maybe$map = F2(
	function (f, maybe) {
		if (maybe.$ === 'Just') {
			var value = maybe.a;
			return elm$core$Maybe$Just(
				f(value));
		} else {
			return elm$core$Maybe$Nothing;
		}
	});
var elm$json$Json$Encode$int = _Json_wrap;
var elm$json$Json$Encode$list = F2(
	function (func, entries) {
		return _Json_wrap(
			A3(
				elm$core$List$foldl,
				_Json_addEntry(func),
				_Json_emptyArray(_Utils_Tuple0),
				entries));
	});
var elm$json$Json$Encode$object = function (pairs) {
	return _Json_wrap(
		A3(
			elm$core$List$foldl,
			F2(
				function (_n0, obj) {
					var k = _n0.a;
					var v = _n0.b;
					return A3(_Json_addField, k, v, obj);
				}),
			_Json_emptyObject(_Utils_Tuple0),
			pairs));
};
var author$project$API$encodeWord = function (x) {
	return elm$json$Json$Encode$object(
		_List_fromArray(
			[
				_Utils_Tuple2(
				'id',
				elm$json$Json$Encode$int(x.id)),
				_Utils_Tuple2(
				'language',
				elm$json$Json$Encode$string(x.language)),
				_Utils_Tuple2(
				'word',
				elm$json$Json$Encode$string(x.word)),
				_Utils_Tuple2(
				'keywords',
				elm$json$Json$Encode$list(elm$json$Json$Encode$string)(x.keywords)),
				_Utils_Tuple2(
				'definition',
				elm$json$Json$Encode$string(x.definition)),
				_Utils_Tuple2(
				'difficulty',
				A2(
					elm$core$Basics$composeL,
					elm$core$Maybe$withDefault(elm$json$Json$Encode$null),
					elm$core$Maybe$map(elm$json$Json$Encode$int))(x.difficulty))
			]));
};
var elm$http$Http$Internal$StringBody = F2(
	function (a, b) {
		return {$: 'StringBody', a: a, b: b};
	});
var elm$http$Http$jsonBody = function (value) {
	return A2(
		elm$http$Http$Internal$StringBody,
		'application/json',
		A2(elm$json$Json$Encode$encode, 0, value));
};
var author$project$API$postWords = F2(
	function (headers, argBody) {
		return elm$http$Http$request(
			{
				body: elm$http$Http$jsonBody(
					author$project$API$encodeWord(argBody)),
				expect: elm$http$Http$expectStringResponse(
					function (_n0) {
						var body = _n0.body;
						return elm$core$String$isEmpty(body) ? elm$core$Result$Ok(author$project$API$NoContent) : elm$core$Result$Err('Expected the response body to be empty');
					}),
				headers: headers,
				method: 'POST',
				timeout: elm$core$Maybe$Nothing,
				url: A2(
					elm$core$String$join,
					'/',
					_List_fromArray(
						['http://127.1:8080', 'words'])),
				withCredentials: false
			});
	});
var author$project$Request$postWordRequest = F2(
	function (session, word) {
		var jwtToken = function () {
			var _n0 = session.authToken;
			if (_n0.$ === 'Just') {
				var responseJwtToken = _n0.a;
				return function ($) {
					return $.token;
				}(responseJwtToken);
			} else {
				return '';
			}
		}();
		var requestAuthHeader = A2(elm$http$Http$header, 'Authorization', jwtToken);
		return A2(
			author$project$API$postWords,
			_List_fromArray(
				[requestAuthHeader]),
			word);
	});
var author$project$Request$postWordCmd = F3(
	function (msgType, session, word) {
		return A2(
			elm$http$Http$send,
			msgType,
			A2(author$project$Request$postWordRequest, session, word));
	});
var author$project$Page$Home$update = F3(
	function (session, msg, model) {
		switch (msg.$) {
			case 'TestMsg':
				return _Utils_Tuple2(
					_Utils_Tuple2(model, elm$core$Platform$Cmd$none),
					author$project$Page$Home$NoOp);
			case 'HomeAddNewWord':
				var httpCmd = A3(
					author$project$Request$postWordCmd,
					author$project$Page$Home$HomeAddNewWordFinished,
					session,
					A6(
						author$project$API$Word,
						0,
						function ($) {
							return $.addWordLanguage;
						}(model),
						function ($) {
							return $.addWordWord;
						}(model),
						_List_Nil,
						function ($) {
							return $.addWordDefinition;
						}(model),
						elm$core$Maybe$Nothing));
				return _Utils_Tuple2(
					_Utils_Tuple2(
						model,
						elm$core$Platform$Cmd$batch(
							_List_fromArray(
								[httpCmd]))),
					author$project$Page$Home$NoOp);
			case 'HomeAddNewWordFinished':
				if (msg.a.$ === 'Ok') {
					return _Utils_Tuple2(
						_Utils_Tuple2(model, elm$core$Platform$Cmd$none),
						author$project$Page$Home$ReloadPage);
				} else {
					var httpError = msg.a.a;
					if (httpError.$ === 'BadStatus') {
						var httpResponse = httpError.a;
						return _Utils_Tuple2(
							_Utils_Tuple2(model, elm$core$Platform$Cmd$none),
							author$project$Page$Home$Logout);
					} else {
						return _Utils_Tuple2(
							_Utils_Tuple2(model, elm$core$Platform$Cmd$none),
							author$project$Page$Home$NoOp);
					}
				}
			case 'TypeHomeLanguage':
				var newLanguage = msg.a;
				return _Utils_Tuple2(
					_Utils_Tuple2(
						_Utils_update(
							model,
							{addWordLanguage: newLanguage}),
						elm$core$Platform$Cmd$none),
					author$project$Page$Home$NoOp);
			case 'TypeHomeWord':
				var newWord = msg.a;
				return _Utils_Tuple2(
					_Utils_Tuple2(
						_Utils_update(
							model,
							{addWordWord: newWord}),
						elm$core$Platform$Cmd$none),
					author$project$Page$Home$NoOp);
			case 'TypeHomeDefinition':
				var newDefinition = msg.a;
				return _Utils_Tuple2(
					_Utils_Tuple2(
						_Utils_update(
							model,
							{addWordDefinition: newDefinition}),
						elm$core$Platform$Cmd$none),
					author$project$Page$Home$NoOp);
			case 'LastWordsReqCompletedMsg':
				if (msg.a.$ === 'Ok') {
					var listWords = msg.a.a;
					return _Utils_Tuple2(
						_Utils_Tuple2(
							_Utils_update(
								model,
								{myLastWords: listWords}),
							elm$core$Platform$Cmd$none),
						author$project$Page$Home$NoOp);
				} else {
					var httpError = msg.a.a;
					if (httpError.$ === 'BadStatus') {
						var httpResponse = httpError.a;
						return _Utils_Tuple2(
							_Utils_Tuple2(model, elm$core$Platform$Cmd$none),
							author$project$Page$Home$Logout);
					} else {
						return _Utils_Tuple2(
							_Utils_Tuple2(model, elm$core$Platform$Cmd$none),
							author$project$Page$Home$NoOp);
					}
				}
			case 'InitFinished':
				if (msg.a.$ === 'Ok') {
					var _n3 = msg.a.a;
					var lastWords = _n3.a;
					var keywords = _n3.b;
					return _Utils_Tuple2(
						_Utils_Tuple2(
							_Utils_update(
								model,
								{keywords: keywords, myLastWords: lastWords}),
							elm$core$Platform$Cmd$none),
						author$project$Page$Home$NoOp);
				} else {
					var pageLoadError = msg.a.a;
					return _Utils_Tuple2(
						_Utils_Tuple2(model, elm$core$Platform$Cmd$none),
						author$project$Page$Home$Logout);
				}
			case 'UpdateSearchWord':
				var newSearchWord = msg.a;
				return _Utils_Tuple2(
					_Utils_Tuple2(
						_Utils_update(
							model,
							{searchWord: newSearchWord}),
						elm$core$Platform$Cmd$none),
					author$project$Page$Home$NoOp);
			case 'UpdateSearchKeyword':
				var newSearchKeyword = msg.a;
				return _Utils_Tuple2(
					_Utils_Tuple2(
						_Utils_update(
							model,
							{searchKeyword: newSearchKeyword}),
						elm$core$Platform$Cmd$none),
					author$project$Page$Home$NoOp);
			case 'HomeSearchWord':
				return _Utils_Tuple2(
					_Utils_Tuple2(
						model,
						A4(
							author$project$Request$getWordsSearchCmd,
							author$project$Page$Home$HomeSearchWordFinished,
							session,
							function ($) {
								return $.searchWord;
							}(model),
							function ($) {
								return $.searchKeyword;
							}(model))),
					author$project$Page$Home$NoOp);
			default:
				if (msg.a.$ === 'Ok') {
					var listSearchWords = msg.a.a;
					return _Utils_Tuple2(
						_Utils_Tuple2(
							_Utils_update(
								model,
								{searchWords: listSearchWords}),
							elm$core$Platform$Cmd$none),
						author$project$Page$Home$NoOp);
				} else {
					var httpError = msg.a.a;
					if (httpError.$ === 'BadStatus') {
						var httpResponse = httpError.a;
						return _Utils_Tuple2(
							_Utils_Tuple2(model, elm$core$Platform$Cmd$none),
							author$project$Page$Home$Logout);
					} else {
						return _Utils_Tuple2(
							_Utils_Tuple2(model, elm$core$Platform$Cmd$none),
							author$project$Page$Home$NoOp);
					}
				}
		}
	});
var author$project$API$GrantUser = F2(
	function (username, password) {
		return {password: password, username: username};
	});
var author$project$API$encodeJWTToken = function (x) {
	return elm$json$Json$Encode$object(
		_List_fromArray(
			[
				_Utils_Tuple2(
				'token',
				elm$json$Json$Encode$string(x.token))
			]));
};
var author$project$API$encodeUser = function (x) {
	return elm$json$Json$Encode$object(
		_List_fromArray(
			[
				_Utils_Tuple2(
				'id',
				elm$json$Json$Encode$int(x.userid)),
				_Utils_Tuple2(
				'username',
				elm$json$Json$Encode$string(x.username)),
				_Utils_Tuple2(
				'email',
				A2(
					elm$core$Basics$composeL,
					elm$core$Maybe$withDefault(elm$json$Json$Encode$null),
					elm$core$Maybe$map(elm$json$Json$Encode$string))(x.email)),
				_Utils_Tuple2(
				'languages',
				elm$json$Json$Encode$list(elm$json$Json$Encode$string)(x.languages))
			]));
};
var author$project$Data$Session$encodeSession = function (session) {
	var _n0 = _Utils_Tuple2(session.user, session.authToken);
	if ((_n0.a.$ === 'Just') && (_n0.b.$ === 'Just')) {
		var user = _n0.a.a;
		var authToken = _n0.b.a;
		return elm$json$Json$Encode$object(
			_List_fromArray(
				[
					_Utils_Tuple2(
					'user',
					author$project$API$encodeUser(user)),
					_Utils_Tuple2(
					'authToken',
					author$project$API$encodeJWTToken(authToken))
				]));
	} else {
		return elm$json$Json$Encode$object(_List_Nil);
	}
};
var elm$core$Maybe$destruct = F3(
	function (_default, func, maybe) {
		if (maybe.$ === 'Just') {
			var a = maybe.a;
			return func(a);
		} else {
			return _default;
		}
	});
var author$project$Ports$storeSession = _Platform_outgoingPort(
	'storeSession',
	function ($) {
		return A3(elm$core$Maybe$destruct, elm$json$Json$Encode$null, elm$json$Json$Encode$string, $);
	});
var author$project$Data$Session$storeSession = function (session) {
	return author$project$Ports$storeSession(
		elm$core$Maybe$Just(
			A2(
				elm$json$Json$Encode$encode,
				0,
				author$project$Data$Session$encodeSession(session))));
};
var author$project$Page$Login$LoginGrantCompletedMsg = function (a) {
	return {$: 'LoginGrantCompletedMsg', a: a};
};
var author$project$Page$Login$LoginRequestUserCompletedMsg = function (a) {
	return {$: 'LoginRequestUserCompletedMsg', a: a};
};
var author$project$Page$Login$NoOp = {$: 'NoOp'};
var author$project$Page$Login$SetSession = function (a) {
	return {$: 'SetSession', a: a};
};
var author$project$API$decodeJWTToken = A2(
	elm$json$Json$Decode$map,
	author$project$API$JWTToken,
	A2(elm$json$Json$Decode$field, 'token', elm$json$Json$Decode$string));
var author$project$API$encodeGrantUser = function (grantUser) {
	return elm$json$Json$Encode$object(
		_List_fromArray(
			[
				_Utils_Tuple2(
				'username',
				elm$json$Json$Encode$string(
					function ($) {
						return $.username;
					}(grantUser))),
				_Utils_Tuple2(
				'password',
				elm$json$Json$Encode$string(
					function ($) {
						return $.password;
					}(grantUser)))
			]));
};
var author$project$API$getJWTToken = function (grantUser) {
	return elm$http$Http$request(
		{
			body: elm$http$Http$jsonBody(
				author$project$API$encodeGrantUser(grantUser)),
			expect: elm$http$Http$expectJson(author$project$API$decodeJWTToken),
			headers: _List_Nil,
			method: 'POST',
			timeout: elm$core$Maybe$Nothing,
			url: A2(
				elm$core$String$join,
				'/',
				_List_fromArray(
					['http://127.1:8080', 'auth', 'grant'])),
			withCredentials: false
		});
};
var author$project$Request$getJWTTokenRequest = function (grantUser) {
	return author$project$API$getJWTToken(grantUser);
};
var author$project$API$getUser = function (headers) {
	return elm$http$Http$request(
		{
			body: elm$http$Http$emptyBody,
			expect: elm$http$Http$expectJson(author$project$API$decodeUser),
			headers: headers,
			method: 'GET',
			timeout: elm$core$Maybe$Nothing,
			url: A2(
				elm$core$String$join,
				'/',
				_List_fromArray(
					['http://127.1:8080', 'user'])),
			withCredentials: false
		});
};
var author$project$Request$getUserRequest = function (jwtToken) {
	var requestAuthHeader = A2(elm$http$Http$header, 'Authorization', jwtToken.token);
	return author$project$API$getUser(
		_List_fromArray(
			[requestAuthHeader]));
};
var author$project$Request$getUserCmd = F2(
	function (msgType, jwtToken) {
		return A2(
			elm$http$Http$send,
			msgType,
			author$project$Request$getUserRequest(jwtToken));
	});
var author$project$Route$routeToString = function (page) {
	var pieces = function () {
		switch (page.$) {
			case 'Login':
				return _List_fromArray(
					['']);
			case 'Logout':
				return _List_fromArray(
					['logout']);
			case 'Register':
				return _List_fromArray(
					['register']);
			case 'ProfileEdit':
				return _List_fromArray(
					['profile']);
			case 'Home':
				return _List_fromArray(
					['home']);
			case 'WordEdit':
				var wordId = page.a;
				return _List_fromArray(
					[
						'wordEdit',
						elm$core$String$fromInt(wordId)
					]);
			case 'WordDelete':
				var wordId = page.a;
				return _List_fromArray(
					[
						'wordDelete',
						elm$core$String$fromInt(wordId)
					]);
			default:
				var keywordQuizz = page.a;
				return _List_fromArray(
					['quizz', keywordQuizz]);
		}
	}();
	return A2(elm$core$String$join, '/', pieces);
};
var author$project$Page$Login$update = F3(
	function (msg, key, model) {
		switch (msg.$) {
			case 'TypeLoginMsg':
				var userName = msg.a;
				return _Utils_Tuple2(
					_Utils_Tuple2(
						_Utils_update(
							model,
							{username: userName}),
						elm$core$Platform$Cmd$none),
					author$project$Page$Login$NoOp);
			case 'TypePasswordMsg':
				var userPassword = msg.a;
				return _Utils_Tuple2(
					_Utils_Tuple2(
						_Utils_update(
							model,
							{userpassword: userPassword}),
						elm$core$Platform$Cmd$none),
					author$project$Page$Login$NoOp);
			case 'LoginTryMsg':
				var httpCmd = A2(
					elm$http$Http$send,
					author$project$Page$Login$LoginGrantCompletedMsg,
					author$project$Request$getJWTTokenRequest(
						A2(
							author$project$API$GrantUser,
							function ($) {
								return $.username;
							}(model),
							function ($) {
								return $.userpassword;
							}(model))));
				return _Utils_Tuple2(
					_Utils_Tuple2(
						model,
						elm$core$Platform$Cmd$batch(
							_List_fromArray(
								[httpCmd]))),
					author$project$Page$Login$NoOp);
			case 'LoginGrantCompletedMsg':
				if (msg.a.$ === 'Ok') {
					var jwtToken = msg.a.a;
					return _Utils_Tuple2(
						_Utils_Tuple2(
							_Utils_update(
								model,
								{
									jwtToken: elm$core$Maybe$Just(jwtToken)
								}),
							elm$core$Platform$Cmd$batch(
								_List_fromArray(
									[
										A2(author$project$Request$getUserCmd, author$project$Page$Login$LoginRequestUserCompletedMsg, jwtToken)
									]))),
						author$project$Page$Login$NoOp);
				} else {
					var httpError = msg.a.a;
					switch (httpError.$) {
						case 'BadStatus':
							var httpResponse = httpError.a;
							return _Utils_Tuple2(
								_Utils_Tuple2(
									_Utils_update(
										model,
										{
											errors: A2(
												elm$core$List$cons,
												'Wrong credentials',
												function ($) {
													return $.errors;
												}(model))
										}),
									elm$core$Platform$Cmd$none),
								author$project$Page$Login$NoOp);
						case 'NetworkError':
							return _Utils_Tuple2(
								_Utils_Tuple2(
									_Utils_update(
										model,
										{
											errors: A2(
												elm$core$List$cons,
												'Wrong credentials',
												function ($) {
													return $.errors;
												}(model))
										}),
									elm$core$Platform$Cmd$none),
								author$project$Page$Login$NoOp);
						default:
							return _Utils_Tuple2(
								_Utils_Tuple2(model, elm$core$Platform$Cmd$none),
								author$project$Page$Login$NoOp);
					}
				}
			default:
				if (msg.a.$ === 'Ok') {
					var user = msg.a.a;
					var session = A2(
						author$project$Data$Session$Session,
						model.jwtToken,
						elm$core$Maybe$Just(user));
					return _Utils_Tuple2(
						_Utils_Tuple2(
							model,
							elm$core$Platform$Cmd$batch(
								_List_fromArray(
									[
										author$project$Data$Session$storeSession(session),
										A2(
										elm$browser$Browser$Navigation$pushUrl,
										key,
										author$project$Route$routeToString(author$project$Route$Home))
									]))),
						author$project$Page$Login$SetSession(session));
				} else {
					var httpError = msg.a.a;
					switch (httpError.$) {
						case 'BadStatus':
							var httpResponse = httpError.a;
							return _Utils_Tuple2(
								_Utils_Tuple2(
									_Utils_update(
										model,
										{
											errors: A2(
												elm$core$List$cons,
												'Wrong credentials',
												function ($) {
													return $.errors;
												}(model))
										}),
									elm$core$Platform$Cmd$none),
								author$project$Page$Login$NoOp);
						case 'NetworkError':
							return _Utils_Tuple2(
								_Utils_Tuple2(
									_Utils_update(
										model,
										{
											errors: A2(
												elm$core$List$cons,
												'Wrong credentials',
												function ($) {
													return $.errors;
												}(model))
										}),
									elm$core$Platform$Cmd$none),
								author$project$Page$Login$NoOp);
						default:
							return _Utils_Tuple2(
								_Utils_Tuple2(model, elm$core$Platform$Cmd$none),
								author$project$Page$Login$NoOp);
					}
				}
		}
	});
var author$project$API$FullUser = F5(
	function (userid, username, password, email, languages) {
		return {email: email, languages: languages, password: password, userid: userid, username: username};
	});
var author$project$Page$ProfileEdit$NoOp = {$: 'NoOp'};
var author$project$Page$ProfileEdit$UpdateSession = function (a) {
	return {$: 'UpdateSession', a: a};
};
var author$project$Page$ProfileEdit$UpdateUserRequestFinished = function (a) {
	return {$: 'UpdateUserRequestFinished', a: a};
};
var author$project$API$encodeFullUser = function (x) {
	return elm$json$Json$Encode$object(
		_List_fromArray(
			[
				_Utils_Tuple2(
				'id',
				elm$json$Json$Encode$int(x.userid)),
				_Utils_Tuple2(
				'username',
				elm$json$Json$Encode$string(x.username)),
				_Utils_Tuple2(
				'passpass',
				elm$json$Json$Encode$string(x.password)),
				_Utils_Tuple2(
				'email',
				A2(
					elm$core$Basics$composeL,
					elm$core$Maybe$withDefault(elm$json$Json$Encode$null),
					elm$core$Maybe$map(elm$json$Json$Encode$string))(x.email)),
				_Utils_Tuple2(
				'languages',
				elm$json$Json$Encode$list(elm$json$Json$Encode$string)(x.languages))
			]));
};
var author$project$API$updateUser = F2(
	function (headers, fullUser) {
		return elm$http$Http$request(
			{
				body: elm$http$Http$jsonBody(
					author$project$API$encodeFullUser(fullUser)),
				expect: elm$http$Http$expectJson(author$project$API$decodeUser),
				headers: headers,
				method: 'PUT',
				timeout: elm$core$Maybe$Nothing,
				url: A2(
					elm$core$String$join,
					'/',
					_List_fromArray(
						['http://127.1:8080', 'user'])),
				withCredentials: false
			});
	});
var author$project$Request$updateUserRequest = F2(
	function (session, user) {
		var jwtToken = function () {
			var _n0 = session.authToken;
			if (_n0.$ === 'Just') {
				var responseJwtToken = _n0.a;
				return function ($) {
					return $.token;
				}(responseJwtToken);
			} else {
				return '';
			}
		}();
		var requestAuthHeader = A2(elm$http$Http$header, 'Authorization', jwtToken);
		return A2(
			author$project$API$updateUser,
			_List_fromArray(
				[requestAuthHeader]),
			user);
	});
var elm$core$List$drop = F2(
	function (n, list) {
		drop:
		while (true) {
			if (n <= 0) {
				return list;
			} else {
				if (!list.b) {
					return list;
				} else {
					var x = list.a;
					var xs = list.b;
					var $temp$n = n - 1,
						$temp$list = xs;
					n = $temp$n;
					list = $temp$list;
					continue drop;
				}
			}
		}
	});
var elm$core$List$takeReverse = F3(
	function (n, list, kept) {
		takeReverse:
		while (true) {
			if (n <= 0) {
				return kept;
			} else {
				if (!list.b) {
					return kept;
				} else {
					var x = list.a;
					var xs = list.b;
					var $temp$n = n - 1,
						$temp$list = xs,
						$temp$kept = A2(elm$core$List$cons, x, kept);
					n = $temp$n;
					list = $temp$list;
					kept = $temp$kept;
					continue takeReverse;
				}
			}
		}
	});
var elm$core$List$takeTailRec = F2(
	function (n, list) {
		return elm$core$List$reverse(
			A3(elm$core$List$takeReverse, n, list, _List_Nil));
	});
var elm$core$List$takeFast = F3(
	function (ctr, n, list) {
		if (n <= 0) {
			return _List_Nil;
		} else {
			var _n0 = _Utils_Tuple2(n, list);
			_n0$1:
			while (true) {
				_n0$5:
				while (true) {
					if (!_n0.b.b) {
						return list;
					} else {
						if (_n0.b.b.b) {
							switch (_n0.a) {
								case 1:
									break _n0$1;
								case 2:
									var _n2 = _n0.b;
									var x = _n2.a;
									var _n3 = _n2.b;
									var y = _n3.a;
									return _List_fromArray(
										[x, y]);
								case 3:
									if (_n0.b.b.b.b) {
										var _n4 = _n0.b;
										var x = _n4.a;
										var _n5 = _n4.b;
										var y = _n5.a;
										var _n6 = _n5.b;
										var z = _n6.a;
										return _List_fromArray(
											[x, y, z]);
									} else {
										break _n0$5;
									}
								default:
									if (_n0.b.b.b.b && _n0.b.b.b.b.b) {
										var _n7 = _n0.b;
										var x = _n7.a;
										var _n8 = _n7.b;
										var y = _n8.a;
										var _n9 = _n8.b;
										var z = _n9.a;
										var _n10 = _n9.b;
										var w = _n10.a;
										var tl = _n10.b;
										return (ctr > 1000) ? A2(
											elm$core$List$cons,
											x,
											A2(
												elm$core$List$cons,
												y,
												A2(
													elm$core$List$cons,
													z,
													A2(
														elm$core$List$cons,
														w,
														A2(elm$core$List$takeTailRec, n - 4, tl))))) : A2(
											elm$core$List$cons,
											x,
											A2(
												elm$core$List$cons,
												y,
												A2(
													elm$core$List$cons,
													z,
													A2(
														elm$core$List$cons,
														w,
														A3(elm$core$List$takeFast, ctr + 1, n - 4, tl)))));
									} else {
										break _n0$5;
									}
							}
						} else {
							if (_n0.a === 1) {
								break _n0$1;
							} else {
								break _n0$5;
							}
						}
					}
				}
				return list;
			}
			var _n1 = _n0.b;
			var x = _n1.a;
			return _List_fromArray(
				[x]);
		}
	});
var elm$core$List$take = F2(
	function (n, list) {
		return A3(elm$core$List$takeFast, 0, n, list);
	});
var author$project$Page$ProfileEdit$update = F4(
	function (session, key, msg, model) {
		switch (msg.$) {
			case 'TestMsg':
				return _Utils_Tuple2(
					_Utils_Tuple2(model, elm$core$Platform$Cmd$none),
					author$project$Page$ProfileEdit$NoOp);
			case 'UpdatePassword':
				var newPassword = msg.a;
				return _Utils_Tuple2(
					_Utils_Tuple2(
						_Utils_update(
							model,
							{password: newPassword}),
						elm$core$Platform$Cmd$none),
					author$project$Page$ProfileEdit$NoOp);
			case 'UpdateUser':
				var newUser = msg.a;
				return _Utils_Tuple2(
					_Utils_Tuple2(
						_Utils_update(
							model,
							{user: newUser}),
						elm$core$Platform$Cmd$none),
					author$project$Page$ProfileEdit$NoOp);
			case 'IncreaseNbLanguage':
				return _Utils_Tuple2(
					_Utils_Tuple2(
						_Utils_update(
							model,
							{nbLanguage: model.nbLanguage + 1}),
						elm$core$Platform$Cmd$none),
					author$project$Page$ProfileEdit$NoOp);
			case 'RemoveLanguage':
				var argIndexLanguage = msg.a;
				var removeLanguage = F2(
					function (user, indexLanguage) {
						return _Utils_update(
							user,
							{
								languages: _Utils_ap(
									A2(elm$core$List$take, argIndexLanguage, user.languages),
									A2(elm$core$List$drop, argIndexLanguage + 1, user.languages))
							});
					});
				return _Utils_Tuple2(
					_Utils_Tuple2(
						_Utils_update(
							model,
							{
								nbLanguage: model.nbLanguage - 1,
								user: A2(removeLanguage, model.user, argIndexLanguage)
							}),
						elm$core$Platform$Cmd$none),
					author$project$Page$ProfileEdit$NoOp);
			case 'ToUpdateUser':
				var username = function ($) {
					return $.username;
				}(model.user);
				var password = model.password;
				var languages = function ($) {
					return $.languages;
				}(model.user);
				var email = function ($) {
					return $.email;
				}(model.user);
				return _Utils_Tuple2(
					_Utils_Tuple2(
						model,
						A2(
							elm$http$Http$send,
							author$project$Page$ProfileEdit$UpdateUserRequestFinished,
							A2(
								author$project$Request$updateUserRequest,
								session,
								A5(author$project$API$FullUser, 0, username, password, email, languages)))),
					author$project$Page$ProfileEdit$NoOp);
			default:
				if (msg.a.$ === 'Ok') {
					var user = msg.a.a;
					var newSession = _Utils_update(
						session,
						{
							user: elm$core$Maybe$Just(user)
						});
					return _Utils_Tuple2(
						_Utils_Tuple2(
							model,
							elm$core$Platform$Cmd$batch(
								_List_fromArray(
									[
										author$project$Data$Session$storeSession(newSession),
										A2(
										elm$browser$Browser$Navigation$pushUrl,
										key,
										author$project$Route$routeToString(author$project$Route$Home))
									]))),
						author$project$Page$ProfileEdit$UpdateSession(newSession));
				} else {
					var noContent = msg.a.a;
					return _Utils_Tuple2(
						_Utils_Tuple2(model, elm$core$Platform$Cmd$none),
						author$project$Page$ProfileEdit$NoOp);
				}
		}
	});
var author$project$Page$Quizz$QuizzInitFinished = function (a) {
	return {$: 'QuizzInitFinished', a: a};
};
var author$project$Page$Quizz$NoOp = {$: 'NoOp'};
var author$project$Page$Quizz$QuizzReInit = {$: 'QuizzReInit'};
var author$project$Page$Quizz$QuizzReInitFinished = function (a) {
	return {$: 'QuizzReInitFinished', a: a};
};
var author$project$Page$Quizz$TakeQuizzNb = function (a) {
	return {$: 'TakeQuizzNb', a: a};
};
var author$project$Page$Quizz$TakeQuizzResponse = function (a) {
	return {$: 'TakeQuizzResponse', a: a};
};
var elm$core$Basics$always = F2(
	function (a, _n0) {
		return a;
	});
var elm$core$Process$sleep = _Process_sleep;
var author$project$Page$Quizz$delay = F2(
	function (timeout, msg) {
		return A2(
			elm$core$Task$perform,
			elm$core$Basics$identity,
			A2(
				elm$core$Task$andThen,
				elm$core$Basics$always(
					elm$core$Task$succeed(msg)),
				elm$core$Process$sleep(timeout)));
	});
var elm$json$Json$Decode$bool = _Json_decodeBool;
var author$project$API$postWordQuizzResponse = F3(
	function (headers, wordId, response) {
		return elm$http$Http$request(
			{
				body: elm$http$Http$jsonBody(
					elm$json$Json$Encode$string(response)),
				expect: elm$http$Http$expectJson(
					elm$json$Json$Decode$nullable(elm$json$Json$Decode$bool)),
				headers: headers,
				method: 'POST',
				timeout: elm$core$Maybe$Nothing,
				url: A2(
					elm$core$String$join,
					'/',
					_List_fromArray(
						[
							'http://127.1:8080',
							'words',
							'quizz',
							'response',
							elm$core$String$fromInt(wordId)
						])),
				withCredentials: false
			});
	});
var author$project$Request$postWordQuizzResponseRequest = F3(
	function (session, wordId, response) {
		var jwtToken = function () {
			var _n0 = session.authToken;
			if (_n0.$ === 'Just') {
				var responseJwtToken = _n0.a;
				return function ($) {
					return $.token;
				}(responseJwtToken);
			} else {
				return '';
			}
		}();
		var requestAuthHeader = A2(elm$http$Http$header, 'Authorization', jwtToken);
		return A3(
			author$project$API$postWordQuizzResponse,
			_List_fromArray(
				[requestAuthHeader]),
			wordId,
			response);
	});
var author$project$Request$postWordQuizzResponseCmd = F4(
	function (msgType, session, wordId, wordResponse) {
		return A2(
			elm$http$Http$send,
			msgType,
			A3(author$project$Request$postWordQuizzResponseRequest, session, wordId, wordResponse));
	});
var elm$random$Random$Generate = function (a) {
	return {$: 'Generate', a: a};
};
var elm$core$Bitwise$shiftRightZfBy = _Bitwise_shiftRightZfBy;
var elm$random$Random$Seed = F2(
	function (a, b) {
		return {$: 'Seed', a: a, b: b};
	});
var elm$random$Random$next = function (_n0) {
	var state0 = _n0.a;
	var incr = _n0.b;
	return A2(elm$random$Random$Seed, ((state0 * 1664525) + incr) >>> 0, incr);
};
var elm$random$Random$initialSeed = function (x) {
	var _n0 = elm$random$Random$next(
		A2(elm$random$Random$Seed, 0, 1013904223));
	var state1 = _n0.a;
	var incr = _n0.b;
	var state2 = (state1 + x) >>> 0;
	return elm$random$Random$next(
		A2(elm$random$Random$Seed, state2, incr));
};
var elm$time$Time$Name = function (a) {
	return {$: 'Name', a: a};
};
var elm$time$Time$Offset = function (a) {
	return {$: 'Offset', a: a};
};
var elm$time$Time$Zone = F2(
	function (a, b) {
		return {$: 'Zone', a: a, b: b};
	});
var elm$time$Time$customZone = elm$time$Time$Zone;
var elm$time$Time$Posix = function (a) {
	return {$: 'Posix', a: a};
};
var elm$time$Time$millisToPosix = elm$time$Time$Posix;
var elm$time$Time$now = _Time_now(elm$time$Time$millisToPosix);
var elm$time$Time$posixToMillis = function (_n0) {
	var millis = _n0.a;
	return millis;
};
var elm$random$Random$init = A2(
	elm$core$Task$andThen,
	function (time) {
		return elm$core$Task$succeed(
			elm$random$Random$initialSeed(
				elm$time$Time$posixToMillis(time)));
	},
	elm$time$Time$now);
var elm$random$Random$step = F2(
	function (_n0, seed) {
		var generator = _n0.a;
		return generator(seed);
	});
var elm$random$Random$onEffects = F3(
	function (router, commands, seed) {
		if (!commands.b) {
			return elm$core$Task$succeed(seed);
		} else {
			var generator = commands.a.a;
			var rest = commands.b;
			var _n1 = A2(elm$random$Random$step, generator, seed);
			var value = _n1.a;
			var newSeed = _n1.b;
			return A2(
				elm$core$Task$andThen,
				function (_n2) {
					return A3(elm$random$Random$onEffects, router, rest, newSeed);
				},
				A2(elm$core$Platform$sendToApp, router, value));
		}
	});
var elm$random$Random$onSelfMsg = F3(
	function (_n0, _n1, seed) {
		return elm$core$Task$succeed(seed);
	});
var elm$random$Random$Generator = function (a) {
	return {$: 'Generator', a: a};
};
var elm$random$Random$map = F2(
	function (func, _n0) {
		var genA = _n0.a;
		return elm$random$Random$Generator(
			function (seed0) {
				var _n1 = genA(seed0);
				var a = _n1.a;
				var seed1 = _n1.b;
				return _Utils_Tuple2(
					func(a),
					seed1);
			});
	});
var elm$random$Random$cmdMap = F2(
	function (func, _n0) {
		var generator = _n0.a;
		return elm$random$Random$Generate(
			A2(elm$random$Random$map, func, generator));
	});
_Platform_effectManagers['Random'] = _Platform_createManager(elm$random$Random$init, elm$random$Random$onEffects, elm$random$Random$onSelfMsg, elm$random$Random$cmdMap);
var elm$random$Random$command = _Platform_leaf('Random');
var elm$random$Random$generate = F2(
	function (tagger, generator) {
		return elm$random$Random$command(
			elm$random$Random$Generate(
				A2(elm$random$Random$map, tagger, generator)));
	});
var elm$core$Basics$negate = function (n) {
	return -n;
};
var elm$core$Bitwise$and = _Bitwise_and;
var elm$core$Bitwise$xor = _Bitwise_xor;
var elm$random$Random$peel = function (_n0) {
	var state = _n0.a;
	var word = (state ^ (state >>> ((state >>> 28) + 4))) * 277803737;
	return ((word >>> 22) ^ word) >>> 0;
};
var elm$random$Random$int = F2(
	function (a, b) {
		return elm$random$Random$Generator(
			function (seed0) {
				var _n0 = (_Utils_cmp(a, b) < 0) ? _Utils_Tuple2(a, b) : _Utils_Tuple2(b, a);
				var lo = _n0.a;
				var hi = _n0.b;
				var range = (hi - lo) + 1;
				if (!((range - 1) & range)) {
					return _Utils_Tuple2(
						(((range - 1) & elm$random$Random$peel(seed0)) >>> 0) + lo,
						elm$random$Random$next(seed0));
				} else {
					var threshhold = (((-range) >>> 0) % range) >>> 0;
					var accountForBias = function (seed) {
						accountForBias:
						while (true) {
							var x = elm$random$Random$peel(seed);
							var seedN = elm$random$Random$next(seed);
							if (_Utils_cmp(x, threshhold) < 0) {
								var $temp$seed = seedN;
								seed = $temp$seed;
								continue accountForBias;
							} else {
								return _Utils_Tuple2((x % range) + lo, seedN);
							}
						}
					};
					return accountForBias(seed0);
				}
			});
	});
var author$project$Page$Quizz$update = F3(
	function (session, msg, model) {
		switch (msg.$) {
			case 'QuizzReInit':
				return _Utils_Tuple2(
					_Utils_Tuple2(
						_Utils_update(
							model,
							{word: elm$core$Maybe$Nothing, wordResponse: ''}),
						A2(
							elm$core$Task$attempt,
							author$project$Page$Quizz$QuizzReInitFinished,
							A2(author$project$Page$Quizz$init, session, model.keyword))),
					author$project$Page$Quizz$NoOp);
			case 'QuizzInitFinished':
				if (msg.a.$ === 'Ok') {
					var listWords = msg.a.a;
					return _Utils_Tuple2(
						_Utils_Tuple2(
							_Utils_update(
								model,
								{words: listWords}),
							elm$core$Platform$Cmd$none),
						author$project$Page$Quizz$NoOp);
				} else {
					return _Utils_Tuple2(
						_Utils_Tuple2(model, elm$core$Platform$Cmd$none),
						author$project$Page$Quizz$NoOp);
				}
			case 'QuizzReInitFinished':
				if (msg.a.$ === 'Ok') {
					var listWords = msg.a.a;
					return _Utils_Tuple2(
						_Utils_Tuple2(
							_Utils_update(
								model,
								{word: elm$core$Maybe$Nothing, wordResponse: '', words: listWords}),
							elm$core$Platform$Cmd$none),
						author$project$Page$Quizz$NoOp);
				} else {
					return _Utils_Tuple2(
						_Utils_Tuple2(model, elm$core$Platform$Cmd$none),
						author$project$Page$Quizz$NoOp);
				}
			case 'TakeQuizz':
				return _Utils_Tuple2(
					_Utils_Tuple2(
						model,
						A2(
							elm$random$Random$generate,
							author$project$Page$Quizz$TakeQuizzNb,
							A2(
								elm$random$Random$int,
								0,
								elm$core$List$length(model.words)))),
					author$project$Page$Quizz$NoOp);
			case 'TakeQuizzNb':
				var randomInt = msg.a;
				var randomWord = elm$core$List$head(
					A2(elm$core$List$drop, randomInt, model.words));
				return _Utils_Tuple2(
					_Utils_Tuple2(
						_Utils_update(
							model,
							{
								word: A2(
									elm$core$Maybe$map,
									function (w) {
										return _Utils_Tuple2(w, elm$core$Maybe$Nothing);
									},
									randomWord)
							}),
						elm$core$Platform$Cmd$none),
					author$project$Page$Quizz$NoOp);
			case 'TakeQuizzUpdateResponse':
				var newReponse = msg.a;
				return _Utils_Tuple2(
					_Utils_Tuple2(
						_Utils_update(
							model,
							{wordResponse: newReponse}),
						elm$core$Platform$Cmd$none),
					author$project$Page$Quizz$NoOp);
			case 'TakeQuizzAttempt':
				var wordId = function () {
					var _n1 = model.word;
					if (_n1.$ === 'Just') {
						var _n2 = _n1.a;
						var theWord = _n2.a;
						return theWord.id;
					} else {
						return 0;
					}
				}();
				return _Utils_Tuple2(
					_Utils_Tuple2(
						model,
						A4(author$project$Request$postWordQuizzResponseCmd, author$project$Page$Quizz$TakeQuizzResponse, session, wordId, model.wordResponse)),
					author$project$Page$Quizz$NoOp);
			case 'TakeQuizzResponse':
				if (msg.a.$ === 'Ok') {
					var maybeVerified = msg.a.a;
					var newWord = function () {
						var _n3 = model.word;
						if (_n3.$ === 'Just') {
							var _n4 = _n3.a;
							var theWord = _n4.a;
							return elm$core$Maybe$Just(
								_Utils_Tuple2(theWord, maybeVerified));
						} else {
							return elm$core$Maybe$Nothing;
						}
					}();
					return _Utils_Tuple2(
						_Utils_Tuple2(
							_Utils_update(
								model,
								{word: newWord}),
							A2(author$project$Page$Quizz$delay, 4000, author$project$Page$Quizz$QuizzReInit)),
						author$project$Page$Quizz$NoOp);
				} else {
					return _Utils_Tuple2(
						_Utils_Tuple2(
							model,
							A2(
								elm$core$Task$attempt,
								author$project$Page$Quizz$QuizzReInitFinished,
								A2(author$project$Page$Quizz$init, session, model.keyword))),
						author$project$Page$Quizz$NoOp);
				}
			default:
				return _Utils_Tuple2(
					_Utils_Tuple2(model, elm$core$Platform$Cmd$none),
					author$project$Page$Quizz$NoOp);
		}
	});
var author$project$Page$Register$InitFinished = function (a) {
	return {$: 'InitFinished', a: a};
};
var author$project$API$encodeNewUser = function (x) {
	return elm$json$Json$Encode$object(
		_List_fromArray(
			[
				_Utils_Tuple2(
				'username',
				elm$json$Json$Encode$string(x.username)),
				_Utils_Tuple2(
				'password',
				elm$json$Json$Encode$string(x.password)),
				_Utils_Tuple2(
				'email',
				A2(
					elm$core$Basics$composeL,
					elm$core$Maybe$withDefault(elm$json$Json$Encode$null),
					elm$core$Maybe$map(elm$json$Json$Encode$string))(x.email)),
				_Utils_Tuple2(
				'languages',
				elm$json$Json$Encode$list(elm$json$Json$Encode$string)(x.languages))
			]));
};
var author$project$API$postNewUser = F2(
	function (token, newUser) {
		return elm$http$Http$request(
			{
				body: elm$http$Http$jsonBody(
					author$project$API$encodeNewUser(newUser)),
				expect: elm$http$Http$expectStringResponse(
					function (_n0) {
						var body = _n0.body;
						return elm$core$String$isEmpty(body) ? elm$core$Result$Ok(author$project$API$NoContent) : elm$core$Result$Err('Expected the response body to be empty');
					}),
				headers: _List_Nil,
				method: 'POST',
				timeout: elm$core$Maybe$Nothing,
				url: A2(
					elm$core$String$join,
					'/',
					_List_fromArray(
						['http://127.1:8080', 'auth', 'create', token])),
				withCredentials: false
			});
	});
var author$project$Page$Register$GoLogin = {$: 'GoLogin'};
var author$project$Page$Register$NoOp = {$: 'NoOp'};
var author$project$Page$Register$RegisterFinished = function (a) {
	return {$: 'RegisterFinished', a: a};
};
var author$project$Page$Register$update = F2(
	function (msg, model) {
		switch (msg.$) {
			case 'IncreaseNbLanguage':
				return _Utils_Tuple2(
					_Utils_Tuple2(
						_Utils_update(
							model,
							{nbLanguage: model.nbLanguage + 1}),
						elm$core$Platform$Cmd$none),
					author$project$Page$Register$NoOp);
			case 'InitFinished':
				if (msg.a.$ === 'Ok') {
					var token = msg.a.a;
					return _Utils_Tuple2(
						_Utils_Tuple2(
							_Utils_update(
								model,
								{token: token}),
							elm$core$Platform$Cmd$none),
						author$project$Page$Register$NoOp);
				} else {
					var err = msg.a.a;
					var errorString = function () {
						switch (err.$) {
							case 'BadUrl':
								return 'bad url';
							case 'Timeout':
								return 'timeout';
							case 'NetworkError':
								return 'network error';
							case 'BadStatus':
								return 'bad status';
							default:
								return 'bad payload';
						}
					}();
					return _Utils_Tuple2(
						_Utils_Tuple2(
							_Utils_update(
								model,
								{
									errors: A2(elm$core$List$cons, errorString, model.errors)
								}),
							elm$core$Platform$Cmd$none),
						author$project$Page$Register$NoOp);
				}
			case 'UpdateNewUser':
				var newUser = msg.a;
				return _Utils_Tuple2(
					_Utils_Tuple2(
						_Utils_update(
							model,
							{newUser: newUser}),
						elm$core$Platform$Cmd$none),
					author$project$Page$Register$NoOp);
			case 'Register':
				return _Utils_Tuple2(
					_Utils_Tuple2(
						model,
						A2(
							elm$http$Http$send,
							author$project$Page$Register$RegisterFinished,
							A2(author$project$API$postNewUser, model.token, model.newUser))),
					author$project$Page$Register$NoOp);
			default:
				if (msg.a.$ === 'Ok') {
					return _Utils_Tuple2(
						_Utils_Tuple2(model, elm$core$Platform$Cmd$none),
						author$project$Page$Register$GoLogin);
				} else {
					var err = msg.a.a;
					var errorString = function () {
						switch (err.$) {
							case 'BadUrl':
								return 'bad url';
							case 'Timeout':
								return 'timeout';
							case 'NetworkError':
								return 'network error';
							case 'BadStatus':
								return 'bad status';
							default:
								return 'bad payload';
						}
					}();
					return _Utils_Tuple2(
						_Utils_Tuple2(
							_Utils_update(
								model,
								{
									errors: A2(elm$core$List$cons, errorString, model.errors)
								}),
							elm$core$Platform$Cmd$none),
						author$project$Page$Register$NoOp);
				}
		}
	});
var author$project$Page$WordDelete$WordDeleteInitFinished = function (a) {
	return {$: 'WordDeleteInitFinished', a: a};
};
var author$project$Page$WordDelete$GoHome = {$: 'GoHome'};
var author$project$Page$WordDelete$Logout = {$: 'Logout'};
var author$project$Page$WordDelete$NoOp = {$: 'NoOp'};
var author$project$Page$WordDelete$update = F3(
	function (session, msg, model) {
		if (msg.a.$ === 'Ok') {
			return _Utils_Tuple2(
				_Utils_Tuple2(model, elm$core$Platform$Cmd$none),
				author$project$Page$WordDelete$GoHome);
		} else {
			var httpError = msg.a.a;
			if (httpError.$ === 'BadStatus') {
				var httpResponse = httpError.a;
				return _Utils_Tuple2(
					_Utils_Tuple2(model, elm$core$Platform$Cmd$none),
					author$project$Page$WordDelete$Logout);
			} else {
				return _Utils_Tuple2(
					_Utils_Tuple2(model, elm$core$Platform$Cmd$none),
					author$project$Page$WordDelete$NoOp);
			}
		}
	});
var author$project$Page$WordEdit$WordEditInitFinished = function (a) {
	return {$: 'WordEditInitFinished', a: a};
};
var author$project$Page$WordEdit$GoHome = {$: 'GoHome'};
var author$project$Page$WordEdit$Logout = {$: 'Logout'};
var author$project$Page$WordEdit$NoOp = {$: 'NoOp'};
var author$project$Page$WordEdit$UpdateWordRequestFinished = function (a) {
	return {$: 'UpdateWordRequestFinished', a: a};
};
var author$project$API$putWordsIdByWordId = F3(
	function (headers, capture_wordId, body) {
		return elm$http$Http$request(
			{
				body: elm$http$Http$jsonBody(
					author$project$API$encodeWord(body)),
				expect: elm$http$Http$expectJson(author$project$API$decodeWord),
				headers: headers,
				method: 'PUT',
				timeout: elm$core$Maybe$Nothing,
				url: A2(
					elm$core$String$join,
					'/',
					_List_fromArray(
						[
							'http://127.1:8080',
							'words',
							'id',
							elm$core$String$fromInt(capture_wordId)
						])),
				withCredentials: false
			});
	});
var author$project$Request$putWordsIdByWordIdRequest = F2(
	function (session, word) {
		var jwtToken = function () {
			var _n0 = session.authToken;
			if (_n0.$ === 'Just') {
				var responseJwtToken = _n0.a;
				return function ($) {
					return $.token;
				}(responseJwtToken);
			} else {
				return '';
			}
		}();
		var requestAuthHeader = A2(elm$http$Http$header, 'Authorization', jwtToken);
		return A3(
			author$project$API$putWordsIdByWordId,
			_List_fromArray(
				[requestAuthHeader]),
			function ($) {
				return $.id;
			}(word),
			word);
	});
var author$project$Request$putWordsIdByWordIdCmd = F3(
	function (msgType, session, word) {
		return A2(
			elm$http$Http$send,
			msgType,
			A2(author$project$Request$putWordsIdByWordIdRequest, session, word));
	});
var author$project$Page$WordEdit$update = F3(
	function (session, msg, model) {
		switch (msg.$) {
			case 'TestMsg':
				return _Utils_Tuple2(
					_Utils_Tuple2(model, elm$core$Platform$Cmd$none),
					author$project$Page$WordEdit$NoOp);
			case 'IncreaseNbKeyword':
				return _Utils_Tuple2(
					_Utils_Tuple2(
						_Utils_update(
							model,
							{nbKeyword: model.nbKeyword + 1}),
						elm$core$Platform$Cmd$none),
					author$project$Page$WordEdit$NoOp);
			case 'RemoveKeyword':
				var argIndexKeyword = msg.a;
				var removeKeyword = F2(
					function (word, indexKeyword) {
						if (word.$ === 'Just') {
							var w = word.a;
							return elm$core$Maybe$Just(
								_Utils_update(
									w,
									{
										keywords: _Utils_ap(
											A2(elm$core$List$take, argIndexKeyword, w.keywords),
											A2(elm$core$List$drop, argIndexKeyword + 1, w.keywords))
									}));
						} else {
							return word;
						}
					});
				return _Utils_Tuple2(
					_Utils_Tuple2(
						_Utils_update(
							model,
							{
								nbKeyword: model.nbKeyword - 1,
								word: A2(removeKeyword, model.word, argIndexKeyword)
							}),
						elm$core$Platform$Cmd$none),
					author$project$Page$WordEdit$NoOp);
			case 'UpdateWord':
				var newWord = msg.a;
				return _Utils_Tuple2(
					_Utils_Tuple2(
						_Utils_update(
							model,
							{
								word: elm$core$Maybe$Just(newWord)
							}),
						elm$core$Platform$Cmd$none),
					author$project$Page$WordEdit$NoOp);
			case 'WordEditInitFinished':
				if (msg.a.$ === 'Err') {
					var httpError = msg.a.a;
					if (httpError.$ === 'BadStatus') {
						var httpResponse = httpError.a;
						return _Utils_Tuple2(
							_Utils_Tuple2(model, elm$core$Platform$Cmd$none),
							author$project$Page$WordEdit$Logout);
					} else {
						return _Utils_Tuple2(
							_Utils_Tuple2(model, elm$core$Platform$Cmd$none),
							author$project$Page$WordEdit$NoOp);
					}
				} else {
					var word = msg.a.a;
					return _Utils_Tuple2(
						_Utils_Tuple2(
							_Utils_update(
								model,
								{
									nbKeyword: elm$core$List$length(word.keywords) + 1,
									word: elm$core$Maybe$Just(word)
								}),
							elm$core$Platform$Cmd$none),
						author$project$Page$WordEdit$NoOp);
				}
			case 'UpdateWordRequest':
				var _n3 = model.word;
				if (_n3.$ === 'Nothing') {
					return _Utils_Tuple2(
						_Utils_Tuple2(model, elm$core$Platform$Cmd$none),
						author$project$Page$WordEdit$NoOp);
				} else {
					var word = _n3.a;
					return _Utils_Tuple2(
						_Utils_Tuple2(
							model,
							A3(author$project$Request$putWordsIdByWordIdCmd, author$project$Page$WordEdit$UpdateWordRequestFinished, session, word)),
						author$project$Page$WordEdit$NoOp);
				}
			default:
				if (msg.a.$ === 'Ok') {
					var word = msg.a.a;
					return _Utils_Tuple2(
						_Utils_Tuple2(
							_Utils_update(
								model,
								{
									word: elm$core$Maybe$Just(word)
								}),
							elm$core$Platform$Cmd$none),
						author$project$Page$WordEdit$GoHome);
				} else {
					var httpError = msg.a.a;
					if (httpError.$ === 'BadStatus') {
						var httpResponse = httpError.a;
						return _Utils_Tuple2(
							_Utils_Tuple2(model, elm$core$Platform$Cmd$none),
							author$project$Page$WordEdit$Logout);
					} else {
						return _Utils_Tuple2(
							_Utils_Tuple2(model, elm$core$Platform$Cmd$none),
							author$project$Page$WordEdit$NoOp);
					}
				}
		}
	});
var author$project$WordApp$HomeMsg = function (a) {
	return {$: 'HomeMsg', a: a};
};
var author$project$WordApp$LoginMsg = function (a) {
	return {$: 'LoginMsg', a: a};
};
var author$project$WordApp$ProfileEditMsg = function (a) {
	return {$: 'ProfileEditMsg', a: a};
};
var author$project$WordApp$QuizzMsg = function (a) {
	return {$: 'QuizzMsg', a: a};
};
var author$project$WordApp$RegisterMsg = function (a) {
	return {$: 'RegisterMsg', a: a};
};
var author$project$WordApp$WordDeleteMsg = function (a) {
	return {$: 'WordDeleteMsg', a: a};
};
var author$project$WordApp$WordEditMsg = function (a) {
	return {$: 'WordEditMsg', a: a};
};
var elm$browser$Browser$Navigation$load = _Browser_load;
var elm$core$Platform$Cmd$map = _Platform_map;
var elm$url$Url$addPort = F2(
	function (maybePort, starter) {
		if (maybePort.$ === 'Nothing') {
			return starter;
		} else {
			var port_ = maybePort.a;
			return starter + (':' + elm$core$String$fromInt(port_));
		}
	});
var elm$url$Url$addPrefixed = F3(
	function (prefix, maybeSegment, starter) {
		if (maybeSegment.$ === 'Nothing') {
			return starter;
		} else {
			var segment = maybeSegment.a;
			return _Utils_ap(
				starter,
				_Utils_ap(prefix, segment));
		}
	});
var elm$url$Url$toString = function (url) {
	var http = function () {
		var _n0 = url.protocol;
		if (_n0.$ === 'Http') {
			return 'http://';
		} else {
			return 'https://';
		}
	}();
	return A3(
		elm$url$Url$addPrefixed,
		'#',
		url.fragment,
		A3(
			elm$url$Url$addPrefixed,
			'?',
			url.query,
			_Utils_ap(
				A2(
					elm$url$Url$addPort,
					url.port_,
					_Utils_ap(http, url.host)),
				url.path)));
};
var author$project$WordApp$updatePage = F3(
	function (page, msg, model) {
		var _n0 = _Utils_Tuple2(page, msg);
		_n0$14:
		while (true) {
			switch (_n0.b.$) {
				case 'ChangedUrl':
					var url = _n0.b.a;
					return A2(
						author$project$WordApp$setRoute,
						author$project$Route$fromUrl(url),
						model);
				case 'ClickedLink':
					var urlRequest = _n0.b.a;
					if (urlRequest.$ === 'Internal') {
						var url = urlRequest.a;
						return _Utils_Tuple2(
							model,
							A2(
								elm$browser$Browser$Navigation$pushUrl,
								model.key,
								elm$url$Url$toString(url)));
					} else {
						var url = urlRequest.a;
						return _Utils_Tuple2(
							model,
							elm$browser$Browser$Navigation$load(url));
					}
				case 'SetRoute':
					var route = _n0.b.a;
					return A2(author$project$WordApp$setRoute, route, model);
				case 'LoginMsg':
					if (_n0.a.$ === 'Login') {
						var subModel = _n0.a.a;
						var subMsg = _n0.b.a;
						var _n2 = A3(author$project$Page$Login$update, subMsg, model.key, subModel);
						var _n3 = _n2.a;
						var pageModel = _n3.a;
						var pageMsg = _n3.b;
						var externalMsg = _n2.b;
						var newModel = function () {
							if (externalMsg.$ === 'NoOp') {
								return model;
							} else {
								var newSession = externalMsg.a;
								return _Utils_update(
									model,
									{session: newSession});
							}
						}();
						return _Utils_Tuple2(
							_Utils_update(
								newModel,
								{
									page: author$project$WordApp$Login(pageModel)
								}),
							A2(elm$core$Platform$Cmd$map, author$project$WordApp$LoginMsg, pageMsg));
					} else {
						break _n0$14;
					}
				case 'RegisterInit':
					if (_n0.a.$ === 'Register') {
						var subModel = _n0.a.a;
						var subMsg = _n0.b.a;
						var _n5 = A2(
							author$project$Page$Register$update,
							author$project$Page$Register$InitFinished(subMsg),
							subModel);
						var _n6 = _n5.a;
						var pageModel = _n6.a;
						var pageMsg = _n6.b;
						var externalMsg = _n5.b;
						return _Utils_Tuple2(
							_Utils_update(
								model,
								{
									page: author$project$WordApp$Register(pageModel)
								}),
							A2(elm$core$Platform$Cmd$map, author$project$WordApp$RegisterMsg, pageMsg));
					} else {
						break _n0$14;
					}
				case 'RegisterMsg':
					if (_n0.a.$ === 'Register') {
						var subModel = _n0.a.a;
						var subMsg = _n0.b.a;
						var _n7 = A2(author$project$Page$Register$update, subMsg, subModel);
						var _n8 = _n7.a;
						var pageModel = _n8.a;
						var pageMsg = _n8.b;
						var externalMsg = _n7.b;
						if (externalMsg.$ === 'NoOp') {
							return _Utils_Tuple2(
								_Utils_update(
									model,
									{
										page: author$project$WordApp$Register(pageModel)
									}),
								A2(elm$core$Platform$Cmd$map, author$project$WordApp$RegisterMsg, pageMsg));
						} else {
							return _Utils_Tuple2(
								_Utils_update(
									model,
									{
										page: author$project$WordApp$Login(author$project$Page$Login$initialModel)
									}),
								elm$core$Platform$Cmd$none);
						}
					} else {
						break _n0$14;
					}
				case 'ProfileEditMsg':
					if (_n0.a.$ === 'ProfileEdit') {
						var subModel = _n0.a.a;
						var subMsg = _n0.b.a;
						var _n10 = A4(author$project$Page$ProfileEdit$update, model.session, model.key, subMsg, subModel);
						var _n11 = _n10.a;
						var pageModel = _n11.a;
						var pageMsg = _n11.b;
						var externalMsg = _n10.b;
						switch (externalMsg.$) {
							case 'NoOp':
								return _Utils_Tuple2(
									_Utils_update(
										model,
										{
											page: author$project$WordApp$ProfileEdit(pageModel)
										}),
									A2(elm$core$Platform$Cmd$map, author$project$WordApp$ProfileEditMsg, pageMsg));
							case 'Logout':
								return _Utils_Tuple2(
									_Utils_update(
										model,
										{
											messages: A2(
												elm$core$List$cons,
												A2(author$project$Data$Message$Message, author$project$Data$Message$Warning, 'You got logged out'),
												model.messages),
											session: A2(author$project$Data$Session$Session, elm$core$Maybe$Nothing, elm$core$Maybe$Nothing)
										}),
									elm$core$Platform$Cmd$batch(
										_List_fromArray(
											[
												author$project$Data$Session$deleteSession,
												A2(elm$browser$Browser$Navigation$pushUrl, model.key, '/')
											])));
							default:
								var newSession = externalMsg.a;
								return _Utils_Tuple2(
									_Utils_update(
										model,
										{session: newSession}),
									A2(elm$core$Platform$Cmd$map, author$project$WordApp$ProfileEditMsg, pageMsg));
						}
					} else {
						break _n0$14;
					}
				case 'HomeInit':
					if (_n0.a.$ === 'Home') {
						var subModel = _n0.a.a;
						var subMsg = _n0.b.a;
						var _n13 = A3(
							author$project$Page$Home$update,
							model.session,
							author$project$Page$Home$InitFinished(subMsg),
							subModel);
						var _n14 = _n13.a;
						var pageModel = _n14.a;
						var pageMsg = _n14.b;
						var externalMsg = _n13.b;
						switch (externalMsg.$) {
							case 'NoOp':
								return _Utils_Tuple2(
									_Utils_update(
										model,
										{
											page: author$project$WordApp$Home(pageModel)
										}),
									A2(elm$core$Platform$Cmd$map, author$project$WordApp$HomeMsg, pageMsg));
							case 'Logout':
								return _Utils_Tuple2(
									_Utils_update(
										model,
										{
											messages: A2(
												elm$core$List$cons,
												A2(author$project$Data$Message$Message, author$project$Data$Message$Warning, 'You got logged out'),
												model.messages),
											session: A2(author$project$Data$Session$Session, elm$core$Maybe$Nothing, elm$core$Maybe$Nothing)
										}),
									elm$core$Platform$Cmd$batch(
										_List_fromArray(
											[
												author$project$Data$Session$deleteSession,
												A2(elm$browser$Browser$Navigation$pushUrl, model.key, '/')
											])));
							default:
								var _n16 = model.session.user;
								if (_n16.$ === 'Nothing') {
									return _Utils_Tuple2(
										_Utils_update(
											model,
											{
												page: author$project$WordApp$Home(pageModel)
											}),
										elm$core$Platform$Cmd$none);
								} else {
									var user = _n16.a;
									return _Utils_Tuple2(
										_Utils_update(
											model,
											{
												page: author$project$WordApp$Home(pageModel)
											}),
										A2(
											elm$core$Task$attempt,
											author$project$WordApp$HomeInit,
											author$project$Page$Home$init(
												function ($) {
													return $.session;
												}(model))));
								}
						}
					} else {
						break _n0$14;
					}
				case 'HomeMsg':
					if (_n0.a.$ === 'Home') {
						var subModel = _n0.a.a;
						var subMsg = _n0.b.a;
						var _n17 = A3(author$project$Page$Home$update, model.session, subMsg, subModel);
						var _n18 = _n17.a;
						var pageModel = _n18.a;
						var pageMsg = _n18.b;
						var externalMsg = _n17.b;
						switch (externalMsg.$) {
							case 'NoOp':
								return _Utils_Tuple2(
									_Utils_update(
										model,
										{
											page: author$project$WordApp$Home(pageModel)
										}),
									A2(elm$core$Platform$Cmd$map, author$project$WordApp$HomeMsg, pageMsg));
							case 'Logout':
								return _Utils_Tuple2(
									_Utils_update(
										model,
										{
											messages: A2(
												elm$core$List$cons,
												A2(author$project$Data$Message$Message, author$project$Data$Message$Warning, 'You got logged out'),
												model.messages),
											session: A2(author$project$Data$Session$Session, elm$core$Maybe$Nothing, elm$core$Maybe$Nothing)
										}),
									elm$core$Platform$Cmd$batch(
										_List_fromArray(
											[
												author$project$Data$Session$deleteSession,
												A2(elm$browser$Browser$Navigation$pushUrl, model.key, '/')
											])));
							default:
								var _n20 = model.session.user;
								if (_n20.$ === 'Nothing') {
									return _Utils_Tuple2(
										_Utils_update(
											model,
											{
												page: author$project$WordApp$Home(pageModel)
											}),
										elm$core$Platform$Cmd$none);
								} else {
									var user = _n20.a;
									return _Utils_Tuple2(
										_Utils_update(
											model,
											{
												page: author$project$WordApp$Home(pageModel)
											}),
										A2(
											elm$core$Task$attempt,
											author$project$WordApp$HomeInit,
											author$project$Page$Home$init(
												function ($) {
													return $.session;
												}(model))));
								}
						}
					} else {
						break _n0$14;
					}
				case 'WordEditInitMsg':
					if (_n0.a.$ === 'WordEdit') {
						var subModel = _n0.a.a;
						var subMsg = _n0.b.a;
						var _n21 = A3(
							author$project$Page$WordEdit$update,
							model.session,
							author$project$Page$WordEdit$WordEditInitFinished(subMsg),
							subModel);
						var _n22 = _n21.a;
						var pageModel = _n22.a;
						var pageMsg = _n22.b;
						var externalMsg = _n21.b;
						switch (externalMsg.$) {
							case 'NoOp':
								return _Utils_Tuple2(
									_Utils_update(
										model,
										{
											page: author$project$WordApp$WordEdit(pageModel)
										}),
									A2(elm$core$Platform$Cmd$map, author$project$WordApp$WordEditMsg, pageMsg));
							case 'Logout':
								return _Utils_Tuple2(
									_Utils_update(
										model,
										{
											messages: A2(
												elm$core$List$cons,
												A2(author$project$Data$Message$Message, author$project$Data$Message$Warning, 'You got logged out'),
												model.messages),
											session: A2(author$project$Data$Session$Session, elm$core$Maybe$Nothing, elm$core$Maybe$Nothing)
										}),
									elm$core$Platform$Cmd$batch(
										_List_fromArray(
											[
												author$project$Data$Session$deleteSession,
												A2(elm$browser$Browser$Navigation$pushUrl, model.key, '/')
											])));
							default:
								return _Utils_Tuple2(
									model,
									A2(
										elm$browser$Browser$Navigation$pushUrl,
										model.key,
										'/' + author$project$Route$routeToString(author$project$Route$Home)));
						}
					} else {
						break _n0$14;
					}
				case 'WordEditMsg':
					if (_n0.a.$ === 'WordEdit') {
						var subModel = _n0.a.a;
						var subMsg = _n0.b.a;
						var _n24 = A3(author$project$Page$WordEdit$update, model.session, subMsg, subModel);
						var _n25 = _n24.a;
						var pageModel = _n25.a;
						var pageMsg = _n25.b;
						var externalMsg = _n24.b;
						switch (externalMsg.$) {
							case 'NoOp':
								return _Utils_Tuple2(
									_Utils_update(
										model,
										{
											page: author$project$WordApp$WordEdit(pageModel)
										}),
									A2(elm$core$Platform$Cmd$map, author$project$WordApp$WordEditMsg, pageMsg));
							case 'Logout':
								return _Utils_Tuple2(
									_Utils_update(
										model,
										{
											messages: A2(
												elm$core$List$cons,
												A2(author$project$Data$Message$Message, author$project$Data$Message$Warning, 'You got logged out'),
												model.messages),
											session: A2(author$project$Data$Session$Session, elm$core$Maybe$Nothing, elm$core$Maybe$Nothing)
										}),
									elm$core$Platform$Cmd$batch(
										_List_fromArray(
											[
												author$project$Data$Session$deleteSession,
												A2(elm$browser$Browser$Navigation$pushUrl, model.key, '/')
											])));
							default:
								return _Utils_Tuple2(
									model,
									A2(
										elm$browser$Browser$Navigation$pushUrl,
										model.key,
										'/' + author$project$Route$routeToString(author$project$Route$Home)));
						}
					} else {
						break _n0$14;
					}
				case 'WordDeleteInitMsg':
					if (_n0.a.$ === 'WordDelete') {
						var subModel = _n0.a.a;
						var subMsg = _n0.b.a;
						var _n27 = A3(
							author$project$Page$WordDelete$update,
							model.session,
							author$project$Page$WordDelete$WordDeleteInitFinished(subMsg),
							subModel);
						var _n28 = _n27.a;
						var pageModel = _n28.a;
						var pageMsg = _n28.b;
						var externalMsg = _n27.b;
						switch (externalMsg.$) {
							case 'NoOp':
								return _Utils_Tuple2(
									_Utils_update(
										model,
										{
											page: author$project$WordApp$WordDelete(pageModel)
										}),
									A2(elm$core$Platform$Cmd$map, author$project$WordApp$WordDeleteMsg, pageMsg));
							case 'Logout':
								return _Utils_Tuple2(
									_Utils_update(
										model,
										{
											messages: A2(
												elm$core$List$cons,
												A2(author$project$Data$Message$Message, author$project$Data$Message$Warning, 'You got logged out'),
												model.messages),
											session: A2(author$project$Data$Session$Session, elm$core$Maybe$Nothing, elm$core$Maybe$Nothing)
										}),
									elm$core$Platform$Cmd$batch(
										_List_fromArray(
											[
												author$project$Data$Session$deleteSession,
												A2(elm$browser$Browser$Navigation$pushUrl, model.key, '/')
											])));
							default:
								return _Utils_Tuple2(
									model,
									A2(
										elm$browser$Browser$Navigation$pushUrl,
										model.key,
										'/' + author$project$Route$routeToString(author$project$Route$Home)));
						}
					} else {
						break _n0$14;
					}
				case 'QuizzInit':
					if (_n0.a.$ === 'Quizz') {
						var subModel = _n0.a.a;
						var subMsg = _n0.b.a;
						var _n30 = A3(
							author$project$Page$Quizz$update,
							model.session,
							author$project$Page$Quizz$QuizzInitFinished(subMsg),
							subModel);
						var _n31 = _n30.a;
						var pageModel = _n31.a;
						var pageMsg = _n31.b;
						var externalMsg = _n30.b;
						return _Utils_Tuple2(
							_Utils_update(
								model,
								{
									page: author$project$WordApp$Quizz(pageModel)
								}),
							A2(elm$core$Platform$Cmd$map, author$project$WordApp$QuizzMsg, pageMsg));
					} else {
						break _n0$14;
					}
				case 'QuizzMsg':
					if (_n0.a.$ === 'Quizz') {
						var subModel = _n0.a.a;
						var subMsg = _n0.b.a;
						var _n32 = A3(author$project$Page$Quizz$update, model.session, subMsg, subModel);
						var _n33 = _n32.a;
						var pageModel = _n33.a;
						var pageMsg = _n33.b;
						var externalMsg = _n32.b;
						return _Utils_Tuple2(
							_Utils_update(
								model,
								{
									page: author$project$WordApp$Quizz(pageModel)
								}),
							A2(elm$core$Platform$Cmd$map, author$project$WordApp$QuizzMsg, pageMsg));
					} else {
						break _n0$14;
					}
				default:
					break _n0$14;
			}
		}
		return _Utils_Tuple2(model, elm$core$Platform$Cmd$none);
	});
var elm$core$Debug$log = _Debug_log;
var author$project$WordApp$update = F2(
	function (msg, model) {
		return A3(
			author$project$WordApp$updatePage,
			function ($) {
				return $.page;
			}(model),
			A2(elm$core$Debug$log, 'msg: ', msg),
			model);
	});
var author$project$Page$Home$HomeAddNewWord = {$: 'HomeAddNewWord'};
var author$project$Page$Home$HomeSearchWord = {$: 'HomeSearchWord'};
var author$project$Page$Home$TypeHomeDefinition = function (a) {
	return {$: 'TypeHomeDefinition', a: a};
};
var author$project$Page$Home$TypeHomeLanguage = function (a) {
	return {$: 'TypeHomeLanguage', a: a};
};
var author$project$Page$Home$TypeHomeWord = function (a) {
	return {$: 'TypeHomeWord', a: a};
};
var author$project$Page$Home$UpdateSearchKeyword = function (a) {
	return {$: 'UpdateSearchKeyword', a: a};
};
var author$project$Page$Home$UpdateSearchWord = function (a) {
	return {$: 'UpdateSearchWord', a: a};
};
var elm$html$Html$Attributes$stringProperty = F2(
	function (key, string) {
		return A2(
			_VirtualDom_property,
			key,
			elm$json$Json$Encode$string(string));
	});
var elm$html$Html$Attributes$href = function (url) {
	return A2(
		elm$html$Html$Attributes$stringProperty,
		'href',
		_VirtualDom_noJavaScriptUri(url));
};
var author$project$Route$href = function (argRoute) {
	return elm$html$Html$Attributes$href(
		'/' + author$project$Route$routeToString(argRoute));
};
var elm$html$Html$button = _VirtualDom_node('button');
var elm$html$Html$form = _VirtualDom_node('form');
var elm$html$Html$input = _VirtualDom_node('input');
var elm$html$Html$label = _VirtualDom_node('label');
var elm$html$Html$option = _VirtualDom_node('option');
var elm$html$Html$select = _VirtualDom_node('select');
var elm$virtual_dom$VirtualDom$text = _VirtualDom_text;
var elm$html$Html$text = elm$virtual_dom$VirtualDom$text;
var elm$html$Html$Attributes$action = function (uri) {
	return A2(
		elm$html$Html$Attributes$stringProperty,
		'action',
		_VirtualDom_noJavaScriptUri(uri));
};
var elm$html$Html$Attributes$for = elm$html$Html$Attributes$stringProperty('htmlFor');
var elm$html$Html$Attributes$name = elm$html$Html$Attributes$stringProperty('name');
var elm$html$Html$Attributes$placeholder = elm$html$Html$Attributes$stringProperty('placeholder');
var elm$html$Html$Attributes$type_ = elm$html$Html$Attributes$stringProperty('type');
var elm$html$Html$Events$alwaysStop = function (x) {
	return _Utils_Tuple2(x, true);
};
var elm$virtual_dom$VirtualDom$MayStopPropagation = function (a) {
	return {$: 'MayStopPropagation', a: a};
};
var elm$virtual_dom$VirtualDom$on = _VirtualDom_on;
var elm$html$Html$Events$stopPropagationOn = F2(
	function (event, decoder) {
		return A2(
			elm$virtual_dom$VirtualDom$on,
			event,
			elm$virtual_dom$VirtualDom$MayStopPropagation(decoder));
	});
var elm$json$Json$Decode$at = F2(
	function (fields, decoder) {
		return A3(elm$core$List$foldr, elm$json$Json$Decode$field, decoder, fields);
	});
var elm$html$Html$Events$targetValue = A2(
	elm$json$Json$Decode$at,
	_List_fromArray(
		['target', 'value']),
	elm$json$Json$Decode$string);
var elm$html$Html$Events$onInput = function (tagger) {
	return A2(
		elm$html$Html$Events$stopPropagationOn,
		'input',
		A2(
			elm$json$Json$Decode$map,
			elm$html$Html$Events$alwaysStop,
			A2(elm$json$Json$Decode$map, tagger, elm$html$Html$Events$targetValue)));
};
var elm$html$Html$Events$alwaysPreventDefault = function (msg) {
	return _Utils_Tuple2(msg, true);
};
var elm$virtual_dom$VirtualDom$MayPreventDefault = function (a) {
	return {$: 'MayPreventDefault', a: a};
};
var elm$html$Html$Events$preventDefaultOn = F2(
	function (event, decoder) {
		return A2(
			elm$virtual_dom$VirtualDom$on,
			event,
			elm$virtual_dom$VirtualDom$MayPreventDefault(decoder));
	});
var elm$html$Html$Events$onSubmit = function (msg) {
	return A2(
		elm$html$Html$Events$preventDefaultOn,
		'submit',
		A2(
			elm$json$Json$Decode$map,
			elm$html$Html$Events$alwaysPreventDefault,
			elm$json$Json$Decode$succeed(msg)));
};
var author$project$Views$Forms$viewFormAddWord = F5(
	function (possibleLanguages, homeAddNewWord, typeHomeLanguage, typeHomeWord, typeHomeDefinition) {
		return A2(
			elm$html$Html$form,
			_List_fromArray(
				[
					elm$html$Html$Events$onSubmit(homeAddNewWord),
					elm$html$Html$Attributes$action('javascript:void(0);')
				]),
			_List_fromArray(
				[
					A2(
					elm$html$Html$label,
					_List_fromArray(
						[
							elm$html$Html$Attributes$for('language')
						]),
					_List_fromArray(
						[
							elm$html$Html$text('Language')
						])),
					A2(
					elm$html$Html$select,
					_List_fromArray(
						[
							elm$html$Html$Events$onInput(typeHomeLanguage),
							elm$html$Html$Attributes$name('language')
						]),
					A2(
						elm$core$List$map,
						function (l) {
							return A2(
								elm$html$Html$option,
								_List_Nil,
								_List_fromArray(
									[
										elm$html$Html$text(l)
									]));
						},
						possibleLanguages)),
					A2(
					elm$html$Html$label,
					_List_fromArray(
						[
							elm$html$Html$Attributes$for('word')
						]),
					_List_fromArray(
						[
							elm$html$Html$text('Word')
						])),
					A2(
					elm$html$Html$input,
					_List_fromArray(
						[
							elm$html$Html$Events$onInput(typeHomeWord),
							elm$html$Html$Attributes$placeholder('word')
						]),
					_List_Nil),
					A2(
					elm$html$Html$label,
					_List_fromArray(
						[
							elm$html$Html$Attributes$for('definition')
						]),
					_List_fromArray(
						[
							elm$html$Html$text('Definition')
						])),
					A2(
					elm$html$Html$input,
					_List_fromArray(
						[
							elm$html$Html$Events$onInput(typeHomeDefinition),
							elm$html$Html$Attributes$placeholder('definition')
						]),
					_List_Nil),
					A2(
					elm$html$Html$button,
					_List_fromArray(
						[
							elm$html$Html$Attributes$type_('submit')
						]),
					_List_fromArray(
						[
							elm$html$Html$text('add word')
						]))
				]));
	});
var author$project$Views$Forms$viewFormSearchWord = F4(
	function (keywords, toSearchMsg, toUpdateSearchWord, toUpdateSearchKeyword) {
		return A2(
			elm$html$Html$form,
			_List_fromArray(
				[
					elm$html$Html$Events$onSubmit(toSearchMsg),
					elm$html$Html$Attributes$action('javascript:void(0);')
				]),
			_List_fromArray(
				[
					A2(
					elm$html$Html$label,
					_List_fromArray(
						[
							elm$html$Html$Attributes$for('original word')
						]),
					_List_fromArray(
						[
							elm$html$Html$text('Word')
						])),
					A2(
					elm$html$Html$input,
					_List_fromArray(
						[
							elm$html$Html$Events$onInput(toUpdateSearchWord),
							elm$html$Html$Attributes$placeholder('original word')
						]),
					_List_Nil),
					A2(
					elm$html$Html$label,
					_List_fromArray(
						[
							elm$html$Html$Attributes$for('keyword')
						]),
					_List_fromArray(
						[
							elm$html$Html$text('Keyword')
						])),
					A2(
					elm$html$Html$select,
					_List_fromArray(
						[
							elm$html$Html$Events$onInput(toUpdateSearchKeyword),
							elm$html$Html$Attributes$name('keyword')
						]),
					elm$core$List$concat(
						_List_fromArray(
							[
								_List_fromArray(
								[
									A2(
									elm$html$Html$option,
									_List_Nil,
									_List_fromArray(
										[
											elm$html$Html$text('--')
										]))
								]),
								A2(
								elm$core$List$map,
								function (k) {
									return A2(
										elm$html$Html$option,
										_List_Nil,
										_List_fromArray(
											[
												elm$html$Html$text(k)
											]));
								},
								keywords)
							]))),
					A2(
					elm$html$Html$button,
					_List_fromArray(
						[
							elm$html$Html$Attributes$type_('submit')
						]),
					_List_fromArray(
						[
							elm$html$Html$text('update search word')
						]))
				]));
	});
var elm$core$String$toLower = _String_toLower;
var elm$html$Html$a = _VirtualDom_node('a');
var elm$html$Html$div = _VirtualDom_node('div');
var elm$html$Html$h1 = _VirtualDom_node('h1');
var elm$html$Html$p = _VirtualDom_node('p');
var elm$html$Html$span = _VirtualDom_node('span');
var elm$html$Html$Attributes$class = elm$html$Html$Attributes$stringProperty('className');
var elm$html$Html$Attributes$rel = _VirtualDom_attribute('rel');
var elm$html$Html$Attributes$target = elm$html$Html$Attributes$stringProperty('target');
var elm$url$Url$percentEncode = _Url_percentEncode;
var author$project$Views$Words$viewWordCard = function (word) {
	var dicUrl = 'https://' + (elm$core$String$toLower(word.language) + ('.wiktionary.org/wiki/Special:Search?search=' + elm$url$Url$percentEncode(word.word)));
	return A2(
		elm$html$Html$div,
		_List_fromArray(
			[
				elm$html$Html$Attributes$class('word-container')
			]),
		_List_fromArray(
			[
				elm$html$Html$text(' '),
				A2(
				elm$html$Html$div,
				_List_fromArray(
					[
						elm$html$Html$Attributes$class('word-container-header')
					]),
				_List_fromArray(
					[
						A2(
						elm$html$Html$h1,
						_List_Nil,
						_List_fromArray(
							[
								elm$html$Html$text(
								function ($) {
									return $.word;
								}(word))
							])),
						A2(
						elm$html$Html$div,
						_List_fromArray(
							[
								elm$html$Html$Attributes$class('word-container-header-icons')
							]),
						_List_fromArray(
							[
								A2(
								elm$html$Html$a,
								_List_fromArray(
									[
										author$project$Route$href(
										author$project$Route$WordDelete(
											function ($) {
												return $.id;
											}(word)))
									]),
								_List_fromArray(
									[
										A2(
										elm$html$Html$span,
										_List_fromArray(
											[
												elm$html$Html$Attributes$class('icon-trash-empty')
											]),
										_List_Nil)
									])),
								A2(
								elm$html$Html$a,
								_List_fromArray(
									[
										author$project$Route$href(
										author$project$Route$WordEdit(
											function ($) {
												return $.id;
											}(word)))
									]),
								_List_fromArray(
									[
										A2(
										elm$html$Html$span,
										_List_fromArray(
											[
												elm$html$Html$Attributes$class('icon-pencil')
											]),
										_List_Nil)
									])),
								A2(
								elm$html$Html$a,
								_List_fromArray(
									[
										elm$html$Html$Attributes$href(dicUrl),
										elm$html$Html$Attributes$target('_blank'),
										elm$html$Html$Attributes$rel('noopener noreferrer')
									]),
								_List_fromArray(
									[
										A2(
										elm$html$Html$span,
										_List_fromArray(
											[
												elm$html$Html$Attributes$class('icon-search')
											]),
										_List_Nil),
										A2(
										elm$html$Html$span,
										_List_Nil,
										_List_fromArray(
											[
												elm$html$Html$text(
												function ($) {
													return $.language;
												}(word))
											]))
									]))
							]))
					])),
				A2(
				elm$html$Html$div,
				_List_fromArray(
					[
						elm$html$Html$Attributes$class('word-container-body')
					]),
				_List_fromArray(
					[
						A2(
						elm$html$Html$p,
						_List_Nil,
						_List_fromArray(
							[
								elm$html$Html$text(
								function ($) {
									return $.definition;
								}(word))
							]))
					]))
			]));
};
var elm$core$List$intersperse = F2(
	function (sep, xs) {
		if (!xs.b) {
			return _List_Nil;
		} else {
			var hd = xs.a;
			var tl = xs.b;
			var step = F2(
				function (x, rest) {
					return A2(
						elm$core$List$cons,
						sep,
						A2(elm$core$List$cons, x, rest));
				});
			var spersed = A3(elm$core$List$foldr, step, _List_Nil, tl);
			return A2(elm$core$List$cons, hd, spersed);
		}
	});
var author$project$Views$Words$viewWordsCards = function (words) {
	return A2(
		elm$core$List$intersperse,
		elm$html$Html$text(' '),
		A2(elm$core$List$map, author$project$Views$Words$viewWordCard, words));
};
var elm$core$String$concat = function (strings) {
	return A2(elm$core$String$join, '', strings);
};
var elm$html$Html$td = _VirtualDom_node('td');
var elm$html$Html$tr = _VirtualDom_node('tr');
var author$project$Views$Words$viewWordTr = function (word) {
	return A2(
		elm$html$Html$tr,
		_List_Nil,
		_List_fromArray(
			[
				A2(
				elm$html$Html$td,
				_List_Nil,
				_List_fromArray(
					[
						elm$html$Html$text(
						function ($) {
							return $.language;
						}(word))
					])),
				A2(
				elm$html$Html$td,
				_List_Nil,
				_List_fromArray(
					[
						elm$html$Html$text(
						function ($) {
							return $.word;
						}(word))
					])),
				A2(
				elm$html$Html$td,
				_List_Nil,
				_List_fromArray(
					[
						elm$html$Html$text(
						function ($) {
							return $.definition;
						}(word))
					])),
				A2(
				elm$html$Html$td,
				_List_Nil,
				_List_fromArray(
					[
						elm$html$Html$text(
						elm$core$String$concat(
							A2(
								elm$core$List$intersperse,
								', ',
								function ($) {
									return $.keywords;
								}(word))))
					])),
				A2(
				elm$html$Html$td,
				_List_Nil,
				_List_fromArray(
					[
						A2(
						elm$html$Html$a,
						_List_fromArray(
							[
								author$project$Route$href(
								author$project$Route$WordEdit(
									function ($) {
										return $.id;
									}(word)))
							]),
						_List_fromArray(
							[
								A2(
								elm$html$Html$span,
								_List_fromArray(
									[
										elm$html$Html$Attributes$class('icon-pencil')
									]),
								_List_Nil)
							])),
						A2(
						elm$html$Html$a,
						_List_fromArray(
							[
								author$project$Route$href(
								author$project$Route$WordDelete(
									function ($) {
										return $.id;
									}(word)))
							]),
						_List_fromArray(
							[
								A2(
								elm$html$Html$span,
								_List_fromArray(
									[
										elm$html$Html$Attributes$class('icon-trash-empty')
									]),
								_List_Nil)
							]))
					]))
			]));
};
var elm$html$Html$table = _VirtualDom_node('table');
var elm$html$Html$tbody = _VirtualDom_node('tbody');
var elm$html$Html$th = _VirtualDom_node('th');
var elm$html$Html$thead = _VirtualDom_node('thead');
var author$project$Views$Words$viewWordsTable = function (words) {
	return A2(
		elm$html$Html$table,
		_List_Nil,
		_List_fromArray(
			[
				A2(
				elm$html$Html$thead,
				_List_Nil,
				_List_fromArray(
					[
						A2(
						elm$html$Html$tr,
						_List_Nil,
						_List_fromArray(
							[
								A2(
								elm$html$Html$th,
								_List_Nil,
								_List_fromArray(
									[
										elm$html$Html$text('language')
									])),
								A2(
								elm$html$Html$th,
								_List_Nil,
								_List_fromArray(
									[
										elm$html$Html$text('original')
									])),
								A2(
								elm$html$Html$th,
								_List_Nil,
								_List_fromArray(
									[
										elm$html$Html$text('my translation')
									])),
								A2(
								elm$html$Html$th,
								_List_Nil,
								_List_fromArray(
									[
										elm$html$Html$text('keywords')
									])),
								A2(
								elm$html$Html$th,
								_List_Nil,
								_List_fromArray(
									[
										elm$html$Html$text('edit')
									]))
							]))
					])),
				A2(
				elm$html$Html$tbody,
				_List_Nil,
				A2(elm$core$List$map, author$project$Views$Words$viewWordTr, words))
			]));
};
var author$project$Page$Home$view = F2(
	function (model, session) {
		var myLangs = function () {
			var _n0 = session.user;
			if (_n0.$ === 'Just') {
				var user = _n0.a;
				return user.languages;
			} else {
				return _List_fromArray(
					['EN', 'FR']);
			}
		}();
		return A2(
			elm$html$Html$div,
			_List_Nil,
			_List_fromArray(
				[
					A2(
					elm$html$Html$div,
					_List_Nil,
					_List_fromArray(
						[
							A2(
							elm$html$Html$h1,
							_List_Nil,
							_List_fromArray(
								[
									elm$html$Html$text('You want to add a word?')
								])),
							A2(
							elm$html$Html$div,
							_List_fromArray(
								[
									elm$html$Html$Attributes$class('form-div')
								]),
							_List_fromArray(
								[
									A5(author$project$Views$Forms$viewFormAddWord, myLangs, author$project$Page$Home$HomeAddNewWord, author$project$Page$Home$TypeHomeLanguage, author$project$Page$Home$TypeHomeWord, author$project$Page$Home$TypeHomeDefinition)
								]))
						])),
					A2(
					elm$html$Html$div,
					_List_Nil,
					_List_fromArray(
						[
							A2(
							elm$html$Html$h1,
							_List_Nil,
							_List_fromArray(
								[
									elm$html$Html$text('Take a quizz')
								])),
							A2(
							elm$html$Html$div,
							_List_fromArray(
								[
									elm$html$Html$Attributes$class('quizz-container-links')
								]),
							A2(
								elm$core$List$map,
								function (l) {
									return A2(
										elm$html$Html$a,
										_List_fromArray(
											[
												author$project$Route$href(
												author$project$Route$Quizz(l))
											]),
										_List_fromArray(
											[
												elm$html$Html$text(l)
											]));
								},
								myLangs))
						])),
					A2(
					elm$html$Html$div,
					_List_Nil,
					_List_fromArray(
						[
							A2(
							elm$html$Html$h1,
							_List_Nil,
							_List_fromArray(
								[
									elm$html$Html$text('Search a particular word in your dict?')
								])),
							A2(
							elm$html$Html$div,
							_List_fromArray(
								[
									elm$html$Html$Attributes$class('form-div')
								]),
							_List_fromArray(
								[
									A4(
									author$project$Views$Forms$viewFormSearchWord,
									function ($) {
										return $.keywords;
									}(model),
									author$project$Page$Home$HomeSearchWord,
									author$project$Page$Home$UpdateSearchWord,
									author$project$Page$Home$UpdateSearchKeyword)
								])),
							author$project$Views$Words$viewWordsTable(model.searchWords)
						])),
					A2(
					elm$html$Html$div,
					_List_Nil,
					_List_fromArray(
						[
							A2(
							elm$html$Html$h1,
							_List_Nil,
							_List_fromArray(
								[
									elm$html$Html$text('Your last words of the week:')
								])),
							A2(
							elm$html$Html$div,
							_List_fromArray(
								[
									elm$html$Html$Attributes$class('container-cards')
								]),
							author$project$Views$Words$viewWordsCards(model.myLastWords))
						]))
				]));
	});
var author$project$Page$Login$LoginTryMsg = {$: 'LoginTryMsg'};
var author$project$Page$Login$TypeLoginMsg = function (a) {
	return {$: 'TypeLoginMsg', a: a};
};
var author$project$Page$Login$TypePasswordMsg = function (a) {
	return {$: 'TypePasswordMsg', a: a};
};
var elm$virtual_dom$VirtualDom$attribute = F2(
	function (key, value) {
		return A2(
			_VirtualDom_attribute,
			_VirtualDom_noOnOrFormAction(key),
			_VirtualDom_noJavaScriptOrHtmlUri(value));
	});
var elm$html$Html$Attributes$attribute = elm$virtual_dom$VirtualDom$attribute;
var author$project$Views$Forms$viewFormLogin = F3(
	function (loginTryMsg, typeLoginMsg, typePasswordMsg) {
		return A2(
			elm$html$Html$form,
			_List_fromArray(
				[
					elm$html$Html$Events$onSubmit(loginTryMsg),
					elm$html$Html$Attributes$action('javascript:void(0);')
				]),
			_List_fromArray(
				[
					A2(
					elm$html$Html$label,
					_List_fromArray(
						[
							elm$html$Html$Attributes$for('username')
						]),
					_List_fromArray(
						[
							elm$html$Html$text('Username')
						])),
					A2(
					elm$html$Html$input,
					_List_fromArray(
						[
							elm$html$Html$Events$onInput(typeLoginMsg),
							elm$html$Html$Attributes$placeholder('username'),
							A2(elm$html$Html$Attributes$attribute, 'type', 'text')
						]),
					_List_Nil),
					A2(
					elm$html$Html$label,
					_List_fromArray(
						[
							elm$html$Html$Attributes$for('password')
						]),
					_List_fromArray(
						[
							elm$html$Html$text('Password')
						])),
					A2(
					elm$html$Html$input,
					_List_fromArray(
						[
							elm$html$Html$Events$onInput(typePasswordMsg),
							elm$html$Html$Attributes$placeholder('password'),
							A2(elm$html$Html$Attributes$attribute, 'type', 'password')
						]),
					_List_Nil),
					A2(
					elm$html$Html$button,
					_List_fromArray(
						[
							elm$html$Html$Attributes$type_('submit')
						]),
					_List_fromArray(
						[
							elm$html$Html$text('log-in')
						]))
				]));
	});
var author$project$Page$Login$view = function (model) {
	return A2(
		elm$html$Html$div,
		_List_fromArray(
			[
				elm$html$Html$Attributes$class('form-div')
			]),
		_List_fromArray(
			[
				A2(
				elm$html$Html$h1,
				_List_Nil,
				_List_fromArray(
					[
						elm$html$Html$text('Login'),
						A2(
						elm$html$Html$span,
						_List_Nil,
						_List_fromArray(
							[
								A2(
								elm$html$Html$a,
								_List_fromArray(
									[
										author$project$Route$href(author$project$Route$Register)
									]),
								_List_fromArray(
									[
										elm$html$Html$text('or register')
									]))
							]))
					])),
				A3(author$project$Views$Forms$viewFormLogin, author$project$Page$Login$LoginTryMsg, author$project$Page$Login$TypeLoginMsg, author$project$Page$Login$TypePasswordMsg)
			]));
};
var author$project$Page$NotFound$view = A2(
	elm$html$Html$div,
	_List_Nil,
	_List_fromArray(
		[
			A2(
			elm$html$Html$p,
			_List_Nil,
			_List_fromArray(
				[
					elm$html$Html$text('not found')
				]))
		]));
var author$project$Page$ProfileEdit$IncreaseNbLanguage = {$: 'IncreaseNbLanguage'};
var author$project$Page$ProfileEdit$RemoveLanguage = function (a) {
	return {$: 'RemoveLanguage', a: a};
};
var author$project$Page$ProfileEdit$ToUpdateUser = {$: 'ToUpdateUser'};
var author$project$Page$ProfileEdit$UpdatePassword = function (a) {
	return {$: 'UpdatePassword', a: a};
};
var author$project$Page$ProfileEdit$UpdateUser = function (a) {
	return {$: 'UpdateUser', a: a};
};
var author$project$Views$Forms$updateNiemeListElement = F3(
	function (nieme, newElem, l) {
		return A2(
			elm$core$List$append,
			A2(
				elm$core$List$append,
				A2(elm$core$List$take, nieme - 1, l),
				_List_fromArray(
					[newElem])),
			A2(elm$core$List$drop, nieme, l));
	});
var elm$html$Html$Attributes$value = elm$html$Html$Attributes$stringProperty('value');
var elm$virtual_dom$VirtualDom$Normal = function (a) {
	return {$: 'Normal', a: a};
};
var elm$html$Html$Events$on = F2(
	function (event, decoder) {
		return A2(
			elm$virtual_dom$VirtualDom$on,
			event,
			elm$virtual_dom$VirtualDom$Normal(decoder));
	});
var elm$html$Html$Events$onClick = function (msg) {
	return A2(
		elm$html$Html$Events$on,
		'click',
		elm$json$Json$Decode$succeed(msg));
};
var author$project$Views$Forms$viewLanguageUserInput = F5(
	function (user, toIncreaseNbLanguage, toUpdateUser, toRemoveLanguage, indexInput) {
		var language = function () {
			var _n0 = elm$core$List$head(
				A2(elm$core$List$drop, indexInput, user.languages));
			if (_n0.$ === 'Just') {
				var responseLanguage = _n0.a;
				return responseLanguage;
			} else {
				return '';
			}
		}();
		return A2(
			elm$html$Html$div,
			_List_fromArray(
				[
					elm$html$Html$Attributes$class('group-form')
				]),
			_List_fromArray(
				[
					A2(
					elm$html$Html$label,
					_List_fromArray(
						[
							elm$html$Html$Attributes$for(
							'language' + elm$core$String$fromInt(indexInput))
						]),
					_List_fromArray(
						[
							elm$html$Html$text('Language')
						])),
					A2(
					elm$html$Html$input,
					_List_fromArray(
						[
							elm$html$Html$Events$onInput(
							function (v) {
								return toUpdateUser(
									_Utils_update(
										user,
										{
											languages: A3(author$project$Views$Forms$updateNiemeListElement, indexInput + 1, v, user.languages)
										}));
							}),
							elm$html$Html$Attributes$placeholder('languages to learn (2chars)'),
							elm$html$Html$Attributes$value(language)
						]),
					_List_Nil),
					A2(
					elm$html$Html$button,
					_List_fromArray(
						[
							elm$html$Html$Events$onClick(toIncreaseNbLanguage),
							elm$html$Html$Attributes$type_('button'),
							elm$html$Html$Attributes$class('button-add')
						]),
					_List_fromArray(
						[
							A2(
							elm$html$Html$span,
							_List_fromArray(
								[
									elm$html$Html$Attributes$class('icon-plus')
								]),
							_List_Nil)
						])),
					A2(
					elm$html$Html$button,
					_List_fromArray(
						[
							elm$html$Html$Events$onClick(
							toRemoveLanguage(indexInput)),
							elm$html$Html$Attributes$type_('button'),
							elm$html$Html$Attributes$class('button-minus')
						]),
					_List_fromArray(
						[
							A2(
							elm$html$Html$span,
							_List_fromArray(
								[
									elm$html$Html$Attributes$class('icon-minus')
								]),
							_List_Nil)
						]))
				]));
	});
var elm$core$List$repeatHelp = F3(
	function (result, n, value) {
		repeatHelp:
		while (true) {
			if (n <= 0) {
				return result;
			} else {
				var $temp$result = A2(elm$core$List$cons, value, result),
					$temp$n = n - 1,
					$temp$value = value;
				result = $temp$result;
				n = $temp$n;
				value = $temp$value;
				continue repeatHelp;
			}
		}
	});
var elm$core$List$repeat = F2(
	function (n, value) {
		return A3(elm$core$List$repeatHelp, _List_Nil, n, value);
	});
var author$project$Views$Forms$viewLanguageUserInputs = F5(
	function (numberOfInput, toIncreaseNbLanguage, toRemoveLanguage, user, toUpdateUser) {
		var createLanguageInput = F2(
			function (indexInput, _n0) {
				return A5(author$project$Views$Forms$viewLanguageUserInput, user, toIncreaseNbLanguage, toUpdateUser, toRemoveLanguage, indexInput);
			});
		return A2(
			elm$core$List$indexedMap,
			createLanguageInput,
			A2(elm$core$List$repeat, numberOfInput, _Utils_Tuple0));
	});
var author$project$Views$Forms$viewFormUpdateUser = F7(
	function (user, nbLanguage, toIncreaseNbLanguage, toRemoveLanguage, toUpdateNewUser, toUpdateMsg, toUpdatePassword) {
		return A2(
			elm$html$Html$form,
			_List_fromArray(
				[
					elm$html$Html$Events$onSubmit(toUpdateMsg),
					elm$html$Html$Attributes$action('javascript:void(0);')
				]),
			_Utils_ap(
				_List_fromArray(
					[
						A2(
						elm$html$Html$label,
						_List_fromArray(
							[
								elm$html$Html$Attributes$for('password')
							]),
						_List_fromArray(
							[
								elm$html$Html$text('Language')
							])),
						A2(
						elm$html$Html$input,
						_List_fromArray(
							[
								elm$html$Html$Events$onInput(toUpdatePassword),
								elm$html$Html$Attributes$placeholder('new password'),
								A2(elm$html$Html$Attributes$attribute, 'type', 'password')
							]),
						_List_Nil),
						A2(
						elm$html$Html$label,
						_List_fromArray(
							[
								elm$html$Html$Attributes$for('email')
							]),
						_List_fromArray(
							[
								elm$html$Html$text('Email')
							])),
						A2(
						elm$html$Html$input,
						_List_fromArray(
							[
								elm$html$Html$Events$onInput(
								function (v) {
									return toUpdateNewUser(
										_Utils_update(
											user,
											{
												email: elm$core$Maybe$Just(v)
											}));
								}),
								elm$html$Html$Attributes$placeholder('new email'),
								elm$html$Html$Attributes$value(
								A2(elm$core$Maybe$withDefault, '', user.email))
							]),
						_List_Nil)
					]),
				_Utils_ap(
					A5(author$project$Views$Forms$viewLanguageUserInputs, nbLanguage, toIncreaseNbLanguage, toRemoveLanguage, user, toUpdateNewUser),
					_List_fromArray(
						[
							A2(
							elm$html$Html$button,
							_List_fromArray(
								[
									elm$html$Html$Attributes$type_('submit')
								]),
							_List_fromArray(
								[
									elm$html$Html$text('Update my profile')
								]))
						]))));
	});
var author$project$Page$ProfileEdit$view = function (model) {
	return A2(
		elm$html$Html$div,
		_List_fromArray(
			[
				elm$html$Html$Attributes$class('form-div')
			]),
		_List_fromArray(
			[
				A2(
				elm$html$Html$h1,
				_List_Nil,
				_List_fromArray(
					[
						elm$html$Html$text('My profile information')
					])),
				A7(author$project$Views$Forms$viewFormUpdateUser, model.user, model.nbLanguage, author$project$Page$ProfileEdit$IncreaseNbLanguage, author$project$Page$ProfileEdit$RemoveLanguage, author$project$Page$ProfileEdit$UpdateUser, author$project$Page$ProfileEdit$ToUpdateUser, author$project$Page$ProfileEdit$UpdatePassword)
			]));
};
var author$project$Page$Quizz$TakeQuizz = {$: 'TakeQuizz'};
var author$project$Page$Quizz$TakeQuizzAttempt = {$: 'TakeQuizzAttempt'};
var author$project$Page$Quizz$TakeQuizzUpdateResponse = function (a) {
	return {$: 'TakeQuizzUpdateResponse', a: a};
};
var author$project$Page$Quizz$boolToColor = function (boo) {
	if (boo) {
		return 'green';
	} else {
		return 'red';
	}
};
var author$project$Views$Words$viewWordCardForm = F3(
	function (word, toUpdateWord, toTakeQuizz) {
		return A2(
			elm$html$Html$div,
			_List_fromArray(
				[
					elm$html$Html$Attributes$class('word-container')
				]),
			_List_fromArray(
				[
					elm$html$Html$text(' '),
					A2(
					elm$html$Html$div,
					_List_fromArray(
						[
							elm$html$Html$Attributes$class('word-container-header')
						]),
					_List_fromArray(
						[
							A2(
							elm$html$Html$h1,
							_List_Nil,
							_List_fromArray(
								[
									elm$html$Html$text(
									function ($) {
										return $.word;
									}(word))
								])),
							A2(
							elm$html$Html$div,
							_List_fromArray(
								[
									elm$html$Html$Attributes$class('word-container-header-icons')
								]),
							_List_fromArray(
								[
									A2(
									elm$html$Html$a,
									_List_fromArray(
										[
											author$project$Route$href(
											author$project$Route$WordDelete(
												function ($) {
													return $.id;
												}(word)))
										]),
									_List_fromArray(
										[
											A2(
											elm$html$Html$span,
											_List_fromArray(
												[
													elm$html$Html$Attributes$class('icon-trash-empty')
												]),
											_List_Nil)
										])),
									A2(
									elm$html$Html$a,
									_List_fromArray(
										[
											author$project$Route$href(
											author$project$Route$WordEdit(
												function ($) {
													return $.id;
												}(word)))
										]),
									_List_fromArray(
										[
											A2(
											elm$html$Html$span,
											_List_fromArray(
												[
													elm$html$Html$Attributes$class('icon-pencil')
												]),
											_List_Nil)
										])),
									A2(
									elm$html$Html$span,
									_List_Nil,
									_List_fromArray(
										[
											elm$html$Html$text(
											function ($) {
												return $.language;
											}(word))
										]))
								]))
						])),
					A2(
					elm$html$Html$div,
					_List_fromArray(
						[
							elm$html$Html$Attributes$class('word-container-body')
						]),
					_List_fromArray(
						[
							A2(
							elm$html$Html$form,
							_List_fromArray(
								[
									elm$html$Html$Events$onSubmit(toTakeQuizz),
									elm$html$Html$Attributes$action('javascript:void(0);')
								]),
							_List_fromArray(
								[
									A2(
									elm$html$Html$input,
									_List_fromArray(
										[
											elm$html$Html$Events$onInput(toUpdateWord),
											elm$html$Html$Attributes$placeholder('response')
										]),
									_List_Nil)
								]))
						]))
				]));
	});
var elm$html$Html$h2 = _VirtualDom_node('h2');
var elm$virtual_dom$VirtualDom$style = _VirtualDom_style;
var elm$html$Html$Attributes$style = elm$virtual_dom$VirtualDom$style;
var author$project$Page$Quizz$view = function (model) {
	var _n0 = model.word;
	if (_n0.$ === 'Just') {
		var _n1 = _n0.a;
		var quizzWord = _n1.a;
		var maybeVerified = _n1.b;
		var color = A2(
			elm$core$Maybe$withDefault,
			'black',
			A2(elm$core$Maybe$map, author$project$Page$Quizz$boolToColor, maybeVerified));
		if (maybeVerified.$ === 'Just') {
			return A2(
				elm$html$Html$div,
				_List_Nil,
				_List_fromArray(
					[
						A2(
						elm$html$Html$div,
						_List_fromArray(
							[
								elm$html$Html$Attributes$class('container-quizz-buttons')
							]),
						_List_fromArray(
							[
								A2(
								elm$html$Html$a,
								_List_fromArray(
									[
										elm$html$Html$Events$onClick(author$project$Page$Quizz$QuizzReInit)
									]),
								_List_fromArray(
									[
										A2(
										elm$html$Html$span,
										_List_fromArray(
											[
												elm$html$Html$Attributes$class('icon-arrows-cw')
											]),
										_List_Nil)
									]))
							])),
						A2(
						elm$html$Html$h2,
						_List_fromArray(
							[
								A2(elm$html$Html$Attributes$style, 'color', color)
							]),
						_List_fromArray(
							[
								elm$html$Html$text('The word to find:')
							])),
						A2(
						elm$html$Html$div,
						_List_fromArray(
							[
								elm$html$Html$Attributes$class('container-cards')
							]),
						_List_fromArray(
							[
								author$project$Views$Words$viewWordCard(quizzWord)
							]))
					]));
		} else {
			return A2(
				elm$html$Html$div,
				_List_Nil,
				_List_fromArray(
					[
						A2(
						elm$html$Html$div,
						_List_fromArray(
							[
								elm$html$Html$Attributes$class('container-quizz-buttons')
							]),
						_List_fromArray(
							[
								A2(
								elm$html$Html$a,
								_List_fromArray(
									[
										elm$html$Html$Events$onClick(author$project$Page$Quizz$QuizzReInit)
									]),
								_List_fromArray(
									[
										A2(
										elm$html$Html$span,
										_List_fromArray(
											[
												elm$html$Html$Attributes$class('icon-arrows-cw')
											]),
										_List_Nil)
									]))
							])),
						A2(
						elm$html$Html$h2,
						_List_fromArray(
							[
								A2(elm$html$Html$Attributes$style, 'color', color)
							]),
						_List_fromArray(
							[
								elm$html$Html$text('The word to find:')
							])),
						A2(
						elm$html$Html$div,
						_List_fromArray(
							[
								elm$html$Html$Attributes$class('container-cards')
							]),
						_List_fromArray(
							[
								A3(author$project$Views$Words$viewWordCardForm, quizzWord, author$project$Page$Quizz$TakeQuizzUpdateResponse, author$project$Page$Quizz$TakeQuizzAttempt)
							]))
					]));
		}
	} else {
		return A2(
			elm$html$Html$div,
			_List_Nil,
			_List_fromArray(
				[
					A2(
					elm$html$Html$div,
					_List_fromArray(
						[
							elm$html$Html$Attributes$class('container-quizz-buttons')
						]),
					_List_fromArray(
						[
							A2(
							elm$html$Html$a,
							_List_fromArray(
								[
									elm$html$Html$Events$onClick(author$project$Page$Quizz$QuizzReInit)
								]),
							_List_fromArray(
								[
									A2(
									elm$html$Html$span,
									_List_fromArray(
										[
											elm$html$Html$Attributes$class('icon-arrows-cw')
										]),
									_List_Nil)
								])),
							A2(
							elm$html$Html$a,
							_List_fromArray(
								[
									elm$html$Html$Events$onClick(author$project$Page$Quizz$TakeQuizz)
								]),
							_List_fromArray(
								[
									A2(
									elm$html$Html$span,
									_List_fromArray(
										[
											elm$html$Html$Attributes$class('icon-play-circled')
										]),
									_List_Nil)
								]))
						])),
					A2(
					elm$html$Html$h2,
					_List_Nil,
					_List_fromArray(
						[
							elm$html$Html$text('My words for the quizz:')
						])),
					A2(
					elm$html$Html$div,
					_List_fromArray(
						[
							elm$html$Html$Attributes$class('container-cards')
						]),
					author$project$Views$Words$viewWordsCards(
						function ($) {
							return $.words;
						}(model)))
				]));
	}
};
var author$project$Page$Register$IncreaseNbLanguage = {$: 'IncreaseNbLanguage'};
var author$project$Page$Register$Register = {$: 'Register'};
var author$project$Page$Register$UpdateNewUser = function (a) {
	return {$: 'UpdateNewUser', a: a};
};
var author$project$Views$Forms$viewLanguageNewUserInput = F4(
	function (newUser, toIncreaseNbLanguage, toUpdateRegisterModel, indexInput) {
		return A2(
			elm$html$Html$div,
			_List_fromArray(
				[
					elm$html$Html$Attributes$class('group-form')
				]),
			_List_fromArray(
				[
					A2(
					elm$html$Html$label,
					_List_fromArray(
						[
							elm$html$Html$Attributes$for(
							'language' + elm$core$String$fromInt(indexInput))
						]),
					_List_fromArray(
						[
							elm$html$Html$text('Language')
						])),
					A2(
					elm$html$Html$input,
					_List_fromArray(
						[
							elm$html$Html$Events$onInput(
							function (v) {
								return toUpdateRegisterModel(
									_Utils_update(
										newUser,
										{
											languages: A3(author$project$Views$Forms$updateNiemeListElement, indexInput + 1, v, newUser.languages)
										}));
							}),
							elm$html$Html$Attributes$placeholder('languages to learn (2chars)')
						]),
					_List_Nil),
					A2(
					elm$html$Html$button,
					_List_fromArray(
						[
							elm$html$Html$Events$onClick(toIncreaseNbLanguage),
							elm$html$Html$Attributes$class('button-add'),
							elm$html$Html$Attributes$type_('button')
						]),
					_List_fromArray(
						[
							A2(
							elm$html$Html$span,
							_List_fromArray(
								[
									elm$html$Html$Attributes$class('icon-plus')
								]),
							_List_Nil)
						]))
				]));
	});
var author$project$Views$Forms$viewLanguageNewUserInputs = F4(
	function (numberOfInput, toIncreaseNbLanguage, newUser, toUpdateRegisterModel) {
		var createLanguageInput = F2(
			function (indexInput, _n0) {
				return A4(author$project$Views$Forms$viewLanguageNewUserInput, newUser, toIncreaseNbLanguage, toUpdateRegisterModel, indexInput);
			});
		return A2(
			elm$core$List$indexedMap,
			createLanguageInput,
			A2(elm$core$List$repeat, numberOfInput, _Utils_Tuple0));
	});
var author$project$Views$Forms$viewFormRegister = F5(
	function (newUser, nbLanguage, toIncreaseNbLanguage, toUpdateRegisterModel, toRegisterMsg) {
		return A2(
			elm$html$Html$form,
			_List_fromArray(
				[
					elm$html$Html$Events$onSubmit(toRegisterMsg),
					elm$html$Html$Attributes$action('javascript:void(0);')
				]),
			_Utils_ap(
				_List_fromArray(
					[
						A2(
						elm$html$Html$label,
						_List_fromArray(
							[
								elm$html$Html$Attributes$for('username')
							]),
						_List_fromArray(
							[
								elm$html$Html$text('Username')
							])),
						A2(
						elm$html$Html$input,
						_List_fromArray(
							[
								elm$html$Html$Events$onInput(
								function (v) {
									return toUpdateRegisterModel(
										_Utils_update(
											newUser,
											{username: v}));
								}),
								elm$html$Html$Attributes$placeholder('username')
							]),
						_List_Nil),
						A2(
						elm$html$Html$label,
						_List_fromArray(
							[
								elm$html$Html$Attributes$for('password')
							]),
						_List_fromArray(
							[
								elm$html$Html$text('Password')
							])),
						A2(
						elm$html$Html$input,
						_List_fromArray(
							[
								elm$html$Html$Events$onInput(
								function (v) {
									return toUpdateRegisterModel(
										_Utils_update(
											newUser,
											{password: v}));
								}),
								elm$html$Html$Attributes$placeholder('password'),
								A2(elm$html$Html$Attributes$attribute, 'type', 'password')
							]),
						_List_Nil),
						A2(
						elm$html$Html$label,
						_List_fromArray(
							[
								elm$html$Html$Attributes$for('email')
							]),
						_List_fromArray(
							[
								elm$html$Html$text('Email')
							])),
						A2(
						elm$html$Html$input,
						_List_fromArray(
							[
								elm$html$Html$Events$onInput(
								function (v) {
									return toUpdateRegisterModel(
										_Utils_update(
											newUser,
											{
												email: elm$core$Maybe$Just(v)
											}));
								}),
								elm$html$Html$Attributes$placeholder('email')
							]),
						_List_Nil)
					]),
				_Utils_ap(
					A4(author$project$Views$Forms$viewLanguageNewUserInputs, nbLanguage, toIncreaseNbLanguage, newUser, toUpdateRegisterModel),
					_List_fromArray(
						[
							A2(
							elm$html$Html$button,
							_List_fromArray(
								[
									elm$html$Html$Attributes$type_('submit')
								]),
							_List_fromArray(
								[
									elm$html$Html$text('please, register me')
								]))
						]))));
	});
var author$project$Page$Register$view = function (model) {
	return A2(
		elm$html$Html$div,
		_List_fromArray(
			[
				elm$html$Html$Attributes$class('form-div')
			]),
		_List_fromArray(
			[
				A2(
				elm$html$Html$h1,
				_List_Nil,
				_List_fromArray(
					[
						elm$html$Html$text('Register'),
						A2(
						elm$html$Html$span,
						_List_Nil,
						_List_fromArray(
							[
								A2(
								elm$html$Html$a,
								_List_fromArray(
									[
										author$project$Route$href(author$project$Route$Login)
									]),
								_List_fromArray(
									[
										elm$html$Html$text('or login')
									]))
							]))
					])),
				A5(author$project$Views$Forms$viewFormRegister, model.newUser, model.nbLanguage, author$project$Page$Register$IncreaseNbLanguage, author$project$Page$Register$UpdateNewUser, author$project$Page$Register$Register)
			]));
};
var author$project$Page$WordDelete$view = function (model) {
	return A2(
		elm$html$Html$div,
		_List_Nil,
		_List_fromArray(
			[
				A2(
				elm$html$Html$p,
				_List_Nil,
				_List_fromArray(
					[
						elm$html$Html$text('Deleting the word…')
					]))
			]));
};
var author$project$Page$WordEdit$IncreaseNbKeyword = {$: 'IncreaseNbKeyword'};
var author$project$Page$WordEdit$RemoveKeyword = function (a) {
	return {$: 'RemoveKeyword', a: a};
};
var author$project$Page$WordEdit$UpdateWord = function (a) {
	return {$: 'UpdateWord', a: a};
};
var author$project$Page$WordEdit$UpdateWordRequest = {$: 'UpdateWordRequest'};
var author$project$Views$Forms$viewKeywordInput = F5(
	function (word, toIncreaseNbKeyword, toRemoveKeyword, toUpdateWord, indexInput) {
		var keyword = function () {
			var _n0 = elm$core$List$head(
				A2(elm$core$List$drop, indexInput, word.keywords));
			if (_n0.$ === 'Just') {
				var responseKeyword = _n0.a;
				return responseKeyword;
			} else {
				return '';
			}
		}();
		return A2(
			elm$html$Html$div,
			_List_fromArray(
				[
					elm$html$Html$Attributes$class('group-form')
				]),
			_List_fromArray(
				[
					A2(
					elm$html$Html$label,
					_List_fromArray(
						[
							elm$html$Html$Attributes$for(
							'keyword' + elm$core$String$fromInt(indexInput))
						]),
					_List_fromArray(
						[
							elm$html$Html$text('Keyword')
						])),
					A2(
					elm$html$Html$input,
					_List_fromArray(
						[
							elm$html$Html$Events$onInput(
							function (v) {
								return toUpdateWord(
									_Utils_update(
										word,
										{
											keywords: A3(author$project$Views$Forms$updateNiemeListElement, indexInput + 1, v, word.keywords)
										}));
							}),
							elm$html$Html$Attributes$placeholder('keyword'),
							elm$html$Html$Attributes$value(keyword)
						]),
					_List_Nil),
					A2(
					elm$html$Html$button,
					_List_fromArray(
						[
							elm$html$Html$Events$onClick(toIncreaseNbKeyword),
							elm$html$Html$Attributes$type_('button'),
							elm$html$Html$Attributes$class('button-add')
						]),
					_List_fromArray(
						[
							A2(
							elm$html$Html$span,
							_List_fromArray(
								[
									elm$html$Html$Attributes$class('icon-plus')
								]),
							_List_Nil)
						])),
					A2(
					elm$html$Html$button,
					_List_fromArray(
						[
							elm$html$Html$Events$onClick(
							toRemoveKeyword(indexInput)),
							elm$html$Html$Attributes$type_('button'),
							elm$html$Html$Attributes$class('button-minus')
						]),
					_List_fromArray(
						[
							A2(
							elm$html$Html$span,
							_List_fromArray(
								[
									elm$html$Html$Attributes$class('icon-minus')
								]),
							_List_Nil)
						]))
				]));
	});
var author$project$Views$Forms$viewKeywordInputs = F5(
	function (numberOfInput, toIncreaseNbKeyword, toRemoveKeyword, word, toUpdateWord) {
		var createWordInput = F2(
			function (indexInput, _n0) {
				return A5(author$project$Views$Forms$viewKeywordInput, word, toIncreaseNbKeyword, toRemoveKeyword, toUpdateWord, indexInput);
			});
		return A2(
			elm$core$List$indexedMap,
			createWordInput,
			A2(elm$core$List$repeat, numberOfInput, _Utils_Tuple0));
	});
var author$project$Views$Forms$viewWordForm = F6(
	function (word, nbKeyword, toIncreaseNbKeyword, toRemoveKeyword, toUpdateWord, toUpdateMsg) {
		return A2(
			elm$html$Html$form,
			_List_fromArray(
				[
					elm$html$Html$Events$onSubmit(toUpdateMsg)
				]),
			_Utils_ap(
				_List_fromArray(
					[
						A2(
						elm$html$Html$label,
						_List_fromArray(
							[
								elm$html$Html$Attributes$for('language')
							]),
						_List_fromArray(
							[
								elm$html$Html$text('Language')
							])),
						A2(
						elm$html$Html$input,
						_List_fromArray(
							[
								elm$html$Html$Events$onInput(
								function (v) {
									return toUpdateWord(
										_Utils_update(
											word,
											{language: v}));
								}),
								elm$html$Html$Attributes$placeholder('language'),
								elm$html$Html$Attributes$value(
								function ($) {
									return $.language;
								}(word))
							]),
						_List_Nil),
						A2(
						elm$html$Html$label,
						_List_fromArray(
							[
								elm$html$Html$Attributes$for('definition')
							]),
						_List_fromArray(
							[
								elm$html$Html$text('Definition')
							])),
						A2(
						elm$html$Html$input,
						_List_fromArray(
							[
								elm$html$Html$Events$onInput(
								function (v) {
									return toUpdateWord(
										_Utils_update(
											word,
											{word: v}));
								}),
								elm$html$Html$Attributes$placeholder('definition'),
								elm$html$Html$Attributes$value(
								function ($) {
									return $.word;
								}(word))
							]),
						_List_Nil)
					]),
				_Utils_ap(
					A5(author$project$Views$Forms$viewKeywordInputs, nbKeyword, toIncreaseNbKeyword, toRemoveKeyword, word, toUpdateWord),
					_List_fromArray(
						[
							A2(
							elm$html$Html$label,
							_List_fromArray(
								[
									elm$html$Html$Attributes$for('definition')
								]),
							_List_fromArray(
								[
									elm$html$Html$text('Definition')
								])),
							A2(
							elm$html$Html$input,
							_List_fromArray(
								[
									elm$html$Html$Events$onInput(
									function (v) {
										return toUpdateWord(
											_Utils_update(
												word,
												{definition: v}));
									}),
									elm$html$Html$Attributes$placeholder('definition'),
									elm$html$Html$Attributes$value(
									function ($) {
										return $.definition;
									}(word))
								]),
							_List_Nil),
							A2(
							elm$html$Html$label,
							_List_fromArray(
								[
									elm$html$Html$Attributes$for('difficulty')
								]),
							_List_fromArray(
								[
									elm$html$Html$text('Difficulty')
								])),
							A2(
							elm$html$Html$input,
							_List_fromArray(
								[
									elm$html$Html$Attributes$placeholder('difficulty (0 to 10)'),
									elm$html$Html$Attributes$value(
									elm$core$String$fromInt(
										A2(
											elm$core$Maybe$withDefault,
											0,
											function ($) {
												return $.difficulty;
											}(word))))
								]),
							_List_Nil),
							A2(
							elm$html$Html$button,
							_List_fromArray(
								[
									elm$html$Html$Attributes$type_('submit')
								]),
							_List_fromArray(
								[
									elm$html$Html$text('Update word')
								]))
						]))));
	});
var author$project$Page$WordEdit$view = function (model) {
	var _n0 = model.word;
	if (_n0.$ === 'Nothing') {
		return A2(
			elm$html$Html$div,
			_List_Nil,
			_List_fromArray(
				[
					A2(
					elm$html$Html$h1,
					_List_Nil,
					_List_fromArray(
						[
							elm$html$Html$text('Loading the word…')
						]))
				]));
	} else {
		var word = _n0.a;
		return A2(
			elm$html$Html$div,
			_List_fromArray(
				[
					elm$html$Html$Attributes$class('form-div')
				]),
			_List_fromArray(
				[
					A2(
					elm$html$Html$h1,
					_List_Nil,
					_List_fromArray(
						[
							elm$html$Html$text(
							'Word #' + elm$core$String$fromInt(
								function ($) {
									return $.id;
								}(word)))
						])),
					A6(author$project$Views$Forms$viewWordForm, word, model.nbKeyword, author$project$Page$WordEdit$IncreaseNbKeyword, author$project$Page$WordEdit$RemoveKeyword, author$project$Page$WordEdit$UpdateWord, author$project$Page$WordEdit$UpdateWordRequest)
				]));
	}
};
var author$project$Views$Page$viewFooter = A2(
	elm$html$Html$div,
	_List_fromArray(
		[
			elm$html$Html$Attributes$class('footer')
		]),
	_List_fromArray(
		[
			A2(
			elm$html$Html$p,
			_List_Nil,
			_List_fromArray(
				[
					elm$html$Html$text('Made with ❤ from WAW ❤ by '),
					A2(
					elm$html$Html$a,
					_List_fromArray(
						[
							elm$html$Html$Attributes$href('https://github.com/aRkadeFR')
						]),
					_List_fromArray(
						[
							elm$html$Html$text('aRkadeFR')
						]))
				]))
		]));
var elm$html$Html$li = _VirtualDom_node('li');
var elm$html$Html$nav = _VirtualDom_node('nav');
var elm$html$Html$ul = _VirtualDom_node('ul');
var author$project$Views$Page$viewNav = function (session) {
	var _n0 = session.user;
	if (_n0.$ === 'Just') {
		var user = _n0.a;
		return A2(
			elm$html$Html$nav,
			_List_Nil,
			_List_fromArray(
				[
					A2(
					elm$html$Html$ul,
					_List_Nil,
					_List_fromArray(
						[
							A2(
							elm$html$Html$li,
							_List_Nil,
							_List_fromArray(
								[
									A2(
									elm$html$Html$a,
									_List_fromArray(
										[
											author$project$Route$href(author$project$Route$Home)
										]),
									_List_fromArray(
										[
											elm$html$Html$text('Go home')
										]))
								])),
							A2(
							elm$html$Html$li,
							_List_Nil,
							_List_fromArray(
								[
									A2(
									elm$html$Html$a,
									_List_fromArray(
										[
											author$project$Route$href(author$project$Route$ProfileEdit)
										]),
									_List_fromArray(
										[
											elm$html$Html$text('Edit Profile')
										]))
								])),
							A2(
							elm$html$Html$li,
							_List_Nil,
							_List_fromArray(
								[
									A2(
									elm$html$Html$a,
									_List_fromArray(
										[
											author$project$Route$href(author$project$Route$Logout)
										]),
									_List_fromArray(
										[
											elm$html$Html$text('Logout')
										]))
								]))
						]))
				]));
	} else {
		return A2(
			elm$html$Html$nav,
			_List_Nil,
			_List_fromArray(
				[
					A2(
					elm$html$Html$ul,
					_List_Nil,
					_List_fromArray(
						[
							A2(
							elm$html$Html$li,
							_List_Nil,
							_List_fromArray(
								[
									A2(
									elm$html$Html$a,
									_List_fromArray(
										[
											author$project$Route$href(author$project$Route$Login)
										]),
									_List_fromArray(
										[
											elm$html$Html$text('Login')
										]))
								])),
							A2(
							elm$html$Html$li,
							_List_Nil,
							_List_fromArray(
								[
									A2(
									elm$html$Html$a,
									_List_fromArray(
										[
											author$project$Route$href(author$project$Route$Register)
										]),
									_List_fromArray(
										[
											elm$html$Html$text('Register')
										]))
								]))
						]))
				]));
	}
};
var elm$html$Html$img = _VirtualDom_node('img');
var elm$html$Html$Attributes$src = function (url) {
	return A2(
		elm$html$Html$Attributes$stringProperty,
		'src',
		_VirtualDom_noJavaScriptOrHtmlUri(url));
};
var author$project$Views$Page$viewHeader = function (session) {
	return A2(
		elm$html$Html$div,
		_List_fromArray(
			[
				elm$html$Html$Attributes$class('header')
			]),
		_List_fromArray(
			[
				A2(
				elm$html$Html$div,
				_List_fromArray(
					[
						elm$html$Html$Attributes$class('header-title')
					]),
				_List_fromArray(
					[
						A2(
						elm$html$Html$h1,
						_List_Nil,
						_List_fromArray(
							[
								A2(
								elm$html$Html$img,
								_List_fromArray(
									[
										elm$html$Html$Attributes$src('/ressources/dictionnary.logo.png')
									]),
								_List_Nil),
								elm$html$Html$text('IziDict.com')
							]))
					])),
				A2(
				elm$html$Html$div,
				_List_fromArray(
					[
						elm$html$Html$Attributes$class('logos')
					]),
				_List_fromArray(
					[
						A2(
						elm$html$Html$img,
						_List_fromArray(
							[
								elm$html$Html$Attributes$class('support-logo'),
								elm$html$Html$Attributes$src('/ressources/Logo.ELM.png')
							]),
						_List_Nil),
						A2(
						elm$html$Html$img,
						_List_fromArray(
							[
								elm$html$Html$Attributes$class('support-logo'),
								elm$html$Html$Attributes$src('/ressources/Logo.Haskell.png')
							]),
						_List_Nil),
						A2(
						elm$html$Html$img,
						_List_fromArray(
							[
								elm$html$Html$Attributes$class('support-logo'),
								elm$html$Html$Attributes$src('/ressources/Logo.Github.png')
							]),
						_List_Nil),
						A2(
						elm$html$Html$img,
						_List_fromArray(
							[
								elm$html$Html$Attributes$class('support-logo'),
								elm$html$Html$Attributes$src('/ressources/Logo.Servant.png')
							]),
						_List_Nil),
						A2(
						elm$html$Html$img,
						_List_fromArray(
							[
								elm$html$Html$Attributes$class('support-logo'),
								elm$html$Html$Attributes$src('/ressources/Logo.PostgreSQL.png')
							]),
						_List_Nil),
						A2(
						elm$html$Html$img,
						_List_fromArray(
							[
								elm$html$Html$Attributes$class('support-logo'),
								elm$html$Html$Attributes$src('/ressources/Logo.Debian.png')
							]),
						_List_Nil)
					])),
				A2(
				elm$html$Html$div,
				_List_fromArray(
					[
						elm$html$Html$Attributes$class('navigation')
					]),
				_List_fromArray(
					[
						author$project$Views$Page$viewNav(session)
					]))
			]));
};
var author$project$Views$Messages$viewMessageLi = function (message) {
	var criticity = message.a;
	var msgString = message.b;
	return A2(
		elm$html$Html$li,
		_List_Nil,
		_List_fromArray(
			[
				elm$html$Html$text('message: ' + msgString)
			]));
};
var author$project$Views$Page$viewMessages = function (listMessages) {
	return A2(
		elm$html$Html$div,
		_List_fromArray(
			[
				elm$html$Html$Attributes$class('messages')
			]),
		_List_fromArray(
			[
				A2(
				elm$html$Html$ul,
				_List_Nil,
				A2(elm$core$List$map, author$project$Views$Messages$viewMessageLi, listMessages))
			]));
};
var author$project$Views$Page$frame = F3(
	function (session, listMessages, content) {
		return A2(
			elm$html$Html$div,
			_List_fromArray(
				[
					elm$html$Html$Attributes$class('container')
				]),
			_List_fromArray(
				[
					author$project$Views$Page$viewHeader(session),
					A2(elm$html$Html$div, _List_Nil, _List_Nil),
					A2(
					elm$html$Html$div,
					_List_fromArray(
						[
							elm$html$Html$Attributes$class('main')
						]),
					_List_fromArray(
						[
							author$project$Views$Page$viewMessages(listMessages),
							content
						])),
					A2(elm$html$Html$div, _List_Nil, _List_Nil),
					author$project$Views$Page$viewFooter
				]));
	});
var elm$browser$Browser$Document = F2(
	function (title, body) {
		return {body: body, title: title};
	});
var elm$virtual_dom$VirtualDom$map = _VirtualDom_map;
var elm$html$Html$map = elm$virtual_dom$VirtualDom$map;
var author$project$WordApp$view = function (model) {
	var frame = A2(author$project$Views$Page$frame, model.session, model.messages);
	var document = function (htmlElement) {
		return A2(
			elm$browser$Browser$Document,
			'IziDict.com - My Dictionnary Online!',
			_List_fromArray(
				[htmlElement]));
	};
	var _n0 = model.page;
	switch (_n0.$) {
		case 'Login':
			var subModel = _n0.a;
			return document(
				A2(
					elm$html$Html$map,
					author$project$WordApp$LoginMsg,
					frame(
						author$project$Page$Login$view(subModel))));
		case 'Register':
			var subModel = _n0.a;
			return document(
				A2(
					elm$html$Html$map,
					author$project$WordApp$RegisterMsg,
					frame(
						author$project$Page$Register$view(subModel))));
		case 'ProfileEdit':
			var subModel = _n0.a;
			return document(
				A2(
					elm$html$Html$map,
					author$project$WordApp$ProfileEditMsg,
					frame(
						author$project$Page$ProfileEdit$view(subModel))));
		case 'Home':
			var subModel = _n0.a;
			return document(
				A2(
					elm$html$Html$map,
					author$project$WordApp$HomeMsg,
					frame(
						A2(author$project$Page$Home$view, subModel, model.session))));
		case 'WordEdit':
			var subModel = _n0.a;
			return document(
				A2(
					elm$html$Html$map,
					author$project$WordApp$WordEditMsg,
					frame(
						author$project$Page$WordEdit$view(subModel))));
		case 'WordDelete':
			var subModel = _n0.a;
			return document(
				A2(
					elm$html$Html$map,
					author$project$WordApp$WordDeleteMsg,
					frame(
						author$project$Page$WordDelete$view(subModel))));
		case 'Quizz':
			var subModel = _n0.a;
			return document(
				A2(
					elm$html$Html$map,
					author$project$WordApp$QuizzMsg,
					frame(
						author$project$Page$Quizz$view(subModel))));
		default:
			return document(
				frame(author$project$Page$NotFound$view));
	}
};
var elm$browser$Browser$application = _Browser_application;
var author$project$WordApp$main = elm$browser$Browser$application(
	{init: author$project$WordApp$init, onUrlChange: author$project$WordApp$ChangedUrl, onUrlRequest: author$project$WordApp$ClickedLink, subscriptions: author$project$WordApp$subscriptions, update: author$project$WordApp$update, view: author$project$WordApp$view});
_Platform_export({'WordApp':{'init':author$project$WordApp$main(elm$json$Json$Decode$value)(0)}});}(this));