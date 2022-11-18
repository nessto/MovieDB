//
//  Storage.swift
//  MovieDB
//
//  Created by Nestor Contreras Miranda on 17/11/22.
//

import CoreData
import Combine

protocol Storage {
    func save<T>(object: T) -> Future<Bool, StorageFailure>
    func delete<T>(object: T)  -> Future<Bool, StorageFailure>
    func fetch<T: NSManagedObject>() -> Future<[T], StorageFailure>
}
