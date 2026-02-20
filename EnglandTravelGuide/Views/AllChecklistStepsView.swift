import SwiftUI

struct AllChecklistStepsView: View {

    var onBack: (() -> Void)?

    @EnvironmentObject var appState: AppState

    private let headerBackground = Color(r: 19, g: 17, b: 27)
    private let headerShadow = Color(r: 128, g: 115, b: 221)
    private let sectionBackground = Color(r: 45, g: 37, b: 104)
    private let accentOrange = Color(r: 255, g: 94, b: 0)

    var body: some View {
        VStack(spacing: 0) {
            header

            ScrollView(showsIndicators: false) {
                VStack(spacing: 14) {
                    ForEach(ChecklistProgressService.sections) { section in
                        sectionBlock(section: section)
                    }
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
            
            Text("All Checklist Steps")
                .font(.interBlack(size: 18))
                .foregroundStyle(.white)
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

    private func sectionBlock(section: ChecklistSectionInfo) -> some View {
        let completedInSection = section.steps.filter { appState.isChecklistStepCompleted($0.id) }.count
        let total = section.steps.count
        return VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text(section.title)
                    .font(.interBold(size: 14))
                    .foregroundStyle(.white)
                Spacer()
                Text("\(completedInSection)/\(total)")
                    .font(.interRegular(size: 14))
                    .foregroundStyle(.white)
            }
            .padding(.bottom, 12)

            ForEach(section.steps) { step in
                checklistRow(step: step)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(sectionBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func checklistRow(step: ChecklistStepInfo) -> some View {
        let isCompleted = appState.isChecklistStepCompleted(step.id)
        return Button {
            appState.toggleChecklistStep(step.id)
        } label: {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .stroke(accentOrange, lineWidth: 2)
                        .frame(width: 24, height: 24)
                    if isCompleted {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(accentOrange)
                    }
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text(step.title)
                        .font(.interBold(size: 14))
                        .foregroundStyle(.white)
                    Text(step.attractionsCount == 1 ? "1 attraction" : "\(step.attractionsCount) attractions")
                        .font(.interRegular(size: 12))
                        .foregroundStyle(.white)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.8))
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    AllChecklistStepsView()
        .environmentObject(AppState())
}
