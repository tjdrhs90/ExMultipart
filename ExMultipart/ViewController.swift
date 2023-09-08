//
//  ViewController.swift
//  ExMultipart
//
//  Created by ssg on 2023/09/08.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let model = Model(name: "ssg",
                          number: 123,
                          arr: [0,0],
                          img: #imageLiteral(resourceName: "2").jpegData(compressionQuality: 0.1)!,
                          child: Model.ChildModel(memo: "child",
                                                  img2: #imageLiteral(resourceName: "1").pngData()!))
        //배열이나 하위 모델은 안되고 있음
        ImageUploader().uploadImageUsingURLSession(model: model) { err in
            print(err?.localizedDescription ?? "")
        }
    }
}
