//
//  Person.swift
//  NamesToFaces
//
//  Created by Marina Khort on 18.09.2020.
//  Copyright © 2020 Marina Khort. All rights reserved.
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
