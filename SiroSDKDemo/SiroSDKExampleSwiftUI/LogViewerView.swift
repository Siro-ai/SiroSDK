import SwiftUI
import SiroSDK

struct LogViewerView: View {
    @ObservedObject var logDelegate = LogDelegate.shared
    @State private var searchText = ""
    @State private var selectedLevel: SiroSDKLogLevel? = nil
    @State private var selectedCategory: String? = nil
    @State private var showMetadata = false
    
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter
    }()
    
    var uniqueCategories: [String] {
        let categories = logDelegate.logs.map { $0.category }
        return Array(Set(categories)).sorted()
    }
    
    var filteredLogs: [SiroSDKLogEntry] {
        var logs = logDelegate.logs
        
        // Filter by level
        if let level = selectedLevel {
            logs = logs.filter { $0.level == level }
        }
        
        // Filter by category
        if let category = selectedCategory {
            logs = logs.filter { $0.category == category }
        }
        
        // Filter by search text (search in message, category, subcategory)
        if !searchText.isEmpty {
            logs = logs.filter { log in
                log.message.localizedCaseInsensitiveContains(searchText) ||
                log.category.localizedCaseInsensitiveContains(searchText) ||
                (log.subcategory?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }
        
        return logs
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Filter Controls
                VStack(spacing: 12) {
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search logs...", text: $searchText)
                            .textFieldStyle(PlainTextFieldStyle())
                        
                        if !searchText.isEmpty {
                            Button(action: { searchText = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    
                    // Level Filter
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 8) {
                            Text("Level:")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            FilterButton(
                                title: "All",
                                count: logDelegate.logs.count,
                                isSelected: selectedLevel == nil
                            ) {
                                selectedLevel = nil
                            }
                            
                            FilterButton(
                                title: "Debug",
                                count: logDelegate.logs.filter { $0.level == .debug }.count,
                                isSelected: selectedLevel == .debug,
                                color: .blue
                            ) {
                                selectedLevel = selectedLevel == .debug ? nil : .debug
                            }
                            
                            FilterButton(
                                title: "Info",
                                count: logDelegate.logs.filter { $0.level == .info }.count,
                                isSelected: selectedLevel == .info,
                                color: .green
                            ) {
                                selectedLevel = selectedLevel == .info ? nil : .info
                            }
                            
                            FilterButton(
                                title: "Error",
                                count: logDelegate.logs.filter { $0.level == .error }.count,
                                isSelected: selectedLevel == .error,
                                color: .red
                            ) {
                                selectedLevel = selectedLevel == .error ? nil : .error
                            }
                            
                            Spacer()
                        }
                        
                        // Category Filter
                        if !uniqueCategories.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    Text("Category:")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    
                                    FilterButton(
                                        title: "All",
                                        count: logDelegate.logs.count,
                                        isSelected: selectedCategory == nil
                                    ) {
                                        selectedCategory = nil
                                    }
                                    
                                    ForEach(uniqueCategories, id: \.self) { category in
                                        FilterButton(
                                            title: category.capitalized,
                                            count: logDelegate.logs.filter { $0.category == category }.count,
                                            isSelected: selectedCategory == category,
                                            color: categoryColor(for: category)
                                        ) {
                                            selectedCategory = selectedCategory == category ? nil : category
                                        }
                                    }
                                }
                                .padding(.horizontal, 1)
                            }
                        }
                        
                        // Options
                        HStack {
                            Toggle("Show Metadata", isOn: $showMetadata)
                                .font(.caption)
                            Spacer()
                        }
                    }
                    .font(.caption)
                }
                .padding()
                .background(Color(.systemBackground))
                
                Divider()
                
                // Logs List
                if filteredLogs.isEmpty {
                    VStack(spacing: 16) {
                        Spacer()
                        Image(systemName: searchText.isEmpty ? "tray" : "magnifyingglass")
                            .font(.system(size: 48))
                            .foregroundColor(.gray)
                        Text(searchText.isEmpty ? "No logs yet" : "No matching logs")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Text(searchText.isEmpty ? "SDK logs will appear here" : "Try adjusting your search or filters")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(Array(filteredLogs.enumerated()), id: \.element.id) { index, log in
                                LogEntryRow(log: log, timeFormatter: timeFormatter, showMetadata: showMetadata)
                                
                                if index < filteredLogs.count - 1 {
                                    Divider()
                                        .padding(.leading, 48)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("SDK Logs (\(filteredLogs.count))")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        logDelegate.clearLogs()
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                    .disabled(logDelegate.logs.isEmpty)
                }
            }
        }
    }
    
    private func categoryColor(for category: String) -> Color {
        switch category.lowercased() {
        case "recording": return .purple
        case "upload": return .orange
        case "network": return .cyan
        case "events": return .yellow
        case "lifecycle": return .indigo
        case "error": return .red
        default: return .gray
        }
    }
}

struct LogEntryRow: View {
    let log: SiroSDKLogEntry
    let timeFormatter: DateFormatter
    let showMetadata: Bool
    @State private var isExpanded = false
    
    var emoji: String {
        switch log.level {
        case .debug: return "🐛"
        case .info: return "ℹ️"
        case .error: return "❌"
        }
    }
    
    var levelColor: Color {
        switch log.level {
        case .debug: return .blue
        case .info: return .green
        case .error: return .red
        }
    }
    
    var body: some View {
        Button(action: { isExpanded.toggle() }) {
            HStack(alignment: .top, spacing: 12) {
                // Emoji Icon
                Text(emoji)
                    .font(.system(size: 20))
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 4) {
                    // Time, Level, and Category
                    HStack {
                        Text(timeFormatter.string(from: log.timestamp))
                            .font(.system(.caption, design: .monospaced))
                            .foregroundColor(.gray)
                        
                        Text(log.level.description)
                            .font(.system(.caption, design: .monospaced))
                            .foregroundColor(levelColor)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(levelColor.opacity(0.1))
                            .cornerRadius(4)
                        
                        Text(log.category.uppercased())
                            .font(.system(.caption2, design: .monospaced))
                            .foregroundColor(categoryColor(for: log.category))
                            .padding(.horizontal, 4)
                            .padding(.vertical, 1)
                            .background(categoryColor(for: log.category).opacity(0.1))
                            .cornerRadius(3)
                        
                        if let subcategory = log.subcategory {
                            Text(subcategory)
                                .font(.system(.caption2, design: .monospaced))
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 4)
                                .padding(.vertical, 1)
                                .background(Color(.systemGray6))
                                .cornerRadius(3)
                        }
                        
                        Spacer()
                        
                        if !isExpanded {
                            Image(systemName: "chevron.down")
                                .font(.caption2)
                                .foregroundColor(.gray)
                        } else {
                            Image(systemName: "chevron.up")
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    // Message
                    Text(log.message)
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(.primary)
                        .lineLimit(isExpanded ? nil : 3)
                        .fixedSize(horizontal: false, vertical: true)
                        .textSelection(.enabled)
                    
                    // Expanded details
                    if isExpanded {
                        VStack(alignment: .leading, spacing: 6) {
                            // Source information
                            if let source = log.source {
                                HStack {
                                    Text("Source:")
                                        .font(.system(.caption2, design: .monospaced))
                                        .foregroundColor(.secondary)
                                    Text("\(source.file):\(source.line) in \(source.function)")
                                        .font(.system(.caption2, design: .monospaced))
                                        .foregroundColor(.primary)
                                        .textSelection(.enabled)
                                }
                                .padding(.leading, 4)
                            }
                            
                            // Thread information
                            if log.thread != "main" {
                                HStack {
                                    Text("Thread:")
                                        .font(.system(.caption2, design: .monospaced))
                                        .foregroundColor(.secondary)
                                    Text(log.thread)
                                        .font(.system(.caption2, design: .monospaced))
                                        .foregroundColor(.primary)
                                        .textSelection(.enabled)
                                }
                                .padding(.leading, 4)
                            }
                            
                            // Metadata
                            if showMetadata && !log.metadata.isEmpty {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Metadata:")
                                        .font(.system(.caption2, design: .monospaced))
                                        .foregroundColor(.secondary)
                                    
                                    ForEach(log.metadata.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                                        HStack {
                                            Text("  \(key):")
                                                .font(.system(.caption2, design: .monospaced))
                                                .foregroundColor(.secondary)
                                            Text(value)
                                                .font(.system(.caption2, design: .monospaced))
                                                .foregroundColor(.primary)
                                                .textSelection(.enabled)
                                        }
                                    }
                                }
                                .padding(.leading, 4)
                            }
                        }
                        .padding(.top, 4)
                        .padding(.leading, 8)
                        .overlay(
                            Rectangle()
                                .frame(width: 2)
                                .foregroundColor(.gray.opacity(0.3)),
                            alignment: .leading
                        )
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .background(isExpanded ? Color(.systemGray6).opacity(0.5) : Color.clear)
    }
    
    private func categoryColor(for category: String) -> Color {
        switch category.lowercased() {
        case "recording": return .purple
        case "upload": return .orange
        case "network": return .cyan
        case "events": return .yellow
        case "lifecycle": return .indigo
        case "error": return .red
        default: return .gray
        }
    }
}

struct FilterButton: View {
    let title: String
    let count: Int
    var isSelected: Bool = false
    var color: Color = .primary
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Text(title)
                Text("(\(count))")
                    .foregroundColor(.gray)
            }
            .font(.caption)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(isSelected ? color.opacity(0.2) : Color(.systemGray6))
            .foregroundColor(isSelected ? color : .primary)
            .cornerRadius(6)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(isSelected ? color : Color.clear, lineWidth: 1)
            )
        }
    }
}

struct LogViewerView_Previews: PreviewProvider {
    static var previews: some View {
        LogViewerView()
    }
}

