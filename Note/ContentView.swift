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
            List(0 ..< settings.notes.count, id: \.self) { i in
                if self.settings.notes[i] == self.settings.selected {
                    Text(self.settings.notes[i]).bold()
                } else {
                    Text(self.settings.notes[i])
                        .onTapGesture {
                            self.settings.selected = self.settings.notes[i]
                            self.settings.md = try! String(contentsOfFile: self.settings.filePath, encoding: String.Encoding.utf8)
                                self.settings.mdView = self.settings.md
                    }
                }
            }
            .frame(width: 200)
            .padding(EdgeInsets())

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
                    .tag(2)

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
