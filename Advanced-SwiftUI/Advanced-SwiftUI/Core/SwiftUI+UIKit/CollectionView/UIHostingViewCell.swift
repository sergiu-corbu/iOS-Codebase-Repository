//
//  UIHostingViewCell.swift
//  Advanced-SwiftUI
//
//  Created by Sergiu Corbu on 12.02.2023.
//

import UIKit
import SwiftUI

class UIHostingViewCell<CellContent: View>: UICollectionViewCell {
  
  private var contentHostingController: UIHostingController<CellContent>!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .clear
    clipsToBounds = true
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(with content: CellContent) {
    if let contentHostingController {
      contentHostingController.rootView = content
      contentHostingController.view.setNeedsLayout()
      contentHostingController.view.setNeedsDisplay()
      contentHostingController.view.layoutIfNeeded()
    } else {
      addHostingController(view: content)
    }
  }
  
  private func addHostingController(view: CellContent) {
    let contentHostingController = UIHostingController(rootView: view)
    self.contentHostingController = contentHostingController
    contentHostingController.view.backgroundColor = .clear
    contentHostingController.view.translatesAutoresizingMaskIntoConstraints = false
    addSubview(contentHostingController.view)
    contentHostingController.view.constrainAllMargins(with: self)
  }
}

extension UIHostingViewCell {
  static var reuseIdentifier: String {
    return "UIHostingViewCellIdentifier"
  }
}
