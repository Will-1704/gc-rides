import MapKit
import Combine

class LocationPickerViewModel: ObservableObject {
    @Published var searchQuery = ""
    @Published var searchResults: [MKLocalSearchCompletion] = []
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 33.0801, longitude: -83.2321),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @Published var selectedLocation: LocationResult?
    @Published var annotations: [LocationAnnotation] = []
    
    private var searchCompleter = MKLocalSearchCompleter()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        searchCompleter.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 33.0801, longitude: -83.2321),
            latitudinalMeters: 5000,
            longitudinalMeters: 5000
        )
        
        $searchQuery
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] query in
                self?.searchCompleter.queryFragment = query
            }
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(
            for: NSNotification.Name.MKLocalSearchCompleterDidUpdateResults,
            object: searchCompleter
        )
        .sink { [weak self] _ in
            self?.searchResults = self?.searchCompleter.results ?? []
        }
        .store(in: &cancellables)
    }
}

struct LocationResult: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let coordinate: CLLocationCoordinate2D
}

struct LocationAnnotation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
} 