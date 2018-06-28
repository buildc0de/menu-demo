import Foundation

enum DBError: Error {
    case unableToFetchData
    case unableToSaveData
    case unexpectedData
}

extension DBError: LocalizedError {
    
    var errorDescription: String? {
        
        switch self {
        case .unableToFetchData:
            return NSLocalizedString("dbmanager.error.unable-to-fetch-data", comment: "")
        case .unableToSaveData:
            return NSLocalizedString("dbmanager.error.unable-to-save-data", comment: "")
        case .unexpectedData:
            return NSLocalizedString("dbmanager.error.unexpected-data", comment: "")
        }
        
    }
    
}
