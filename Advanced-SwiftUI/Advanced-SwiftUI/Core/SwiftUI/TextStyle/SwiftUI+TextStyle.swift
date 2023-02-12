//
//  SwiftUI+TextStyle.swift
//  Advanced-SwiftUI
//
//  Created by Sergiu Corbu on 12.02.2023.
//

import Foundation
import SwiftUI

extension Text {
    
    func textStyle<S>(_ style: S) -> some View where S : TextStyle {
        return style.makeBody(text: self)
    }
}

protocol TextStyle {
    
    associatedtype Body : View
    func makeBody(text: Text) -> Self.Body
}

extension TextStyle where Self == ToastMessageTextStyle {
    
    static var toastMessage: Self {
        ToastMessageTextStyle()
    }
}

struct ToastMessageTextStyle: TextStyle {
    
    func makeBody(text: Text) -> some View {
        text
            .font(.subheadline)
            .foregroundColor(.gray)
            .lineLimit(2)
            .minimumScaleFactor(0.9)
    }
}
