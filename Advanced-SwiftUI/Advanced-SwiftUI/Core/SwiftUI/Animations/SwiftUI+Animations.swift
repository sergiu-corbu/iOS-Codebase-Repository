//
//  SwiftUI+Animations.swift
//  Advanced-SwiftUI
//
//  Created by Sergiu Corbu on 12.02.2023.
//

import SwiftUI

extension Animation {
  static let hero = Self.interactiveSpring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.6)
}
