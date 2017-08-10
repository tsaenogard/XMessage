/*
 * Copyright (c) 2015 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import Firebase

enum Section: Int {
    case createNewChannelSection = 0
    case currentChannelsSection
}

class ChannelListViewController: UITableViewController {
    var senderDisplayName: String?
    var newChannelTextField: UITextField?
    private var channels: [Channel] = []
    
    private lazy var channelRef: DatabaseReference = Database.database().reference().child("channels")
    private var channelRefHandle: DatabaseHandle?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "xmessage"
        observeChannels()
        
        let logoutBtn = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(onLogout(_:)))
        self.navigationItem.rightBarButtonItem = logoutBtn
        
        senderDisplayName = Auth.auth().currentUser?.displayName
    }
    
    deinit {
        if let refHandle = channelRefHandle {
            channelRef.removeObserver(withHandle: refHandle)
        }
    }
    
    
    private func observeChannels() {
        channelRefHandle = channelRef.observe(.childAdded, with: { (snapshot) in
            let channelData = snapshot.value as! Dictionary<String, AnyObject>
            let id = snapshot.key
            if let name = channelData["name"] as! String!, name.characters.count > 0 {
                self.channels.append(Channel(id: id, name: name))
                self.tableView.reloadData()
            }else {
                print("Error! Could not decode channel data")
            }
        })
    }
    
    //MARK: - selector
    func createChannel(_ sender: AnyObject) {
        if let name = newChannelTextField?.text {
            let newChannelRef = channelRef.childByAutoId()  //用AutoID建立新的在資料庫channels下建立新的條目
            let channelItem = ["name" : name]
            newChannelRef.setValue(channelItem)
        }
    }
    
    func onLogout(_ sender: UIBarButtonItem)  {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            let destinVC = LoginViewController()
            UIApplication.shared.keyWindow?.rootViewController = UINavigationController(rootViewController: destinVC)
            self.dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    
    //MARK: - UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let currentSection: Section = Section(rawValue: section) {
            switch currentSection {
            case .createNewChannelSection:
                return 1
            case .currentChannelsSection:
                return channels.count
            }
        }else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let reuseIdentifier = (indexPath as NSIndexPath).section == Section.createNewChannelSection.rawValue ? "NewChannel" : "ExistingChannel"
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        
        if (indexPath as NSIndexPath).section == Section.createNewChannelSection.rawValue  {
            cell = CreateChannelCell(style: .default, reuseIdentifier: reuseIdentifier)
            (cell as! CreateChannelCell).createChannelButton.addTarget(self, action: #selector(createChannel(_:)), for: .touchUpInside)
            if let createNewChannel = cell as? CreateChannelCell {
                newChannelTextField = createNewChannel.newChannelNameField
            }
        }else {
            cell = UITableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
            cell?.textLabel?.text = channels[(indexPath as NSIndexPath).row].name
        }
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == Section.currentChannelsSection.rawValue {
            let channel = channels[(indexPath as NSIndexPath).row]
            let destinVC = ChatViewController()
            destinVC.channel = channel
            destinVC.senderDisplayName = senderDisplayName
            destinVC.channelRef = channelRef.child(channel.id)
            self.navigationController?.pushViewController(destinVC, animated: true)  //move to ChatViewController
        }
    }
}
