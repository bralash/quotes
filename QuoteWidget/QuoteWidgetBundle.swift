//
//  QuoteWidgetBundle.swift
//  QuoteWidget
//
//  Created by Emmanuel  Asaber on 10/1/24.
//

import WidgetKit
import SwiftUI

@main
struct QuoteWidgetBundle: WidgetBundle {
    var body: some Widget {
        QuoteWidget()
        QuoteWidgetControl()
        QuoteWidgetLiveActivity()
    }
}
