//
//  ViewController.swift
//
//  Copyright (c) Alexis Creuzot (http://alexiscreuzot.com)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit

class ViewController: UIViewController {
    
    typealias FilteringCompletion = ((UIImage?, Error?) -> ())
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var loader: UIActivityIndicatorView!
    @IBOutlet var applyButton: UIButton!
    @IBOutlet var loaderWidthConstraint: NSLayoutConstraint!
    
    var imagePicker = UIImagePickerController()
    var isProcessing : Bool = false {
        didSet {
            self.applyButton.isEnabled = !isProcessing
            self.isProcessing ? self.loader.startAnimating() : self.loader.stopAnimating()
            self.loaderWidthConstraint.constant = self.isProcessing ? 20.0 : 0.0
            UIView.animate(withDuration: 0.3) {
                self.isProcessing
                    ? self.applyButton.setTitle("Processing...", for: .normal)
                    : self.applyButton.setTitle("Apply Style", for: .normal)
                self.view.layoutIfNeeded()
            }
        }
    }
    
    //MARK:- Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isProcessing = false
        self.applyButton.superview!.layer.cornerRadius = 4
    }
    
    //MARK:- CoreML
    
    func process(input: UIImage, completion: @escaping FilteringCompletion) {
        
        // TODO
        
        DispatchQueue.main.async {
            completion(nil, NSTError.notImplemented)
        }
    }
    
    //MARK:- Actions
    
    @IBAction func importFromLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.allowsEditing = false
            self.present(self.imagePicker, animated: true)
        } else {
            print("Photo Library not available")
        }
    }
    
    @IBAction func applyNST() {
        
        guard let image = self.imageView.image else {
            print("Select an image first")
            return
        }
        
        self.isProcessing = true
        self.process(input: image) { filteredImage, error in
            self.isProcessing = false
            if let filteredImage = filteredImage {
                self.imageView.image = filteredImage
            } else if let error = error {
                self.applyButton.setTitle(error.localizedDescription, for: .normal)
            } else {
                print(NSTError.unknown.localizedDescription)
            }
        }
    }
}

// MARK: - UIImagePickerControllerDelegate

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageView.image = pickedImage
            self.imageView.backgroundColor = .clear
        }
        self.dismiss(animated: true)
    }
}
