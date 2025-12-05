import SwiftUI

struct CategoriesView: View {
    @EnvironmentObject var audioManager: AudioManager
    @State private var selectedCategory: MusicCategory?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Neural Music")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)
                
                Text("Choose your focus")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 20) {
                    ForEach(MusicCategory.allCases) { category in
                        CategoryCard(category: category) {
                            selectedCategory = category
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .navigationBarHidden(true)
            .sheet(item: $selectedCategory) { category in
                CategoryDetailView(category: category)
            }
        }
    }
}

struct CategoryCard: View {
    let category: MusicCategory
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: category.iconName)
                    .font(.system(size: 40))
                    .foregroundColor(.white)
                
                Text(category.rawValue)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Text(category.description)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(height: 160)
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(category.color),
                        Color(category.color).opacity(0.7)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(16)
            .shadow(color: Color(category.color).opacity(0.3), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CategoryDetailView: View {
    let category: MusicCategory
    @EnvironmentObject var audioManager: AudioManager
    @Environment(\.presentationMode) var presentationMode
    
    private var tracksForCategory: [MusicTrack] {
        MusicTrack.sampleTracks.filter { $0.category == category }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List(tracksForCategory) { track in
                    TrackRow(track: track) {
                        audioManager.selectTrack(track)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .navigationTitle(category.rawValue)
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(
                trailing: Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

struct TrackRow: View {
    let track: MusicTrack
    let action: () -> Void
    @EnvironmentObject var audioManager: AudioManager
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(track.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(track.artist)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(track.formattedDuration)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Button(action: {
                        audioManager.toggleSaved(track)
                    }) {
                        Image(systemName: audioManager.savedTracks.contains(track) ? "heart.fill" : "heart")
                            .foregroundColor(audioManager.savedTracks.contains(track) ? .red : .gray)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    CategoriesView()
        .environmentObject(AudioManager())
}