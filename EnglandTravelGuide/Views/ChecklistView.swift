import SwiftUI

struct ChecklistView: View {

    var onViewAllSteps: (() -> Void)?

    @EnvironmentObject var appState: AppState

    private let headerBackground = Color(r: 19, g: 17, b: 27)
    private let headerShadow = Color(r: 128, g: 115, b: 221)
    private let cardBackground = Color(r: 45, g: 37, b: 104)
    private let tagBackground = Color(r: 243, g: 58, b: 150)
    private let accentOrange = Color(r: 255, g: 94, b: 0)

    var body: some View {
        VStack(spacing: 0) {
            header

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    currentStepSection

                    nextUpSection

                    viewAllStepsButton

                    statusCards
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
        VStack(spacing: 20) {
            Text("Discove England")
                .font(.interBlack(size: 18))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            overallProgressSection
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            headerBackground
                .ignoresSafeArea()
                .shadow(color: headerShadow.opacity(0.5), radius: 8, x: 0, y: 4)
        )
    }

    private var overallProgressSection: some View {
        let completed = appState.completedChecklistCount
        let total = ChecklistProgressService.totalStepCount
        let progress = total > 0 ? CGFloat(completed) / CGFloat(total) : 0
        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Overall Progress")
                    .font(.interRegular(size: 12))
                    .foregroundStyle(.white)
                Spacer()
                Text("\(completed) of \(total) completed")
                    .font(.interBold(size: 12))
                    .foregroundStyle(.white)
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(cardBackground)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(headerShadow)
                        .frame(width: geometry.size.width * progress)
                }
            }
            .frame(height: 8)

            Text("\(Int(progress * 100))% complete")
                .font(.interRegular(size: 12))
                .foregroundStyle(.white.opacity(0.6))
        }
    }

    private var currentStepInfo: ChecklistStepInfo? {
        ChecklistProgressService.allSteps().first { !appState.isChecklistStepCompleted($0.id) }
    }

    private var nextStepInfo: ChecklistStepInfo? {
        let steps = ChecklistProgressService.allSteps()
        guard let idx = steps.firstIndex(where: { !appState.isChecklistStepCompleted($0.id) }) else { return nil }
        let nextIdx = steps.index(after: idx)
        return nextIdx < steps.endIndex ? steps[nextIdx] : nil
    }

    private var currentStepSection: some View {
        let sectionTitle: String = currentStepInfo.flatMap { step in
            ChecklistProgressService.sections.first { $0.sectionIndex == step.sectionIndex }?.title ?? ""
        } ?? ""
        return VStack(alignment: .leading, spacing: 12) {
            Text("Current Step")
                .font(.interBold(size: 14))
                .foregroundStyle(.white)

            if let step = currentStepInfo {
                stepCard(
                    tag: sectionTitle,
                    title: step.title,
                    description: "\(step.attractionsCount) attraction\(step.attractionsCount == 1 ? "" : "s") to explore.",
                    showButton: true,
                    buttonTitle: "Start This Step",
                    action: onViewAllSteps
                )
            } else {
                stepCard(
                    tag: "Done",
                    title: "All steps completed!",
                    description: "You've explored England's checklist.",
                    showButton: false,
                    buttonTitle: nil,
                    action: nil
                )
            }
        }
    }

    private var nextUpSection: some View {
        let sectionTitle: String = nextStepInfo.flatMap { step in
            ChecklistProgressService.sections.first { $0.sectionIndex == step.sectionIndex }?.title ?? ""
        } ?? ""
        return VStack(alignment: .leading, spacing: 12) {
            Text("Next Up")
                .font(.interBold(size: 18))
                .foregroundStyle(.white)

            if let step = nextStepInfo {
                stepCard(
                    tag: sectionTitle,
                    title: step.title,
                    description: "\(step.attractionsCount) attraction\(step.attractionsCount == 1 ? "" : "s").",
                    showButton: false,
                    buttonTitle: nil,
                    action: nil
                )
            }
        }
    }

    private func stepCard(tag: String, title: String, description: String, showButton: Bool, buttonTitle: String?, action: (() -> Void)?) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(tag)
                .font(.interRegular(size: 12))
                .foregroundStyle(tagBackground)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(tagBackground.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 6))

            Text(title)
                .font(.interBold(size: 18))
                .foregroundStyle(.white)

            Text(description)
                .font(.interRegular(size: 14))
                .foregroundStyle(.white)

            if showButton, let title = buttonTitle {
                Button {
                    action?()
                } label: {
                    Text(title)
                        .font(.interBold(size: 18))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(accentOrange)
                        .clipShape(RoundedRectangle(cornerRadius: 100))
                }
                .buttonStyle(.plain)
                .padding(.top, 4)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var viewAllStepsButton: some View {
        Button {
            onViewAllSteps?()
        } label: {
            Text("View All Steps (\(ChecklistProgressService.totalStepCount))")
                .font(.interBold(size: 18))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .overlay {
                    RoundedRectangle(cornerRadius: 100)
                        .stroke(.white, lineWidth: 1)
                }
        }
        .buttonStyle(.plain)
    }

    private var statusCards: some View {
        let completed = appState.completedChecklistCount
        let remaining = ChecklistProgressService.totalStepCount - completed
        return HStack(spacing: 16) {
            statusCard(number: "\(completed)", label: "Step Completed")
            statusCard(number: "\(remaining)", label: "Steps Remaining")
        }
    }

    private func statusCard(number: String, label: String) -> some View {
        VStack(alignment: .leading, spacing: 24) {
            Text(number)
                .font(.interBold(size: 24))
                .foregroundStyle(accentOrange)

            Text(label)
                .font(.interRegular(size: 14))
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    ChecklistView()
        .environmentObject(AppState())
}
