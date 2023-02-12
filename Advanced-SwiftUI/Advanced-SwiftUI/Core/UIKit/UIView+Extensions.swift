//
//  UIView+Extensions.swift
//  Advanced-SwiftUI
//
//  Created by Sergiu Corbu on 12.02.2023.
//

import UIKit

extension UIView {
    
    func constrainAllMargins(with other: UIView) {
        let constraints = [
            topAnchor.constraint(equalTo: other.topAnchor),
            bottomAnchor.constraint(equalTo: other.bottomAnchor),
            leadingAnchor.constraint(equalTo: other.leadingAnchor),
            trailingAnchor.constraint(equalTo: other.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
