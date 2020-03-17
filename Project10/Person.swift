//
//  Person.swift
//  Project10
//
//  Created by Nikola on 05/03/2020.
//  Copyright © 2020 Nikola Krstevski. All rights reserved.
//

import UIKit
//Saving photos using Codable - 1 step: Conforming to Codable
class Person: NSObject, Codable {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
