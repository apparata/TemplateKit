import XCTest
@testable import TemplateKit

final class TemplateKitTests: XCTestCase {
    func testExample() {
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
            
        XCTAssertNoThrow(try template.render(context: context))
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
