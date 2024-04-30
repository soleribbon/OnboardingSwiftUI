import SwiftUI
import SlideOverCard

struct FeaturesView: View {
    @Binding var contentState: CardContent
    private let features = Globals.features
    private let featuresTitle = Globals.featuresTitle
    private let featuresDesc = Globals.featuresDesc
    private let appIcon = Globals.appIcon
    
    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            featuresTitleGroup
            featureList
            continueButton
        }
    }
    
    private var featureList: some View {
        VStack (alignment: .leading, spacing: 20) {
            ForEach(features) { feature in
                featureRow(for: feature)
            }
        }
    }
    
    private var featuresTitleGroup: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 14) {
                Image(appIcon)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .cornerRadius(10)
                    .scaleEffect(contentState == .welcome ? 1 : 0.95)
                    .animation(.easeInOut(duration: 0.5), value: contentState)
                Text(featuresTitle)
                    .font(.title)
                    .bold()
                    .foregroundColor(.primary)
                Spacer()
            }
            
            //            Text(featuresDesc)
            //                .font(.body)
            //                .foregroundColor(.secondary)
            //                .padding(.bottom)
        }
    }
    
    private func featureRow(for feature: Feature) -> some View {
        HStack(alignment: .center, spacing: 14) {
            Image(systemName: feature.iconName)
                .font(.system(size: 30))
                .foregroundColor(.accentColor)
                .frame(width: 36, height: 36)
            
            VStack(alignment: .leading) {
                Text(feature.title)
                    .bold()
                Text(feature.description)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(.gray)
            }
        }
    }
    
    
    private var continueButton: some View {
        
        ActionButtonHostingController(buttonAction: {
            withAnimation {
                contentState = .gif
            }
        }, buttonTitle: "Continue")
        .frame(height: 60)
    }
}

struct FeaturesView_Previews: PreviewProvider {
    @State static var contentState: CardContent = .welcome
    
    static var previews: some View {
        FeaturesView(contentState: $contentState)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
