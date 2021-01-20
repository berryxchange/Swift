//
//  chatLogCell.swift
//  TCIApp
//
//  Created by Quinton Quaye on 5/10/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import UIKit
import AVFoundation

class chatLogCell: UICollectionViewCell {
    
    var chatLogController: ChatLogControllerOne?
    
    var activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.hidesWhenStopped = true
        
        return aiv
    }()
    
    var message: Message?
    
    // for the play button
    lazy var playButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "playButton")
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.white
        button.addTarget(self, action: #selector(playThis), for: .touchUpInside)
        
        return button
    }()
    
    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    
    @objc func playThis(){
        
        if let videoUrlString = message?.videoUrl, let url = NSURL(string: videoUrlString) {
            print("been tapped")
            player = AVPlayer(url: url as URL )
            
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.frame = bubbleView.bounds
            bubbleView.layer.addSublayer(playerLayer!)
            
            player?.play()
            activityIndicatorView.startAnimating()
            playButton.isHidden = true
            
            
        }
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        activityIndicatorView.stopAnimating()
        playerLayer?.removeFromSuperlayer()
        player?.pause()
    }
    
    let textView: UITextView = {
        
        
        let tv = UITextView()
        tv.text = "sample Text stuff"
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
        tv.textColor = UIColor.white
        tv.isEditable = false
        
        return tv
        
    }()
    
    
    
    
    static let blueColor = UIColor(red: 0, green: 94, blue: 249, alpha: 1)
    static let grayColor = UIColor(red: 231, green: 231, blue: 231, alpha: 1)
    
    // for the bubble background
    let bubbleView: UIView = {
        let view = UIView()
        
        view.backgroundColor = blueColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        
        view.layer.masksToBounds = true
        return view
    }()
    
    
    
    // for the image
    let profileImage: UIImageView = {
        let imageView = UIImageView()
        //imageView.image = UIImage(named: "pastor")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // for the image
    lazy var messageImageView: UIImageView = {
        let imageView = UIImageView()
        //imageView.image = UIImage(named: "pastor")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(zoomTap)))
        
        return imageView
    }()
    
    @objc func zoomTap(tapGesture: UITapGestureRecognizer){
        self.chatLogController?.inputTextField.resignFirstResponder()
        if message?.videoUrl != nil {
            return
        }
        
        if let imageView = tapGesture.view as? UIImageView{
            self.chatLogController?.performZomingForStartingImageView(startingImageView: imageView)
        }
    }
    
    var bubbleWidthAnchor : NSLayoutConstraint?
    var bubbleViewRightAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // loads the view with thses materials
        
        addSubview(bubbleView)
        addSubview(textView)
        addSubview(profileImage)
        
        bubbleView.addSubview(messageImageView)
        // adds the play button on top of the image
        bubbleView.addSubview(playButton)
        //x, y, w, h
        bubbleView.addSubview(activityIndicatorView)
        //x, y, w, h
        
        //x, y, w, h
        messageImageView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor).isActive = true
        messageImageView.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
        messageImageView.widthAnchor.constraint(equalTo: bubbleView.widthAnchor).isActive = true
        messageImageView.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true
        
        
        
        playButton.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true
        playButton.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        
        activityIndicatorView.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
        activityIndicatorView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        activityIndicatorView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        
        
        // ios9 constraints
        //x, y, w, h
        profileImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImage.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 32).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        
        //x, y, w, h
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        bubbleViewRightAnchor?.isActive = true
        
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 8)
        //bubbleViewLeftAnchor?.isActive = true
        
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        
        //x, y, w, h
        //textView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        
        //textView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) had not been implemented")
    }
    
}
