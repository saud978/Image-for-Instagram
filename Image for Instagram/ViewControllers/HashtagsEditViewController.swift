//
//  HashtagsEditViewController.swift
//  Image for Instagram
//
//  Created by Saud Almutlaq on 15/05/2020.
//  Copyright © 2020 Saud Soft. All rights reserved.
//

import UIKit
import TagListView

class HashtagsEditViewController: UIViewController, TagListViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var hashtagVeiw: TagListView!
    @IBOutlet weak var hashtagString: UITextField!
    
    @IBAction func dismissView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addHashtag(_ sender: Any) {
        if hashtagString.text != "" {
            let newHashtag = "#\(hashtagString.text ?? "")"
            hashtagsArray.append(newHashtag)
            hashtagVeiw.addTag(newHashtag)
            hashtagString.text = ""
        }
        UserDefaults.standard.set(hashtagsArray.joined(separator: " "), forKey: "hashtags")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        hashtagVeiw.delegate = self
        hashtagString.delegate = self
        
        let userHashtagData = UserDefaults.standard.value(forKey: "hashtags") as! String
        hashtagsArray = userHashtagData.components(separatedBy: " ")
        hashtagVeiw.addTags(hashtagsArray)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (string == " ") {
            return false
        }
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: TagListViewDelegate
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag pressed: \(title)")
        tagView.isSelected = !tagView.isSelected
    }
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag Remove pressed: \(title), \(sender)")
        hashtagsArray = hashtagsArray.filter {$0 != title}
        UserDefaults.standard.set(hashtagsArray.joined(separator: " "), forKey: "hashtags")
        sender.removeTagView(tagView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let firstVC = presentingViewController as? ViewController {
            DispatchQueue.main.async {
                firstVC.updateView()
            }
        }
    }
}
