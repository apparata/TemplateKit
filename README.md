![](https://github.com/apparata/TemplateKit/workflows/Swift/badge.svg)

# TemplateKit

## Simple Value

```Swift
let template: Template = "This is a <{ thing }>"

try template.render(context: [
    "thing": "test"
])
```

## Simple Value with Transformer

```Swift
let template: Template = "This is an uppercase <{ #uppercased thing }>"

try template.render(context: [
    "thing": "Test"
])
```

### Built-in Transformers

- `#lowercased`
- `#uppercased`
- `#uppercasingFirstLetter`
- `#lowercasingFirstLetter`
- `#trimmed`
- `#removingWhitespace`
- `#collapsingWhitespace`

## Conditionals

### `if ...` ... `end`

```Swift
let template: Template = """
<{ if isMonday }>
This is only kept if isMonday is true.
<{ #uppercased whatever }>
Some more text.
<{ end }>
"""

try template.render(context: [
    "whatever": "Test",
    "isMonday": true
])
```

###  `if ...` ... `else` ... `end`

```Swift
let template: Template = """
<{ if thing }>
Thing is true.
<{ else }>
Thing is false.
<{ end }>
"""

try template.render(context: [
    "thing": true
])
```

### Conditional Expression

The conditional expression can be more complicated than a simple boolean value. Here
is the complete grammar for the conditional expression:

```
expr      := term ('or' term)*
term      := factor ('and' factor)*
factor    := 'not'? ( statement | '(' expr ')' )
statement := terminal ( ('==' | '!=') string )?
string    := ('"' | ''') character* ('"' | ''')
```

#### Example: `if not ...`

```Swift
let template: Template = """
<{ if not isMonday }>
Today is not Monday.
<{ end }>
"""

try template.render(context: [
    "isMonday": true
])
```

#### Example: `if not (... and ...)`

```Swift
let template: Template = """
<{ if not (isMonday and isRaining) }>
Today is not Monday and it is not raining.
<{ end }>
"""

try template.render(context: [
    "isMonday": true,
    "isRaining": true
])
```

#### Example: `if ... == "..."`

```Swift
let template: Template = """
<{ if license == "MIT" }>
This is the MIT license.
<{ end }>
"""

try template.render(context: [
    "license": "MIT"
])
```

### Loops: `for ... in ...`

```Swift
let template: Template = """
Here are some types of fruits:
<{ for fruit in fruits }>
Fruit name: <{ fruit }>
<{ end }>
"""

try template.render(context: [
    "fruits": [
        "banana",
        "orange",
        "pineapple",
        "pear"
    ]
])
```

## Longer Example:

```Swift
let template: Template = """
This is a test.
<{ #lowercased whatever }>
So is this.
<{ stuff }>
Whatever
<{ if potato }>
    Only if potato is true.
    <{ if cucumber }>
        Only if both potato and cucumber are true.
    <{ end }>
<{ end }>
Here are some types of fruits:
<{ for fruit in fruits }>
Fruit name: <{ fruit }>
<{ end }>

Here they are again:
<{ for fruit in fruits }>Fruit name: <{ car }> <{ end }>
"""

let context: [String: Any?] = [
    "whatever": "[WHATEVER]",
    "stuff": 1337,
    "potato": true,
    "cucumber": 1,
    "fruits": [
        "banana",
        "orange",
        "pineapple",
        "pear"
    ]
]

try template.render(context: context)
```
