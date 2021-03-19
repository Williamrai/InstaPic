//
//  ProfileViewController.swift
//  InstaPic
//
//  Created by My Mac on 3/19/21.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    
    var profiles = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authorLabel.text = PFUser.current()?.username!
        loadProfile()
    }
    
    
    func loadProfile(){
        let query = PFQuery(className: "profile")
        query.whereKey("author", equalTo: PFUser.current() ?? [])
        
        query.findObjectsInBackground { (profile, error) in
            if profile != nil{
                DispatchQueue.main.async {
                    //setting image
                    //image
                    let count = profile?.count ?? 0
                    if (count > 0){
                        let imageFile = profile?[count-1]["image"] as! PFFileObject
                        let imageUrl = imageFile.url!
                        let url = URL(string: imageUrl)!
                        self.profileImage.af.setImage(withURL: url)
                    }
                    

                  
                  
                }
               
            }else{
                print("error \(error!.localizedDescription)")
            }
        }
    }

    
    @IBAction func onProfImageTap(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
       
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            picker.sourceType = .camera
        }else{
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    //After picking a image
    //resize and show it in imageView
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af.imageAspectScaled(toFill: size)
        
        profileImage.image = scaledImage
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func uploadProfilePic(_ sender: Any) {
        let profile = PFObject(className: "profile")
        
        profile["author"] = PFUser.current()
        
        let imageData = profileImage.image!.pngData()
        let file = PFFileObject(data: imageData!)
        profile["image"] = file
        
        profile.saveInBackground { (success, error) in
            if success{
                print("successfully added.")
            }else{
                print("error on adding \(error)");
            }
        }
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
