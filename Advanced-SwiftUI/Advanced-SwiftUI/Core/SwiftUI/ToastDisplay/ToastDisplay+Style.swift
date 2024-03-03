//
//  ToastDisplay+Style.swift
//  Bond
//
//  Created by Sergiu Corbu on 03.11.2022.
//

import SwiftUI

extension ToastDisplay {
  
  enum Style {
    
    case success
    case error
    case informative
    
    var tint: Color {
      switch self {
      case .success: return .green
      case .informative: return .brown
      case .error: return .red
      }
    }
    
    var image: Image {
      switch self {
      case .success: return Image(systemName: "mark")
      case .informative: return Image(systemName: "mark")
      case .error: return Image(systemName: "xmark")
      }
    }
  }
}
