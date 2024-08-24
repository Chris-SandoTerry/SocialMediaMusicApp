import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject {
    
    func signOut() throws{
        try AuthenticationManager.shared.signOut()
    }
    
    func resetPassword() async throws{
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        guard let email = authUser.email else {
            throw URLError(.fileDoesNotExist)
        }
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    
    func updateEmail() async throws {
        let email = ""
        try await AuthenticationManager.shared.updateEmail(email: email)
    }
    
    func updatePassword() async throws {
        let password = ""
        try await AuthenticationManager.shared.updatePassword(password: password)
    }
    
    
    
}




struct SettingsView: View {
    
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        List {
            Button("Log Out") {
                Task {
                    do {
                        try viewModel.signOut()
                        showSignInView = true
                    }
                    catch {
                        print("Failed to Sign Out")
                    }
                }
            }
               emailsection
            
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    NavigationStack {
        SettingsView(showSignInView: .constant(true))
    }
}

extension SettingsView {
    
    private var emailsection: some View {
        
        Section {
            
            Button("Reset Password") {
                Task {
                    do {
                        try await viewModel.resetPassword()
                        print("Password RESET!!")
                    }
                    catch {
                        print(error)
                    }
                }
            }
            
            Button("Update Password") {
                Task {
                    do {
                        try await viewModel.updatePassword()
                        print("Password RESET!!")
                    }
                    catch {
                        print(error)
                    }
                }
            }
            
            Button("Update Email") {
                Task {
                    do {
                        try await viewModel.updateEmail()
                        print("Email RESET!!")
                    }
                    catch {
                        print(error)
                    }
                }
            }
        } header: {
            Text("Account")
        }

    }
}
