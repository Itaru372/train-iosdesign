#if canImport(ActivityKit)
import WidgetKit
import SwiftUI
import ActivityKit

struct TrainLiveActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TrainActivityAttributes.self) { context in
            lockScreenView(context: context)
                .activityBackgroundTint(.accentColor.opacity(0.15))
                .activitySystemActionForegroundColor(.accentColor)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Label("\(context.state.remainingMinutes)分", systemImage: "clock.fill")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Label("\(context.state.remainingStations)駅", systemImage: "tram.fill")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text(context.attributes.destinationStationName)
                        .font(.headline)
                }
            } compactLeading: {
                Text("\(context.state.remainingMinutes)m")
            } compactTrailing: {
                Image(systemName: context.state.isDelayed ? "exclamationmark.triangle.fill" : "tram.fill")
            } minimal: {
                Image(systemName: "tram.fill")
            }
        }
    }

    @ViewBuilder
    private func lockScreenView(context: ActivityViewContext<TrainActivityAttributes>) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(context.attributes.routeName)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text("あと\(context.state.remainingMinutes)分")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                Text("残り\(context.state.remainingStations)駅")
                    .font(.headline)
                Text(context.attributes.destinationStationName)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
    }
}
#endif
