import CoreNFC
import Logging

class IOSNFCService: NSObject, NFCService {
    private let logger = Logger(label: "nfc")

    var session: NFCTagReaderSession?

    private let itemsSubject = SafeValueSubject([ArchiveItem]())

    var items: SafePublisher<[ArchiveItem]> {
        self.itemsSubject.eraseToAnyPublisher()
    }

    override init() {
        super.init()
        itemsSubject.value = []
    }

    func startReader() {
        session = NFCTagReaderSession(
            pollingOption: .iso14443,
            delegate: self,
            queue: DispatchQueue.main)
        session?.begin()
    }
}

extension IOSNFCService: NFCTagReaderSessionDelegate {
    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
    }

    func tagReaderSession(
        _ session: NFCTagReaderSession,
        didInvalidateWithError error: Swift.Error
    ) {
    }

    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        let items = tags.compactMap(ArchiveItem.init)
        itemsSubject.value = items
        session.invalidate()
    }

    func dump(_ tag: NFCTag) {
        logger.info("\(tag)")
    }
}

extension NFCMiFareFamily: CustomStringConvertible {
    // swiftlint:disable switch_case_on_newline
    public var description: String {
        switch self {
        case .unknown: return "Unknown"
        case .ultralight: return "Ultralight"
        case .plus: return "Plus"
        case .desfire: return "Desfire"
        @unknown default: return "Unsupported"
        }
    }
}

fileprivate extension ArchiveItem {
    init?(_ tag: NFCTag) {
        switch tag {
        case let .miFare(tag):
            self.init(
                name: .init("scan_\(Int(Date().timeIntervalSince1970))"),
                fileType: .nfc,
                properties: [
                    .init(key: "UID", value: tag.identifier.hexString)
                ])
        default:
            return nil
        }
    }
}

extension Data {
    var hexString: String {
        map { String(format: "%02hhX", $0) }.joined()
    }

    var debugHexString: String {
        map { String(format: "%02hhX ", $0) }.joined()
    }
}