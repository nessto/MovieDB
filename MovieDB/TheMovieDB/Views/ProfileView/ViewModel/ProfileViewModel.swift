//
//  ProfileViewModel.swift
//  TheMovieDB
//
//  Created by Byron Mejia on 10/20/22.
//

import UIKit
import Combine
import CoreData

protocol ProfileViewModelRepresentable {
    func getAccountDetails()
    func loadFavoriteMovies(_ offset: Int)
    func prefetchData(for indexPaths: [IndexPath])
    func didTapItem(index: IndexPath)
    var profileItem: Profile? { get }
    var favoritesSubject: PassthroughSubject<[Movie], APIError> { get }
}

final class ProfileViewModel<R: AppRouter> {
    weak var router: R?
    private let store: ProfileStore
    
    private var cancellables = Set<AnyCancellable>()
    let favoritesSubject = PassthroughSubject<[Movie], APIError>()
    var profileItem: Profile?
    
    private var fetchedFavorites = [Movie]() {
        didSet {
            favoritesSubject.send(fetchedFavorites)
        }
    }
    
    init(store: ProfileStore = APIManager()) {
        self.store = store
    }
}

extension ProfileViewModel: ProfileViewModelRepresentable {
    
    func getAccountDetails() {
        guard AuthorizationDataManager.shared.getAuthorizationSession != nil,
              let profile = AuthorizationDataManager.shared.getAuthorizationProfile
        else { return }
        profileItem = profile
        favoritesSubject.send([])
    }
    
    func loadFavoriteMovies(_ offset: Int) {
        guard let sessionId = AuthorizationDataManager.shared.getAuthorizationSession,
        let accountId = profileItem?.id else { return }
        
        let recievedData = { (response: PaginatedResponse<Movie>)  -> Void in
            DispatchQueue.main.async { [unowned self] in
                fetchedFavorites.append(contentsOf: response.results)
            }
        }
        
        let completion = { [unowned self] (completion: Subscribers.Completion<APIError>) -> Void in
            switch  completion {
            case .finished:
                break
            case .failure(let error):
                favoritesSubject.send(completion: .failure(error))
            }
        }
        
        store.getMovieFavorite(accountId: accountId, sessionId: sessionId, with: offset)
            .sink(receiveCompletion: completion, receiveValue: recievedData)
            .store(in: &cancellables)
    }
    
    func prefetchData(for indexPaths: [IndexPath]) {
        guard let index = indexPaths.last?.row else { return }
        
        let movieAlreadyLoaded = fetchedFavorites.count
        if index > movieAlreadyLoaded - 10 {
            loadFavoriteMovies(movieAlreadyLoaded)
        }
    }
    
    func didTapItem(index: IndexPath) {
        let movie = fetchedFavorites[index.row]
        router?.process(route: .showDetail(model: movie))
    }
}
