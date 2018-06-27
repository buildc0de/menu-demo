import Foundation

enum DBError: Error {
    case unableToFetchData
    case unableToSaveData
}

extension DBError: LocalizedError {
    
    var errorDescription: String? {
        
        switch self {
        case .unableToFetchData:
            return NSLocalizedString("dbmanager.unable-to-fetch-data", comment: "")
        case .unableToSaveData:
            return NSLocalizedString("dbmanager.unable-to-save-data", comment: "")
        }
        
    }
    
}
