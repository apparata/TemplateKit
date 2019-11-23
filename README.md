# TemplateKit

Example:

```Swift
let template: Template = """
This is a test.
{{ whatever }}
So is this.
{{ stuff }}
Whatever
{{ if potato }}
    Only if potato is true.
    {{ if cucumber }}
        Only if both potato and cucumber are true.
    {{ end }}
{{ end }}
Here are some types of fruits:
{{ for fruit in fruits }}
Fruit name: {{ fruit }}
{{ end }}

Here they are again:
{{ for fruit in fruits }}Fruit name: {{ car }} {{ end }}
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

## Built-in Transformers

- `#lowercased`
- `#uppercased`
- `#uppercasingFirstLetter`
- `#lowercasingFirstLetter`
- `#trimmed`
- `#removingWhitespace`
- `#collapsingWhitespace`
