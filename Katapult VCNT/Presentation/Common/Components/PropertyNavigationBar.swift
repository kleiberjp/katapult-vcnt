import SwiftUI

struct PropertyNavigationBar: View {
    @State private var isSearching = false
    @State private var showPropertySelector = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Profile/Property Section
            Button(action: { showPropertySelector = true }) {
                HStack(spacing: 12) {
                    ProfileImageView()
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Hotel Mai")
                            .font(.headline)
                        Text("107 Long Beach Blvd.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    Image(systemName: "chevron.down")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            Spacer()
            
            // Action Buttons
            HStack(spacing: 16) {
                Button(action: { isSearching = true }) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.green)
                        .padding(10)
                        .background(Circle().fill(Color.gray.opacity(0.15)))
                }
                
                Button(action: { /* Add reservation action */ }) {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Circle().fill(Color.green))
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .shadow(color: Color.black.opacity(0.1), radius: 4, y: 2)
        .sheet(isPresented: $showPropertySelector) {
            PropertySelectorView()
        }
    }
}

private struct ProfileImageView: View {
    var body: some View {
        Circle()
            .fill(Color.red)
            .frame(width: 40, height: 40)
            .overlay(
                Text("H")
                    .foregroundColor(.white)
                    .font(.headline)
            )
    }
}

// Property selector sheet
private struct PropertySelectorView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let properties = [
        Property(id: "1", name: "Hotel Mai", address: "107 Long Beach Blvd.", imageURL: nil),
        Property(id: "2", name: "Beach Resort", address: "500 Ocean Drive", imageURL: nil),
        Property(id: "3", name: "Mountain Lodge", address: "1200 Pine Road", imageURL: nil)
    ]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(properties) { property in
                    Button(action: {
                        // Would update selected property in a real app
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 32, height: 32)
                                .overlay(
                                    Text(String(property.name.prefix(1)))
                                        .foregroundColor(.white)
                                        .font(.subheadline)
                                )
                            
                            VStack(alignment: .leading) {
                                Text(property.name)
                                    .font(.headline)
                                Text(property.address)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                        }
                        .padding(.vertical, 4)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .navigationTitle("Select Property")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
} 