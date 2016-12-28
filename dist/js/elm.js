
(function() {
'use strict';

function F2(fun)
{
  function wrapper(a) { return function(b) { return fun(a,b); }; }
  wrapper.arity = 2;
  wrapper.func = fun;
  return wrapper;
}

function F3(fun)
{
  function wrapper(a) {
    return function(b) { return function(c) { return fun(a, b, c); }; };
  }
  wrapper.arity = 3;
  wrapper.func = fun;
  return wrapper;
}

function F4(fun)
{
  function wrapper(a) { return function(b) { return function(c) {
    return function(d) { return fun(a, b, c, d); }; }; };
  }
  wrapper.arity = 4;
  wrapper.func = fun;
  return wrapper;
}

function F5(fun)
{
  function wrapper(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return fun(a, b, c, d, e); }; }; }; };
  }
  wrapper.arity = 5;
  wrapper.func = fun;
  return wrapper;
}

function F6(fun)
{
  function wrapper(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return fun(a, b, c, d, e, f); }; }; }; }; };
  }
  wrapper.arity = 6;
  wrapper.func = fun;
  return wrapper;
}

function F7(fun)
{
  function wrapper(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return function(g) { return fun(a, b, c, d, e, f, g); }; }; }; }; }; };
  }
  wrapper.arity = 7;
  wrapper.func = fun;
  return wrapper;
}

function F8(fun)
{
  function wrapper(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return function(g) { return function(h) {
    return fun(a, b, c, d, e, f, g, h); }; }; }; }; }; }; };
  }
  wrapper.arity = 8;
  wrapper.func = fun;
  return wrapper;
}

function F9(fun)
{
  function wrapper(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return function(g) { return function(h) { return function(i) {
    return fun(a, b, c, d, e, f, g, h, i); }; }; }; }; }; }; }; };
  }
  wrapper.arity = 9;
  wrapper.func = fun;
  return wrapper;
}

function A2(fun, a, b)
{
  return fun.arity === 2
    ? fun.func(a, b)
    : fun(a)(b);
}
function A3(fun, a, b, c)
{
  return fun.arity === 3
    ? fun.func(a, b, c)
    : fun(a)(b)(c);
}
function A4(fun, a, b, c, d)
{
  return fun.arity === 4
    ? fun.func(a, b, c, d)
    : fun(a)(b)(c)(d);
}
function A5(fun, a, b, c, d, e)
{
  return fun.arity === 5
    ? fun.func(a, b, c, d, e)
    : fun(a)(b)(c)(d)(e);
}
function A6(fun, a, b, c, d, e, f)
{
  return fun.arity === 6
    ? fun.func(a, b, c, d, e, f)
    : fun(a)(b)(c)(d)(e)(f);
}
function A7(fun, a, b, c, d, e, f, g)
{
  return fun.arity === 7
    ? fun.func(a, b, c, d, e, f, g)
    : fun(a)(b)(c)(d)(e)(f)(g);
}
function A8(fun, a, b, c, d, e, f, g, h)
{
  return fun.arity === 8
    ? fun.func(a, b, c, d, e, f, g, h)
    : fun(a)(b)(c)(d)(e)(f)(g)(h);
}
function A9(fun, a, b, c, d, e, f, g, h, i)
{
  return fun.arity === 9
    ? fun.func(a, b, c, d, e, f, g, h, i)
    : fun(a)(b)(c)(d)(e)(f)(g)(h)(i);
}

//import Native.Utils //

var _elm_lang$core$Native_Basics = function() {

function div(a, b)
{
	return (a / b) | 0;
}
function rem(a, b)
{
	return a % b;
}
function mod(a, b)
{
	if (b === 0)
	{
		throw new Error('Cannot perform mod 0. Division by zero error.');
	}
	var r = a % b;
	var m = a === 0 ? 0 : (b > 0 ? (a >= 0 ? r : r + b) : -mod(-a, -b));

	return m === b ? 0 : m;
}
function logBase(base, n)
{
	return Math.log(n) / Math.log(base);
}
function negate(n)
{
	return -n;
}
function abs(n)
{
	return n < 0 ? -n : n;
}

function min(a, b)
{
	return _elm_lang$core$Native_Utils.cmp(a, b) < 0 ? a : b;
}
function max(a, b)
{
	return _elm_lang$core$Native_Utils.cmp(a, b) > 0 ? a : b;
}
function clamp(lo, hi, n)
{
	return _elm_lang$core$Native_Utils.cmp(n, lo) < 0
		? lo
		: _elm_lang$core$Native_Utils.cmp(n, hi) > 0
			? hi
			: n;
}

var ord = ['LT', 'EQ', 'GT'];

function compare(x, y)
{
	return { ctor: ord[_elm_lang$core$Native_Utils.cmp(x, y) + 1] };
}

function xor(a, b)
{
	return a !== b;
}
function not(b)
{
	return !b;
}
function isInfinite(n)
{
	return n === Infinity || n === -Infinity;
}

function truncate(n)
{
	return n | 0;
}

function degrees(d)
{
	return d * Math.PI / 180;
}
function turns(t)
{
	return 2 * Math.PI * t;
}
function fromPolar(point)
{
	var r = point._0;
	var t = point._1;
	return _elm_lang$core$Native_Utils.Tuple2(r * Math.cos(t), r * Math.sin(t));
}
function toPolar(point)
{
	var x = point._0;
	var y = point._1;
	return _elm_lang$core$Native_Utils.Tuple2(Math.sqrt(x * x + y * y), Math.atan2(y, x));
}

return {
	div: F2(div),
	rem: F2(rem),
	mod: F2(mod),

	pi: Math.PI,
	e: Math.E,
	cos: Math.cos,
	sin: Math.sin,
	tan: Math.tan,
	acos: Math.acos,
	asin: Math.asin,
	atan: Math.atan,
	atan2: F2(Math.atan2),

	degrees: degrees,
	turns: turns,
	fromPolar: fromPolar,
	toPolar: toPolar,

	sqrt: Math.sqrt,
	logBase: F2(logBase),
	negate: negate,
	abs: abs,
	min: F2(min),
	max: F2(max),
	clamp: F3(clamp),
	compare: F2(compare),

	xor: F2(xor),
	not: not,

	truncate: truncate,
	ceiling: Math.ceil,
	floor: Math.floor,
	round: Math.round,
	toFloat: function(x) { return x; },
	isNaN: isNaN,
	isInfinite: isInfinite
};

}();
//import //

var _elm_lang$core$Native_Utils = function() {

// COMPARISONS

function eq(x, y)
{
	var stack = [];
	var isEqual = eqHelp(x, y, 0, stack);
	var pair;
	while (isEqual && (pair = stack.pop()))
	{
		isEqual = eqHelp(pair.x, pair.y, 0, stack);
	}
	return isEqual;
}


function eqHelp(x, y, depth, stack)
{
	if (depth > 100)
	{
		stack.push({ x: x, y: y });
		return true;
	}

	if (x === y)
	{
		return true;
	}

	if (typeof x !== 'object')
	{
		if (typeof x === 'function')
		{
			throw new Error(
				'Trying to use `(==)` on functions. There is no way to know if functions are "the same" in the Elm sense.'
				+ ' Read more about this at http://package.elm-lang.org/packages/elm-lang/core/latest/Basics#=='
				+ ' which describes why it is this way and what the better version will look like.'
			);
		}
		return false;
	}

	if (x === null || y === null)
	{
		return false
	}

	if (x instanceof Date)
	{
		return x.getTime() === y.getTime();
	}

	if (!('ctor' in x))
	{
		for (var key in x)
		{
			if (!eqHelp(x[key], y[key], depth + 1, stack))
			{
				return false;
			}
		}
		return true;
	}

	// convert Dicts and Sets to lists
	if (x.ctor === 'RBNode_elm_builtin' || x.ctor === 'RBEmpty_elm_builtin')
	{
		x = _elm_lang$core$Dict$toList(x);
		y = _elm_lang$core$Dict$toList(y);
	}
	if (x.ctor === 'Set_elm_builtin')
	{
		x = _elm_lang$core$Set$toList(x);
		y = _elm_lang$core$Set$toList(y);
	}

	// check if lists are equal without recursion
	if (x.ctor === '::')
	{
		var a = x;
		var b = y;
		while (a.ctor === '::' && b.ctor === '::')
		{
			if (!eqHelp(a._0, b._0, depth + 1, stack))
			{
				return false;
			}
			a = a._1;
			b = b._1;
		}
		return a.ctor === b.ctor;
	}

	// check if Arrays are equal
	if (x.ctor === '_Array')
	{
		var xs = _elm_lang$core$Native_Array.toJSArray(x);
		var ys = _elm_lang$core$Native_Array.toJSArray(y);
		if (xs.length !== ys.length)
		{
			return false;
		}
		for (var i = 0; i < xs.length; i++)
		{
			if (!eqHelp(xs[i], ys[i], depth + 1, stack))
			{
				return false;
			}
		}
		return true;
	}

	if (!eqHelp(x.ctor, y.ctor, depth + 1, stack))
	{
		return false;
	}

	for (var key in x)
	{
		if (!eqHelp(x[key], y[key], depth + 1, stack))
		{
			return false;
		}
	}
	return true;
}

// Code in Generate/JavaScript.hs, Basics.js, and List.js depends on
// the particular integer values assigned to LT, EQ, and GT.

var LT = -1, EQ = 0, GT = 1;

function cmp(x, y)
{
	if (typeof x !== 'object')
	{
		return x === y ? EQ : x < y ? LT : GT;
	}

	if (x instanceof String)
	{
		var a = x.valueOf();
		var b = y.valueOf();
		return a === b ? EQ : a < b ? LT : GT;
	}

	if (x.ctor === '::' || x.ctor === '[]')
	{
		while (x.ctor === '::' && y.ctor === '::')
		{
			var ord = cmp(x._0, y._0);
			if (ord !== EQ)
			{
				return ord;
			}
			x = x._1;
			y = y._1;
		}
		return x.ctor === y.ctor ? EQ : x.ctor === '[]' ? LT : GT;
	}

	if (x.ctor.slice(0, 6) === '_Tuple')
	{
		var ord;
		var n = x.ctor.slice(6) - 0;
		var err = 'cannot compare tuples with more than 6 elements.';
		if (n === 0) return EQ;
		if (n >= 1) { ord = cmp(x._0, y._0); if (ord !== EQ) return ord;
		if (n >= 2) { ord = cmp(x._1, y._1); if (ord !== EQ) return ord;
		if (n >= 3) { ord = cmp(x._2, y._2); if (ord !== EQ) return ord;
		if (n >= 4) { ord = cmp(x._3, y._3); if (ord !== EQ) return ord;
		if (n >= 5) { ord = cmp(x._4, y._4); if (ord !== EQ) return ord;
		if (n >= 6) { ord = cmp(x._5, y._5); if (ord !== EQ) return ord;
		if (n >= 7) throw new Error('Comparison error: ' + err); } } } } } }
		return EQ;
	}

	throw new Error(
		'Comparison error: comparison is only defined on ints, '
		+ 'floats, times, chars, strings, lists of comparable values, '
		+ 'and tuples of comparable values.'
	);
}


// COMMON VALUES

var Tuple0 = {
	ctor: '_Tuple0'
};

function Tuple2(x, y)
{
	return {
		ctor: '_Tuple2',
		_0: x,
		_1: y
	};
}

function chr(c)
{
	return new String(c);
}


// GUID

var count = 0;
function guid(_)
{
	return count++;
}


// RECORDS

function update(oldRecord, updatedFields)
{
	var newRecord = {};
	for (var key in oldRecord)
	{
		var value = (key in updatedFields) ? updatedFields[key] : oldRecord[key];
		newRecord[key] = value;
	}
	return newRecord;
}


//// LIST STUFF ////

var Nil = { ctor: '[]' };

function Cons(hd, tl)
{
	return {
		ctor: '::',
		_0: hd,
		_1: tl
	};
}

function append(xs, ys)
{
	// append Strings
	if (typeof xs === 'string')
	{
		return xs + ys;
	}

	// append Lists
	if (xs.ctor === '[]')
	{
		return ys;
	}
	var root = Cons(xs._0, Nil);
	var curr = root;
	xs = xs._1;
	while (xs.ctor !== '[]')
	{
		curr._1 = Cons(xs._0, Nil);
		xs = xs._1;
		curr = curr._1;
	}
	curr._1 = ys;
	return root;
}


// CRASHES

function crash(moduleName, region)
{
	return function(message) {
		throw new Error(
			'Ran into a `Debug.crash` in module `' + moduleName + '` ' + regionToString(region) + '\n'
			+ 'The message provided by the code author is:\n\n    '
			+ message
		);
	};
}

function crashCase(moduleName, region, value)
{
	return function(message) {
		throw new Error(
			'Ran into a `Debug.crash` in module `' + moduleName + '`\n\n'
			+ 'This was caused by the `case` expression ' + regionToString(region) + '.\n'
			+ 'One of the branches ended with a crash and the following value got through:\n\n    ' + toString(value) + '\n\n'
			+ 'The message provided by the code author is:\n\n    '
			+ message
		);
	};
}

function regionToString(region)
{
	if (region.start.line == region.end.line)
	{
		return 'on line ' + region.start.line;
	}
	return 'between lines ' + region.start.line + ' and ' + region.end.line;
}


// TO STRING

function toString(v)
{
	var type = typeof v;
	if (type === 'function')
	{
		var name = v.func ? v.func.name : v.name;
		return '<function' + (name === '' ? '' : ':') + name + '>';
	}

	if (type === 'boolean')
	{
		return v ? 'True' : 'False';
	}

	if (type === 'number')
	{
		return v + '';
	}

	if (v instanceof String)
	{
		return '\'' + addSlashes(v, true) + '\'';
	}

	if (type === 'string')
	{
		return '"' + addSlashes(v, false) + '"';
	}

	if (v === null)
	{
		return 'null';
	}

	if (type === 'object' && 'ctor' in v)
	{
		var ctorStarter = v.ctor.substring(0, 5);

		if (ctorStarter === '_Tupl')
		{
			var output = [];
			for (var k in v)
			{
				if (k === 'ctor') continue;
				output.push(toString(v[k]));
			}
			return '(' + output.join(',') + ')';
		}

		if (ctorStarter === '_Task')
		{
			return '<task>'
		}

		if (v.ctor === '_Array')
		{
			var list = _elm_lang$core$Array$toList(v);
			return 'Array.fromList ' + toString(list);
		}

		if (v.ctor === '<decoder>')
		{
			return '<decoder>';
		}

		if (v.ctor === '_Process')
		{
			return '<process:' + v.id + '>';
		}

		if (v.ctor === '::')
		{
			var output = '[' + toString(v._0);
			v = v._1;
			while (v.ctor === '::')
			{
				output += ',' + toString(v._0);
				v = v._1;
			}
			return output + ']';
		}

		if (v.ctor === '[]')
		{
			return '[]';
		}

		if (v.ctor === 'Set_elm_builtin')
		{
			return 'Set.fromList ' + toString(_elm_lang$core$Set$toList(v));
		}

		if (v.ctor === 'RBNode_elm_builtin' || v.ctor === 'RBEmpty_elm_builtin')
		{
			return 'Dict.fromList ' + toString(_elm_lang$core$Dict$toList(v));
		}

		var output = '';
		for (var i in v)
		{
			if (i === 'ctor') continue;
			var str = toString(v[i]);
			var c0 = str[0];
			var parenless = c0 === '{' || c0 === '(' || c0 === '<' || c0 === '"' || str.indexOf(' ') < 0;
			output += ' ' + (parenless ? str : '(' + str + ')');
		}
		return v.ctor + output;
	}

	if (type === 'object')
	{
		if (v instanceof Date)
		{
			return '<' + v.toString() + '>';
		}

		if (v.elm_web_socket)
		{
			return '<websocket>';
		}

		var output = [];
		for (var k in v)
		{
			output.push(k + ' = ' + toString(v[k]));
		}
		if (output.length === 0)
		{
			return '{}';
		}
		return '{ ' + output.join(', ') + ' }';
	}

	return '<internal structure>';
}

function addSlashes(str, isChar)
{
	var s = str.replace(/\\/g, '\\\\')
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


return {
	eq: eq,
	cmp: cmp,
	Tuple0: Tuple0,
	Tuple2: Tuple2,
	chr: chr,
	update: update,
	guid: guid,

	append: F2(append),

	crash: crash,
	crashCase: crashCase,

	toString: toString
};

}();
var _elm_lang$core$Basics$uncurry = F2(
	function (f, _p0) {
		var _p1 = _p0;
		return A2(f, _p1._0, _p1._1);
	});
var _elm_lang$core$Basics$curry = F3(
	function (f, a, b) {
		return f(
			{ctor: '_Tuple2', _0: a, _1: b});
	});
var _elm_lang$core$Basics$flip = F3(
	function (f, b, a) {
		return A2(f, a, b);
	});
var _elm_lang$core$Basics$snd = function (_p2) {
	var _p3 = _p2;
	return _p3._1;
};
var _elm_lang$core$Basics$fst = function (_p4) {
	var _p5 = _p4;
	return _p5._0;
};
var _elm_lang$core$Basics$always = F2(
	function (a, _p6) {
		return a;
	});
var _elm_lang$core$Basics$identity = function (x) {
	return x;
};
var _elm_lang$core$Basics_ops = _elm_lang$core$Basics_ops || {};
_elm_lang$core$Basics_ops['<|'] = F2(
	function (f, x) {
		return f(x);
	});
var _elm_lang$core$Basics_ops = _elm_lang$core$Basics_ops || {};
_elm_lang$core$Basics_ops['|>'] = F2(
	function (x, f) {
		return f(x);
	});
var _elm_lang$core$Basics_ops = _elm_lang$core$Basics_ops || {};
_elm_lang$core$Basics_ops['>>'] = F3(
	function (f, g, x) {
		return g(
			f(x));
	});
var _elm_lang$core$Basics_ops = _elm_lang$core$Basics_ops || {};
_elm_lang$core$Basics_ops['<<'] = F3(
	function (g, f, x) {
		return g(
			f(x));
	});
var _elm_lang$core$Basics_ops = _elm_lang$core$Basics_ops || {};
_elm_lang$core$Basics_ops['++'] = _elm_lang$core$Native_Utils.append;
var _elm_lang$core$Basics$toString = _elm_lang$core$Native_Utils.toString;
var _elm_lang$core$Basics$isInfinite = _elm_lang$core$Native_Basics.isInfinite;
var _elm_lang$core$Basics$isNaN = _elm_lang$core$Native_Basics.isNaN;
var _elm_lang$core$Basics$toFloat = _elm_lang$core$Native_Basics.toFloat;
var _elm_lang$core$Basics$ceiling = _elm_lang$core$Native_Basics.ceiling;
var _elm_lang$core$Basics$floor = _elm_lang$core$Native_Basics.floor;
var _elm_lang$core$Basics$truncate = _elm_lang$core$Native_Basics.truncate;
var _elm_lang$core$Basics$round = _elm_lang$core$Native_Basics.round;
var _elm_lang$core$Basics$not = _elm_lang$core$Native_Basics.not;
var _elm_lang$core$Basics$xor = _elm_lang$core$Native_Basics.xor;
var _elm_lang$core$Basics_ops = _elm_lang$core$Basics_ops || {};
_elm_lang$core$Basics_ops['||'] = _elm_lang$core$Native_Basics.or;
var _elm_lang$core$Basics_ops = _elm_lang$core$Basics_ops || {};
_elm_lang$core$Basics_ops['&&'] = _elm_lang$core$Native_Basics.and;
var _elm_lang$core$Basics$max = _elm_lang$core$Native_Basics.max;
var _elm_lang$core$Basics$min = _elm_lang$core$Native_Basics.min;
var _elm_lang$core$Basics$compare = _elm_lang$core$Native_Basics.compare;
var _elm_lang$core$Basics_ops = _elm_lang$core$Basics_ops || {};
_elm_lang$core$Basics_ops['>='] = _elm_lang$core$Native_Basics.ge;
var _elm_lang$core$Basics_ops = _elm_lang$core$Basics_ops || {};
_elm_lang$core$Basics_ops['<='] = _elm_lang$core$Native_Basics.le;
var _elm_lang$core$Basics_ops = _elm_lang$core$Basics_ops || {};
_elm_lang$core$Basics_ops['>'] = _elm_lang$core$Native_Basics.gt;
var _elm_lang$core$Basics_ops = _elm_lang$core$Basics_ops || {};
_elm_lang$core$Basics_ops['<'] = _elm_lang$core$Native_Basics.lt;
var _elm_lang$core$Basics_ops = _elm_lang$core$Basics_ops || {};
_elm_lang$core$Basics_ops['/='] = _elm_lang$core$Native_Basics.neq;
var _elm_lang$core$Basics_ops = _elm_lang$core$Basics_ops || {};
_elm_lang$core$Basics_ops['=='] = _elm_lang$core$Native_Basics.eq;
var _elm_lang$core$Basics$e = _elm_lang$core$Native_Basics.e;
var _elm_lang$core$Basics$pi = _elm_lang$core$Native_Basics.pi;
var _elm_lang$core$Basics$clamp = _elm_lang$core$Native_Basics.clamp;
var _elm_lang$core$Basics$logBase = _elm_lang$core$Native_Basics.logBase;
var _elm_lang$core$Basics$abs = _elm_lang$core$Native_Basics.abs;
var _elm_lang$core$Basics$negate = _elm_lang$core$Native_Basics.negate;
var _elm_lang$core$Basics$sqrt = _elm_lang$core$Native_Basics.sqrt;
var _elm_lang$core$Basics$atan2 = _elm_lang$core$Native_Basics.atan2;
var _elm_lang$core$Basics$atan = _elm_lang$core$Native_Basics.atan;
var _elm_lang$core$Basics$asin = _elm_lang$core$Native_Basics.asin;
var _elm_lang$core$Basics$acos = _elm_lang$core$Native_Basics.acos;
var _elm_lang$core$Basics$tan = _elm_lang$core$Native_Basics.tan;
var _elm_lang$core$Basics$sin = _elm_lang$core$Native_Basics.sin;
var _elm_lang$core$Basics$cos = _elm_lang$core$Native_Basics.cos;
var _elm_lang$core$Basics_ops = _elm_lang$core$Basics_ops || {};
_elm_lang$core$Basics_ops['^'] = _elm_lang$core$Native_Basics.exp;
var _elm_lang$core$Basics_ops = _elm_lang$core$Basics_ops || {};
_elm_lang$core$Basics_ops['%'] = _elm_lang$core$Native_Basics.mod;
var _elm_lang$core$Basics$rem = _elm_lang$core$Native_Basics.rem;
var _elm_lang$core$Basics_ops = _elm_lang$core$Basics_ops || {};
_elm_lang$core$Basics_ops['//'] = _elm_lang$core$Native_Basics.div;
var _elm_lang$core$Basics_ops = _elm_lang$core$Basics_ops || {};
_elm_lang$core$Basics_ops['/'] = _elm_lang$core$Native_Basics.floatDiv;
var _elm_lang$core$Basics_ops = _elm_lang$core$Basics_ops || {};
_elm_lang$core$Basics_ops['*'] = _elm_lang$core$Native_Basics.mul;
var _elm_lang$core$Basics_ops = _elm_lang$core$Basics_ops || {};
_elm_lang$core$Basics_ops['-'] = _elm_lang$core$Native_Basics.sub;
var _elm_lang$core$Basics_ops = _elm_lang$core$Basics_ops || {};
_elm_lang$core$Basics_ops['+'] = _elm_lang$core$Native_Basics.add;
var _elm_lang$core$Basics$toPolar = _elm_lang$core$Native_Basics.toPolar;
var _elm_lang$core$Basics$fromPolar = _elm_lang$core$Native_Basics.fromPolar;
var _elm_lang$core$Basics$turns = _elm_lang$core$Native_Basics.turns;
var _elm_lang$core$Basics$degrees = _elm_lang$core$Native_Basics.degrees;
var _elm_lang$core$Basics$radians = function (t) {
	return t;
};
var _elm_lang$core$Basics$GT = {ctor: 'GT'};
var _elm_lang$core$Basics$EQ = {ctor: 'EQ'};
var _elm_lang$core$Basics$LT = {ctor: 'LT'};
var _elm_lang$core$Basics$Never = function (a) {
	return {ctor: 'Never', _0: a};
};

//import Native.Utils //

var _elm_lang$core$Native_Debug = function() {

function log(tag, value)
{
	var msg = tag + ': ' + _elm_lang$core$Native_Utils.toString(value);
	var process = process || {};
	if (process.stdout)
	{
		process.stdout.write(msg);
	}
	else
	{
		console.log(msg);
	}
	return value;
}

function crash(message)
{
	throw new Error(message);
}

return {
	crash: crash,
	log: F2(log)
};

}();
var _elm_lang$core$Debug$crash = _elm_lang$core$Native_Debug.crash;
var _elm_lang$core$Debug$log = _elm_lang$core$Native_Debug.log;

var _elm_lang$core$Maybe$withDefault = F2(
	function ($default, maybe) {
		var _p0 = maybe;
		if (_p0.ctor === 'Just') {
			return _p0._0;
		} else {
			return $default;
		}
	});
var _elm_lang$core$Maybe$Nothing = {ctor: 'Nothing'};
var _elm_lang$core$Maybe$oneOf = function (maybes) {
	oneOf:
	while (true) {
		var _p1 = maybes;
		if (_p1.ctor === '[]') {
			return _elm_lang$core$Maybe$Nothing;
		} else {
			var _p3 = _p1._0;
			var _p2 = _p3;
			if (_p2.ctor === 'Nothing') {
				var _v3 = _p1._1;
				maybes = _v3;
				continue oneOf;
			} else {
				return _p3;
			}
		}
	}
};
var _elm_lang$core$Maybe$andThen = F2(
	function (maybeValue, callback) {
		var _p4 = maybeValue;
		if (_p4.ctor === 'Just') {
			return callback(_p4._0);
		} else {
			return _elm_lang$core$Maybe$Nothing;
		}
	});
var _elm_lang$core$Maybe$Just = function (a) {
	return {ctor: 'Just', _0: a};
};
var _elm_lang$core$Maybe$map = F2(
	function (f, maybe) {
		var _p5 = maybe;
		if (_p5.ctor === 'Just') {
			return _elm_lang$core$Maybe$Just(
				f(_p5._0));
		} else {
			return _elm_lang$core$Maybe$Nothing;
		}
	});
var _elm_lang$core$Maybe$map2 = F3(
	function (func, ma, mb) {
		var _p6 = {ctor: '_Tuple2', _0: ma, _1: mb};
		if (((_p6.ctor === '_Tuple2') && (_p6._0.ctor === 'Just')) && (_p6._1.ctor === 'Just')) {
			return _elm_lang$core$Maybe$Just(
				A2(func, _p6._0._0, _p6._1._0));
		} else {
			return _elm_lang$core$Maybe$Nothing;
		}
	});
var _elm_lang$core$Maybe$map3 = F4(
	function (func, ma, mb, mc) {
		var _p7 = {ctor: '_Tuple3', _0: ma, _1: mb, _2: mc};
		if ((((_p7.ctor === '_Tuple3') && (_p7._0.ctor === 'Just')) && (_p7._1.ctor === 'Just')) && (_p7._2.ctor === 'Just')) {
			return _elm_lang$core$Maybe$Just(
				A3(func, _p7._0._0, _p7._1._0, _p7._2._0));
		} else {
			return _elm_lang$core$Maybe$Nothing;
		}
	});
var _elm_lang$core$Maybe$map4 = F5(
	function (func, ma, mb, mc, md) {
		var _p8 = {ctor: '_Tuple4', _0: ma, _1: mb, _2: mc, _3: md};
		if (((((_p8.ctor === '_Tuple4') && (_p8._0.ctor === 'Just')) && (_p8._1.ctor === 'Just')) && (_p8._2.ctor === 'Just')) && (_p8._3.ctor === 'Just')) {
			return _elm_lang$core$Maybe$Just(
				A4(func, _p8._0._0, _p8._1._0, _p8._2._0, _p8._3._0));
		} else {
			return _elm_lang$core$Maybe$Nothing;
		}
	});
var _elm_lang$core$Maybe$map5 = F6(
	function (func, ma, mb, mc, md, me) {
		var _p9 = {ctor: '_Tuple5', _0: ma, _1: mb, _2: mc, _3: md, _4: me};
		if ((((((_p9.ctor === '_Tuple5') && (_p9._0.ctor === 'Just')) && (_p9._1.ctor === 'Just')) && (_p9._2.ctor === 'Just')) && (_p9._3.ctor === 'Just')) && (_p9._4.ctor === 'Just')) {
			return _elm_lang$core$Maybe$Just(
				A5(func, _p9._0._0, _p9._1._0, _p9._2._0, _p9._3._0, _p9._4._0));
		} else {
			return _elm_lang$core$Maybe$Nothing;
		}
	});

//import Native.Utils //

var _elm_lang$core$Native_List = function() {

var Nil = { ctor: '[]' };

function Cons(hd, tl)
{
	return { ctor: '::', _0: hd, _1: tl };
}

function fromArray(arr)
{
	var out = Nil;
	for (var i = arr.length; i--; )
	{
		out = Cons(arr[i], out);
	}
	return out;
}

function toArray(xs)
{
	var out = [];
	while (xs.ctor !== '[]')
	{
		out.push(xs._0);
		xs = xs._1;
	}
	return out;
}


function range(lo, hi)
{
	var list = Nil;
	if (lo <= hi)
	{
		do
		{
			list = Cons(hi, list);
		}
		while (hi-- > lo);
	}
	return list;
}

function foldr(f, b, xs)
{
	var arr = toArray(xs);
	var acc = b;
	for (var i = arr.length; i--; )
	{
		acc = A2(f, arr[i], acc);
	}
	return acc;
}

function map2(f, xs, ys)
{
	var arr = [];
	while (xs.ctor !== '[]' && ys.ctor !== '[]')
	{
		arr.push(A2(f, xs._0, ys._0));
		xs = xs._1;
		ys = ys._1;
	}
	return fromArray(arr);
}

function map3(f, xs, ys, zs)
{
	var arr = [];
	while (xs.ctor !== '[]' && ys.ctor !== '[]' && zs.ctor !== '[]')
	{
		arr.push(A3(f, xs._0, ys._0, zs._0));
		xs = xs._1;
		ys = ys._1;
		zs = zs._1;
	}
	return fromArray(arr);
}

function map4(f, ws, xs, ys, zs)
{
	var arr = [];
	while (   ws.ctor !== '[]'
		   && xs.ctor !== '[]'
		   && ys.ctor !== '[]'
		   && zs.ctor !== '[]')
	{
		arr.push(A4(f, ws._0, xs._0, ys._0, zs._0));
		ws = ws._1;
		xs = xs._1;
		ys = ys._1;
		zs = zs._1;
	}
	return fromArray(arr);
}

function map5(f, vs, ws, xs, ys, zs)
{
	var arr = [];
	while (   vs.ctor !== '[]'
		   && ws.ctor !== '[]'
		   && xs.ctor !== '[]'
		   && ys.ctor !== '[]'
		   && zs.ctor !== '[]')
	{
		arr.push(A5(f, vs._0, ws._0, xs._0, ys._0, zs._0));
		vs = vs._1;
		ws = ws._1;
		xs = xs._1;
		ys = ys._1;
		zs = zs._1;
	}
	return fromArray(arr);
}

function sortBy(f, xs)
{
	return fromArray(toArray(xs).sort(function(a, b) {
		return _elm_lang$core$Native_Utils.cmp(f(a), f(b));
	}));
}

function sortWith(f, xs)
{
	return fromArray(toArray(xs).sort(function(a, b) {
		var ord = f(a)(b).ctor;
		return ord === 'EQ' ? 0 : ord === 'LT' ? -1 : 1;
	}));
}

return {
	Nil: Nil,
	Cons: Cons,
	cons: F2(Cons),
	toArray: toArray,
	fromArray: fromArray,
	range: range,

	foldr: F3(foldr),

	map2: F3(map2),
	map3: F4(map3),
	map4: F5(map4),
	map5: F6(map5),
	sortBy: F2(sortBy),
	sortWith: F2(sortWith)
};

}();
var _elm_lang$core$List$sortWith = _elm_lang$core$Native_List.sortWith;
var _elm_lang$core$List$sortBy = _elm_lang$core$Native_List.sortBy;
var _elm_lang$core$List$sort = function (xs) {
	return A2(_elm_lang$core$List$sortBy, _elm_lang$core$Basics$identity, xs);
};
var _elm_lang$core$List$drop = F2(
	function (n, list) {
		drop:
		while (true) {
			if (_elm_lang$core$Native_Utils.cmp(n, 0) < 1) {
				return list;
			} else {
				var _p0 = list;
				if (_p0.ctor === '[]') {
					return list;
				} else {
					var _v1 = n - 1,
						_v2 = _p0._1;
					n = _v1;
					list = _v2;
					continue drop;
				}
			}
		}
	});
var _elm_lang$core$List$map5 = _elm_lang$core$Native_List.map5;
var _elm_lang$core$List$map4 = _elm_lang$core$Native_List.map4;
var _elm_lang$core$List$map3 = _elm_lang$core$Native_List.map3;
var _elm_lang$core$List$map2 = _elm_lang$core$Native_List.map2;
var _elm_lang$core$List$any = F2(
	function (isOkay, list) {
		any:
		while (true) {
			var _p1 = list;
			if (_p1.ctor === '[]') {
				return false;
			} else {
				if (isOkay(_p1._0)) {
					return true;
				} else {
					var _v4 = isOkay,
						_v5 = _p1._1;
					isOkay = _v4;
					list = _v5;
					continue any;
				}
			}
		}
	});
var _elm_lang$core$List$all = F2(
	function (isOkay, list) {
		return _elm_lang$core$Basics$not(
			A2(
				_elm_lang$core$List$any,
				function (_p2) {
					return _elm_lang$core$Basics$not(
						isOkay(_p2));
				},
				list));
	});
var _elm_lang$core$List$foldr = _elm_lang$core$Native_List.foldr;
var _elm_lang$core$List$foldl = F3(
	function (func, acc, list) {
		foldl:
		while (true) {
			var _p3 = list;
			if (_p3.ctor === '[]') {
				return acc;
			} else {
				var _v7 = func,
					_v8 = A2(func, _p3._0, acc),
					_v9 = _p3._1;
				func = _v7;
				acc = _v8;
				list = _v9;
				continue foldl;
			}
		}
	});
var _elm_lang$core$List$length = function (xs) {
	return A3(
		_elm_lang$core$List$foldl,
		F2(
			function (_p4, i) {
				return i + 1;
			}),
		0,
		xs);
};
var _elm_lang$core$List$sum = function (numbers) {
	return A3(
		_elm_lang$core$List$foldl,
		F2(
			function (x, y) {
				return x + y;
			}),
		0,
		numbers);
};
var _elm_lang$core$List$product = function (numbers) {
	return A3(
		_elm_lang$core$List$foldl,
		F2(
			function (x, y) {
				return x * y;
			}),
		1,
		numbers);
};
var _elm_lang$core$List$maximum = function (list) {
	var _p5 = list;
	if (_p5.ctor === '::') {
		return _elm_lang$core$Maybe$Just(
			A3(_elm_lang$core$List$foldl, _elm_lang$core$Basics$max, _p5._0, _p5._1));
	} else {
		return _elm_lang$core$Maybe$Nothing;
	}
};
var _elm_lang$core$List$minimum = function (list) {
	var _p6 = list;
	if (_p6.ctor === '::') {
		return _elm_lang$core$Maybe$Just(
			A3(_elm_lang$core$List$foldl, _elm_lang$core$Basics$min, _p6._0, _p6._1));
	} else {
		return _elm_lang$core$Maybe$Nothing;
	}
};
var _elm_lang$core$List$indexedMap = F2(
	function (f, xs) {
		return A3(
			_elm_lang$core$List$map2,
			f,
			_elm_lang$core$Native_List.range(
				0,
				_elm_lang$core$List$length(xs) - 1),
			xs);
	});
var _elm_lang$core$List$member = F2(
	function (x, xs) {
		return A2(
			_elm_lang$core$List$any,
			function (a) {
				return _elm_lang$core$Native_Utils.eq(a, x);
			},
			xs);
	});
var _elm_lang$core$List$isEmpty = function (xs) {
	var _p7 = xs;
	if (_p7.ctor === '[]') {
		return true;
	} else {
		return false;
	}
};
var _elm_lang$core$List$tail = function (list) {
	var _p8 = list;
	if (_p8.ctor === '::') {
		return _elm_lang$core$Maybe$Just(_p8._1);
	} else {
		return _elm_lang$core$Maybe$Nothing;
	}
};
var _elm_lang$core$List$head = function (list) {
	var _p9 = list;
	if (_p9.ctor === '::') {
		return _elm_lang$core$Maybe$Just(_p9._0);
	} else {
		return _elm_lang$core$Maybe$Nothing;
	}
};
var _elm_lang$core$List_ops = _elm_lang$core$List_ops || {};
_elm_lang$core$List_ops['::'] = _elm_lang$core$Native_List.cons;
var _elm_lang$core$List$map = F2(
	function (f, xs) {
		return A3(
			_elm_lang$core$List$foldr,
			F2(
				function (x, acc) {
					return A2(
						_elm_lang$core$List_ops['::'],
						f(x),
						acc);
				}),
			_elm_lang$core$Native_List.fromArray(
				[]),
			xs);
	});
var _elm_lang$core$List$filter = F2(
	function (pred, xs) {
		var conditionalCons = F2(
			function (x, xs$) {
				return pred(x) ? A2(_elm_lang$core$List_ops['::'], x, xs$) : xs$;
			});
		return A3(
			_elm_lang$core$List$foldr,
			conditionalCons,
			_elm_lang$core$Native_List.fromArray(
				[]),
			xs);
	});
var _elm_lang$core$List$maybeCons = F3(
	function (f, mx, xs) {
		var _p10 = f(mx);
		if (_p10.ctor === 'Just') {
			return A2(_elm_lang$core$List_ops['::'], _p10._0, xs);
		} else {
			return xs;
		}
	});
var _elm_lang$core$List$filterMap = F2(
	function (f, xs) {
		return A3(
			_elm_lang$core$List$foldr,
			_elm_lang$core$List$maybeCons(f),
			_elm_lang$core$Native_List.fromArray(
				[]),
			xs);
	});
var _elm_lang$core$List$reverse = function (list) {
	return A3(
		_elm_lang$core$List$foldl,
		F2(
			function (x, y) {
				return A2(_elm_lang$core$List_ops['::'], x, y);
			}),
		_elm_lang$core$Native_List.fromArray(
			[]),
		list);
};
var _elm_lang$core$List$scanl = F3(
	function (f, b, xs) {
		var scan1 = F2(
			function (x, accAcc) {
				var _p11 = accAcc;
				if (_p11.ctor === '::') {
					return A2(
						_elm_lang$core$List_ops['::'],
						A2(f, x, _p11._0),
						accAcc);
				} else {
					return _elm_lang$core$Native_List.fromArray(
						[]);
				}
			});
		return _elm_lang$core$List$reverse(
			A3(
				_elm_lang$core$List$foldl,
				scan1,
				_elm_lang$core$Native_List.fromArray(
					[b]),
				xs));
	});
var _elm_lang$core$List$append = F2(
	function (xs, ys) {
		var _p12 = ys;
		if (_p12.ctor === '[]') {
			return xs;
		} else {
			return A3(
				_elm_lang$core$List$foldr,
				F2(
					function (x, y) {
						return A2(_elm_lang$core$List_ops['::'], x, y);
					}),
				ys,
				xs);
		}
	});
var _elm_lang$core$List$concat = function (lists) {
	return A3(
		_elm_lang$core$List$foldr,
		_elm_lang$core$List$append,
		_elm_lang$core$Native_List.fromArray(
			[]),
		lists);
};
var _elm_lang$core$List$concatMap = F2(
	function (f, list) {
		return _elm_lang$core$List$concat(
			A2(_elm_lang$core$List$map, f, list));
	});
var _elm_lang$core$List$partition = F2(
	function (pred, list) {
		var step = F2(
			function (x, _p13) {
				var _p14 = _p13;
				var _p16 = _p14._0;
				var _p15 = _p14._1;
				return pred(x) ? {
					ctor: '_Tuple2',
					_0: A2(_elm_lang$core$List_ops['::'], x, _p16),
					_1: _p15
				} : {
					ctor: '_Tuple2',
					_0: _p16,
					_1: A2(_elm_lang$core$List_ops['::'], x, _p15)
				};
			});
		return A3(
			_elm_lang$core$List$foldr,
			step,
			{
				ctor: '_Tuple2',
				_0: _elm_lang$core$Native_List.fromArray(
					[]),
				_1: _elm_lang$core$Native_List.fromArray(
					[])
			},
			list);
	});
var _elm_lang$core$List$unzip = function (pairs) {
	var step = F2(
		function (_p18, _p17) {
			var _p19 = _p18;
			var _p20 = _p17;
			return {
				ctor: '_Tuple2',
				_0: A2(_elm_lang$core$List_ops['::'], _p19._0, _p20._0),
				_1: A2(_elm_lang$core$List_ops['::'], _p19._1, _p20._1)
			};
		});
	return A3(
		_elm_lang$core$List$foldr,
		step,
		{
			ctor: '_Tuple2',
			_0: _elm_lang$core$Native_List.fromArray(
				[]),
			_1: _elm_lang$core$Native_List.fromArray(
				[])
		},
		pairs);
};
var _elm_lang$core$List$intersperse = F2(
	function (sep, xs) {
		var _p21 = xs;
		if (_p21.ctor === '[]') {
			return _elm_lang$core$Native_List.fromArray(
				[]);
		} else {
			var step = F2(
				function (x, rest) {
					return A2(
						_elm_lang$core$List_ops['::'],
						sep,
						A2(_elm_lang$core$List_ops['::'], x, rest));
				});
			var spersed = A3(
				_elm_lang$core$List$foldr,
				step,
				_elm_lang$core$Native_List.fromArray(
					[]),
				_p21._1);
			return A2(_elm_lang$core$List_ops['::'], _p21._0, spersed);
		}
	});
var _elm_lang$core$List$takeReverse = F3(
	function (n, list, taken) {
		takeReverse:
		while (true) {
			if (_elm_lang$core$Native_Utils.cmp(n, 0) < 1) {
				return taken;
			} else {
				var _p22 = list;
				if (_p22.ctor === '[]') {
					return taken;
				} else {
					var _v23 = n - 1,
						_v24 = _p22._1,
						_v25 = A2(_elm_lang$core$List_ops['::'], _p22._0, taken);
					n = _v23;
					list = _v24;
					taken = _v25;
					continue takeReverse;
				}
			}
		}
	});
var _elm_lang$core$List$takeTailRec = F2(
	function (n, list) {
		return _elm_lang$core$List$reverse(
			A3(
				_elm_lang$core$List$takeReverse,
				n,
				list,
				_elm_lang$core$Native_List.fromArray(
					[])));
	});
var _elm_lang$core$List$takeFast = F3(
	function (ctr, n, list) {
		if (_elm_lang$core$Native_Utils.cmp(n, 0) < 1) {
			return _elm_lang$core$Native_List.fromArray(
				[]);
		} else {
			var _p23 = {ctor: '_Tuple2', _0: n, _1: list};
			_v26_5:
			do {
				_v26_1:
				do {
					if (_p23.ctor === '_Tuple2') {
						if (_p23._1.ctor === '[]') {
							return list;
						} else {
							if (_p23._1._1.ctor === '::') {
								switch (_p23._0) {
									case 1:
										break _v26_1;
									case 2:
										return _elm_lang$core$Native_List.fromArray(
											[_p23._1._0, _p23._1._1._0]);
									case 3:
										if (_p23._1._1._1.ctor === '::') {
											return _elm_lang$core$Native_List.fromArray(
												[_p23._1._0, _p23._1._1._0, _p23._1._1._1._0]);
										} else {
											break _v26_5;
										}
									default:
										if ((_p23._1._1._1.ctor === '::') && (_p23._1._1._1._1.ctor === '::')) {
											var _p28 = _p23._1._1._1._0;
											var _p27 = _p23._1._1._0;
											var _p26 = _p23._1._0;
											var _p25 = _p23._1._1._1._1._0;
											var _p24 = _p23._1._1._1._1._1;
											return (_elm_lang$core$Native_Utils.cmp(ctr, 1000) > 0) ? A2(
												_elm_lang$core$List_ops['::'],
												_p26,
												A2(
													_elm_lang$core$List_ops['::'],
													_p27,
													A2(
														_elm_lang$core$List_ops['::'],
														_p28,
														A2(
															_elm_lang$core$List_ops['::'],
															_p25,
															A2(_elm_lang$core$List$takeTailRec, n - 4, _p24))))) : A2(
												_elm_lang$core$List_ops['::'],
												_p26,
												A2(
													_elm_lang$core$List_ops['::'],
													_p27,
													A2(
														_elm_lang$core$List_ops['::'],
														_p28,
														A2(
															_elm_lang$core$List_ops['::'],
															_p25,
															A3(_elm_lang$core$List$takeFast, ctr + 1, n - 4, _p24)))));
										} else {
											break _v26_5;
										}
								}
							} else {
								if (_p23._0 === 1) {
									break _v26_1;
								} else {
									break _v26_5;
								}
							}
						}
					} else {
						break _v26_5;
					}
				} while(false);
				return _elm_lang$core$Native_List.fromArray(
					[_p23._1._0]);
			} while(false);
			return list;
		}
	});
var _elm_lang$core$List$take = F2(
	function (n, list) {
		return A3(_elm_lang$core$List$takeFast, 0, n, list);
	});
var _elm_lang$core$List$repeatHelp = F3(
	function (result, n, value) {
		repeatHelp:
		while (true) {
			if (_elm_lang$core$Native_Utils.cmp(n, 0) < 1) {
				return result;
			} else {
				var _v27 = A2(_elm_lang$core$List_ops['::'], value, result),
					_v28 = n - 1,
					_v29 = value;
				result = _v27;
				n = _v28;
				value = _v29;
				continue repeatHelp;
			}
		}
	});
var _elm_lang$core$List$repeat = F2(
	function (n, value) {
		return A3(
			_elm_lang$core$List$repeatHelp,
			_elm_lang$core$Native_List.fromArray(
				[]),
			n,
			value);
	});

var _elm_lang$core$Result$toMaybe = function (result) {
	var _p0 = result;
	if (_p0.ctor === 'Ok') {
		return _elm_lang$core$Maybe$Just(_p0._0);
	} else {
		return _elm_lang$core$Maybe$Nothing;
	}
};
var _elm_lang$core$Result$withDefault = F2(
	function (def, result) {
		var _p1 = result;
		if (_p1.ctor === 'Ok') {
			return _p1._0;
		} else {
			return def;
		}
	});
var _elm_lang$core$Result$Err = function (a) {
	return {ctor: 'Err', _0: a};
};
var _elm_lang$core$Result$andThen = F2(
	function (result, callback) {
		var _p2 = result;
		if (_p2.ctor === 'Ok') {
			return callback(_p2._0);
		} else {
			return _elm_lang$core$Result$Err(_p2._0);
		}
	});
var _elm_lang$core$Result$Ok = function (a) {
	return {ctor: 'Ok', _0: a};
};
var _elm_lang$core$Result$map = F2(
	function (func, ra) {
		var _p3 = ra;
		if (_p3.ctor === 'Ok') {
			return _elm_lang$core$Result$Ok(
				func(_p3._0));
		} else {
			return _elm_lang$core$Result$Err(_p3._0);
		}
	});
var _elm_lang$core$Result$map2 = F3(
	function (func, ra, rb) {
		var _p4 = {ctor: '_Tuple2', _0: ra, _1: rb};
		if (_p4._0.ctor === 'Ok') {
			if (_p4._1.ctor === 'Ok') {
				return _elm_lang$core$Result$Ok(
					A2(func, _p4._0._0, _p4._1._0));
			} else {
				return _elm_lang$core$Result$Err(_p4._1._0);
			}
		} else {
			return _elm_lang$core$Result$Err(_p4._0._0);
		}
	});
var _elm_lang$core$Result$map3 = F4(
	function (func, ra, rb, rc) {
		var _p5 = {ctor: '_Tuple3', _0: ra, _1: rb, _2: rc};
		if (_p5._0.ctor === 'Ok') {
			if (_p5._1.ctor === 'Ok') {
				if (_p5._2.ctor === 'Ok') {
					return _elm_lang$core$Result$Ok(
						A3(func, _p5._0._0, _p5._1._0, _p5._2._0));
				} else {
					return _elm_lang$core$Result$Err(_p5._2._0);
				}
			} else {
				return _elm_lang$core$Result$Err(_p5._1._0);
			}
		} else {
			return _elm_lang$core$Result$Err(_p5._0._0);
		}
	});
var _elm_lang$core$Result$map4 = F5(
	function (func, ra, rb, rc, rd) {
		var _p6 = {ctor: '_Tuple4', _0: ra, _1: rb, _2: rc, _3: rd};
		if (_p6._0.ctor === 'Ok') {
			if (_p6._1.ctor === 'Ok') {
				if (_p6._2.ctor === 'Ok') {
					if (_p6._3.ctor === 'Ok') {
						return _elm_lang$core$Result$Ok(
							A4(func, _p6._0._0, _p6._1._0, _p6._2._0, _p6._3._0));
					} else {
						return _elm_lang$core$Result$Err(_p6._3._0);
					}
				} else {
					return _elm_lang$core$Result$Err(_p6._2._0);
				}
			} else {
				return _elm_lang$core$Result$Err(_p6._1._0);
			}
		} else {
			return _elm_lang$core$Result$Err(_p6._0._0);
		}
	});
var _elm_lang$core$Result$map5 = F6(
	function (func, ra, rb, rc, rd, re) {
		var _p7 = {ctor: '_Tuple5', _0: ra, _1: rb, _2: rc, _3: rd, _4: re};
		if (_p7._0.ctor === 'Ok') {
			if (_p7._1.ctor === 'Ok') {
				if (_p7._2.ctor === 'Ok') {
					if (_p7._3.ctor === 'Ok') {
						if (_p7._4.ctor === 'Ok') {
							return _elm_lang$core$Result$Ok(
								A5(func, _p7._0._0, _p7._1._0, _p7._2._0, _p7._3._0, _p7._4._0));
						} else {
							return _elm_lang$core$Result$Err(_p7._4._0);
						}
					} else {
						return _elm_lang$core$Result$Err(_p7._3._0);
					}
				} else {
					return _elm_lang$core$Result$Err(_p7._2._0);
				}
			} else {
				return _elm_lang$core$Result$Err(_p7._1._0);
			}
		} else {
			return _elm_lang$core$Result$Err(_p7._0._0);
		}
	});
var _elm_lang$core$Result$formatError = F2(
	function (f, result) {
		var _p8 = result;
		if (_p8.ctor === 'Ok') {
			return _elm_lang$core$Result$Ok(_p8._0);
		} else {
			return _elm_lang$core$Result$Err(
				f(_p8._0));
		}
	});
var _elm_lang$core$Result$fromMaybe = F2(
	function (err, maybe) {
		var _p9 = maybe;
		if (_p9.ctor === 'Just') {
			return _elm_lang$core$Result$Ok(_p9._0);
		} else {
			return _elm_lang$core$Result$Err(err);
		}
	});

//import //

var _elm_lang$core$Native_Platform = function() {


// PROGRAMS

function addPublicModule(object, name, main)
{
	var init = main ? makeEmbed(name, main) : mainIsUndefined(name);

	object['worker'] = function worker(flags)
	{
		return init(undefined, flags, false);
	}

	object['embed'] = function embed(domNode, flags)
	{
		return init(domNode, flags, true);
	}

	object['fullscreen'] = function fullscreen(flags)
	{
		return init(document.body, flags, true);
	};
}


// PROGRAM FAIL

function mainIsUndefined(name)
{
	return function(domNode)
	{
		var message = 'Cannot initialize module `' + name +
			'` because it has no `main` value!\nWhat should I show on screen?';
		domNode.innerHTML = errorHtml(message);
		throw new Error(message);
	};
}

function errorHtml(message)
{
	return '<div style="padding-left:1em;">'
		+ '<h2 style="font-weight:normal;"><b>Oops!</b> Something went wrong when starting your Elm program.</h2>'
		+ '<pre style="padding-left:1em;">' + message + '</pre>'
		+ '</div>';
}


// PROGRAM SUCCESS

function makeEmbed(moduleName, main)
{
	return function embed(rootDomNode, flags, withRenderer)
	{
		try
		{
			var program = mainToProgram(moduleName, main);
			if (!withRenderer)
			{
				program.renderer = dummyRenderer;
			}
			return makeEmbedHelp(moduleName, program, rootDomNode, flags);
		}
		catch (e)
		{
			rootDomNode.innerHTML = errorHtml(e.message);
			throw e;
		}
	};
}

function dummyRenderer()
{
	return { update: function() {} };
}


// MAIN TO PROGRAM

function mainToProgram(moduleName, wrappedMain)
{
	var main = wrappedMain.main;

	if (typeof main.init === 'undefined')
	{
		var emptyBag = batch(_elm_lang$core$Native_List.Nil);
		var noChange = _elm_lang$core$Native_Utils.Tuple2(
			_elm_lang$core$Native_Utils.Tuple0,
			emptyBag
		);

		return _elm_lang$virtual_dom$VirtualDom$programWithFlags({
			init: function() { return noChange; },
			view: function() { return main; },
			update: F2(function() { return noChange; }),
			subscriptions: function () { return emptyBag; }
		});
	}

	var flags = wrappedMain.flags;
	var init = flags
		? initWithFlags(moduleName, main.init, flags)
		: initWithoutFlags(moduleName, main.init);

	return _elm_lang$virtual_dom$VirtualDom$programWithFlags({
		init: init,
		view: main.view,
		update: main.update,
		subscriptions: main.subscriptions,
	});
}

function initWithoutFlags(moduleName, realInit)
{
	return function init(flags)
	{
		if (typeof flags !== 'undefined')
		{
			throw new Error(
				'You are giving module `' + moduleName + '` an argument in JavaScript.\n'
				+ 'This module does not take arguments though! You probably need to change the\n'
				+ 'initialization code to something like `Elm.' + moduleName + '.fullscreen()`'
			);
		}
		return realInit();
	};
}

function initWithFlags(moduleName, realInit, flagDecoder)
{
	return function init(flags)
	{
		var result = A2(_elm_lang$core$Native_Json.run, flagDecoder, flags);
		if (result.ctor === 'Err')
		{
			throw new Error(
				'You are trying to initialize module `' + moduleName + '` with an unexpected argument.\n'
				+ 'When trying to convert it to a usable Elm value, I run into this problem:\n\n'
				+ result._0
			);
		}
		return realInit(result._0);
	};
}


// SETUP RUNTIME SYSTEM

function makeEmbedHelp(moduleName, program, rootDomNode, flags)
{
	var init = program.init;
	var update = program.update;
	var subscriptions = program.subscriptions;
	var view = program.view;
	var makeRenderer = program.renderer;

	// ambient state
	var managers = {};
	var renderer;

	// init and update state in main process
	var initApp = _elm_lang$core$Native_Scheduler.nativeBinding(function(callback) {
		var results = init(flags);
		var model = results._0;
		renderer = makeRenderer(rootDomNode, enqueue, view(model));
		var cmds = results._1;
		var subs = subscriptions(model);
		dispatchEffects(managers, cmds, subs);
		callback(_elm_lang$core$Native_Scheduler.succeed(model));
	});

	function onMessage(msg, model)
	{
		return _elm_lang$core$Native_Scheduler.nativeBinding(function(callback) {
			var results = A2(update, msg, model);
			model = results._0;
			renderer.update(view(model));
			var cmds = results._1;
			var subs = subscriptions(model);
			dispatchEffects(managers, cmds, subs);
			callback(_elm_lang$core$Native_Scheduler.succeed(model));
		});
	}

	var mainProcess = spawnLoop(initApp, onMessage);

	function enqueue(msg)
	{
		_elm_lang$core$Native_Scheduler.rawSend(mainProcess, msg);
	}

	var ports = setupEffects(managers, enqueue);

	return ports ? { ports: ports } : {};
}


// EFFECT MANAGERS

var effectManagers = {};

function setupEffects(managers, callback)
{
	var ports;

	// setup all necessary effect managers
	for (var key in effectManagers)
	{
		var manager = effectManagers[key];

		if (manager.isForeign)
		{
			ports = ports || {};
			ports[key] = manager.tag === 'cmd'
				? setupOutgoingPort(key)
				: setupIncomingPort(key, callback);
		}

		managers[key] = makeManager(manager, callback);
	}

	return ports;
}

function makeManager(info, callback)
{
	var router = {
		main: callback,
		self: undefined
	};

	var tag = info.tag;
	var onEffects = info.onEffects;
	var onSelfMsg = info.onSelfMsg;

	function onMessage(msg, state)
	{
		if (msg.ctor === 'self')
		{
			return A3(onSelfMsg, router, msg._0, state);
		}

		var fx = msg._0;
		switch (tag)
		{
			case 'cmd':
				return A3(onEffects, router, fx.cmds, state);

			case 'sub':
				return A3(onEffects, router, fx.subs, state);

			case 'fx':
				return A4(onEffects, router, fx.cmds, fx.subs, state);
		}
	}

	var process = spawnLoop(info.init, onMessage);
	router.self = process;
	return process;
}

function sendToApp(router, msg)
{
	return _elm_lang$core$Native_Scheduler.nativeBinding(function(callback)
	{
		router.main(msg);
		callback(_elm_lang$core$Native_Scheduler.succeed(_elm_lang$core$Native_Utils.Tuple0));
	});
}

function sendToSelf(router, msg)
{
	return A2(_elm_lang$core$Native_Scheduler.send, router.self, {
		ctor: 'self',
		_0: msg
	});
}


// HELPER for STATEFUL LOOPS

function spawnLoop(init, onMessage)
{
	var andThen = _elm_lang$core$Native_Scheduler.andThen;

	function loop(state)
	{
		var handleMsg = _elm_lang$core$Native_Scheduler.receive(function(msg) {
			return onMessage(msg, state);
		});
		return A2(andThen, handleMsg, loop);
	}

	var task = A2(andThen, init, loop);

	return _elm_lang$core$Native_Scheduler.rawSpawn(task);
}


// BAGS

function leaf(home)
{
	return function(value)
	{
		return {
			type: 'leaf',
			home: home,
			value: value
		};
	};
}

function batch(list)
{
	return {
		type: 'node',
		branches: list
	};
}

function map(tagger, bag)
{
	return {
		type: 'map',
		tagger: tagger,
		tree: bag
	}
}


// PIPE BAGS INTO EFFECT MANAGERS

function dispatchEffects(managers, cmdBag, subBag)
{
	var effectsDict = {};
	gatherEffects(true, cmdBag, effectsDict, null);
	gatherEffects(false, subBag, effectsDict, null);

	for (var home in managers)
	{
		var fx = home in effectsDict
			? effectsDict[home]
			: {
				cmds: _elm_lang$core$Native_List.Nil,
				subs: _elm_lang$core$Native_List.Nil
			};

		_elm_lang$core$Native_Scheduler.rawSend(managers[home], { ctor: 'fx', _0: fx });
	}
}

function gatherEffects(isCmd, bag, effectsDict, taggers)
{
	switch (bag.type)
	{
		case 'leaf':
			var home = bag.home;
			var effect = toEffect(isCmd, home, taggers, bag.value);
			effectsDict[home] = insert(isCmd, effect, effectsDict[home]);
			return;

		case 'node':
			var list = bag.branches;
			while (list.ctor !== '[]')
			{
				gatherEffects(isCmd, list._0, effectsDict, taggers);
				list = list._1;
			}
			return;

		case 'map':
			gatherEffects(isCmd, bag.tree, effectsDict, {
				tagger: bag.tagger,
				rest: taggers
			});
			return;
	}
}

function toEffect(isCmd, home, taggers, value)
{
	function applyTaggers(x)
	{
		var temp = taggers;
		while (temp)
		{
			x = temp.tagger(x);
			temp = temp.rest;
		}
		return x;
	}

	var map = isCmd
		? effectManagers[home].cmdMap
		: effectManagers[home].subMap;

	return A2(map, applyTaggers, value)
}

function insert(isCmd, newEffect, effects)
{
	effects = effects || {
		cmds: _elm_lang$core$Native_List.Nil,
		subs: _elm_lang$core$Native_List.Nil
	};
	if (isCmd)
	{
		effects.cmds = _elm_lang$core$Native_List.Cons(newEffect, effects.cmds);
		return effects;
	}
	effects.subs = _elm_lang$core$Native_List.Cons(newEffect, effects.subs);
	return effects;
}


// PORTS

function checkPortName(name)
{
	if (name in effectManagers)
	{
		throw new Error('There can only be one port named `' + name + '`, but your program has multiple.');
	}
}


// OUTGOING PORTS

function outgoingPort(name, converter)
{
	checkPortName(name);
	effectManagers[name] = {
		tag: 'cmd',
		cmdMap: outgoingPortMap,
		converter: converter,
		isForeign: true
	};
	return leaf(name);
}

var outgoingPortMap = F2(function cmdMap(tagger, value) {
	return value;
});

function setupOutgoingPort(name)
{
	var subs = [];
	var converter = effectManagers[name].converter;

	// CREATE MANAGER

	var init = _elm_lang$core$Native_Scheduler.succeed(null);

	function onEffects(router, cmdList, state)
	{
		while (cmdList.ctor !== '[]')
		{
			var value = converter(cmdList._0);
			for (var i = 0; i < subs.length; i++)
			{
				subs[i](value);
			}
			cmdList = cmdList._1;
		}
		return init;
	}

	effectManagers[name].init = init;
	effectManagers[name].onEffects = F3(onEffects);

	// PUBLIC API

	function subscribe(callback)
	{
		subs.push(callback);
	}

	function unsubscribe(callback)
	{
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

function incomingPort(name, converter)
{
	checkPortName(name);
	effectManagers[name] = {
		tag: 'sub',
		subMap: incomingPortMap,
		converter: converter,
		isForeign: true
	};
	return leaf(name);
}

var incomingPortMap = F2(function subMap(tagger, finalTagger)
{
	return function(value)
	{
		return tagger(finalTagger(value));
	};
});

function setupIncomingPort(name, callback)
{
	var sentBeforeInit = [];
	var subs = _elm_lang$core$Native_List.Nil;
	var converter = effectManagers[name].converter;
	var currentOnEffects = preInitOnEffects;
	var currentSend = preInitSend;

	// CREATE MANAGER

	var init = _elm_lang$core$Native_Scheduler.succeed(null);

	function preInitOnEffects(router, subList, state)
	{
		var postInitResult = postInitOnEffects(router, subList, state);

		for(var i = 0; i < sentBeforeInit.length; i++)
		{
			postInitSend(sentBeforeInit[i]);
		}

		sentBeforeInit = null; // to release objects held in queue
		currentSend = postInitSend;
		currentOnEffects = postInitOnEffects;
		return postInitResult;
	}

	function postInitOnEffects(router, subList, state)
	{
		subs = subList;
		return init;
	}

	function onEffects(router, subList, state)
	{
		return currentOnEffects(router, subList, state);
	}

	effectManagers[name].init = init;
	effectManagers[name].onEffects = F3(onEffects);

	// PUBLIC API

	function preInitSend(value)
	{
		sentBeforeInit.push(value);
	}

	function postInitSend(incomingValue)
	{
		var result = A2(_elm_lang$core$Json_Decode$decodeValue, converter, incomingValue);
		if (result.ctor === 'Err')
		{
			throw new Error('Trying to send an unexpected type of value through port `' + name + '`:\n' + result._0);
		}

		var value = result._0;
		var temp = subs;
		while (temp.ctor !== '[]')
		{
			callback(temp._0(value));
			temp = temp._1;
		}
	}

	function send(incomingValue)
	{
		currentSend(incomingValue);
	}

	return { send: send };
}

return {
	// routers
	sendToApp: F2(sendToApp),
	sendToSelf: F2(sendToSelf),

	// global setup
	mainToProgram: mainToProgram,
	effectManagers: effectManagers,
	outgoingPort: outgoingPort,
	incomingPort: incomingPort,
	addPublicModule: addPublicModule,

	// effect bags
	leaf: leaf,
	batch: batch,
	map: F2(map)
};

}();

//import Native.Utils //

var _elm_lang$core$Native_Scheduler = function() {

var MAX_STEPS = 10000;


// TASKS

function succeed(value)
{
	return {
		ctor: '_Task_succeed',
		value: value
	};
}

function fail(error)
{
	return {
		ctor: '_Task_fail',
		value: error
	};
}

function nativeBinding(callback)
{
	return {
		ctor: '_Task_nativeBinding',
		callback: callback,
		cancel: null
	};
}

function andThen(task, callback)
{
	return {
		ctor: '_Task_andThen',
		task: task,
		callback: callback
	};
}

function onError(task, callback)
{
	return {
		ctor: '_Task_onError',
		task: task,
		callback: callback
	};
}

function receive(callback)
{
	return {
		ctor: '_Task_receive',
		callback: callback
	};
}


// PROCESSES

function rawSpawn(task)
{
	var process = {
		ctor: '_Process',
		id: _elm_lang$core$Native_Utils.guid(),
		root: task,
		stack: null,
		mailbox: []
	};

	enqueue(process);

	return process;
}

function spawn(task)
{
	return nativeBinding(function(callback) {
		var process = rawSpawn(task);
		callback(succeed(process));
	});
}

function rawSend(process, msg)
{
	process.mailbox.push(msg);
	enqueue(process);
}

function send(process, msg)
{
	return nativeBinding(function(callback) {
		rawSend(process, msg);
		callback(succeed(_elm_lang$core$Native_Utils.Tuple0));
	});
}

function kill(process)
{
	return nativeBinding(function(callback) {
		var root = process.root;
		if (root.ctor === '_Task_nativeBinding' && root.cancel)
		{
			root.cancel();
		}

		process.root = null;

		callback(succeed(_elm_lang$core$Native_Utils.Tuple0));
	});
}

function sleep(time)
{
	return nativeBinding(function(callback) {
		var id = setTimeout(function() {
			callback(succeed(_elm_lang$core$Native_Utils.Tuple0));
		}, time);

		return function() { clearTimeout(id); };
	});
}


// STEP PROCESSES

function step(numSteps, process)
{
	while (numSteps < MAX_STEPS)
	{
		var ctor = process.root.ctor;

		if (ctor === '_Task_succeed')
		{
			while (process.stack && process.stack.ctor === '_Task_onError')
			{
				process.stack = process.stack.rest;
			}
			if (process.stack === null)
			{
				break;
			}
			process.root = process.stack.callback(process.root.value);
			process.stack = process.stack.rest;
			++numSteps;
			continue;
		}

		if (ctor === '_Task_fail')
		{
			while (process.stack && process.stack.ctor === '_Task_andThen')
			{
				process.stack = process.stack.rest;
			}
			if (process.stack === null)
			{
				break;
			}
			process.root = process.stack.callback(process.root.value);
			process.stack = process.stack.rest;
			++numSteps;
			continue;
		}

		if (ctor === '_Task_andThen')
		{
			process.stack = {
				ctor: '_Task_andThen',
				callback: process.root.callback,
				rest: process.stack
			};
			process.root = process.root.task;
			++numSteps;
			continue;
		}

		if (ctor === '_Task_onError')
		{
			process.stack = {
				ctor: '_Task_onError',
				callback: process.root.callback,
				rest: process.stack
			};
			process.root = process.root.task;
			++numSteps;
			continue;
		}

		if (ctor === '_Task_nativeBinding')
		{
			process.root.cancel = process.root.callback(function(newRoot) {
				process.root = newRoot;
				enqueue(process);
			});

			break;
		}

		if (ctor === '_Task_receive')
		{
			var mailbox = process.mailbox;
			if (mailbox.length === 0)
			{
				break;
			}

			process.root = process.root.callback(mailbox.shift());
			++numSteps;
			continue;
		}

		throw new Error(ctor);
	}

	if (numSteps < MAX_STEPS)
	{
		return numSteps + 1;
	}
	enqueue(process);

	return numSteps;
}


// WORK QUEUE

var working = false;
var workQueue = [];

function enqueue(process)
{
	workQueue.push(process);

	if (!working)
	{
		setTimeout(work, 0);
		working = true;
	}
}

function work()
{
	var numSteps = 0;
	var process;
	while (numSteps < MAX_STEPS && (process = workQueue.shift()))
	{
		if (process.root)
		{
			numSteps = step(numSteps, process);
		}
	}
	if (!process)
	{
		working = false;
		return;
	}
	setTimeout(work, 0);
}


return {
	succeed: succeed,
	fail: fail,
	nativeBinding: nativeBinding,
	andThen: F2(andThen),
	onError: F2(onError),
	receive: receive,

	spawn: spawn,
	kill: kill,
	sleep: sleep,
	send: F2(send),

	rawSpawn: rawSpawn,
	rawSend: rawSend
};

}();
var _elm_lang$core$Platform$hack = _elm_lang$core$Native_Scheduler.succeed;
var _elm_lang$core$Platform$sendToSelf = _elm_lang$core$Native_Platform.sendToSelf;
var _elm_lang$core$Platform$sendToApp = _elm_lang$core$Native_Platform.sendToApp;
var _elm_lang$core$Platform$Program = {ctor: 'Program'};
var _elm_lang$core$Platform$Task = {ctor: 'Task'};
var _elm_lang$core$Platform$ProcessId = {ctor: 'ProcessId'};
var _elm_lang$core$Platform$Router = {ctor: 'Router'};

var _elm_lang$core$Platform_Cmd$batch = _elm_lang$core$Native_Platform.batch;
var _elm_lang$core$Platform_Cmd$none = _elm_lang$core$Platform_Cmd$batch(
	_elm_lang$core$Native_List.fromArray(
		[]));
var _elm_lang$core$Platform_Cmd_ops = _elm_lang$core$Platform_Cmd_ops || {};
_elm_lang$core$Platform_Cmd_ops['!'] = F2(
	function (model, commands) {
		return {
			ctor: '_Tuple2',
			_0: model,
			_1: _elm_lang$core$Platform_Cmd$batch(commands)
		};
	});
var _elm_lang$core$Platform_Cmd$map = _elm_lang$core$Native_Platform.map;
var _elm_lang$core$Platform_Cmd$Cmd = {ctor: 'Cmd'};

var _elm_lang$core$Platform_Sub$batch = _elm_lang$core$Native_Platform.batch;
var _elm_lang$core$Platform_Sub$none = _elm_lang$core$Platform_Sub$batch(
	_elm_lang$core$Native_List.fromArray(
		[]));
var _elm_lang$core$Platform_Sub$map = _elm_lang$core$Native_Platform.map;
var _elm_lang$core$Platform_Sub$Sub = {ctor: 'Sub'};

//import Native.List //

var _elm_lang$core$Native_Array = function() {

// A RRB-Tree has two distinct data types.
// Leaf -> "height"  is always 0
//         "table"   is an array of elements
// Node -> "height"  is always greater than 0
//         "table"   is an array of child nodes
//         "lengths" is an array of accumulated lengths of the child nodes

// M is the maximal table size. 32 seems fast. E is the allowed increase
// of search steps when concatting to find an index. Lower values will
// decrease balancing, but will increase search steps.
var M = 32;
var E = 2;

// An empty array.
var empty = {
	ctor: '_Array',
	height: 0,
	table: []
};


function get(i, array)
{
	if (i < 0 || i >= length(array))
	{
		throw new Error(
			'Index ' + i + ' is out of range. Check the length of ' +
			'your array first or use getMaybe or getWithDefault.');
	}
	return unsafeGet(i, array);
}


function unsafeGet(i, array)
{
	for (var x = array.height; x > 0; x--)
	{
		var slot = i >> (x * 5);
		while (array.lengths[slot] <= i)
		{
			slot++;
		}
		if (slot > 0)
		{
			i -= array.lengths[slot - 1];
		}
		array = array.table[slot];
	}
	return array.table[i];
}


// Sets the value at the index i. Only the nodes leading to i will get
// copied and updated.
function set(i, item, array)
{
	if (i < 0 || length(array) <= i)
	{
		return array;
	}
	return unsafeSet(i, item, array);
}


function unsafeSet(i, item, array)
{
	array = nodeCopy(array);

	if (array.height === 0)
	{
		array.table[i] = item;
	}
	else
	{
		var slot = getSlot(i, array);
		if (slot > 0)
		{
			i -= array.lengths[slot - 1];
		}
		array.table[slot] = unsafeSet(i, item, array.table[slot]);
	}
	return array;
}


function initialize(len, f)
{
	if (len <= 0)
	{
		return empty;
	}
	var h = Math.floor( Math.log(len) / Math.log(M) );
	return initialize_(f, h, 0, len);
}

function initialize_(f, h, from, to)
{
	if (h === 0)
	{
		var table = new Array((to - from) % (M + 1));
		for (var i = 0; i < table.length; i++)
		{
		  table[i] = f(from + i);
		}
		return {
			ctor: '_Array',
			height: 0,
			table: table
		};
	}

	var step = Math.pow(M, h);
	var table = new Array(Math.ceil((to - from) / step));
	var lengths = new Array(table.length);
	for (var i = 0; i < table.length; i++)
	{
		table[i] = initialize_(f, h - 1, from + (i * step), Math.min(from + ((i + 1) * step), to));
		lengths[i] = length(table[i]) + (i > 0 ? lengths[i-1] : 0);
	}
	return {
		ctor: '_Array',
		height: h,
		table: table,
		lengths: lengths
	};
}

function fromList(list)
{
	if (list.ctor === '[]')
	{
		return empty;
	}

	// Allocate M sized blocks (table) and write list elements to it.
	var table = new Array(M);
	var nodes = [];
	var i = 0;

	while (list.ctor !== '[]')
	{
		table[i] = list._0;
		list = list._1;
		i++;

		// table is full, so we can push a leaf containing it into the
		// next node.
		if (i === M)
		{
			var leaf = {
				ctor: '_Array',
				height: 0,
				table: table
			};
			fromListPush(leaf, nodes);
			table = new Array(M);
			i = 0;
		}
	}

	// Maybe there is something left on the table.
	if (i > 0)
	{
		var leaf = {
			ctor: '_Array',
			height: 0,
			table: table.splice(0, i)
		};
		fromListPush(leaf, nodes);
	}

	// Go through all of the nodes and eventually push them into higher nodes.
	for (var h = 0; h < nodes.length - 1; h++)
	{
		if (nodes[h].table.length > 0)
		{
			fromListPush(nodes[h], nodes);
		}
	}

	var head = nodes[nodes.length - 1];
	if (head.height > 0 && head.table.length === 1)
	{
		return head.table[0];
	}
	else
	{
		return head;
	}
}

// Push a node into a higher node as a child.
function fromListPush(toPush, nodes)
{
	var h = toPush.height;

	// Maybe the node on this height does not exist.
	if (nodes.length === h)
	{
		var node = {
			ctor: '_Array',
			height: h + 1,
			table: [],
			lengths: []
		};
		nodes.push(node);
	}

	nodes[h].table.push(toPush);
	var len = length(toPush);
	if (nodes[h].lengths.length > 0)
	{
		len += nodes[h].lengths[nodes[h].lengths.length - 1];
	}
	nodes[h].lengths.push(len);

	if (nodes[h].table.length === M)
	{
		fromListPush(nodes[h], nodes);
		nodes[h] = {
			ctor: '_Array',
			height: h + 1,
			table: [],
			lengths: []
		};
	}
}

// Pushes an item via push_ to the bottom right of a tree.
function push(item, a)
{
	var pushed = push_(item, a);
	if (pushed !== null)
	{
		return pushed;
	}

	var newTree = create(item, a.height);
	return siblise(a, newTree);
}

// Recursively tries to push an item to the bottom-right most
// tree possible. If there is no space left for the item,
// null will be returned.
function push_(item, a)
{
	// Handle resursion stop at leaf level.
	if (a.height === 0)
	{
		if (a.table.length < M)
		{
			var newA = {
				ctor: '_Array',
				height: 0,
				table: a.table.slice()
			};
			newA.table.push(item);
			return newA;
		}
		else
		{
		  return null;
		}
	}

	// Recursively push
	var pushed = push_(item, botRight(a));

	// There was space in the bottom right tree, so the slot will
	// be updated.
	if (pushed !== null)
	{
		var newA = nodeCopy(a);
		newA.table[newA.table.length - 1] = pushed;
		newA.lengths[newA.lengths.length - 1]++;
		return newA;
	}

	// When there was no space left, check if there is space left
	// for a new slot with a tree which contains only the item
	// at the bottom.
	if (a.table.length < M)
	{
		var newSlot = create(item, a.height - 1);
		var newA = nodeCopy(a);
		newA.table.push(newSlot);
		newA.lengths.push(newA.lengths[newA.lengths.length - 1] + length(newSlot));
		return newA;
	}
	else
	{
		return null;
	}
}

// Converts an array into a list of elements.
function toList(a)
{
	return toList_(_elm_lang$core$Native_List.Nil, a);
}

function toList_(list, a)
{
	for (var i = a.table.length - 1; i >= 0; i--)
	{
		list =
			a.height === 0
				? _elm_lang$core$Native_List.Cons(a.table[i], list)
				: toList_(list, a.table[i]);
	}
	return list;
}

// Maps a function over the elements of an array.
function map(f, a)
{
	var newA = {
		ctor: '_Array',
		height: a.height,
		table: new Array(a.table.length)
	};
	if (a.height > 0)
	{
		newA.lengths = a.lengths;
	}
	for (var i = 0; i < a.table.length; i++)
	{
		newA.table[i] =
			a.height === 0
				? f(a.table[i])
				: map(f, a.table[i]);
	}
	return newA;
}

// Maps a function over the elements with their index as first argument.
function indexedMap(f, a)
{
	return indexedMap_(f, a, 0);
}

function indexedMap_(f, a, from)
{
	var newA = {
		ctor: '_Array',
		height: a.height,
		table: new Array(a.table.length)
	};
	if (a.height > 0)
	{
		newA.lengths = a.lengths;
	}
	for (var i = 0; i < a.table.length; i++)
	{
		newA.table[i] =
			a.height === 0
				? A2(f, from + i, a.table[i])
				: indexedMap_(f, a.table[i], i == 0 ? from : from + a.lengths[i - 1]);
	}
	return newA;
}

function foldl(f, b, a)
{
	if (a.height === 0)
	{
		for (var i = 0; i < a.table.length; i++)
		{
			b = A2(f, a.table[i], b);
		}
	}
	else
	{
		for (var i = 0; i < a.table.length; i++)
		{
			b = foldl(f, b, a.table[i]);
		}
	}
	return b;
}

function foldr(f, b, a)
{
	if (a.height === 0)
	{
		for (var i = a.table.length; i--; )
		{
			b = A2(f, a.table[i], b);
		}
	}
	else
	{
		for (var i = a.table.length; i--; )
		{
			b = foldr(f, b, a.table[i]);
		}
	}
	return b;
}

// TODO: currently, it slices the right, then the left. This can be
// optimized.
function slice(from, to, a)
{
	if (from < 0)
	{
		from += length(a);
	}
	if (to < 0)
	{
		to += length(a);
	}
	return sliceLeft(from, sliceRight(to, a));
}

function sliceRight(to, a)
{
	if (to === length(a))
	{
		return a;
	}

	// Handle leaf level.
	if (a.height === 0)
	{
		var newA = { ctor:'_Array', height:0 };
		newA.table = a.table.slice(0, to);
		return newA;
	}

	// Slice the right recursively.
	var right = getSlot(to, a);
	var sliced = sliceRight(to - (right > 0 ? a.lengths[right - 1] : 0), a.table[right]);

	// Maybe the a node is not even needed, as sliced contains the whole slice.
	if (right === 0)
	{
		return sliced;
	}

	// Create new node.
	var newA = {
		ctor: '_Array',
		height: a.height,
		table: a.table.slice(0, right),
		lengths: a.lengths.slice(0, right)
	};
	if (sliced.table.length > 0)
	{
		newA.table[right] = sliced;
		newA.lengths[right] = length(sliced) + (right > 0 ? newA.lengths[right - 1] : 0);
	}
	return newA;
}

function sliceLeft(from, a)
{
	if (from === 0)
	{
		return a;
	}

	// Handle leaf level.
	if (a.height === 0)
	{
		var newA = { ctor:'_Array', height:0 };
		newA.table = a.table.slice(from, a.table.length + 1);
		return newA;
	}

	// Slice the left recursively.
	var left = getSlot(from, a);
	var sliced = sliceLeft(from - (left > 0 ? a.lengths[left - 1] : 0), a.table[left]);

	// Maybe the a node is not even needed, as sliced contains the whole slice.
	if (left === a.table.length - 1)
	{
		return sliced;
	}

	// Create new node.
	var newA = {
		ctor: '_Array',
		height: a.height,
		table: a.table.slice(left, a.table.length + 1),
		lengths: new Array(a.table.length - left)
	};
	newA.table[0] = sliced;
	var len = 0;
	for (var i = 0; i < newA.table.length; i++)
	{
		len += length(newA.table[i]);
		newA.lengths[i] = len;
	}

	return newA;
}

// Appends two trees.
function append(a,b)
{
	if (a.table.length === 0)
	{
		return b;
	}
	if (b.table.length === 0)
	{
		return a;
	}

	var c = append_(a, b);

	// Check if both nodes can be crunshed together.
	if (c[0].table.length + c[1].table.length <= M)
	{
		if (c[0].table.length === 0)
		{
			return c[1];
		}
		if (c[1].table.length === 0)
		{
			return c[0];
		}

		// Adjust .table and .lengths
		c[0].table = c[0].table.concat(c[1].table);
		if (c[0].height > 0)
		{
			var len = length(c[0]);
			for (var i = 0; i < c[1].lengths.length; i++)
			{
				c[1].lengths[i] += len;
			}
			c[0].lengths = c[0].lengths.concat(c[1].lengths);
		}

		return c[0];
	}

	if (c[0].height > 0)
	{
		var toRemove = calcToRemove(a, b);
		if (toRemove > E)
		{
			c = shuffle(c[0], c[1], toRemove);
		}
	}

	return siblise(c[0], c[1]);
}

// Returns an array of two nodes; right and left. One node _may_ be empty.
function append_(a, b)
{
	if (a.height === 0 && b.height === 0)
	{
		return [a, b];
	}

	if (a.height !== 1 || b.height !== 1)
	{
		if (a.height === b.height)
		{
			a = nodeCopy(a);
			b = nodeCopy(b);
			var appended = append_(botRight(a), botLeft(b));

			insertRight(a, appended[1]);
			insertLeft(b, appended[0]);
		}
		else if (a.height > b.height)
		{
			a = nodeCopy(a);
			var appended = append_(botRight(a), b);

			insertRight(a, appended[0]);
			b = parentise(appended[1], appended[1].height + 1);
		}
		else
		{
			b = nodeCopy(b);
			var appended = append_(a, botLeft(b));

			var left = appended[0].table.length === 0 ? 0 : 1;
			var right = left === 0 ? 1 : 0;
			insertLeft(b, appended[left]);
			a = parentise(appended[right], appended[right].height + 1);
		}
	}

	// Check if balancing is needed and return based on that.
	if (a.table.length === 0 || b.table.length === 0)
	{
		return [a, b];
	}

	var toRemove = calcToRemove(a, b);
	if (toRemove <= E)
	{
		return [a, b];
	}
	return shuffle(a, b, toRemove);
}

// Helperfunctions for append_. Replaces a child node at the side of the parent.
function insertRight(parent, node)
{
	var index = parent.table.length - 1;
	parent.table[index] = node;
	parent.lengths[index] = length(node);
	parent.lengths[index] += index > 0 ? parent.lengths[index - 1] : 0;
}

function insertLeft(parent, node)
{
	if (node.table.length > 0)
	{
		parent.table[0] = node;
		parent.lengths[0] = length(node);

		var len = length(parent.table[0]);
		for (var i = 1; i < parent.lengths.length; i++)
		{
			len += length(parent.table[i]);
			parent.lengths[i] = len;
		}
	}
	else
	{
		parent.table.shift();
		for (var i = 1; i < parent.lengths.length; i++)
		{
			parent.lengths[i] = parent.lengths[i] - parent.lengths[0];
		}
		parent.lengths.shift();
	}
}

// Returns the extra search steps for E. Refer to the paper.
function calcToRemove(a, b)
{
	var subLengths = 0;
	for (var i = 0; i < a.table.length; i++)
	{
		subLengths += a.table[i].table.length;
	}
	for (var i = 0; i < b.table.length; i++)
	{
		subLengths += b.table[i].table.length;
	}

	var toRemove = a.table.length + b.table.length;
	return toRemove - (Math.floor((subLengths - 1) / M) + 1);
}

// get2, set2 and saveSlot are helpers for accessing elements over two arrays.
function get2(a, b, index)
{
	return index < a.length
		? a[index]
		: b[index - a.length];
}

function set2(a, b, index, value)
{
	if (index < a.length)
	{
		a[index] = value;
	}
	else
	{
		b[index - a.length] = value;
	}
}

function saveSlot(a, b, index, slot)
{
	set2(a.table, b.table, index, slot);

	var l = (index === 0 || index === a.lengths.length)
		? 0
		: get2(a.lengths, a.lengths, index - 1);

	set2(a.lengths, b.lengths, index, l + length(slot));
}

// Creates a node or leaf with a given length at their arrays for perfomance.
// Is only used by shuffle.
function createNode(h, length)
{
	if (length < 0)
	{
		length = 0;
	}
	var a = {
		ctor: '_Array',
		height: h,
		table: new Array(length)
	};
	if (h > 0)
	{
		a.lengths = new Array(length);
	}
	return a;
}

// Returns an array of two balanced nodes.
function shuffle(a, b, toRemove)
{
	var newA = createNode(a.height, Math.min(M, a.table.length + b.table.length - toRemove));
	var newB = createNode(a.height, newA.table.length - (a.table.length + b.table.length - toRemove));

	// Skip the slots with size M. More precise: copy the slot references
	// to the new node
	var read = 0;
	while (get2(a.table, b.table, read).table.length % M === 0)
	{
		set2(newA.table, newB.table, read, get2(a.table, b.table, read));
		set2(newA.lengths, newB.lengths, read, get2(a.lengths, b.lengths, read));
		read++;
	}

	// Pulling items from left to right, caching in a slot before writing
	// it into the new nodes.
	var write = read;
	var slot = new createNode(a.height - 1, 0);
	var from = 0;

	// If the current slot is still containing data, then there will be at
	// least one more write, so we do not break this loop yet.
	while (read - write - (slot.table.length > 0 ? 1 : 0) < toRemove)
	{
		// Find out the max possible items for copying.
		var source = get2(a.table, b.table, read);
		var to = Math.min(M - slot.table.length, source.table.length);

		// Copy and adjust size table.
		slot.table = slot.table.concat(source.table.slice(from, to));
		if (slot.height > 0)
		{
			var len = slot.lengths.length;
			for (var i = len; i < len + to - from; i++)
			{
				slot.lengths[i] = length(slot.table[i]);
				slot.lengths[i] += (i > 0 ? slot.lengths[i - 1] : 0);
			}
		}

		from += to;

		// Only proceed to next slots[i] if the current one was
		// fully copied.
		if (source.table.length <= to)
		{
			read++; from = 0;
		}

		// Only create a new slot if the current one is filled up.
		if (slot.table.length === M)
		{
			saveSlot(newA, newB, write, slot);
			slot = createNode(a.height - 1, 0);
			write++;
		}
	}

	// Cleanup after the loop. Copy the last slot into the new nodes.
	if (slot.table.length > 0)
	{
		saveSlot(newA, newB, write, slot);
		write++;
	}

	// Shift the untouched slots to the left
	while (read < a.table.length + b.table.length )
	{
		saveSlot(newA, newB, write, get2(a.table, b.table, read));
		read++;
		write++;
	}

	return [newA, newB];
}

// Navigation functions
function botRight(a)
{
	return a.table[a.table.length - 1];
}
function botLeft(a)
{
	return a.table[0];
}

// Copies a node for updating. Note that you should not use this if
// only updating only one of "table" or "lengths" for performance reasons.
function nodeCopy(a)
{
	var newA = {
		ctor: '_Array',
		height: a.height,
		table: a.table.slice()
	};
	if (a.height > 0)
	{
		newA.lengths = a.lengths.slice();
	}
	return newA;
}

// Returns how many items are in the tree.
function length(array)
{
	if (array.height === 0)
	{
		return array.table.length;
	}
	else
	{
		return array.lengths[array.lengths.length - 1];
	}
}

// Calculates in which slot of "table" the item probably is, then
// find the exact slot via forward searching in  "lengths". Returns the index.
function getSlot(i, a)
{
	var slot = i >> (5 * a.height);
	while (a.lengths[slot] <= i)
	{
		slot++;
	}
	return slot;
}

// Recursively creates a tree with a given height containing
// only the given item.
function create(item, h)
{
	if (h === 0)
	{
		return {
			ctor: '_Array',
			height: 0,
			table: [item]
		};
	}
	return {
		ctor: '_Array',
		height: h,
		table: [create(item, h - 1)],
		lengths: [1]
	};
}

// Recursively creates a tree that contains the given tree.
function parentise(tree, h)
{
	if (h === tree.height)
	{
		return tree;
	}

	return {
		ctor: '_Array',
		height: h,
		table: [parentise(tree, h - 1)],
		lengths: [length(tree)]
	};
}

// Emphasizes blood brotherhood beneath two trees.
function siblise(a, b)
{
	return {
		ctor: '_Array',
		height: a.height + 1,
		table: [a, b],
		lengths: [length(a), length(a) + length(b)]
	};
}

function toJSArray(a)
{
	var jsArray = new Array(length(a));
	toJSArray_(jsArray, 0, a);
	return jsArray;
}

function toJSArray_(jsArray, i, a)
{
	for (var t = 0; t < a.table.length; t++)
	{
		if (a.height === 0)
		{
			jsArray[i + t] = a.table[t];
		}
		else
		{
			var inc = t === 0 ? 0 : a.lengths[t - 1];
			toJSArray_(jsArray, i + inc, a.table[t]);
		}
	}
}

function fromJSArray(jsArray)
{
	if (jsArray.length === 0)
	{
		return empty;
	}
	var h = Math.floor(Math.log(jsArray.length) / Math.log(M));
	return fromJSArray_(jsArray, h, 0, jsArray.length);
}

function fromJSArray_(jsArray, h, from, to)
{
	if (h === 0)
	{
		return {
			ctor: '_Array',
			height: 0,
			table: jsArray.slice(from, to)
		};
	}

	var step = Math.pow(M, h);
	var table = new Array(Math.ceil((to - from) / step));
	var lengths = new Array(table.length);
	for (var i = 0; i < table.length; i++)
	{
		table[i] = fromJSArray_(jsArray, h - 1, from + (i * step), Math.min(from + ((i + 1) * step), to));
		lengths[i] = length(table[i]) + (i > 0 ? lengths[i - 1] : 0);
	}
	return {
		ctor: '_Array',
		height: h,
		table: table,
		lengths: lengths
	};
}

return {
	empty: empty,
	fromList: fromList,
	toList: toList,
	initialize: F2(initialize),
	append: F2(append),
	push: F2(push),
	slice: F3(slice),
	get: F2(get),
	set: F3(set),
	map: F2(map),
	indexedMap: F2(indexedMap),
	foldl: F3(foldl),
	foldr: F3(foldr),
	length: length,

	toJSArray: toJSArray,
	fromJSArray: fromJSArray
};

}();
var _elm_lang$core$Array$append = _elm_lang$core$Native_Array.append;
var _elm_lang$core$Array$length = _elm_lang$core$Native_Array.length;
var _elm_lang$core$Array$isEmpty = function (array) {
	return _elm_lang$core$Native_Utils.eq(
		_elm_lang$core$Array$length(array),
		0);
};
var _elm_lang$core$Array$slice = _elm_lang$core$Native_Array.slice;
var _elm_lang$core$Array$set = _elm_lang$core$Native_Array.set;
var _elm_lang$core$Array$get = F2(
	function (i, array) {
		return ((_elm_lang$core$Native_Utils.cmp(0, i) < 1) && (_elm_lang$core$Native_Utils.cmp(
			i,
			_elm_lang$core$Native_Array.length(array)) < 0)) ? _elm_lang$core$Maybe$Just(
			A2(_elm_lang$core$Native_Array.get, i, array)) : _elm_lang$core$Maybe$Nothing;
	});
var _elm_lang$core$Array$push = _elm_lang$core$Native_Array.push;
var _elm_lang$core$Array$empty = _elm_lang$core$Native_Array.empty;
var _elm_lang$core$Array$filter = F2(
	function (isOkay, arr) {
		var update = F2(
			function (x, xs) {
				return isOkay(x) ? A2(_elm_lang$core$Native_Array.push, x, xs) : xs;
			});
		return A3(_elm_lang$core$Native_Array.foldl, update, _elm_lang$core$Native_Array.empty, arr);
	});
var _elm_lang$core$Array$foldr = _elm_lang$core$Native_Array.foldr;
var _elm_lang$core$Array$foldl = _elm_lang$core$Native_Array.foldl;
var _elm_lang$core$Array$indexedMap = _elm_lang$core$Native_Array.indexedMap;
var _elm_lang$core$Array$map = _elm_lang$core$Native_Array.map;
var _elm_lang$core$Array$toIndexedList = function (array) {
	return A3(
		_elm_lang$core$List$map2,
		F2(
			function (v0, v1) {
				return {ctor: '_Tuple2', _0: v0, _1: v1};
			}),
		_elm_lang$core$Native_List.range(
			0,
			_elm_lang$core$Native_Array.length(array) - 1),
		_elm_lang$core$Native_Array.toList(array));
};
var _elm_lang$core$Array$toList = _elm_lang$core$Native_Array.toList;
var _elm_lang$core$Array$fromList = _elm_lang$core$Native_Array.fromList;
var _elm_lang$core$Array$initialize = _elm_lang$core$Native_Array.initialize;
var _elm_lang$core$Array$repeat = F2(
	function (n, e) {
		return A2(
			_elm_lang$core$Array$initialize,
			n,
			_elm_lang$core$Basics$always(e));
	});
var _elm_lang$core$Array$Array = {ctor: 'Array'};

var _elm_community$maybe_extra$Maybe_Extra$filter = F2(
	function (f, m) {
		var _p0 = A2(_elm_lang$core$Maybe$map, f, m);
		if ((_p0.ctor === 'Just') && (_p0._0 === true)) {
			return m;
		} else {
			return _elm_lang$core$Maybe$Nothing;
		}
	});
var _elm_community$maybe_extra$Maybe_Extra$traverseArray = function (f) {
	var step = F2(
		function (e, acc) {
			var _p1 = f(e);
			if (_p1.ctor === 'Nothing') {
				return _elm_lang$core$Maybe$Nothing;
			} else {
				return A2(
					_elm_lang$core$Maybe$map,
					_elm_lang$core$Array$push(_p1._0),
					acc);
			}
		});
	return A2(
		_elm_lang$core$Array$foldl,
		step,
		_elm_lang$core$Maybe$Just(_elm_lang$core$Array$empty));
};
var _elm_community$maybe_extra$Maybe_Extra$combineArray = _elm_community$maybe_extra$Maybe_Extra$traverseArray(_elm_lang$core$Basics$identity);
var _elm_community$maybe_extra$Maybe_Extra$traverse = function (f) {
	var step = F2(
		function (e, acc) {
			var _p2 = f(e);
			if (_p2.ctor === 'Nothing') {
				return _elm_lang$core$Maybe$Nothing;
			} else {
				return A2(
					_elm_lang$core$Maybe$map,
					F2(
						function (x, y) {
							return A2(_elm_lang$core$List_ops['::'], x, y);
						})(_p2._0),
					acc);
			}
		});
	return A2(
		_elm_lang$core$List$foldr,
		step,
		_elm_lang$core$Maybe$Just(
			_elm_lang$core$Native_List.fromArray(
				[])));
};
var _elm_community$maybe_extra$Maybe_Extra$combine = _elm_community$maybe_extra$Maybe_Extra$traverse(_elm_lang$core$Basics$identity);
var _elm_community$maybe_extra$Maybe_Extra$maybeToArray = function (m) {
	var _p3 = m;
	if (_p3.ctor === 'Nothing') {
		return _elm_lang$core$Array$empty;
	} else {
		return A2(_elm_lang$core$Array$repeat, 1, _p3._0);
	}
};
var _elm_community$maybe_extra$Maybe_Extra$maybeToList = function (m) {
	var _p4 = m;
	if (_p4.ctor === 'Nothing') {
		return _elm_lang$core$Native_List.fromArray(
			[]);
	} else {
		return _elm_lang$core$Native_List.fromArray(
			[_p4._0]);
	}
};
var _elm_community$maybe_extra$Maybe_Extra$orElse = F2(
	function (ma, mb) {
		var _p5 = mb;
		if (_p5.ctor === 'Nothing') {
			return ma;
		} else {
			return mb;
		}
	});
var _elm_community$maybe_extra$Maybe_Extra$orElseLazy = F2(
	function (fma, mb) {
		var _p6 = mb;
		if (_p6.ctor === 'Nothing') {
			return fma(
				{ctor: '_Tuple0'});
		} else {
			return mb;
		}
	});
var _elm_community$maybe_extra$Maybe_Extra$orLazy = F2(
	function (ma, fmb) {
		var _p7 = ma;
		if (_p7.ctor === 'Nothing') {
			return fmb(
				{ctor: '_Tuple0'});
		} else {
			return ma;
		}
	});
var _elm_community$maybe_extra$Maybe_Extra$or = F2(
	function (ma, mb) {
		var _p8 = ma;
		if (_p8.ctor === 'Nothing') {
			return mb;
		} else {
			return ma;
		}
	});
var _elm_community$maybe_extra$Maybe_Extra$prev = _elm_lang$core$Maybe$map2(_elm_lang$core$Basics$always);
var _elm_community$maybe_extra$Maybe_Extra$next = _elm_lang$core$Maybe$map2(
	_elm_lang$core$Basics$flip(_elm_lang$core$Basics$always));
var _elm_community$maybe_extra$Maybe_Extra$andMap = F2(
	function (f, x) {
		return A2(
			_elm_lang$core$Maybe$andThen,
			x,
			function (x$) {
				return A2(
					_elm_lang$core$Maybe$andThen,
					f,
					function (f$) {
						return _elm_lang$core$Maybe$Just(
							f$(x$));
					});
			});
	});
var _elm_community$maybe_extra$Maybe_Extra$unpack = F3(
	function (d, f, m) {
		var _p9 = m;
		if (_p9.ctor === 'Nothing') {
			return d(
				{ctor: '_Tuple0'});
		} else {
			return f(_p9._0);
		}
	});
var _elm_community$maybe_extra$Maybe_Extra$unwrap = F3(
	function (d, f, m) {
		var _p10 = m;
		if (_p10.ctor === 'Nothing') {
			return d;
		} else {
			return f(_p10._0);
		}
	});
var _elm_community$maybe_extra$Maybe_Extra$isJust = function (m) {
	var _p11 = m;
	if (_p11.ctor === 'Nothing') {
		return false;
	} else {
		return true;
	}
};
var _elm_community$maybe_extra$Maybe_Extra$isNothing = function (m) {
	var _p12 = m;
	if (_p12.ctor === 'Nothing') {
		return true;
	} else {
		return false;
	}
};
var _elm_community$maybe_extra$Maybe_Extra$join = function (mx) {
	var _p13 = mx;
	if (_p13.ctor === 'Just') {
		return _p13._0;
	} else {
		return _elm_lang$core$Maybe$Nothing;
	}
};
var _elm_community$maybe_extra$Maybe_Extra_ops = _elm_community$maybe_extra$Maybe_Extra_ops || {};
_elm_community$maybe_extra$Maybe_Extra_ops['?'] = F2(
	function (mx, x) {
		return A2(_elm_lang$core$Maybe$withDefault, x, mx);
	});

var _elm_community$result_extra$Result_Extra$orElse = F2(
	function (ra, rb) {
		var _p0 = rb;
		if (_p0.ctor === 'Err') {
			return ra;
		} else {
			return rb;
		}
	});
var _elm_community$result_extra$Result_Extra$orElseLazy = F2(
	function (fra, rb) {
		var _p1 = rb;
		if (_p1.ctor === 'Err') {
			return fra(
				{ctor: '_Tuple0'});
		} else {
			return rb;
		}
	});
var _elm_community$result_extra$Result_Extra$orLazy = F2(
	function (ra, frb) {
		var _p2 = ra;
		if (_p2.ctor === 'Err') {
			return frb(
				{ctor: '_Tuple0'});
		} else {
			return ra;
		}
	});
var _elm_community$result_extra$Result_Extra$or = F2(
	function (ra, rb) {
		var _p3 = ra;
		if (_p3.ctor === 'Err') {
			return rb;
		} else {
			return ra;
		}
	});
var _elm_community$result_extra$Result_Extra$combine = A2(
	_elm_lang$core$List$foldr,
	_elm_lang$core$Result$map2(
		F2(
			function (x, y) {
				return A2(_elm_lang$core$List_ops['::'], x, y);
			})),
	_elm_lang$core$Result$Ok(
		_elm_lang$core$Native_List.fromArray(
			[])));
var _elm_community$result_extra$Result_Extra$mapBoth = F3(
	function (errFunc, okFunc, result) {
		var _p4 = result;
		if (_p4.ctor === 'Ok') {
			return _elm_lang$core$Result$Ok(
				okFunc(_p4._0));
		} else {
			return _elm_lang$core$Result$Err(
				errFunc(_p4._0));
		}
	});
var _elm_community$result_extra$Result_Extra$unpack = F3(
	function (errFunc, okFunc, result) {
		var _p5 = result;
		if (_p5.ctor === 'Ok') {
			return okFunc(_p5._0);
		} else {
			return errFunc(_p5._0);
		}
	});
var _elm_community$result_extra$Result_Extra$unwrap = F3(
	function (defaultValue, okFunc, result) {
		var _p6 = result;
		if (_p6.ctor === 'Ok') {
			return okFunc(_p6._0);
		} else {
			return defaultValue;
		}
	});
var _elm_community$result_extra$Result_Extra$extract = F2(
	function (f, x) {
		var _p7 = x;
		if (_p7.ctor === 'Ok') {
			return _p7._0;
		} else {
			return f(_p7._0);
		}
	});
var _elm_community$result_extra$Result_Extra$isErr = function (x) {
	var _p8 = x;
	if (_p8.ctor === 'Ok') {
		return false;
	} else {
		return true;
	}
};
var _elm_community$result_extra$Result_Extra$isOk = function (x) {
	var _p9 = x;
	if (_p9.ctor === 'Ok') {
		return true;
	} else {
		return false;
	}
};

//import Native.Utils //

var _elm_lang$core$Native_Char = function() {

return {
	fromCode: function(c) { return _elm_lang$core$Native_Utils.chr(String.fromCharCode(c)); },
	toCode: function(c) { return c.charCodeAt(0); },
	toUpper: function(c) { return _elm_lang$core$Native_Utils.chr(c.toUpperCase()); },
	toLower: function(c) { return _elm_lang$core$Native_Utils.chr(c.toLowerCase()); },
	toLocaleUpper: function(c) { return _elm_lang$core$Native_Utils.chr(c.toLocaleUpperCase()); },
	toLocaleLower: function(c) { return _elm_lang$core$Native_Utils.chr(c.toLocaleLowerCase()); }
};

}();
var _elm_lang$core$Char$fromCode = _elm_lang$core$Native_Char.fromCode;
var _elm_lang$core$Char$toCode = _elm_lang$core$Native_Char.toCode;
var _elm_lang$core$Char$toLocaleLower = _elm_lang$core$Native_Char.toLocaleLower;
var _elm_lang$core$Char$toLocaleUpper = _elm_lang$core$Native_Char.toLocaleUpper;
var _elm_lang$core$Char$toLower = _elm_lang$core$Native_Char.toLower;
var _elm_lang$core$Char$toUpper = _elm_lang$core$Native_Char.toUpper;
var _elm_lang$core$Char$isBetween = F3(
	function (low, high, $char) {
		var code = _elm_lang$core$Char$toCode($char);
		return (_elm_lang$core$Native_Utils.cmp(
			code,
			_elm_lang$core$Char$toCode(low)) > -1) && (_elm_lang$core$Native_Utils.cmp(
			code,
			_elm_lang$core$Char$toCode(high)) < 1);
	});
var _elm_lang$core$Char$isUpper = A2(
	_elm_lang$core$Char$isBetween,
	_elm_lang$core$Native_Utils.chr('A'),
	_elm_lang$core$Native_Utils.chr('Z'));
var _elm_lang$core$Char$isLower = A2(
	_elm_lang$core$Char$isBetween,
	_elm_lang$core$Native_Utils.chr('a'),
	_elm_lang$core$Native_Utils.chr('z'));
var _elm_lang$core$Char$isDigit = A2(
	_elm_lang$core$Char$isBetween,
	_elm_lang$core$Native_Utils.chr('0'),
	_elm_lang$core$Native_Utils.chr('9'));
var _elm_lang$core$Char$isOctDigit = A2(
	_elm_lang$core$Char$isBetween,
	_elm_lang$core$Native_Utils.chr('0'),
	_elm_lang$core$Native_Utils.chr('7'));
var _elm_lang$core$Char$isHexDigit = function ($char) {
	return _elm_lang$core$Char$isDigit($char) || (A3(
		_elm_lang$core$Char$isBetween,
		_elm_lang$core$Native_Utils.chr('a'),
		_elm_lang$core$Native_Utils.chr('f'),
		$char) || A3(
		_elm_lang$core$Char$isBetween,
		_elm_lang$core$Native_Utils.chr('A'),
		_elm_lang$core$Native_Utils.chr('F'),
		$char));
};

//import Maybe, Native.List, Native.Utils, Result //

var _elm_lang$core$Native_String = function() {

function isEmpty(str)
{
	return str.length === 0;
}
function cons(chr, str)
{
	return chr + str;
}
function uncons(str)
{
	var hd = str[0];
	if (hd)
	{
		return _elm_lang$core$Maybe$Just(_elm_lang$core$Native_Utils.Tuple2(_elm_lang$core$Native_Utils.chr(hd), str.slice(1)));
	}
	return _elm_lang$core$Maybe$Nothing;
}
function append(a, b)
{
	return a + b;
}
function concat(strs)
{
	return _elm_lang$core$Native_List.toArray(strs).join('');
}
function length(str)
{
	return str.length;
}
function map(f, str)
{
	var out = str.split('');
	for (var i = out.length; i--; )
	{
		out[i] = f(_elm_lang$core$Native_Utils.chr(out[i]));
	}
	return out.join('');
}
function filter(pred, str)
{
	return str.split('').map(_elm_lang$core$Native_Utils.chr).filter(pred).join('');
}
function reverse(str)
{
	return str.split('').reverse().join('');
}
function foldl(f, b, str)
{
	var len = str.length;
	for (var i = 0; i < len; ++i)
	{
		b = A2(f, _elm_lang$core$Native_Utils.chr(str[i]), b);
	}
	return b;
}
function foldr(f, b, str)
{
	for (var i = str.length; i--; )
	{
		b = A2(f, _elm_lang$core$Native_Utils.chr(str[i]), b);
	}
	return b;
}
function split(sep, str)
{
	return _elm_lang$core$Native_List.fromArray(str.split(sep));
}
function join(sep, strs)
{
	return _elm_lang$core$Native_List.toArray(strs).join(sep);
}
function repeat(n, str)
{
	var result = '';
	while (n > 0)
	{
		if (n & 1)
		{
			result += str;
		}
		n >>= 1, str += str;
	}
	return result;
}
function slice(start, end, str)
{
	return str.slice(start, end);
}
function left(n, str)
{
	return n < 1 ? '' : str.slice(0, n);
}
function right(n, str)
{
	return n < 1 ? '' : str.slice(-n);
}
function dropLeft(n, str)
{
	return n < 1 ? str : str.slice(n);
}
function dropRight(n, str)
{
	return n < 1 ? str : str.slice(0, -n);
}
function pad(n, chr, str)
{
	var half = (n - str.length) / 2;
	return repeat(Math.ceil(half), chr) + str + repeat(half | 0, chr);
}
function padRight(n, chr, str)
{
	return str + repeat(n - str.length, chr);
}
function padLeft(n, chr, str)
{
	return repeat(n - str.length, chr) + str;
}

function trim(str)
{
	return str.trim();
}
function trimLeft(str)
{
	return str.replace(/^\s+/, '');
}
function trimRight(str)
{
	return str.replace(/\s+$/, '');
}

function words(str)
{
	return _elm_lang$core$Native_List.fromArray(str.trim().split(/\s+/g));
}
function lines(str)
{
	return _elm_lang$core$Native_List.fromArray(str.split(/\r\n|\r|\n/g));
}

function toUpper(str)
{
	return str.toUpperCase();
}
function toLower(str)
{
	return str.toLowerCase();
}

function any(pred, str)
{
	for (var i = str.length; i--; )
	{
		if (pred(_elm_lang$core$Native_Utils.chr(str[i])))
		{
			return true;
		}
	}
	return false;
}
function all(pred, str)
{
	for (var i = str.length; i--; )
	{
		if (!pred(_elm_lang$core$Native_Utils.chr(str[i])))
		{
			return false;
		}
	}
	return true;
}

function contains(sub, str)
{
	return str.indexOf(sub) > -1;
}
function startsWith(sub, str)
{
	return str.indexOf(sub) === 0;
}
function endsWith(sub, str)
{
	return str.length >= sub.length &&
		str.lastIndexOf(sub) === str.length - sub.length;
}
function indexes(sub, str)
{
	var subLen = sub.length;
	
	if (subLen < 1)
	{
		return _elm_lang$core$Native_List.Nil;
	}

	var i = 0;
	var is = [];

	while ((i = str.indexOf(sub, i)) > -1)
	{
		is.push(i);
		i = i + subLen;
	}	
	
	return _elm_lang$core$Native_List.fromArray(is);
}

function toInt(s)
{
	var len = s.length;
	if (len === 0)
	{
		return _elm_lang$core$Result$Err("could not convert string '" + s + "' to an Int" );
	}
	var start = 0;
	if (s[0] === '-')
	{
		if (len === 1)
		{
			return _elm_lang$core$Result$Err("could not convert string '" + s + "' to an Int" );
		}
		start = 1;
	}
	for (var i = start; i < len; ++i)
	{
		var c = s[i];
		if (c < '0' || '9' < c)
		{
			return _elm_lang$core$Result$Err("could not convert string '" + s + "' to an Int" );
		}
	}
	return _elm_lang$core$Result$Ok(parseInt(s, 10));
}

function toFloat(s)
{
	var len = s.length;
	if (len === 0)
	{
		return _elm_lang$core$Result$Err("could not convert string '" + s + "' to a Float" );
	}
	var start = 0;
	if (s[0] === '-')
	{
		if (len === 1)
		{
			return _elm_lang$core$Result$Err("could not convert string '" + s + "' to a Float" );
		}
		start = 1;
	}
	var dotCount = 0;
	for (var i = start; i < len; ++i)
	{
		var c = s[i];
		if ('0' <= c && c <= '9')
		{
			continue;
		}
		if (c === '.')
		{
			dotCount += 1;
			if (dotCount <= 1)
			{
				continue;
			}
		}
		return _elm_lang$core$Result$Err("could not convert string '" + s + "' to a Float" );
	}
	return _elm_lang$core$Result$Ok(parseFloat(s));
}

function toList(str)
{
	return _elm_lang$core$Native_List.fromArray(str.split('').map(_elm_lang$core$Native_Utils.chr));
}
function fromList(chars)
{
	return _elm_lang$core$Native_List.toArray(chars).join('');
}

return {
	isEmpty: isEmpty,
	cons: F2(cons),
	uncons: uncons,
	append: F2(append),
	concat: concat,
	length: length,
	map: F2(map),
	filter: F2(filter),
	reverse: reverse,
	foldl: F3(foldl),
	foldr: F3(foldr),

	split: F2(split),
	join: F2(join),
	repeat: F2(repeat),

	slice: F3(slice),
	left: F2(left),
	right: F2(right),
	dropLeft: F2(dropLeft),
	dropRight: F2(dropRight),

	pad: F3(pad),
	padLeft: F3(padLeft),
	padRight: F3(padRight),

	trim: trim,
	trimLeft: trimLeft,
	trimRight: trimRight,

	words: words,
	lines: lines,

	toUpper: toUpper,
	toLower: toLower,

	any: F2(any),
	all: F2(all),

	contains: F2(contains),
	startsWith: F2(startsWith),
	endsWith: F2(endsWith),
	indexes: F2(indexes),

	toInt: toInt,
	toFloat: toFloat,
	toList: toList,
	fromList: fromList
};

}();

var _elm_lang$core$String$fromList = _elm_lang$core$Native_String.fromList;
var _elm_lang$core$String$toList = _elm_lang$core$Native_String.toList;
var _elm_lang$core$String$toFloat = _elm_lang$core$Native_String.toFloat;
var _elm_lang$core$String$toInt = _elm_lang$core$Native_String.toInt;
var _elm_lang$core$String$indices = _elm_lang$core$Native_String.indexes;
var _elm_lang$core$String$indexes = _elm_lang$core$Native_String.indexes;
var _elm_lang$core$String$endsWith = _elm_lang$core$Native_String.endsWith;
var _elm_lang$core$String$startsWith = _elm_lang$core$Native_String.startsWith;
var _elm_lang$core$String$contains = _elm_lang$core$Native_String.contains;
var _elm_lang$core$String$all = _elm_lang$core$Native_String.all;
var _elm_lang$core$String$any = _elm_lang$core$Native_String.any;
var _elm_lang$core$String$toLower = _elm_lang$core$Native_String.toLower;
var _elm_lang$core$String$toUpper = _elm_lang$core$Native_String.toUpper;
var _elm_lang$core$String$lines = _elm_lang$core$Native_String.lines;
var _elm_lang$core$String$words = _elm_lang$core$Native_String.words;
var _elm_lang$core$String$trimRight = _elm_lang$core$Native_String.trimRight;
var _elm_lang$core$String$trimLeft = _elm_lang$core$Native_String.trimLeft;
var _elm_lang$core$String$trim = _elm_lang$core$Native_String.trim;
var _elm_lang$core$String$padRight = _elm_lang$core$Native_String.padRight;
var _elm_lang$core$String$padLeft = _elm_lang$core$Native_String.padLeft;
var _elm_lang$core$String$pad = _elm_lang$core$Native_String.pad;
var _elm_lang$core$String$dropRight = _elm_lang$core$Native_String.dropRight;
var _elm_lang$core$String$dropLeft = _elm_lang$core$Native_String.dropLeft;
var _elm_lang$core$String$right = _elm_lang$core$Native_String.right;
var _elm_lang$core$String$left = _elm_lang$core$Native_String.left;
var _elm_lang$core$String$slice = _elm_lang$core$Native_String.slice;
var _elm_lang$core$String$repeat = _elm_lang$core$Native_String.repeat;
var _elm_lang$core$String$join = _elm_lang$core$Native_String.join;
var _elm_lang$core$String$split = _elm_lang$core$Native_String.split;
var _elm_lang$core$String$foldr = _elm_lang$core$Native_String.foldr;
var _elm_lang$core$String$foldl = _elm_lang$core$Native_String.foldl;
var _elm_lang$core$String$reverse = _elm_lang$core$Native_String.reverse;
var _elm_lang$core$String$filter = _elm_lang$core$Native_String.filter;
var _elm_lang$core$String$map = _elm_lang$core$Native_String.map;
var _elm_lang$core$String$length = _elm_lang$core$Native_String.length;
var _elm_lang$core$String$concat = _elm_lang$core$Native_String.concat;
var _elm_lang$core$String$append = _elm_lang$core$Native_String.append;
var _elm_lang$core$String$uncons = _elm_lang$core$Native_String.uncons;
var _elm_lang$core$String$cons = _elm_lang$core$Native_String.cons;
var _elm_lang$core$String$fromChar = function ($char) {
	return A2(_elm_lang$core$String$cons, $char, '');
};
var _elm_lang$core$String$isEmpty = _elm_lang$core$Native_String.isEmpty;

var _elm_lang$core$Dict$foldr = F3(
	function (f, acc, t) {
		foldr:
		while (true) {
			var _p0 = t;
			if (_p0.ctor === 'RBEmpty_elm_builtin') {
				return acc;
			} else {
				var _v1 = f,
					_v2 = A3(
					f,
					_p0._1,
					_p0._2,
					A3(_elm_lang$core$Dict$foldr, f, acc, _p0._4)),
					_v3 = _p0._3;
				f = _v1;
				acc = _v2;
				t = _v3;
				continue foldr;
			}
		}
	});
var _elm_lang$core$Dict$keys = function (dict) {
	return A3(
		_elm_lang$core$Dict$foldr,
		F3(
			function (key, value, keyList) {
				return A2(_elm_lang$core$List_ops['::'], key, keyList);
			}),
		_elm_lang$core$Native_List.fromArray(
			[]),
		dict);
};
var _elm_lang$core$Dict$values = function (dict) {
	return A3(
		_elm_lang$core$Dict$foldr,
		F3(
			function (key, value, valueList) {
				return A2(_elm_lang$core$List_ops['::'], value, valueList);
			}),
		_elm_lang$core$Native_List.fromArray(
			[]),
		dict);
};
var _elm_lang$core$Dict$toList = function (dict) {
	return A3(
		_elm_lang$core$Dict$foldr,
		F3(
			function (key, value, list) {
				return A2(
					_elm_lang$core$List_ops['::'],
					{ctor: '_Tuple2', _0: key, _1: value},
					list);
			}),
		_elm_lang$core$Native_List.fromArray(
			[]),
		dict);
};
var _elm_lang$core$Dict$foldl = F3(
	function (f, acc, dict) {
		foldl:
		while (true) {
			var _p1 = dict;
			if (_p1.ctor === 'RBEmpty_elm_builtin') {
				return acc;
			} else {
				var _v5 = f,
					_v6 = A3(
					f,
					_p1._1,
					_p1._2,
					A3(_elm_lang$core$Dict$foldl, f, acc, _p1._3)),
					_v7 = _p1._4;
				f = _v5;
				acc = _v6;
				dict = _v7;
				continue foldl;
			}
		}
	});
var _elm_lang$core$Dict$merge = F6(
	function (leftStep, bothStep, rightStep, leftDict, rightDict, initialResult) {
		var stepState = F3(
			function (rKey, rValue, _p2) {
				stepState:
				while (true) {
					var _p3 = _p2;
					var _p9 = _p3._1;
					var _p8 = _p3._0;
					var _p4 = _p8;
					if (_p4.ctor === '[]') {
						return {
							ctor: '_Tuple2',
							_0: _p8,
							_1: A3(rightStep, rKey, rValue, _p9)
						};
					} else {
						var _p7 = _p4._1;
						var _p6 = _p4._0._1;
						var _p5 = _p4._0._0;
						if (_elm_lang$core$Native_Utils.cmp(_p5, rKey) < 0) {
							var _v10 = rKey,
								_v11 = rValue,
								_v12 = {
								ctor: '_Tuple2',
								_0: _p7,
								_1: A3(leftStep, _p5, _p6, _p9)
							};
							rKey = _v10;
							rValue = _v11;
							_p2 = _v12;
							continue stepState;
						} else {
							if (_elm_lang$core$Native_Utils.cmp(_p5, rKey) > 0) {
								return {
									ctor: '_Tuple2',
									_0: _p8,
									_1: A3(rightStep, rKey, rValue, _p9)
								};
							} else {
								return {
									ctor: '_Tuple2',
									_0: _p7,
									_1: A4(bothStep, _p5, _p6, rValue, _p9)
								};
							}
						}
					}
				}
			});
		var _p10 = A3(
			_elm_lang$core$Dict$foldl,
			stepState,
			{
				ctor: '_Tuple2',
				_0: _elm_lang$core$Dict$toList(leftDict),
				_1: initialResult
			},
			rightDict);
		var leftovers = _p10._0;
		var intermediateResult = _p10._1;
		return A3(
			_elm_lang$core$List$foldl,
			F2(
				function (_p11, result) {
					var _p12 = _p11;
					return A3(leftStep, _p12._0, _p12._1, result);
				}),
			intermediateResult,
			leftovers);
	});
var _elm_lang$core$Dict$reportRemBug = F4(
	function (msg, c, lgot, rgot) {
		return _elm_lang$core$Native_Debug.crash(
			_elm_lang$core$String$concat(
				_elm_lang$core$Native_List.fromArray(
					[
						'Internal red-black tree invariant violated, expected ',
						msg,
						' and got ',
						_elm_lang$core$Basics$toString(c),
						'/',
						lgot,
						'/',
						rgot,
						'\nPlease report this bug to <https://github.com/elm-lang/core/issues>'
					])));
	});
var _elm_lang$core$Dict$isBBlack = function (dict) {
	var _p13 = dict;
	_v14_2:
	do {
		if (_p13.ctor === 'RBNode_elm_builtin') {
			if (_p13._0.ctor === 'BBlack') {
				return true;
			} else {
				break _v14_2;
			}
		} else {
			if (_p13._0.ctor === 'LBBlack') {
				return true;
			} else {
				break _v14_2;
			}
		}
	} while(false);
	return false;
};
var _elm_lang$core$Dict$sizeHelp = F2(
	function (n, dict) {
		sizeHelp:
		while (true) {
			var _p14 = dict;
			if (_p14.ctor === 'RBEmpty_elm_builtin') {
				return n;
			} else {
				var _v16 = A2(_elm_lang$core$Dict$sizeHelp, n + 1, _p14._4),
					_v17 = _p14._3;
				n = _v16;
				dict = _v17;
				continue sizeHelp;
			}
		}
	});
var _elm_lang$core$Dict$size = function (dict) {
	return A2(_elm_lang$core$Dict$sizeHelp, 0, dict);
};
var _elm_lang$core$Dict$get = F2(
	function (targetKey, dict) {
		get:
		while (true) {
			var _p15 = dict;
			if (_p15.ctor === 'RBEmpty_elm_builtin') {
				return _elm_lang$core$Maybe$Nothing;
			} else {
				var _p16 = A2(_elm_lang$core$Basics$compare, targetKey, _p15._1);
				switch (_p16.ctor) {
					case 'LT':
						var _v20 = targetKey,
							_v21 = _p15._3;
						targetKey = _v20;
						dict = _v21;
						continue get;
					case 'EQ':
						return _elm_lang$core$Maybe$Just(_p15._2);
					default:
						var _v22 = targetKey,
							_v23 = _p15._4;
						targetKey = _v22;
						dict = _v23;
						continue get;
				}
			}
		}
	});
var _elm_lang$core$Dict$member = F2(
	function (key, dict) {
		var _p17 = A2(_elm_lang$core$Dict$get, key, dict);
		if (_p17.ctor === 'Just') {
			return true;
		} else {
			return false;
		}
	});
var _elm_lang$core$Dict$maxWithDefault = F3(
	function (k, v, r) {
		maxWithDefault:
		while (true) {
			var _p18 = r;
			if (_p18.ctor === 'RBEmpty_elm_builtin') {
				return {ctor: '_Tuple2', _0: k, _1: v};
			} else {
				var _v26 = _p18._1,
					_v27 = _p18._2,
					_v28 = _p18._4;
				k = _v26;
				v = _v27;
				r = _v28;
				continue maxWithDefault;
			}
		}
	});
var _elm_lang$core$Dict$NBlack = {ctor: 'NBlack'};
var _elm_lang$core$Dict$BBlack = {ctor: 'BBlack'};
var _elm_lang$core$Dict$Black = {ctor: 'Black'};
var _elm_lang$core$Dict$blackish = function (t) {
	var _p19 = t;
	if (_p19.ctor === 'RBNode_elm_builtin') {
		var _p20 = _p19._0;
		return _elm_lang$core$Native_Utils.eq(_p20, _elm_lang$core$Dict$Black) || _elm_lang$core$Native_Utils.eq(_p20, _elm_lang$core$Dict$BBlack);
	} else {
		return true;
	}
};
var _elm_lang$core$Dict$Red = {ctor: 'Red'};
var _elm_lang$core$Dict$moreBlack = function (color) {
	var _p21 = color;
	switch (_p21.ctor) {
		case 'Black':
			return _elm_lang$core$Dict$BBlack;
		case 'Red':
			return _elm_lang$core$Dict$Black;
		case 'NBlack':
			return _elm_lang$core$Dict$Red;
		default:
			return _elm_lang$core$Native_Debug.crash('Can\'t make a double black node more black!');
	}
};
var _elm_lang$core$Dict$lessBlack = function (color) {
	var _p22 = color;
	switch (_p22.ctor) {
		case 'BBlack':
			return _elm_lang$core$Dict$Black;
		case 'Black':
			return _elm_lang$core$Dict$Red;
		case 'Red':
			return _elm_lang$core$Dict$NBlack;
		default:
			return _elm_lang$core$Native_Debug.crash('Can\'t make a negative black node less black!');
	}
};
var _elm_lang$core$Dict$LBBlack = {ctor: 'LBBlack'};
var _elm_lang$core$Dict$LBlack = {ctor: 'LBlack'};
var _elm_lang$core$Dict$RBEmpty_elm_builtin = function (a) {
	return {ctor: 'RBEmpty_elm_builtin', _0: a};
};
var _elm_lang$core$Dict$empty = _elm_lang$core$Dict$RBEmpty_elm_builtin(_elm_lang$core$Dict$LBlack);
var _elm_lang$core$Dict$isEmpty = function (dict) {
	return _elm_lang$core$Native_Utils.eq(dict, _elm_lang$core$Dict$empty);
};
var _elm_lang$core$Dict$RBNode_elm_builtin = F5(
	function (a, b, c, d, e) {
		return {ctor: 'RBNode_elm_builtin', _0: a, _1: b, _2: c, _3: d, _4: e};
	});
var _elm_lang$core$Dict$ensureBlackRoot = function (dict) {
	var _p23 = dict;
	if ((_p23.ctor === 'RBNode_elm_builtin') && (_p23._0.ctor === 'Red')) {
		return A5(_elm_lang$core$Dict$RBNode_elm_builtin, _elm_lang$core$Dict$Black, _p23._1, _p23._2, _p23._3, _p23._4);
	} else {
		return dict;
	}
};
var _elm_lang$core$Dict$lessBlackTree = function (dict) {
	var _p24 = dict;
	if (_p24.ctor === 'RBNode_elm_builtin') {
		return A5(
			_elm_lang$core$Dict$RBNode_elm_builtin,
			_elm_lang$core$Dict$lessBlack(_p24._0),
			_p24._1,
			_p24._2,
			_p24._3,
			_p24._4);
	} else {
		return _elm_lang$core$Dict$RBEmpty_elm_builtin(_elm_lang$core$Dict$LBlack);
	}
};
var _elm_lang$core$Dict$balancedTree = function (col) {
	return function (xk) {
		return function (xv) {
			return function (yk) {
				return function (yv) {
					return function (zk) {
						return function (zv) {
							return function (a) {
								return function (b) {
									return function (c) {
										return function (d) {
											return A5(
												_elm_lang$core$Dict$RBNode_elm_builtin,
												_elm_lang$core$Dict$lessBlack(col),
												yk,
												yv,
												A5(_elm_lang$core$Dict$RBNode_elm_builtin, _elm_lang$core$Dict$Black, xk, xv, a, b),
												A5(_elm_lang$core$Dict$RBNode_elm_builtin, _elm_lang$core$Dict$Black, zk, zv, c, d));
										};
									};
								};
							};
						};
					};
				};
			};
		};
	};
};
var _elm_lang$core$Dict$blacken = function (t) {
	var _p25 = t;
	if (_p25.ctor === 'RBEmpty_elm_builtin') {
		return _elm_lang$core$Dict$RBEmpty_elm_builtin(_elm_lang$core$Dict$LBlack);
	} else {
		return A5(_elm_lang$core$Dict$RBNode_elm_builtin, _elm_lang$core$Dict$Black, _p25._1, _p25._2, _p25._3, _p25._4);
	}
};
var _elm_lang$core$Dict$redden = function (t) {
	var _p26 = t;
	if (_p26.ctor === 'RBEmpty_elm_builtin') {
		return _elm_lang$core$Native_Debug.crash('can\'t make a Leaf red');
	} else {
		return A5(_elm_lang$core$Dict$RBNode_elm_builtin, _elm_lang$core$Dict$Red, _p26._1, _p26._2, _p26._3, _p26._4);
	}
};
var _elm_lang$core$Dict$balanceHelp = function (tree) {
	var _p27 = tree;
	_v36_6:
	do {
		_v36_5:
		do {
			_v36_4:
			do {
				_v36_3:
				do {
					_v36_2:
					do {
						_v36_1:
						do {
							_v36_0:
							do {
								if (_p27.ctor === 'RBNode_elm_builtin') {
									if (_p27._3.ctor === 'RBNode_elm_builtin') {
										if (_p27._4.ctor === 'RBNode_elm_builtin') {
											switch (_p27._3._0.ctor) {
												case 'Red':
													switch (_p27._4._0.ctor) {
														case 'Red':
															if ((_p27._3._3.ctor === 'RBNode_elm_builtin') && (_p27._3._3._0.ctor === 'Red')) {
																break _v36_0;
															} else {
																if ((_p27._3._4.ctor === 'RBNode_elm_builtin') && (_p27._3._4._0.ctor === 'Red')) {
																	break _v36_1;
																} else {
																	if ((_p27._4._3.ctor === 'RBNode_elm_builtin') && (_p27._4._3._0.ctor === 'Red')) {
																		break _v36_2;
																	} else {
																		if ((_p27._4._4.ctor === 'RBNode_elm_builtin') && (_p27._4._4._0.ctor === 'Red')) {
																			break _v36_3;
																		} else {
																			break _v36_6;
																		}
																	}
																}
															}
														case 'NBlack':
															if ((_p27._3._3.ctor === 'RBNode_elm_builtin') && (_p27._3._3._0.ctor === 'Red')) {
																break _v36_0;
															} else {
																if ((_p27._3._4.ctor === 'RBNode_elm_builtin') && (_p27._3._4._0.ctor === 'Red')) {
																	break _v36_1;
																} else {
																	if (((((_p27._0.ctor === 'BBlack') && (_p27._4._3.ctor === 'RBNode_elm_builtin')) && (_p27._4._3._0.ctor === 'Black')) && (_p27._4._4.ctor === 'RBNode_elm_builtin')) && (_p27._4._4._0.ctor === 'Black')) {
																		break _v36_4;
																	} else {
																		break _v36_6;
																	}
																}
															}
														default:
															if ((_p27._3._3.ctor === 'RBNode_elm_builtin') && (_p27._3._3._0.ctor === 'Red')) {
																break _v36_0;
															} else {
																if ((_p27._3._4.ctor === 'RBNode_elm_builtin') && (_p27._3._4._0.ctor === 'Red')) {
																	break _v36_1;
																} else {
																	break _v36_6;
																}
															}
													}
												case 'NBlack':
													switch (_p27._4._0.ctor) {
														case 'Red':
															if ((_p27._4._3.ctor === 'RBNode_elm_builtin') && (_p27._4._3._0.ctor === 'Red')) {
																break _v36_2;
															} else {
																if ((_p27._4._4.ctor === 'RBNode_elm_builtin') && (_p27._4._4._0.ctor === 'Red')) {
																	break _v36_3;
																} else {
																	if (((((_p27._0.ctor === 'BBlack') && (_p27._3._3.ctor === 'RBNode_elm_builtin')) && (_p27._3._3._0.ctor === 'Black')) && (_p27._3._4.ctor === 'RBNode_elm_builtin')) && (_p27._3._4._0.ctor === 'Black')) {
																		break _v36_5;
																	} else {
																		break _v36_6;
																	}
																}
															}
														case 'NBlack':
															if (_p27._0.ctor === 'BBlack') {
																if ((((_p27._4._3.ctor === 'RBNode_elm_builtin') && (_p27._4._3._0.ctor === 'Black')) && (_p27._4._4.ctor === 'RBNode_elm_builtin')) && (_p27._4._4._0.ctor === 'Black')) {
																	break _v36_4;
																} else {
																	if ((((_p27._3._3.ctor === 'RBNode_elm_builtin') && (_p27._3._3._0.ctor === 'Black')) && (_p27._3._4.ctor === 'RBNode_elm_builtin')) && (_p27._3._4._0.ctor === 'Black')) {
																		break _v36_5;
																	} else {
																		break _v36_6;
																	}
																}
															} else {
																break _v36_6;
															}
														default:
															if (((((_p27._0.ctor === 'BBlack') && (_p27._3._3.ctor === 'RBNode_elm_builtin')) && (_p27._3._3._0.ctor === 'Black')) && (_p27._3._4.ctor === 'RBNode_elm_builtin')) && (_p27._3._4._0.ctor === 'Black')) {
																break _v36_5;
															} else {
																break _v36_6;
															}
													}
												default:
													switch (_p27._4._0.ctor) {
														case 'Red':
															if ((_p27._4._3.ctor === 'RBNode_elm_builtin') && (_p27._4._3._0.ctor === 'Red')) {
																break _v36_2;
															} else {
																if ((_p27._4._4.ctor === 'RBNode_elm_builtin') && (_p27._4._4._0.ctor === 'Red')) {
																	break _v36_3;
																} else {
																	break _v36_6;
																}
															}
														case 'NBlack':
															if (((((_p27._0.ctor === 'BBlack') && (_p27._4._3.ctor === 'RBNode_elm_builtin')) && (_p27._4._3._0.ctor === 'Black')) && (_p27._4._4.ctor === 'RBNode_elm_builtin')) && (_p27._4._4._0.ctor === 'Black')) {
																break _v36_4;
															} else {
																break _v36_6;
															}
														default:
															break _v36_6;
													}
											}
										} else {
											switch (_p27._3._0.ctor) {
												case 'Red':
													if ((_p27._3._3.ctor === 'RBNode_elm_builtin') && (_p27._3._3._0.ctor === 'Red')) {
														break _v36_0;
													} else {
														if ((_p27._3._4.ctor === 'RBNode_elm_builtin') && (_p27._3._4._0.ctor === 'Red')) {
															break _v36_1;
														} else {
															break _v36_6;
														}
													}
												case 'NBlack':
													if (((((_p27._0.ctor === 'BBlack') && (_p27._3._3.ctor === 'RBNode_elm_builtin')) && (_p27._3._3._0.ctor === 'Black')) && (_p27._3._4.ctor === 'RBNode_elm_builtin')) && (_p27._3._4._0.ctor === 'Black')) {
														break _v36_5;
													} else {
														break _v36_6;
													}
												default:
													break _v36_6;
											}
										}
									} else {
										if (_p27._4.ctor === 'RBNode_elm_builtin') {
											switch (_p27._4._0.ctor) {
												case 'Red':
													if ((_p27._4._3.ctor === 'RBNode_elm_builtin') && (_p27._4._3._0.ctor === 'Red')) {
														break _v36_2;
													} else {
														if ((_p27._4._4.ctor === 'RBNode_elm_builtin') && (_p27._4._4._0.ctor === 'Red')) {
															break _v36_3;
														} else {
															break _v36_6;
														}
													}
												case 'NBlack':
													if (((((_p27._0.ctor === 'BBlack') && (_p27._4._3.ctor === 'RBNode_elm_builtin')) && (_p27._4._3._0.ctor === 'Black')) && (_p27._4._4.ctor === 'RBNode_elm_builtin')) && (_p27._4._4._0.ctor === 'Black')) {
														break _v36_4;
													} else {
														break _v36_6;
													}
												default:
													break _v36_6;
											}
										} else {
											break _v36_6;
										}
									}
								} else {
									break _v36_6;
								}
							} while(false);
							return _elm_lang$core$Dict$balancedTree(_p27._0)(_p27._3._3._1)(_p27._3._3._2)(_p27._3._1)(_p27._3._2)(_p27._1)(_p27._2)(_p27._3._3._3)(_p27._3._3._4)(_p27._3._4)(_p27._4);
						} while(false);
						return _elm_lang$core$Dict$balancedTree(_p27._0)(_p27._3._1)(_p27._3._2)(_p27._3._4._1)(_p27._3._4._2)(_p27._1)(_p27._2)(_p27._3._3)(_p27._3._4._3)(_p27._3._4._4)(_p27._4);
					} while(false);
					return _elm_lang$core$Dict$balancedTree(_p27._0)(_p27._1)(_p27._2)(_p27._4._3._1)(_p27._4._3._2)(_p27._4._1)(_p27._4._2)(_p27._3)(_p27._4._3._3)(_p27._4._3._4)(_p27._4._4);
				} while(false);
				return _elm_lang$core$Dict$balancedTree(_p27._0)(_p27._1)(_p27._2)(_p27._4._1)(_p27._4._2)(_p27._4._4._1)(_p27._4._4._2)(_p27._3)(_p27._4._3)(_p27._4._4._3)(_p27._4._4._4);
			} while(false);
			return A5(
				_elm_lang$core$Dict$RBNode_elm_builtin,
				_elm_lang$core$Dict$Black,
				_p27._4._3._1,
				_p27._4._3._2,
				A5(_elm_lang$core$Dict$RBNode_elm_builtin, _elm_lang$core$Dict$Black, _p27._1, _p27._2, _p27._3, _p27._4._3._3),
				A5(
					_elm_lang$core$Dict$balance,
					_elm_lang$core$Dict$Black,
					_p27._4._1,
					_p27._4._2,
					_p27._4._3._4,
					_elm_lang$core$Dict$redden(_p27._4._4)));
		} while(false);
		return A5(
			_elm_lang$core$Dict$RBNode_elm_builtin,
			_elm_lang$core$Dict$Black,
			_p27._3._4._1,
			_p27._3._4._2,
			A5(
				_elm_lang$core$Dict$balance,
				_elm_lang$core$Dict$Black,
				_p27._3._1,
				_p27._3._2,
				_elm_lang$core$Dict$redden(_p27._3._3),
				_p27._3._4._3),
			A5(_elm_lang$core$Dict$RBNode_elm_builtin, _elm_lang$core$Dict$Black, _p27._1, _p27._2, _p27._3._4._4, _p27._4));
	} while(false);
	return tree;
};
var _elm_lang$core$Dict$balance = F5(
	function (c, k, v, l, r) {
		var tree = A5(_elm_lang$core$Dict$RBNode_elm_builtin, c, k, v, l, r);
		return _elm_lang$core$Dict$blackish(tree) ? _elm_lang$core$Dict$balanceHelp(tree) : tree;
	});
var _elm_lang$core$Dict$bubble = F5(
	function (c, k, v, l, r) {
		return (_elm_lang$core$Dict$isBBlack(l) || _elm_lang$core$Dict$isBBlack(r)) ? A5(
			_elm_lang$core$Dict$balance,
			_elm_lang$core$Dict$moreBlack(c),
			k,
			v,
			_elm_lang$core$Dict$lessBlackTree(l),
			_elm_lang$core$Dict$lessBlackTree(r)) : A5(_elm_lang$core$Dict$RBNode_elm_builtin, c, k, v, l, r);
	});
var _elm_lang$core$Dict$removeMax = F5(
	function (c, k, v, l, r) {
		var _p28 = r;
		if (_p28.ctor === 'RBEmpty_elm_builtin') {
			return A3(_elm_lang$core$Dict$rem, c, l, r);
		} else {
			return A5(
				_elm_lang$core$Dict$bubble,
				c,
				k,
				v,
				l,
				A5(_elm_lang$core$Dict$removeMax, _p28._0, _p28._1, _p28._2, _p28._3, _p28._4));
		}
	});
var _elm_lang$core$Dict$rem = F3(
	function (c, l, r) {
		var _p29 = {ctor: '_Tuple2', _0: l, _1: r};
		if (_p29._0.ctor === 'RBEmpty_elm_builtin') {
			if (_p29._1.ctor === 'RBEmpty_elm_builtin') {
				var _p30 = c;
				switch (_p30.ctor) {
					case 'Red':
						return _elm_lang$core$Dict$RBEmpty_elm_builtin(_elm_lang$core$Dict$LBlack);
					case 'Black':
						return _elm_lang$core$Dict$RBEmpty_elm_builtin(_elm_lang$core$Dict$LBBlack);
					default:
						return _elm_lang$core$Native_Debug.crash('cannot have bblack or nblack nodes at this point');
				}
			} else {
				var _p33 = _p29._1._0;
				var _p32 = _p29._0._0;
				var _p31 = {ctor: '_Tuple3', _0: c, _1: _p32, _2: _p33};
				if ((((_p31.ctor === '_Tuple3') && (_p31._0.ctor === 'Black')) && (_p31._1.ctor === 'LBlack')) && (_p31._2.ctor === 'Red')) {
					return A5(_elm_lang$core$Dict$RBNode_elm_builtin, _elm_lang$core$Dict$Black, _p29._1._1, _p29._1._2, _p29._1._3, _p29._1._4);
				} else {
					return A4(
						_elm_lang$core$Dict$reportRemBug,
						'Black/LBlack/Red',
						c,
						_elm_lang$core$Basics$toString(_p32),
						_elm_lang$core$Basics$toString(_p33));
				}
			}
		} else {
			if (_p29._1.ctor === 'RBEmpty_elm_builtin') {
				var _p36 = _p29._1._0;
				var _p35 = _p29._0._0;
				var _p34 = {ctor: '_Tuple3', _0: c, _1: _p35, _2: _p36};
				if ((((_p34.ctor === '_Tuple3') && (_p34._0.ctor === 'Black')) && (_p34._1.ctor === 'Red')) && (_p34._2.ctor === 'LBlack')) {
					return A5(_elm_lang$core$Dict$RBNode_elm_builtin, _elm_lang$core$Dict$Black, _p29._0._1, _p29._0._2, _p29._0._3, _p29._0._4);
				} else {
					return A4(
						_elm_lang$core$Dict$reportRemBug,
						'Black/Red/LBlack',
						c,
						_elm_lang$core$Basics$toString(_p35),
						_elm_lang$core$Basics$toString(_p36));
				}
			} else {
				var _p40 = _p29._0._2;
				var _p39 = _p29._0._4;
				var _p38 = _p29._0._1;
				var l$ = A5(_elm_lang$core$Dict$removeMax, _p29._0._0, _p38, _p40, _p29._0._3, _p39);
				var _p37 = A3(_elm_lang$core$Dict$maxWithDefault, _p38, _p40, _p39);
				var k = _p37._0;
				var v = _p37._1;
				return A5(_elm_lang$core$Dict$bubble, c, k, v, l$, r);
			}
		}
	});
var _elm_lang$core$Dict$map = F2(
	function (f, dict) {
		var _p41 = dict;
		if (_p41.ctor === 'RBEmpty_elm_builtin') {
			return _elm_lang$core$Dict$RBEmpty_elm_builtin(_elm_lang$core$Dict$LBlack);
		} else {
			var _p42 = _p41._1;
			return A5(
				_elm_lang$core$Dict$RBNode_elm_builtin,
				_p41._0,
				_p42,
				A2(f, _p42, _p41._2),
				A2(_elm_lang$core$Dict$map, f, _p41._3),
				A2(_elm_lang$core$Dict$map, f, _p41._4));
		}
	});
var _elm_lang$core$Dict$Same = {ctor: 'Same'};
var _elm_lang$core$Dict$Remove = {ctor: 'Remove'};
var _elm_lang$core$Dict$Insert = {ctor: 'Insert'};
var _elm_lang$core$Dict$update = F3(
	function (k, alter, dict) {
		var up = function (dict) {
			var _p43 = dict;
			if (_p43.ctor === 'RBEmpty_elm_builtin') {
				var _p44 = alter(_elm_lang$core$Maybe$Nothing);
				if (_p44.ctor === 'Nothing') {
					return {ctor: '_Tuple2', _0: _elm_lang$core$Dict$Same, _1: _elm_lang$core$Dict$empty};
				} else {
					return {
						ctor: '_Tuple2',
						_0: _elm_lang$core$Dict$Insert,
						_1: A5(_elm_lang$core$Dict$RBNode_elm_builtin, _elm_lang$core$Dict$Red, k, _p44._0, _elm_lang$core$Dict$empty, _elm_lang$core$Dict$empty)
					};
				}
			} else {
				var _p55 = _p43._2;
				var _p54 = _p43._4;
				var _p53 = _p43._3;
				var _p52 = _p43._1;
				var _p51 = _p43._0;
				var _p45 = A2(_elm_lang$core$Basics$compare, k, _p52);
				switch (_p45.ctor) {
					case 'EQ':
						var _p46 = alter(
							_elm_lang$core$Maybe$Just(_p55));
						if (_p46.ctor === 'Nothing') {
							return {
								ctor: '_Tuple2',
								_0: _elm_lang$core$Dict$Remove,
								_1: A3(_elm_lang$core$Dict$rem, _p51, _p53, _p54)
							};
						} else {
							return {
								ctor: '_Tuple2',
								_0: _elm_lang$core$Dict$Same,
								_1: A5(_elm_lang$core$Dict$RBNode_elm_builtin, _p51, _p52, _p46._0, _p53, _p54)
							};
						}
					case 'LT':
						var _p47 = up(_p53);
						var flag = _p47._0;
						var newLeft = _p47._1;
						var _p48 = flag;
						switch (_p48.ctor) {
							case 'Same':
								return {
									ctor: '_Tuple2',
									_0: _elm_lang$core$Dict$Same,
									_1: A5(_elm_lang$core$Dict$RBNode_elm_builtin, _p51, _p52, _p55, newLeft, _p54)
								};
							case 'Insert':
								return {
									ctor: '_Tuple2',
									_0: _elm_lang$core$Dict$Insert,
									_1: A5(_elm_lang$core$Dict$balance, _p51, _p52, _p55, newLeft, _p54)
								};
							default:
								return {
									ctor: '_Tuple2',
									_0: _elm_lang$core$Dict$Remove,
									_1: A5(_elm_lang$core$Dict$bubble, _p51, _p52, _p55, newLeft, _p54)
								};
						}
					default:
						var _p49 = up(_p54);
						var flag = _p49._0;
						var newRight = _p49._1;
						var _p50 = flag;
						switch (_p50.ctor) {
							case 'Same':
								return {
									ctor: '_Tuple2',
									_0: _elm_lang$core$Dict$Same,
									_1: A5(_elm_lang$core$Dict$RBNode_elm_builtin, _p51, _p52, _p55, _p53, newRight)
								};
							case 'Insert':
								return {
									ctor: '_Tuple2',
									_0: _elm_lang$core$Dict$Insert,
									_1: A5(_elm_lang$core$Dict$balance, _p51, _p52, _p55, _p53, newRight)
								};
							default:
								return {
									ctor: '_Tuple2',
									_0: _elm_lang$core$Dict$Remove,
									_1: A5(_elm_lang$core$Dict$bubble, _p51, _p52, _p55, _p53, newRight)
								};
						}
				}
			}
		};
		var _p56 = up(dict);
		var flag = _p56._0;
		var updatedDict = _p56._1;
		var _p57 = flag;
		switch (_p57.ctor) {
			case 'Same':
				return updatedDict;
			case 'Insert':
				return _elm_lang$core$Dict$ensureBlackRoot(updatedDict);
			default:
				return _elm_lang$core$Dict$blacken(updatedDict);
		}
	});
var _elm_lang$core$Dict$insert = F3(
	function (key, value, dict) {
		return A3(
			_elm_lang$core$Dict$update,
			key,
			_elm_lang$core$Basics$always(
				_elm_lang$core$Maybe$Just(value)),
			dict);
	});
var _elm_lang$core$Dict$singleton = F2(
	function (key, value) {
		return A3(_elm_lang$core$Dict$insert, key, value, _elm_lang$core$Dict$empty);
	});
var _elm_lang$core$Dict$union = F2(
	function (t1, t2) {
		return A3(_elm_lang$core$Dict$foldl, _elm_lang$core$Dict$insert, t2, t1);
	});
var _elm_lang$core$Dict$filter = F2(
	function (predicate, dictionary) {
		var add = F3(
			function (key, value, dict) {
				return A2(predicate, key, value) ? A3(_elm_lang$core$Dict$insert, key, value, dict) : dict;
			});
		return A3(_elm_lang$core$Dict$foldl, add, _elm_lang$core$Dict$empty, dictionary);
	});
var _elm_lang$core$Dict$intersect = F2(
	function (t1, t2) {
		return A2(
			_elm_lang$core$Dict$filter,
			F2(
				function (k, _p58) {
					return A2(_elm_lang$core$Dict$member, k, t2);
				}),
			t1);
	});
var _elm_lang$core$Dict$partition = F2(
	function (predicate, dict) {
		var add = F3(
			function (key, value, _p59) {
				var _p60 = _p59;
				var _p62 = _p60._1;
				var _p61 = _p60._0;
				return A2(predicate, key, value) ? {
					ctor: '_Tuple2',
					_0: A3(_elm_lang$core$Dict$insert, key, value, _p61),
					_1: _p62
				} : {
					ctor: '_Tuple2',
					_0: _p61,
					_1: A3(_elm_lang$core$Dict$insert, key, value, _p62)
				};
			});
		return A3(
			_elm_lang$core$Dict$foldl,
			add,
			{ctor: '_Tuple2', _0: _elm_lang$core$Dict$empty, _1: _elm_lang$core$Dict$empty},
			dict);
	});
var _elm_lang$core$Dict$fromList = function (assocs) {
	return A3(
		_elm_lang$core$List$foldl,
		F2(
			function (_p63, dict) {
				var _p64 = _p63;
				return A3(_elm_lang$core$Dict$insert, _p64._0, _p64._1, dict);
			}),
		_elm_lang$core$Dict$empty,
		assocs);
};
var _elm_lang$core$Dict$remove = F2(
	function (key, dict) {
		return A3(
			_elm_lang$core$Dict$update,
			key,
			_elm_lang$core$Basics$always(_elm_lang$core$Maybe$Nothing),
			dict);
	});
var _elm_lang$core$Dict$diff = F2(
	function (t1, t2) {
		return A3(
			_elm_lang$core$Dict$foldl,
			F3(
				function (k, v, t) {
					return A2(_elm_lang$core$Dict$remove, k, t);
				}),
			t1,
			t2);
	});

//import Maybe, Native.Array, Native.List, Native.Utils, Result //

var _elm_lang$core$Native_Json = function() {


// CORE DECODERS

function succeed(msg)
{
	return {
		ctor: '<decoder>',
		tag: 'succeed',
		msg: msg
	};
}

function fail(msg)
{
	return {
		ctor: '<decoder>',
		tag: 'fail',
		msg: msg
	};
}

function decodePrimitive(tag)
{
	return {
		ctor: '<decoder>',
		tag: tag
	};
}

function decodeContainer(tag, decoder)
{
	return {
		ctor: '<decoder>',
		tag: tag,
		decoder: decoder
	};
}

function decodeNull(value)
{
	return {
		ctor: '<decoder>',
		tag: 'null',
		value: value
	};
}

function decodeField(field, decoder)
{
	return {
		ctor: '<decoder>',
		tag: 'field',
		field: field,
		decoder: decoder
	};
}

function decodeKeyValuePairs(decoder)
{
	return {
		ctor: '<decoder>',
		tag: 'key-value',
		decoder: decoder
	};
}

function decodeObject(f, decoders)
{
	return {
		ctor: '<decoder>',
		tag: 'map-many',
		func: f,
		decoders: decoders
	};
}

function decodeTuple(f, decoders)
{
	return {
		ctor: '<decoder>',
		tag: 'tuple',
		func: f,
		decoders: decoders
	};
}

function andThen(decoder, callback)
{
	return {
		ctor: '<decoder>',
		tag: 'andThen',
		decoder: decoder,
		callback: callback
	};
}

function customAndThen(decoder, callback)
{
	return {
		ctor: '<decoder>',
		tag: 'customAndThen',
		decoder: decoder,
		callback: callback
	};
}

function oneOf(decoders)
{
	return {
		ctor: '<decoder>',
		tag: 'oneOf',
		decoders: decoders
	};
}


// DECODING OBJECTS

function decodeObject1(f, d1)
{
	return decodeObject(f, [d1]);
}

function decodeObject2(f, d1, d2)
{
	return decodeObject(f, [d1, d2]);
}

function decodeObject3(f, d1, d2, d3)
{
	return decodeObject(f, [d1, d2, d3]);
}

function decodeObject4(f, d1, d2, d3, d4)
{
	return decodeObject(f, [d1, d2, d3, d4]);
}

function decodeObject5(f, d1, d2, d3, d4, d5)
{
	return decodeObject(f, [d1, d2, d3, d4, d5]);
}

function decodeObject6(f, d1, d2, d3, d4, d5, d6)
{
	return decodeObject(f, [d1, d2, d3, d4, d5, d6]);
}

function decodeObject7(f, d1, d2, d3, d4, d5, d6, d7)
{
	return decodeObject(f, [d1, d2, d3, d4, d5, d6, d7]);
}

function decodeObject8(f, d1, d2, d3, d4, d5, d6, d7, d8)
{
	return decodeObject(f, [d1, d2, d3, d4, d5, d6, d7, d8]);
}


// DECODING TUPLES

function decodeTuple1(f, d1)
{
	return decodeTuple(f, [d1]);
}

function decodeTuple2(f, d1, d2)
{
	return decodeTuple(f, [d1, d2]);
}

function decodeTuple3(f, d1, d2, d3)
{
	return decodeTuple(f, [d1, d2, d3]);
}

function decodeTuple4(f, d1, d2, d3, d4)
{
	return decodeTuple(f, [d1, d2, d3, d4]);
}

function decodeTuple5(f, d1, d2, d3, d4, d5)
{
	return decodeTuple(f, [d1, d2, d3, d4, d5]);
}

function decodeTuple6(f, d1, d2, d3, d4, d5, d6)
{
	return decodeTuple(f, [d1, d2, d3, d4, d5, d6]);
}

function decodeTuple7(f, d1, d2, d3, d4, d5, d6, d7)
{
	return decodeTuple(f, [d1, d2, d3, d4, d5, d6, d7]);
}

function decodeTuple8(f, d1, d2, d3, d4, d5, d6, d7, d8)
{
	return decodeTuple(f, [d1, d2, d3, d4, d5, d6, d7, d8]);
}


// DECODE HELPERS

function ok(value)
{
	return { tag: 'ok', value: value };
}

function badPrimitive(type, value)
{
	return { tag: 'primitive', type: type, value: value };
}

function badIndex(index, nestedProblems)
{
	return { tag: 'index', index: index, rest: nestedProblems };
}

function badField(field, nestedProblems)
{
	return { tag: 'field', field: field, rest: nestedProblems };
}

function badOneOf(problems)
{
	return { tag: 'oneOf', problems: problems };
}

function badCustom(msg)
{
	return { tag: 'custom', msg: msg };
}

function bad(msg)
{
	return { tag: 'fail', msg: msg };
}

function badToString(problem)
{
	var context = '_';
	while (problem)
	{
		switch (problem.tag)
		{
			case 'primitive':
				return 'Expecting ' + problem.type
					+ (context === '_' ? '' : ' at ' + context)
					+ ' but instead got: ' + jsToString(problem.value);

			case 'index':
				context += '[' + problem.index + ']';
				problem = problem.rest;
				break;

			case 'field':
				context += '.' + problem.field;
				problem = problem.rest;
				break;

			case 'oneOf':
				var problems = problem.problems;
				for (var i = 0; i < problems.length; i++)
				{
					problems[i] = badToString(problems[i]);
				}
				return 'I ran into the following problems'
					+ (context === '_' ? '' : ' at ' + context)
					+ ':\n\n' + problems.join('\n');

			case 'custom':
				return 'A `customDecoder` failed'
					+ (context === '_' ? '' : ' at ' + context)
					+ ' with the message: ' + problem.msg;

			case 'fail':
				return 'I ran into a `fail` decoder'
					+ (context === '_' ? '' : ' at ' + context)
					+ ': ' + problem.msg;
		}
	}
}

function jsToString(value)
{
	return value === undefined
		? 'undefined'
		: JSON.stringify(value);
}


// DECODE

function runOnString(decoder, string)
{
	var json;
	try
	{
		json = JSON.parse(string);
	}
	catch (e)
	{
		return _elm_lang$core$Result$Err('Given an invalid JSON: ' + e.message);
	}
	return run(decoder, json);
}

function run(decoder, value)
{
	var result = runHelp(decoder, value);
	return (result.tag === 'ok')
		? _elm_lang$core$Result$Ok(result.value)
		: _elm_lang$core$Result$Err(badToString(result));
}

function runHelp(decoder, value)
{
	switch (decoder.tag)
	{
		case 'bool':
			return (typeof value === 'boolean')
				? ok(value)
				: badPrimitive('a Bool', value);

		case 'int':
			if (typeof value !== 'number') {
				return badPrimitive('an Int', value);
			}

			if (-2147483647 < value && value < 2147483647 && (value | 0) === value) {
				return ok(value);
			}

			if (isFinite(value) && !(value % 1)) {
				return ok(value);
			}

			return badPrimitive('an Int', value);

		case 'float':
			return (typeof value === 'number')
				? ok(value)
				: badPrimitive('a Float', value);

		case 'string':
			return (typeof value === 'string')
				? ok(value)
				: (value instanceof String)
					? ok(value + '')
					: badPrimitive('a String', value);

		case 'null':
			return (value === null)
				? ok(decoder.value)
				: badPrimitive('null', value);

		case 'value':
			return ok(value);

		case 'list':
			if (!(value instanceof Array))
			{
				return badPrimitive('a List', value);
			}

			var list = _elm_lang$core$Native_List.Nil;
			for (var i = value.length; i--; )
			{
				var result = runHelp(decoder.decoder, value[i]);
				if (result.tag !== 'ok')
				{
					return badIndex(i, result)
				}
				list = _elm_lang$core$Native_List.Cons(result.value, list);
			}
			return ok(list);

		case 'array':
			if (!(value instanceof Array))
			{
				return badPrimitive('an Array', value);
			}

			var len = value.length;
			var array = new Array(len);
			for (var i = len; i--; )
			{
				var result = runHelp(decoder.decoder, value[i]);
				if (result.tag !== 'ok')
				{
					return badIndex(i, result);
				}
				array[i] = result.value;
			}
			return ok(_elm_lang$core$Native_Array.fromJSArray(array));

		case 'maybe':
			var result = runHelp(decoder.decoder, value);
			return (result.tag === 'ok')
				? ok(_elm_lang$core$Maybe$Just(result.value))
				: ok(_elm_lang$core$Maybe$Nothing);

		case 'field':
			var field = decoder.field;
			if (typeof value !== 'object' || value === null || !(field in value))
			{
				return badPrimitive('an object with a field named `' + field + '`', value);
			}

			var result = runHelp(decoder.decoder, value[field]);
			return (result.tag === 'ok')
				? result
				: badField(field, result);

		case 'key-value':
			if (typeof value !== 'object' || value === null || value instanceof Array)
			{
				return badPrimitive('an object', value);
			}

			var keyValuePairs = _elm_lang$core$Native_List.Nil;
			for (var key in value)
			{
				var result = runHelp(decoder.decoder, value[key]);
				if (result.tag !== 'ok')
				{
					return badField(key, result);
				}
				var pair = _elm_lang$core$Native_Utils.Tuple2(key, result.value);
				keyValuePairs = _elm_lang$core$Native_List.Cons(pair, keyValuePairs);
			}
			return ok(keyValuePairs);

		case 'map-many':
			var answer = decoder.func;
			var decoders = decoder.decoders;
			for (var i = 0; i < decoders.length; i++)
			{
				var result = runHelp(decoders[i], value);
				if (result.tag !== 'ok')
				{
					return result;
				}
				answer = answer(result.value);
			}
			return ok(answer);

		case 'tuple':
			var decoders = decoder.decoders;
			var len = decoders.length;

			if ( !(value instanceof Array) || value.length !== len )
			{
				return badPrimitive('a Tuple with ' + len + ' entries', value);
			}

			var answer = decoder.func;
			for (var i = 0; i < len; i++)
			{
				var result = runHelp(decoders[i], value[i]);
				if (result.tag !== 'ok')
				{
					return badIndex(i, result);
				}
				answer = answer(result.value);
			}
			return ok(answer);

		case 'customAndThen':
			var result = runHelp(decoder.decoder, value);
			if (result.tag !== 'ok')
			{
				return result;
			}
			var realResult = decoder.callback(result.value);
			if (realResult.ctor === 'Err')
			{
				return badCustom(realResult._0);
			}
			return ok(realResult._0);

		case 'andThen':
			var result = runHelp(decoder.decoder, value);
			return (result.tag !== 'ok')
				? result
				: runHelp(decoder.callback(result.value), value);

		case 'oneOf':
			var errors = [];
			var temp = decoder.decoders;
			while (temp.ctor !== '[]')
			{
				var result = runHelp(temp._0, value);

				if (result.tag === 'ok')
				{
					return result;
				}

				errors.push(result);

				temp = temp._1;
			}
			return badOneOf(errors);

		case 'fail':
			return bad(decoder.msg);

		case 'succeed':
			return ok(decoder.msg);
	}
}


// EQUALITY

function equality(a, b)
{
	if (a === b)
	{
		return true;
	}

	if (a.tag !== b.tag)
	{
		return false;
	}

	switch (a.tag)
	{
		case 'succeed':
		case 'fail':
			return a.msg === b.msg;

		case 'bool':
		case 'int':
		case 'float':
		case 'string':
		case 'value':
			return true;

		case 'null':
			return a.value === b.value;

		case 'list':
		case 'array':
		case 'maybe':
		case 'key-value':
			return equality(a.decoder, b.decoder);

		case 'field':
			return a.field === b.field && equality(a.decoder, b.decoder);

		case 'map-many':
		case 'tuple':
			if (a.func !== b.func)
			{
				return false;
			}
			return listEquality(a.decoders, b.decoders);

		case 'andThen':
		case 'customAndThen':
			return a.callback === b.callback && equality(a.decoder, b.decoder);

		case 'oneOf':
			return listEquality(a.decoders, b.decoders);
	}
}

function listEquality(aDecoders, bDecoders)
{
	var len = aDecoders.length;
	if (len !== bDecoders.length)
	{
		return false;
	}
	for (var i = 0; i < len; i++)
	{
		if (!equality(aDecoders[i], bDecoders[i]))
		{
			return false;
		}
	}
	return true;
}


// ENCODE

function encode(indentLevel, value)
{
	return JSON.stringify(value, null, indentLevel);
}

function identity(value)
{
	return value;
}

function encodeObject(keyValuePairs)
{
	var obj = {};
	while (keyValuePairs.ctor !== '[]')
	{
		var pair = keyValuePairs._0;
		obj[pair._0] = pair._1;
		keyValuePairs = keyValuePairs._1;
	}
	return obj;
}

return {
	encode: F2(encode),
	runOnString: F2(runOnString),
	run: F2(run),

	decodeNull: decodeNull,
	decodePrimitive: decodePrimitive,
	decodeContainer: F2(decodeContainer),

	decodeField: F2(decodeField),

	decodeObject1: F2(decodeObject1),
	decodeObject2: F3(decodeObject2),
	decodeObject3: F4(decodeObject3),
	decodeObject4: F5(decodeObject4),
	decodeObject5: F6(decodeObject5),
	decodeObject6: F7(decodeObject6),
	decodeObject7: F8(decodeObject7),
	decodeObject8: F9(decodeObject8),
	decodeKeyValuePairs: decodeKeyValuePairs,

	decodeTuple1: F2(decodeTuple1),
	decodeTuple2: F3(decodeTuple2),
	decodeTuple3: F4(decodeTuple3),
	decodeTuple4: F5(decodeTuple4),
	decodeTuple5: F6(decodeTuple5),
	decodeTuple6: F7(decodeTuple6),
	decodeTuple7: F8(decodeTuple7),
	decodeTuple8: F9(decodeTuple8),

	andThen: F2(andThen),
	customAndThen: F2(customAndThen),
	fail: fail,
	succeed: succeed,
	oneOf: oneOf,

	identity: identity,
	encodeNull: null,
	encodeArray: _elm_lang$core$Native_Array.toJSArray,
	encodeList: _elm_lang$core$Native_List.toArray,
	encodeObject: encodeObject,

	equality: equality
};

}();

var _elm_lang$core$Json_Encode$list = _elm_lang$core$Native_Json.encodeList;
var _elm_lang$core$Json_Encode$array = _elm_lang$core$Native_Json.encodeArray;
var _elm_lang$core$Json_Encode$object = _elm_lang$core$Native_Json.encodeObject;
var _elm_lang$core$Json_Encode$null = _elm_lang$core$Native_Json.encodeNull;
var _elm_lang$core$Json_Encode$bool = _elm_lang$core$Native_Json.identity;
var _elm_lang$core$Json_Encode$float = _elm_lang$core$Native_Json.identity;
var _elm_lang$core$Json_Encode$int = _elm_lang$core$Native_Json.identity;
var _elm_lang$core$Json_Encode$string = _elm_lang$core$Native_Json.identity;
var _elm_lang$core$Json_Encode$encode = _elm_lang$core$Native_Json.encode;
var _elm_lang$core$Json_Encode$Value = {ctor: 'Value'};

var _elm_lang$core$Json_Decode$tuple8 = _elm_lang$core$Native_Json.decodeTuple8;
var _elm_lang$core$Json_Decode$tuple7 = _elm_lang$core$Native_Json.decodeTuple7;
var _elm_lang$core$Json_Decode$tuple6 = _elm_lang$core$Native_Json.decodeTuple6;
var _elm_lang$core$Json_Decode$tuple5 = _elm_lang$core$Native_Json.decodeTuple5;
var _elm_lang$core$Json_Decode$tuple4 = _elm_lang$core$Native_Json.decodeTuple4;
var _elm_lang$core$Json_Decode$tuple3 = _elm_lang$core$Native_Json.decodeTuple3;
var _elm_lang$core$Json_Decode$tuple2 = _elm_lang$core$Native_Json.decodeTuple2;
var _elm_lang$core$Json_Decode$tuple1 = _elm_lang$core$Native_Json.decodeTuple1;
var _elm_lang$core$Json_Decode$succeed = _elm_lang$core$Native_Json.succeed;
var _elm_lang$core$Json_Decode$fail = _elm_lang$core$Native_Json.fail;
var _elm_lang$core$Json_Decode$andThen = _elm_lang$core$Native_Json.andThen;
var _elm_lang$core$Json_Decode$customDecoder = _elm_lang$core$Native_Json.customAndThen;
var _elm_lang$core$Json_Decode$decodeValue = _elm_lang$core$Native_Json.run;
var _elm_lang$core$Json_Decode$value = _elm_lang$core$Native_Json.decodePrimitive('value');
var _elm_lang$core$Json_Decode$maybe = function (decoder) {
	return A2(_elm_lang$core$Native_Json.decodeContainer, 'maybe', decoder);
};
var _elm_lang$core$Json_Decode$null = _elm_lang$core$Native_Json.decodeNull;
var _elm_lang$core$Json_Decode$array = function (decoder) {
	return A2(_elm_lang$core$Native_Json.decodeContainer, 'array', decoder);
};
var _elm_lang$core$Json_Decode$list = function (decoder) {
	return A2(_elm_lang$core$Native_Json.decodeContainer, 'list', decoder);
};
var _elm_lang$core$Json_Decode$bool = _elm_lang$core$Native_Json.decodePrimitive('bool');
var _elm_lang$core$Json_Decode$int = _elm_lang$core$Native_Json.decodePrimitive('int');
var _elm_lang$core$Json_Decode$float = _elm_lang$core$Native_Json.decodePrimitive('float');
var _elm_lang$core$Json_Decode$string = _elm_lang$core$Native_Json.decodePrimitive('string');
var _elm_lang$core$Json_Decode$oneOf = _elm_lang$core$Native_Json.oneOf;
var _elm_lang$core$Json_Decode$keyValuePairs = _elm_lang$core$Native_Json.decodeKeyValuePairs;
var _elm_lang$core$Json_Decode$object8 = _elm_lang$core$Native_Json.decodeObject8;
var _elm_lang$core$Json_Decode$object7 = _elm_lang$core$Native_Json.decodeObject7;
var _elm_lang$core$Json_Decode$object6 = _elm_lang$core$Native_Json.decodeObject6;
var _elm_lang$core$Json_Decode$object5 = _elm_lang$core$Native_Json.decodeObject5;
var _elm_lang$core$Json_Decode$object4 = _elm_lang$core$Native_Json.decodeObject4;
var _elm_lang$core$Json_Decode$object3 = _elm_lang$core$Native_Json.decodeObject3;
var _elm_lang$core$Json_Decode$object2 = _elm_lang$core$Native_Json.decodeObject2;
var _elm_lang$core$Json_Decode$object1 = _elm_lang$core$Native_Json.decodeObject1;
var _elm_lang$core$Json_Decode_ops = _elm_lang$core$Json_Decode_ops || {};
_elm_lang$core$Json_Decode_ops[':='] = _elm_lang$core$Native_Json.decodeField;
var _elm_lang$core$Json_Decode$at = F2(
	function (fields, decoder) {
		return A3(
			_elm_lang$core$List$foldr,
			F2(
				function (x, y) {
					return A2(_elm_lang$core$Json_Decode_ops[':='], x, y);
				}),
			decoder,
			fields);
	});
var _elm_lang$core$Json_Decode$decodeString = _elm_lang$core$Native_Json.runOnString;
var _elm_lang$core$Json_Decode$map = _elm_lang$core$Native_Json.decodeObject1;
var _elm_lang$core$Json_Decode$dict = function (decoder) {
	return A2(
		_elm_lang$core$Json_Decode$map,
		_elm_lang$core$Dict$fromList,
		_elm_lang$core$Json_Decode$keyValuePairs(decoder));
};
var _elm_lang$core$Json_Decode$Decoder = {ctor: 'Decoder'};

//import Native.Json //

var _elm_lang$virtual_dom$Native_VirtualDom = function() {

var STYLE_KEY = 'STYLE';
var EVENT_KEY = 'EVENT';
var ATTR_KEY = 'ATTR';
var ATTR_NS_KEY = 'ATTR_NS';



////////////  VIRTUAL DOM NODES  ////////////


function text(string)
{
	return {
		type: 'text',
		text: string
	};
}


function node(tag)
{
	return F2(function(factList, kidList) {
		return nodeHelp(tag, factList, kidList);
	});
}


function nodeHelp(tag, factList, kidList)
{
	var organized = organizeFacts(factList);
	var namespace = organized.namespace;
	var facts = organized.facts;

	var children = [];
	var descendantsCount = 0;
	while (kidList.ctor !== '[]')
	{
		var kid = kidList._0;
		descendantsCount += (kid.descendantsCount || 0);
		children.push(kid);
		kidList = kidList._1;
	}
	descendantsCount += children.length;

	return {
		type: 'node',
		tag: tag,
		facts: facts,
		children: children,
		namespace: namespace,
		descendantsCount: descendantsCount
	};
}


function keyedNode(tag, factList, kidList)
{
	var organized = organizeFacts(factList);
	var namespace = organized.namespace;
	var facts = organized.facts;

	var children = [];
	var descendantsCount = 0;
	while (kidList.ctor !== '[]')
	{
		var kid = kidList._0;
		descendantsCount += (kid._1.descendantsCount || 0);
		children.push(kid);
		kidList = kidList._1;
	}
	descendantsCount += children.length;

	return {
		type: 'keyed-node',
		tag: tag,
		facts: facts,
		children: children,
		namespace: namespace,
		descendantsCount: descendantsCount
	};
}


function custom(factList, model, impl)
{
	var facts = organizeFacts(factList).facts;

	return {
		type: 'custom',
		facts: facts,
		model: model,
		impl: impl
	};
}


function map(tagger, node)
{
	return {
		type: 'tagger',
		tagger: tagger,
		node: node,
		descendantsCount: 1 + (node.descendantsCount || 0)
	};
}


function thunk(func, args, thunk)
{
	return {
		type: 'thunk',
		func: func,
		args: args,
		thunk: thunk,
		node: undefined
	};
}

function lazy(fn, a)
{
	return thunk(fn, [a], function() {
		return fn(a);
	});
}

function lazy2(fn, a, b)
{
	return thunk(fn, [a,b], function() {
		return A2(fn, a, b);
	});
}

function lazy3(fn, a, b, c)
{
	return thunk(fn, [a,b,c], function() {
		return A3(fn, a, b, c);
	});
}



// FACTS


function organizeFacts(factList)
{
	var namespace, facts = {};

	while (factList.ctor !== '[]')
	{
		var entry = factList._0;
		var key = entry.key;

		if (key === ATTR_KEY || key === ATTR_NS_KEY || key === EVENT_KEY)
		{
			var subFacts = facts[key] || {};
			subFacts[entry.realKey] = entry.value;
			facts[key] = subFacts;
		}
		else if (key === STYLE_KEY)
		{
			var styles = facts[key] || {};
			var styleList = entry.value;
			while (styleList.ctor !== '[]')
			{
				var style = styleList._0;
				styles[style._0] = style._1;
				styleList = styleList._1;
			}
			facts[key] = styles;
		}
		else if (key === 'namespace')
		{
			namespace = entry.value;
		}
		else
		{
			facts[key] = entry.value;
		}
		factList = factList._1;
	}

	return {
		facts: facts,
		namespace: namespace
	};
}



////////////  PROPERTIES AND ATTRIBUTES  ////////////


function style(value)
{
	return {
		key: STYLE_KEY,
		value: value
	};
}


function property(key, value)
{
	return {
		key: key,
		value: value
	};
}


function attribute(key, value)
{
	return {
		key: ATTR_KEY,
		realKey: key,
		value: value
	};
}


function attributeNS(namespace, key, value)
{
	return {
		key: ATTR_NS_KEY,
		realKey: key,
		value: {
			value: value,
			namespace: namespace
		}
	};
}


function on(name, options, decoder)
{
	return {
		key: EVENT_KEY,
		realKey: name,
		value: {
			options: options,
			decoder: decoder
		}
	};
}


function equalEvents(a, b)
{
	if (!a.options === b.options)
	{
		if (a.stopPropagation !== b.stopPropagation || a.preventDefault !== b.preventDefault)
		{
			return false;
		}
	}
	return _elm_lang$core$Native_Json.equality(a.decoder, b.decoder);
}



////////////  RENDERER  ////////////


function renderer(parent, tagger, initialVirtualNode)
{
	var eventNode = { tagger: tagger, parent: undefined };

	var domNode = render(initialVirtualNode, eventNode);
	parent.appendChild(domNode);

	var state = 'NO_REQUEST';
	var currentVirtualNode = initialVirtualNode;
	var nextVirtualNode = initialVirtualNode;

	function registerVirtualNode(vNode)
	{
		if (state === 'NO_REQUEST')
		{
			rAF(updateIfNeeded);
		}
		state = 'PENDING_REQUEST';
		nextVirtualNode = vNode;
	}

	function updateIfNeeded()
	{
		switch (state)
		{
			case 'NO_REQUEST':
				throw new Error(
					'Unexpected draw callback.\n' +
					'Please report this to <https://github.com/elm-lang/core/issues>.'
				);

			case 'PENDING_REQUEST':
				rAF(updateIfNeeded);
				state = 'EXTRA_REQUEST';

				var patches = diff(currentVirtualNode, nextVirtualNode);
				domNode = applyPatches(domNode, currentVirtualNode, patches, eventNode);
				currentVirtualNode = nextVirtualNode;

				return;

			case 'EXTRA_REQUEST':
				state = 'NO_REQUEST';
				return;
		}
	}

	return { update: registerVirtualNode };
}


var rAF =
	typeof requestAnimationFrame !== 'undefined'
		? requestAnimationFrame
		: function(cb) { setTimeout(cb, 1000 / 60); };



////////////  RENDER  ////////////


function render(vNode, eventNode)
{
	switch (vNode.type)
	{
		case 'thunk':
			if (!vNode.node)
			{
				vNode.node = vNode.thunk();
			}
			return render(vNode.node, eventNode);

		case 'tagger':
			var subNode = vNode.node;
			var tagger = vNode.tagger;

			while (subNode.type === 'tagger')
			{
				typeof tagger !== 'object'
					? tagger = [tagger, subNode.tagger]
					: tagger.push(subNode.tagger);

				subNode = subNode.node;
			}

			var subEventRoot = {
				tagger: tagger,
				parent: eventNode
			};

			var domNode = render(subNode, subEventRoot);
			domNode.elm_event_node_ref = subEventRoot;
			return domNode;

		case 'text':
			return document.createTextNode(vNode.text);

		case 'node':
			var domNode = vNode.namespace
				? document.createElementNS(vNode.namespace, vNode.tag)
				: document.createElement(vNode.tag);

			applyFacts(domNode, eventNode, vNode.facts);

			var children = vNode.children;

			for (var i = 0; i < children.length; i++)
			{
				domNode.appendChild(render(children[i], eventNode));
			}

			return domNode;

		case 'keyed-node':
			var domNode = vNode.namespace
				? document.createElementNS(vNode.namespace, vNode.tag)
				: document.createElement(vNode.tag);

			applyFacts(domNode, eventNode, vNode.facts);

			var children = vNode.children;

			for (var i = 0; i < children.length; i++)
			{
				domNode.appendChild(render(children[i]._1, eventNode));
			}

			return domNode;

		case 'custom':
			var domNode = vNode.impl.render(vNode.model);
			applyFacts(domNode, eventNode, vNode.facts);
			return domNode;
	}
}



////////////  APPLY FACTS  ////////////


function applyFacts(domNode, eventNode, facts)
{
	for (var key in facts)
	{
		var value = facts[key];

		switch (key)
		{
			case STYLE_KEY:
				applyStyles(domNode, value);
				break;

			case EVENT_KEY:
				applyEvents(domNode, eventNode, value);
				break;

			case ATTR_KEY:
				applyAttrs(domNode, value);
				break;

			case ATTR_NS_KEY:
				applyAttrsNS(domNode, value);
				break;

			case 'value':
				if (domNode[key] !== value)
				{
					domNode[key] = value;
				}
				break;

			default:
				domNode[key] = value;
				break;
		}
	}
}

function applyStyles(domNode, styles)
{
	var domNodeStyle = domNode.style;

	for (var key in styles)
	{
		domNodeStyle[key] = styles[key];
	}
}

function applyEvents(domNode, eventNode, events)
{
	var allHandlers = domNode.elm_handlers || {};

	for (var key in events)
	{
		var handler = allHandlers[key];
		var value = events[key];

		if (typeof value === 'undefined')
		{
			domNode.removeEventListener(key, handler);
			allHandlers[key] = undefined;
		}
		else if (typeof handler === 'undefined')
		{
			var handler = makeEventHandler(eventNode, value);
			domNode.addEventListener(key, handler);
			allHandlers[key] = handler;
		}
		else
		{
			handler.info = value;
		}
	}

	domNode.elm_handlers = allHandlers;
}

function makeEventHandler(eventNode, info)
{
	function eventHandler(event)
	{
		var info = eventHandler.info;

		var value = A2(_elm_lang$core$Native_Json.run, info.decoder, event);

		if (value.ctor === 'Ok')
		{
			var options = info.options;
			if (options.stopPropagation)
			{
				event.stopPropagation();
			}
			if (options.preventDefault)
			{
				event.preventDefault();
			}

			var message = value._0;

			var currentEventNode = eventNode;
			while (currentEventNode)
			{
				var tagger = currentEventNode.tagger;
				if (typeof tagger === 'function')
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
				currentEventNode = currentEventNode.parent;
			}
		}
	};

	eventHandler.info = info;

	return eventHandler;
}

function applyAttrs(domNode, attrs)
{
	for (var key in attrs)
	{
		var value = attrs[key];
		if (typeof value === 'undefined')
		{
			domNode.removeAttribute(key);
		}
		else
		{
			domNode.setAttribute(key, value);
		}
	}
}

function applyAttrsNS(domNode, nsAttrs)
{
	for (var key in nsAttrs)
	{
		var pair = nsAttrs[key];
		var namespace = pair.namespace;
		var value = pair.value;

		if (typeof value === 'undefined')
		{
			domNode.removeAttributeNS(namespace, key);
		}
		else
		{
			domNode.setAttributeNS(namespace, key, value);
		}
	}
}



////////////  DIFF  ////////////


function diff(a, b)
{
	var patches = [];
	diffHelp(a, b, patches, 0);
	return patches;
}


function makePatch(type, index, data)
{
	return {
		index: index,
		type: type,
		data: data,
		domNode: undefined,
		eventNode: undefined
	};
}


function diffHelp(a, b, patches, index)
{
	if (a === b)
	{
		return;
	}

	var aType = a.type;
	var bType = b.type;

	// Bail if you run into different types of nodes. Implies that the
	// structure has changed significantly and it's not worth a diff.
	if (aType !== bType)
	{
		patches.push(makePatch('p-redraw', index, b));
		return;
	}

	// Now we know that both nodes are the same type.
	switch (bType)
	{
		case 'thunk':
			var aArgs = a.args;
			var bArgs = b.args;
			var i = aArgs.length;
			var same = a.func === b.func && i === bArgs.length;
			while (same && i--)
			{
				same = aArgs[i] === bArgs[i];
			}
			if (same)
			{
				b.node = a.node;
				return;
			}
			b.node = b.thunk();
			var subPatches = [];
			diffHelp(a.node, b.node, subPatches, 0);
			if (subPatches.length > 0)
			{
				patches.push(makePatch('p-thunk', index, subPatches));
			}
			return;

		case 'tagger':
			// gather nested taggers
			var aTaggers = a.tagger;
			var bTaggers = b.tagger;
			var nesting = false;

			var aSubNode = a.node;
			while (aSubNode.type === 'tagger')
			{
				nesting = true;

				typeof aTaggers !== 'object'
					? aTaggers = [aTaggers, aSubNode.tagger]
					: aTaggers.push(aSubNode.tagger);

				aSubNode = aSubNode.node;
			}

			var bSubNode = b.node;
			while (bSubNode.type === 'tagger')
			{
				nesting = true;

				typeof bTaggers !== 'object'
					? bTaggers = [bTaggers, bSubNode.tagger]
					: bTaggers.push(bSubNode.tagger);

				bSubNode = bSubNode.node;
			}

			// Just bail if different numbers of taggers. This implies the
			// structure of the virtual DOM has changed.
			if (nesting && aTaggers.length !== bTaggers.length)
			{
				patches.push(makePatch('p-redraw', index, b));
				return;
			}

			// check if taggers are "the same"
			if (nesting ? !pairwiseRefEqual(aTaggers, bTaggers) : aTaggers !== bTaggers)
			{
				patches.push(makePatch('p-tagger', index, bTaggers));
			}

			// diff everything below the taggers
			diffHelp(aSubNode, bSubNode, patches, index + 1);
			return;

		case 'text':
			if (a.text !== b.text)
			{
				patches.push(makePatch('p-text', index, b.text));
				return;
			}

			return;

		case 'node':
			// Bail if obvious indicators have changed. Implies more serious
			// structural changes such that it's not worth it to diff.
			if (a.tag !== b.tag || a.namespace !== b.namespace)
			{
				patches.push(makePatch('p-redraw', index, b));
				return;
			}

			var factsDiff = diffFacts(a.facts, b.facts);

			if (typeof factsDiff !== 'undefined')
			{
				patches.push(makePatch('p-facts', index, factsDiff));
			}

			diffChildren(a, b, patches, index);
			return;

		case 'keyed-node':
			// Bail if obvious indicators have changed. Implies more serious
			// structural changes such that it's not worth it to diff.
			if (a.tag !== b.tag || a.namespace !== b.namespace)
			{
				patches.push(makePatch('p-redraw', index, b));
				return;
			}

			var factsDiff = diffFacts(a.facts, b.facts);

			if (typeof factsDiff !== 'undefined')
			{
				patches.push(makePatch('p-facts', index, factsDiff));
			}

			diffKeyedChildren(a, b, patches, index);
			return;

		case 'custom':
			if (a.impl !== b.impl)
			{
				patches.push(makePatch('p-redraw', index, b));
				return;
			}

			var factsDiff = diffFacts(a.facts, b.facts);
			if (typeof factsDiff !== 'undefined')
			{
				patches.push(makePatch('p-facts', index, factsDiff));
			}

			var patch = b.impl.diff(a,b);
			if (patch)
			{
				patches.push(makePatch('p-custom', index, patch));
				return;
			}

			return;
	}
}


// assumes the incoming arrays are the same length
function pairwiseRefEqual(as, bs)
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


// TODO Instead of creating a new diff object, it's possible to just test if
// there *is* a diff. During the actual patch, do the diff again and make the
// modifications directly. This way, there's no new allocations. Worth it?
function diffFacts(a, b, category)
{
	var diff;

	// look for changes and removals
	for (var aKey in a)
	{
		if (aKey === STYLE_KEY || aKey === EVENT_KEY || aKey === ATTR_KEY || aKey === ATTR_NS_KEY)
		{
			var subDiff = diffFacts(a[aKey], b[aKey] || {}, aKey);
			if (subDiff)
			{
				diff = diff || {};
				diff[aKey] = subDiff;
			}
			continue;
		}

		// remove if not in the new facts
		if (!(aKey in b))
		{
			diff = diff || {};
			diff[aKey] =
				(typeof category === 'undefined')
					? (typeof a[aKey] === 'string' ? '' : null)
					:
				(category === STYLE_KEY)
					? ''
					:
				(category === EVENT_KEY || category === ATTR_KEY)
					? undefined
					:
				{ namespace: a[aKey].namespace, value: undefined };

			continue;
		}

		var aValue = a[aKey];
		var bValue = b[aKey];

		// reference equal, so don't worry about it
		if (aValue === bValue && aKey !== 'value'
			|| category === EVENT_KEY && equalEvents(aValue, bValue))
		{
			continue;
		}

		diff = diff || {};
		diff[aKey] = bValue;
	}

	// add new stuff
	for (var bKey in b)
	{
		if (!(bKey in a))
		{
			diff = diff || {};
			diff[bKey] = b[bKey];
		}
	}

	return diff;
}


function diffChildren(aParent, bParent, patches, rootIndex)
{
	var aChildren = aParent.children;
	var bChildren = bParent.children;

	var aLen = aChildren.length;
	var bLen = bChildren.length;

	// FIGURE OUT IF THERE ARE INSERTS OR REMOVALS

	if (aLen > bLen)
	{
		patches.push(makePatch('p-remove-last', rootIndex, aLen - bLen));
	}
	else if (aLen < bLen)
	{
		patches.push(makePatch('p-append', rootIndex, bChildren.slice(aLen)));
	}

	// PAIRWISE DIFF EVERYTHING ELSE

	var index = rootIndex;
	var minLen = aLen < bLen ? aLen : bLen;
	for (var i = 0; i < minLen; i++)
	{
		index++;
		var aChild = aChildren[i];
		diffHelp(aChild, bChildren[i], patches, index);
		index += aChild.descendantsCount || 0;
	}
}



////////////  KEYED DIFF  ////////////


function diffKeyedChildren(aParent, bParent, patches, rootIndex)
{
	var localPatches = [];

	var changes = {}; // Dict String Entry
	var inserts = []; // Array { index : Int, entry : Entry }
	// type Entry = { tag : String, vnode : VNode, index : Int, data : _ }

	var aChildren = aParent.children;
	var bChildren = bParent.children;
	var aLen = aChildren.length;
	var bLen = bChildren.length;
	var aIndex = 0;
	var bIndex = 0;

	var index = rootIndex;

	while (aIndex < aLen && bIndex < bLen)
	{
		var a = aChildren[aIndex];
		var b = bChildren[bIndex];

		var aKey = a._0;
		var bKey = b._0;
		var aNode = a._1;
		var bNode = b._1;

		// check if keys match

		if (aKey === bKey)
		{
			index++;
			diffHelp(aNode, bNode, localPatches, index);
			index += aNode.descendantsCount || 0;

			aIndex++;
			bIndex++;
			continue;
		}

		// look ahead 1 to detect insertions and removals.

		var aLookAhead = aIndex + 1 < aLen;
		var bLookAhead = bIndex + 1 < bLen;

		if (aLookAhead)
		{
			var aNext = aChildren[aIndex + 1];
			var aNextKey = aNext._0;
			var aNextNode = aNext._1;
			var oldMatch = bKey === aNextKey;
		}

		if (bLookAhead)
		{
			var bNext = bChildren[bIndex + 1];
			var bNextKey = bNext._0;
			var bNextNode = bNext._1;
			var newMatch = aKey === bNextKey;
		}


		// swap a and b
		if (aLookAhead && bLookAhead && newMatch && oldMatch)
		{
			index++;
			diffHelp(aNode, bNextNode, localPatches, index);
			insertNode(changes, localPatches, aKey, bNode, bIndex, inserts);
			index += aNode.descendantsCount || 0;

			index++;
			removeNode(changes, localPatches, aKey, aNextNode, index);
			index += aNextNode.descendantsCount || 0;

			aIndex += 2;
			bIndex += 2;
			continue;
		}

		// insert b
		if (bLookAhead && newMatch)
		{
			index++;
			insertNode(changes, localPatches, bKey, bNode, bIndex, inserts);
			diffHelp(aNode, bNextNode, localPatches, index);
			index += aNode.descendantsCount || 0;

			aIndex += 1;
			bIndex += 2;
			continue;
		}

		// remove a
		if (aLookAhead && oldMatch)
		{
			index++;
			removeNode(changes, localPatches, aKey, aNode, index);
			index += aNode.descendantsCount || 0;

			index++;
			diffHelp(aNextNode, bNode, localPatches, index);
			index += aNextNode.descendantsCount || 0;

			aIndex += 2;
			bIndex += 1;
			continue;
		}

		// remove a, insert b
		if (aLookAhead && bLookAhead && aNextKey === bNextKey)
		{
			index++;
			removeNode(changes, localPatches, aKey, aNode, index);
			insertNode(changes, localPatches, bKey, bNode, bIndex, inserts);
			index += aNode.descendantsCount || 0;

			index++;
			diffHelp(aNextNode, bNextNode, localPatches, index);
			index += aNextNode.descendantsCount || 0;

			aIndex += 2;
			bIndex += 2;
			continue;
		}

		break;
	}

	// eat up any remaining nodes with removeNode and insertNode

	while (aIndex < aLen)
	{
		index++;
		var a = aChildren[aIndex];
		var aNode = a._1;
		removeNode(changes, localPatches, a._0, aNode, index);
		index += aNode.descendantsCount || 0;
		aIndex++;
	}

	var endInserts;
	while (bIndex < bLen)
	{
		endInserts = endInserts || [];
		var b = bChildren[bIndex];
		insertNode(changes, localPatches, b._0, b._1, undefined, endInserts);
		bIndex++;
	}

	if (localPatches.length > 0 || inserts.length > 0 || typeof endInserts !== 'undefined')
	{
		patches.push(makePatch('p-reorder', rootIndex, {
			patches: localPatches,
			inserts: inserts,
			endInserts: endInserts
		}));
	}
}



////////////  CHANGES FROM KEYED DIFF  ////////////


var POSTFIX = '_elmW6BL';


function insertNode(changes, localPatches, key, vnode, bIndex, inserts)
{
	var entry = changes[key];

	// never seen this key before
	if (typeof entry === 'undefined')
	{
		entry = {
			tag: 'insert',
			vnode: vnode,
			index: bIndex,
			data: undefined
		};

		inserts.push({ index: bIndex, entry: entry });
		changes[key] = entry;

		return;
	}

	// this key was removed earlier, a match!
	if (entry.tag === 'remove')
	{
		inserts.push({ index: bIndex, entry: entry });

		entry.tag = 'move';
		var subPatches = [];
		diffHelp(entry.vnode, vnode, subPatches, entry.index);
		entry.index = bIndex;
		entry.data.data = {
			patches: subPatches,
			entry: entry
		};

		return;
	}

	// this key has already been inserted or moved, a duplicate!
	insertNode(changes, localPatches, key + POSTFIX, vnode, bIndex, inserts);
}


function removeNode(changes, localPatches, key, vnode, index)
{
	var entry = changes[key];

	// never seen this key before
	if (typeof entry === 'undefined')
	{
		var patch = makePatch('p-remove', index, undefined);
		localPatches.push(patch);

		changes[key] = {
			tag: 'remove',
			vnode: vnode,
			index: index,
			data: patch
		};

		return;
	}

	// this key was inserted earlier, a match!
	if (entry.tag === 'insert')
	{
		entry.tag = 'move';
		var subPatches = [];
		diffHelp(vnode, entry.vnode, subPatches, index);

		var patch = makePatch('p-remove', index, {
			patches: subPatches,
			entry: entry
		});
		localPatches.push(patch);

		return;
	}

	// this key has already been removed or moved, a duplicate!
	removeNode(changes, localPatches, key + POSTFIX, vnode, index);
}



////////////  ADD DOM NODES  ////////////
//
// Each DOM node has an "index" assigned in order of traversal. It is important
// to minimize our crawl over the actual DOM, so these indexes (along with the
// descendantsCount of virtual nodes) let us skip touching entire subtrees of
// the DOM if we know there are no patches there.


function addDomNodes(domNode, vNode, patches, eventNode)
{
	addDomNodesHelp(domNode, vNode, patches, 0, 0, vNode.descendantsCount, eventNode);
}


// assumes `patches` is non-empty and indexes increase monotonically.
function addDomNodesHelp(domNode, vNode, patches, i, low, high, eventNode)
{
	var patch = patches[i];
	var index = patch.index;

	while (index === low)
	{
		var patchType = patch.type;

		if (patchType === 'p-thunk')
		{
			addDomNodes(domNode, vNode.node, patch.data, eventNode);
		}
		else if (patchType === 'p-reorder')
		{
			patch.domNode = domNode;
			patch.eventNode = eventNode;

			var subPatches = patch.data.patches;
			if (subPatches.length > 0)
			{
				addDomNodesHelp(domNode, vNode, subPatches, 0, low, high, eventNode);
			}
		}
		else if (patchType === 'p-remove')
		{
			patch.domNode = domNode;
			patch.eventNode = eventNode;

			var data = patch.data;
			if (typeof data !== 'undefined')
			{
				data.entry.data = domNode;
				var subPatches = data.patches;
				if (subPatches.length > 0)
				{
					addDomNodesHelp(domNode, vNode, subPatches, 0, low, high, eventNode);
				}
			}
		}
		else
		{
			patch.domNode = domNode;
			patch.eventNode = eventNode;
		}

		i++;

		if (!(patch = patches[i]) || (index = patch.index) > high)
		{
			return i;
		}
	}

	switch (vNode.type)
	{
		case 'tagger':
			var subNode = vNode.node;

			while (subNode.type === "tagger")
			{
				subNode = subNode.node;
			}

			return addDomNodesHelp(domNode, subNode, patches, i, low + 1, high, domNode.elm_event_node_ref);

		case 'node':
			var vChildren = vNode.children;
			var childNodes = domNode.childNodes;
			for (var j = 0; j < vChildren.length; j++)
			{
				low++;
				var vChild = vChildren[j];
				var nextLow = low + (vChild.descendantsCount || 0);
				if (low <= index && index <= nextLow)
				{
					i = addDomNodesHelp(childNodes[j], vChild, patches, i, low, nextLow, eventNode);
					if (!(patch = patches[i]) || (index = patch.index) > high)
					{
						return i;
					}
				}
				low = nextLow;
			}
			return i;

		case 'keyed-node':
			var vChildren = vNode.children;
			var childNodes = domNode.childNodes;
			for (var j = 0; j < vChildren.length; j++)
			{
				low++;
				var vChild = vChildren[j]._1;
				var nextLow = low + (vChild.descendantsCount || 0);
				if (low <= index && index <= nextLow)
				{
					i = addDomNodesHelp(childNodes[j], vChild, patches, i, low, nextLow, eventNode);
					if (!(patch = patches[i]) || (index = patch.index) > high)
					{
						return i;
					}
				}
				low = nextLow;
			}
			return i;

		case 'text':
		case 'thunk':
			throw new Error('should never traverse `text` or `thunk` nodes like this');
	}
}



////////////  APPLY PATCHES  ////////////


function applyPatches(rootDomNode, oldVirtualNode, patches, eventNode)
{
	if (patches.length === 0)
	{
		return rootDomNode;
	}

	addDomNodes(rootDomNode, oldVirtualNode, patches, eventNode);
	return applyPatchesHelp(rootDomNode, patches);
}

function applyPatchesHelp(rootDomNode, patches)
{
	for (var i = 0; i < patches.length; i++)
	{
		var patch = patches[i];
		var localDomNode = patch.domNode
		var newNode = applyPatch(localDomNode, patch);
		if (localDomNode === rootDomNode)
		{
			rootDomNode = newNode;
		}
	}
	return rootDomNode;
}

function applyPatch(domNode, patch)
{
	switch (patch.type)
	{
		case 'p-redraw':
			return applyPatchRedraw(domNode, patch.data, patch.eventNode);

		case 'p-facts':
			applyFacts(domNode, patch.eventNode, patch.data);
			return domNode;

		case 'p-text':
			domNode.replaceData(0, domNode.length, patch.data);
			return domNode;

		case 'p-thunk':
			return applyPatchesHelp(domNode, patch.data);

		case 'p-tagger':
			domNode.elm_event_node_ref.tagger = patch.data;
			return domNode;

		case 'p-remove-last':
			var i = patch.data;
			while (i--)
			{
				domNode.removeChild(domNode.lastChild);
			}
			return domNode;

		case 'p-append':
			var newNodes = patch.data;
			for (var i = 0; i < newNodes.length; i++)
			{
				domNode.appendChild(render(newNodes[i], patch.eventNode));
			}
			return domNode;

		case 'p-remove':
			var data = patch.data;
			if (typeof data === 'undefined')
			{
				domNode.parentNode.removeChild(domNode);
				return domNode;
			}
			var entry = data.entry;
			if (typeof entry.index !== 'undefined')
			{
				domNode.parentNode.removeChild(domNode);
			}
			entry.data = applyPatchesHelp(domNode, data.patches);
			return domNode;

		case 'p-reorder':
			return applyPatchReorder(domNode, patch);

		case 'p-custom':
			var impl = patch.data;
			return impl.applyPatch(domNode, impl.data);

		default:
			throw new Error('Ran into an unknown patch!');
	}
}


function applyPatchRedraw(domNode, vNode, eventNode)
{
	var parentNode = domNode.parentNode;
	var newNode = render(vNode, eventNode);

	if (typeof newNode.elm_event_node_ref === 'undefined')
	{
		newNode.elm_event_node_ref = domNode.elm_event_node_ref;
	}

	if (parentNode && newNode !== domNode)
	{
		parentNode.replaceChild(newNode, domNode);
	}
	return newNode;
}


function applyPatchReorder(domNode, patch)
{
	var data = patch.data;

	// remove end inserts
	var frag = applyPatchReorderEndInsertsHelp(data.endInserts, patch);

	// removals
	domNode = applyPatchesHelp(domNode, data.patches);

	// inserts
	var inserts = data.inserts;
	for (var i = 0; i < inserts.length; i++)
	{
		var insert = inserts[i];
		var entry = insert.entry;
		var node = entry.tag === 'move'
			? entry.data
			: render(entry.vnode, patch.eventNode);
		domNode.insertBefore(node, domNode.childNodes[insert.index]);
	}

	// add end inserts
	if (typeof frag !== 'undefined')
	{
		domNode.appendChild(frag);
	}

	return domNode;
}


function applyPatchReorderEndInsertsHelp(endInserts, patch)
{
	if (typeof endInserts === 'undefined')
	{
		return;
	}

	var frag = document.createDocumentFragment();
	for (var i = 0; i < endInserts.length; i++)
	{
		var insert = endInserts[i];
		var entry = insert.entry;
		frag.appendChild(entry.tag === 'move'
			? entry.data
			: render(entry.vnode, patch.eventNode)
		);
	}
	return frag;
}



////////////  PROGRAMS  ////////////


function programWithFlags(details)
{
	return {
		init: details.init,
		update: details.update,
		subscriptions: details.subscriptions,
		view: details.view,
		renderer: renderer
	};
}


return {
	node: node,
	text: text,

	custom: custom,

	map: F2(map),

	on: F3(on),
	style: style,
	property: F2(property),
	attribute: F2(attribute),
	attributeNS: F3(attributeNS),

	lazy: F2(lazy),
	lazy2: F3(lazy2),
	lazy3: F4(lazy3),
	keyedNode: F3(keyedNode),

	programWithFlags: programWithFlags
};

}();
var _elm_lang$virtual_dom$VirtualDom$programWithFlags = _elm_lang$virtual_dom$Native_VirtualDom.programWithFlags;
var _elm_lang$virtual_dom$VirtualDom$keyedNode = _elm_lang$virtual_dom$Native_VirtualDom.keyedNode;
var _elm_lang$virtual_dom$VirtualDom$lazy3 = _elm_lang$virtual_dom$Native_VirtualDom.lazy3;
var _elm_lang$virtual_dom$VirtualDom$lazy2 = _elm_lang$virtual_dom$Native_VirtualDom.lazy2;
var _elm_lang$virtual_dom$VirtualDom$lazy = _elm_lang$virtual_dom$Native_VirtualDom.lazy;
var _elm_lang$virtual_dom$VirtualDom$defaultOptions = {stopPropagation: false, preventDefault: false};
var _elm_lang$virtual_dom$VirtualDom$onWithOptions = _elm_lang$virtual_dom$Native_VirtualDom.on;
var _elm_lang$virtual_dom$VirtualDom$on = F2(
	function (eventName, decoder) {
		return A3(_elm_lang$virtual_dom$VirtualDom$onWithOptions, eventName, _elm_lang$virtual_dom$VirtualDom$defaultOptions, decoder);
	});
var _elm_lang$virtual_dom$VirtualDom$style = _elm_lang$virtual_dom$Native_VirtualDom.style;
var _elm_lang$virtual_dom$VirtualDom$attributeNS = _elm_lang$virtual_dom$Native_VirtualDom.attributeNS;
var _elm_lang$virtual_dom$VirtualDom$attribute = _elm_lang$virtual_dom$Native_VirtualDom.attribute;
var _elm_lang$virtual_dom$VirtualDom$property = _elm_lang$virtual_dom$Native_VirtualDom.property;
var _elm_lang$virtual_dom$VirtualDom$map = _elm_lang$virtual_dom$Native_VirtualDom.map;
var _elm_lang$virtual_dom$VirtualDom$text = _elm_lang$virtual_dom$Native_VirtualDom.text;
var _elm_lang$virtual_dom$VirtualDom$node = _elm_lang$virtual_dom$Native_VirtualDom.node;
var _elm_lang$virtual_dom$VirtualDom$Options = F2(
	function (a, b) {
		return {stopPropagation: a, preventDefault: b};
	});
var _elm_lang$virtual_dom$VirtualDom$Node = {ctor: 'Node'};
var _elm_lang$virtual_dom$VirtualDom$Property = {ctor: 'Property'};

var _elm_lang$html$Html$text = _elm_lang$virtual_dom$VirtualDom$text;
var _elm_lang$html$Html$node = _elm_lang$virtual_dom$VirtualDom$node;
var _elm_lang$html$Html$body = _elm_lang$html$Html$node('body');
var _elm_lang$html$Html$section = _elm_lang$html$Html$node('section');
var _elm_lang$html$Html$nav = _elm_lang$html$Html$node('nav');
var _elm_lang$html$Html$article = _elm_lang$html$Html$node('article');
var _elm_lang$html$Html$aside = _elm_lang$html$Html$node('aside');
var _elm_lang$html$Html$h1 = _elm_lang$html$Html$node('h1');
var _elm_lang$html$Html$h2 = _elm_lang$html$Html$node('h2');
var _elm_lang$html$Html$h3 = _elm_lang$html$Html$node('h3');
var _elm_lang$html$Html$h4 = _elm_lang$html$Html$node('h4');
var _elm_lang$html$Html$h5 = _elm_lang$html$Html$node('h5');
var _elm_lang$html$Html$h6 = _elm_lang$html$Html$node('h6');
var _elm_lang$html$Html$header = _elm_lang$html$Html$node('header');
var _elm_lang$html$Html$footer = _elm_lang$html$Html$node('footer');
var _elm_lang$html$Html$address = _elm_lang$html$Html$node('address');
var _elm_lang$html$Html$main$ = _elm_lang$html$Html$node('main');
var _elm_lang$html$Html$p = _elm_lang$html$Html$node('p');
var _elm_lang$html$Html$hr = _elm_lang$html$Html$node('hr');
var _elm_lang$html$Html$pre = _elm_lang$html$Html$node('pre');
var _elm_lang$html$Html$blockquote = _elm_lang$html$Html$node('blockquote');
var _elm_lang$html$Html$ol = _elm_lang$html$Html$node('ol');
var _elm_lang$html$Html$ul = _elm_lang$html$Html$node('ul');
var _elm_lang$html$Html$li = _elm_lang$html$Html$node('li');
var _elm_lang$html$Html$dl = _elm_lang$html$Html$node('dl');
var _elm_lang$html$Html$dt = _elm_lang$html$Html$node('dt');
var _elm_lang$html$Html$dd = _elm_lang$html$Html$node('dd');
var _elm_lang$html$Html$figure = _elm_lang$html$Html$node('figure');
var _elm_lang$html$Html$figcaption = _elm_lang$html$Html$node('figcaption');
var _elm_lang$html$Html$div = _elm_lang$html$Html$node('div');
var _elm_lang$html$Html$a = _elm_lang$html$Html$node('a');
var _elm_lang$html$Html$em = _elm_lang$html$Html$node('em');
var _elm_lang$html$Html$strong = _elm_lang$html$Html$node('strong');
var _elm_lang$html$Html$small = _elm_lang$html$Html$node('small');
var _elm_lang$html$Html$s = _elm_lang$html$Html$node('s');
var _elm_lang$html$Html$cite = _elm_lang$html$Html$node('cite');
var _elm_lang$html$Html$q = _elm_lang$html$Html$node('q');
var _elm_lang$html$Html$dfn = _elm_lang$html$Html$node('dfn');
var _elm_lang$html$Html$abbr = _elm_lang$html$Html$node('abbr');
var _elm_lang$html$Html$time = _elm_lang$html$Html$node('time');
var _elm_lang$html$Html$code = _elm_lang$html$Html$node('code');
var _elm_lang$html$Html$var = _elm_lang$html$Html$node('var');
var _elm_lang$html$Html$samp = _elm_lang$html$Html$node('samp');
var _elm_lang$html$Html$kbd = _elm_lang$html$Html$node('kbd');
var _elm_lang$html$Html$sub = _elm_lang$html$Html$node('sub');
var _elm_lang$html$Html$sup = _elm_lang$html$Html$node('sup');
var _elm_lang$html$Html$i = _elm_lang$html$Html$node('i');
var _elm_lang$html$Html$b = _elm_lang$html$Html$node('b');
var _elm_lang$html$Html$u = _elm_lang$html$Html$node('u');
var _elm_lang$html$Html$mark = _elm_lang$html$Html$node('mark');
var _elm_lang$html$Html$ruby = _elm_lang$html$Html$node('ruby');
var _elm_lang$html$Html$rt = _elm_lang$html$Html$node('rt');
var _elm_lang$html$Html$rp = _elm_lang$html$Html$node('rp');
var _elm_lang$html$Html$bdi = _elm_lang$html$Html$node('bdi');
var _elm_lang$html$Html$bdo = _elm_lang$html$Html$node('bdo');
var _elm_lang$html$Html$span = _elm_lang$html$Html$node('span');
var _elm_lang$html$Html$br = _elm_lang$html$Html$node('br');
var _elm_lang$html$Html$wbr = _elm_lang$html$Html$node('wbr');
var _elm_lang$html$Html$ins = _elm_lang$html$Html$node('ins');
var _elm_lang$html$Html$del = _elm_lang$html$Html$node('del');
var _elm_lang$html$Html$img = _elm_lang$html$Html$node('img');
var _elm_lang$html$Html$iframe = _elm_lang$html$Html$node('iframe');
var _elm_lang$html$Html$embed = _elm_lang$html$Html$node('embed');
var _elm_lang$html$Html$object = _elm_lang$html$Html$node('object');
var _elm_lang$html$Html$param = _elm_lang$html$Html$node('param');
var _elm_lang$html$Html$video = _elm_lang$html$Html$node('video');
var _elm_lang$html$Html$audio = _elm_lang$html$Html$node('audio');
var _elm_lang$html$Html$source = _elm_lang$html$Html$node('source');
var _elm_lang$html$Html$track = _elm_lang$html$Html$node('track');
var _elm_lang$html$Html$canvas = _elm_lang$html$Html$node('canvas');
var _elm_lang$html$Html$svg = _elm_lang$html$Html$node('svg');
var _elm_lang$html$Html$math = _elm_lang$html$Html$node('math');
var _elm_lang$html$Html$table = _elm_lang$html$Html$node('table');
var _elm_lang$html$Html$caption = _elm_lang$html$Html$node('caption');
var _elm_lang$html$Html$colgroup = _elm_lang$html$Html$node('colgroup');
var _elm_lang$html$Html$col = _elm_lang$html$Html$node('col');
var _elm_lang$html$Html$tbody = _elm_lang$html$Html$node('tbody');
var _elm_lang$html$Html$thead = _elm_lang$html$Html$node('thead');
var _elm_lang$html$Html$tfoot = _elm_lang$html$Html$node('tfoot');
var _elm_lang$html$Html$tr = _elm_lang$html$Html$node('tr');
var _elm_lang$html$Html$td = _elm_lang$html$Html$node('td');
var _elm_lang$html$Html$th = _elm_lang$html$Html$node('th');
var _elm_lang$html$Html$form = _elm_lang$html$Html$node('form');
var _elm_lang$html$Html$fieldset = _elm_lang$html$Html$node('fieldset');
var _elm_lang$html$Html$legend = _elm_lang$html$Html$node('legend');
var _elm_lang$html$Html$label = _elm_lang$html$Html$node('label');
var _elm_lang$html$Html$input = _elm_lang$html$Html$node('input');
var _elm_lang$html$Html$button = _elm_lang$html$Html$node('button');
var _elm_lang$html$Html$select = _elm_lang$html$Html$node('select');
var _elm_lang$html$Html$datalist = _elm_lang$html$Html$node('datalist');
var _elm_lang$html$Html$optgroup = _elm_lang$html$Html$node('optgroup');
var _elm_lang$html$Html$option = _elm_lang$html$Html$node('option');
var _elm_lang$html$Html$textarea = _elm_lang$html$Html$node('textarea');
var _elm_lang$html$Html$keygen = _elm_lang$html$Html$node('keygen');
var _elm_lang$html$Html$output = _elm_lang$html$Html$node('output');
var _elm_lang$html$Html$progress = _elm_lang$html$Html$node('progress');
var _elm_lang$html$Html$meter = _elm_lang$html$Html$node('meter');
var _elm_lang$html$Html$details = _elm_lang$html$Html$node('details');
var _elm_lang$html$Html$summary = _elm_lang$html$Html$node('summary');
var _elm_lang$html$Html$menuitem = _elm_lang$html$Html$node('menuitem');
var _elm_lang$html$Html$menu = _elm_lang$html$Html$node('menu');

var _elm_lang$html$Html_App$programWithFlags = _elm_lang$virtual_dom$VirtualDom$programWithFlags;
var _elm_lang$html$Html_App$program = function (app) {
	return _elm_lang$html$Html_App$programWithFlags(
		_elm_lang$core$Native_Utils.update(
			app,
			{
				init: function (_p0) {
					return app.init;
				}
			}));
};
var _elm_lang$html$Html_App$beginnerProgram = function (_p1) {
	var _p2 = _p1;
	return _elm_lang$html$Html_App$programWithFlags(
		{
			init: function (_p3) {
				return A2(
					_elm_lang$core$Platform_Cmd_ops['!'],
					_p2.model,
					_elm_lang$core$Native_List.fromArray(
						[]));
			},
			update: F2(
				function (msg, model) {
					return A2(
						_elm_lang$core$Platform_Cmd_ops['!'],
						A2(_p2.update, msg, model),
						_elm_lang$core$Native_List.fromArray(
							[]));
				}),
			view: _p2.view,
			subscriptions: function (_p4) {
				return _elm_lang$core$Platform_Sub$none;
			}
		});
};
var _elm_lang$html$Html_App$map = _elm_lang$virtual_dom$VirtualDom$map;

var _elm_lang$html$Html_Attributes$attribute = _elm_lang$virtual_dom$VirtualDom$attribute;
var _elm_lang$html$Html_Attributes$contextmenu = function (value) {
	return A2(_elm_lang$html$Html_Attributes$attribute, 'contextmenu', value);
};
var _elm_lang$html$Html_Attributes$draggable = function (value) {
	return A2(_elm_lang$html$Html_Attributes$attribute, 'draggable', value);
};
var _elm_lang$html$Html_Attributes$list = function (value) {
	return A2(_elm_lang$html$Html_Attributes$attribute, 'list', value);
};
var _elm_lang$html$Html_Attributes$maxlength = function (n) {
	return A2(
		_elm_lang$html$Html_Attributes$attribute,
		'maxlength',
		_elm_lang$core$Basics$toString(n));
};
var _elm_lang$html$Html_Attributes$datetime = function (value) {
	return A2(_elm_lang$html$Html_Attributes$attribute, 'datetime', value);
};
var _elm_lang$html$Html_Attributes$pubdate = function (value) {
	return A2(_elm_lang$html$Html_Attributes$attribute, 'pubdate', value);
};
var _elm_lang$html$Html_Attributes$colspan = function (n) {
	return A2(
		_elm_lang$html$Html_Attributes$attribute,
		'colspan',
		_elm_lang$core$Basics$toString(n));
};
var _elm_lang$html$Html_Attributes$rowspan = function (n) {
	return A2(
		_elm_lang$html$Html_Attributes$attribute,
		'rowspan',
		_elm_lang$core$Basics$toString(n));
};
var _elm_lang$html$Html_Attributes$property = _elm_lang$virtual_dom$VirtualDom$property;
var _elm_lang$html$Html_Attributes$stringProperty = F2(
	function (name, string) {
		return A2(
			_elm_lang$html$Html_Attributes$property,
			name,
			_elm_lang$core$Json_Encode$string(string));
	});
var _elm_lang$html$Html_Attributes$class = function (name) {
	return A2(_elm_lang$html$Html_Attributes$stringProperty, 'className', name);
};
var _elm_lang$html$Html_Attributes$id = function (name) {
	return A2(_elm_lang$html$Html_Attributes$stringProperty, 'id', name);
};
var _elm_lang$html$Html_Attributes$title = function (name) {
	return A2(_elm_lang$html$Html_Attributes$stringProperty, 'title', name);
};
var _elm_lang$html$Html_Attributes$accesskey = function ($char) {
	return A2(
		_elm_lang$html$Html_Attributes$stringProperty,
		'accessKey',
		_elm_lang$core$String$fromChar($char));
};
var _elm_lang$html$Html_Attributes$dir = function (value) {
	return A2(_elm_lang$html$Html_Attributes$stringProperty, 'dir', value);
};
var _elm_lang$html$Html_Attributes$dropzone = function (value) {
	return A2(_elm_lang$html$Html_Attributes$stringProperty, 'dropzone', value);
};
var _elm_lang$html$Html_Attributes$itemprop = function (value) {
	return A2(_elm_lang$html$Html_Attributes$stringProperty, 'itemprop', value);
};
var _elm_lang$html$Html_Attributes$lang = function (value) {
	return A2(_elm_lang$html$Html_Attributes$stringProperty, 'lang', value);
};
var _elm_lang$html$Html_Attributes$tabindex = function (n) {
	return A2(
		_elm_lang$html$Html_Attributes$stringProperty,
		'tabIndex',
		_elm_lang$core$Basics$toString(n));
};
var _elm_lang$html$Html_Attributes$charset = function (value) {
	return A2(_elm_lang$html$Html_Attributes$stringProperty, 'charset', value);
};
var _elm_lang$html$Html_Attributes$content = function (value) {
	return A2(_elm_lang$html$Html_Attributes$stringProperty, 'content', value);
};
var _elm_lang$html$Html_Attributes$httpEquiv = function (value) {
	return A2(_elm_lang$html$Html_Attributes$stringProperty, 'httpEquiv', value);
};
var _elm_lang$html$Html_Attributes$language = function (value) {
	return A2(_elm_lang$html$Html_Attributes$stringProperty, 'language', value);
};
var _elm_lang$html$Html_Attributes$src = function (value) {
	return A2(_elm_lang$html$Html_Attributes$stringProperty, 'src', value);
};
var _elm_lang$html$Html_Attributes$height = function (value) {
	return A2(
		_elm_lang$html$Html_Attributes$stringProperty,
		'height',
		_elm_lang$core$Basics$toString(value));
};
var _elm_lang$html$Html_Attributes$width = function (value) {
	return A2(
		_elm_lang$html$Html_Attributes$stringProperty,
		'width',
		_elm_lang$core$Basics$toString(value));
};
var _elm_lang$html$Html_Attributes$alt = function (value) {
	return A2(_elm_lang$html$Html_Attributes$stringProperty, 'alt', value);
};
var _elm_lang$html$Html_Attributes$preload = function (value) {
	return A2(_elm_lang$html$Html_Attributes$stringProperty, 'preload', value);
};
var _elm_lang$html$Html_Attributes$poster = function (value) {
	return A2(_elm_lang$html$Html_Attributes$stringProperty, 'poster', value);
};
var _elm_lang$html$Html_Attributes$kind = function (value) {
	return A2(_elm_lang$html$Html_Attributes$stringProperty, 'kind', value);
};
var _elm_lang$html$Html_Attributes$srclang = function (value) {
	return A2(_elm_lang$html$Html_Attributes$stringProperty, 'srclang', value);
};
var _elm_lang$html$Html_Attributes$sandbox = function (value) {
	return A2(_elm_lang$html$Html_Attributes$stringProperty, 'sandbox', value);
};
var _elm_lang$html$Html_Attributes$srcdoc = function (value) {
	return A2(_elm_lang$html$Html_Attributes$stringProperty, 'srcdoc', value);
};
var _elm_lang$html$Html_Attributes$type$ = function (value) {
	return A2(_elm_lang$html$Html_Attributes$stringProperty, 'type', value);
};
var _elm_lang$html$Html_Attributes$value = function (value) {
	return A2(_elm_lang$html$Html_Attributes$stringProperty, 'value', value);
};
var _elm_lang$html$Html_Attributes$defaultValue = function (value) {
	return A2(_elm_lang$html$Html_Attributes$stringProperty, 'defaultValue', value);
};
var _elm_lang$html$Html_Attributes$placeholder = function (value) {
	return A2(_elm_lang$html$Html_Attributes$stringProperty, 'placeholder', value);
};
var _elm_lang$html$Html_Attributes$accept = function (value) {
	return A2(_elm_lang$html$Html_Attributes$stringProperty, 'accept', value);
};
var _elm_lang$html$Html_Attributes$acceptCharset = function (value) {
	return A2(_elm_lang$html$Html_Attributes$stringProperty, 'acceptCharset', value);
};
var _elm_lang$html$Html_Attributes$action = function (value) {
	return A2(_elm_lang$html$Html_Attributes$stringProperty, 'action', value);
};
var _elm_lang$html$Html_Attributes$autocomplete = function (bool) {
	return A2(
		_elm_lang$html$Html_Attributes$stringProperty,
		'autocomplete',
		bool ? 'on' : 'off');
};
var _elm_lang$html$Html_Attributes$autosave = function (value) {
	return A2(_elm_lang$html$Html_Attributes$stringProperty, 'autosave', value);
};
var _elm_lang$html$Html_Attributes$enctype = function (value) {
	return A2(_elm_lang$html$Html_Attributes$stringProperty, 'enctype', value);
};
var _elm_lang$html$Html_Attributes$formaction = function (value) {
	return A2(_elm_lang$html$Html_Attributes$stringProperty, 'formAction', value);
};
var _elm_lang$html$Html_Attributes$minlength = function (n) {
	return A2(
		_elm_lang$html$Html_Attributes$stringProperty,
		'minLength',
		_elm_lang$core$Basics$toString(n));
};
var _elm_lang$html$Html_Attributes$method = function (value) {
	return A2(_elm_lang$html$Html_Attributes$stringProperty, 'method', value);
};
var _elm_lang$html$Html_Attributes$name = function (value) {
	return A2(_elm_lang$html$Html_Attributes$stringProperty, 'name', value);
};
var _elm_lang$html$Html_Attributes$pattern = function (value) {
	return A2(_elm_lang$html$Html_Attributes$stringProperty, 'pattern', value);
};
var _elm_lang$html$Html_Attributes$size = function (n) {
	return A2(
		_elm_lang$html$Html_Attributes$stringProperty,
		'size',
		_elm_lang$core$Basics$toString(n));
};
var _elm_lang$html$Html_Attributes$for = function (value) {
	return A2(_elm_lang$html$Html_Attributes$stringProperty, 'htmlFor', value);
};
var _elm_lang$html$Html_Attributes$form = function (value) {
	return A2(_elm_lang$html$Html_Attributes$stringProperty, 'form', value);
};
var _elm_lang$html$Html_Attributes$max = function (value) {
	return A2(_elm_lang$html$Html_Attributes$stringProperty, 'max', value);
};
var _elm_lang$html$Html_Attributes$min = function (value) {
	return A2(_elm_lang$html$Html_Attributes$stringProperty, 'min', value);
};
var _elm_lang$html$Html_Attributes$step = function (n) {
	return A2(_elm_lang$html$Html_Attributes$stringProperty, 'step', n);
};
var _elm_lang$html$Html_Attributes$cols = function (n) {
	return A2(
		_elm_lang$html$Html_Attributes$stringProperty,
		'cols',
		_elm_lang$core$Basics$toString(n));
};
var _elm_lang$html$Html_Attributes$rows = function (n) {
	return A2(
		_elm_lang$html$Html_Attributes$stringProperty,
		'rows',
		_elm_lang$core$Basics$toString(n));
};
var _elm_lang$html$Html_Attributes$wrap = function (value) {
	return A2(_elm_lang$html$Html_Attributes$stringProperty, 'wrap', value);
};
var _elm_lang$html$Html_Attributes$usemap = function (value) {
	return A2(_elm_lang$html$Html_Attributes$stringProperty, 'useMap', value);
};
var _elm_lang$html$Html_Attributes$shape = function (value) {
	return A2(_elm_lang$html$Html_Attributes$stringProperty, 'shape', value);
};
var _elm_lang$html$Html_Attributes$coords = function (value) {
	return A2(_elm_lang$html$Html_Attributes$stringProperty, 'coords', value);
};
var _elm_lang$html$Html_Attributes$challenge = function (value) {
	return A2(_elm_lang$html$Html_Attributes$stringProperty, 'challenge', value);
};
var _elm_lang$html$Html_Attributes$keytype = function (value) {
	return A2(_elm_lang$html$Html_Attributes$stringProperty, 'keytype', value);
};
var _elm_lang$html$Html_Attributes$align = function (value) {
	return A2(_elm_lang$html$Html_Attributes$stringProperty, 'align', value);
};
var _elm_lang$html$Html_Attributes$cite = function (value) {
	return A2(_elm_lang$html$Html_Attributes$stringProperty, 'cite', value);
};
var _elm_lang$html$Html_Attributes$href = function (value) {
	return A2(_elm_lang$html$Html_Attributes$stringProperty, 'href', value);
};
var _elm_lang$html$Html_Attributes$target = function (value) {
	return A2(_elm_lang$html$Html_Attributes$stringProperty, 'target', value);
};
var _elm_lang$html$Html_Attributes$downloadAs = function (value) {
	return A2(_elm_lang$html$Html_Attributes$stringProperty, 'download', value);
};
var _elm_lang$html$Html_Attributes$hreflang = function (value) {
	return A2(_elm_lang$html$Html_Attributes$stringProperty, 'hreflang', value);
};
var _elm_lang$html$Html_Attributes$media = function (value) {
	return A2(_elm_lang$html$Html_Attributes$stringProperty, 'media', value);
};
var _elm_lang$html$Html_Attributes$ping = function (value) {
	return A2(_elm_lang$html$Html_Attributes$stringProperty, 'ping', value);
};
var _elm_lang$html$Html_Attributes$rel = function (value) {
	return A2(_elm_lang$html$Html_Attributes$stringProperty, 'rel', value);
};
var _elm_lang$html$Html_Attributes$start = function (n) {
	return A2(
		_elm_lang$html$Html_Attributes$stringProperty,
		'start',
		_elm_lang$core$Basics$toString(n));
};
var _elm_lang$html$Html_Attributes$headers = function (value) {
	return A2(_elm_lang$html$Html_Attributes$stringProperty, 'headers', value);
};
var _elm_lang$html$Html_Attributes$scope = function (value) {
	return A2(_elm_lang$html$Html_Attributes$stringProperty, 'scope', value);
};
var _elm_lang$html$Html_Attributes$manifest = function (value) {
	return A2(_elm_lang$html$Html_Attributes$stringProperty, 'manifest', value);
};
var _elm_lang$html$Html_Attributes$boolProperty = F2(
	function (name, bool) {
		return A2(
			_elm_lang$html$Html_Attributes$property,
			name,
			_elm_lang$core$Json_Encode$bool(bool));
	});
var _elm_lang$html$Html_Attributes$hidden = function (bool) {
	return A2(_elm_lang$html$Html_Attributes$boolProperty, 'hidden', bool);
};
var _elm_lang$html$Html_Attributes$contenteditable = function (bool) {
	return A2(_elm_lang$html$Html_Attributes$boolProperty, 'contentEditable', bool);
};
var _elm_lang$html$Html_Attributes$spellcheck = function (bool) {
	return A2(_elm_lang$html$Html_Attributes$boolProperty, 'spellcheck', bool);
};
var _elm_lang$html$Html_Attributes$async = function (bool) {
	return A2(_elm_lang$html$Html_Attributes$boolProperty, 'async', bool);
};
var _elm_lang$html$Html_Attributes$defer = function (bool) {
	return A2(_elm_lang$html$Html_Attributes$boolProperty, 'defer', bool);
};
var _elm_lang$html$Html_Attributes$scoped = function (bool) {
	return A2(_elm_lang$html$Html_Attributes$boolProperty, 'scoped', bool);
};
var _elm_lang$html$Html_Attributes$autoplay = function (bool) {
	return A2(_elm_lang$html$Html_Attributes$boolProperty, 'autoplay', bool);
};
var _elm_lang$html$Html_Attributes$controls = function (bool) {
	return A2(_elm_lang$html$Html_Attributes$boolProperty, 'controls', bool);
};
var _elm_lang$html$Html_Attributes$loop = function (bool) {
	return A2(_elm_lang$html$Html_Attributes$boolProperty, 'loop', bool);
};
var _elm_lang$html$Html_Attributes$default = function (bool) {
	return A2(_elm_lang$html$Html_Attributes$boolProperty, 'default', bool);
};
var _elm_lang$html$Html_Attributes$seamless = function (bool) {
	return A2(_elm_lang$html$Html_Attributes$boolProperty, 'seamless', bool);
};
var _elm_lang$html$Html_Attributes$checked = function (bool) {
	return A2(_elm_lang$html$Html_Attributes$boolProperty, 'checked', bool);
};
var _elm_lang$html$Html_Attributes$selected = function (bool) {
	return A2(_elm_lang$html$Html_Attributes$boolProperty, 'selected', bool);
};
var _elm_lang$html$Html_Attributes$autofocus = function (bool) {
	return A2(_elm_lang$html$Html_Attributes$boolProperty, 'autofocus', bool);
};
var _elm_lang$html$Html_Attributes$disabled = function (bool) {
	return A2(_elm_lang$html$Html_Attributes$boolProperty, 'disabled', bool);
};
var _elm_lang$html$Html_Attributes$multiple = function (bool) {
	return A2(_elm_lang$html$Html_Attributes$boolProperty, 'multiple', bool);
};
var _elm_lang$html$Html_Attributes$novalidate = function (bool) {
	return A2(_elm_lang$html$Html_Attributes$boolProperty, 'noValidate', bool);
};
var _elm_lang$html$Html_Attributes$readonly = function (bool) {
	return A2(_elm_lang$html$Html_Attributes$boolProperty, 'readOnly', bool);
};
var _elm_lang$html$Html_Attributes$required = function (bool) {
	return A2(_elm_lang$html$Html_Attributes$boolProperty, 'required', bool);
};
var _elm_lang$html$Html_Attributes$ismap = function (value) {
	return A2(_elm_lang$html$Html_Attributes$boolProperty, 'isMap', value);
};
var _elm_lang$html$Html_Attributes$download = function (bool) {
	return A2(_elm_lang$html$Html_Attributes$boolProperty, 'download', bool);
};
var _elm_lang$html$Html_Attributes$reversed = function (bool) {
	return A2(_elm_lang$html$Html_Attributes$boolProperty, 'reversed', bool);
};
var _elm_lang$html$Html_Attributes$classList = function (list) {
	return _elm_lang$html$Html_Attributes$class(
		A2(
			_elm_lang$core$String$join,
			' ',
			A2(
				_elm_lang$core$List$map,
				_elm_lang$core$Basics$fst,
				A2(_elm_lang$core$List$filter, _elm_lang$core$Basics$snd, list))));
};
var _elm_lang$html$Html_Attributes$style = _elm_lang$virtual_dom$VirtualDom$style;

var _elm_lang$html$Html_Events$keyCode = A2(_elm_lang$core$Json_Decode_ops[':='], 'keyCode', _elm_lang$core$Json_Decode$int);
var _elm_lang$html$Html_Events$targetChecked = A2(
	_elm_lang$core$Json_Decode$at,
	_elm_lang$core$Native_List.fromArray(
		['target', 'checked']),
	_elm_lang$core$Json_Decode$bool);
var _elm_lang$html$Html_Events$targetValue = A2(
	_elm_lang$core$Json_Decode$at,
	_elm_lang$core$Native_List.fromArray(
		['target', 'value']),
	_elm_lang$core$Json_Decode$string);
var _elm_lang$html$Html_Events$defaultOptions = _elm_lang$virtual_dom$VirtualDom$defaultOptions;
var _elm_lang$html$Html_Events$onWithOptions = _elm_lang$virtual_dom$VirtualDom$onWithOptions;
var _elm_lang$html$Html_Events$on = _elm_lang$virtual_dom$VirtualDom$on;
var _elm_lang$html$Html_Events$onFocus = function (msg) {
	return A2(
		_elm_lang$html$Html_Events$on,
		'focus',
		_elm_lang$core$Json_Decode$succeed(msg));
};
var _elm_lang$html$Html_Events$onBlur = function (msg) {
	return A2(
		_elm_lang$html$Html_Events$on,
		'blur',
		_elm_lang$core$Json_Decode$succeed(msg));
};
var _elm_lang$html$Html_Events$onSubmitOptions = _elm_lang$core$Native_Utils.update(
	_elm_lang$html$Html_Events$defaultOptions,
	{preventDefault: true});
var _elm_lang$html$Html_Events$onSubmit = function (msg) {
	return A3(
		_elm_lang$html$Html_Events$onWithOptions,
		'submit',
		_elm_lang$html$Html_Events$onSubmitOptions,
		_elm_lang$core$Json_Decode$succeed(msg));
};
var _elm_lang$html$Html_Events$onCheck = function (tagger) {
	return A2(
		_elm_lang$html$Html_Events$on,
		'change',
		A2(_elm_lang$core$Json_Decode$map, tagger, _elm_lang$html$Html_Events$targetChecked));
};
var _elm_lang$html$Html_Events$onInput = function (tagger) {
	return A2(
		_elm_lang$html$Html_Events$on,
		'input',
		A2(_elm_lang$core$Json_Decode$map, tagger, _elm_lang$html$Html_Events$targetValue));
};
var _elm_lang$html$Html_Events$onMouseOut = function (msg) {
	return A2(
		_elm_lang$html$Html_Events$on,
		'mouseout',
		_elm_lang$core$Json_Decode$succeed(msg));
};
var _elm_lang$html$Html_Events$onMouseOver = function (msg) {
	return A2(
		_elm_lang$html$Html_Events$on,
		'mouseover',
		_elm_lang$core$Json_Decode$succeed(msg));
};
var _elm_lang$html$Html_Events$onMouseLeave = function (msg) {
	return A2(
		_elm_lang$html$Html_Events$on,
		'mouseleave',
		_elm_lang$core$Json_Decode$succeed(msg));
};
var _elm_lang$html$Html_Events$onMouseEnter = function (msg) {
	return A2(
		_elm_lang$html$Html_Events$on,
		'mouseenter',
		_elm_lang$core$Json_Decode$succeed(msg));
};
var _elm_lang$html$Html_Events$onMouseUp = function (msg) {
	return A2(
		_elm_lang$html$Html_Events$on,
		'mouseup',
		_elm_lang$core$Json_Decode$succeed(msg));
};
var _elm_lang$html$Html_Events$onMouseDown = function (msg) {
	return A2(
		_elm_lang$html$Html_Events$on,
		'mousedown',
		_elm_lang$core$Json_Decode$succeed(msg));
};
var _elm_lang$html$Html_Events$onDoubleClick = function (msg) {
	return A2(
		_elm_lang$html$Html_Events$on,
		'dblclick',
		_elm_lang$core$Json_Decode$succeed(msg));
};
var _elm_lang$html$Html_Events$onClick = function (msg) {
	return A2(
		_elm_lang$html$Html_Events$on,
		'click',
		_elm_lang$core$Json_Decode$succeed(msg));
};
var _elm_lang$html$Html_Events$Options = F2(
	function (a, b) {
		return {stopPropagation: a, preventDefault: b};
	});

var _user$project$Data_Json_Utils$ref = _elm_lang$core$Json_Decode$oneOf(
	_elm_lang$core$Native_List.fromArray(
		[
			_elm_lang$core$Json_Decode$null(_elm_lang$core$Maybe$Nothing),
			A2(_elm_lang$core$Json_Decode$map, _elm_lang$core$Maybe$Just, _elm_lang$core$Json_Decode$int)
		]));

var _user$project$Data_Audience$audiencesJSON = '\n    {\n        \"data\": [\n            {\n                \"id\": 104,\n                \"name\": \"Food Lovers\",\n                \"expression\": {\n                    \"or\": [\n                        {\n                            \"options\": [\n                                \"q25_6\"\n                            ],\n                            \"question\": \"q25\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 358\n            },\n            {\n                \"id\": 97,\n                \"name\": \"Brand Likers\",\n                \"expression\": {\n                    \"or\": [\n                        {\n                            \"options\": [\n                                \"q2157_8\"\n                            ],\n                            \"question\": \"q2157\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 358\n            },\n            {\n                \"id\": 116,\n                \"name\": \"Political Commentators\",\n                \"expression\": {\n                    \"or\": [\n                        {\n                            \"options\": [\n                                \"q25_9\"\n                            ],\n                            \"question\": \"q25\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 358\n            },\n            {\n                \"id\": 118,\n                \"name\": \"Music Lovers\",\n                \"expression\": {\n                    \"or\": [\n                        {\n                            \"options\": [\n                                \"q25_3\"\n                            ],\n                            \"question\": \"q25\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 358\n            },\n            {\n                \"id\": 5028,\n                \"name\": \"Social Segments: Creators\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"r1_1\"\n                            ],\n                            \"question\": \"r1\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Demographics\",\n                \"folder\": 357\n            },\n            {\n                \"id\": 5030,\n                \"name\": \"Social Segments: Sharers\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"r1_2\"\n                            ],\n                            \"question\": \"r1\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Demographics\",\n                \"folder\": 357\n            },\n            {\n                \"id\": 4996,\n                \"name\": \"Female 35-44\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q2_2\"\n                            ],\n                            \"question\": \"q2\"\n                        },\n                        {\n                            \"options\": [\n                                \"q4_4\"\n                            ],\n                            \"question\": \"q4\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Demographics\",\n                \"folder\": 357\n            },\n            {\n                \"id\": 5000,\n                \"name\": \"Male 16-24\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q2_1\"\n                            ],\n                            \"question\": \"q2\"\n                        },\n                        {\n                            \"options\": [\n                                \"q4_2\"\n                            ],\n                            \"question\": \"q4\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Demographics\",\n                \"folder\": 357\n            },\n            {\n                \"id\": 5006,\n                \"name\": \"Income: Mid 50%\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"i1_2\"\n                            ],\n                            \"question\": \"i1\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Demographics\",\n                \"folder\": 357\n            },\n            {\n                \"id\": 43311,\n                \"name\": \"Ad-Clickers\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q2157_4\"\n                            ],\n                            \"question\": \"q2157\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 43312,\n                \"name\": \"Apple Pay Users\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q3158_1\"\n                            ],\n                            \"question\": \"q3158\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Enterprise\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 5003,\n                \"name\": \"Male 45-54\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q2_1\"\n                            ],\n                            \"question\": \"q2\"\n                        },\n                        {\n                            \"options\": [\n                                \"q4_5\"\n                            ],\n                            \"question\": \"q4\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Demographics\",\n                \"folder\": 357\n            },\n            {\n                \"id\": 5004,\n                \"name\": \"Male 55-64\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q2_1\"\n                            ],\n                            \"question\": \"q2\"\n                        },\n                        {\n                            \"options\": [\n                                \"q4_6\"\n                            ],\n                            \"question\": \"q4\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Demographics\",\n                \"folder\": 357\n            },\n            {\n                \"id\": 5007,\n                \"name\": \"Income: Top 25%\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"i1_3\"\n                            ],\n                            \"question\": \"i1\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Demographics\",\n                \"folder\": 357\n            },\n            {\n                \"id\": 5013,\n                \"name\": \"Marital Status: In a Relationship\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q7_2\"\n                            ],\n                            \"question\": \"q7\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Demographics\",\n                \"folder\": 357\n            },\n            {\n                \"id\": 5010,\n                \"name\": \"Children in HH: 2\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q8_3\"\n                            ],\n                            \"question\": \"q8\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Demographics\",\n                \"folder\": 357\n            },\n            {\n                \"id\": 5016,\n                \"name\": \"Education: School Until 16\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q6_1\"\n                            ],\n                            \"question\": \"q6\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Demographics\",\n                \"folder\": 357\n            },\n            {\n                \"id\": 5017,\n                \"name\": \"Education: School Until 18\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q6_2\"\n                            ],\n                            \"question\": \"q6\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Demographics\",\n                \"folder\": 357\n            },\n            {\n                \"id\": 5018,\n                \"name\": \"Education: Trade/Technical School or College\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q6_3\"\n                            ],\n                            \"question\": \"q6\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Demographics\",\n                \"folder\": 357\n            },\n            {\n                \"id\": 5022,\n                \"name\": \"Employment: Full-Time Parent\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q14_5\"\n                            ],\n                            \"question\": \"q14\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Demographics\",\n                \"folder\": 357\n            },\n            {\n                \"id\": 5021,\n                \"name\": \"Employment: Full-Time Worker\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q14_1\"\n                            ],\n                            \"question\": \"q14\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Demographics\",\n                \"folder\": 357\n            },\n            {\n                \"id\": 5023,\n                \"name\": \"Employment: Part-Time Worker\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q14_2\"\n                            ],\n                            \"question\": \"q14\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Demographics\",\n                \"folder\": 357\n            },\n            {\n                \"id\": 5036,\n                \"name\": \"World Region: Middle East & Africa\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"s6_5\"\n                            ],\n                            \"question\": \"s6\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Demographics\",\n                \"folder\": 357\n            },\n            {\n                \"id\": 5025,\n                \"name\": \"Employment: Freelancer\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q14_3\"\n                            ],\n                            \"question\": \"q14\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Demographics\",\n                \"folder\": 357\n            },\n            {\n                \"id\": 5026,\n                \"name\": \"Employment: Student\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q14_6\"\n                            ],\n                            \"question\": \"q14\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Demographics\",\n                \"folder\": 357\n            },\n            {\n                \"id\": 53516,\n                \"name\": \"Furniture Buyers\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q91_13\"\n                            ],\n                            \"question\": \"q91\",\n                            \"suffixes\": [\n                                4\n                            ]\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 5029,\n                \"name\": \"Social Segments: Reviewers\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"r1_3\"\n                            ],\n                            \"question\": \"r1\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Demographics\",\n                \"folder\": 357\n            },\n            {\n                \"id\": 5035,\n                \"name\": \"World Region: Latin America\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"s6_3\"\n                            ],\n                            \"question\": \"s6\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Demographics\",\n                \"folder\": 357\n            },\n            {\n                \"id\": 5031,\n                \"name\": \"Social Segments: Commenters\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"r1_6\"\n                            ],\n                            \"question\": \"r1\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Demographics\",\n                \"folder\": 357\n            },\n            {\n                \"id\": 5032,\n                \"name\": \"Social Segments: Passives\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"r1_5\"\n                            ],\n                            \"question\": \"r1\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Demographics\",\n                \"folder\": 357\n            },\n            {\n                \"id\": 4993,\n                \"name\": \"Female\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q2_2\"\n                            ],\n                            \"question\": \"q2\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Demographics\",\n                \"folder\": 357\n            },\n            {\n                \"id\": 5019,\n                \"name\": \"Education: University\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q6_4\"\n                            ],\n                            \"question\": \"q6\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Demographics\",\n                \"folder\": 357\n            },\n            {\n                \"id\": 4833,\n                \"name\": \"Meal Providers\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q25_6\"\n                            ],\n                            \"question\": \"q25\",\n                            \"not\": true\n                        },\n                        {\n                            \"or\": [\n                                {\n                                    \"options\": [\n                                        \"r2021d_2\"\n                                    ],\n                                    \"question\": \"r2021d\"\n                                },\n                                {\n                                    \"options\": [\n                                        \"r2021e_2\"\n                                    ],\n                                    \"question\": \"r2021e\"\n                                }\n                            ]\n                        },\n                        {\n                            \"options\": [\n                                \"q8_2\",\n                                \"q8_3\",\n                                \"q8_4\"\n                            ],\n                            \"question\": \"q8\"\n                        },\n                        {\n                            \"and\": [\n                                {\n                                    \"options\": [\n                                        \"r2021d_46\"\n                                    ],\n                                    \"question\": \"r2021d\",\n                                    \"not\": true\n                                },\n                                {\n                                    \"options\": [\n                                        \"r2021e_46\"\n                                    ],\n                                    \"question\": \"r2021e\",\n                                    \"not\": true\n                                }\n                            ]\n                        }\n                    ]\n                },\n                \"curated\": null,\n                \"type\": \"shared\",\n                \"shared\": true,\n                \"category\": null,\n                \"folder\": null\n            },\n            {\n                \"id\": 5034,\n                \"name\": \"World Region: Europe\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"s6_1\"\n                            ],\n                            \"question\": \"s6\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Demographics\",\n                \"folder\": 357\n            },\n            {\n                \"id\": 4938,\n                \"name\": \"ITDM\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q16_8\",\n                                \"q16_4\",\n                                \"q16_3\",\n                                \"q16_2\"\n                            ],\n                            \"question\": \"q16\"\n                        },\n                        {\n                            \"options\": [\n                                \"q17_4\"\n                            ],\n                            \"question\": \"q17\"\n                        },\n                        {\n                            \"options\": [\n                                \"q18a_4\",\n                                \"q18a_5\"\n                            ],\n                            \"question\": \"q18a\"\n                        }\n                    ]\n                },\n                \"curated\": null,\n                \"type\": \"shared\",\n                \"shared\": true,\n                \"category\": null,\n                \"folder\": null\n            },\n            {\n                \"id\": 5037,\n                \"name\": \"World Region: North America\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"s6_2\"\n                            ],\n                            \"question\": \"s6\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Demographics\",\n                \"folder\": 357\n            },\n            {\n                \"id\": 4995,\n                \"name\": \"Female 25-34\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q2_2\"\n                            ],\n                            \"question\": \"q2\"\n                        },\n                        {\n                            \"options\": [\n                                \"q4_3\"\n                            ],\n                            \"question\": \"q4\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Demographics\",\n                \"folder\": 357\n            },\n            {\n                \"id\": 4997,\n                \"name\": \"Female 45-54\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q2_2\"\n                            ],\n                            \"question\": \"q2\"\n                        },\n                        {\n                            \"options\": [\n                                \"q4_5\"\n                            ],\n                            \"question\": \"q4\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Demographics\",\n                \"folder\": 357\n            },\n            {\n                \"id\": 4998,\n                \"name\": \"Female 55-64\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q2_2\"\n                            ],\n                            \"question\": \"q2\"\n                        },\n                        {\n                            \"options\": [\n                                \"q4_6\"\n                            ],\n                            \"question\": \"q4\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Demographics\",\n                \"folder\": 357\n            },\n            {\n                \"id\": 5008,\n                \"name\": \"Children in HH: 0\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q8_1\"\n                            ],\n                            \"question\": \"q8\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Demographics\",\n                \"folder\": 357\n            },\n            {\n                \"id\": 5012,\n                \"name\": \"Marital Status: Single\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q7_1\"\n                            ],\n                            \"question\": \"q7\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Demographics\",\n                \"folder\": 357\n            },\n            {\n                \"id\": 5009,\n                \"name\": \"Children in HH: 1\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q8_2\"\n                            ],\n                            \"question\": \"q8\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Demographics\",\n                \"folder\": 357\n            },\n            {\n                \"id\": 5011,\n                \"name\": \"Children in HH: 3+\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q8_4\"\n                            ],\n                            \"question\": \"q8\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Demographics\",\n                \"folder\": 357\n            },\n            {\n                \"id\": 4999,\n                \"name\": \"Male\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q2_1\"\n                            ],\n                            \"question\": \"q2\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Demographics\",\n                \"folder\": 357\n            },\n            {\n                \"id\": 5001,\n                \"name\": \"Male 25-34\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q2_1\"\n                            ],\n                            \"question\": \"q2\"\n                        },\n                        {\n                            \"options\": [\n                                \"q4_3\"\n                            ],\n                            \"question\": \"q4\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Demographics\",\n                \"folder\": 357\n            },\n            {\n                \"id\": 5002,\n                \"name\": \"Male 35-44\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q2_1\"\n                            ],\n                            \"question\": \"q2\"\n                        },\n                        {\n                            \"options\": [\n                                \"q4_4\"\n                            ],\n                            \"question\": \"q4\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Demographics\",\n                \"folder\": 357\n            },\n            {\n                \"id\": 5014,\n                \"name\": \"Marital Status: Married\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q7_3\"\n                            ],\n                            \"question\": \"q7\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Demographics\",\n                \"folder\": 357\n            },\n            {\n                \"id\": 32394,\n                \"name\": \"Social Networkers\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"r4154cd_1\"\n                            ],\n                            \"question\": \"r4154cd\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 5033,\n                \"name\": \"World Region: Asia Pacific\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"s6_4\"\n                            ],\n                            \"question\": \"s6\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Demographics\",\n                \"folder\": 357\n            },\n            {\n                \"id\": 8306,\n                \"name\": \"Teens\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q3_16\",\n                                \"q3_17\",\n                                \"q3_18\",\n                                \"q3_19\"\n                            ],\n                            \"question\": \"q3\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 109,\n                \"name\": \"Parents (Young Children)\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q9_1\",\n                                \"q9_2\"\n                            ],\n                            \"question\": \"q9\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": null,\n                \"category\": \"Audiences\",\n                \"folder\": 358\n            },\n            {\n                \"id\": 8296,\n                \"name\": \"Console Gamers\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q21510_6\"\n                            ],\n                            \"question\": \"q21510\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 43303,\n                \"name\": \"Mobile Internet Users\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q39a_3\"\n                            ],\n                            \"question\": \"q39a\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 43307,\n                \"name\": \"Price Conscious Consumers\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q20_58\"\n                            ],\n                            \"question\": \"q20\",\n                            \"suffixes\": [\n                                4,\n                                5\n                            ]\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 32382,\n                \"name\": \"Tablet Users\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q39a_6\"\n                            ],\n                            \"question\": \"q39a\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 8304,\n                \"name\": \"Parents (Young Children)\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q9_1\",\n                                \"q9_2\"\n                            ],\n                            \"question\": \"q9\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 80901,\n                \"name\": \"blackberry\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q126h_3\"\n                            ],\n                            \"question\": \"q126h\"\n                        }\n                    ]\n                },\n                \"curated\": null,\n                \"type\": \"user\",\n                \"shared\": false,\n                \"category\": null,\n                \"folder\": null\n            },\n            {\n                \"id\": 32512,\n                \"name\": \"Business Leaders\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q14_1\"\n                            ],\n                            \"question\": \"q14\"\n                        },\n                        {\n                            \"options\": [\n                                \"q16_1\"\n                            ],\n                            \"question\": \"q16\"\n                        },\n                        {\n                            \"options\": [\n                                \"q18a_5\",\n                                \"q18a_4\",\n                                \"q18a_3\"\n                            ],\n                            \"question\": \"q18a\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 32514,\n                \"name\": \"Fashionistas\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q25_14\"\n                            ],\n                            \"question\": \"q25\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 358\n            },\n            {\n                \"id\": 32518,\n                \"name\": \"Social Segments: Commentators\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"r1_6\"\n                            ],\n                            \"question\": \"r1\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 358\n            },\n            {\n                \"id\": 32521,\n                \"name\": \"Social Segments: Sharers\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"r1_2\"\n                            ],\n                            \"question\": \"r1\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 358\n            },\n            {\n                \"id\": 32519,\n                \"name\": \"Social Segments: Creators\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"r1_1\"\n                            ],\n                            \"question\": \"r1\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 358\n            },\n            {\n                \"id\": 32520,\n                \"name\": \"Social Segments: Reviewers\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"r1_3\"\n                            ],\n                            \"question\": \"r1\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 358\n            },\n            {\n                \"id\": 32525,\n                \"name\": \"PC Gamers\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q21510_1\"\n                            ],\n                            \"question\": \"q21510\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 358\n            },\n            {\n                \"id\": 32526,\n                \"name\": \"Smartphone Owners\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q39d_1\"\n                            ],\n                            \"question\": \"q39d\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 32522,\n                \"name\": \"Social Segments: Socializers\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"r1_4\"\n                            ],\n                            \"question\": \"r1\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 358\n            },\n            {\n                \"id\": 32388,\n                \"name\": \"Second-Screeners\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q120_4\",\n                                \"q120_5\",\n                                \"q120_3\",\n                                \"q120_1\",\n                                \"q120_2\"\n                            ],\n                            \"question\": \"q120\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 32381,\n                \"name\": \"Spotify Users\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q320_5\"\n                            ],\n                            \"question\": \"q320\",\n                            \"suffixes\": [\n                                1\n                            ]\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Enterprise\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 32387,\n                \"name\": \"WeChat Users\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q126i_26\"\n                            ],\n                            \"question\": \"q126i\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Enterprise\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 32377,\n                \"name\": \"Pinterest Engagers/Contributors\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q46x2_4\"\n                            ],\n                            \"question\": \"q46x2\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 32361,\n                \"name\": \"Twitter Engagers/Contributors\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q46x2_2\"\n                            ],\n                            \"question\": \"q46x2\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 32399,\n                \"name\": \"WhatsApp Users\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q126i_29\"\n                            ],\n                            \"question\": \"q126i\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Enterprise\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 32384,\n                \"name\": \"Viber Users\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q126i_41\"\n                            ],\n                            \"question\": \"q126i\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Enterprise\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 32350,\n                \"name\": \"F1 Fans\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q4142_17\"\n                            ],\n                            \"question\": \"q4142\",\n                            \"suffixes\": [\n                                3,\n                                2,\n                                1\n                            ]\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Enterprise\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 32385,\n                \"name\": \"YouTube Engagers/Contributors\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q46x2_5\"\n                            ],\n                            \"question\": \"q46x2\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 32356,\n                \"name\": \"Shazam Users\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q126i_25\"\n                            ],\n                            \"question\": \"q126i\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Enterprise\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 85888,\n                \"name\": \"Premier League (Watch TV OR ONLINE) 55-64\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q4142_6\"\n                            ],\n                            \"question\": \"q4142\",\n                            \"suffixes\": [\n                                2,\n                                3\n                            ]\n                        },\n                        {\n                            \"options\": [\n                                \"q4_6\"\n                            ],\n                            \"question\": \"q4\"\n                        }\n                    ]\n                },\n                \"curated\": null,\n                \"type\": \"shared\",\n                \"shared\": true,\n                \"category\": null,\n                \"folder\": null\n            },\n            {\n                \"id\": 32352,\n                \"name\": \"NFL Fans\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q4142_1\"\n                            ],\n                            \"question\": \"q4142\",\n                            \"suffixes\": [\n                                3,\n                                2,\n                                1\n                            ]\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Enterprise\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 32371,\n                \"name\": \"Facebook Messenger Users\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q126i_23\"\n                            ],\n                            \"question\": \"q126i\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Enterprise\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 32699,\n                \"name\": \"Marital Status: Divorced/Widowed\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q7_4\"\n                            ],\n                            \"question\": \"q7\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Demographics\",\n                \"folder\": 357\n            },\n            {\n                \"id\": 32372,\n                \"name\": \"Google+ Engagers/Contributors\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q46x2_3\"\n                            ],\n                            \"question\": \"q46x2\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 32369,\n                \"name\": \"Sports Fans\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q25_26\"\n                            ],\n                            \"question\": \"q25\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 32365,\n                \"name\": \"Vlog Watchers\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"r4154cd_34\"\n                            ],\n                            \"question\": \"r4154cd\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 32380,\n                \"name\": \"SoundCloud Users\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q320_61\"\n                            ],\n                            \"question\": \"q320\",\n                            \"suffixes\": [\n                                1\n                            ]\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Enterprise\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 32358,\n                \"name\": \"Snapchat Users\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q126i_30\"\n                            ],\n                            \"question\": \"q126i\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Enterprise\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 32404,\n                \"name\": \"Facebook Account Holders\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q46x1_1\"\n                            ],\n                            \"question\": \"q46x1\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Enterprise\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 32373,\n                \"name\": \"iPhone Owners\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q127ag2_5\"\n                            ],\n                            \"question\": \"q127ag2\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Enterprise\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 32397,\n                \"name\": \"Online Shoppers\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"r4154cd_22\"\n                            ],\n                            \"question\": \"r4154cd\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 32346,\n                \"name\": \"Brand Followers\",\n                \"expression\": {\n                    \"or\": [\n                        {\n                            \"options\": [\n                                \"q48_9\",\n                                \"q48_10\"\n                            ],\n                            \"question\": \"q48\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 32378,\n                \"name\": \"Reddit Engagers/Contributors\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q46x2_48\"\n                            ],\n                            \"question\": \"q46x2\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 32405,\n                \"name\": \"Twitter Account Holders\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q46x1_2\"\n                            ],\n                            \"question\": \"q46x1\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Enterprise\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 32376,\n                \"name\": \"LinkedIn Engagers/Contributors\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q46x2_6\"\n                            ],\n                            \"question\": \"q46x2\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 32403,\n                \"name\": \"Podcast Listeners\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"r4154cd_30\"\n                            ],\n                            \"question\": \"r4154cd\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 32396,\n                \"name\": \"Vine Engagers/Contributors\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q46x2_56\"\n                            ],\n                            \"question\": \"q46x2\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 32697,\n                \"name\": \"Education: Post Graduate\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q6_5\"\n                            ],\n                            \"question\": \"q6\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Demographics\",\n                \"folder\": 357\n            },\n            {\n                \"id\": 32386,\n                \"name\": \"VPN Users\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q309_1\"\n                            ],\n                            \"question\": \"q309\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 32085,\n                \"name\": \"4G Mobile Users\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q39c_1\"\n                            ],\n                            \"question\": \"q39c\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 32375,\n                \"name\": \"Netflix Users\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q320_1\"\n                            ],\n                            \"question\": \"q320\",\n                            \"suffixes\": [\n                                1\n                            ]\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Enterprise\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 32362,\n                \"name\": \"Facebook Engagers/Contributors\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q46x2_1\"\n                            ],\n                            \"question\": \"q46x2\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 32348,\n                \"name\": \"Business Travelers\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q311_1\",\n                                \"q311_2\"\n                            ],\n                            \"question\": \"q311\",\n                            \"suffixes\": [\n                                3\n                            ]\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 32359,\n                \"name\": \"Students\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q14_6\"\n                            ],\n                            \"question\": \"q14\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 35789,\n                \"name\": \"Ad-Blockers\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q324_4\"\n                            ],\n                            \"question\": \"q324\",\n                            \"suffixes\": [\n                                1\n                            ]\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 35792,\n                \"name\": \"Social Sharers\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q2157_13\"\n                            ],\n                            \"question\": \"q2157\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 35793,\n                \"name\": \"Streaming Device Owners\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q39d_10\"\n                            ],\n                            \"question\": \"q39d\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 44991,\n                \"name\": \"Vacationers\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q311_4\",\n                                \"q311_3\",\n                                \"q311_2\",\n                                \"q311_1\"\n                            ],\n                            \"question\": \"q311\",\n                            \"suffixes\": [\n                                2\n                            ]\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 358\n            },\n            {\n                \"id\": 45382,\n                \"name\": \"LINE Users\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q126i_32\"\n                            ],\n                            \"question\": \"q126i\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Enterprise\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 43304,\n                \"name\": \"Eco-Consumers\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"r2021e_48\"\n                            ],\n                            \"question\": \"r2021e\"\n                        },\n                        {\n                            \"options\": [\n                                \"q2154_11\"\n                            ],\n                            \"question\": \"q2154\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 43308,\n                \"name\": \"Brand Experimenters\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q20_7\"\n                            ],\n                            \"question\": \"q20\",\n                            \"suffixes\": [\n                                4,\n                                5\n                            ]\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 43306,\n                \"name\": \"Brand Conscious Consumers\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q20_24\"\n                            ],\n                            \"question\": \"q20\",\n                            \"suffixes\": [\n                                4,\n                                5\n                            ]\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 43309,\n                \"name\": \"Brand Loyalists\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q20_10\"\n                            ],\n                            \"question\": \"q20\",\n                            \"suffixes\": [\n                                4,\n                                5\n                            ]\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 95,\n                \"name\": \"Baby Boomers\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q3_52\",\n                                \"q3_53\",\n                                \"q3_54\",\n                                \"q3_55\",\n                                \"q3_56\",\n                                \"q3_57\",\n                                \"q3_58\",\n                                \"q3_59\",\n                                \"q3_60\",\n                                \"q3_61\",\n                                \"q3_62\",\n                                \"q3_63\",\n                                \"q3_64\"\n                            ],\n                            \"question\": \"q3\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": null,\n                \"category\": \"Audiences\",\n                \"folder\": 358\n            },\n            {\n                \"id\": 223,\n                \"name\": \"All Internet Uses\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q2_2\",\n                                \"q2_1\"\n                            ],\n                            \"question\": \"q2\"\n                        }\n                    ]\n                },\n                \"curated\": null,\n                \"type\": \"shared\",\n                \"shared\": true,\n                \"category\": null,\n                \"folder\": null\n            },\n            {\n                \"id\": 1809,\n                \"name\": \"Console Gamers\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q21510_6\"\n                            ],\n                            \"question\": \"q21510\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 358\n            },\n            {\n                \"id\": 4994,\n                \"name\": \"Female 16-24\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q2_2\"\n                            ],\n                            \"question\": \"q2\"\n                        },\n                        {\n                            \"options\": [\n                                \"q4_2\"\n                            ],\n                            \"question\": \"q4\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Demographics\",\n                \"folder\": 357\n            },\n            {\n                \"id\": 43305,\n                \"name\": \"Early Tech Adopters\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q39d_1\"\n                            ],\n                            \"question\": \"q39d\"\n                        },\n                        {\n                            \"options\": [\n                                \"q39d_4\"\n                            ],\n                            \"question\": \"q39d\"\n                        },\n                        {\n                            \"options\": [\n                                \"q39d_5\",\n                                \"q39d_6\"\n                            ],\n                            \"question\": \"q39d\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 60808,\n                \"name\": \"PRUK>Confident Connectors\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"s2_44\"\n                            ],\n                            \"question\": \"s2\"\n                        },\n                        {\n                            \"options\": [\n                                \"q20_6\",\n                                \"q20_8\",\n                                \"q20_26\",\n                                \"q20_16\",\n                                \"q20_52\",\n                                \"q20_42\"\n                            ],\n                            \"question\": \"q20\",\n                            \"suffixes\": [\n                                5\n                            ]\n                        },\n                        {\n                            \"options\": [\n                                \"q4_3\",\n                                \"q4_4\"\n                            ],\n                            \"question\": \"q4\"\n                        },\n                        {\n                            \"options\": [\n                                \"q94new_23\"\n                            ],\n                            \"question\": \"q94new\"\n                        }\n                    ]\n                },\n                \"curated\": null,\n                \"type\": \"shared\",\n                \"shared\": true,\n                \"category\": null,\n                \"folder\": null\n            },\n            {\n                \"id\": 48982,\n                \"name\": \"mums ( 21+) with kids aged 3-11) copy - pay TV\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q3_16\",\n                                \"q3_17\",\n                                \"q3_18\",\n                                \"q3_19\",\n                                \"q3_20\"\n                            ],\n                            \"question\": \"q3\",\n                            \"not\": true\n                        },\n                        {\n                            \"options\": [\n                                \"q2_2\"\n                            ],\n                            \"question\": \"q2\"\n                        },\n                        {\n                            \"options\": [\n                                \"q8_2\",\n                                \"q8_3\",\n                                \"q8_4\"\n                            ],\n                            \"question\": \"q8\"\n                        },\n                        {\n                            \"options\": [\n                                \"q9_2\",\n                                \"q9_3\"\n                            ],\n                            \"question\": \"q9\"\n                        },\n                        {\n                            \"options\": [\n                                \"q1151_1\"\n                            ],\n                            \"question\": \"q1151\"\n                        }\n                    ]\n                },\n                \"curated\": null,\n                \"type\": \"shared\",\n                \"shared\": true,\n                \"category\": null,\n                \"folder\": null\n            },\n            {\n                \"id\": 82636,\n                \"name\": \"NBC Chicago - C Suite\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"o0_0\"\n                            ],\n                            \"question\": \"gwiq-c0111.o0\"\n                        },\n                        {\n                            \"options\": [\n                                \"i1_2\",\n                                \"i1_3\"\n                            ],\n                            \"question\": \"i1\"\n                        }\n                    ]\n                },\n                \"curated\": null,\n                \"type\": \"shared\",\n                \"shared\": true,\n                \"category\": null,\n                \"folder\": null\n            },\n            {\n                \"id\": 53506,\n                \"name\": \"Car Buyers\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q91_11\"\n                            ],\n                            \"question\": \"q91\",\n                            \"suffixes\": [\n                                4\n                            ]\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 52334,\n                \"name\": \"Old Fiesta\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q2_2\"\n                            ],\n                            \"question\": \"q2\"\n                        },\n                        {\n                            \"options\": [\n                                \"q4_3\"\n                            ],\n                            \"question\": \"q4\"\n                        },\n                        {\n                            \"options\": [\n                                \"q14_1\"\n                            ],\n                            \"question\": \"q14\"\n                        },\n                        {\n                            \"options\": [\n                                \"q9_1\",\n                                \"q9_3\",\n                                \"q9_2\",\n                                \"q9_4\",\n                                \"q9_5\",\n                                \"q9_6\",\n                                \"q9_7\"\n                            ],\n                            \"question\": \"q9\",\n                            \"not\": true\n                        },\n                        {\n                            \"options\": [\n                                \"q20_23\",\n                                \"q20_16\",\n                                \"q20_26\",\n                                \"q20_11\",\n                                \"q20_4\"\n                            ],\n                            \"question\": \"q20\",\n                            \"min_count\": \"3\",\n                            \"suffixes\": [\n                                5,\n                                4\n                            ]\n                        },\n                        {\n                            \"options\": [\n                                \"q20_3\",\n                                \"q20_42\"\n                            ],\n                            \"question\": \"q20\",\n                            \"suffixes\": [\n                                5,\n                                4\n                            ]\n                        },\n                        {\n                            \"options\": [\n                                \"q91_11\"\n                            ],\n                            \"question\": \"q91\",\n                            \"suffixes\": [\n                                1,\n                                2\n                            ]\n                        }\n                    ]\n                },\n                \"curated\": null,\n                \"type\": \"shared\",\n                \"shared\": true,\n                \"category\": null,\n                \"folder\": null\n            },\n            {\n                \"id\": 52348,\n                \"name\": \"Mondeo\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q2_1\"\n                            ],\n                            \"question\": \"q2\"\n                        },\n                        {\n                            \"options\": [\n                                \"q4_4\"\n                            ],\n                            \"question\": \"q4\"\n                        },\n                        {\n                            \"options\": [\n                                \"q7_3\"\n                            ],\n                            \"question\": \"q7\"\n                        },\n                        {\n                            \"options\": [\n                                \"q9_1\",\n                                \"q9_3\",\n                                \"q9_2\",\n                                \"q9_4\",\n                                \"q9_5\",\n                                \"q9_6\",\n                                \"q9_7\"\n                            ],\n                            \"question\": \"q9\"\n                        },\n                        {\n                            \"or\": [\n                                {\n                                    \"options\": [\n                                        \"q21a_17\"\n                                    ],\n                                    \"question\": \"q21a\",\n                                    \"suffixes\": [\n                                        5,\n                                        4\n                                    ]\n                                },\n                                {\n                                    \"options\": [\n                                        \"q20_14\",\n                                        \"q20_8\",\n                                        \"q20_16\",\n                                        \"q20_3\",\n                                        \"q20_23\"\n                                    ],\n                                    \"question\": \"q20\",\n                                    \"min_count\": \"3\",\n                                    \"suffixes\": [\n                                        5,\n                                        4\n                                    ]\n                                }\n                            ]\n                        },\n                        {\n                            \"options\": [\n                                \"q91_11\"\n                            ],\n                            \"question\": \"q91\",\n                            \"suffixes\": [\n                                1,\n                                2\n                            ]\n                        }\n                    ]\n                },\n                \"curated\": null,\n                \"type\": \"shared\",\n                \"shared\": true,\n                \"category\": null,\n                \"folder\": null\n            },\n            {\n                \"id\": 52377,\n                \"name\": \"Old Fiesta copy\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q2_2\"\n                            ],\n                            \"question\": \"q2\"\n                        },\n                        {\n                            \"options\": [\n                                \"q4_3\"\n                            ],\n                            \"question\": \"q4\"\n                        },\n                        {\n                            \"options\": [\n                                \"q14_1\"\n                            ],\n                            \"question\": \"q14\"\n                        },\n                        {\n                            \"options\": [\n                                \"q9_1\",\n                                \"q9_3\",\n                                \"q9_2\",\n                                \"q9_4\",\n                                \"q9_5\",\n                                \"q9_6\",\n                                \"q9_7\"\n                            ],\n                            \"question\": \"q9\",\n                            \"not\": true\n                        },\n                        {\n                            \"or\": [\n                                {\n                                    \"options\": [\n                                        \"q20_23\",\n                                        \"q20_16\",\n                                        \"q20_26\",\n                                        \"q20_11\",\n                                        \"q20_4\"\n                                    ],\n                                    \"question\": \"q20\",\n                                    \"min_count\": \"3\",\n                                    \"suffixes\": [\n                                        5,\n                                        4\n                                    ]\n                                },\n                                {\n                                    \"options\": [\n                                        \"q20_3\",\n                                        \"q20_42\"\n                                    ],\n                                    \"question\": \"q20\",\n                                    \"suffixes\": [\n                                        5,\n                                        4\n                                    ]\n                                }\n                            ]\n                        }\n                    ]\n                },\n                \"curated\": null,\n                \"type\": \"shared\",\n                \"shared\": true,\n                \"category\": null,\n                \"folder\": null\n            },\n            {\n                \"id\": 56010,\n                \"name\": \"AOL Travel for business abroad \",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q311_1\"\n                            ],\n                            \"question\": \"q311\",\n                            \"suffixes\": [\n                                3\n                            ]\n                        },\n                        {\n                            \"options\": [\n                                \"q4_4\",\n                                \"q4_5\",\n                                \"q4_6\"\n                            ],\n                            \"question\": \"q4\"\n                        },\n                        {\n                            \"options\": [\n                                \"r52allse_1\"\n                            ],\n                            \"question\": \"r52allse\"\n                        }\n                    ]\n                },\n                \"curated\": null,\n                \"type\": \"shared\",\n                \"shared\": true,\n                \"category\": null,\n                \"folder\": null\n            },\n            {\n                \"id\": 57550,\n                \"name\": \"Flipboard users  \",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q126i_39\"\n                            ],\n                            \"question\": \"q126i\"\n                        }\n                    ]\n                },\n                \"curated\": null,\n                \"type\": \"shared\",\n                \"shared\": true,\n                \"category\": null,\n                \"folder\": null\n            },\n            {\n                \"id\": 53514,\n                \"name\": \"Online-Only TV Viewers\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q27lf_10\"\n                            ],\n                            \"question\": \"q27lf\",\n                            \"not\": true\n                        },\n                        {\n                            \"options\": [\n                                \"q27lb_10\"\n                            ],\n                            \"question\": \"q27lb\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 53515,\n                \"name\": \"Linear Loyalists\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q27lf_10\"\n                            ],\n                            \"question\": \"q27lf\"\n                        },\n                        {\n                            \"options\": [\n                                \"q27lb_10\"\n                            ],\n                            \"question\": \"q27lb\",\n                            \"not\": true\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 32360,\n                \"name\": \"Top 1%\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"or\": [\n                                {\n                                    \"options\": [\n                                        \"q4dar_7\"\n                                    ],\n                                    \"question\": \"q4dar\"\n                                },\n                                {\n                                    \"options\": [\n                                        \"q4dau_7\"\n                                    ],\n                                    \"question\": \"q4dau\"\n                                },\n                                {\n                                    \"options\": [\n                                        \"q4dbe_7\"\n                                    ],\n                                    \"question\": \"q4dbe\"\n                                },\n                                {\n                                    \"options\": [\n                                        \"q4dbr_7\"\n                                    ],\n                                    \"question\": \"q4dbr\"\n                                },\n                                {\n                                    \"options\": [\n                                        \"q4dca_7\"\n                                    ],\n                                    \"question\": \"q4dca\"\n                                },\n                                {\n                                    \"options\": [\n                                        \"q4dfr_7\"\n                                    ],\n                                    \"question\": \"q4dfr\"\n                                },\n                                {\n                                    \"options\": [\n                                        \"q4dde_7\"\n                                    ],\n                                    \"question\": \"q4dde\"\n                                },\n                                {\n                                    \"options\": [\n                                        \"q4dhk_7\"\n                                    ],\n                                    \"question\": \"q4dhk\"\n                                },\n                                {\n                                    \"options\": [\n                                        \"q4din_7\"\n                                    ],\n                                    \"question\": \"q4din\"\n                                },\n                                {\n                                    \"options\": [\n                                        \"q4dind_7\"\n                                    ],\n                                    \"question\": \"q4dind\"\n                                },\n                                {\n                                    \"options\": [\n                                        \"q4dit_7\"\n                                    ],\n                                    \"question\": \"q4dit\"\n                                },\n                                {\n                                    \"options\": [\n                                        \"q4dire_7\"\n                                    ],\n                                    \"question\": \"q4dire\"\n                                },\n                                {\n                                    \"options\": [\n                                        \"q4djp_7\"\n                                    ],\n                                    \"question\": \"q4djp\"\n                                },\n                                {\n                                    \"options\": [\n                                        \"q4dml_7\"\n                                    ],\n                                    \"question\": \"q4dml\"\n                                },\n                                {\n                                    \"options\": [\n                                        \"q4dmx_7\"\n                                    ],\n                                    \"question\": \"q4dmx\"\n                                },\n                                {\n                                    \"options\": [\n                                        \"q4dnl_7\"\n                                    ],\n                                    \"question\": \"q4dnl\"\n                                },\n                                {\n                                    \"options\": [\n                                        \"q4dph_7\"\n                                    ],\n                                    \"question\": \"q4dph\"\n                                },\n                                {\n                                    \"options\": [\n                                        \"q4dpo_7\"\n                                    ],\n                                    \"question\": \"q4dpo\"\n                                },\n                                {\n                                    \"options\": [\n                                        \"q4dpt_7\"\n                                    ],\n                                    \"question\": \"q4dpt\"\n                                },\n                                {\n                                    \"options\": [\n                                        \"q4dru_7\"\n                                    ],\n                                    \"question\": \"q4dru\"\n                                },\n                                {\n                                    \"options\": [\n                                        \"q4dsa_7\"\n                                    ],\n                                    \"question\": \"q4dsa\"\n                                },\n                                {\n                                    \"options\": [\n                                        \"q4dsg_7\"\n                                    ],\n                                    \"question\": \"q4dsg\"\n                                },\n                                {\n                                    \"options\": [\n                                        \"q4dza_7\"\n                                    ],\n                                    \"question\": \"q4dza\"\n                                },\n                                {\n                                    \"options\": [\n                                        \"q4dsk_7\"\n                                    ],\n                                    \"question\": \"q4dsk\"\n                                },\n                                {\n                                    \"options\": [\n                                        \"q4des_7\"\n                                    ],\n                                    \"question\": \"q4des\"\n                                },\n                                {\n                                    \"options\": [\n                                        \"q4dse_7\"\n                                    ],\n                                    \"question\": \"q4dse\"\n                                },\n                                {\n                                    \"options\": [\n                                        \"q4dtw_7\"\n                                    ],\n                                    \"question\": \"q4dtw\"\n                                },\n                                {\n                                    \"options\": [\n                                        \"q4dth_7\"\n                                    ],\n                                    \"question\": \"q4dth\"\n                                },\n                                {\n                                    \"options\": [\n                                        \"q4dtr_7\"\n                                    ],\n                                    \"question\": \"q4dtr\"\n                                },\n                                {\n                                    \"options\": [\n                                        \"q4duae_7\"\n                                    ],\n                                    \"question\": \"q4duae\"\n                                },\n                                {\n                                    \"options\": [\n                                        \"q4duk_7\"\n                                    ],\n                                    \"question\": \"q4duk\"\n                                },\n                                {\n                                    \"options\": [\n                                        \"q4dus_7\"\n                                    ],\n                                    \"question\": \"q4dus\"\n                                },\n                                {\n                                    \"options\": [\n                                        \"q4dvt_7\"\n                                    ],\n                                    \"question\": \"q4dvt\"\n                                },\n                                {\n                                    \"options\": [\n                                        \"q4dcn_7\"\n                                    ],\n                                    \"question\": \"q4dcn\"\n                                }\n                            ]\n                        },\n                        {\n                            \"options\": [\n                                \"q1d_2\",\n                                \"q1d_4\",\n                                \"q1d_3\"\n                            ],\n                            \"question\": \"q1d\",\n                            \"suffixes\": [\n                                1\n                            ]\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 82270,\n                \"name\": \"Mothers Gen Y\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q8_2\",\n                                \"q8_4\",\n                                \"q8_3\"\n                            ],\n                            \"question\": \"q8\"\n                        },\n                        {\n                            \"options\": [\n                                \"q4_2\",\n                                \"q4_3\"\n                            ],\n                            \"question\": \"q4\"\n                        }\n                    ]\n                },\n                \"curated\": null,\n                \"type\": \"shared\",\n                \"shared\": true,\n                \"category\": null,\n                \"folder\": null\n            },\n            {\n                \"id\": 105,\n                \"name\": \"Celebrity Gossipers\",\n                \"expression\": {\n                    \"or\": [\n                        {\n                            \"options\": [\n                                \"q25_13\"\n                            ],\n                            \"question\": \"q25\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 358\n            },\n            {\n                \"id\": 120,\n                \"name\": \"Business Leaders\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q14_1\"\n                            ],\n                            \"question\": \"q14\"\n                        },\n                        {\n                            \"options\": [\n                                \"q18a_4\",\n                                \"q18a_5\",\n                                \"q18a_3\"\n                            ],\n                            \"question\": \"q18a\"\n                        },\n                        {\n                            \"options\": [\n                                \"q16_1\"\n                            ],\n                            \"question\": \"q16\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 358\n            },\n            {\n                \"id\": 121,\n                \"name\": \"Travel Enthusiasts\",\n                \"expression\": {\n                    \"or\": [\n                        {\n                            \"options\": [\n                                \"q25_5\"\n                            ],\n                            \"question\": \"q25\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 358\n            },\n            {\n                \"id\": 122,\n                \"name\": \"Movie Buffs\",\n                \"expression\": {\n                    \"or\": [\n                        {\n                            \"options\": [\n                                \"q25_4\"\n                            ],\n                            \"question\": \"q25\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 358\n            },\n            {\n                \"id\": 123,\n                \"name\": \"Finance Experts\",\n                \"expression\": {\n                    \"or\": [\n                        {\n                            \"options\": [\n                                \"q25_21\"\n                            ],\n                            \"question\": \"q25\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 358\n            },\n            {\n                \"id\": 125,\n                \"name\": \"Social Segments: Passives\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"r1_5\"\n                            ],\n                            \"question\": \"r1\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 358\n            },\n            {\n                \"id\": 126,\n                \"name\": \"Smartphone Owners\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q39d_1\"\n                            ],\n                            \"question\": \"q39d\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 358\n            },\n            {\n                \"id\": 129,\n                \"name\": \"Photo Fanatics\",\n                \"expression\": {\n                    \"or\": [\n                        {\n                            \"options\": [\n                                \"q25_20\"\n                            ],\n                            \"question\": \"q25\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 358\n            },\n            {\n                \"id\": 130,\n                \"name\": \"Parents\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q9_1\",\n                                \"q9_2\",\n                                \"q9_3\",\n                                \"q9_4\",\n                                \"q9_5\",\n                                \"q9_6\",\n                                \"q9_7\"\n                            ],\n                            \"question\": \"q9\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": null,\n                \"category\": \"Audiences\",\n                \"folder\": 358\n            },\n            {\n                \"id\": 131,\n                \"name\": \"Culture Lovers\",\n                \"expression\": {\n                    \"or\": [\n                        {\n                            \"options\": [\n                                \"q25_15\"\n                            ],\n                            \"question\": \"q25\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 358\n            },\n            {\n                \"id\": 5024,\n                \"name\": \"Employment: Self-Employed\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q14_4\"\n                            ],\n                            \"question\": \"q14\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Demographics\",\n                \"folder\": 357\n            },\n            {\n                \"id\": 5027,\n                \"name\": \"Employment: Unemployed\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q14_7\"\n                            ],\n                            \"question\": \"q14\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Demographics\",\n                \"folder\": 357\n            },\n            {\n                \"id\": 5005,\n                \"name\": \"Income: Bottom 25%\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"i1_1\"\n                            ],\n                            \"question\": \"i1\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Demographics\",\n                \"folder\": 357\n            },\n            {\n                \"id\": 8305,\n                \"name\": \"Tech Influencers\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q115_13\"\n                            ],\n                            \"question\": \"q115\"\n                        },\n                        {\n                            \"options\": [\n                                \"q20_6\"\n                            ],\n                            \"question\": \"q20\",\n                            \"suffixes\": [\n                                5\n                            ]\n                        },\n                        {\n                            \"options\": [\n                                \"q25_1\"\n                            ],\n                            \"question\": \"q25\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 43310,\n                \"name\": \"YouTube Visitors\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"r52all_9\"\n                            ],\n                            \"question\": \"r52all\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Enterprise\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 32391,\n                \"name\": \"Skype Users\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q126i_22\"\n                            ],\n                            \"question\": \"q126i\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Enterprise\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 8303,\n                \"name\": \"Parents\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q9_1\",\n                                \"q9_2\",\n                                \"q9_3\",\n                                \"q9_4\",\n                                \"q9_5\",\n                                \"q9_6\",\n                                \"q9_7\"\n                            ],\n                            \"question\": \"q9\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 35788,\n                \"name\": \"Digital Content Purchasers\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q85b1_17\",\n                                \"q85b1_19\",\n                                \"q85b1_18\",\n                                \"q85b1_20\",\n                                \"q85b1_16\",\n                                \"q85b1_15\",\n                                \"q85b1_11\",\n                                \"q85b1_21\",\n                                \"q85b1_13\",\n                                \"q85b1_22\",\n                                \"q85b1_9\",\n                                \"q85b1_4\",\n                                \"q85b1_12\",\n                                \"q85b1_10\",\n                                \"q85b1_8\",\n                                \"q85b1_14\",\n                                \"q85b1_6\",\n                                \"q85b1_7\",\n                                \"q85b1_3\"\n                            ],\n                            \"question\": \"q85b1\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 96,\n                \"name\": \"B2B Buyers\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q17_4\",\n                                \"q17_5\"\n                            ],\n                            \"question\": \"q17\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": null,\n                \"category\": \"Audiences\",\n                \"folder\": 358\n            },\n            {\n                \"id\": 98,\n                \"name\": \"Dads\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q2_1\"\n                            ],\n                            \"question\": \"q2\"\n                        },\n                        {\n                            \"options\": [\n                                \"q9_1\",\n                                \"q9_2\",\n                                \"q9_3\",\n                                \"q9_4\",\n                                \"q9_5\",\n                                \"q9_6\",\n                                \"q9_7\"\n                            ],\n                            \"question\": \"q9\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": null,\n                \"category\": \"Audiences\",\n                \"folder\": 358\n            },\n            {\n                \"id\": 99,\n                \"name\": \"Entrepreneurs\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q14_4\"\n                            ],\n                            \"question\": \"q14\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 358\n            },\n            {\n                \"id\": 100,\n                \"name\": \"Fitness Fanatics\",\n                \"expression\": {\n                    \"or\": [\n                        {\n                            \"options\": [\n                                \"q25_24\"\n                            ],\n                            \"question\": \"q25\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 358\n            },\n            {\n                \"id\": 101,\n                \"name\": \"Petrol Heads\",\n                \"expression\": {\n                    \"or\": [\n                        {\n                            \"options\": [\n                                \"q25_18\"\n                            ],\n                            \"question\": \"q25\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 358\n            },\n            {\n                \"id\": 108,\n                \"name\": \"Moms\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q2_2\"\n                            ],\n                            \"question\": \"q2\"\n                        },\n                        {\n                            \"options\": [\n                                \"q9_1\",\n                                \"q9_2\",\n                                \"q9_3\",\n                                \"q9_4\",\n                                \"q9_5\",\n                                \"q9_6\",\n                                \"q9_7\"\n                            ],\n                            \"question\": \"q9\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": null,\n                \"category\": \"Audiences\",\n                \"folder\": 358\n            },\n            {\n                \"id\": 110,\n                \"name\": \"Environmentalists\",\n                \"expression\": {\n                    \"or\": [\n                        {\n                            \"options\": [\n                                \"q25_8\"\n                            ],\n                            \"question\": \"q25\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 358\n            },\n            {\n                \"id\": 111,\n                \"name\": \"Teens\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q3_16\",\n                                \"q3_17\",\n                                \"q3_18\",\n                                \"q3_19\"\n                            ],\n                            \"question\": \"q3\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": null,\n                \"category\": \"Audiences\",\n                \"folder\": 358\n            },\n            {\n                \"id\": 112,\n                \"name\": \"Brand Advocates\",\n                \"expression\": {\n                    \"or\": [\n                        {\n                            \"options\": [\n                                \"q20_6\"\n                            ],\n                            \"question\": \"q20\",\n                            \"suffixes\": [\n                                5\n                            ]\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 358\n            },\n            {\n                \"id\": 113,\n                \"name\": \"Gen X\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q3_33\",\n                                \"q3_34\",\n                                \"q3_35\",\n                                \"q3_36\",\n                                \"q3_37\",\n                                \"q3_38\",\n                                \"q3_39\",\n                                \"q3_40\",\n                                \"q3_41\",\n                                \"q3_42\",\n                                \"q3_43\",\n                                \"q3_44\",\n                                \"q3_45\",\n                                \"q3_46\",\n                                \"q3_47\",\n                                \"q3_48\",\n                                \"q3_49\",\n                                \"q3_50\",\n                                \"q3_51\"\n                            ],\n                            \"question\": \"q3\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 358\n            },\n            {\n                \"id\": 8298,\n                \"name\": \"Gen X\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q3_33\",\n                                \"q3_34\",\n                                \"q3_35\",\n                                \"q3_36\",\n                                \"q3_37\",\n                                \"q3_38\",\n                                \"q3_39\",\n                                \"q3_40\",\n                                \"q3_41\",\n                                \"q3_42\",\n                                \"q3_43\",\n                                \"q3_44\",\n                                \"q3_45\",\n                                \"q3_46\",\n                                \"q3_47\",\n                                \"q3_48\",\n                                \"q3_49\",\n                                \"q3_50\",\n                                \"q3_51\"\n                            ],\n                            \"question\": \"q3\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 8299,\n                \"name\": \"Gen Y / Millennials\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q3_18\",\n                                \"q3_19\",\n                                \"q3_20\",\n                                \"q3_21\",\n                                \"q3_22\",\n                                \"q3_23\",\n                                \"q3_24\",\n                                \"q3_25\",\n                                \"q3_26\",\n                                \"q3_27\",\n                                \"q3_28\",\n                                \"q3_29\",\n                                \"q3_30\",\n                                \"q3_31\",\n                                \"q3_32\"\n                            ],\n                            \"question\": \"q3\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 114,\n                \"name\": \"Gen Y / Millennials\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q3_18\",\n                                \"q3_19\",\n                                \"q3_20\",\n                                \"q3_21\",\n                                \"q3_22\",\n                                \"q3_23\",\n                                \"q3_24\",\n                                \"q3_25\",\n                                \"q3_26\",\n                                \"q3_27\",\n                                \"q3_28\",\n                                \"q3_29\",\n                                \"q3_30\",\n                                \"q3_31\",\n                                \"q3_32\"\n                            ],\n                            \"question\": \"q3\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 358\n            },\n            {\n                \"id\": 127,\n                \"name\": \"Sports Players\",\n                \"expression\": {\n                    \"or\": [\n                        {\n                            \"options\": [\n                                \"q25_25\"\n                            ],\n                            \"question\": \"q25\"\n                        },\n                        {\n                            \"options\": [\n                                \"q4141_2\",\n                                \"q4141_16\",\n                                \"q4141_9\",\n                                \"q4141_3\",\n                                \"q4141_18\",\n                                \"q4141_7\",\n                                \"q4141_15\",\n                                \"q4141_10\",\n                                \"q4141_11\",\n                                \"q4141_1\",\n                                \"q4141_5\",\n                                \"q4141_8\",\n                                \"q4141_14\",\n                                \"q4141_6\",\n                                \"q4141_19\",\n                                \"q4141_17\",\n                                \"q4141_13\",\n                                \"q4141_4\",\n                                \"q4141_12\"\n                            ],\n                            \"question\": \"q4141\",\n                            \"suffixes\": [\n                                1\n                            ]\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 358\n            },\n            {\n                \"id\": 128,\n                \"name\": \"Tech Influencers\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"and\": [\n                                {\n                                    \"options\": [\n                                        \"q25_1\"\n                                    ],\n                                    \"question\": \"q25\"\n                                },\n                                {\n                                    \"options\": [\n                                        \"q115_13\"\n                                    ],\n                                    \"question\": \"q115\"\n                                }\n                            ]\n                        },\n                        {\n                            \"options\": [\n                                \"q20_6\"\n                            ],\n                            \"question\": \"q20\",\n                            \"suffixes\": [\n                                5,\n                                4\n                            ]\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 358\n            },\n            {\n                \"id\": 133,\n                \"name\": \"Beauty Fans\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q25_17\"\n                            ],\n                            \"question\": \"q25\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 358\n            },\n            {\n                \"id\": 1811,\n                \"name\": \"Mobile Gamers\",\n                \"expression\": {\n                    \"or\": [\n                        {\n                            \"options\": [\n                                \"q21510_4\"\n                            ],\n                            \"question\": \"q21510\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 358\n            },\n            {\n                \"id\": 8293,\n                \"name\": \"Baby Boomers\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q3_52\",\n                                \"q3_53\",\n                                \"q3_54\",\n                                \"q3_55\",\n                                \"q3_56\",\n                                \"q3_57\",\n                                \"q3_58\",\n                                \"q3_59\",\n                                \"q3_60\",\n                                \"q3_61\",\n                                \"q3_62\",\n                                \"q3_63\",\n                                \"q3_64\"\n                            ],\n                            \"question\": \"q3\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 8294,\n                \"name\": \"Brand Advocates\",\n                \"expression\": {\n                    \"or\": [\n                        {\n                            \"options\": [\n                                \"r2021e_35\"\n                            ],\n                            \"question\": \"r2021e\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 8297,\n                \"name\": \"Dads\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q2_1\"\n                            ],\n                            \"question\": \"q2\"\n                        },\n                        {\n                            \"options\": [\n                                \"q9_1\",\n                                \"q9_2\",\n                                \"q9_3\",\n                                \"q9_4\",\n                                \"q9_5\",\n                                \"q9_6\",\n                                \"q9_7\"\n                            ],\n                            \"question\": \"q9\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 8300,\n                \"name\": \"Mobile Gamers\",\n                \"expression\": {\n                    \"or\": [\n                        {\n                            \"options\": [\n                                \"q21510_4\"\n                            ],\n                            \"question\": \"q21510\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 8302,\n                \"name\": \"Moms\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q2_2\"\n                            ],\n                            \"question\": \"q2\"\n                        },\n                        {\n                            \"options\": [\n                                \"q9_1\",\n                                \"q9_2\",\n                                \"q9_3\",\n                                \"q9_4\",\n                                \"q9_5\",\n                                \"q9_6\",\n                                \"q9_7\"\n                            ],\n                            \"question\": \"q9\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 77543,\n                \"name\": \"Hershey_SS_HomemadeTraditionalists\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"and\": [\n                                {\n                                    \"options\": [\n                                        \"q9_5\",\n                                        \"q9_6\",\n                                        \"q9_7\"\n                                    ],\n                                    \"question\": \"q9\"\n                                },\n                                {\n                                    \"options\": [\n                                        \"q8_2\",\n                                        \"q8_3\"\n                                    ],\n                                    \"question\": \"q8\"\n                                }\n                            ]\n                        },\n                        {\n                            \"options\": [\n                                \"q4_5\",\n                                \"q4_6\"\n                            ],\n                            \"question\": \"q4\"\n                        },\n                        {\n                            \"options\": [\n                                \"q13newca_7\",\n                                \"q13newca_8\",\n                                \"q13newca_9\",\n                                \"q13newca_6\"\n                            ],\n                            \"question\": \"q13newca\"\n                        },\n                        {\n                            \"options\": [\n                                \"q2_2\",\n                                \"q2_1\"\n                            ],\n                            \"question\": \"q2\"\n                        },\n                        {\n                            \"options\": [\n                                \"s2_2\"\n                            ],\n                            \"question\": \"s2\"\n                        },\n                        {\n                            \"options\": [\n                                \"q2021a_2\",\n                                \"q2021a_4\",\n                                \"q2021a_5\",\n                                \"q2021a_25\",\n                                \"q2021a_28\",\n                                \"q2021a_38\",\n                                \"q2021a_42\",\n                                \"q2021a_46\"\n                            ],\n                            \"question\": \"q2021a\",\n                            \"min_count\": \"4\"\n                        },\n                        {\n                            \"options\": [\n                                \"q94newfc_27\"\n                            ],\n                            \"question\": \"q94newfc\"\n                        }\n                    ]\n                },\n                \"curated\": false,\n                \"type\": \"shared\",\n                \"shared\": true,\n                \"category\": null,\n                \"folder\": null\n            },\n            {\n                \"id\": 77538,\n                \"name\": \"Hershey_SS_ElvesUnderPressure\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"and\": [\n                                {\n                                    \"and\": [\n                                        {\n                                            \"options\": [\n                                                \"q2_1\"\n                                            ],\n                                            \"question\": \"q2\"\n                                        },\n                                        {\n                                            \"options\": [\n                                                \"s2_2\"\n                                            ],\n                                            \"question\": \"s2\"\n                                        }\n                                    ]\n                                },\n                                {\n                                    \"or\": [\n                                        {\n                                            \"options\": [\n                                                \"q3_18\",\n                                                \"q3_19\",\n                                                \"q3_20\",\n                                                \"q3_21\",\n                                                \"q3_22\",\n                                                \"q3_23\",\n                                                \"q3_24\",\n                                                \"q3_45\",\n                                                \"q3_46\",\n                                                \"q3_47\",\n                                                \"q3_48\"\n                                            ],\n                                            \"question\": \"q3\"\n                                        },\n                                        {\n                                            \"options\": [\n                                                \"q4_3\",\n                                                \"q4_4\"\n                                            ],\n                                            \"question\": \"q4\"\n                                        }\n                                    ]\n                                },\n                                {\n                                    \"options\": [\n                                        \"q13newca_7\",\n                                        \"q13newca_6\",\n                                        \"q13newca_8\"\n                                    ],\n                                    \"question\": \"q13newca\"\n                                }\n                            ]\n                        },\n                        {\n                            \"options\": [\n                                \"q16_5\",\n                                \"q16_6\"\n                            ],\n                            \"question\": \"q16\"\n                        },\n                        {\n                            \"options\": [\n                                \"q2021a_8\",\n                                \"q2021a_39\",\n                                \"q2021a_64\",\n                                \"q2021a_65\",\n                                \"q2021a_7\"\n                            ],\n                            \"question\": \"q2021a\"\n                        },\n                        {\n                            \"options\": [\n                                \"q94new_38\",\n                                \"q94new_27\"\n                            ],\n                            \"question\": \"q94new\"\n                        }\n                    ]\n                },\n                \"curated\": false,\n                \"type\": \"shared\",\n                \"shared\": true,\n                \"category\": null,\n                \"folder\": null\n            },\n            {\n                \"id\": 77539,\n                \"name\": \"Hershey_SS_GraciousGuests\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"s2_2\"\n                            ],\n                            \"question\": \"s2\"\n                        },\n                        {\n                            \"options\": [\n                                \"q13newca_7\",\n                                \"q13newca_6\",\n                                \"q13newca_8\",\n                                \"q13newca_9\"\n                            ],\n                            \"question\": \"q13newca\"\n                        },\n                        {\n                            \"options\": [\n                                \"q2_1\"\n                            ],\n                            \"question\": \"q2\"\n                        },\n                        {\n                            \"options\": [\n                                \"q4_6\"\n                            ],\n                            \"question\": \"q4\"\n                        },\n                        {\n                            \"options\": [\n                                \"q10_4\",\n                                \"q10_1\"\n                            ],\n                            \"question\": \"q10\"\n                        },\n                        {\n                            \"options\": [\n                                \"q14_9\",\n                                \"q14_1\"\n                            ],\n                            \"question\": \"q14\"\n                        },\n                        {\n                            \"options\": [\n                                \"q2021a_2\",\n                                \"q2021a_34\",\n                                \"q2021a_41\",\n                                \"q2021a_28\"\n                            ],\n                            \"question\": \"q2021a\"\n                        },\n                        {\n                            \"options\": [\n                                \"q94newfc_27\"\n                            ],\n                            \"question\": \"q94newfc\"\n                        }\n                    ]\n                },\n                \"curated\": false,\n                \"type\": \"shared\",\n                \"shared\": true,\n                \"category\": null,\n                \"folder\": null\n            },\n            {\n                \"id\": 77541,\n                \"name\": \"Hershey_SS_LacklusterContributors\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q2_1\",\n                                \"q2_2\"\n                            ],\n                            \"question\": \"q2\"\n                        },\n                        {\n                            \"options\": [\n                                \"q13newca_7\",\n                                \"q13newca_8\",\n                                \"q13newca_9\",\n                                \"q13newca_6\"\n                            ],\n                            \"question\": \"q13newca\"\n                        },\n                        {\n                            \"options\": [\n                                \"q4_6\",\n                                \"q4_5\"\n                            ],\n                            \"question\": \"q4\"\n                        },\n                        {\n                            \"options\": [\n                                \"s2_2\"\n                            ],\n                            \"question\": \"s2\"\n                        },\n                        {\n                            \"options\": [\n                                \"q14_9\",\n                                \"q14_8\"\n                            ],\n                            \"question\": \"q14\"\n                        },\n                        {\n                            \"options\": [\n                                \"q2021a_7\",\n                                \"q2021a_28\",\n                                \"q2021a_27\",\n                                \"q2021a_34\"\n                            ],\n                            \"question\": \"q2021a\"\n                        },\n                        {\n                            \"options\": [\n                                \"q94newfc_27\"\n                            ],\n                            \"question\": \"q94newfc\"\n                        }\n                    ]\n                },\n                \"curated\": false,\n                \"type\": \"shared\",\n                \"shared\": true,\n                \"category\": null,\n                \"folder\": null\n            },\n            {\n                \"id\": 77537,\n                \"name\": \"Hershey_SS_ChristmasEnthusiasts\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"or\": [\n                                {\n                                    \"options\": [\n                                        \"q3_45\",\n                                        \"q3_47\",\n                                        \"q3_46\",\n                                        \"q3_48\"\n                                    ],\n                                    \"question\": \"q3\"\n                                },\n                                {\n                                    \"options\": [\n                                        \"q4_3\",\n                                        \"q4_4\"\n                                    ],\n                                    \"question\": \"q4\"\n                                }\n                            ]\n                        },\n                        {\n                            \"options\": [\n                                \"q13newca_6\",\n                                \"q13newca_7\",\n                                \"q13newca_5\"\n                            ],\n                            \"question\": \"q13newca\"\n                        },\n                        {\n                            \"options\": [\n                                \"s2_2\"\n                            ],\n                            \"question\": \"s2\"\n                        },\n                        {\n                            \"options\": [\n                                \"q8_3\",\n                                \"q8_4\",\n                                \"q8_2\",\n                                \"q8_1\"\n                            ],\n                            \"question\": \"q8\"\n                        },\n                        {\n                            \"options\": [\n                                \"q2_2\"\n                            ],\n                            \"question\": \"q2\"\n                        },\n                        {\n                            \"options\": [\n                                \"q2021a_1\",\n                                \"q2021a_45\",\n                                \"q2021a_4\"\n                            ],\n                            \"question\": \"q2021a\"\n                        },\n                        {\n                            \"options\": [\n                                \"q94new_27\"\n                            ],\n                            \"question\": \"q94new\"\n                        }\n                    ]\n                },\n                \"curated\": false,\n                \"type\": \"shared\",\n                \"shared\": true,\n                \"category\": null,\n                \"folder\": null\n            },\n            {\n                \"id\": 67512,\n                \"name\": \"Euro Viewers\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q4142_30\"\n                            ],\n                            \"question\": \"q4142\",\n                            \"suffixes\": [\n                                2,\n                                3\n                            ]\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 32363,\n                \"name\": \"Instagram Engagers/Contributors\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q46x2_49\"\n                            ],\n                            \"question\": \"q46x2\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 31642,\n                \"name\": \"ABC1\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"s2_44\"\n                            ],\n                            \"question\": \"s2\"\n                        },\n                        {\n                            \"options\": [\n                                \"q6_5\",\n                                \"q6_4\",\n                                \"q6_3\"\n                            ],\n                            \"question\": \"q6\"\n                        },\n                        {\n                            \"options\": [\n                                \"q15_1\",\n                                \"q15_4\",\n                                \"q15_6\",\n                                \"q15_7\",\n                                \"q15_10\",\n                                \"q15_13\",\n                                \"q15_16\",\n                                \"q15_17\",\n                                \"q15_19\"\n                            ],\n                            \"question\": \"q15\"\n                        },\n                        {\n                            \"options\": [\n                                \"i1_2\",\n                                \"i1_3\"\n                            ],\n                            \"question\": \"i1\"\n                        }\n                    ]\n                },\n                \"curated\": false,\n                \"type\": \"shared\",\n                \"shared\": true,\n                \"category\": null,\n                \"folder\": null\n            },\n            {\n                \"id\": 32383,\n                \"name\": \"Tumblr Engagers/Contributors\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q46x2_9\"\n                            ],\n                            \"question\": \"q46x2\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 67513,\n                \"name\": \"Fashionistas\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q25_14\"\n                            ],\n                            \"question\": \"q25\"\n                        },\n                        {\n                            \"options\": [\n                                \"q94new_29\"\n                            ],\n                            \"question\": \"q94new\"\n                        },\n                        {\n                            \"options\": [\n                                \"q2021a_25\"\n                            ],\n                            \"question\": \"q2021a\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 31646,\n                \"name\": \"C2DE\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"s2_44\"\n                            ],\n                            \"question\": \"s2\"\n                        },\n                        {\n                            \"options\": [\n                                \"i1_1\"\n                            ],\n                            \"question\": \"i1\"\n                        },\n                        {\n                            \"options\": [\n                                \"q15_9\",\n                                \"q15_5\",\n                                \"q15_8\",\n                                \"q15_11\",\n                                \"q15_12\",\n                                \"q15_18\",\n                                \"q15_2\"\n                            ],\n                            \"question\": \"q15\"\n                        },\n                        {\n                            \"options\": [\n                                \"q6_2\",\n                                \"q6_1\"\n                            ],\n                            \"question\": \"q6\"\n                        }\n                    ]\n                },\n                \"curated\": false,\n                \"type\": \"shared\",\n                \"shared\": true,\n                \"category\": null,\n                \"folder\": null\n            },\n            {\n                \"id\": 67511,\n                \"name\": \"Mobile Ad-Blockers\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q324b_1\"\n                            ],\n                            \"question\": \"q324b\"\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 67516,\n                \"name\": \"Olympics Fans\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q4142_3\"\n                            ],\n                            \"question\": \"q4142\",\n                            \"suffixes\": [\n                                2,\n                                3\n                            ]\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 36272,\n                \"name\": \"25-34 Urban Affluents\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q4_3\"\n                            ],\n                            \"question\": \"q4\"\n                        },\n                        {\n                            \"options\": [\n                                \"q11_1\"\n                            ],\n                            \"question\": \"q11\"\n                        },\n                        {\n                            \"options\": [\n                                \"i1_3\"\n                            ],\n                            \"question\": \"i1\"\n                        }\n                    ]\n                },\n                \"curated\": null,\n                \"type\": \"shared\",\n                \"shared\": true,\n                \"category\": null,\n                \"folder\": null\n            },\n            {\n                \"id\": 77536,\n                \"name\": \"Hershey_SS_CasualCelebrators\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"s2_2\"\n                            ],\n                            \"question\": \"s2\"\n                        },\n                        {\n                            \"options\": [\n                                \"q4_4\",\n                                \"q4_5\"\n                            ],\n                            \"question\": \"q4\"\n                        },\n                        {\n                            \"options\": [\n                                \"q13newca_6\",\n                                \"q13newca_7\",\n                                \"q13newca_8\"\n                            ],\n                            \"question\": \"q13newca\"\n                        },\n                        {\n                            \"options\": [\n                                \"q2_2\",\n                                \"q2_1\"\n                            ],\n                            \"question\": \"q2\"\n                        },\n                        {\n                            \"options\": [\n                                \"q8_4\",\n                                \"q8_3\",\n                                \"q8_1\",\n                                \"q8_2\"\n                            ],\n                            \"question\": \"q8\"\n                        },\n                        {\n                            \"options\": [\n                                \"q2021a_2\",\n                                \"q2021a_6\",\n                                \"q2021a_41\"\n                            ],\n                            \"question\": \"q2021a\"\n                        },\n                        {\n                            \"options\": [\n                                \"q94new_27\"\n                            ],\n                            \"question\": \"q94new\"\n                        }\n                    ]\n                },\n                \"curated\": false,\n                \"type\": \"shared\",\n                \"shared\": true,\n                \"category\": null,\n                \"folder\": null\n            },\n            {\n                \"id\": 70335,\n                \"name\": \"ios + ford / chevrolet / Audi\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"or\": [\n                                {\n                                    \"options\": [\n                                        \"q126h_1\"\n                                    ],\n                                    \"question\": \"q126h\"\n                                },\n                                {\n                                    \"options\": [\n                                        \"q126j_3\"\n                                    ],\n                                    \"question\": \"q126j\"\n                                }\n                            ]\n                        },\n                        {\n                            \"options\": [\n                                \"q306a_14\",\n                                \"q306a_5\",\n                                \"q306a_8\"\n                            ],\n                            \"question\": \"q306a\",\n                            \"suffixes\": [\n                                1,\n                                2,\n                                3,\n                                4\n                            ]\n                        }\n                    ]\n                },\n                \"curated\": null,\n                \"type\": \"user\",\n                \"shared\": false,\n                \"category\": null,\n                \"folder\": null\n            },\n            {\n                \"id\": 80899,\n                \"name\": \"android\",\n                \"expression\": {\n                    \"and\": []\n                },\n                \"curated\": null,\n                \"type\": \"user\",\n                \"shared\": false,\n                \"category\": null,\n                \"folder\": null\n            },\n            {\n                \"id\": 85462,\n                \"name\": \"4G Mobile Users copy\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q39c_1\"\n                            ],\n                            \"question\": \"q39c\"\n                        }\n                    ]\n                },\n                \"curated\": null,\n                \"type\": \"user\",\n                \"shared\": false,\n                \"category\": null,\n                \"folder\": null\n            },\n            {\n                \"id\": 32354,\n                \"name\": \"Premier League Fans\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q4142_6\"\n                            ],\n                            \"question\": \"q4142\",\n                            \"suffixes\": [\n                                3,\n                                2\n                            ]\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 84063,\n                \"name\": \"TV Buyers\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q91el_5\"\n                            ],\n                            \"question\": \"q91el\",\n                            \"suffixes\": [\n                                4\n                            ]\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 84064,\n                \"name\": \"Vacationers\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q311_1\",\n                                \"q311_2\",\n                                \"q311_3\",\n                                \"q311_4\"\n                            ],\n                            \"question\": \"q311\",\n                            \"suffixes\": [\n                                2\n                            ]\n                        }\n                    ]\n                },\n                \"curated\": true,\n                \"type\": \"curated\",\n                \"shared\": false,\n                \"category\": \"Audiences\",\n                \"folder\": 383\n            },\n            {\n                \"id\": 76232,\n                \"name\": \"Tesla Campaign - UK tech or ecofriendly Parents and expecting with high income \",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"or\": [\n                                {\n                                    \"options\": [\n                                        \"q8_2\",\n                                        \"q8_3\",\n                                        \"q8_4\"\n                                    ],\n                                    \"question\": \"q8\"\n                                },\n                                {\n                                    \"options\": [\n                                        \"q31512_1\"\n                                    ],\n                                    \"question\": \"q31512\"\n                                }\n                            ]\n                        },\n                        {\n                            \"or\": [\n                                {\n                                    \"options\": [\n                                        \"q13newuk_13\",\n                                        \"q13newuk_14\"\n                                    ],\n                                    \"question\": \"q13newuk\"\n                                },\n                                {\n                                    \"options\": [\n                                        \"i1_3\"\n                                    ],\n                                    \"question\": \"i1\"\n                                }\n                            ]\n                        },\n                        {\n                            \"or\": [\n                                {\n                                    \"options\": [\n                                        \"r2021e_3\"\n                                    ],\n                                    \"question\": \"r2021e\"\n                                },\n                                {\n                                    \"options\": [\n                                        \"q2021a_48\"\n                                    ],\n                                    \"question\": \"q2021a\"\n                                }\n                            ]\n                        },\n                        {\n                            \"or\": [\n                                {\n                                    \"options\": [\n                                        \"r2021e_38\"\n                                    ],\n                                    \"question\": \"r2021e\"\n                                },\n                                {\n                                    \"options\": [\n                                        \"r2021e_46\"\n                                    ],\n                                    \"question\": \"r2021e\"\n                                }\n                            ]\n                        },\n                        {\n                            \"options\": [\n                                \"r8_1\"\n                            ],\n                            \"question\": \"r8\"\n                        }\n                    ]\n                },\n                \"curated\": null,\n                \"type\": \"shared\",\n                \"shared\": true,\n                \"category\": null,\n                \"folder\": null\n            },\n            {\n                \"id\": 30256,\n                \"name\": \"16-24 travellers\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q4_2\"\n                            ],\n                            \"question\": \"q4\"\n                        },\n                        {\n                            \"and\": [\n                                {\n                                    \"options\": [\n                                        \"q2_1\"\n                                    ],\n                                    \"question\": \"q2\"\n                                },\n                                {\n                                    \"or\": [\n                                        {\n                                            \"options\": [\n                                                \"q126a2co_968\",\n                                                \"q126a2co_1023\",\n                                                \"q126a2co_982\"\n                                            ],\n                                            \"question\": \"q126a2co\"\n                                        },\n                                        {\n                                            \"options\": [\n                                                \"q311_3\",\n                                                \"q311_2\",\n                                                \"q311_1\"\n                                            ],\n                                            \"question\": \"q311\",\n                                            \"suffixes\": [\n                                                1,\n                                                2,\n                                                3\n                                            ],\n                                            \"not\": true\n                                        }\n                                    ]\n                                }\n                            ]\n                        }\n                    ]\n                },\n                \"curated\": null,\n                \"type\": \"shared\",\n                \"shared\": true,\n                \"category\": null,\n                \"folder\": null\n            },\n            {\n                \"id\": 80898,\n                \"name\": \"tripomatic users maybe\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q126h_2\",\n                                \"q126h_1\",\n                                \"q126h_3\"\n                            ],\n                            \"question\": \"q126h\"\n                        },\n                        {\n                            \"or\": [\n                                {\n                                    \"options\": [\n                                        \"q94newtr_31\"\n                                    ],\n                                    \"question\": \"q94newtr\"\n                                },\n                                {\n                                    \"options\": [\n                                        \"q126d2_7\"\n                                    ],\n                                    \"question\": \"q126d2\"\n                                },\n                                {\n                                    \"options\": [\n                                        \"q4154m_16\"\n                                    ],\n                                    \"question\": \"q4154m\"\n                                },\n                                {\n                                    \"options\": [\n                                        \"q91tr_15\",\n                                        \"q91tr_14\"\n                                    ],\n                                    \"question\": \"q91tr\",\n                                    \"suffixes\": [\n                                        1,\n                                        2,\n                                        3,\n                                        4\n                                    ]\n                                }\n                            ]\n                        }\n                    ]\n                },\n                \"curated\": null,\n                \"type\": \"user\",\n                \"shared\": false,\n                \"category\": null,\n                \"folder\": null\n            },\n            {\n                \"id\": 80900,\n                \"name\": \"ios\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q126h_1\"\n                            ],\n                            \"question\": \"q126h\"\n                        }\n                    ]\n                },\n                \"curated\": null,\n                \"type\": \"user\",\n                \"shared\": false,\n                \"category\": null,\n                \"folder\": null\n            },\n            {\n                \"id\": 85882,\n                \"name\": \"Premier League (Watch TV OR ONLINE) Female\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q4142_6\"\n                            ],\n                            \"question\": \"q4142\",\n                            \"suffixes\": [\n                                2,\n                                3\n                            ]\n                        },\n                        {\n                            \"options\": [\n                                \"q2_2\"\n                            ],\n                            \"question\": \"q2\"\n                        }\n                    ]\n                },\n                \"curated\": null,\n                \"type\": \"shared\",\n                \"shared\": true,\n                \"category\": null,\n                \"folder\": null\n            },\n            {\n                \"id\": 76588,\n                \"name\": \"Top 1% copy\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q4dar_7\"\n                            ],\n                            \"question\": \"q4dar\"\n                        },\n                        {\n                            \"options\": [\n                                \"q4dau_7\"\n                            ],\n                            \"question\": \"q4dau\"\n                        },\n                        {\n                            \"options\": [\n                                \"q1d_2\",\n                                \"q1d_4\",\n                                \"q1d_3\"\n                            ],\n                            \"question\": \"q1d\",\n                            \"suffixes\": [\n                                1\n                            ]\n                        }\n                    ]\n                },\n                \"curated\": null,\n                \"type\": \"user\",\n                \"shared\": false,\n                \"category\": null,\n                \"folder\": null\n            },\n            {\n                \"id\": 85884,\n                \"name\": \"Premier League (Watch TV OR ONLINE) 25-34\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q4142_6\"\n                            ],\n                            \"question\": \"q4142\",\n                            \"suffixes\": [\n                                2,\n                                3\n                            ]\n                        },\n                        {\n                            \"options\": [\n                                \"q4_3\"\n                            ],\n                            \"question\": \"q4\"\n                        }\n                    ]\n                },\n                \"curated\": null,\n                \"type\": \"shared\",\n                \"shared\": true,\n                \"category\": null,\n                \"folder\": null\n            },\n            {\n                \"id\": 85893,\n                \"name\": \"Premier League (Watch TV OR ONLINE) B2B IT Buyers\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q4142_6\"\n                            ],\n                            \"question\": \"q4142\",\n                            \"suffixes\": [\n                                2,\n                                3\n                            ]\n                        },\n                        {\n                            \"options\": [\n                                \"q17_4\"\n                            ],\n                            \"question\": \"q17\"\n                        },\n                        {\n                            \"options\": [\n                                \"q18_1\",\n                                \"q18_2\"\n                            ],\n                            \"question\": \"q18\"\n                        }\n                    ]\n                },\n                \"curated\": null,\n                \"type\": \"shared\",\n                \"shared\": true,\n                \"category\": null,\n                \"folder\": null\n            },\n            {\n                \"id\": 91107,\n                \"name\": \"filter\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q2_1\",\n                                \"q2_2\"\n                            ],\n                            \"question\": \"q2\"\n                        }\n                    ]\n                },\n                \"curated\": null,\n                \"type\": \"user\",\n                \"shared\": false,\n                \"category\": null,\n                \"folder\": null\n            },\n            {\n                \"id\": 83677,\n                \"name\": \"Snapchat users (training) and travel\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"r52alls_1006\"\n                            ],\n                            \"question\": \"r52alls\"\n                        },\n                        {\n                            \"or\": [\n                                {\n                                    \"options\": [\n                                        \"q25_5\"\n                                    ],\n                                    \"question\": \"q25\"\n                                },\n                                {\n                                    \"options\": [\n                                        \"q311_1\",\n                                        \"q311_2\",\n                                        \"q311_3\",\n                                        \"q311_4\"\n                                    ],\n                                    \"question\": \"q311\",\n                                    \"suffixes\": [\n                                        2,\n                                        1\n                                    ]\n                                }\n                            ]\n                        }\n                    ]\n                },\n                \"curated\": null,\n                \"type\": \"shared\",\n                \"shared\": true,\n                \"category\": null,\n                \"folder\": null\n            },\n            {\n                \"id\": 85885,\n                \"name\": \"Premier League (Watch TV OR ONLINE) 35-44\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q4142_6\"\n                            ],\n                            \"question\": \"q4142\",\n                            \"suffixes\": [\n                                2,\n                                3\n                            ]\n                        },\n                        {\n                            \"options\": [\n                                \"q4_4\"\n                            ],\n                            \"question\": \"q4\"\n                        }\n                    ]\n                },\n                \"curated\": null,\n                \"type\": \"shared\",\n                \"shared\": true,\n                \"category\": null,\n                \"folder\": null\n            },\n            {\n                \"id\": 85883,\n                \"name\": \"Premier League (Watch TV OR ONLINE) 16-24\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q4142_6\"\n                            ],\n                            \"question\": \"q4142\",\n                            \"suffixes\": [\n                                2,\n                                3\n                            ]\n                        },\n                        {\n                            \"options\": [\n                                \"q4_2\"\n                            ],\n                            \"question\": \"q4\"\n                        }\n                    ]\n                },\n                \"curated\": null,\n                \"type\": \"shared\",\n                \"shared\": true,\n                \"category\": null,\n                \"folder\": null\n            },\n            {\n                \"id\": 85880,\n                \"name\": \"Premier League (Watch TV OR ONLINE) Male\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q4142_6\"\n                            ],\n                            \"question\": \"q4142\",\n                            \"suffixes\": [\n                                2,\n                                3\n                            ]\n                        },\n                        {\n                            \"options\": [\n                                \"q2_1\"\n                            ],\n                            \"question\": \"q2\"\n                        }\n                    ]\n                },\n                \"curated\": null,\n                \"type\": \"shared\",\n                \"shared\": true,\n                \"category\": null,\n                \"folder\": null\n            },\n            {\n                \"id\": 81598,\n                \"name\": \"APAC Social networking Mums with children ages 0-11 \",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q2_2\"\n                            ],\n                            \"question\": \"q2\"\n                        },\n                        {\n                            \"options\": [\n                                \"q8_2\",\n                                \"q8_4\",\n                                \"q8_3\"\n                            ],\n                            \"question\": \"q8\"\n                        },\n                        {\n                            \"options\": [\n                                \"q9_3\",\n                                \"q9_2\",\n                                \"q9_1\"\n                            ],\n                            \"question\": \"q9\"\n                        },\n                        {\n                            \"options\": [\n                                \"q27lj_1\"\n                            ],\n                            \"question\": \"q27lj\"\n                        },\n                        {\n                            \"options\": [\n                                \"s2_86\",\n                                \"s2_852\",\n                                \"s2_65\",\n                                \"s2_886\",\n                                \"s2_66\",\n                                \"s2_82\"\n                            ],\n                            \"question\": \"s2\"\n                        }\n                    ]\n                },\n                \"curated\": null,\n                \"type\": \"shared\",\n                \"shared\": true,\n                \"category\": null,\n                \"folder\": null\n            },\n            {\n                \"id\": 85887,\n                \"name\": \"Premier League (Watch TV OR ONLINE) 45-54\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q4142_6\"\n                            ],\n                            \"question\": \"q4142\",\n                            \"suffixes\": [\n                                2,\n                                3\n                            ]\n                        },\n                        {\n                            \"options\": [\n                                \"q4_5\"\n                            ],\n                            \"question\": \"q4\"\n                        }\n                    ]\n                },\n                \"curated\": null,\n                \"type\": \"shared\",\n                \"shared\": true,\n                \"category\": null,\n                \"folder\": null\n            },\n            {\n                \"id\": 82272,\n                \"name\": \"Mothers Gen X\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q8_2\",\n                                \"q8_4\",\n                                \"q8_3\"\n                            ],\n                            \"question\": \"q8\"\n                        },\n                        {\n                            \"options\": [\n                                \"q4_4\",\n                                \"q4_5\",\n                                \"q4_6\"\n                            ],\n                            \"question\": \"q4\"\n                        }\n                    ]\n                },\n                \"curated\": null,\n                \"type\": \"shared\",\n                \"shared\": true,\n                \"category\": null,\n                \"folder\": null\n            },\n            {\n                \"id\": 83800,\n                \"name\": \"Millennials Mums\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q2_2\"\n                            ],\n                            \"question\": \"q2\"\n                        },\n                        {\n                            \"or\": [\n                                {\n                                    \"options\": [\n                                        \"q3_35\"\n                                    ],\n                                    \"question\": \"q3\"\n                                },\n                                {\n                                    \"options\": [\n                                        \"q4_3\"\n                                    ],\n                                    \"question\": \"q4\"\n                                }\n                            ]\n                        },\n                        {\n                            \"options\": [\n                                \"q11_1\"\n                            ],\n                            \"question\": \"q11\"\n                        },\n                        {\n                            \"options\": [\n                                \"q6_4\"\n                            ],\n                            \"question\": \"q6\"\n                        },\n                        {\n                            \"or\": [\n                                {\n                                    \"options\": [\n                                        \"q31512_1\"\n                                    ],\n                                    \"question\": \"q31512\"\n                                },\n                                {\n                                    \"options\": [\n                                        \"q8_2\",\n                                        \"q8_3\",\n                                        \"q8_4\"\n                                    ],\n                                    \"question\": \"q8\"\n                                }\n                            ]\n                        }\n                    ]\n                },\n                \"curated\": false,\n                \"type\": \"shared\",\n                \"shared\": true,\n                \"category\": null,\n                \"folder\": null\n            },\n            {\n                \"id\": 85890,\n                \"name\": \"Premier League (Watch TV OR ONLINE) B2B Buyers\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q4142_6\"\n                            ],\n                            \"question\": \"q4142\",\n                            \"suffixes\": [\n                                2,\n                                3\n                            ]\n                        },\n                        {\n                            \"options\": [\n                                \"q17_5\",\n                                \"q17_4\"\n                            ],\n                            \"question\": \"q17\"\n                        },\n                        {\n                            \"options\": [\n                                \"q18_1\",\n                                \"q18_2\"\n                            ],\n                            \"question\": \"q18\"\n                        }\n                    ]\n                },\n                \"curated\": null,\n                \"type\": \"shared\",\n                \"shared\": true,\n                \"category\": null,\n                \"folder\": null\n            },\n            {\n                \"id\": 89182,\n                \"name\": \"Facebook Vlogger Fans (APAC)\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q48_13\"\n                            ],\n                            \"question\": \"q48\"\n                        },\n                        {\n                            \"options\": [\n                                \"q46x2_1\"\n                            ],\n                            \"question\": \"q46x2\"\n                        },\n                        {\n                            \"options\": [\n                                \"s6_4\"\n                            ],\n                            \"question\": \"s6\"\n                        }\n                    ]\n                },\n                \"curated\": null,\n                \"type\": \"shared\",\n                \"shared\": true,\n                \"category\": null,\n                \"folder\": null\n            },\n            {\n                \"id\": 89214,\n                \"name\": \"All things hair\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q7_1\",\n                                \"q7_2\",\n                                \"q7_3\",\n                                \"q7_4\"\n                            ],\n                            \"question\": \"gwi-160815.q7\"\n                        }\n                    ]\n                },\n                \"curated\": null,\n                \"type\": \"user\",\n                \"shared\": false,\n                \"category\": null,\n                \"folder\": null\n            },\n            {\n                \"id\": 88145,\n                \"name\": \"High achiever\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q2021a_5\",\n                                \"q2021a_8\",\n                                \"q2021a_16\",\n                                \"q2021a_68\",\n                                \"q2021a_53\"\n                            ],\n                            \"question\": \"q2021a\"\n                        }\n                    ]\n                },\n                \"curated\": null,\n                \"type\": \"shared\",\n                \"shared\": true,\n                \"category\": null,\n                \"folder\": null\n            },\n            {\n                \"id\": 87906,\n                \"name\": \"Top 25% - business travel or interest\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"i1_3\",\n                                \"i1_4\"\n                            ],\n                            \"question\": \"i1\"\n                        },\n                        {\n                            \"or\": [\n                                {\n                                    \"options\": [\n                                        \"q25_10\",\n                                        \"q25_21\",\n                                        \"q25_11\",\n                                        \"q25_36\"\n                                    ],\n                                    \"question\": \"q25\"\n                                },\n                                {\n                                    \"options\": [\n                                        \"q311_2\"\n                                    ],\n                                    \"question\": \"q311\",\n                                    \"suffixes\": [\n                                        3\n                                    ]\n                                }\n                            ]\n                        }\n                    ]\n                },\n                \"curated\": false,\n                \"type\": \"shared\",\n                \"shared\": true,\n                \"category\": null,\n                \"folder\": null\n            },\n            {\n                \"id\": 91958,\n                \"name\": \"Mothers Main Food Shoppers\",\n                \"expression\": {\n                    \"and\": [\n                        {\n                            \"options\": [\n                                \"q8_2\",\n                                \"q8_3\",\n                                \"q8_4\"\n                            ],\n                            \"question\": \"q8\"\n                        },\n                        {\n                            \"options\": [\n                                \"q12b_1\"\n                            ],\n                            \"question\": \"q12b\"\n                        }\n                    ]\n                },\n                \"curated\": null,\n                \"type\": \"shared\",\n                \"shared\": true,\n                \"category\": null,\n                \"folder\": null\n            }\n        ]\n    }\n    ';
var _user$project$Data_Audience$Audience = F4(
	function (a, b, c, d) {
		return {id: a, name: b, type$: c, folder: d};
	});
var _user$project$Data_Audience$Curated = {ctor: 'Curated'};
var _user$project$Data_Audience$Shared = {ctor: 'Shared'};
var _user$project$Data_Audience$Authored = {ctor: 'Authored'};

var _user$project$Data_Json_Audience$audienceTypeDecoder = function () {
	var typeBuilder = function (tag) {
		var _p0 = tag;
		switch (_p0) {
			case 'curated':
				return _elm_lang$core$Json_Decode$succeed(_user$project$Data_Audience$Curated);
			case 'shared':
				return _elm_lang$core$Json_Decode$succeed(_user$project$Data_Audience$Shared);
			case 'user':
				return _elm_lang$core$Json_Decode$succeed(_user$project$Data_Audience$Authored);
			default:
				return _elm_lang$core$Json_Decode$fail(
					A2(_elm_lang$core$Basics_ops['++'], 'Invalid type: ', tag));
		}
	};
	return A2(_elm_lang$core$Json_Decode$andThen, _elm_lang$core$Json_Decode$string, typeBuilder);
}();
var _user$project$Data_Json_Audience$audienceDecoder = A5(
	_elm_lang$core$Json_Decode$object4,
	_user$project$Data_Audience$Audience,
	A2(_elm_lang$core$Json_Decode_ops[':='], 'id', _elm_lang$core$Json_Decode$int),
	A2(_elm_lang$core$Json_Decode_ops[':='], 'name', _elm_lang$core$Json_Decode$string),
	A2(_elm_lang$core$Json_Decode_ops[':='], 'type', _user$project$Data_Json_Audience$audienceTypeDecoder),
	A2(_elm_lang$core$Json_Decode_ops[':='], 'folder', _user$project$Data_Json_Utils$ref));

var _user$project$Data_AudienceFolder$audienceFoldersJSON = '\n    {\n        \"data\": [\n            {\n                \"id\": 357,\n                \"name\": \"Demographics\",\n                \"curated\": true,\n                \"parent\": null\n            },\n            {\n                \"id\": 358,\n                \"name\": \"Marketing Personas\",\n                \"curated\": true,\n                \"parent\": null\n            },\n            {\n                \"id\": 383,\n                \"name\": \"Reports\",\n                \"curated\": true,\n                \"parent\": null\n            },\n            {\n                \"id\": 3110,\n                \"name\": \"New Group\",\n                \"curated\": false,\n                \"parent\": null\n            },\n            {\n                \"id\": 3111,\n                \"name\": \"New Group 2\",\n                \"curated\": false,\n                \"parent\": 3110\n            }\n        ]\n    }\n    ';
var _user$project$Data_AudienceFolder$AudienceFolder = F3(
	function (a, b, c) {
		return {id: a, name: b, parent: c};
	});

var _user$project$Data_Json_AudienceFolder$audienceFolderDecoder = A4(
	_elm_lang$core$Json_Decode$object3,
	_user$project$Data_AudienceFolder$AudienceFolder,
	A2(_elm_lang$core$Json_Decode_ops[':='], 'id', _elm_lang$core$Json_Decode$int),
	A2(_elm_lang$core$Json_Decode_ops[':='], 'name', _elm_lang$core$Json_Decode$string),
	A2(_elm_lang$core$Json_Decode_ops[':='], 'parent', _user$project$Data_Json_Utils$ref));

var _user$project$Data_Api_Endpoints$audience_folders = A2(
	_elm_lang$core$Json_Decode$decodeString,
	A2(
		_elm_lang$core$Json_Decode_ops[':='],
		'data',
		_elm_lang$core$Json_Decode$list(_user$project$Data_Json_AudienceFolder$audienceFolderDecoder)),
	_user$project$Data_AudienceFolder$audienceFoldersJSON);
var _user$project$Data_Api_Endpoints$audiences = A2(
	_elm_lang$core$Json_Decode$decodeString,
	A2(
		_elm_lang$core$Json_Decode_ops[':='],
		'data',
		_elm_lang$core$Json_Decode$list(_user$project$Data_Json_Audience$audienceDecoder)),
	_user$project$Data_Audience$audiencesJSON);

var _user$project$Hierarchy$nodeCompare = F2(
	function (a, b) {
		var _p0 = {ctor: '_Tuple2', _0: a, _1: b};
		if (_p0._0.ctor === 'File') {
			if (_p0._1.ctor === 'File') {
				return A2(_elm_lang$core$Basics$compare, _p0._0._0.name, _p0._1._0.name);
			} else {
				return _elm_lang$core$Basics$GT;
			}
		} else {
			if (_p0._1.ctor === 'Folder') {
				return A2(_elm_lang$core$Basics$compare, _p0._0._1.name, _p0._1._1.name);
			} else {
				return _elm_lang$core$Basics$LT;
			}
		}
	});
var _user$project$Hierarchy$addChild = F2(
	function (id, maybeList) {
		return A2(
			_elm_community$maybe_extra$Maybe_Extra$orElseLazy,
			function (_p1) {
				return _elm_lang$core$Maybe$Just(
					_elm_lang$core$Native_List.fromArray(
						[id]));
			},
			A2(
				_elm_lang$core$Maybe$map,
				F2(
					function (x, y) {
						return A2(_elm_lang$core$List_ops['::'], x, y);
					})(id),
				maybeList));
	});
var _user$project$Hierarchy$currentNodes = function (_p2) {
	var _p3 = _p2;
	var _p5 = _p3._0;
	var _p4 = _p5.breadcrumb;
	if (_p4.ctor === '[]') {
		return A2(
			_elm_lang$core$Result$fromMaybe,
			'Currupted root nodes: some nodes registered as root node do not exist',
			A2(
				_elm_lang$core$Maybe$map,
				_elm_lang$core$List$sortWith(_user$project$Hierarchy$nodeCompare),
				_elm_community$maybe_extra$Maybe_Extra$combine(
					A2(
						_elm_lang$core$List$map,
						A2(_elm_lang$core$Basics$flip, _elm_lang$core$Dict$get, _p5.nodeDB),
						_p5.rootNodes))));
	} else {
		return A2(
			_elm_lang$core$Maybe$withDefault,
			_elm_lang$core$Result$Err('Corrupted breadcrumb: current node does not exist'),
			A2(
				_elm_lang$core$Maybe$map,
				_elm_lang$core$Result$fromMaybe('Currupted child index: contains inexistant nodes'),
				A2(
					_elm_lang$core$Maybe$map,
					_elm_lang$core$Maybe$map(
						_elm_lang$core$List$sortWith(_user$project$Hierarchy$nodeCompare)),
					A2(
						_elm_lang$core$Maybe$map,
						_elm_community$maybe_extra$Maybe_Extra$combine,
						A2(
							_elm_lang$core$Maybe$map,
							_elm_lang$core$List$map(
								A2(_elm_lang$core$Basics$flip, _elm_lang$core$Dict$get, _p5.nodeDB)),
							A2(_elm_lang$core$Dict$get, _p4._0, _p5.childIndex))))));
	}
};
var _user$project$Hierarchy$currentPath = function (_p6) {
	var _p7 = _p6;
	var _p8 = _p7._0;
	return A2(
		_elm_lang$core$Result$fromMaybe,
		'Corrupted breadcrumb: some visited node does not exist',
		_elm_community$maybe_extra$Maybe_Extra$combine(
			A2(
				_elm_lang$core$List$map,
				A2(_elm_lang$core$Basics$flip, _elm_lang$core$Dict$get, _p8.nodeDB),
				_p8.breadcrumb)));
};
var _user$project$Hierarchy$File = function (a) {
	return {ctor: 'File', _0: a};
};
var _user$project$Hierarchy$Folder = F2(
	function (a, b) {
		return {ctor: 'Folder', _0: a, _1: b};
	});
var _user$project$Hierarchy$incrementCounts = F2(
	function (id, nodeDB) {
		var updateFolderCount = function (mf) {
			var _p9 = mf;
			if (_p9.ctor === 'Nothing') {
				return mf;
			} else {
				if (_p9._0.ctor === 'Folder') {
					return _elm_lang$core$Maybe$Just(
						A2(_user$project$Hierarchy$Folder, _p9._0._0 + 1, _p9._0._1));
				} else {
					return _elm_lang$core$Native_Utils.crashCase(
						'Hierarchy',
						{
							start: {line: 237, column: 13},
							end: {line: 246, column: 81}
						},
						_p9)('uh, somebody claimed to be the child of a file');
				}
			}
		};
		return A3(_elm_lang$core$Dict$update, id, updateFolderCount, nodeDB);
	});
var _user$project$Hierarchy$Hierarchy = function (a) {
	return {ctor: 'Hierarchy', _0: a};
};
var _user$project$Hierarchy$empty = _user$project$Hierarchy$Hierarchy(
	{
		breadcrumb: _elm_lang$core$Native_List.fromArray(
			[]),
		rootNodes: _elm_lang$core$Native_List.fromArray(
			[]),
		childIndex: _elm_lang$core$Dict$empty,
		nodeDB: _elm_lang$core$Dict$empty
	});
var _user$project$Hierarchy$goup = F2(
	function (levels, _p11) {
		goup:
		while (true) {
			var _p12 = _p11;
			var _p14 = _p12._0;
			var _p13 = _p14.breadcrumb;
			if (_p13.ctor === '[]') {
				return _user$project$Hierarchy$Hierarchy(_p14);
			} else {
				if (_elm_lang$core$Native_Utils.cmp(levels, 0) < 1) {
					return _user$project$Hierarchy$Hierarchy(_p14);
				} else {
					var _v7 = levels - 1,
						_v8 = _user$project$Hierarchy$Hierarchy(
						_elm_lang$core$Native_Utils.update(
							_p14,
							{breadcrumb: _p13._1}));
					levels = _v7;
					_p11 = _v8;
					continue goup;
				}
			}
		}
	});
var _user$project$Hierarchy$godown = F2(
	function (id, _p15) {
		var _p16 = _p15;
		var _p19 = _p16._0;
		var _p17 = _p19.breadcrumb;
		if (_p17.ctor === '[]') {
			return A2(_elm_lang$core$List$member, id, _p19.rootNodes) ? _elm_lang$core$Result$Ok(
				_user$project$Hierarchy$Hierarchy(
					_elm_lang$core$Native_Utils.update(
						_p19,
						{
							breadcrumb: A2(_elm_lang$core$List_ops['::'], id, _p19.breadcrumb)
						}))) : _elm_lang$core$Result$Err(
				A2(
					_elm_lang$core$Basics_ops['++'],
					'Unknown root node with ID ',
					_elm_lang$core$Basics$toString(id)));
		} else {
			var _p18 = _p17._0;
			var okOrUnknownChild = function (known) {
				return known ? _elm_lang$core$Result$Ok(
					_user$project$Hierarchy$Hierarchy(
						_elm_lang$core$Native_Utils.update(
							_p19,
							{
								breadcrumb: A2(_elm_lang$core$List_ops['::'], id, _p19.breadcrumb)
							}))) : _elm_lang$core$Result$Err(
					A2(
						_elm_lang$core$Basics_ops['++'],
						'Node with ID ',
						A2(
							_elm_lang$core$Basics_ops['++'],
							_elm_lang$core$Basics$toString(_p18),
							A2(
								_elm_lang$core$Basics_ops['++'],
								' has no child with ID ',
								_elm_lang$core$Basics$toString(id)))));
			};
			return A2(
				_elm_lang$core$Maybe$withDefault,
				_elm_lang$core$Result$Err('Corrupted breadcrumb: current node does not exist'),
				A2(
					_elm_lang$core$Maybe$map,
					okOrUnknownChild,
					A2(
						_elm_lang$core$Maybe$map,
						_elm_lang$core$List$member(id),
						A2(_elm_lang$core$Dict$get, _p18, _p19.childIndex))));
		}
	});
var _user$project$Hierarchy$registerFolder = F2(
	function (folder, _p20) {
		var _p21 = _p20;
		var _p25 = _p21._0;
		if (A2(_elm_lang$core$Dict$member, folder.id, _p25.nodeDB)) {
			return _elm_lang$core$Result$Err(
				A2(
					_elm_lang$core$Basics_ops['++'],
					'Node with ID ',
					A2(
						_elm_lang$core$Basics_ops['++'],
						_elm_lang$core$Basics$toString(folder.id),
						' has already been added')));
		} else {
			var currentCount = A2(
				_elm_lang$core$Maybe$withDefault,
				0,
				A2(
					_elm_lang$core$Maybe$map,
					_elm_lang$core$List$length,
					A2(_elm_lang$core$Dict$get, folder.id, _p25.childIndex)));
			var nodeDBWithFolder = A3(
				_elm_lang$core$Dict$insert,
				folder.id,
				A2(_user$project$Hierarchy$Folder, currentCount, folder),
				_p25.nodeDB);
			var childIndexWithFolder = _elm_lang$core$Native_Utils.eq(currentCount, 0) ? A3(
				_elm_lang$core$Dict$insert,
				folder.id,
				_elm_lang$core$Native_List.fromArray(
					[]),
				_p25.childIndex) : _p25.childIndex;
			var _p22 = function () {
				var _p23 = folder.parent;
				if (_p23.ctor === 'Nothing') {
					return {
						ctor: '_Tuple3',
						_0: A2(_elm_lang$core$List_ops['::'], folder.id, _p25.rootNodes),
						_1: childIndexWithFolder,
						_2: nodeDBWithFolder
					};
				} else {
					var _p24 = _p23._0;
					return {
						ctor: '_Tuple3',
						_0: _p25.rootNodes,
						_1: A3(
							_elm_lang$core$Dict$update,
							_p24,
							_user$project$Hierarchy$addChild(folder.id),
							childIndexWithFolder),
						_2: A2(_user$project$Hierarchy$incrementCounts, _p24, nodeDBWithFolder)
					};
				}
			}();
			var newRootNodes = _p22._0;
			var newChildIndex = _p22._1;
			var newNodeDB = _p22._2;
			return _elm_lang$core$Result$Ok(
				_user$project$Hierarchy$Hierarchy(
					_elm_lang$core$Native_Utils.update(
						_p25,
						{nodeDB: newNodeDB, childIndex: newChildIndex, rootNodes: newRootNodes})));
		}
	});
var _user$project$Hierarchy$registerFile = F2(
	function (file, _p26) {
		var _p27 = _p26;
		var _p31 = _p27._0;
		if (A2(_elm_lang$core$Dict$member, file.id, _p31.nodeDB)) {
			return _elm_lang$core$Result$Err(
				A2(
					_elm_lang$core$Basics_ops['++'],
					'Node with ID ',
					A2(
						_elm_lang$core$Basics_ops['++'],
						_elm_lang$core$Basics$toString(file.id),
						' has already been added')));
		} else {
			var nodeDBWithFile = A3(
				_elm_lang$core$Dict$insert,
				file.id,
				_user$project$Hierarchy$File(file),
				_p31.nodeDB);
			var _p28 = function () {
				var _p29 = file.folder;
				if (_p29.ctor === 'Nothing') {
					return {
						ctor: '_Tuple3',
						_0: A2(_elm_lang$core$List_ops['::'], file.id, _p31.rootNodes),
						_1: _p31.childIndex,
						_2: nodeDBWithFile
					};
				} else {
					var _p30 = _p29._0;
					return {
						ctor: '_Tuple3',
						_0: _p31.rootNodes,
						_1: A3(
							_elm_lang$core$Dict$update,
							_p30,
							_user$project$Hierarchy$addChild(file.id),
							_p31.childIndex),
						_2: A2(_user$project$Hierarchy$incrementCounts, _p30, nodeDBWithFile)
					};
				}
			}();
			var newRootNodes = _p28._0;
			var newChildIndex = _p28._1;
			var newNodeDB = _p28._2;
			return _elm_lang$core$Result$Ok(
				_user$project$Hierarchy$Hierarchy(
					_elm_lang$core$Native_Utils.update(
						_p31,
						{nodeDB: newNodeDB, childIndex: newChildIndex, rootNodes: newRootNodes})));
		}
	});

var _user$project$Main$viewBreadcrumbItem = function (node) {
	var name = function () {
		var _p0 = node;
		if (_p0.ctor === 'File') {
			return _p0._0.name;
		} else {
			return _p0._1.name;
		}
	}();
	return A2(
		_elm_lang$html$Html$li,
		_elm_lang$core$Native_List.fromArray(
			[]),
		_elm_lang$core$Native_List.fromArray(
			[
				A2(
				_elm_lang$html$Html$a,
				_elm_lang$core$Native_List.fromArray(
					[
						_elm_lang$html$Html_Attributes$href('#')
					]),
				_elm_lang$core$Native_List.fromArray(
					[
						_elm_lang$html$Html$text(name)
					]))
			]));
};
var _user$project$Main$viewBreadcrumb = function (h) {
	var history = _user$project$Hierarchy$currentPath(h);
	var _p1 = history;
	if (_p1.ctor === 'Ok') {
		return A2(
			_elm_lang$html$Html$ol,
			_elm_lang$core$Native_List.fromArray(
				[
					_elm_lang$html$Html_Attributes$class('breadcrumb')
				]),
			A2(
				_elm_lang$core$List_ops['::'],
				A2(
					_elm_lang$html$Html$li,
					_elm_lang$core$Native_List.fromArray(
						[]),
					_elm_lang$core$Native_List.fromArray(
						[
							A2(
							_elm_lang$html$Html$a,
							_elm_lang$core$Native_List.fromArray(
								[
									_elm_lang$html$Html_Attributes$href('#')
								]),
							_elm_lang$core$Native_List.fromArray(
								[
									_elm_lang$html$Html$text('Root')
								]))
						])),
				A2(_elm_lang$core$List$map, _user$project$Main$viewBreadcrumbItem, _p1._0)));
	} else {
		return A2(
			_elm_lang$html$Html$div,
			_elm_lang$core$Native_List.fromArray(
				[
					_elm_lang$html$Html_Attributes$class('alert alert-info'),
					A2(_elm_lang$html$Html_Attributes$attribute, 'role', 'alert')
				]),
			_elm_lang$core$Native_List.fromArray(
				[
					_elm_lang$html$Html$text(_p1._0)
				]));
	}
};
var _user$project$Main$viewHierarchyInfo = F2(
	function (s, h) {
		return A2(
			_elm_lang$html$Html$div,
			_elm_lang$core$Native_List.fromArray(
				[
					_elm_lang$html$Html_Attributes$class('row')
				]),
			_elm_lang$core$Native_List.fromArray(
				[
					A2(
					_elm_lang$html$Html$div,
					_elm_lang$core$Native_List.fromArray(
						[
							_elm_lang$html$Html_Attributes$class('col-xs-12')
						]),
					_elm_lang$core$Native_List.fromArray(
						[
							_user$project$Main$viewBreadcrumb(h)
						])),
					A2(
					_elm_lang$html$Html$div,
					_elm_lang$core$Native_List.fromArray(
						[
							_elm_lang$html$Html_Attributes$class('col-xs-12')
						]),
					_elm_lang$core$Native_List.fromArray(
						[
							A2(
							_elm_lang$html$Html$h6,
							_elm_lang$core$Native_List.fromArray(
								[]),
							_elm_lang$core$Native_List.fromArray(
								[
									_elm_lang$html$Html$text('Selected Node')
								]))
						])),
					A2(
					_elm_lang$html$Html$div,
					_elm_lang$core$Native_List.fromArray(
						[
							_elm_lang$html$Html_Attributes$class('col-xs-12')
						]),
					_elm_lang$core$Native_List.fromArray(
						[
							A2(
							_elm_lang$html$Html$pre,
							_elm_lang$core$Native_List.fromArray(
								[]),
							_elm_lang$core$Native_List.fromArray(
								[
									_elm_lang$html$Html$text(
									_elm_lang$core$Basics$toString(s))
								]))
						])),
					A2(
					_elm_lang$html$Html$div,
					_elm_lang$core$Native_List.fromArray(
						[
							_elm_lang$html$Html_Attributes$class('col-xs-12')
						]),
					_elm_lang$core$Native_List.fromArray(
						[
							A2(
							_elm_lang$html$Html$h6,
							_elm_lang$core$Native_List.fromArray(
								[]),
							_elm_lang$core$Native_List.fromArray(
								[
									_elm_lang$html$Html$text('Current path')
								]))
						])),
					A2(
					_elm_lang$html$Html$div,
					_elm_lang$core$Native_List.fromArray(
						[
							_elm_lang$html$Html_Attributes$class('col-xs-12')
						]),
					_elm_lang$core$Native_List.fromArray(
						[
							A2(
							_elm_lang$html$Html$pre,
							_elm_lang$core$Native_List.fromArray(
								[]),
							_elm_lang$core$Native_List.fromArray(
								[
									_elm_lang$html$Html$text(
									_elm_lang$core$Basics$toString(
										_user$project$Hierarchy$currentPath(h)))
								]))
						]))
				]));
	});
var _user$project$Main$viewFolderEntry = F3(
	function (label, extraClasses, onPickMsg) {
		return A2(
			_elm_lang$html$Html$a,
			_elm_lang$core$Native_List.fromArray(
				[
					_elm_lang$html$Html_Attributes$href('#'),
					_elm_lang$html$Html_Attributes$class(
					A2(_elm_lang$core$Basics_ops['++'], 'folder ', extraClasses)),
					_elm_lang$html$Html_Events$onClick(onPickMsg)
				]),
			_elm_lang$core$Native_List.fromArray(
				[
					A2(
					_elm_lang$html$Html$div,
					_elm_lang$core$Native_List.fromArray(
						[
							_elm_lang$html$Html_Attributes$class('panel panel-default')
						]),
					_elm_lang$core$Native_List.fromArray(
						[
							A2(
							_elm_lang$html$Html$span,
							_elm_lang$core$Native_List.fromArray(
								[
									_elm_lang$html$Html_Attributes$class('glyphicon glyphicon-folder-close')
								]),
							_elm_lang$core$Native_List.fromArray(
								[])),
							_elm_lang$html$Html$text(label)
						]))
				]));
	});
var _user$project$Main$buildInitialHierarchy = function () {
	var buildHierarchy = F2(
		function (folders, audiences) {
			var withFolders = A3(
				_elm_lang$core$List$foldl,
				F2(
					function (a, b) {
						return A2(
							_elm_lang$core$Result$andThen,
							b,
							_user$project$Hierarchy$registerFolder(a));
					}),
				_elm_lang$core$Result$Ok(_user$project$Hierarchy$empty),
				folders);
			return A3(
				_elm_lang$core$List$foldl,
				F2(
					function (a, b) {
						return A2(
							_elm_lang$core$Result$andThen,
							b,
							_user$project$Hierarchy$registerFile(a));
					}),
				withFolders,
				audiences);
		});
	var audiences = _user$project$Data_Api_Endpoints$audiences;
	var folders = _user$project$Data_Api_Endpoints$audience_folders;
	return A2(
		_elm_lang$core$Result$andThen,
		folders,
		function (a) {
			return A2(
				_elm_lang$core$Result$andThen,
				audiences,
				function (b) {
					return A2(buildHierarchy, a, b);
				});
		});
}();
var _user$project$Main$Loaded = F2(
	function (a, b) {
		return {ctor: 'Loaded', _0: a, _1: b};
	});
var _user$project$Main$updateGoUp = F2(
	function (levels, model) {
		var _p2 = model;
		if (_p2.ctor === 'Error') {
			return model;
		} else {
			return A2(
				_user$project$Main$Loaded,
				_p2._0,
				A2(_user$project$Hierarchy$goup, levels, _p2._1));
		}
	});
var _user$project$Main$updateSelect = F2(
	function (node, model) {
		var _p3 = model;
		if (_p3.ctor === 'Error') {
			return model;
		} else {
			return A2(
				_user$project$Main$Loaded,
				_elm_lang$core$Maybe$Just(node),
				_p3._1);
		}
	});
var _user$project$Main$Error = function (a) {
	return {ctor: 'Error', _0: a};
};
var _user$project$Main$init = A3(
	_elm_community$result_extra$Result_Extra$unpack,
	_user$project$Main$Error,
	_user$project$Main$Loaded(_elm_lang$core$Maybe$Nothing),
	_user$project$Main$buildInitialHierarchy);
var _user$project$Main$updateGoDown = F2(
	function (id, model) {
		var _p4 = model;
		if (_p4.ctor === 'Error') {
			return model;
		} else {
			return A3(
				_elm_community$result_extra$Result_Extra$unpack,
				_user$project$Main$Error,
				_user$project$Main$Loaded(_p4._0),
				A2(_user$project$Hierarchy$godown, id, _p4._1));
		}
	});
var _user$project$Main$update = F2(
	function (msg, model) {
		var _p5 = msg;
		switch (_p5.ctor) {
			case 'GoDown':
				return A2(_user$project$Main$updateGoDown, _p5._0, model);
			case 'GoUp':
				return A2(_user$project$Main$updateGoUp, _p5._0, model);
			default:
				return A2(_user$project$Main$updateSelect, _p5._0, model);
		}
	});
var _user$project$Main$Select = function (a) {
	return {ctor: 'Select', _0: a};
};
var _user$project$Main$GoUp = function (a) {
	return {ctor: 'GoUp', _0: a};
};
var _user$project$Main$viewUp = A3(
	_user$project$Main$viewFolderEntry,
	'Go Up',
	'go-up',
	_user$project$Main$GoUp(1));
var _user$project$Main$GoDown = function (a) {
	return {ctor: 'GoDown', _0: a};
};
var _user$project$Main$viewNode = function (node) {
	var _p6 = node;
	if (_p6.ctor === 'File') {
		return A2(
			_elm_lang$html$Html$a,
			_elm_lang$core$Native_List.fromArray(
				[
					_elm_lang$html$Html_Attributes$href('#'),
					_elm_lang$html$Html_Attributes$class('audience'),
					_elm_lang$html$Html_Events$onClick(
					_user$project$Main$Select(node))
				]),
			_elm_lang$core$Native_List.fromArray(
				[
					A2(
					_elm_lang$html$Html$div,
					_elm_lang$core$Native_List.fromArray(
						[
							_elm_lang$html$Html_Attributes$class('panel panel-default')
						]),
					_elm_lang$core$Native_List.fromArray(
						[
							_elm_lang$html$Html$text(_p6._0.name)
						]))
				]));
	} else {
		var _p7 = _p6._1;
		return A3(
			_user$project$Main$viewFolderEntry,
			A2(
				_elm_lang$core$Basics_ops['++'],
				_p7.name,
				A2(
					_elm_lang$core$Basics_ops['++'],
					' (',
					A2(
						_elm_lang$core$Basics_ops['++'],
						_elm_lang$core$Basics$toString(_p6._0),
						')'))),
			'',
			_user$project$Main$GoDown(_p7.id));
	}
};
var _user$project$Main$viewCurrentNodes = function (h) {
	var hasUp = A2(
		_elm_lang$core$Result$withDefault,
		false,
		A2(
			_elm_lang$core$Result$map,
			A2(
				_elm_lang$core$Basics$flip,
				F2(
					function (x, y) {
						return _elm_lang$core$Native_Utils.cmp(x, y) > 0;
					}),
				0),
			A2(
				_elm_lang$core$Result$map,
				_elm_lang$core$List$length,
				_user$project$Hierarchy$currentPath(h))));
	var res = _user$project$Hierarchy$currentNodes(h);
	var _p8 = res;
	if (_p8.ctor === 'Ok') {
		var upEntry = hasUp ? _elm_lang$core$Native_List.fromArray(
			[_user$project$Main$viewUp]) : _elm_lang$core$Native_List.fromArray(
			[]);
		return A2(
			_elm_lang$core$List$append,
			upEntry,
			A2(_elm_lang$core$List$map, _user$project$Main$viewNode, _p8._0));
	} else {
		return _elm_lang$core$Native_List.fromArray(
			[
				A2(
				_elm_lang$html$Html$div,
				_elm_lang$core$Native_List.fromArray(
					[
						_elm_lang$html$Html_Attributes$class('alert alert-error')
					]),
				_elm_lang$core$Native_List.fromArray(
					[
						_elm_lang$html$Html$text(_p8._0)
					]))
			]);
	}
};
var _user$project$Main$viewHierarchySideBar = function (h) {
	return A2(
		_elm_lang$html$Html$div,
		_elm_lang$core$Native_List.fromArray(
			[
				_elm_lang$html$Html_Attributes$class('row')
			]),
		_elm_lang$core$Native_List.fromArray(
			[
				A2(
				_elm_lang$html$Html$div,
				_elm_lang$core$Native_List.fromArray(
					[
						_elm_lang$html$Html_Attributes$class('col-xs-12')
					]),
				_user$project$Main$viewCurrentNodes(h))
			]));
};
var _user$project$Main$viewHierarchyLayout = F2(
	function (selected, hierachy) {
		return A2(
			_elm_lang$html$Html$div,
			_elm_lang$core$Native_List.fromArray(
				[
					_elm_lang$html$Html_Attributes$class('container-fluid')
				]),
			_elm_lang$core$Native_List.fromArray(
				[
					A2(
					_elm_lang$html$Html$div,
					_elm_lang$core$Native_List.fromArray(
						[
							_elm_lang$html$Html_Attributes$class('row')
						]),
					_elm_lang$core$Native_List.fromArray(
						[
							A2(
							_elm_lang$html$Html$div,
							_elm_lang$core$Native_List.fromArray(
								[
									_elm_lang$html$Html_Attributes$class('col-xs-3')
								]),
							_elm_lang$core$Native_List.fromArray(
								[
									_user$project$Main$viewHierarchySideBar(hierachy)
								])),
							A2(
							_elm_lang$html$Html$div,
							_elm_lang$core$Native_List.fromArray(
								[
									_elm_lang$html$Html_Attributes$class('col-xs-9')
								]),
							_elm_lang$core$Native_List.fromArray(
								[
									A2(_user$project$Main$viewHierarchyInfo, selected, hierachy)
								]))
						]))
				]));
	});
var _user$project$Main$view = function (model) {
	var _p9 = model;
	if (_p9.ctor === 'Error') {
		return _elm_lang$html$Html$text(_p9._0);
	} else {
		return A2(_user$project$Main$viewHierarchyLayout, _p9._0, _p9._1);
	}
};
var _user$project$Main$main = {
	main: _elm_lang$html$Html_App$beginnerProgram(
		{model: _user$project$Main$init, view: _user$project$Main$view, update: _user$project$Main$update})
};

var Elm = {};
Elm['Main'] = Elm['Main'] || {};
_elm_lang$core$Native_Platform.addPublicModule(Elm['Main'], 'Main', typeof _user$project$Main$main === 'undefined' ? null : _user$project$Main$main);

if (typeof define === "function" && define['amd'])
{
  define([], function() { return Elm; });
  return;
}

if (typeof module === "object")
{
  module['exports'] = Elm;
  return;
}

var globalElm = this['Elm'];
if (typeof globalElm === "undefined")
{
  this['Elm'] = Elm;
  return;
}

for (var publicModule in Elm)
{
  if (publicModule in globalElm)
  {
    throw new Error('There are two Elm modules called `' + publicModule + '` on this page! Rename one of them.');
  }
  globalElm[publicModule] = Elm[publicModule];
}

}).call(this);

