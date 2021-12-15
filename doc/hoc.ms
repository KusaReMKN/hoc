.TL
HOC - An Interactive Language For Floating Point Arithmetic
.AU
Brian Kernighan
Rob Pike
.AB
.I Hoc
is a simple programmable interpreter
for floating point expressions.
It has C-style control flow,
function definition and the usual
numerical built-in functions
such as cosine and logarithm.
.AE
.NH
Expressions
.PP
.I Hoc
is an expression language,
much like C:
although there are several control-flow statements,
most statements such as assignments
are expressions whose value is disregarded.
For example, the assignment operator
= assigns the value of its right operand
to its left operand, and yields the value,
so multiple assignments work.
The expression grammar is:
.DS
.I
expr:		number
	|	variable
	|	( expr )
	|	expr binop expr
	|	unop expr
	|	function ( arguments )
.R
.DE
Numbers are floating point.
./" =======================================================================
The input format is that recognized by
.I scanf (3):
digits, decimal point, digits,
.I e
or
.I E ,
signed exponent.
At least on digit or a decimal point must be present; the other components are
optional.
.PP
Variable names are formed from a letter followed by a string of letters and
numbers.
.I binop
refers to binary operators such as addition or logical comparison;
.I unop
refers to the negation operators, `!' (logical negation, `not') and `\-'
(arithmetic negations, sign change). Table 1 lists the operators.
./" =======================================================================
.TS
center, box;
c s
lfCW l.
\fBTable 1:\fP  Operators, in decreasing order of precedence
.sp .5
^	exponentiation (\s-1FORTRAN\s0 **), right associative
! \-	(unary) logical and arithmetic negation
* /	multiplication, division
+ \-	addition, subtraction
> >=	relational operators: greater, greater or equal,
< <=	  less, less or equal,
\&== !=	  equal, not equal (all same precedence)
&&	logical AND (both operand always evaluated)
||	logical OR (both operands always evaluated)
\&=	assignment, right associative
.TE
./" =======================================================================
.PP
Functions, as described later, may be defined by the user.
Function arguments are expressions separated by commas.
There are also a number of built-in functions,
all of which take a single argument, described in Table 2.
.EQ
delim @@
.EN
.TS
center, box;
c s
lfCW l.
\fBTable 2:\fP  Built-in Functions
.sp .5
abs(x)	@|x|@, absolute value of @x@
atan(x)	arc tangent of @x@
cos(x)	@cos (x)@, cosine of @x@
exp(x)	@e sup x@, exponential of @x@
int(x)	integer part of @x@, truncated towards zero
log(x)	@log (x)@, logarithm base @e@ of @x@
log10(x)	@log sub 10 (x)@, logarithm base 10 of @x@
sin(x)	@sin (x)@, sine of @x@
sqrt(x)	@sqrt x@, @x sup half@
.TE
.PP
Logical expressions have value 1.0 (true) and 0.0 (false).
As in C, any non-zero value is taken to be true.
As is always the case with floating point numbers,
equality comparisons are inherently suspect.
.PP
.I Hoc
also
has a few built-in constats, shown in Table 3.
.EQ
delim @@
.EN
./" =======================================================================
.TS
center, box;
c s s
lfCW n l.
\fBTable 3:\fP  Built-in Constants
.sp .5
DEG	57.29577951308232087680	@180/ pi@, degrees per radian
E	2.71828182845904523536	@e@, base of natural logarithms
GAMMA	0.57721566490153286060	@gamma@, Euler-Mascheroni constant
PHI	1.61803398874989484820	@( sqrt 5 +1)/2@, the golden ratio
PI	3.14159265358979323846	@pi@, circular transcendental number
.TE
./" =======================================================================
.NH
Statements and Control Flow
.PP
.I Hoc
statements have the following grammar:
.DS
.I
stmt:		expr
	|	variable = expr
	|	procedure ( arglist )
	|	while ( expr ) stmt
	|	if ( expr ) stmt
	|	if ( expr ) stmt else stmt
	|	{ stmtlist }
	|	print expr-list
	|	return optional-expr

stmtlist:	\fR(nothing)\fP
	|	stmlist stmt
.R
.DE
An assignment is parsed by default as a statement rather than an expression,
so assignments typed interactively do not print their value.
.PP
Note that semicolons are not special to
.I hoc :
statements are terminated by newlines.
This causes some peculiar behavior.
The following are legal
.I if
statements:
.DS
.CW
if (x < 0) print(y) else print(z)

if (x < 0) {
	print(y)
} else {
	print(z)
}
.R
.DE
In the second example, the braces are mandatory:
the newline after the
.I if
would terminate the statement and produce a syntax error were the brace
omitted.
.PP
The syntax and semantics of
.I hoc
control flow facilites are basically the same as in C.
The
.I while
and
.I if
statements are just as in C,
except there are no
.I break
or
.I continue
statements.
.NH
Input and Output:
.I read
and
.I print
.PP
The input function
.I read ,
like the other built-ins, takes a single argument.
Unlike the built-ins, though, the argument is not an expression:
it is the name of a variable.
The next number (as defined above) is read from the standard input and assigned
to the named variable.
The return value of
.I read
is 1 (true) if a value was read,
and 0 (false) if
.I read encountered end of file or an error.
.PP
Output is generated with the
.I print
statement.
The arguments to
.I print
are a comma-separated list of expressions and strings in double quotes,
as in C.
Newlines must be supplied; they are never privuded automatically by
.I print .
.PP
Note that
.I read
is a special built-in function, and therefore takes a single parenthesized
argument, while
.I print
is a statement that takes a comma-separated,
unparenthesized list:
.DS
.CW
while (read(x)) {
	print "value is ", x, "\en"
}
.R
.DE
.NH
Functions and Procedures
.PP
Functions and procedures are distinct in
.I hoc ,
although they are defined by the same mechanism.
This distinction is simply for run-time error checking:
it is an error for a procedure to return a value, and for a function
.I not
to return one.
.PP
The definition syntax is:
.DS
.I
function:	func name() stmt

procedure:	proc name() stmt
.R
.DE
.I name
may be the name of any variable \(em
built-in functions are excluded.
The definition, up to the opening brace or statement,
must be on one line, as with the
.I if statements above.
.PP
Unlike C, the body of a function or procedure may be any statement,
not necessarily a compound (brace-enclosed) statement.
Since semicolons have no meaning in
.I hoc ,
a null procedure body is formed by an empty pair of braces.
.PP
Functions and procedures may take arguments,
separated by commas, when invoked.
Arguments are referred to as in the shell:
.I $3
refers to the third (1-indexed) argument.
They are passed by value and within functions are semantically equivalent to
variables.
It is an error to refer to an argument numbered greater than the number of
arguments passed to the routine.
The error checking is done dynamically, however, so a routine may have variable
numbers of arguments if initial arguments affect the number of arguments to be
referenced (as in C's
.I printf ).
.PP
Functions and procedures may recurse, but the stack has limited depth (about a
hundred calls).
The following show a
.I hoc
definition of Ackermann's function:
.DS
.CW
$ \f(CIhoc
func ack() {
	if ($1 == 0) return $2+1
	if ($2 == 0) return ack($1-1, 1)
	return ack($1-1, ack($1, $2-1))
}
ack(3, 2)
	\fP29
\f(CIack(3, 3)
	\fP61
\f(CIack(3, 4)
\fPhoc: stack too deep near line 8
\&...
.R
.DE
.NH
Examples
.PP
Stitling's formula:
.EQ
n ! ~\(ap~ sqrt { 2 n pi } ( n / e ) sup n ( 1 + 1 over { 12 n } )
.EN
.DS
.CW
$ \f(CIhoc
func stirl() {
    return sqrt(2*$1*PI) * ($1/E)^$1*(1 + 1/(12*$1))
}
stirl(10)
	\fP3628684.7
\f(CIstirl(20)
	\fP2.24328818e+18
.R
.DE
.PP
Factorial funcion, @n !@:
.DS
\f(CIfunc fac() if ($1 <= 0) return 1 else return $1 * fac($1-1)\fP
.DE
.PP
Ratio of factorial to Stirling approximation:
.DS
\f(CIi = 9
while ((i = i+1) <= 20) {
	print i, "  ", fac(i)/stirl(i), "\en"
}
\f(CW10   1.0000318
11   1.0000265
12   1.0000224
13   1.0000192
14   1.0000166
15   1.0000146
16   1.0000128
17   1.0000114
18   1.0000102
19   1.0000092
20   1.0000083
.R
.DE
