//
//  ViewController.swift
//  Instagrid
//
//  Created by Waqas Yaqoob on 28/12/2020.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    private var imagePicker = UIImagePickerController()
    private var flag = 0
    private var rotation = 0
    
    @IBOutlet weak var firstGrid: UIImageView!
    @IBOutlet weak var secondGrid: UIImageView!
    @IBOutlet weak var thirdGrid: UIImageView!
    
    @IBOutlet weak var firstSelectedImage: UIImageView!
    @IBOutlet weak var secondSelectedImage: UIImageView!
    @IBOutlet weak var thirdSelectedImage: UIImageView!
    
    @IBOutlet weak var mainStack: UIStackView!
    @IBOutlet weak var downStack: UIStackView!
    @IBOutlet weak var upperStack: UIStackView!
    
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var fourButton: UIButton!
    
    @IBOutlet weak var mainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        firstSelectedImage.isHidden = true
        thirdSelectedImage.isHidden = true
        fourButton.isHidden = true
        rotation = 1
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(orientationChanged),
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        );
        
        let swipeGestureUp = UISwipeGestureRecognizer(target: self, action:#selector(didSwipeUp(_:)))
        swipeGestureUp.direction = UISwipeGestureRecognizer.Direction.up
        mainView.addGestureRecognizer(swipeGestureUp)
        
        let swipeGestureLeft = UISwipeGestureRecognizer(target: self, action:#selector(didSwipeLeft(_:)))
        swipeGestureLeft.direction = UISwipeGestureRecognizer.Direction.left
        mainView.addGestureRecognizer(swipeGestureLeft)
    }
    
    @IBAction func layoutFirstButton(_ sender: UIButton) {
        
        firstSelectedImage.isHidden = false
        secondSelectedImage.isHidden = true
        thirdSelectedImage.isHidden = true
        
        secondButton.isHidden = true
        fourButton.isHidden = false
    }
    
    @IBAction func layoutSecondButton(_ sender: UIButton) {
        
        firstSelectedImage.isHidden = true
        secondSelectedImage.isHidden = false
        thirdSelectedImage.isHidden = true
        
        secondButton.isHidden = false
        fourButton.isHidden = true
    }
    
    @IBAction func layoutThirdButton(_ sender: UIButton) {
        
        firstSelectedImage.isHidden = true
        secondSelectedImage.isHidden = true
        thirdSelectedImage.isHidden = false
        
        secondButton.isHidden = false
        fourButton.isHidden = false
    }
    
    @IBAction func didSelectFirstButton(_ sender: Any) {
        flag = 1
        addPhotoSelected()
    }
    @IBAction func didSelectSecondButton(_ sender: Any) {
        flag = 2
        addPhotoSelected()
    }
    
    @IBAction func didSelectThirdButton(_ sender: Any) {
        flag = 3
        addPhotoSelected()
    }
    @IBAction func didSelectFourdButton(_ sender: Any) {
        flag = 4
        addPhotoSelected()
    }
    
     private func addPhotoSelected() {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]){
        
        if let pickedImage = info [UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            switch flag {
            case 1:
                firstButton.contentMode = .scaleAspectFill
                firstButton.setImage(pickedImage, for: .normal)
            case 2 :
                secondButton.contentMode = .scaleAspectFill
                secondButton.setImage(pickedImage, for: .normal)
            case 3 :
                thirdButton.contentMode = .scaleAspectFill
                thirdButton.setImage(pickedImage, for: .normal)
            case 4 :
                fourButton.contentMode = .scaleAspectFill
                fourButton.setImage(pickedImage, for: .normal)
            default:
                break
            }
            dismiss(animated: true, completion: nil)
        }
    }
    
    private func image(with view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        defer { UIGraphicsEndImageContext() }
        if let context = UIGraphicsGetCurrentContext() {
            view.layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            return image
        }
        return nil
    }
    
    @objc func didSwipeUp(_ sender: UISwipeGestureRecognizer) {
        
        let screenHeight = UIScreen.main.bounds.height
        let translationUp = CGAffineTransform(translationX: 0, y: -screenHeight)
        
        if rotation == 1 {
            UIView.animate(withDuration: 0.5) {
                self.mainView.transform = translationUp
            }
            let myImage = image(with: mainView)
            let activite = UIActivityViewController(activityItems: [myImage as Any], applicationActivities: [])
            activite.popoverPresentationController?.sourceView = self.view
            activite.completionWithItemsHandler = { (activity, success, items, error) in
                UIView.animate(withDuration: 0.5) {
                    self.mainView.transform = .identity
                }
            }
            self.present(activite, animated: true, completion: nil)
        }
    }
    
    @objc func didSwipeLeft(_ sender: UISwipeGestureRecognizer) {
        
        let screenWidht = UIScreen.main.bounds.width
        let translationLeft = CGAffineTransform(translationX: -screenWidht, y: 0)
        
        if rotation == 2 {
            UIView.animate(withDuration: 0.5) {
                self.mainView.transform = translationLeft
            }
            let myImage = image(with: mainView)
            let activite = UIActivityViewController(activityItems: [myImage as Any], applicationActivities: [])
            activite.popoverPresentationController?.sourceView = self.view
            activite.completionWithItemsHandler = { (activity, success, items, error) in
                UIView.animate(withDuration: 0.5) {
                    self.mainView.transform = .identity
                }
            }
            self.present(activite, animated: true, completion: nil)
        }
    }
    
    @objc func orientationChanged(_ notification: NSNotification, swipe: UISwipeGestureRecognizer) {
        
        if UIDevice.current.orientation.isPortrait {
            rotation = 1
        }
        
        if UIDevice.current.orientation.isLandscape {
            rotation = 2
        }
    }
}


