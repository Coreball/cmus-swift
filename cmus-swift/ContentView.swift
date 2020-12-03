//
//  ContentView.swift
//  cmus-swift
//
//  Created by Changyuan Lin on 12/3/20.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var metadataData = MetadataData()

    var body: some View {
        Image(nsImage: metadataData.albumArt ?? NSImage())
            .resizable()
            .edgesIgnoringSafeArea(.all)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
