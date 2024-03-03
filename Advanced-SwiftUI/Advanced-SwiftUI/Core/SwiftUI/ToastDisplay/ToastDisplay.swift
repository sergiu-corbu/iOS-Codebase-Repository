//
//  ToastDisplay.swift
//  Advanced-SwiftUI
//
//  Created by Sergiu Corbu on 12.02.2023.
//

import SwiftUI

struct ToastDisplay: View {
    
    @Binding var isPresented: Bool
    let style: Style
    let title: String?
    let message: String
    
    var onDismiss: (() -> Void)?
    
    @State private var yTranslation: CGFloat = .zero
    @State private var isDragging = false
    
    var body: some View {
        ZStack {
            if isPresented {
                toastContent
                    .gesture(dragGesture)
                    .transition(.moveAndFade())
                    .task {
                        await dismissToast(after: 2)
                    }
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isPresented)
    }
    
    private var toastContent: some View {
        HStack(spacing: 12) {
            style.image
            VStack(alignment: .leading, spacing: 2) {
                if let title {
                    Text(title)
                        .foregroundColor(style.tint)
                }
                Text(message)
                    .textStyle(.toastMessage)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, minHeight: 54, alignment: .leading)
        .background(Color.gray.cornerRadius(5))
        .padding(.horizontal, 16)
        .offset(y: yTranslation)
        .animation(.easeIn(duration: 0.4), value: yTranslation)
    }
    
    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged { value in
                let draggedHeight = value.translation.height
                if !isDragging {
                    isDragging = true
                }
                
                guard draggedHeight < .zero else {
                    if draggedHeight < 50 {
                        yTranslation = draggedHeight
                    }
                    return
                }
                
                if abs(draggedHeight) > 40 {
                    isPresented = false
                } else {
                    yTranslation = draggedHeight
                }
            }
            .onEnded { _ in
                yTranslation = .zero
                isDragging = false
                Task(priority: .userInitiated) {
                    await dismissToast(after: 1.3)
                }
            }
    }
    
    @MainActor
    private func dismissToast(after seconds: TimeInterval) async {
        await Task.sleep(seconds: seconds)
        if !isDragging {
            isPresented = false
            onDismiss?()
        }
    }
}

#if DEBUG
struct ToastDisplay_Previews: PreviewProvider {
    
    static var previews: some View {
        ToastDisplayPreview()
    }
    
    private struct ToastDisplayPreview: View {
        
        @State var isPresented = false
        
        enum ToastError: String, LocalizedError {
            case title = "This is a short title"
            case message = "This is a regular error message"
            var errorDescription: String? {
                rawValue
            }
        }
        
        var body: some View {
            Color.red
                .onTapGesture {
                    isPresented.toggle()
                }
                .successToast(isPresented: $isPresented, title: "Success", message: ToastError.message.localizedDescription + ToastError.message.localizedDescription)
            //                .errorToast(isPresented: $isPresented, error: ToastError.message)
        }
    }
}
#endif
