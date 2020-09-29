//
//  ViewController.swift
//  NamesToFaces
//
//  Created by Marina Khort on 14.09.2020.
//  Copyright © 2020 Marina Khort. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	var people = [Person]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		collectionView.backgroundColor = .orange
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
		
		let defaults = UserDefaults.standard
		if let savedPeople = defaults.object(forKey: "people") as? Data {
			let jsonDecoder = JSONDecoder()
			do {
				//convert it back to an object graph
				people = try jsonDecoder.decode([Person].self, from: savedPeople)
			} catch {
				print("Failed to load people")
			}
		}
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return people.count
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
				fatalError("Unable to dequeue PersonCell")
		}
		
		let person = people[indexPath.item]
		cell.name.text = person.name
		
		let path = getDocumentsDirectory().appendingPathComponent(person.image)
		cell.imageView.image = UIImage(contentsOfFile: path.path)
		cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
		cell.imageView.layer.borderWidth = 2
		cell.imageView.layer.cornerRadius = 3
		cell.layer.cornerRadius = 7
		
		return cell
	}
	
	@objc func addNewPerson() {
		let picker = UIImagePickerController()
		picker.allowsEditing = true
		
		if UIImagePickerController.isSourceTypeAvailable(.camera) {
			picker.sourceType = .camera
		}
		picker.delegate = self
		present(picker, animated: true)
	}
	
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		guard let image = info[.editedImage] as? UIImage else {return}
		
		let imageName = UUID().uuidString	//extract the unique identifier as a string data type
		let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
		
		if let jpegData = image.jpegData(compressionQuality: 0.8) {
			try? jpegData.write(to: imagePath)
		}
		
		let person = Person(name: "Unknown", image: imageName)
		people.append(person)
		collectionView.reloadData()
		
		dismiss(animated: true)
		save()
	}
	
	override func collectionView(_ collectionView: UICollectionView,
	didSelectItemAt indexPath: IndexPath) {
		let person = people[indexPath.item]
		
		let ac = UIAlertController(title: "Select an option for you",
						message: nil, preferredStyle: .actionSheet)
		ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		ac.addAction(UIAlertAction(title: "Delete", style: .destructive)
		{[weak self] action in
			if let indexOfPerson = self?.people.firstIndex(of: person) {
				self?.people.remove(at: indexOfPerson)
				self?.collectionView.reloadData()
			}
		})
		ac.addAction(UIAlertAction(title: "Edit", style: .default)
		{[weak self] action in
			let editAc = UIAlertController(title: "Rename", message: nil, preferredStyle: .alert)
			editAc.addTextField()
			editAc.addAction(UIAlertAction(title: "Ok", style: .default)
				{[weak self, weak editAc] action in
					guard let newName = editAc?.textFields?[0].text else {return}
					person.name = newName
					self?.collectionView.reloadData()
					self?.save()
				})
			editAc.addAction(UIAlertAction(title: "Cancel", style: .cancel))
			self?.present(editAc, animated: true)
		})
		present(ac, animated: true)
	}


	func getDocumentsDirectory() -> URL {
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		return paths[0]
	}

	func save() {
		let jsonEncoder = JSONEncoder()
		//convert array into Data object
		if let savedData = try? jsonEncoder.encode(people) {
			//save to UserDefaults
			let defaults = UserDefaults.standard
			defaults.set(savedData, forKey: "people")
		} else {
			print("Failed to save people")
		}
	}
}

