###Basics

* all values are objects, they're mutable 
* all code is make of expressions, again mutable
* expresisons made of dynamic message sends 

Outlines on website that goals are to be:
* simple
* powerful (highly concurrent, dynamic)
* practical (fast, multi platform)

###To download

==> http://iolanguage.org

```
make vm
sudo make install
sudo make port  # Mac OSX
```

###Dynamic interpreter!

```
$ io
Io> print 
```

Io> someObject slotNames

###Syntax

* no keywords or statements
* everything is an expression made of messages, all are runtime accessible

"Informal BNF - [Backus-Naur Form](https://en.wikipedia.org/wiki/Backus%E2%80%93Naur_Form) - description" ~ context free grammars used to describe the syntax of languages 

```
exp        ::= { message | terminator }
message    ::= symbol [arguments]
arguments  ::= "(" [exp [ { "," exp } ]] ")"
symbol     ::= identifier | number | string
terminator ::= "\n" | ";"
```

an expression then is a message or terminator 

a message is a symbol with list of arguments

arguments are defined in () with a list of comma separated expressions

symboles are ientifiers or numbers or strings

a terminator is a new line character or a semi colon

####Messages

passed as expressions and evaluated by the receiver

example of a message:
```for(i, 1, 10, i println)```

`for` and `if` are normal messages, not keywords

Io's syntax does not distinguish between accessing a slot containing a method from one containing a variable. 

```
Account := Object clone
Account balance := 0
Account deposit := method(amount,
    balance = balance + amount
)

account := Account clone
account deposit(10.00)
account balance println
```

####Operators

Is a message whose name has no alphanumeric characters othat than ";", "_", or "." and isn't one of the following words - or, and, return

`1 + 2` is actually a normal message `1 +(2)`

`symbol [argument(symbol)]` 

For groupings do `1+(2 * 4)`

Order of operations follows C's:
`1 + 2 * 3 + 4` equals `1 + (2 *(3)) +(4)`


User defined operations (w/no standard operator name) are evalulated left to right

####Assignment

* `::=` makes slot, makes setter, assigns value
* `:=` makes slot, assigns value
* `=` assigns value to slot if exists, raises exception otherwise

####Numbers
123
123.456
0.456
.456
123e-4

Hex numbers are supported too

####Strings

```"defined within single set double quotes with escaped quotes w/in like \"this\" "```

```s := """ multi line or unescape "stuff"
like this """```

####Comments
//, /**/ for multiline, # supported


###Objects

messages => operators, calls, assigns, var access

prototypes => objects, classes, namespaces, locals
scopable blcoks => functions, methods, closures

####Prototypes

everything is an object (inc locals storage of a block and the namespace) all actions are messages (inc assignments)

objects made of kev/value pairs called slots, the internal list of objects they inherit from called protos

slots key is a symbol (unique immutable sequence), value any object type

#####clone and init

All new objects are made by cloning existing ones; clones are empty objects w/a parent in its list of protos

me := Person clone
me name := "lorena"  # new instance var or methods added by setting it
me sayHi := method("Yooooooo" print)

When clone an object, it's init slot will be called if it has one

###Inheritance

When object receives a message it looks for a matching slot, if missing lookup recursively depth first looks in protos

If matching slot has an "activatable object" like a Block of CFunction, it's activated; if other value type that value is returned

Io has no globals and the root object in Io namespace is called `Lobby`

No classes means no difference between subclass and an instance

e.g. subclass in Io

Person := Object clone

This sets Lobby slot "Person" to a clone of Object object, it's protos list only contains a reference to Object

Instance vars and methods are inherited from the objects referenced in the protos list, if a slot is set in our object it makes a new slot but doesn't change the protos

####Multiple inheritance

You can add any number of protos to an object's protos list, when responding to a message again lookup is depth first search of proto chain

###Methods

Methods are anonymous functions, when called makes an object to store its lcoals and sets the local's proto pointer and self slot to the target of the message

Object method method() used to make methods

method((2 + 2) print)

Return value of block is the result of last espression

####Arguments

method(<arg name 0>, <arg name 1>, ..., <do message>)

###Blocks

Block is the same as a method except it is lexically scoped; variable lookups continue in the context of where the block was created instead of the target of hte message which activated the block

Block made by using Object method block()

####Blocks vs Methods

Both these make an object to hold their locals when called

Methods set proto and self slots to the target of the message

Blocks set them to the locals object where the block was created

When a block can't find a variable that means it's locals don't have it whereas when a method can't find a variable in its locals it will pass that variable lookup to the object receiving the message

###call and self slots

when you make a locals object, it's self slot is set to the target of the message if a method else if it is a block its set to the "creation context". The call slot is set to a Call object that can be used to access information about the block activation

```
slot				returns
call sender			locals object of caller
call message		message used to call this method/block
call activated		the activated method/block
call slotContext	context in which slot was found
call target			current object
```





call message slot in locals can be used to access unevalutated argument messages

example:

```
myif := method(
    (call sender doMessage(call message argAt(0))) ifTrue( 
    call sender doMessage(call message argAt(1))) ifFalse( 
    call sender doMessage(call message argAt(2)))
)

myif(foo == bar, write("true\n"), write("false\n"))
```

doMessage() evaluates the argument in the context of the receiver

same as:

```
myif := method(
    call evalArgAt(0) ifTrue(
    call evalArgAt(1)) ifFalse( 
    call evalArgAt(2))
)

myif(foo == bar, write("true\n"), write("false\n"))
```

###Forward

If object doesn't respond to a message it will invoke it's "forward" method if it has one

Example of how to define a forward method that prints the info related to lookup that failed:

```
MyObject forward := method(
    write("sender = ", call sender, "\n")
    write("message name = ", call message name, "\n")
    args := call message argsEvaluatedIn(call sender)
    args foreach(i, v, write("arg", i, " = ", v, "\n") )
)
```

###Resend

Sends the current message to the receiver's protos with self as the context

A := Object clone
A m := method(write("in A\n"))
B := A clone
B m := method(write("in B\n"); resend)
B m
will print:
in B
in A


###Super

Sometimes it's necessary to send a message directly to a proto. Example:
Dog := Object clone
Dog bark := method(writeln("woof!"))

fido := Dog clone
fido bark := method(
    writeln("ruf!")
    super(bark)
)
Both resend and super are implemented in Io. 

###Introspection

```
Dog slotNames # returns list of names of an object's slots

Dog protos # returns list of objects which an object inherits from

myMethod := Dog getSlot("bark")  # gets value of a block in slot w/o activating
```



##Control Flow

###true, false, nil
singletons exist for each, nil is used to represent an unset of missing value

###Comparioson

==
!=
>=
<=
>
<

returns true or false
compare() method is what is implemented above for each returns -1, 0, 1 less,than, equal-to, greater than

###if

if(<condition>, <do message>, <else do message>)

else is optional

if(y < 10, x := y, x := 0)

is the same as:

x := if(y < 10, y, 0)

if(y < 10) then(x := y) else(x := 2)

elseif() is supported:

if(y < 10) then(x := y) elseif(y == 11) then(x := 0) else(x := 2)

###ifTrue, ifFalse 

like Smalltake 

ifNil, ifNonNil also supported

###loops

loop("thing" println)  # infinite
3 repeat("hai" print)
while(<condition>, <do message>)

```
a := 1
while(a < 10, 
    a print
    a = a + 1
)
```
for(<counter>, <start>, <end>, <opt step>, <do msg>)

for(x, 0, 10, 3, x println)
prints 0, 3, 6, 9

for(i, 1, 10, 
    if(i == 3, continue)
    if(i == 7, break)
    i print
)

Output:
12456

Io> test := method(123 print; return "abc"; 456 print)
Io> test
123


QUESTIONS: 
1. WTF is a locals object ... it's a "variable"

```
myMethod := Dog getSlot("bark")
# myMethod is the locals object
```

2.