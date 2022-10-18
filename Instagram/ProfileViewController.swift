//
//  ProfileViewController.swift
//  Instagram
//
//  Created by Cheng Xue on 10/17/22.
//

import UIKit
import Parse
import AlamofireImage
import SnackBar_swift

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    

    

    @IBOutlet weak var profileImage: UIImageView!
    
    
    @IBAction func onImagePressed(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func updateProfile(_ sender: Any) {
        let user = PFUser.current()
//        let post = PFObject(className: "Posts")
//        post["caption"] = textField.text!
//        post["author"] = PFUser.current()!
        
        let imageData = profileImage.image!.pngData()
        let file = PFFileObject(data: imageData!)
        
        user!["image"] = file
        
        user!.saveInBackground{ (success, error) in
            if success {
//                self.dismiss(animated: true)
                SnackBar.make(in: self.view, message: "update successfully!", duration: .lengthLong).show()
            } else {
                print("Error: \(error)")
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af_imageScaled(to: size)
        
        profileImage.image = scaledImage
        dismiss(animated: true)
    }
    
//    @IBAction func onCameraPressed(_ sender: Any) {
//        let picker = UIImagePickerController()
//        picker.delegate = self
//        picker.allowsEditing = true
//
//        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//            picker.sourceType = .camera
//        } else {
//            picker.sourceType = .photoLibrary
//        }
//
//        present(picker, animated: true, completion: nil)
//    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let user = PFUser.current()
//        if (user!["image"] != nil) {
//
//        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
