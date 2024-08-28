import SwiftUI
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift
import AuthenticationServices
import CryptoKit





@MainActor
final class AuthenticationViewModel: ObservableObject {
    
    
    @Published var didSignInWithApple: Bool = false
    let signInAppleHelper = SignInAppleHelper()
    
    func signInGoogle() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
    }
    
    func signInApple() async throws{
        signInAppleHelper.startSignInWithAppleFlow { [weak self] result in
            switch result {
            case .success(let userId):
                print("Apple sign-in successful. User ID: \(userId)")
                // Set the flag to true to hide the sign-in view
                self?.didSignInWithApple = true
            case .failure(let error):
                print("Apple sign-in failed with error: \(error.localizedDescription)")
                // Handle the error accordingly
                self?.didSignInWithApple = false
            }
        }
        
    }
}
    



struct AuthenticationView: View {
    
    @StateObject private var viewModel = AuthenticationViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack{
            
            NavigationLink {
                SignInEmailView(showSignInView: $showSignInView)
            } label: {
                Text("Sign in with Email")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.purple)
                    .cornerRadius(10)
            }
            
            GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .light, style: .wide,state: .normal)) {
                
                Task{
                    do {
                        try await viewModel.signInGoogle()
                        showSignInView = false
                    } catch {
                        print(error)
                    }
                }
                
            }
            
            SignInWithAppleButton(.signIn, onRequest: { request in
                            // Configure the request here
                            request.requestedScopes = [.fullName, .email]
                        }, onCompletion: { result in
                            switch result {
                            case .success(let authorization):
                                if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                                    Task {
                                        do {
                                            try await viewModel.signInApple()
                                            showSignInView = false
                                        } catch {
                                            print(error)
                                        }
                                    }
                                }
                            case .failure(let error):
                                print("Apple sign-in failed: \(error.localizedDescription)")
                            }
                        })
                        .signInWithAppleButtonStyle(.black)
            .frame(height: 55)
            Spacer()
        }
        .padding()
        .navigationTitle("Sign In")
    }
}

#Preview {
    NavigationStack{
        AuthenticationView(showSignInView: .constant(false))
    }
    
}
