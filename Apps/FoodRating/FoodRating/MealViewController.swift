//
//  MealViewController.swift
//  food tracker 2
//
//  Created by Quinton Quaye on 3/1/17.
//  Copyright © 2017 Quinton Quaye. All rights reserved.
//

import UIKit

import os.log

class MealViewController: UIViewController, UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    //MARK: Properties
    
   
    @IBOutlet weak var nameTextField: UITextField!
    
    
   
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var ratingControl: RatingControl!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    /* This value is either passed by 'MealTableViewController' in 'prepare(for:sender:)'*/
    var meal: Meal?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        //handle the text field's user input through delegate callbacks.
        nameTextField.delegate = self
        
        // setup views if editing an existing meal.
        
        if let meal = meal {
            navigationItem.title = meal.name
            nameTextField.text = meal.name
            photoImageView.image = meal.photo
            ratingControl.rating = meal.rating
        }
        
    }
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    // displaying that the label text will become the same as the field imput text.
    func textFieldDidEndEditing(_ textField: UITextField) {
    }

    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImageFromPicker: UIImage?
        if let editedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImageFromPicker = (editedImage as UIImage)
            self.photoImageView.layer.cornerRadius = 75
            self.photoImageView.layer.masksToBounds = true
            self.photoImageView.contentMode = .scaleAspectFill
            
            
        }else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            selectedImageFromPicker = (originalImage as UIImage)
        }
        
        if let selectedImage = selectedImageFromPicker{
            //self.photoImageView.layer.cornerRadius = 75
            self.photoImageView.layer.masksToBounds = true
            self.photoImageView.contentMode = .scaleAspectFill
            self.photoImageView.image = selectedImage
            self.photoImageView.clipsToBounds = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Navigation
    
// this method lets you configure a view controller before its presented
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        //Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = nameTextField.text ?? ""
        let photo = photoImageView.image
        let rating = ratingControl.rating
        
        // set the meal to be passsed to MEalTableViewController after the unwind segue.
        meal = Meal(name: name, photo: photo, rating: rating)
    }
    

    
    
    //MARK: Actions
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UILongPressGestureRecognizer) {
        // Hide the keyboard.
        nameTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
}

