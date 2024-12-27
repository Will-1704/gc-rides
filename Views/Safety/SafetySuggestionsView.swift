import SwiftUI

struct SafetySuggestionsView: View {
    @StateObject private var viewModel = SafetySuggestionsViewModel()
    
    var body: some View {
        List {
            // Priority Suggestions
            Section(header: Text("Priority Improvements")) {
                ForEach(viewModel.prioritySuggestions) { suggestion in
                    SuggestionRow(
                        suggestion: suggestion,
                        impact: .high
                    )
                }
            }
            
            // Component-based Suggestions
            ForEach(viewModel.componentSuggestions) { component in
                Section(header: Text(component.name)) {
                    ForEach(component.suggestions) { suggestion in
                        SuggestionRow(
                            suggestion: suggestion,
                            impact: component.impact
                        )
                    }
                }
            }
            
            // General Safety Tips
            Section(header: Text("General Safety Tips")) {
                ForEach(viewModel.safetyTips) { tip in
                    SafetyTipRow(tip: tip)
                }
            }
        }
        .navigationTitle("Safety Suggestions")
        .refreshable {
            await viewModel.loadSuggestions()
        }
    }
}

struct SuggestionRow: View {
    let suggestion: SafetySuggestion
    let impact: ImpactLevel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: suggestion.icon)
                    .foregroundColor(impact.color)
                Text(suggestion.title)
                    .font(.headline)
                Spacer()
                ImpactBadge(level: impact)
            }
            
            Text(suggestion.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            if let action = suggestion.action {
                Button(action: action.handler) {
                    Text(action.title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                .padding(.top, 4)
            }
        }
        .padding(.vertical, 8)
    }
} 