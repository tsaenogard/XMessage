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

class CreateChannelCell: UITableViewCell {

var newChannelNameField: UITextField!
var createChannelButton: UIButton!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        newChannelNameField = UITextField()
        newChannelNameField.placeholder = "Create New Channel"
        newChannelNameField.font = UIFont.boldSystemFont(ofSize: 15)
        newChannelNameField.backgroundColor = UIColor.lightText
        newChannelNameField.layer.borderColor = UIColor.lightGray.cgColor
        newChannelNameField.layer.borderWidth = 1.0
        newChannelNameField.layer.cornerRadius = 5.0
        newChannelNameField.textAlignment = .center
        self.contentView.addSubview(newChannelNameField)
        
        createChannelButton = UIButton(type: .system)
        createChannelButton.setTitle("create", for: .normal)
        createChannelButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        createChannelButton.titleLabel?.textAlignment = .center
        self.contentView.addSubview(createChannelButton)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let sideSpace: CGFloat = 8
        let gap: CGFloat = 8
        newChannelNameField.frame = CGRect(x: sideSpace, y: sideSpace, width: self.frame.width - 50 - sideSpace * 2 - gap, height: 30)
        createChannelButton.frame = CGRect(x: newChannelNameField.frame.maxX + gap, y: sideSpace, width: 50, height: 30)
        
    }
  
}
