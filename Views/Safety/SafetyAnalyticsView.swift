import SwiftUI
import Charts

struct SafetyAnalyticsView: View {
    @StateObject private var viewModel = SafetyAnalyticsViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Overall Safety Score Trend
                Section(header: HeaderView(title: "Safety Score Trend")) {
                    Chart(viewModel.scoreHistory) { data in
                        LineMark(
                            x: .value("Date", data.date),
                            y: .value("Score", data.score)
                        )
                        .foregroundStyle(Color.green.gradient)
                        
                        AreaMark(
                            x: .value("Date", data.date),
                            y: .value("Score", data.score)
                        )
                        .foregroundStyle(Color.green.opacity(0.1))
                    }
                    .frame(height: 200)
                }
                
                // Component Breakdown
                Section(header: HeaderView(title: "Score Components")) {
                    LazyVGrid(columns: [.init(), .init()], spacing: 16) {
                        ForEach(viewModel.scoreComponents) { component in
                            ComponentCard(
                                title: component.name,
                                score: component.score,
                                trend: component.trend
                            )
                        }
                    }
                }
                
                // Safety Suggestions
                Section(header: HeaderView(title: "Improvement Suggestions")) {
                    ForEach(viewModel.suggestions) { suggestion in
                        SuggestionCard(suggestion: suggestion)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Safety Analytics")
        .refreshable {
            await viewModel.loadData()
        }
    }
} 