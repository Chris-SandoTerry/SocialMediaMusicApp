import SwiftUI

@MainActor
final class SignInEmailViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found.")
            return
        }
        
       
        try await AuthenticationManager.shared.createUser(email: email, password: password)
        
    }
    
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found.")
            return
        }
        
       
        try await AuthenticationManager.shared.signInUser(email: email, password: password)
        
    }
}

struct SignInEmailView: View {
    
    
    @StateObject private var viewModel = SignInEmailViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        
        Text("Welcome to Muxic")
            .font(.headline)
            .dynamicTypeSize(.xLarge)
        
        VStack{
            
            TextField("Email", text: $viewModel.email)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            
            SecureField("Password", text: $viewModel.password)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            
            Button {
                Task{
                    do {
                        try await viewModel.signIn()
                        showSignInView = false
                        return
                    }
                    catch {
                        print(error)
                    }
                }
            } label: {
                Text("Sign In")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.purple)
                    .cornerRadius(10)
            }
            
            Button{
                Task {
                    do {
                        try await viewModel.signUp()
                        showSignInView = false
                        return
                    }
                    catch {
                        print(error)
                    }
                
                }
            } label: {
                Text("Sign Up")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: 300)
                    .background(Color.purple)
                    .cornerRadius(10)
            }
            
        }
        .padding()
        .navigationTitle("Sign In With Email")
    }

}

#Preview {
    SignInEmailView(showSignInView: .constant(false))
}
