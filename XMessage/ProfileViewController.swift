//
//  ProfileViewController.swift
//  XMessage
//
//  Created by Eric Chen on 2017/8/10.
//  Copyright © 2017年 MasB1ue. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    var contentView: UIView!
    var tableView: UITableView!
    var logoutBtn: UIButton!
    
    var sectionContent = [["Name"],["Rate us on App Store","Tell us your feedback","Follow us on facebook"]]
    var links = ["https://twitter.com/appcodamobile","https://facebook.com/appcodamobile","https://www.pinterest.com/appcoda"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .custom
        
        let blurEffectVIew = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        blurEffectVIew.frame.size = CGSize(width: self.view.bounds.width, height: self.view.bounds.height)
        blurEffectVIew.alpha = 0.8
        self.view.addSubview(blurEffectVIew)
        
        contentView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width / 3 * 2, height: self.view.bounds.height / 4 * 3))
        contentView.center = self.view.center
        contentView.backgroundColor = UIColor.white
        self.view.addSubview(contentView)
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame.size = CGSize(width: self.contentView.frame.width, height: self.contentView.frame.height - 50)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.contentView.addSubview(tableView)
        
        logoutBtn = UIButton()
        logoutBtn.frame = CGRect(x: self.contentView.bounds.midX - 50, y: self.tableView.frame.maxY + 10, width: 100, height: 30)
        logoutBtn.setTitle("logout", for: .normal)
        logoutBtn.setTitleColor(UIColor.white, for: .normal)
        logoutBtn.titleLabel?.textAlignment = .center
        logoutBtn.backgroundColor = UIColor.red
        logoutBtn.layer.cornerRadius = 5.0
        self.contentView.addSubview(logoutBtn)
        
        
        
        
    }
    
//MARK: - TableView delegate and datasource
    

}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionContent[section].count
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        switch section {
//        case 0:
//            return "Profile"
//        case 1:
//            return "LeaveFeedback"
//        default:
//            return ""
//        }
//    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let imageView = UIView(frame: CGRect(x: 0, y: 0, width: self.contentView.frame.width, height: 190))
            imageView.backgroundColor = UIColor.clear
            let profilePhoto = UIImageView()
            profilePhoto.frame.size = CGSize(width: 100, height: 100)
            profilePhoto.center = imageView.center
            profilePhoto.layer.cornerRadius = 50
            profilePhoto.layer.borderColor = UIColor.white.cgColor
            profilePhoto.layer.borderWidth = 1.0
            profilePhoto.backgroundColor = UIColor.lightGray
            //profilePhoto.image = try! UIImage(data: Data(contentsOf: (Auth.auth().currentUser?.photoURL)!))
            imageView.addSubview(profilePhoto)
            return imageView
        case 1:
            let titleLabel = UILabel()
            titleLabel.text = "LeaveFeedback"
            titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
            titleLabel.frame = CGRect(x: 0, y: 0, width: self.contentView.frame.width - 10, height: 30)
            titleLabel.backgroundColor = UIColor(red: 213/255, green: 208/255, blue: 208/255, alpha: 0.5)
            return titleLabel
        default:
            return nil
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 190
        case 1:
            return 30
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        }
        
        cell?.textLabel?.text = sectionContent[indexPath.section][indexPath.row]
        return cell!
    }

}
