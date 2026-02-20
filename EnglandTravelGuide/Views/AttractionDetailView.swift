import SwiftUI

struct AttractionDetailView: View {

    let attractionId: String
    var onBack: (() -> Void)?

    @EnvironmentObject var appState: AppState

    private var detail: AttractionDetail? {
        AttractionDetailService.detail(for: attractionId)
    }

    private let headerBackground = Color(r: 19, g: 17, b: 27)
    private let headerShadow = Color(r: 128, g: 115, b: 221)
    private let cardBackground = Color(r: 45, g: 37, b: 104)
    private let sectionTitleColor = Color(r: 255, g: 166, b: 0)
    private let regionTagColor = Color(r: 200, g: 100, b: 60)
    private let detailTagBackground = Color(r: 55, g: 48, b: 90)
    private let saveButtonBackground = Color(r: 128, g: 115, b: 221)
    private let visitedButtonBackground = Color(r: 76, g: 175, b: 80)
    private let regionOrange = Color(r: 255, g: 94, b: 0)

    var body: some View {
        if let detail = detail {
            detailContent(detail: detail)
        } else {
            Text("No data")
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background { Image(.mainBackground).resizable().ignoresSafeArea() }
        }
    }

    private func detailContent(detail: AttractionDetail) -> some View {
        VStack(spacing: 0) {
            header(detail: detail)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    heroImage(detail: detail)

                    overviewTagCard

                    keyFactsCard(detail: detail)

                    sectionCard(icon: "info.circle", title: "Overview", content: detail.overviewText)

                    listSectionCard(icon: "star", title: "Highlights", items: detail.highlights)

                    sectionCard(icon: "book", title: "History & Context", content: detail.historyText)

                    listSectionCard(icon: "lightbulb", title: "Tips", items: detail.tips)

                    sectionCard(icon: "mappin.circle", title: "Getting There", content: detail.gettingThere)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 32)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Image(.mainBackground)
                .resizable()
                .ignoresSafeArea()
        }
    }

    private func header(detail: AttractionDetail) -> some View {
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

            Text(detail.title)
                .font(.interBlack(size: 18))
                .foregroundStyle(.white)
                .lineLimit(1)
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            headerBackground
                .ignoresSafeArea()
                .shadow(color: headerShadow.opacity(0.5), radius: 8, x: 0, y: 4)
        )
    }

    private func heroImage(detail: AttractionDetail) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Image(detail.imageName)
                .resizable()
                .frame(height: 220)

            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(detail.shortDescription)
                        .font(.interRegular(size: 14))
                        .foregroundStyle(.white.opacity(0.5))
                 
                    Spacer()
                    
                    HStack(spacing: 6) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.system(size: 12))
                        Text(detail.region)
                            .font(.interRegular(size: 12))
                    }
                    .foregroundStyle(regionOrange)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(regionOrange.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                }

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(detail.tags, id: \.self) { tag in
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
                    }
                }
            }
            .padding(16)
        }
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var overviewTagCard: some View {
        let isFavorite = appState.isFavorite(attractionId)
        let isVisited = appState.isVisited(attractionId)
        return VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Button {
                    appState.toggleFavorite(attractionId)
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .font(.system(size: 16))
                        Text(isFavorite ? "Saved" : "Save")
                            .font(.interBold(size: 14))
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(.white.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.white.opacity(0.2), lineWidth: 1)
                    }
                }
                .buttonStyle(.plain)

                if !isVisited {
                    Button {
                        appState.markVisited(attractionId)
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "checkmark.circle")
                                .font(.system(size: 16))
                            Text("Mark Visited")
                                .font(.interBold(size: 14))
                        }
                        .foregroundStyle(Color(r: 107, g: 222, b: 0))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color(r: 107, g: 222, b: 0).opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private func keyFactsCard(detail: AttractionDetail) -> some View {
        VStack(spacing: 30) {
            HStack(spacing: 12) {
                keyFactItem(icon: "clock", title: "Time Needed", value: detail.timeNeeded)
                keyFactItem(icon: "ticket", title: "Ticket Info", value: detail.ticketInfo)
            }
            HStack(spacing: 12) {
                keyFactItem(icon: "sun.max", title: "Best Season", value: detail.bestSeason)
                keyFactItem(icon: "figure.roll", title: "Accessibility", value: detail.accessibility)
            }
        }
        .padding(16)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private func keyFactItem(icon: String, title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundStyle(sectionTitleColor)
                Text(title)
                    .font(.interBold(size: 14))
                    .foregroundStyle(.white)
            }
            Text(value)
                .font(.interRegular(size: 14))
                .foregroundStyle(.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func sectionCard(icon: String, title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundStyle(sectionTitleColor)
                Text(title)
                    .font(.interBold(size: 16))
                    .foregroundStyle(sectionTitleColor)
            }
            Text(content)
                .font(.interRegular(size: 14))
                .foregroundStyle(.white)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private func listSectionCard(icon: String, title: String, items: [String]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Text(title)
                    .font(.interBold(size: 16))
                    .foregroundStyle(sectionTitleColor)
            }
            VStack(alignment: .leading, spacing: 16) {
                ForEach(items, id: \.self) { item in
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "star")
                            .font(.system(size: 10))
                            .foregroundStyle(sectionTitleColor)
                        Text(item)
                            .font(.interRegular(size: 14))
                            .foregroundStyle(.white)
                    }
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    AttractionDetailView(attractionId: "attraction11")
        .environmentObject(AppState())
}
