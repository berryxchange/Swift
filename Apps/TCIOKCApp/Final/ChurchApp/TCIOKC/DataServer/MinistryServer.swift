//
//  MinistryServer.swift
//  TCIApp
//
//  Created by Quinton Quaye on 12/27/17.
//  Copyright © 2017 Quinton Quaye. All rights reserved.
//

import Foundation

struct MinistryData {
    var churchName = "Transformation Church International"
    var pastorialTitle = "Pastor"
    var pastorName = "Clarance Johnson"
    
    var users: [ChurchUser] = []
    
    var ministries: [Ministry] = [
        Ministry(ministryIcon: "Events Icon", ministryTitle: "Events", ministrySubtitle: "Major Church Events"),
        //Ministry(ministryIcon: "Star", ministryTitle: "Weekly Bulliten", ministrySubtitle: "Weekly Provided Bullitens"),
        Ministry(ministryIcon: "Media Icon", ministryTitle: "Media", ministrySubtitle: "Sermons, Media, Podcasts and Other"),
        Ministry(ministryIcon: "Social Icon", ministryTitle: "Social", ministrySubtitle: "Interactive Social Media and Newsfeed"),
        Ministry(ministryIcon: "Prayer Icon", ministryTitle: "Prayer", ministrySubtitle: "Prayer Requests and Prayer Wall"),
        Ministry(ministryIcon: "Pastoral Blog Icon", ministryTitle: "Pastoral Blog", ministrySubtitle: "Pastoral Provided Blog Messages"),
        Ministry(ministryIcon: "Bible Icon", ministryTitle: "Bible", ministrySubtitle: "Find, Read, Know Your Bible"),
        Ministry(ministryIcon: "Chat Icon", ministryTitle: "Chat", ministrySubtitle: "Get Connected"),
        //Ministry(ministryIcon: "Church Info Icon", ministryTitle: "Church Info", ministrySubtitle: "Church information")
        
        
    ]
    
    var associatesMinistries: [Ministry] = [
        Ministry(ministryIcon: "Events Icon", ministryTitle: "Events", ministrySubtitle: "Major Church Events"),
        //Ministry(ministryIcon: "Star", ministryTitle: "Weekly Bulliten", ministrySubtitle: "Weekly Provided Bullitens"),
        Ministry(ministryIcon: "Media Icon", ministryTitle: "Media", ministrySubtitle: "Sermons, Media, Podcasts and Other"),
        Ministry(ministryIcon: "Social Icon", ministryTitle: "Social", ministrySubtitle: "Interactive Social Media and Newsfeed"),
        Ministry(ministryIcon: "Prayer Icon", ministryTitle: "Prayer", ministrySubtitle: "Prayer Requests and Prayer Wall"),
        Ministry(ministryIcon: "Pastoral Blog Icon", ministryTitle: "Pastoral Blog", ministrySubtitle: "Pastoral Provided Blog Messages"),
        Ministry(ministryIcon: "Bible Icon", ministryTitle: "Bible", ministrySubtitle: "Find, Read, Know Your Bible"),
        Ministry(ministryIcon: "Chat Icon", ministryTitle: "Chat", ministrySubtitle: "Get Connected"),
        //Ministry(ministryIcon: "Class Icon", ministryTitle: "Class", ministrySubtitle: "Manage Your Students"),
        //Ministry(ministryIcon: "Church Info Icon", ministryTitle: "Church Info", ministrySubtitle: "Church information")
    ]
    
    
    var administratorMinistries: [Ministry] = [
        Ministry(ministryIcon: "Events Icon", ministryTitle: "Events", ministrySubtitle: "Major Church Events"),
        //Ministry(ministryIcon: "Star", ministryTitle: "Weekly Bulliten", ministrySubtitle: "Weekly Provided Bullitens"),
        Ministry(ministryIcon: "Media Icon", ministryTitle: "Media", ministrySubtitle: "Sermons, Media, Podcasts and Other"),
        Ministry(ministryIcon: "Social Icon", ministryTitle: "Social", ministrySubtitle: "Interactive Social Media and Newsfeed"),
        Ministry(ministryIcon: "Prayer Icon", ministryTitle: "Prayer", ministrySubtitle: "Prayer Requests and Prayer Wall"),
        Ministry(ministryIcon: "Pastoral Blog Icon", ministryTitle: "Pastoral Blog", ministrySubtitle: "Pastoral Provided Blog Messages"),
        Ministry(ministryIcon: "Bible Icon", ministryTitle: "Bible", ministrySubtitle: "Find, Read, Know Your Bible"),
        Ministry(ministryIcon: "Chat Icon", ministryTitle: "Chat", ministrySubtitle: "Get Connected"),
        //Ministry(ministryIcon: "Class Icon", ministryTitle: "Class", ministrySubtitle: "Manage Your Students"),
        Ministry(ministryIcon: "Dashboard Icon", ministryTitle: "Dashboard", ministrySubtitle: "Manage Accounts"),
        //Ministry(ministryIcon: "Church Info Icon", ministryTitle: "Church Info", ministrySubtitle: "Church information")
        
    ]
    
    /*var socialMediaPosts: [SocialMediaPost] = [
        SocialMediaPost(socialMediaIcon: "Group 11", byUserName: "Facebook", timeAndDate: "\(Date())", userUploadImage: "vacation", userPostText: "Over the mountain", userPostTextStatus: "Valina just Posted a new image!", userIcon: "Star", socialDetails: ""),
        SocialMediaPost(socialMediaIcon: "Group 11", byUserName: "Twitter", timeAndDate: "\(Date())", userUploadImage: "nature", userPostText: "In the pine bluff", userPostTextStatus: "Carl just Posted a new image!", userIcon: "Star", socialDetails: ""),
        SocialMediaPost(socialMediaIcon: "Group 11", byUserName: "Instagram", timeAndDate: "\(Date())", userUploadImage: "travelling", userPostText: "Oh the scenes you'll see!", userPostTextStatus: "Joleen just Posted a new image!", userIcon: "Star", socialDetails: ""),
        SocialMediaPost(socialMediaIcon: "Group 11", byUserName: "Facebook", timeAndDate: "\(Date())", userUploadImage: "icecream", userPostText: "Yuuummmm!", userPostTextStatus: "Agnis just Posted a new image!", userIcon: "Star", socialDetails: ""),
        SocialMediaPost(socialMediaIcon: "Group 11", byUserName: "Facebook", timeAndDate: "\(Date())", userUploadImage: "city", userPostText: "Living for the city", userPostTextStatus: "Marqquez just Posted a new image!", userIcon: "Star", socialDetails: "")
    ]
    */
    var media: [Media] = [
        Media(mediaTitle: "Get Right Before Tonight", mediaDate: "\(Date())", hostName: "Carlton Bailey"),
        Media(mediaTitle: "It's Coming Today!", mediaDate: "\(Date())", hostName: "Carlton Bailey"),
        Media(mediaTitle: "Are You Ready?!", mediaDate: "\(Date())", hostName: "Carlton Bailey"),
        Media(mediaTitle: "He Is Here To Answer You", mediaDate: "\(Date())", hostName: "Marrisa Tomei"),
        Media(mediaTitle: "Giving Back", mediaDate: "\(Date())", hostName: "Carlton Bailey")
        
    ]
    
   /* var prayers: [Prayer] = [
        Prayer(prayerPostTitle: "Pray for my cousin Josapheen", prayerPostMessage: "Donec facilisis tortor ut augue lacinia, at viverra est semper. Sed sapien metus, scelerisque nec pharetra id, tempor a tortor. Pellentesque non dignissim neque. Ut porta viverra est, ut dignissim elit elementum ut. Nunc vel rhoncus nibh, ut tincidunt turpis. Integer ac enim pellentesque, adipiscing metus id, pharetra odio. \n \n Donec bibendum nunc sit amet tortor scelerisque luctus et sit amet mauris. Suspendisse felis sem, condimentum ullamcorper est sit amet, molestie mollis nulla. Etiam lorem orci, consequat ac magna quis, facilisis vehicula neque. Donec facilisis tortor ut augue lacinia, at viverra est semper. Sed sapien metus, scelerisque nec pharetra id, tempor a tortor.", prayerPostPersonName: "Anna McKormic", prayerPostDateMonth: "JAN", prayerPostDateDay: "24", prayerFullDate: "", prayerPostAgreements: 12),
        Prayer(prayerPostTitle: "Pray for Thomas", prayerPostMessage: "Donec facilisis tortor ut augue lacinia, at viverra est semper. Sed sapien metus, scelerisque nec pharetra id, tempor a tortor. Pellentesque non dignissim neque. Ut porta viverra est, ut dignissim elit elementum ut. Nunc vel rhoncus nibh, ut tincidunt turpis. Integer ac enim pellentesque, adipiscing metus id, pharetra odio. \n \n Donec bibendum nunc sit amet tortor scelerisque luctus et sit amet mauris. Suspendisse felis sem, condimentum ullamcorper est sit amet, molestie mollis nulla. Etiam lorem orci, consequat ac magna quis, facilisis vehicula neque. Donec facilisis tortor ut augue lacinia, at viverra est semper. Sed sapien metus, scelerisque nec pharetra id, tempor a tortor.", prayerPostPersonName: "Julie Seizer", prayerPostDateMonth: "OCT", prayerPostDateDay: "02", prayerFullDate: "", prayerPostAgreements: 4),
        Prayer(prayerPostTitle: "Pray for me", prayerPostMessage: "Donec facilisis tortor ut augue lacinia, at viverra est semper. Sed sapien metus, scelerisque nec pharetra id, tempor a tortor. Pellentesque non dignissim neque. Ut porta viverra est, ut dignissim elit elementum ut. Nunc vel rhoncus nibh, ut tincidunt turpis. Integer ac enim pellentesque, adipiscing metus id, pharetra odio. \n \n Donec bibendum nunc sit amet tortor scelerisque luctus et sit amet mauris. Suspendisse felis sem, condimentum ullamcorper est sit amet, molestie mollis nulla. Etiam lorem orci, consequat ac magna quis, facilisis vehicula neque. Donec facilisis tortor ut augue lacinia, at viverra est semper. Sed sapien metus, scelerisque nec pharetra id, tempor a tortor.", prayerPostPersonName: "The Q", prayerPostDateMonth: "SEP", prayerPostDateDay: "11", prayerFullDate: "", prayerPostAgreements: 84),
        Prayer(prayerPostTitle: "Pray for USA", prayerPostMessage: "Donec facilisis tortor ut augue lacinia, at viverra est semper. Sed sapien metus, scelerisque nec pharetra id, tempor a tortor. Pellentesque non dignissim neque. Ut porta viverra est, ut dignissim elit elementum ut. Nunc vel rhoncus nibh, ut tincidunt turpis. Integer ac enim pellentesque, adipiscing metus id, pharetra odio. \n \n Donec bibendum nunc sit amet tortor scelerisque luctus et sit amet mauris. Suspendisse felis sem, condimentum ullamcorper est sit amet, molestie mollis nulla. Etiam lorem orci, consequat ac magna quis, facilisis vehicula neque. Donec facilisis tortor ut augue lacinia, at viverra est semper. Sed sapien metus, scelerisque nec pharetra id, tempor a tortor.", prayerPostPersonName: "President of USA", prayerPostDateMonth: "JUL", prayerPostDateDay: "04", prayerFullDate: "", prayerPostAgreements: 2),
        Prayer(prayerPostTitle: "Pray for my mom", prayerPostMessage: "Donec facilisis tortor ut augue lacinia, at viverra est semper. Sed sapien metus, scelerisque nec pharetra id, tempor a tortor. Pellentesque non dignissim neque. Ut porta viverra est, ut dignissim elit elementum ut. Nunc vel rhoncus nibh, ut tincidunt turpis. Integer ac enim pellentesque, adipiscing metus id, pharetra odio. \n \n Donec bibendum nunc sit amet tortor scelerisque luctus et sit amet mauris. Suspendisse felis sem, condimentum ullamcorper est sit amet, molestie mollis nulla. Etiam lorem orci, consequat ac magna quis, facilisis vehicula neque. Donec facilisis tortor ut augue lacinia, at viverra est semper. Sed sapien metus, scelerisque nec pharetra id, tempor a tortor.", prayerPostPersonName: "Patty LaBelle", prayerPostDateMonth: "MAR", prayerPostDateDay: "18", prayerFullDate: "", prayerPostAgreements: 44),
        Prayer(prayerPostTitle: "Pray for my family", prayerPostMessage: "Donec facilisis tortor ut augue lacinia, at viverra est semper. Sed sapien metus, scelerisque nec pharetra id, tempor a tortor. Pellentesque non dignissim neque. Ut porta viverra est, ut dignissim elit elementum ut. Nunc vel rhoncus nibh, ut tincidunt turpis. Integer ac enim pellentesque, adipiscing metus id, pharetra odio. \n \n Donec bibendum nunc sit amet tortor scelerisque luctus et sit amet mauris. Suspendisse felis sem, condimentum ullamcorper est sit amet, molestie mollis nulla. Etiam lorem orci, consequat ac magna quis, facilisis vehicula neque. Donec facilisis tortor ut augue lacinia, at viverra est semper. Sed sapien metus, scelerisque nec pharetra id, tempor a tortor.", prayerPostPersonName: "Joel Amous", prayerPostDateMonth: "AUG", prayerPostDateDay: "15", prayerFullDate: "", prayerPostAgreements: 9),
        Prayer(prayerPostTitle: "Pray for my new job!", prayerPostMessage: "Donec facilisis tortor ut augue lacinia, at viverra est semper. Sed sapien metus, scelerisque nec pharetra id, tempor a tortor. Pellentesque non dignissim neque. Ut porta viverra est, ut dignissim elit elementum ut. Nunc vel rhoncus nibh, ut tincidunt turpis. Integer ac enim pellentesque, adipiscing metus id, pharetra odio. \n \n Donec bibendum nunc sit amet tortor scelerisque luctus et sit amet mauris. Suspendisse felis sem, condimentum ullamcorper est sit amet, molestie mollis nulla. Etiam lorem orci, consequat ac magna quis, facilisis vehicula neque. Donec facilisis tortor ut augue lacinia, at viverra est semper. Sed sapien metus, scelerisque nec pharetra id, tempor a tortor.", prayerPostPersonName: "Billy Stevens", prayerPostDateMonth: "MAR", prayerPostDateDay: "24", prayerFullDate: "", prayerPostAgreements: 0),
        Prayer(prayerPostTitle: "Pray for the new year", prayerPostMessage: "Donec facilisis tortor ut augue lacinia, at viverra est semper. Sed sapien metus, scelerisque nec pharetra id, tempor a tortor. Pellentesque non dignissim neque. Ut porta viverra est, ut dignissim elit elementum ut. Nunc vel rhoncus nibh, ut tincidunt turpis. Integer ac enim pellentesque, adipiscing metus id, pharetra odio. \n \n Donec bibendum nunc sit amet tortor scelerisque luctus et sit amet mauris. Suspendisse felis sem, condimentum ullamcorper est sit amet, molestie mollis nulla. Etiam lorem orci, consequat ac magna quis, facilisis vehicula neque. Donec facilisis tortor ut augue lacinia, at viverra est semper. Sed sapien metus, scelerisque nec pharetra id, tempor a tortor.", prayerPostPersonName: "Sarah Thomas", prayerPostDateMonth: "JAN", prayerPostDateDay: "01", prayerFullDate: "", prayerPostAgreements: 90),
        Prayer(prayerPostTitle: "Pray for my cousin Barbra", prayerPostMessage: "Donec facilisis tortor ut augue lacinia, at viverra est semper. Sed sapien metus, scelerisque nec pharetra id, tempor a tortor. Pellentesque non dignissim neque. Ut porta viverra est, ut dignissim elit elementum ut. Nunc vel rhoncus nibh, ut tincidunt turpis. Integer ac enim pellentesque, adipiscing metus id, pharetra odio. \n \n Donec bibendum nunc sit amet tortor scelerisque luctus et sit amet mauris. Suspendisse felis sem, condimentum ullamcorper est sit amet, molestie mollis nulla. Etiam lorem orci, consequat ac magna quis, facilisis vehicula neque. Donec facilisis tortor ut augue lacinia, at viverra est semper. Sed sapien metus, scelerisque nec pharetra id, tempor a tortor.", prayerPostPersonName: "Eliza Ellis", prayerPostDateMonth: "FEB", prayerPostDateDay: "24", prayerFullDate: "", prayerPostAgreements: 204),
        Prayer(prayerPostTitle: "Pray for my church", prayerPostMessage: "Donec facilisis tortor ut augue lacinia, at viverra est semper. Sed sapien metus, scelerisque nec pharetra id, tempor a tortor. Pellentesque non dignissim neque. Ut porta viverra est, ut dignissim elit elementum ut. Nunc vel rhoncus nibh, ut tincidunt turpis. Integer ac enim pellentesque, adipiscing metus id, pharetra odio. \n \n Donec bibendum nunc sit amet tortor scelerisque luctus et sit amet mauris. Suspendisse felis sem, condimentum ullamcorper est sit amet, molestie mollis nulla. Etiam lorem orci, consequat ac magna quis, facilisis vehicula neque. Donec facilisis tortor ut augue lacinia, at viverra est semper. Sed sapien metus, scelerisque nec pharetra id, tempor a tortor.", prayerPostPersonName: "Pastor Rob Schneider", prayerPostDateMonth: "JUN", prayerPostDateDay: "05", prayerFullDate: "", prayerPostAgreements: 6),
    ]
 */
    
    /*var pastorialBlogs: [Blog] = [
        Blog(blogTitle: "I Come Forth", blogMesage: "Donec facilisis tortor ut augue lacinia, at viverra est semper. Sed sapien metus, scelerisque nec pharetra id, tempor a tortor. Pellentesque non dignissim neque. Ut porta viverra est, ut dignissim elit elementum ut. Nunc vel rhoncus nibh, ut tincidunt turpis. Integer ac enim pellentesque, adipiscing metus id, pharetra odio. \n \n Donec bibendum nunc sit amet tortor scelerisque luctus et sit amet mauris. Suspendisse felis sem, condimentum ullamcorper est sit amet, molestie mollis nulla. Etiam lorem orci, consequat ac magna quis, facilisis vehicula neque. Donec facilisis tortor ut augue lacinia, at viverra est semper. Sed sapien metus, scelerisque nec pharetra id, tempor a tortor. \n \n Pellentesque non dignissim neque. Ut porta viverra est, ut dignissim elit elementum ut. Nunc vel rhoncus nibh, ut tincidunt turpis. Integer ac enim pellentesque, adipiscing metus id, pharetra odio. Donec bibendum nunc sit amet tortor scelerisque luctus et sit amet mauris. \n \n Suspendisse felis sem, condimentum ullamcorper est sit amet, molestie mollis nulla. Etiam lorem orci, consequat ac magna quis, facilisis vehicula neque.", blogDate: "\(Date())", blogImage: "vacation"),
        
        Blog(blogTitle: "Stepping out in the Name of God", blogMesage: "Donec facilisis tortor ut augue lacinia, at viverra est semper. Sed sapien metus, scelerisque nec pharetra id, tempor a tortor. Pellentesque non dignissim neque. Ut porta viverra est, ut dignissim elit elementum ut. Nunc vel rhoncus nibh, ut tincidunt turpis. Integer ac enim pellentesque, adipiscing metus id, pharetra odio. Donec bibendum nunc sit amet tortor scelerisque luctus et sit amet mauris. Suspendisse felis sem, condimentum ullamcorper est sit amet, molestie mollis nulla. Etiam lorem orci, consequat ac magna quis, facilisis vehicula neque.", blogDate: "\(Date())", blogImage: "city"),
        
        Blog(blogTitle: "Give Me What's Mine!", blogMesage: "Donec facilisis tortor ut augue lacinia, at viverra est semper. Sed sapien metus, scelerisque nec pharetra id, tempor a tortor. Pellentesque non dignissim neque. Ut porta viverra est, ut dignissim elit elementum ut. Nunc vel rhoncus nibh, ut tincidunt turpis. Integer ac enim pellentesque, adipiscing metus id, pharetra odio. Donec bibendum nunc sit amet tortor scelerisque luctus et sit amet mauris. Suspendisse felis sem, condimentum ullamcorper est sit amet, molestie mollis nulla. Etiam lorem orci, consequat ac magna quis, facilisis vehicula neque.", blogDate: "\(Date())", blogImage: "travelling"),
        
        Blog(blogTitle: "I Come Forth", blogMesage: "Donec facilisis tortor ut augue lacinia, at viverra est semper. Sed sapien metus, scelerisque nec pharetra id, tempor a tortor. Pellentesque non dignissim neque. Ut porta viverra est, ut dignissim elit elementum ut. Nunc vel rhoncus nibh, ut tincidunt turpis. Integer ac enim pellentesque, adipiscing metus id, pharetra odio. \n \n Donec bibendum nunc sit amet tortor scelerisque luctus et sit amet mauris. Suspendisse felis sem, condimentum ullamcorper est sit amet, molestie mollis nulla. Etiam lorem orci, consequat ac magna quis, facilisis vehicula neque. Donec facilisis tortor ut augue lacinia, at viverra est semper. Sed sapien metus, scelerisque nec pharetra id, tempor a tortor. \n \n Pellentesque non dignissim neque. Ut porta viverra est, ut dignissim elit elementum ut. Nunc vel rhoncus nibh, ut tincidunt turpis. Integer ac enim pellentesque, adipiscing metus id, pharetra odio. Donec bibendum nunc sit amet tortor scelerisque luctus et sit amet mauris. \n \n Suspendisse felis sem, condimentum ullamcorper est sit amet, molestie mollis nulla. Etiam lorem orci, consequat ac magna quis, facilisis vehicula neque.", blogDate: "\(Date())", blogImage: "vacation"),
        
        Blog(blogTitle: "Stepping out in the Name of God", blogMesage: "Donec facilisis tortor ut augue lacinia, at viverra est semper. Sed sapien metus, scelerisque nec pharetra id, tempor a tortor. Pellentesque non dignissim neque. Ut porta viverra est, ut dignissim elit elementum ut. Nunc vel rhoncus nibh, ut tincidunt turpis. Integer ac enim pellentesque, adipiscing metus id, pharetra odio. Donec bibendum nunc sit amet tortor scelerisque luctus et sit amet mauris. Suspendisse felis sem, condimentum ullamcorper est sit amet, molestie mollis nulla. Etiam lorem orci, consequat ac magna quis, facilisis vehicula neque.", blogDate: "\(Date())", blogImage: "city"),
        
        Blog(blogTitle: "Give Me What's Mine!", blogMesage: "Donec facilisis tortor ut augue lacinia, at viverra est semper. Sed sapien metus, scelerisque nec pharetra id, tempor a tortor. Pellentesque non dignissim neque. Ut porta viverra est, ut dignissim elit elementum ut. Nunc vel rhoncus nibh, ut tincidunt turpis. Integer ac enim pellentesque, adipiscing metus id, pharetra odio. Donec bibendum nunc sit amet tortor scelerisque luctus et sit amet mauris. Suspendisse felis sem, condimentum ullamcorper est sit amet, molestie mollis nulla. Etiam lorem orci, consequat ac magna quis, facilisis vehicula neque.", blogDate: "\(Date())", blogImage: "travelling"),
        
        Blog(blogTitle: "I Come Forth", blogMesage: "Donec facilisis tortor ut augue lacinia, at viverra est semper. Sed sapien metus, scelerisque nec pharetra id, tempor a tortor. Pellentesque non dignissim neque. Ut porta viverra est, ut dignissim elit elementum ut. Nunc vel rhoncus nibh, ut tincidunt turpis. Integer ac enim pellentesque, adipiscing metus id, pharetra odio. \n \n Donec bibendum nunc sit amet tortor scelerisque luctus et sit amet mauris. Suspendisse felis sem, condimentum ullamcorper est sit amet, molestie mollis nulla. Etiam lorem orci, consequat ac magna quis, facilisis vehicula neque. Donec facilisis tortor ut augue lacinia, at viverra est semper. Sed sapien metus, scelerisque nec pharetra id, tempor a tortor. \n \n Pellentesque non dignissim neque. Ut porta viverra est, ut dignissim elit elementum ut. Nunc vel rhoncus nibh, ut tincidunt turpis. Integer ac enim pellentesque, adipiscing metus id, pharetra odio. Donec bibendum nunc sit amet tortor scelerisque luctus et sit amet mauris. \n \n Suspendisse felis sem, condimentum ullamcorper est sit amet, molestie mollis nulla. Etiam lorem orci, consequat ac magna quis, facilisis vehicula neque.", blogDate: "\(Date())", blogImage: "vacation"),
        
        Blog(blogTitle: "Stepping out in the Name of God", blogMesage: "Donec facilisis tortor ut augue lacinia, at viverra est semper. Sed sapien metus, scelerisque nec pharetra id, tempor a tortor. Pellentesque non dignissim neque. Ut porta viverra est, ut dignissim elit elementum ut. Nunc vel rhoncus nibh, ut tincidunt turpis. Integer ac enim pellentesque, adipiscing metus id, pharetra odio. Donec bibendum nunc sit amet tortor scelerisque luctus et sit amet mauris. Suspendisse felis sem, condimentum ullamcorper est sit amet, molestie mollis nulla. Etiam lorem orci, consequat ac magna quis, facilisis vehicula neque.", blogDate: "\(Date())", blogImage: "city"),
        
        Blog(blogTitle: "Give Me What's Mine!", blogMesage: "Donec facilisis tortor ut augue lacinia, at viverra est semper. Sed sapien metus, scelerisque nec pharetra id, tempor a tortor. Pellentesque non dignissim neque. Ut porta viverra est, ut dignissim elit elementum ut. Nunc vel rhoncus nibh, ut tincidunt turpis. Integer ac enim pellentesque, adipiscing metus id, pharetra odio. Donec bibendum nunc sit amet tortor scelerisque luctus et sit amet mauris. Suspendisse felis sem, condimentum ullamcorper est sit amet, molestie mollis nulla. Etiam lorem orci, consequat ac magna quis, facilisis vehicula neque.", blogDate: "\(Date())", blogImage: "travelling")
       
    ]
    */
   /* var Events: [Event] = [
        
        Event(eventImage: "Event1", eventIcon: "", eventTitle: "Joy baxter", eventSubtitle: "Come enjoy the new blasting album of Joy Baxter!", eventDescription: "A full concert of Joy Baxter live.", eventdate: "1/22/2018", eventTime: "7pm", eventLocation: "Transformation Church International", peopleGoing: 5),
        Event(eventImage: "Event2", eventIcon: "", eventTitle: "Pumpkin Run", eventSubtitle: "A Run for new pumpkins!", eventDescription: "A day the church youth group will go to our local pumpkin farm to pick fresh pumpkins to take home and enjoy.", eventdate: "10/20/2018", eventTime: "3pm", eventLocation: "Transformation Church International", peopleGoing: 19),
        Event(eventImage: "Event3", eventIcon: "", eventTitle: "New Blues", eventSubtitle: "Come enjoy great music", eventDescription: "An outdoor blues concert", eventdate: "9/15/2018", eventTime: "7pm", eventLocation: "Transformation Church International", peopleGoing: 49),
        
        Event(eventImage: "Event4", eventIcon: "", eventTitle: "Mega Revival", eventSubtitle: "The time is near come get revived!", eventDescription: "A yearly planned revival that envolves our local churches and groups to come together to be revived through the powerful word of God", eventdate: "6/5/2018", eventTime: "4pm", eventLocation: "Transformation Church International", peopleGoing: 78),
        
        Event(eventImage: "Event5", eventIcon: "", eventTitle: "NovaNova", eventSubtitle: "The biggest Concert you've ever seen", eventDescription: "A full outdoor concert like you've never seen.", eventdate: "8/16/2018", eventTime: "6pm", eventLocation: "Transformation Church International", peopleGoing: 3020)
        
    ]
 
 */
    
    var weeklyBullien: [Bulliten] = [
        Bulliten(bullitenName: "Make Your House Full", bullitenDate: "Tuesday, July-15-2017"),
        Bulliten(bullitenName: "Today Is Your Day", bullitenDate: "Tuesday, march-8-2017"),
        Bulliten(bullitenName: "Make Your House Full", bullitenDate: "Tuesday, Feb-19-2017")
    ]
    
    
    
}
