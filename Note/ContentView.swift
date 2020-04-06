//
//  ContentView.swift
//  Note
//
//  Created by Yu Chen on 4/3/20.
//  Copyright © 2020 Yu Chen. All rights reserved.
//

import SwiftUI
import WebKit
import Down

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settings: UserSettings

    var body: some View {
        HSplitView {
            List(0 ..< settings.notes.count, id: \.self, selection: $settings.selected) { i in
                if i == self.settings.selected {
                    if self.settings.notes[i].changed {
                        Text(self.settings.notes[i].name).bold().italic()
                    } else {
                        Text(self.settings.notes[i].name).bold()
                    }
                } else {
                    if self.settings.notes[i].changed {
                        Text(self.settings.notes[i].name).italic()
                    } else {
                        Text(self.settings.notes[i].name)
                    }
                }
            }
            .frame(width: 200)
            .padding(EdgeInsets())
            .listStyle(SidebarListStyle())

            if settings.editorOn {
                MacEditorTextView(text: $settings.md)
                    .frame(width: 350)
            }

            GeometryReader { g in
                ScrollView {
                    WebView(colorScheme: self.colorScheme, md: self.$settings.mdView).tabItem {
                        Text("Browser")
                    }
                    .frame(height: g.size.height)
                }.frame(height: g.size.height)
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
