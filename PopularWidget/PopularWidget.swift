//
//  PopularWidget.swift
//  PopularWidget
//
//  Created by Matthew Sousa on 5/12/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        let currentEntry = SimpleEntry(date: currentDate, configuration: configuration)
        entries.append(currentEntry)
        let tommorrow = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        let entry = SimpleEntry(date: tommorrow, configuration: configuration)
        entries.append(entry)
        

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct PopularWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        
//        Text(entry.date, style: .time)
//        StarBar(value: 5)
        
        PopularWidgetView()
            
    }
}

@main
struct PopularWidget: Widget {
    let kind: String = "PopularWidget"

    var body: some WidgetConfiguration {
        
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            PopularWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Most Popular Movie")
        .description("Updated each day to give you access to the most popular movie.")
        .supportedFamilies([.systemSmall])
    }
}

struct PopularWidget_Previews: PreviewProvider {
    static var previews: some View {
        PopularWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
