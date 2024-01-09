//
//  ViewController.swift
//  Image for Instagram
//
//  Created by Saud Almutlaq on 09/05/2020.
//  Copyright © 2020 Saud Soft. All rights reserved.
//

import GoogleMobileAds
import UIKit
import Photos
import TagListView
import IAPurchaseManager

class ViewController: UIViewController, TagListViewDelegate {
    var bannerView: GADBannerView!
    var interstitial: GADInterstitial!
    var rewardedAd: GADRewardedAd?

    @IBAction func editHashtag(_ sender: Any) {
        if !IAPManager.shared.isProductPurchased(productId: productID) {
            if interstitial.isReady {
                interstitial.present(fromRootViewController: self)
            } else {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "hashtagsEditViewController") as! HashtagsEditViewController
                self.present(vc, animated: true, completion: nil)
                print("Ad wasn't ready")
            }
        }
    }
    
    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var hashtagListView: TagListView!
    @IBOutlet weak var captionText: UITextView!
    //    @IBOutlet weak var hashtagText: UITextView!
    // This is the view that hold the two image views
    @IBOutlet weak var viewforImage: UIView!
    
    // Top image
    @IBOutlet weak var imageView: UIImageView!
    
    // Background (Blured) image
    @IBOutlet weak var bgImage: UIImageView!
    
    private lazy var imagePicker = ImagePicker()
    
    @IBAction func getImage(_ sender: Any) {
        photoButtonTapped()
    }
    
    @IBOutlet weak var clearImageButton: UIButton!
    
    @IBAction func deleteImage(_ sender: Any) {
        bgImage.image = nil
        imageView.image = UIImage(named: "image-placeholder")
    }
    
    @IBAction func clearCatption(_ sender: Any) {
        captionText.text = ""
    }
    
    @IBAction func clearHashtag(_ sender: Any) {
        for tag in hashtagListView.selectedTags() {
            tag.isSelected = false
        }
    }
    
    @IBAction func shareImage(_ sender: Any) {
        var hashtagString = ""

        for tag in hashtagListView.selectedTags() {
            hashtagString.append(" \(tag.titleLabel?.text! ?? "")")
        }

        let caption = "\(captionText.text ?? "")\n\(hashtagString)"

        UIPasteboard.general.string = caption

        // Using the extention (end of this file) to convert UIView to UIImage
        clearImageButton.isHidden = true
        let newImage = viewforImage.asImage()
        clearImageButton.isHidden = false
        
        if imageView.image != nil {
            self.postImageToInstagram(image: newImage)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if !IAPManager.shared.isProductPurchased(productId: productID) {
            // Banner Ad Init
            initBannerAdView()
            addBannerViewToView(bannerView)
            
            // Interstitial Ad Init
            initInterstitialAdView()
        }
        
        //Looks for single or multiple taps.
        hashtagListView.delegate = self
        
        updateView()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        imagePicker.delegate = self
        captionText.layer.borderWidth = 1
        captionText.layer.borderColor = UIColor.lightGray.cgColor
        
        view.addGestureRecognizer(tap)
        scrollView.contentSize = hashtagListView.frame.size
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        adView.addSubview(bannerView)
    }
    
    func updateView() {
        DispatchQueue.main.async {
            getHashData()
            self.hashtagListView.removeAllTags()
            self.hashtagListView.addTags(hashtagsArray)
            if !IAPManager.shared.isProductPurchased(productId: productID) {
                let request = GADRequest()
                self.interstitial.load(request)
            }
        }
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    private func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        imagePicker.present(parent: self, sourceType: sourceType)
    }
    
    func photoButtonTapped() { imagePicker.photoGalleryAsscessRequest() }
    func cameraButtonTapped() { imagePicker.cameraAsscessRequest() }
    
    
    //MARK: The following two funciton is used to save the image to camera roll then share it to instagram.
    
    func postImageToInstagram(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if error != nil {
            print(error!)
        }
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        if let lastAsset = fetchResult.firstObject {
            
            let url = URL(string: "instagram://library?LocalIdentifier=\(lastAsset.localIdentifier)")!
            
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                let alertController = UIAlertController(title: "Error", message: "Instagram is not installed", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: TagListViewDelegate
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag pressed: \(title)")
        tagView.isSelected = !tagView.isSelected
    }
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag Remove pressed: \(title), \(sender)")
        sender.removeTagView(tagView)
    }
}

extension ViewController: ImagePickerDelegate {
    func imagePickerDelegate(didSelect image: UIImage, delegatedForm: ImagePicker) {
        
        imageView.image = image
        bgImage.image = blur(image: image)
        bgImage.contentMode = .scaleAspectFill
        
        imageView.contentMode = .scaleAspectFit
        
        imagePicker.dismiss()
    }
    
    /// Add blur to an image
    /// - Parameter image: Source UIImage
    /// - Returns: Blured UIImage
    func blur(image: UIImage) -> UIImage {
        let radius: CGFloat = 20;
        let context = CIContext(options: nil);
        let inputImage = CIImage(cgImage: image.cgImage!);
        let filter = CIFilter(name: "CIGaussianBlur");
        filter?.setValue(inputImage, forKey: kCIInputImageKey);
        filter?.setValue("\(radius)", forKey:kCIInputRadiusKey);
        let result = filter?.value(forKey: kCIOutputImageKey) as! CIImage;
        let rect = CGRect(x: radius * 2, y: radius * 2, width: image.size.width - radius * 4, height: image.size.height - radius * 4)
        let cgImage = context.createCGImage(result, from: rect);
        let returnImage = UIImage(cgImage: cgImage!);
        
        return returnImage;
    }
    
    func imagePickerDelegate(didCancel delegatedForm: ImagePicker) { imagePicker.dismiss() }
    
    func imagePickerDelegate(canUseGallery accessIsAllowed: Bool, delegatedForm: ImagePicker) {
        if accessIsAllowed { presentImagePicker(sourceType: .photoLibrary) }
    }
    
    func imagePickerDelegate(canUseCamera accessIsAllowed: Bool, delegatedForm: ImagePicker) {
        // works only on real device (crash on simulator)
        if accessIsAllowed { presentImagePicker(sourceType: .camera) }
    }
}
