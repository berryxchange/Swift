//
//  profileTableViewCell.swift
//  TCIApp
//
//  Created by Quinton Quaye on 4/28/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

/*import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class profileTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var prayers : [Prayer] = []
    var user: User!
    var displayingData = [Any]()
    
    // needs firebase data pulled and installed
    var stringOfProfileImageView = ""
    var stringOfProfileName = ""
    var stringOfProfileUid = ""
    let usersRef = FIRDatabase.database().reference(withPath: "users")
    //end---------------
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        //Firebase getting data
        // preloads the data
        
        // this listens for changes in the values of the database (added, removed, changed)
        stringOfProfileUid = (FIRAuth.auth()?.currentUser?.uid)!
        
        // item references -------------------
        
        let prayerAgreementsItemRef = usersRef.child(self.stringOfProfileUid).child("PrayerAgreements")
        
        //end --------------------
        
        //Snapshots
        prayerAgreementsItemRef.queryOrdered(byChild: "prayerFullDate").observe(.value, with: {snapshot in
            
            print(snapshot)
            //2 new items are an empty array
            var newPrayerAgreements: [Prayer] = []
            
            //3 - for every item in snapshot as a child, the eventItem will be appended in the new items array list
            for item in snapshot.children {
                // 4
                
                let prayerAgreementItem = Prayer(snapshot: item as! FIRDataSnapshot)
                newPrayerAgreements.insert(prayerAgreementItem, at: 0)
                
            }
            
            
            
            // 5 - the main "events" are now the adjusted "newEvents"
            //self.events = newEvents
            
            self.prayers = newPrayerAgreements
            
            self.displayingData = self.self.prayers
            
            print("here is your displaying data!: \(self.prayers)")
            //imageArray = ["image.jpg", ... etc]
            
        })
        
        
        //end-----------
        
        
        
         // Initialization code
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return prayers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell: profileCollectionViewCell =  collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? profileCollectionViewCell {
            //let randomNumber = Int(arc4random_uniform(UInt32(titleArray.count)))
            
            //let thisPrayer = self.prayers[indexPath.row]
            //print("here is the second data: \(thisPrayer)")
            cell.collectionTitle.text = prayers[indexPath.row].prayerPostTitle
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let size = CGSize(width: 100, height: 125)
        
        return size
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
*/
