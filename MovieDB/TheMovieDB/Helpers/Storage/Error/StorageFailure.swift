//
//  StorageFailure.swift
//  MovieDB
//
//  Created by Nestor Contreras Miranda on 17/11/22.
//

import Foundation

enum StorageFailure: Error {
    case storageDataSave
    case storageDataDelete
    case storageDataFetch
    case storageDataGenel
    case error(Error)
}
