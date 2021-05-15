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
import Combine


struct Provider: IntentTimelineProvider {
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(),
                    reference: [PopularReference(poster: UIImage(named:"placeholder")!)])
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(),
                                reference: [PopularReference(poster: UIImage(named:"placeholder")!)])
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        WidgetImageProvider.getImageFromApi() { imageResponse in
            var entries: [SimpleEntry] = []
            var policy: TimelineReloadPolicy
            var entry: SimpleEntry
            
            switch imageResponse {
            case .Failure:
                entry = SimpleEntry(date: Date(),
                                    reference: [PopularReference(poster: UIImage(named:"placeholder")!)])
                policy = .after(Calendar.current.date(byAdding: .minute, value: 10, to: Date())!)
                break
            case .Success(let reference):
                entry = SimpleEntry(date: Date(),
                                    reference: reference)
                policy = .after(Calendar.current.date(byAdding: .day, value: 1, to: Date())!)
               break
            }
            entries.append(entry)
            let timeline = Timeline(entries: entries, policy: policy)
            completion(timeline)
            
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    public let reference: [PopularReference]
}

struct PopularWidgetEntryView : View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    
    var entry: Provider.Entry

    @ViewBuilder
    var body: some View {

        switch family {
        case .systemMedium:
            if let firstRefrence = entry.reference.first {
                MediumPopularWidgetView(reference: firstRefrence)
            }
        default:
            if let firstRefrence = entry.reference.first {
                SmallPopularWidgetView(reference: firstRefrence)
            }
        }
        
            
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
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
//
//struct PopularWidget_Previews: PreviewProvider {
//    static var previews: some View {
//        PopularWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), reference: PopularReference() ))
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
//    }
//}
