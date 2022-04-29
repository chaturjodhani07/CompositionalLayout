//
//  ImageFetcher.swift
//  CompositionalLayout
//
//  Created by Chirag on 4/29/22.
//

import Foundation
import SwiftUI
class ImageFetcher: ObservableObject {
    @Published var fetchedImages: [ImageModel]?
    // MARK: Pagination Properties
    @Published var currentPage: Int = 0
    @Published var startPagination: Bool = false
    @Published var endPagination: Bool = false
    
    init() {updateImages()}
    func updateImages() {
        currentPage += 1
        Task {
            do{
                try await fetchImages()
            }catch{
                // HANDLE ERROR
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: Image JSON Fetching
    func fetchImages () async throws {
        guard let url = URL(string: "https://picsum.photos/v2/list?page=\(currentPage)&limit=30") else{return}
        let response = try await URLSession.shared.data(from: url)
        // MARK: Reducing Image Size...
        // API call Supports Image Sizing
        let images = try JSONDecoder ().decode([ImageModel].self, from: response.0).compactMap({ item -> ImageModel? in
            let imageId = item.id
            let SizeURL = "https://picsum.photos/id/\(imageId)/500/500"
            return .init(id: imageId, download_url: SizeURL)
        })
        await MainActor.run(body: {
            if fetchedImages == nil{fetchedImages = []}
            fetchedImages?.append(contentsOf: images)
            endPagination = (fetchedImages?.count ?? 0) > 100
            startPagination = false
        })
    }
}
