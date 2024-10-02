//
//  QuoteWidgetLiveActivity.swift
//  QuoteWidget
//
//  Created by Emmanuel  Asaber on 10/1/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct QuoteWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct QuoteWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: QuoteWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension QuoteWidgetAttributes {
    fileprivate static var preview: QuoteWidgetAttributes {
        QuoteWidgetAttributes(name: "World")
    }
}

extension QuoteWidgetAttributes.ContentState {
    fileprivate static var smiley: QuoteWidgetAttributes.ContentState {
        QuoteWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: QuoteWidgetAttributes.ContentState {
         QuoteWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: QuoteWidgetAttributes.preview) {
   QuoteWidgetLiveActivity()
} contentStates: {
    QuoteWidgetAttributes.ContentState.smiley
    QuoteWidgetAttributes.ContentState.starEyes
}
