import WidgetKit
import SwiftUI

// MARK: - 1. Timeline Provider (Reads from React Native App Group)
struct Provider: TimelineProvider {
    // Define the exact same App Group string used in JavaScript
    let sharedDefaults = UserDefaults(suiteName: "group.com.snapcalorie.data")

    func placeholder(in context: Context) -> SnapCalorieEntry {
        SnapCalorieEntry(date: Date(), currentCalories: 0, targetCalories: 2200, protein: 0, proteinTarget: 150, carbs: 0, carbsTarget: 200, fat: 0, fatTarget: 70)
    }

    func getSnapshot(in context: Context, completion: @escaping (SnapCalorieEntry) -> ()) {
        completion(fetchData())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let timeline = Timeline(entries: [fetchData()], policy: .never)
        completion(timeline)
    }
    
    // Helper function to pull the data saved by React Native
    private func fetchData() -> SnapCalorieEntry {
        let currentCal = sharedDefaults?.integer(forKey: "currentCalories") ?? 0
        let targetCal = sharedDefaults?.integer(forKey: "targetCalories") ?? 2200
        let pro = sharedDefaults?.integer(forKey: "protein") ?? 0
        let crb = sharedDefaults?.integer(forKey: "carbs") ?? 0
        let ft = sharedDefaults?.integer(forKey: "fat") ?? 0
        
        return SnapCalorieEntry(
            date: Date(),
            currentCalories: currentCal,
            targetCalories: targetCal,
            protein: pro,
            proteinTarget: 150,
            carbs: crb,
            carbsTarget: 200,
            fat: ft,
            fatTarget: 70
        )
    }
}

// MARK: - 2. Data Model
struct SnapCalorieEntry: TimelineEntry {
    let date: Date
    let currentCalories: Int
    let targetCalories: Int
    let protein: Int
    let proteinTarget: Int
    let carbs: Int
    let carbsTarget: Int
    let fat: Int
    let fatTarget: Int
}

// MARK: - 3. Widget UI View
struct SnapWidgetEntryView : View {
    var entry: Provider.Entry
    let snapGreen = Color(red: 0.07, green: 0.78, blue: 0.44)

    var body: some View {
        VStack {
            // TOP ROW
            HStack(alignment: .top) {
                HStack(spacing: 4) {
                    Image(systemName: "camera.macro")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(snapGreen)
                    Text("SnapCalorie")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 0) {
                    Text("\(entry.currentCalories)")
                        .font(.system(size: 28, weight: .heavy, design: .rounded))
                        .foregroundColor(snapGreen)
                    Text("of \(entry.targetCalories) kcal")
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundColor(.secondary)
                }
            }
            .padding(.top, 14)
            .padding(.horizontal, 16)
            
            Spacer()
            
            // BOTTOM ROW: Macros
            HStack(spacing: 16) {
                MacroRingView(title: "Protein", amount: entry.protein, target: entry.proteinTarget, color: .blue)
                MacroRingView(title: "Carbs", amount: entry.carbs, target: entry.carbsTarget, color: .orange)
                MacroRingView(title: "Fat", amount: entry.fat, target: entry.fatTarget, color: .red)
                Spacer()
            }
            .padding(.bottom, 14)
            .padding(.horizontal, 16)
        }
        .containerBackground(for: .widget) {
            Color(UIColor.systemBackground)
        }
    }
}

// MARK: - 4. Macro Ring Component
struct MacroRingView: View {
    let title: String
    let amount: Int
    let target: Int
    let color: Color
    var progress: Double { return min(Double(amount) / Double(max(target, 1)), 1.0) }
    
    var body: some View {
        HStack(spacing: 6) {
            ZStack {
                Circle().stroke(color.opacity(0.2), lineWidth: 4.5)
                Circle().trim(from: 0, to: progress)
                    .stroke(color, style: StrokeStyle(lineWidth: 4.5, lineCap: .round))
                    .rotationEffect(.degrees(-90))
            }
            .frame(width: 32, height: 32)
            VStack(alignment: .leading, spacing: 1) {
                Text("\(amount)g").font(.system(size: 14, weight: .bold, design: .rounded)).foregroundColor(.primary)
                Text(title).font(.system(size: 10, weight: .medium, design: .rounded)).foregroundColor(.secondary)
            }
        }
    }
}

// MARK: - 5. Main Widget Configuration
struct SnapWidget: Widget {
    let kind: String = "SnapWidget"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            SnapWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("SnapCalorie Tracker")
        .description("Track your daily calories and macros at a glance.")
        .supportedFamilies([.systemMedium])
    }
}
