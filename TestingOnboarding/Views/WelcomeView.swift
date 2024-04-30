import SwiftUI
import SlideOverCard
import UIKit
struct WelcomeView: View {
    @Binding var contentState: CardContent
    
    private let appName = Globals.appName
    private let welcomeTitle = Globals.welcomeTitle
    private let welcomeDesc = Globals.welcomeDesc
    private let appIcon = Globals.appIcon
    
    @State private var isPressed = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            welcomeTitleGroup
            continueButton
        }
    }
    
    private var welcomeTitleGroup: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 14) {
                Image(appIcon)
                    .resizable()
                    .frame(width: 60, height: 60)
                    .cornerRadius(10)
                
            }
            
            Text(welcomeTitle)
                .font(.title)
                .bold()
                .foregroundColor(.primary)
            
            Text(welcomeDesc)
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
    
    private var continueButton: some View {
        
        ActionButtonHostingController(buttonAction: {
            withAnimation {
                contentState = .features
            }
        }, buttonTitle: "Get Started")
        .frame(height: 60)
    }
}



struct WelcomeView_Previews: PreviewProvider {
    @State static var contentState: CardContent = .welcome
    
    static var previews: some View {
        WelcomeView(contentState: $contentState)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

