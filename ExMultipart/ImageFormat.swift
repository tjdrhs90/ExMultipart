//
//  ImageFormat.swift
//  ExMultipart
//
//  Created by ssg on 2023/09/08.
//

import Foundation

/// 이미지 포맷
enum ImageFormat: RawRepresentable  {
    case unknown, png, jpeg, gif, tiff1, tiff2
    
    init?(rawValue: [UInt8]) {
        switch rawValue {
        case [0x89]: self = .png
        case [0xFF]: self = .jpeg
        case [0x47]: self = .gif
        case [0x49]: self = .tiff1
        case [0x4D]: self = .tiff2
        default: return nil
        }
    }
    
    var rawValue: [UInt8] {
        switch self {
        case .png: return [0x89]
        case .jpeg: return [0xFF]
        case .gif: return [0x47]
        case .tiff1: return [0x49]
        case .tiff2: return [0x4D]
        case .unknown: return []
        }
    }
}

extension Data {
    /// 데이터 이미지 포맷 확인
    var imageFormat: ImageFormat {
        var buffer = [UInt8](repeating: 0, count: 1)
        copyBytes(to: &buffer, from: 0..<1)
        return ImageFormat(rawValue: buffer) ?? .unknown
    }
}
