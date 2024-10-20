//
//  PaysplitImage.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 20.10.24.
//

import SwiftUI
import CachedAsyncImage

extension URLCache {
    static let imageCache = URLCache(memoryCapacity: 512_000_000, diskCapacity: 10_000_000_000)
}

public struct PaysplitImage: View {
    let picture: String
    let frame: CGSize

    public init(picture: String, frame: CGSize) {
        self.picture = picture
        self.frame = frame
    }

    public var body: some View {
        if picture.isEmpty {
            Image(systemName: "person.circle.fill")
                .renderingMode(.template)
                .resizable()
                .frame(width: frame.width, height: frame.height)
                .foregroundColor(.gray)
        } else {
            CachedAsyncImage(url: URL(string: picture), urlCache: .imageCache) { profilePicture in
                profilePicture
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .redacted(reason: .placeholder)
            }
            .frame(width: frame.width, height: frame.height)
            .cornerRadius(frame.width / 2)
        }
    }
}
