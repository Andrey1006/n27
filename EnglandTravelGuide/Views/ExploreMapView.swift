import SwiftUI
import MapKit

struct ExploreMapView: View {

    @EnvironmentObject var appState: AppState
    var onSelectAttraction: ((String) -> Void)?

    @State private var searchText = ""
    @State private var showFilters = false
    @State private var filterRegion = "All Regions"
    @State private var filterCategory = "All Categories"
    @State private var filterStatus = "All"
    @State private var selectedItem: MapAttractionItem?
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 52.4, longitude: -1.5),
        span: MKCoordinateSpan(latitudeDelta: 4.2, longitudeDelta: 3.5)
    )

    private let headerBackground = Color(r: 19, g: 17, b: 27)
    private let headerShadow = Color(r: 128, g: 115, b: 221)
    private let searchBackground = Color(r: 34, g: 31, b: 61)
    private let cardBackground = Color(r: 45, g: 37, b: 104)
    private let accentOrange = Color(r: 255, g: 94, b: 0)
    private let pinNotVisited = Color(r: 255, g: 94, b: 0)
    private let pinVisited = Color(r: 128, g: 115, b: 221)
    private let pinFavorite = Color(r: 243, g: 58, b: 150)

    private static let baseMapItems: [(attractionId: String, title: String, subtitle: String, region: String, lat: Double, lon: Double)] = [
        ("attraction1", "Tower of London", "Historic castle on the Thames", "London", 51.5081, -0.0759),
        ("attraction2", "British Museum", "World cultures and history under one roof", "London", 51.5194, -0.1270),
        ("attraction3", "Stonehenge", "Prehistoric monument and mystery", "South", 51.1789, -1.8262),
        ("attraction4", "Lake District National Park", "Mountains, lakes, and literary heritage", "North", 54.4609, -3.0886),
        ("attraction5", "Windsor Castle", "The Queen's weekend residence", "South", 51.4839, -0.6044),
        ("attraction6", "Roman Baths", "Ancient spa in the heart of Bath", "South", 51.3804, -2.3660),
        ("attraction7", "Peak District National Park", "Rolling hills and historic estates", "Midlands", 53.3498, -1.8000),
        ("attraction8", "York Minster", "Gothic masterpiece cathedral", "North", 53.9620, -1.0819),
        ("attraction9", "Jurassic Coast", "185 million years of geological history", "Coast", 50.7050, -2.5550),
        ("attraction10", "Warwick Castle", "Medieval fortress with 1,100 years of history", "Midlands", 52.2794, -1.5849),
        ("attraction11", "Camden Market", "Eclectic market in North London", "London", 51.5392, -0.1466),
        ("attraction12", "Buckingham Palace", "The King's official London residence", "London", 51.5014, -0.1419),
        ("attraction13", "Cotswolds", "Quintessential English villages", "Countryside", 51.8860, -1.7600),
        ("attraction14", "Kew Gardens", "World-leading botanical gardens", "London", 51.4847, -0.2947),
        ("attraction15", "Edinburgh Castle", "Historic fortress overlooking Scotland's capital", "Scotland", 55.9486, -3.2008),
        ("attraction16", "Giant's Causeway", "Unique natural rock formation on the coast", "Northern Ireland", 55.2408, -6.5116),
        ("attraction17", "Snowdonia National Park", "Mountain landscapes and dramatic Welsh scenery", "Wales", 53.0685, -4.0762),
        ("attraction18", "The Shard", "London's tallest skyscraper with panoramic views", "London", 51.5045, -0.0865)
    ]

    private var filteredBaseItems: [(attractionId: String, title: String, subtitle: String, region: String, lat: Double, lon: Double)] {
        var list = ExploreMapView.baseMapItems

        if !searchText.isEmpty {
            let q = searchText.lowercased()
            list = list.filter { $0.title.lowercased().contains(q) || $0.subtitle.lowercased().contains(q) }
        }

        if filterRegion != "All Regions" {
            list = list.filter { $0.region == filterRegion }
        }

        if filterCategory != "All Categories" {
            list = list.filter { base in
                let detail = AttractionDetailService.detail(for: base.attractionId)
                return matchesCategory(detail: detail, baseTitle: base.title, category: filterCategory)
            }
        }

        switch filterStatus {
        case "Visited":
            list = list.filter { appState.isVisited($0.attractionId) }
        case "Not Visited":
            list = list.filter { !appState.isVisited($0.attractionId) }
        case "Favorites":
            list = list.filter { appState.isFavorite($0.attractionId) }
        default:
            break
        }

        return list
    }

    private var mapItems: [MapAttractionItem] {
        filteredBaseItems.map { base in
            let state: MapPinState
            if appState.isFavorite(base.attractionId) { state = .favorite }
            else if appState.isVisited(base.attractionId) { state = .visited }
            else { state = .notVisited }
            return MapAttractionItem(attractionId: base.attractionId, title: base.title, subtitle: base.subtitle, region: base.region, latitude: base.lat, longitude: base.lon, pinState: state)
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            header

            VStack(alignment: .leading, spacing: 12) {
                searchAndFilterBar
                legend
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 12)
            .background(headerBackground)

            ZStack(alignment: .bottom) {
                MapViewRepresentable(
                    items: mapItems,
                    region: $region,
                    selectedItem: $selectedItem
                )
                .ignoresSafeArea(edges: .bottom)

                if let item = selectedItem {
                    floatingCard(item: item)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 24)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(headerBackground)
        .overlay {
            if showFilters {
                ZStack(alignment: .trailing) {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture { withAnimation(.easeInOut(duration: 0.3)) { showFilters = false } }

                    FiltersView(
                        onDismiss: { withAnimation(.easeInOut(duration: 0.3)) { showFilters = false } },
                        onApply: { region, category, status in
                            filterRegion = region
                            filterCategory = category
                            filterStatus = status
                            refreshSelectionIfNeeded()
                        }
                    )
                    .frame(width: min(320, UIScreen.main.bounds.width * 0.85))
                    .frame(maxHeight: .infinity)
                    .transition(.move(edge: .trailing))
                }
                .animation(.easeInOut(duration: 0.3), value: showFilters)
            }
        }
        .onChange(of: searchText) { _ in refreshSelectionIfNeeded() }
        .onChange(of: filterRegion) { _ in refreshSelectionIfNeeded() }
        .onChange(of: filterCategory) { _ in refreshSelectionIfNeeded() }
        .onChange(of: filterStatus) { _ in refreshSelectionIfNeeded() }
    }

    private func refreshSelectionIfNeeded() {
        guard let selectedItem else { return }
        let allowedIds = Set(mapItems.map(\.attractionId))
        if !allowedIds.contains(selectedItem.attractionId) {
            self.selectedItem = nil
        }
    }

    private func matchesCategory(detail: AttractionDetail?, baseTitle: String, category: String) -> Bool {
        let title = (detail?.title ?? baseTitle).lowercased()
        let tags = (detail?.tags ?? []).map { $0.lowercased() }

        switch category {
        case "Museums":
            return title.contains("museum") || tags.contains(where: { $0.contains("museum") }) || tags.contains(where: { $0.contains("museums") })
        case "Royal & Historic":
            return tags.contains(where: { $0.contains("royal") }) || tags.contains(where: { $0.contains("historic") })
        case "Parks & Nature":
            return title.contains("national park") || tags.contains(where: { $0.contains("parks") }) || tags.contains(where: { $0.contains("nature") })
        case "Castles":
            return title.contains("castle")
        case "Markets":
            return title.contains("market")
        case "Family":
            return tags.contains(where: { $0.contains("family") })
        case "Free":
            return tags.contains(where: { $0.contains("free") })
        default:
            return true
        }
    }

    private var header: some View {
        Text("Explore Map")
            .font(.interBlack(size: 18))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                headerBackground
                    .ignoresSafeArea()
                    .shadow(color: headerShadow.opacity(0.5), radius: 8, x: 0, y: 4)
            )
    }

    private var searchAndFilterBar: some View {
        HStack(spacing: 12) {
            HStack(spacing: 8) {
                TextField("", text: $searchText, prompt:
                    Text("Search attractions")
                        .font(.interRegular(size: 14))
                        .foregroundColor(.white.opacity(0.5))
                )
                .font(.interRegular(size: 14))
                .foregroundStyle(.white)
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 16))
                    .foregroundStyle(.white.opacity(0.5))
            }
            .padding(20)
            .background(searchBackground)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            Button {
                withAnimation(.easeInOut(duration: 0.3)) { showFilters = true }
            } label: {
                Image(.optionButton)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
            }
            .buttonStyle(.plain)
        }
    }

    private var legend: some View {
        HStack(spacing: 16) {
            legendItem(color: pinNotVisited, text: "Not visited")
            legendItem(color: pinVisited, text: "Visited")
            legendItem(color: pinFavorite, text: "Favorite")
        }
    }

    private func legendItem(color: Color, text: String) -> some View {
        HStack(spacing: 6) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            Text(text)
                .font(.interRegular(size: 12))
                .foregroundStyle(.white.opacity(0.8))
        }
    }

    private func floatingCard(item: MapAttractionItem) -> some View {
        Button {
            onSelectAttraction?(item.attractionId)
        } label: {
            HStack(spacing: 12) {
                Image(item.attractionId)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 72, height: 72)
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.interBold(size: 16))
                        .foregroundStyle(.white)
                        .lineLimit(1)
                    Text(item.subtitle)
                        .font(.interRegular(size: 14))
                        .foregroundStyle(.white.opacity(0.7))
                        .lineLimit(1)
                    Text(item.region)
                        .font(.interRegular(size: 12))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(accentOrange)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                Spacer(minLength: 0)
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.6))
            }
            .padding(12)
            .background(cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(accentOrange.opacity(0.5), lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
    }
}

struct MapAttractionItem: Identifiable {
    let id: String
    let attractionId: String
    let title: String
    let subtitle: String
    let region: String
    let coordinate: CLLocationCoordinate2D
    let pinState: MapPinState

    init(attractionId: String, title: String, subtitle: String, region: String, latitude: Double, longitude: Double, pinState: MapPinState) {
        self.id = attractionId
        self.attractionId = attractionId
        self.title = title
        self.subtitle = subtitle
        self.region = region
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.pinState = pinState
    }
}

enum MapPinState {
    case notVisited
    case visited
    case favorite
}

private struct MapViewRepresentable: UIViewRepresentable {

    let items: [MapAttractionItem]
    @Binding var region: MKCoordinateRegion
    @Binding var selectedItem: MapAttractionItem?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.overrideUserInterfaceStyle = .dark
        mapView.region = region
        mapView.showsUserLocation = false
        mapView.register(AttractionAnnotationView.self, forAnnotationViewWithReuseIdentifier: AttractionAnnotationView.reuseId)
        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.region = region
        let existingIds = Set(mapView.annotations.compactMap { $0 as? AttractionAnnotation }.map(\.attractionId))
        let currentIds = Set(items.map(\.attractionId))
        if existingIds != currentIds {
            mapView.removeAnnotations(mapView.annotations)
            let annotations = items.map { item in AttractionAnnotation(item: item) }
            mapView.addAnnotations(annotations)
        }
        for annotation in mapView.annotations {
            guard let ann = annotation as? AttractionAnnotation,
                  let view = mapView.view(for: annotation) as? AttractionAnnotationView else { continue }
            view.configure(with: ann.item, isSelected: selectedItem?.attractionId == ann.attractionId)
        }
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapViewRepresentable

        init(_ parent: MapViewRepresentable) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let ann = annotation as? AttractionAnnotation else { return nil }
            let view = mapView.dequeueReusableAnnotationView(withIdentifier: AttractionAnnotationView.reuseId, for: ann) as? AttractionAnnotationView
            view?.configure(with: ann.item, isSelected: parent.selectedItem?.attractionId == ann.attractionId)
            return view
        }

        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            guard let ann = view.annotation as? AttractionAnnotation else { return }
            parent.selectedItem = ann.item
        }
    }
}

private final class AttractionAnnotation: NSObject, MKAnnotation {
    let item: MapAttractionItem
    var coordinate: CLLocationCoordinate2D { item.coordinate }
    var attractionId: String { item.attractionId }

    init(item: MapAttractionItem) {
        self.item = item
    }
}

private final class AttractionAnnotationView: MKAnnotationView {

    static let reuseId = "AttractionAnnotationView"

    private let pinColorMap: [MapPinState: UIColor] = [
        .notVisited: UIColor(red: 255/255, green: 94/255, blue: 0/255, alpha: 1),
        .visited: UIColor(red: 128/255, green: 115/255, blue: 221/255, alpha: 1),
        .favorite: UIColor(red: 243/255, green: 58/255, blue: 150/255, alpha: 1)
    ]

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        frame = CGRect(x: 0, y: 0, width: 36, height: 36)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with item: MapAttractionItem, isSelected: Bool) {
        subviews.forEach { $0.removeFromSuperview() }
        let color = pinColorMap[item.pinState] ?? .orange
        let container = UIView()
        container.backgroundColor = color
        container.layer.cornerRadius = 8
        container.layer.borderWidth = 2
        container.layer.borderColor = isSelected ? UIColor.white.cgColor : UIColor.white.withAlphaComponent(0.5).cgColor
        if isSelected {
            container.layer.shadowColor = UIColor.white.cgColor
            container.layer.shadowRadius = 6
            container.layer.shadowOpacity = 0.6
        }
        container.translatesAutoresizingMaskIntoConstraints = false
        let icon = UIImage(systemName: "mappin.circle.fill")
        let imageView = UIImageView(image: icon)
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 20),
            imageView.heightAnchor.constraint(equalToConstant: 20)
        ])
        addSubview(container)
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.topAnchor.constraint(equalTo: topAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

#Preview {
    ExploreMapView()
}
