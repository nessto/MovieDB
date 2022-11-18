//
//  UICollectionReusableView.swift
//  MovieDB
//
//  Created by Nestor Contreras Miranda on 17/11/22.
//

import UIKit

extension UICollectionReusableView {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
