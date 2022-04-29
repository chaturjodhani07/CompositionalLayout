//
//  ContentView.swift
//  CompositionalLayout
//
//  Created by Chirag on 4/29/22.
//

import SwiftUI
import SDWebImageSwiftUI
struct ContentView: View {
    @StateObject var imageFetcher: ImageFetcher = .init()
    var body: some View {
        NavigationView{
            Group {
                if let images = imageFetcher.fetchedImages {
                    ScrollView {
                        CompositionalView (items:images, id: \.id) { item in
                            GeometryReader { proxy in
                                let size = proxy.size
                                WebImage(url: URL(string: item.download_url))
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: size.width, height: size.height)
                                    .cornerRadius(10)
                                    .onAppear {
                                        if images.last?.id == item.id {
                                            imageFetcher.startPagination = true
                                        }
                                    }
                            }
                        }
                        .padding()
                        .padding(.bottom, 10)
                        
                        if imageFetcher.startPagination && !imageFetcher.endPagination {
                            ProgressView()
                                .offset(y: -15)
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                        imageFetcher.updateImages()
                                    }
                                }
                        }
                    }
                }else {
                    ProgressView()
                }
            }
            .navigationTitle("Compositional Layout")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
