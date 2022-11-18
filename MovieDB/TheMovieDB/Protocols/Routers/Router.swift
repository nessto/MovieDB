//
//  Router.swift
//  MovieDB
//
//  Created by Nestor Contreras Miranda on 17/11/22.
//

import UIKit

protocol Router: AnyObject {
    associatedtype Route
    var navigationController: UINavigationController { get set }
    func exit()
    func process(route: Route)
}

protocol AppRouter: Router where Route == AppTransition { }
