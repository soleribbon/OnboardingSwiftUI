//
//  GlobalEditables.swift
//  TestingOnboarding
//
//  Created by Ravi Heyne on 22/04/24.
//

import Foundation
import SwiftUI

struct Globals {

    //GENERAL
    static let appName = "Insert App Name"
    static let appIcon = "App Icon Name"
    static let actionButtonColor = UIColor.systemBlue
    //Also try: Color(hex: "#3F51B5")

    // STYLING for SlideOverCard
    static let innerPadding: CGFloat = 18.0
    static let outerPadding: CGFloat = 16.0
    static let dimmingOpacity: Double = 0.37

    //WELCOME Step
    static let welcomeTitle = "Welcome"
    static let welcomeDesc = "\(appName) helps you calculate how much you will earn after all fees as a seller on Reverb.com"

    //FEATURES Step
    static let featuresTitle = "Main Features"
    static let featuresDesc = "Check out these main functions" //unused
    //FEATURES LIST
    static let features: [Feature] = [
        Feature(iconName: "star.fill", title: "Star Items", description: "This is an awesome new thing."),
        Feature(iconName: "heart.fill", title: "Calculate easily", description: "You're going to love this!"),
        Feature(iconName: "square.and.arrow.down", title: "Downloadable anywhere", description: "You're going to love this!"),
    ]

    //EMAILS Step
    static let emailCollectionTitle = "Stay Updated"
    static let emailCollectionDesc  = "Only important app updates. Never spam."
    static let emailAPIURL = "INSERT YOUR EMAIL API POST REQUEST URL HERE"

    //GIF Step
    //NOTE: Put GIF file as DataSet in Assets
    static let gifName = "userInfoGIF"
    static let gifTitle = "How it works"
    static let gifDesc  = "A quick tutorial." //unused

    //FINAL Step
    static let finalTitle = "Thank You"
    static let finalDesc = "Enjoy \(appName)? \nPlease share your experience and support us with a coffee️ donation!"

}

struct Feature: Identifiable {
    var id = UUID()
    let iconName: String
    let title: String
    let description: String
}
enum CardContent {
    case welcome, features, gif, email, final
}

struct DynamicOnboardingViewWrapper: View {
    @Binding var contentState: CardContent
    @Binding var activeCard: Bool
    var body: some View {
        switch contentState {
        case .welcome:
            WelcomeView(contentState: $contentState)
        case .features:
            FeaturesView(contentState: $contentState)
        case .gif:
            GIFBreakdownView(contentState: $contentState)
        case .email:
            EmailView(contentState: $contentState)
        case .final:
            FinalView(contentState: $contentState, activeCard: $activeCard)

        }
    }
}

//Enables HEX color code usage
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#") // Optional: handle the '#' character

        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = Double(rgbValue & 0x0000FF) / 255.0

        self.init(red: r, green: g, blue: b)
    }
}

//Extra functions
//main haptic for buttons
func triggerHapticFeedback() {
    let impactMed = UIImpactFeedbackGenerator(style: .medium)
    impactMed.prepare()
    impactMed.impactOccurred()
}
//for other special haptics
func triggerNotificationFeedback(ofType type: UINotificationFeedbackGenerator.FeedbackType) {
    let generator = UINotificationFeedbackGenerator()
    generator.prepare()
    generator.notificationOccurred(type)
}
func isValidEmail(_ email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: email)
}


