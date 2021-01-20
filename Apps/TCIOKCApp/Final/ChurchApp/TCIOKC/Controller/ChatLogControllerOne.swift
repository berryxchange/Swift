//
//  
//  TCIApp
//
//  Created by Quinton Quaye on 5/12/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import UIKit
import Firebase
import MobileCoreServices
import AVFoundation
import UserNotifications

private let reuseIdentifier = "Cell"
class ChatLogControllerOne: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var kind = 0
    var stringOfProfileImageView = ""
    var stringOfProfileName = ""
    var stringOfProfileUid = ""
    
    var user: Member? {
        didSet {
            if kind == 2 || kind == 1{
                navigationItem.title = user?.username
                
                observeMessages()
            }
        }
    }
    var churchName = "TCI"

    
    var messages = [Message]()
    
   
    
    func observeMessages(){
        
        var thisToId : String? = ""
        if kind == 2 || kind == 1{
            thisToId = user?.key
        }else if kind == 3{
            thisToId = stringOfProfileUid
        }
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid, let toId = thisToId else {
            return
        }
        
        let userMessagesRef = FIRDatabase.database().reference().child("user-messages").child(uid).child(toId)
        userMessagesRef.observe(.childAdded, with: { (snapshot) in
            //print(snapshot)
            
            let messageId = snapshot.key
            let messagesRef = FIRDatabase.database().reference().child("Messages").child(messageId)
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                //print(snapshot)
                
                guard let dictionary = snapshot.value as? [String: AnyObject] else {
                    return
                }
                
                self.messages.append(Message(dictionary: dictionary))
                
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                    
                    // scroll to the last index - this is also good for social scrolling wall
                    let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                    self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
                    
                }
                
                
            }, withCancel: nil)
            
        }, withCancel: nil)
    }
    
    
    
    
    
    
    // for the input text field
    // setting as "lazy var" instead of let, allows us to access "self"
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }() // this is the execution block parenthesis
    
   
    
    override func viewDidLoad() {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
        } else {
            print("Internet connection FAILED")
            let alert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default)
            
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
        
       
        super.viewDidLoad()
        if kind == 3{
            navigationItem.title = stringOfProfileName
            
            observeMessages()
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        self.collectionView!.register(chatLogCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Do any additional setup after loading the view.
        
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0) // this singly handles the content inside the collection view to all arrange from the edges
        //collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0) // this singly handles the content inside the collection view for the scroll
        
        // gives the keyboard a interactive dismissal
        collectionView?.keyboardDismissMode = .interactive
        
        self.collectionView!.backgroundColor = UIColor.white
        
        self.hideKeyboardWhenTappedAround()
        
        //setupInputComponents()
        // gets notification of keyboard
        //setupKeyboardObservers()
    }
    
    
    lazy var inputContainerView: UIView = {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y:0 , width: view.frame.width, height: 50)
        containerView.backgroundColor = UIColor.white
        
        
        // the image asset for the uploaded image
        let uploadImageView = UIImageView()
        uploadImageView.isUserInteractionEnabled = true
        uploadImageView.image = UIImage(named: "camera")
        uploadImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(uploadImageView)
        
        //x,y,w,h
        
        uploadImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        uploadImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        uploadImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        uploadImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(uploadTap)))
        
        
        
        // send button
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        // the trigger to send
        sendButton.addTarget(self, action: #selector(recheck), for: .touchUpInside)
        containerView.addSubview(sendButton)
        
        //x,y,w,h
        
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo:containerView.heightAnchor).isActive = true
        
        
        // the add of the above initiated inputTextField
        containerView.addSubview(inputTextField)
        
        //x,y,w,h
        
        self.inputTextField.leftAnchor.constraint(equalTo: uploadImageView.rightAnchor , constant: 8).isActive = true
        self.inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        self.inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor, constant: 8).isActive = true
        self.inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        let seperatorLineView = UIView()
        seperatorLineView.backgroundColor = UIColor.lightGray
        seperatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(seperatorLineView)
        
        //x,y,w,h
        
        seperatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        seperatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        seperatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        seperatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        return containerView
    }()
    
    override var inputAccessoryView: UIView? {
        get {
            return inputContainerView
        }
    }
    
    @objc func uploadTap(){
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        // for the video uploading
        if let videoUrl = info[UIImagePickerControllerMediaURL] as? NSURL {
            // we selected a video
            print("here is the video url" , videoUrl)
            videoSelectedForInfo(url: videoUrl)
            
        } else {
            
            //We selected an image
            imageSelectedForInfo(info: info as [String : AnyObject])
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    private func videoSelectedForInfo(url: NSURL) {
        let fileName = NSUUID().uuidString + ".mov"
        
        var thisToId : String? = ""
        if kind == 2 || kind == 1{
            thisToId = user?.key
        }else if kind == 3{
            thisToId = stringOfProfileUid
        }
        
        let uploadTask = FIRStorage.storage().reference().child("Messages").child("ChatVideos").child(thisToId!).child(fileName).putFile(url as URL, metadata: nil, completion: { (metadata, error) in
            
            if error != nil {
                print("Failed to upload video: ", error!)
                return
            }
            
            if let videoUrl = metadata?.downloadURL()?.absoluteString{
                
                if let thumbnailImage = self.thumbnailImageForFileUrl(fileUrl: url) {
                    
                    self.uploadToFirebaseStorageUsingImage(image: thumbnailImage, completion: { (imageUrl) in
                        let properties: [String: AnyObject] = ["imageUrl": imageUrl as AnyObject, "imageWidth": thumbnailImage.size.width as AnyObject, "imageHeight": thumbnailImage.size.height as AnyObject, "videoUrl": videoUrl as AnyObject]
                        self.SendMessageWithProperties(properties: properties)
                    })
                    
                    
                    
                    
                }
                
            }
        })
        
        uploadTask.observe(.progress) { (snapshot) in
            if let completedUnitCount = snapshot.progress?.completedUnitCount {
                self.navigationItem.title = "\(completedUnitCount)"
            }
        }
        var thisuserName : String? = ""
        if kind == 2 || kind == 1{
            thisuserName = self.user?.username
        }else if kind == 3{
            thisuserName = self.stringOfProfileName
        }
        
        uploadTask.observe(.success) { (snapshot) in
            self.navigationItem.title = thisuserName
        }
    }
    
    private func thumbnailImageForFileUrl(fileUrl: NSURL) -> UIImage? {
        let asset = AVAsset(url: fileUrl as URL)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(1, 60), actualTime: nil)
            
            return UIImage(cgImage: thumbnailCGImage)
        } catch let err {
            print(err)
        }
        
        
        return nil
        
    }
    
    private func imageSelectedForInfo(info: [String: AnyObject]){
        var selectedImageFromPicker: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] {
            
            selectedImageFromPicker = (editedImage as! UIImage)
        }else if let originalImage = info["UIImagePickerControllerOriginalImage"] {
            selectedImageFromPicker = (originalImage as! UIImage)
            
        }
        if let selectedImage = selectedImageFromPicker{
            uploadToFirebaseStorageUsingImage(image: selectedImage, completion: {(imageUrl) in
                self.SendMessageWithImageUrl(imageUrl: imageUrl, image: selectedImage)
            })
            
        }
    }
    // end------
    
    
    
    
    private func uploadToFirebaseStorageUsingImage(image: UIImage, completion: @escaping (_ imageUrl: String) -> ()){
        let imageName = UUID().uuidString
        let storageRef = FIRStorage.storage().reference().child("Messages").child("chat Image").child(imageName)
        
        if let uploadData = UIImageJPEGRepresentation(image, 0.2) {
            storageRef.put(uploadData, metadata: nil, completion: {(metadata, error) in
                
                if error != nil {
                    print("failed to upload Data", error!)
                    return
                }
                if let imageUrl = metadata?.downloadURL()?.absoluteString{
                    completion(imageUrl)
                    
                }
            })
            
        }
    }
    
    
    // Input view
    //override var inputAccessoryView: UIView? {
      //  get {
        //    return inputContainerView
        //}
   // }
    
    
    override var canBecomeFirstResponder: Bool { return true }
    
    
    // keyboard functions...
    func setupKeyboardObservers(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        
        //   NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        // NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardDidShow(){
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }
    
    
    // resolves memory leak
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    //end------
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        print(notification.userInfo!)
        
        let  keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        containerViewBottomAnchor?.constant = -keyboardFrame!.height
        
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        let  keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        containerViewBottomAnchor?.constant = 0
        
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
    }
    
    var containerViewBottomAnchor : NSLayoutConstraint?
    // end---------
    
    
    
    
    
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! chatLogCell
        
        cell.chatLogController = self
        
        
        
        let message = messages[indexPath.item]
        cell.message = message
        cell.textView.text = message.text
        
        setupCell(cell: cell, message: message)
        
        if let text = message.text {
            // a text message and not an image
            cell.bubbleWidthAnchor?.constant = estimatedFrameForText(text: text).width + 27
            cell.textView.isHidden = false
        }else if message.imageUrl != nil{
            //image falls in here
            cell.bubbleWidthAnchor?.constant = 200
            cell.textView.isHidden = true
        }
        
        if message.videoUrl != nil {
            cell.playButton.isHidden = false
        }else {
            cell.playButton.isHidden = true
        }
        
        // Configure the cell
        return cell
    }
    
    
    // the cleanup work of cell
    
    
    
    private func setupCell(cell: chatLogCell, message: Message){
        
        var thisuserImage : String? = ""
        if kind == 2 || kind == 1{
            thisuserImage = user?.userImageUrl
        }else if kind == 3{
            thisuserImage = stringOfProfileImageView
        }
        
        if let profileImageUrl = thisuserImage {
            cell.profileImage.loadImageUsingCacheWithURLString(urlString: profileImageUrl)
        }
        
        
        
        if message.fromId == FIRAuth.auth()?.currentUser?.uid {
            // outgoing blue
            cell.profileImage.isHidden = true
            cell.bubbleView.backgroundColor = UIColor.blue
            cell.textView.textColor = UIColor.white
            
            cell.bubbleViewRightAnchor?.isActive  = true
            cell.bubbleViewLeftAnchor?.isActive  = false
        } else {
            // incoming grey
            cell.profileImage.isHidden = false
            cell.bubbleView.backgroundColor = UIColor.lightGray
            cell.textView.textColor = UIColor.black
            
            cell.bubbleViewRightAnchor?.isActive  = false
            cell.bubbleViewLeftAnchor?.isActive  = true
            
        }
        
        if let messageImageUrl = message.imageUrl {
            cell.messageImageView.loadImageUsingCacheWithURLString(urlString: messageImageUrl)
            cell.messageImageView.isHidden = false
            cell.bubbleView.backgroundColor = UIColor.clear
        }else {
            cell.messageImageView.isHidden = true
            
        }
        
    }
    
    
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 80
        
        let message = messages[indexPath.item]
        if let text = message.text {
            height = estimatedFrameForText(text: text).height + 20
        }else if let imageWidth = message.imageWidth?.floatValue, let imageHeight = message.imageHeight?.floatValue{
            
            //h1 / w1 = h2 / w2
            // solve for h1
            // h1 = h2 / w2 * w1
            
            height = CGFloat(imageHeight / imageWidth * 200)
        }
        
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height)
    }
    
    // important
    private func estimatedFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    
    /* for adjusting text field distance from bottom
     func animateTextField(textField: UITextField, up: Bool)
     {
     let movementDistance:CGFloat = -260
     let movementDuration: Double = 0.3
     
     var movement:CGFloat = 0
     if up
     {
     movement = movementDistance
     }
     else
     {
     movement = -movementDistance
     }
     UIView.beginAnimations("animateTextField", context: nil)
     UIView.setAnimationBeginsFromCurrentState(true)
     UIView.setAnimationDuration(movementDuration)
     self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
     UIView.commitAnimations()
     }
     
     
     
     func textFieldDidBeginEditing(_ textField: UITextField)
     {
     self.animateTextField(textField: textField, up:true)
     }
     
     func textFieldDidEndEditing(_ textField: UITextField)
     {
     self.animateTextField(textField: textField, up:false)
     }
     
     
     */
    
    @objc func recheck(){
        if inputTextField.text == "" {
            
            let alert = UIAlertController(title: "Cannot Send", message: "the text field is empty.", preferredStyle: .alert)
            
            let closeAction = UIAlertAction(title: "Close", style: .default) { action in
            }
            
            // actions of the alert controller
            alert.addAction(closeAction)
            
            // action to present the alert controller
            present(alert, animated: true, completion: nil)
        }else {
            
            let properties = ["text": inputTextField.text!]
            SendMessageWithProperties(properties: properties as [String : AnyObject])
            
            inputTextField.text = ""
        }
        
    }
    
    private func SendMessageWithImageUrl(imageUrl: String, image: UIImage){
        
        let properties: [String: AnyObject] = ["imageUrl": imageUrl as AnyObject, "imageWidth": image.size.width as AnyObject, "imageHeight": image.size.height as AnyObject]
        
        SendMessageWithProperties(properties: properties)
    }
    
    
    private func SendMessageWithProperties(properties: [String: AnyObject]){
        let ref = FIRDatabase.database().reference().child("Messages")
        let childRef = ref.childByAutoId()
        
        var thisToId : String? = ""
        if kind == 2 || kind == 1{
            thisToId = user!.key
        }else if kind == 3{
            thisToId = stringOfProfileUid
        }
        
        let toUid = thisToId
        let fromId = FIRAuth.auth()!.currentUser!.uid
        let timestamp = Int(Date().timeIntervalSince1970)
        var values: [String : Any] = ["toUid": toUid!,  "fromId": fromId, "timestamp": timestamp]
        
        // append properties dictionary onto values somehow
        //key $0, value $1
        properties.forEach({values[$0] = $1})
        
        
        childRef.updateChildValues(values){(error, ref) in
            if error != nil {
                print(error!)
                return
            }
            // the senders data
            let userMessagesRef = FIRDatabase.database().reference().child("user-messages").child(fromId).child(toUid!)
            
            let messageId = childRef.key
            userMessagesRef.updateChildValues([messageId: 1])
            
            
            // the receivers data
            let recipientUserMessagesRef = FIRDatabase.database().reference().child("user-messages").child(toUid!).child(fromId)
            recipientUserMessagesRef.updateChildValues([messageId : 1])
            
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == inputTextField {
            textField.resignFirstResponder()
        }
        recheck()
        return true
    }
    
    var startingFrame: CGRect?
    var blackBackgroundView: UIView?
    
    
    // my custom zooming logic
    
    func performZomingForStartingImageView(startingImageView: UIImageView){
        hideKeyboardWhenTappedAround()
        startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
        let zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView.backgroundColor = UIColor.blue
        zoomingImageView.image = startingImageView.image
        zoomingImageView.addGestureRecognizer(UITapGestureRecognizer (target: self, action: #selector(zoomOut)))
        zoomingImageView.isUserInteractionEnabled = true
        
        if let keyWindow = UIApplication.shared.keyWindow{
            blackBackgroundView = UIView(frame: keyWindow.frame)
            blackBackgroundView?.backgroundColor = UIColor.black
            blackBackgroundView?.alpha = 0
            keyWindow.addSubview(blackBackgroundView!)
            
            keyWindow.addSubview(zoomingImageView)
            
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
                
                self.blackBackgroundView?.alpha = 1
                self.inputContainerView.alpha = 0
                
                
                // math?
                //h2 / w1 = h1 / w1
                //h2 = h1 / w1 * w1
                
                let height = self.startingFrame!.height / self.startingFrame!.width * keyWindow.frame.width
                
                zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                
                zoomingImageView.center = keyWindow.center
                
                
            }) { (completed) in
                // Do nothing
                
            }
            
        }
    }
    
    
    
    @objc func zoomOut(tapGesture: UITapGestureRecognizer){
        if let zoomOutImageView = tapGesture.view{
            zoomOutImageView.layer.cornerRadius = 16
            zoomOutImageView.clipsToBounds = true
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                zoomOutImageView.frame = self.startingFrame!
                self.blackBackgroundView?.alpha = 0
                self.inputContainerView.alpha = 1
            }) { (completed) in
                // Do something here...
                zoomOutImageView.removeFromSuperview()
                
            }
        }
    }
    
    
    
    // notifications
    
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func done(_ sender: Any) {
        if  kind == 3{
            dismiss(animated: true, completion: nil)
            
        } else if kind == 2 {
            performSegue(withIdentifier: "unwindToMessagesControllerRegular", sender: self)
            print("unwinded  2")
        }else if kind == 1{
            dismiss(animated: true, completion: nil)
            
            print("unwinded 1 ")
        }
        
    }
}
