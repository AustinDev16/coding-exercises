//
//  Location.swift
//  Locations
//
//  Created by Austin Blaser on 9/18/24.
//

struct Location: Decodable {
    let id: Int
    let latitude: Double
    let longitude: Double
    let attributes: [Attribute]
}

struct Attribute: Decodable {
    let type: String
    let value: ValueType

    enum CodingKeys: String, CodingKey {
        case type
        case value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decode(String.self, forKey: .type)
        // Try double first as String decoding is more inclusive
        if let doubleValue = try? container.decode(Double.self, forKey: .value) {
            self.value = .double(doubleValue)
        } else {
            let stringValue = try container.decode(String.self, forKey: .value)
            self.value = .string(stringValue)
        }
    }
}

enum ValueType: Decodable {
    case string(String)
    case double(Double)

    var label: String {
        return switch self {
        case .string(let value): value
        case .double(let value): String(format: "%.1f", value)
        }
    }
}
