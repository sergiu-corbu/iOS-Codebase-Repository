//
//  Concurrency+Utils.swift
//  Advanced-SwiftUI
//
//  Created by Sergiu Corbu on 12.02.2023.
//

import Foundation

import Foundation

extension Task where Success == Never, Failure == Never {
    
    /// Suspends the current task for at least the given duration in seconds.
    static func sleep(seconds: TimeInterval) async {
        let duration = UInt64(seconds * 1_000_000_000)
        try? await sleep(nanoseconds: duration)
    }
}
