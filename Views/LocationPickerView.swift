import SwiftUI
import MapKit

struct LocationPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = LocationPickerViewModel()
    @Binding var location: String
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search Bar
                SearchBar(text: $viewModel.searchQuery)
                    .padding()
                
                if !viewModel.searchResults.isEmpty {
                    // Search Results
                    List(viewModel.searchResults, id: \.self) { result in
                        Button(action: {
                            location = result.title
                            dismiss()
                        }) {
                            VStack(alignment: .leading) {
                                Text(result.title)
                                    .font(.headline)
                                Text(result.subtitle)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                } else {
                    // Map
                    Map(coordinateRegion: $viewModel.region,
                        showsUserLocation: true,
                        annotationItems: viewModel.annotations) { annotation in
                        MapAnnotation(coordinate: annotation.coordinate) {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(.red)
                                .font(.title)
                        }
                    }
                }
            }
            .navigationTitle("Choose Location")
            .navigationBarItems(
                leading: Button("Cancel") { dismiss() },
                trailing: Button("Select") {
                    location = viewModel.selectedLocation?.title ?? ""
                    dismiss()
                }
                .disabled(viewModel.selectedLocation == nil)
            )
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search location", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
    }
} 