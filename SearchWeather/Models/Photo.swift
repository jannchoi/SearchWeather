//
//  Photo.swift
//  SearchWeather
//
//  Created by 최정안 on 2/14/25.
//

import Foundation

struct Photo: Decodable {
    let results: [PhotoDetail]
}
struct PhotoDetail: Decodable {
    let id: String
    let urls: URLS
}
struct URLS: Decodable{
    let thumb: String?
}
