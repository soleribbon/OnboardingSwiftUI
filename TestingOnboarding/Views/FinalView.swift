//
//  FinalView.swift
//  TestingOnboarding
//
//  Created by Ravi Heyne on 21/04/24.
//

import SwiftUI
import SlideOverCard

struct FinalView: View {
    @Binding var contentState: CardContent
    @Binding var activeCard: Bool
    @State private var isAnimatingHeart: Bool = false
    @State private var rotationDegrees: Double = -6
    
    private let finalTitle = Globals.finalTitle
    private let finalDesc = Globals.finalDesc
    private let appIcon = Globals.appIcon
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            finalTitleGroup
            continueButton
        }        .onAppear {
            isAnimatingHeart = true
            withAnimation(Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                rotationDegrees = 6
            }
        }
    }
    private var finalTitleGroup: some View {
        VStack(alignment: .leading, spacing: 14) {
            
            HStack(spacing: 14) {
                Image(appIcon)
                    .resizable()
                    .frame(width: 60, height: 60)
                    .cornerRadius(10)
            }
            
            HStack(spacing: 6) {
                
                Text(finalTitle)
                    .font(.title)
                    .bold()
                    .foregroundColor(.primary)
                Image(systemName: "heart.fill")
                    .font(.title)
                    .foregroundStyle(Color(red: 0.859, green: 0, blue: 0))
                    .rotationEffect(.degrees(rotationDegrees))
                    .scaleEffect(isAnimatingHeart ? 1.1 : 1.0)
                    .animation(Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: isAnimatingHeart)
            }
            
            Text(finalDesc)
                .font(.body)
                .foregroundColor(.primary)
        }
    }
    
    private var continueButton: some View {
        
        ActionButtonHostingController(buttonAction: {
            activeCard = false
            
            contentState = .welcome //reset card flow
            
        }, buttonTitle: "Enter App")
        
        .frame(height: 60)
    }
}

struct FinalView_Previews: PreviewProvider {
    @State static var contentState: CardContent = .final
    @State static var activeCard: Bool = true
    
    static var previews: some View {
        FinalView(contentState: $contentState, activeCard: $activeCard)
            .previewLayout(.sizeThatFits)
            .padding()
        
    }
}
