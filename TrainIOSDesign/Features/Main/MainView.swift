import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = TrainStatusViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                header
                etaCard
                controls
                Spacer()
            }
            .padding(20)
            .navigationTitle("TrainIOSDesign")
            .background(Color(.systemGroupedBackground))
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(viewModel.routeName)
                .font(.headline)
            Text(viewModel.destinationStationName)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var etaCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                Text("あと")
                    .font(.title3)
                    .foregroundStyle(.secondary)
                Text("\(viewModel.remainingMinutes)")
                    .font(.system(size: 56, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.accentColor)
                    .contentTransition(.numericText())
                Text("分")
                    .font(.title2.weight(.semibold))
            }
            Text("残り \(viewModel.remainingStations) 駅")
                .font(.headline)
            Text(viewModel.statusText)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            if viewModel.isDelayed {
                Label("遅延反映済み", systemImage: "exclamationmark.triangle.fill")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.orange)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .animation(.spring(response: 0.35, dampingFraction: 0.85), value: viewModel.remainingMinutes)
    }

    private var controls: some View {
        VStack(spacing: 12) {
            Button {
                viewModel.setMockRoute()
                viewModel.startTracking()
            } label: {
                Label("自動トラッキング開始", systemImage: "play.circle.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)

            Button(role: .cancel) {
                viewModel.stopTracking()
            } label: {
                Label("停止", systemImage: "stop.circle")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
        }
    }
}

#Preview {
    MainView()
}
