import XCTest
@testable import TemplateKit

final class TemplateKitTests: XCTestCase {
    func testExample() {
        let context: [String: Any?] = [
            "whatever": "[WHATEVER]",
            "stuff": 1337,
            "potato": true,
            "cucumber": 1,
            "otherThing": false,
            "fruits": [
                "banana",
                "orange",
                "pineapple",
                "pear"
            ],
            "nestedCars": [
                "cars": [
                    "Volvo",
                    "Saab",
                    "Ferrari"
                ]
            ]
        ]

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
        <{ if otherThing }>
            Only if otherThing is true.
        <{ else }>
            <{ if cucumber }>
                Only if otherThing is false and cucumber are true.
            <{ end }>
        <{ end }>
        Here are some types of cars:
        <{ for car in nestedCars.cars }>
        Car name: <{ car }>
        <{ end }>
        Here are some types of fruits:
        <{ for fruit in fruits }>
        Fruit name: <{ fruit }>
        <{ end }>

        Here they are again:
        <{ for fruit in fruits }>Fruit name: <{ fruit }> <{ end }>
        """

        XCTAssertNoThrow(try {
            let result = try template.render(context: context)
            print(result)
        }())

    }

    func testExample2() {

        struct Fruit {
            let name: String
        }

        let context: [String: Any?] = [
            "whatever": "[WHATEVER]",
            "stuff": 1337,
            "potato": true,
            "cucumber": 1,
            "otherThing": false,
            "fruits": [
                Fruit(name: "banana"),
                Fruit(name: "orange"),
                Fruit(name: "pineapple"),
                Fruit(name: "pear")
            ]
        ]

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
        <{ if otherThing }>
            Only if otherThing is true.
        <{ else }>
            <{ if cucumber }>
                Only if otherThing is false and cucumber are true.
            <{ end }>
        <{ end }>
        Here are some types of fruits:
        <{ for fruit in fruits }>
        Fruit name: <{ fruit.name }>
        <{ end }>

        Here they are again:
        <{ for fruit in fruits }>Fruit name: <{ fruit.name }> <{ end }>
        """

        XCTAssertNoThrow(try {
            let result = try template.render(context: context)
            print(result)
        }())

    }

    func testNewLine() {
        let context: [String: Any?] = [
            "whatever": "[WHATEVER]",
            "stuff": 1337,
            "potato": true,
            "cucumber": 1,
            "otherThing": false,
            "fruits": [
                "banana",
                "orange",
                "pineapple",
                "pear"
            ]
        ]

        let template: Template = """
        <{ if cucumber }>
            <{ end }>
        This should be at the start of the line.
        """

        XCTAssertNoThrow(try {
            let result = try template.render(context: context)
            print(result)
        }())
    }

    func testExampleIf() {
        let context: [String: Any?] = [
            "thing": true
        ]

        let template: Template = "<{ if thing }>Is True<{ end }>"

        XCTAssertNoThrow(try {
            let result = try template.render(context: context)
            print(result)
        }())
    }

    func testExampleIfNot() {
        let context: [String: Any?] = [
            "thing": false,
            "otherThing": true
        ]

        let template: Template = "<{ if not (thing and otherThing) }>Is True<{ end }>"

        XCTAssertNoThrow(try {
            let result = try template.render(context: context)
            print(result)
        }())
    }

    func testExampleIfEquals() {
        let context: [String: Any?] = [
            "thing": false,
            "license": "MIT"
        ]

        let template: Template = "<{ if license == \"MIT\" }>Is True<{ end }>"

        XCTAssertNoThrow(try {
            let result = try template.render(context: context)
            print(result)
        }())
    }

    func testExampleIfEqualsSingleQuote() {
        let context: [String: Any?] = [
            "thing": false,
            "license": "MIT"
        ]

        let template: Template = "<{ if license == 'MIT' }>Is True<{ end }>"

        XCTAssertNoThrow(try {
            let result = try template.render(context: context)
            print(result)
        }())
    }

    func testExampleIfNotEqualsSingleQuote() {
        let context: [String: Any?] = [
            "license": "Unlicense"
        ]

        let template: Template = """
        <{ if license == 'Unlicense' }>Unlicense<{ end }>
        <{ if not (license == 'Unlicense') }><{ license }><{ end }>
        <{ if license != 'MIT' }>Not MIT<{ end }>
        """

        XCTAssertNoThrow(try {
            let result = try template.render(context: context)
            print(result)
        }())
    }

    func testExampleIfElse() {
        let context: [String: Any?] = [
            "thing": false
        ]

        let template: Template = """
        Banana
        <{ if thing }>
            Is True
        <{ else }>
            Is False
        <{ end }>
        Apple
        """

        XCTAssertNoThrow(try {
            let result = try template.render(context: context)
            print(result)
        }())
    }

    func testCode() {
        let context: [String: Any?] = [:]

        let template: Template = """
banan {
    hej
}
"""
        XCTAssertNoThrow(try {
            let result = try template.render(context: context)
            print(result)
        }())
    }

    func testOneTagOnly() {
        let context: [String: Any?] = [
            "banana": "hej"
        ]

        let template: Template = "<{ banana }>"

        XCTAssertNoThrow(try {
            let result = try template.render(context: context)
            print(result)
        }())
    }

    func testNoTagOnly() {
        let context: [String: Any?] = [
            "banana": "hej"
        ]

        let template: Template = """
<banana>
<gurka>
"""

        XCTAssertNoThrow(try {
            let result = try template.render(context: context)
            print(result)
        }())
    }

    func testURLConditional() {
        let context: [String: Any?] = [
            "url": URL(string: "https://google.com")
        ]

        let template: Template = """
        <{ if url == "" }>
        URL is empty.
        <{ end }>
        <{ if url != "" }>
        URL is not empty.
        <{ end }>
        <{ if url == "https://google.com" }>
        URL is https://google.com
        <{ end }>
        <{ if url != "https://google.com" }>
        URL is not https://google.com
        <{ end }>
        """

        XCTAssertNoThrow(try {
            let result = try template.render(context: context)
            print(result)
        }())
    }

    func testOptionalVariable() {
        struct Fruit {
            struct Peel {
                let color: String?
            }
            let name: String
            let peel: Peel?
        }

        let banana = Fruit(name: "Banana", peel: nil)
        let apple = Fruit(name: "Apple", peel: .init(color: nil))
        let orange = Fruit(name: "Orange", peel: .init(color: "orange"))

        let context: [String: Any?] = [
            "banana": banana,
            "apple": apple,
            "orange": orange,
            "text": "stuff"
        ]

        let template: Template = """
            |<{banana.peel.color}>|
            |<{apple.peel.color}>|
            |<{orange.peel.color}>|
            <{ if banana.peel.color == "" }>
            True
            <{ else }>
            False
            <{ end }>
            <{ if banana.peel.color != "" }>
            True
            <{ else }>
            False
            <{ end }>
            <{ if orange.peel.color == "" }>
            True
            <{ else }>
            False
            <{ end }>
            <{ if orange.peel.color != "" }>
            True
            <{ else }>
            False
            <{ end }>
            <{ if orange.peel.color == "orange" }>
            True
            <{ else }>
            False
            <{ end }>
            """

        XCTAssertNoThrow(try {
            let result = try template.render(context: context)
            print(result)
        }())
    }

    static var allTests = [
        ("testExample", testExample),
        ("testExample2", testExample2),
        ("testNewLine", testNewLine),
        ("testExampleIf", testExampleIf),
        ("testExampleIfNot", testExampleIfNot),
        ("testExampleIfEquals", testExampleIfEquals),
        ("testExampleIfEqualsSingleQuote", testExampleIfEqualsSingleQuote),
        ("testExampleIfNotEqualsSingleQuote", testExampleIfNotEqualsSingleQuote),
        ("testExampleIfElse", testExampleIfElse),
        ("testCode", testCode),
        ("testOneTagOnly", testOneTagOnly),
        ("testNoTagOnly", testNoTagOnly),
        ("testOptionalVariable", testOptionalVariable)
    ]
}
