import SwiftUI

struct ProgressView: View {

    var onBack: (() -> Void)?

    @EnvironmentObject var appState: AppState

    private let headerBackground = Color(r: 19, g: 17, b: 27)
    private let headerShadow = Color(r: 128, g: 115, b: 221)
    private let cardBackground = Color(r: 28, g: 23, b: 67)
    private let sectionCardBackground = Color(r: 45, g: 37, b: 104)
    private let accentOrange = Color(r: 255, g: 94, b: 0)
    private let sectionHeaderOrange = Color(r: 206, g: 140, b: 90)
    private let sectionHeaderGold = Color(r: 212, g: 175, b: 55)

    private let regionTotals: [(name: String, total: Int)] = [
        ("London", 5),
        ("South", 4),
        ("Midlands", 2),
        ("North", 2),
        ("Coast", 1),
        ("Countryside", 1)
    ]

    private var visitsByRegion: [String: Int] {
        var counts: [String: Int] = [:]
        for visit in appState.visits {
            if let detail = AttractionDetailService.detail(for: visit.attractionId) {
                counts[detail.region, default: 0] += 1
            }
        }
        return counts
    }

    private var londonCount: Int { visitsByRegion["London"] ?? 0 }
    private var castleCount: Int {
        appState.visits.filter { visit in
            let detail = AttractionDetailService.detail(for: visit.attractionId)
            return (detail?.title.lowercased().contains("castle") ?? false) ||
                (detail?.tags.contains { $0.lowercased().contains("castle") } ?? false)
        }.count
    }
    private var museumCount: Int {
        appState.visits.filter { visit in
            AttractionDetailService.detail(for: visit.attractionId)?.tags.contains { $0.lowercased().contains("museum") } ?? false
        }.count
    }

    var body: some View {
        VStack(spacing: 0) {
            header

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    checklistJourneyCard

                    statisticsGrid

                    regionsSection

                    achievementsSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
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

    private var header: some View {
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

            VStack(alignment: .leading, spacing: 2) {
                Text("Progress")
                    .font(.interBlack(size: 18))
                    .foregroundStyle(.white)
                Text("Track your journey through England")
                    .font(.interRegular(size: 12))
                    .foregroundStyle(.white.opacity(0.7))
            }
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

    private var checklistJourneyCard: some View {
        let completed = appState.completedChecklistCount
        let total = ChecklistProgressService.totalStepCount
        let progress = total > 0 ? Double(completed) / Double(total) : 0
        return VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: "point.topleft.down.to.point.bottomright.curvepath")
                    .font(.system(size: 28))
                    .foregroundStyle(headerShadow)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Checklist Journey")
                        .font(.interBold(size: 16))
                        .foregroundStyle(.white)
                    Text("\(completed) of \(total) steps")
                        .font(.interRegular(size: 14))
                        .foregroundStyle(.white.opacity(0.7))
                }
                Spacer()
            }

            progressBar(progress: progress)
            
            Text("\(Int(progress * 100))% complete")
                .font(.interRegular(size: 12))
                .foregroundStyle(.white.opacity(0.6))
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(sectionCardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var statisticsGrid: some View {
        let achievementsUnlocked = [londonCount >= 5, castleCount >= 3, museumCount >= 2, appState.visitedRegionsCount >= 6, appState.completedChecklistCount >= 20, false].filter { $0 }.count
        return LazyVGrid(columns: [GridItem(.flexible(), spacing: 20), GridItem(.flexible(), spacing: 20)], spacing: 20) {
            statCard(value: "\(appState.visitsTotalCount)", label: "Visits")
            statCard(value: "\(appState.favoriteIds.count)", label: "Favorites")
            statCard(value: "\(appState.completedChecklistCount)", label: "Steps Done")
            statCard(value: "\(achievementsUnlocked)", label: "Badges")
        }
    }

    private func statCard(value: String, label: String) -> some View {
        VStack(spacing: 40) {
            Text(value)
                .font(.interBold(size: 24))
                .foregroundStyle(accentOrange)
            Text(label)
                .font(.interRegular(size: 12))
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(sectionCardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var regionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "map")
                    .font(.system(size: 18))
                    .foregroundStyle(sectionHeaderOrange)
                Text("Regions Explored")
                    .font(.interBold(size: 16))
                    .foregroundStyle(.white)
            }

            ForEach(regionTotals, id: \.name) { region in
                let completed = visitsByRegion[region.name] ?? 0
                regionRow(name: region.name, completed: completed, total: region.total)
            }
        }
        .padding(16)
        .background(sectionCardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private func regionRow(name: String, completed: Int, total: Int) -> some View {
        let progress = total > 0 ? Double(completed) / Double(total) : 0
        return VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(name)
                    .font(.interBold(size: 12))
                    .foregroundStyle(.white)
                Spacer()
                Text("\(completed)/\(total)")
                    .font(.interRegular(size: 12))
                    .foregroundStyle(.white)
            }
            
            progressBar(progress: min(1, progress))
            
            Text("\(Int(progress * 100))% complete")
                .font(.interRegular(size: 12))
                .foregroundStyle(.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var achievementsSection: some View {
        let achievementsData: [(icon: String, title: String, description: String, current: Int, total: Int)] = [
            ("building.2", "London Explorer", "Visit 5 attractions in London", londonCount, 5),
            ("building.columns", "Castle Seeker", "Visit 3 castles", castleCount, 3),
            ("building.2.fill", "Museum Day", "Visit 2 museums", museumCount, 2),
            ("map", "Region Master", "Visit all 6 regions", appState.visitedRegionsCount, 6),
            ("target", "Checklist Champion", "Complete 20 checklist steps", appState.completedChecklistCount, 20),
            ("star", "Five Star", "Rate 5 attractions with 5 stars", 0, 5)
        ]
        let unlocked = achievementsData.filter { $0.current >= $0.total }.count
        return VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "trophy")
                    .font(.system(size: 18))
                    .foregroundStyle(sectionHeaderGold)
                Text("Achievements (\(unlocked)/6)")
                    .font(.interBold(size: 16))
                    .foregroundStyle(.white)
            }

            ForEach(Array(achievementsData.enumerated()), id: \.offset) { _, item in
                achievementCard(
                    icon: item.icon,
                    title: item.title,
                    description: item.description,
                    current: item.current,
                    total: item.total
                )
            }
        }
        .padding(16)
        .background(sectionCardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private func achievementCard(icon: String, title: String, description: String, current: Int, total: Int) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundStyle(headerShadow)
                    .frame(width: 40, height: 40)

                VStack(alignment: .leading, spacing: 10) {
                    Text(title)
                        .font(.interBold(size: 16))
                        .foregroundStyle(.white)
                    
                    Text(description)
                        .font(.interRegular(size: 12))
                        .foregroundStyle(.white)
                    
                    progressBar(progress: total > 0 ? Double(current) / Double(total) : 0)
                    
                    Text("\(current)/\(total)")
                        .font(.interRegular(size: 12))
                        .foregroundStyle(.white.opacity(0.5))
                }
                Spacer()
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private func progressBar(progress: Double) -> some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 100)
                    .fill(cardBackground)
                RoundedRectangle(cornerRadius: 100)
                    .fill(headerShadow)
                    .frame(width: geometry.size.width * progress)
            }
        }
        .frame(height: 8)
    }
}

#Preview {
    ProgressView()
        .environmentObject(AppState())
}
