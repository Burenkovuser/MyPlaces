//
//  NewPlaceViewController.swift
//  MyPlaces
//
//  Created by Vasilii on 25/09/2019.
//  Copyright © 2019 Vasilii Burenkov. All rights reserved.
//

import UIKit

class NewPlaceViewController: UITableViewController {
    
    //var newPlace = Place()
    
    var currentPlace: Place? // объект который передадим для редактирования
    var imageIsChanged = false
    
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var placeName: UITextField!
    @IBOutlet weak var placeLockation: UITextField!
    @IBOutlet weak var placeType: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        //записываем данные в базу один раз
        DispatchQueue.main.async {
            self.newPlace.savePlaces()
        }
*/
        tableView.tableFooterView = UIView() // убираем разлиновку ниже используемых ячеек
        saveButton.isEnabled = false // делаем кнопку сохранения не активной

        placeName.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged) // отслеживать изменения в поле названия
        setupEditScreen()
    }
    
    // MARK: Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            let cameraIcon = #imageLiteral(resourceName: "camera")
            let photoIcon = #imageLiteral(resourceName: "photo")
            
            let actionSheet = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
            
            let camera = UIAlertAction(title: "Camera", style: .default) { _ in
                self.chooseImagePicker(source: .camera)
            }
            
            camera.setValue(cameraIcon, forKey: "image") //добавлем изображение
            camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment") // делаем надпись по левому краю
            
            let photo = UIAlertAction(title: "Photo", style: .default) { _ in
                self.chooseImagePicker(source: .photoLibrary)
            }
            
            photo.setValue(photoIcon, forKey: "image")
            photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            actionSheet.addAction(camera)
            actionSheet.addAction(photo)
            actionSheet.addAction(cancel)
            present(actionSheet, animated: true)
            
        } else {
            view.endEditing(true) // заканчиваем редактирование
        }
    }
    
    func savePlace() {
        
        //let newPlace = Place()
        
        var image: UIImage?
        
        if imageIsChanged {
            image = placeImage.image
        } else {
            image = #imageLiteral(resourceName: "imagePlaceholder")
        }
        
        let imageData = image?.pngData() //коновертируем изображение в тип Data
        
        let newPlace = Place(name: placeName.text!,
                             location: placeLockation.text,
                             type: placeType.text,
                             imageData: imageData)
        
        if currentPlace != nil {
            try! realm.write {
                currentPlace?.name = newPlace.name
                currentPlace?.location = newPlace.location
                currentPlace?.type = newPlace.type
                currentPlace?.imageData = newPlace.imageData
            }
        } else {
            StorageManager.saveObject(newPlace)
        }
        
        
        /*
        newPlace.name = placeName.text!
        newPlace.location = placeLockation.text
        newPlace.type = placeType.text
        newPlace.imageData = imageData
        */

        /*
        newPlace = Place(name: placeName.text!,
                         location: placeLockation.text,
                         type: placeType.text,
                         image: image,
                         restaurantImage: nil)
 */
    }
    //если есть данные мы их подставляем для редактирования
    private func setupEditScreen() {
        if currentPlace != nil {
            setupNavigationBar()
            
            imageIsChanged = true // изображение не будет менятся на фоновое при редактировании
            guard let data = currentPlace?.imageData, let image = UIImage(data: data) else { return }
            placeImage.image = image
            placeImage.contentMode = .scaleToFill //масштабируем изображение по размеру
            
            placeName.text = currentPlace?.name
            placeLockation.text = currentPlace?.location
            placeType.text = currentPlace?.type
        }
    }
    
    private func setupNavigationBar() {
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil) // настраиваем кнопку возварата
        }
        navigationItem.leftBarButtonItem = nil
        title = currentPlace?.name
        saveButton.isEnabled = true
    }

    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
}

// MARK: Text field delegate

extension NewPlaceViewController: UITextFieldDelegate {
    
    // Скрываем клавиатуру по нажатию на Done
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func textFieldChanged() {
        
        if placeName.text?.isEmpty == false {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
}

// MARK: Work with image

extension NewPlaceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true // даем пользователю возможност редактировать изображение
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        placeImage.image = info[.editedImage] as? UIImage // присваиваем отредактированное изображение
        placeImage.contentMode = .scaleAspectFill //масшбируем изображение
        placeImage.clipsToBounds = true // обрезаем по границе
        imageIsChanged = true
        dismiss(animated: true)
    }
}
