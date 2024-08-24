import SwiftUI
import GoogleSignIn
import GoogleSignInSwift



@MainActor
final class AuthenticationViewModel: ObservableObject {
    
    func signInGoogle() async throws {
//        let something = GIDSignIn.sharedInstance.signIn(withPresenting: <#T##UIViewController#>)
        
        
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
                
            }
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
