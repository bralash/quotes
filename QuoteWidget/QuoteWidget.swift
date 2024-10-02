//
//  QuoteWidget.swift
//  QuoteWidget
//
//  Created by Emmanuel  Asaber on 10/1/24.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> QuoteEntry {
        QuoteEntry(date: Date(), quote: Quote(q: "Widget Placeholder", a: "Author", h: ""))
    }

    func getSnapshot(in context: Context, completion: @escaping (QuoteEntry) -> ()) {
        let entry = QuoteEntry(date: Date(), quote: SharedDataManager.shared.getRandomQuote() ?? Quote(q: "Widget Snapshot", a: "Author", h: ""))
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [QuoteEntry] = []
        let currentDate = Date()
        let midnight = Calendar.current.startOfDay(for: currentDate)
        let nextMidnight = Calendar.current.date(byAdding: .day, value: 1, to: midnight)!
        
        // Create an entry for each hour until midnight
        for hourOffset in 0..<24 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            if entryDate < nextMidnight {
                if let quote = SharedDataManager.shared.getRandomQuote() {
                    let entry = QuoteEntry(date: entryDate, quote: quote)
                    entries.append(entry)
                }
            }
        }
        
        // If no quotes are available, add a placeholder
        if entries.isEmpty {
            entries.append(QuoteEntry(date: currentDate, quote: Quote(q: "No quotes available", a: "Widget", h: "")))
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct QuoteEntry: TimelineEntry {
    let date: Date
    let quote: Quote
}

struct QuoteWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(entry.quote.q)
                .font(.system(size: 14, weight: .medium, design: .serif))
                .foregroundColor(.primary)
                .lineLimit(nil)
            Text("— \(entry.quote.a)")
                .font(.system(size: 12, weight: .regular, design: .serif))
                .foregroundColor(.secondary)
        }
        .padding()
        .modifier(WidgetBackgroundModifier())
    }
}

struct WidgetBackgroundModifier: ViewModifier {
    @Environment(\.widgetFamily) var family
    
    func body(content: Content) -> some View {
        if #available(iOSApplicationExtension 17.0, *) {
            content
                .containerBackground(for: .widget) {
                    Color.clear
                }
        } else {
            content
                .background(Color(UIColor.systemBackground))
        }
    }
}

struct QuoteWidget: Widget {
    let kind: String = "QuoteWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            QuoteWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Quote of the Day")
        .description("This widget displays an inspiring quote, updating hourly.")
        .supportedFamilies([.systemSmall, .systemMedium])
        .contentMarginsDisabled()
    }
}

struct QuoteWidget_Previews: PreviewProvider {
    static var previews: some View {
        QuoteWidgetEntryView(entry: QuoteEntry(date: Date(), quote: Quote(q: "Preview Quote", a: "Preview Author", h: "")))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

extension View {
    func widgetBackground(_ background: some View) -> some View {
        if #available(iOSApplicationExtension 17.0, *) {
            return containerBackground(for: .widget) {
                background
            }
        } else {
            return background
        }
    }
}
