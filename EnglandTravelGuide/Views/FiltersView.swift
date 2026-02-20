import SwiftUI

struct FiltersView: View {

    var onDismiss: () -> Void
    var onApply: ((String, String, String) -> Void)?

    @State private var selectedRegion: String = "All Regions"
    @State private var selectedCategory: String = "All Categories"
    @State private var selectedStatus: String = "All"
    @State private var expandedSection: FilterSection?

    private let panelBackground = Color(r: 19, g: 17, b: 27)
    private let dropdownBackground = Color(r: 45, g: 37, b: 104)
    private let dropdownSelectedBackground = Color(r: 74, g: 64, b: 150)
    private let accentOrange = Color(r: 255, g: 94, b: 0)

    private let regionOptions = ["All Regions", "London", "South", "Midlands", "North", "Coast", "Countryside"]
    private let categoryOptions = ["All Categories", "Museums", "Royal & Historic", "Parks & Nature", "Castles", "Markets", "Family", "Free"]
    private let statusOptions = ["All", "Visited", "Not Visited", "Favorites"]

    enum FilterSection {
        case region, category, status
    }

    var body: some View {
        VStack(spacing: 0) {
            header

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    filterDropdown(
                        title: "Region",
                        section: .region,
                        selectedValue: selectedRegion,
                        options: regionOptions
                    ) { selectedRegion = $0 }

                    filterDropdown(
                        title: "Category",
                        section: .category,
                        selectedValue: selectedCategory,
                        options: categoryOptions
                    ) { selectedCategory = $0 }

                    filterDropdown(
                        title: "Status",
                        section: .status,
                        selectedValue: selectedStatus,
                        options: statusOptions
                    ) { selectedStatus = $0 }
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 24)
            }

            applyButton
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(panelBackground)
    }

    private var header: some View {
        HStack {
            Text("Filters")
                .font(.interBlack(size: 18))
                .foregroundStyle(.white)

            Spacer()

            Button {
                onDismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }

    private func filterDropdown(
        title: String,
        section: FilterSection,
        selectedValue: String,
        options: [String],
        onSelect: @escaping (String) -> Void
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.interBold(size: 14))
                .foregroundStyle(.white)

            VStack(spacing: 0) {
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        expandedSection = expandedSection == section ? nil : section
                    }
                } label: {
                    HStack {
                        Text(selectedValue)
                            .font(.interRegular(size: 16))
                            .foregroundStyle(.white)
                        Spacer()
                        Image(systemName: expandedSection == section ? "chevron.up" : "chevron.down")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.white.opacity(0.8))
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(dropdownBackground)
                }
                .buttonStyle(.plain)

                if expandedSection == section {
                    VStack(spacing: 0) {
                        ForEach(options, id: \.self) { option in
                            Button {
                                onSelect(option)
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    expandedSection = nil
                                }
                            } label: {
                                HStack {
                                    Text(option)
                                        .font(.interRegular(size: 16))
                                        .foregroundStyle(.white)
                                    Spacer()
                                    if option == selectedValue {
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundStyle(.white)
                                    }
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(option == selectedValue ? dropdownSelectedBackground : Color.clear)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .background(dropdownBackground)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    private var applyButton: some View {
        Button {
            onApply?(selectedRegion, selectedCategory, selectedStatus)
            onDismiss()
        } label: {
            Text("Apply Filters")
                .font(.interBold(size: 18))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(accentOrange)
                .clipShape(RoundedRectangle(cornerRadius: 100))
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 34)
    }
}

#Preview {
    FiltersView(onDismiss: {}, onApply: nil)
}
