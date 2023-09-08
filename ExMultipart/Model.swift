//
//  Model.swift
//  ExMultipart
//
//  Created by ssg on 2023/09/08.
//

import UIKit

struct Model: Codable {
    let name: String
    let number: Int
    let arr: [Int]
    let img: Data
    let child: ChildModel
    
    struct ChildModel: Codable {
        let memo: String
        let img2: Data
    }
}
