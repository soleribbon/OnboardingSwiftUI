import SwiftUI
import SlideOverCard


struct ContentView: View {
    @State var activeCard: Bool = false
    @State private var contentState: CardContent = .welcome
    
    var body: some View {
        VStack {
            Button("Show Onboarding") {
                activeCard = true
            }
            
        }
        .slideOverCard(isPresented: $activeCard, options: [.hideDismissButton], style: SOCStyle(
            innerPadding: 18.0,
            outerPadding: 16.0,
            dimmingOpacity: 0.37
        )) {
            DynamicOnboardingViewWrapper(contentState: $contentState, activeCard: $activeCard)
        }
        
    }
}

#Preview {
    ContentView()
}
