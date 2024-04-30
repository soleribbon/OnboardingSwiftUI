//
//  GIFBreakdownView.swift
//  TestingOnboarding
//
//  Created by Ravi Heyne on 22/04/24.
//

import SwiftUI
import SlideOverCard

struct GIFBreakdownView: View {
    @Binding var contentState: CardContent
    private let gifTitle = Globals.gifTitle
    private let gifDesc = Globals.gifDesc
    private let appIcon = Globals.appIcon
    private let gifName = Globals.gifName
    
    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            gifTitleGroup
            gifViewer
            continueButton
            
        }
        
    }
    private var gifViewer: some View {
        VStack (alignment: .center){
            if let gifData = NSDataAsset(name: gifName)?.data {
                GIFImageView(imageData: gifData)
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.9)
                    .aspectRatio(1, contentMode: .fit)
                    .padding(.horizontal, 10)
                    .shadow(radius: 2)
                //FUTURE: add corner radius
            }
        }
    }
    
    private var gifTitleGroup: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 14) {
                Image(appIcon)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .cornerRadius(10)
                Text(gifTitle)
                    .font(.title)
                    .bold()
                    .foregroundColor(.primary)
                Spacer()
            }
        }
    }
    
    
    
    private var continueButton: some View {
        ActionButtonHostingController(buttonAction: {
            
            withAnimation {
                contentState = .email
            }
            
        }, buttonTitle: "Continue")
        .frame(height: 60)
    }
}

struct GIFBreakdownView_Previews: PreviewProvider {
    @State static var contentState: CardContent = .welcome
    
    static var previews: some View {
        
        GIFBreakdownView(contentState: $contentState)
            .previewLayout(.sizeThatFits)
            .padding()
        
    }
}

