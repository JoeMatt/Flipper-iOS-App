import Foundation

public struct ArchiveItem: Codable, Equatable, Identifiable {
    public let id: ID
    public let name: Name
    public let fileType: FileType
    public var properties: [Property]
    public var isFavorite: Bool
    public var status: Status
    public var date: Date

    public struct ID: Codable, Equatable, Hashable {
        let value: String?

        public static let none: ID = .init()

        private init() { value = nil }

        init(name: Name, fileType: FileType) {
            self.value = "\(name.value).\(fileType.extension)"
        }

        init(path: Path) {
            self.value = path.components.last
        }
    }

    public enum Status: Codable, Equatable {
        case error
        case deleted
        case imported
        case modified
        case synchronizied
        case synchronizing
    }

    public struct Name: Codable, Equatable {
        public var value: String

        public init(_ value: String) {
            self.value = value
        }
    }

    public struct Property: Codable, Equatable {
        public let key: String
        public var value: String
        public var description: [String] = []
    }

    public enum FileType: Codable, Comparable, CaseIterable {
        case ibutton
        case nfc
        case rfid
        case subghz
        case irda
    }

    public init(
        name: Name,
        fileType: FileType,
        properties: [Property],
        isFavorite: Bool,
        status: Status,
        date: Date = .init()
    ) {
        self.id = .init(name: name, fileType: fileType)
        self.name = name
        self.fileType = fileType
        self.isFavorite = isFavorite
        self.properties = properties
        self.status = status
        self.date = date
    }
}

extension ArchiveItem {
    public func rename(to name: Name) -> ArchiveItem {
        .init(
            name: name,
            fileType: fileType,
            properties: properties,
            isFavorite: isFavorite,
            status: status)
    }
}

extension ArchiveItem.Name: CustomStringConvertible {
    public var description: String {
        value
    }
}

extension ArchiveItem.Name: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.value = value
    }
}

extension ArchiveItem.Name: Comparable {
    public static func < (lhs: ArchiveItem.Name, rhs: ArchiveItem.Name) -> Bool {
        lhs.value < rhs.value
    }
}
