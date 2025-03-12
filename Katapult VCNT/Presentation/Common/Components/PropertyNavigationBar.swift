import SwiftUI

struct PropertyNavigationBar: View {
    @State private var isSearching = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Profile/Property Section
            HStack(spacing: 12) {
                ProfileImageView()
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Hotel Mai")
                        .font(.headline)
                    Text("107 Long Beach Blvd.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            // Action Buttons
            HStack(spacing: 16) {
                Button(action: { isSearching = true }) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.primary)
                }
                
                Button(action: { /* Add reservation action */ }) {
                    Image(systemName: "plus")
                        .foregroundColor(.primary)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .shadow(color: Color.black.opacity(0.1), radius: 4, y: 2)
    }
}

private struct ProfileImageView: View {
    var body: some View {
        Circle()
            .fill(Color.blue)
            .frame(width: 40, height: 40)
            .overlay(
                Text("H")
                    .foregroundColor(.white)
                    .font(.headline)
            )
    }
} 