import SwiftUI
import SlideOverCard
import UIKit

struct EmailView: View {
    @Binding var contentState: CardContent
    @State private var email: String = ""
    @State private var isLoading: Bool = false
    @State private var isErrorVisible: Bool = false
    @State private var isButtonPressed: Bool = false
    
    @FocusState private var emailFieldFocused: Bool
    private let emailTitle = Globals.emailCollectionTitle
    private let emailDesc = Globals.emailCollectionDesc
    private let appIcon = Globals.appIcon
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            emailTitleGroup
            emailInputGroup
            if isErrorVisible {
                errorView
            }
            continueButton
            
        }.onTapGesture {
            
            emailFieldFocused = false
        }
        
    }
    
    private var errorView: some View {
        HStack {
            Spacer()
            HStack(spacing: 8) {
                Image(systemName: "exclamationmark.circle")
                    .foregroundColor(.red)
                    .imageScale(.medium)
                Text("Unable to process your request.")
                    .foregroundColor(.red)
                    .fontWeight(.medium)
                    .font(.caption)
            }
            .padding(.vertical, 10)
            .padding(.horizontal)
            .background(Color.red.opacity(0.1))
            .cornerRadius(10)
            Spacer()
        }
        .transition(.opacity)
        .animation(.easeIn, value: isErrorVisible)
        
    }
    
    private var emailTitleGroup: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 14) {
                Image(appIcon)
                    .resizable()
                    .frame(width: 60, height: 60)
                    .cornerRadius(10)
            }
            
            VStack (alignment: .leading, spacing: 6){
                Text(emailTitle)
                    .font(.title)
                    .bold()
                    .foregroundColor(.primary)
                
                Text(emailDesc)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            
            
        }
    }
    
    private var emailInputGroup: some View {
        HStack {
            Image("emailUpdate") // Icon inside the text field
                .resizable()
                .frame(width: 28, height: 28)
                .opacity(0.5)
                .foregroundColor(.secondary)
            
            TextField("Your email address", text: $email)
                .font(.system(size: 20))
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .frame(height: 54)
                .focused($emailFieldFocused)
                .submitLabel(.done)
        }
        .padding(.horizontal)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
        
        //        .onChange(of: email) { newValue, _ in
        //            isErrorVisible = !isValidEmail(newValue)
        //        }
    }
    private var continueButton: some View {
        VStack (alignment: .center) {
            
            Button(action: submitEmail) {
                if !isLoading {
                    Text("Submit")
                } else {
                    ProgressView()
                }
            }
            .buttonStyle(SOCActionButton())
            .disabled(!isValidEmail(email) || isLoading)
            .scaleEffect(isButtonPressed ? 0.96 : 1.0)
            .animation(.easeOut(duration: 0.3), value: isButtonPressed)
            .simultaneousGesture(
                LongPressGesture(minimumDuration: 0.03).onChanged { _ in
                    self.isButtonPressed = true
                }.onEnded { _ in
                    self.isButtonPressed = false
                }
            )
            
            Button("Not now") {
                triggerHapticFeedback()
                withAnimation {
                    contentState = .final
                }
            }
            .foregroundStyle(.secondary)
            .padding(.top)
        }
    }
    func submitEmail() {
        guard isValidEmail(self.email) else {
            withAnimation {
                isErrorVisible = true
                triggerNotificationFeedback(ofType: .error)
            }
            return
        }
        //Please don't see this and abuse my API
        let url = URL(string: "https://raviheyne.com/epicapi/submitEmail")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = ["email": self.email]
        request.httpBody = try? JSONEncoder().encode(body)
        
        isLoading = true
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    self.isErrorVisible = true
                    triggerNotificationFeedback(ofType: .error)
                    return
                }
                
                if data != nil {
                    //Decode server json if needed
                    withAnimation {
                        triggerNotificationFeedback(ofType: .success)
                        self.contentState = .final
                    }
                } else {
                    self.isErrorVisible = true
                    triggerNotificationFeedback(ofType: .error)
                }
            }
        }
        task.resume()
    }
}

struct EmailView_Previews: PreviewProvider {
    @State static var contentState: CardContent = .welcome
    
    static var previews: some View {
        EmailView(contentState: $contentState)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}



