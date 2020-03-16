//
//  Person.swift
//  Project10
//
//  Created by Nikola on 05/03/2020.
//  Copyright © 2020 Nikola Krstevski. All rights reserved.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
