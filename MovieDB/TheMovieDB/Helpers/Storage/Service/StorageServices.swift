//
//  StorageServices.swift
//  MovieDB
//
//  Created by Nestor Contreras Miranda on 17/11/22.
//

import Combinefire
import CoreData

protocol StorageServices {
    func fetch() -> Future<[NSManagedObject], StorageFailure>
    func save(movie: Movie) -> Future<Bool, StorageFailure>
    func delete(movieManagedObject: NSManagedObject) -> Future<Bool, StorageFailure>
}

final class Services {
    private let storage: Storage
    private var cancellables = Set<AnyCancellable>()
    private var subscription: AnyCancellable?
    
    required init(storage: Storage) {
        self.storage = storage
    }
}

extension Services: StorageServices {
    func fetch() -> Future<[NSManagedObject], StorageFailure> {
        return Future { [unowned self]  promise in
            subscription = storage.fetch()
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        promise(.failure(.error(error)))
                    }
                } receiveValue: { favorites in
                    promise(.success(favorites))
                }
        }
    }
    
    func save(movie: Movie) -> Future<Bool, StorageFailure> {
        return Future { [unowned self]  promise in
            subscription = storage.save(object: movie)
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        promise(.failure(.error(error)))
                    }
                } receiveValue: { response in
                    promise(.success(response))
                }
        }
    }
    
    func delete(movieManagedObject: NSManagedObject) -> Future<Bool, StorageFailure> {
        return Future { [unowned self]  promise in
            subscription = storage.delete(object: movieManagedObject)
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        promise(.failure(.error(error)))
                    }
                } receiveValue: { response in
                    promise(.success(response))
                }
        }
    }
}
