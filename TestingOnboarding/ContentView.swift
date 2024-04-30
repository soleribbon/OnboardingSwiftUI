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
            innerPadding: Globals.innerPadding,
            outerPadding: Globals.outerPadding,
            dimmingOpacity: Globals.dimmingOpacity
        )) {
            DynamicOnboardingViewWrapper(contentState: $contentState, activeCard: $activeCard)
        }
        
    }
}

#Preview {
    ContentView()
}
