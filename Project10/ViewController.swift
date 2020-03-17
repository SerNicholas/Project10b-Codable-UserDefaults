//
//  ViewController.swift
//  Project10
//
//  Created by Nikola on 04/03/2020.
//  Copyright © 2020 Nikola Krstevski. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var people = [Person]()//property to store all the people in our application
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        
//Step 4:  Loading the array back from disk when the app starts
        let defaults = UserDefaults.standard

        if let savedPeople = defaults.object(forKey: "people") as? Data {
            let jsonDecoder = JSONDecoder()

            do {
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
            //we failed to get a PersonCell - bail out!
            fatalError("Unable to dequeue PersonCell")
        }
        // if we're still here it means we got a PersonCell, so we can return it
        let person = people[indexPath.item]
        cell.name.text = person.name
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path) //path.path - first path is URL but we need to convert it to string. Thats why we use path after it
        
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        return cell
    }
    
    @objc func addNewPerson() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return } // using guard to to pull out and typecast the image from image picker
        
        let imageName = UUID().uuidString //creating UUID object; using its uuidString property to extract the unique identifier as a string data type
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName) //creating a new constant imagePath which takes result of getDocumentDirectory() and calls a new method on it: appendingPathComponent(). This is used when working with file paths and adds one string (imageName in our case) to a path including whatever path separator is used on the platform.
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {//at this point we have an image and a path where we want to save it, we need to convert the UIImage to a Dataobject so it can be saved. To do that we use jpegData() method which takes one parameter -> a quality value between 0 and 1(being a maximum quality)
            try? jpegData.write(to: imagePath) //Once we have a Data object containing our JPEG data, we just need to unwrap it safely then write it to the file name we made earlier. That's done using the write(to:) method, which takes a filename as its parameter.
        }
        //next 3 lines are added after creating "people" property
        let person = Person(name: "Unkown", image: imageName)
        people.append(person)
        save() // Saving Photos with Codable - 3b step:  Callling save( ) method where needed
        collectionView.reloadData()
        dismiss(animated: true)
    }
    
    func getDocumentsDirectory() -> URL { // function created by us
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
     
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]

        let ac = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
        ac.addTextField()

        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
            guard let newName = ac?.textFields?[0].text else { return }
            person.name = newName
            self?.save() // Saving Photos with Codable - 3a step:  Callling save( ) method where needed
            self?.collectionView.reloadData()
        })

        present(ac, animated: true)
    }
// Saving Photos with Codable - 2 step: Creating a function to encode(write) data.
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(people) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "people")
        } else {
            print("Failed to save people.")
        }
    }
}

