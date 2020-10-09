//
//  ViewController.swift
//  Photofilter
//
//  Created by Marina Khort on 09.10.2020.
//  Copyright © 2020 Marina Khort. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	@IBOutlet var imageView: UIImageView!
	@IBOutlet var slider: UISlider!
	var currentImage: UIImage!
	
	
	override func viewDidLoad() {
			super.viewDidLoad()
	//import a photo from the user's photo library
		title = "Photo filter"
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
		}
	
	@objc func importPicture() {
		let picker = UIImagePickerController()
		picker.allowsEditing = true
		picker.delegate = self
		present(picker, animated:  true)
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		guard let image = info[.editedImage] as? UIImage else {return}
		dismiss(animated: true)
		
		//to have a copy of pic what is originally imported
		currentImage = image
	}
	
	@IBAction func intensityChanged(_ sender: UISlider) {
		
	}
	
	@IBAction func changeFilter(_ sender: UIButton) {
		
	}
	
	
	@IBAction func save(_ sender: UIButton) {
		
	}
	
	


}

