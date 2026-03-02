import SwiftUI

struct AttractionsView: View {

    var onBack: (() -> Void)?
    var onSelectAttraction: ((String) -> Void)?

    @EnvironmentObject var appState: AppState
    @State private var searchText = ""
    @State private var showFilters = false
    @State private var filterRegion = "All Regions"
    @State private var filterCategory = "All Categories"
    @State private var filterStatus = "All"

    private let headerBackground = Color(r: 19, g: 17, b: 27)
    private let headerShadow = Color(r: 128, g: 115, b: 221)
    private let cardBackground = Color(r: 45, g: 37, b: 104)
    private let searchBackground = Color(r: 34, g: 31, b: 61)
    private let regionRed = Color(r: 180, g: 70, b: 70)
    private let regionOrange = Color(r: 255, g: 94, b: 0)
    private let regionPurple = Color(r: 128, g: 115, b: 221)
    private let detailTagBackground = Color(r: 55, g: 48, b: 90)

    private let attractions: [AttractionItem] = [
        AttractionItem(imageName: "attraction1", title: "Tower of London", description: "Historic castle on the Thames.", region: "London", regionColor: .red, detailTags: ["2-3 hours", "Family-friendly"]),
        AttractionItem(imageName: "attraction2", title: "British Museum", description: "World cultures and history under one roof.", region: "London", regionColor: .red, detailTags: ["2-4 hours", "Free"]),
        AttractionItem(imageName: "attraction3", title: "Stonehenge", description: "Prehistoric monument and mystery.", region: "South", regionColor: .orange, detailTags: ["1-2 hours", "Must-see"]),
        AttractionItem(imageName: "attraction4", title: "Lake District National Park", description: "Mountains, lakes, and literary heritage.", region: "North", regionColor: .red, detailTags: ["Full day", "Free"]),
        AttractionItem(imageName: "attraction5", title: "Windsor Castle", description: "The Queen's weekend residence.", region: "South", regionColor: .orange, detailTags: ["2-3 hours", "Royal"]),
        AttractionItem(imageName: "attraction6", title: "Roman Baths", description: "Ancient spa in the heart of Bath.", region: "South", regionColor: .orange, detailTags: ["1-2 hours", "Historic"]),
        AttractionItem(imageName: "attraction7", title: "Peak District National Park", description: "Rolling hills and historic estates.", region: "Midlands", regionColor: .purple, detailTags: ["Full day", "Free"]),
        AttractionItem(imageName: "attraction8", title: "York Minster", description: "Gothic masterpiece cathedral.", region: "North", regionColor: .red, detailTags: ["1-2 hours", "Historic"]),
        AttractionItem(imageName: "attraction9", title: "Jurassic Coast", description: "185 million years of geological history.", region: "Coast", regionColor: .orange, detailTags: ["Full day", "Free"]),
        AttractionItem(imageName: "attraction10", title: "Warwick Castle", description: "Medieval fortress with 1,100 years of history.", region: "Midlands", regionColor: .purple, detailTags: ["3-4 hours", "Family-friendly"]),
        AttractionItem(imageName: "attraction11", title: "Camden Market", description: "Eclectic market in North London.", region: "London", regionColor: .red, detailTags: ["2-3 hours", "Free"]),
        AttractionItem(imageName: "attraction12", title: "Buckingham Palace", description: "The King's official London residence.", region: "London", regionColor: .red, detailTags: ["2 hours", "Royal"]),
        AttractionItem(imageName: "attraction13", title: "Cotswolds", description: "Quintessential English villages.", region: "Countryside", regionColor: .red, detailTags: ["Full day", "Free"]),
        AttractionItem(imageName: "attraction14", title: "Kew Gardens", description: "World-leading botanical gardens.", region: "London", regionColor: .red, detailTags: ["3-4 hours", "Nature"]),
        AttractionItem(imageName: "attraction15", title: "Edinburgh Castle", description: "Historic fortress overlooking Scotland's capital.", region: "Scotland", regionColor: .red, detailTags: ["2-4 hours", "History", "Castles", "Family-friendly"]),
        AttractionItem(imageName: "attraction16", title: "Giant's Causeway", description: "Unique natural rock formation on the coast.", region: "Northern Ireland", regionColor: .orange, detailTags: ["2-3 hours", "Nature", "UNESCO", "Family-friendly"]),
        AttractionItem(imageName: "attraction17", title: "Snowdonia National Park", description: "Mountain landscapes and dramatic Welsh scenery.", region: "Wales", regionColor: .purple, detailTags: ["4-8 hours", "Nature", "Hiking", "Family-friendly"]),
        AttractionItem(imageName: "attraction18", title: "The Shard", description: "London's tallest skyscraper with panoramic views.", region: "London", regionColor: .red, detailTags: ["1-2 hours", "City Views", "Family-friendly"])
    ]

    private var filteredAttractions: [AttractionItem] {
        var list = attractions
        if !searchText.isEmpty {
            let q = searchText.lowercased()
            list = list.filter { $0.title.lowercased().contains(q) || $0.description.lowercased().contains(q) }
        }
        if filterRegion != "All Regions" {
            list = list.filter { $0.region == filterRegion }
        }
        if filterCategory != "All Categories" {
            list = list.filter { item in
                item.detailTags.contains { $0.lowercased().contains(filterCategory.prefix(5).lowercased()) } ||
                item.title.lowercased().contains(filterCategory.prefix(5).lowercased())
            }
        }
        switch filterStatus {
        case "Visited": list = list.filter { appState.isVisited($0.imageName) }
        case "Not Visited": list = list.filter { !appState.isVisited($0.imageName) }
        case "Favorites": list = list.filter { appState.isFavorite($0.imageName) }
        default: break
        }
        return list
    }

    var body: some View {
        VStack(spacing: 0) {
            header

            VStack(alignment: .leading, spacing: 0) {
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 16) {
                        ForEach(Array(filteredAttractions.enumerated()), id: \.element.imageName) { _, item in
                            Button {
                                onSelectAttraction?(item.imageName)
                            } label: {
                                attractionCard(item: item)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.bottom, 32)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Image(.mainBackground)
                .resizable()
                .ignoresSafeArea()
        }
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
                        }
                    )
                    .frame(width: min(320, UIScreen.main.bounds.width * 0.85))
                    .frame(maxHeight: .infinity)
                    .transition(.move(edge: .trailing))
                }
                .animation(.easeInOut(duration: 0.3), value: showFilters)
            }
        }
    }

    private var header: some View {
        VStack(spacing: 14) {
            HStack(spacing: 20) {
                Button {
                    onBack?()
                } label: {
                    Image(.backButton)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 36, height: 36)
                }
                .buttonStyle(.plain)
                
                Text("Attractions")
                    .font(.interBlack(size: 18))
                    .foregroundStyle(.white)
                Spacer()
            }
            
            searchAndFilterBar
            
            Text("\(filteredAttractions.count) attractions")
                .font(.interRegular(size: 12))
                .foregroundStyle(.white)
        }
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

    private func attractionCard(item: AttractionItem) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Image(item.imageName)
                .resizable()
                .frame(height: 180)

            VStack(alignment: .leading, spacing: 12) {
                Text(item.title)
                    .font(.interBold(size: 18))
                    .foregroundStyle(.white)

                HStack {
                    Text(item.description)
                        .font(.interRegular(size: 14))
                        .foregroundStyle(.white.opacity(0.5))
                 
                    Spacer()
                    
                    HStack(spacing: 6) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.system(size: 12))
                        Text(item.region)
                            .font(.interRegular(size: 12))
                    }
                    .foregroundStyle(regionOrange)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(regionOrange.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                }

                HStack(spacing: 8) {
                    ForEach(item.detailTags, id: \.self) { tag in
                        Text(tag)
                            .font(.interRegular(size: 12))
                            .foregroundStyle(.white)
                            .padding(7)
                            .background(.white.opacity(0.04))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .overlay {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(.white.opacity(0.2), lineWidth: 1)
                            }
                    }
                    Spacer(minLength: 0)
                }
            }
            .padding(16)
        }
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

private struct AttractionItem {
    let imageName: String
    let title: String
    let description: String
    let region: String
    let regionColor: RegionColor
    let detailTags: [String]

    enum RegionColor {
        case red, orange, purple
    }
}

#Preview {
    AttractionsView()
        .environmentObject(AppState())
}
