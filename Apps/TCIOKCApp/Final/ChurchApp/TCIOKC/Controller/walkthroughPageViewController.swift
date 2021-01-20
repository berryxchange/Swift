//
//  walkthroughPageViewController.swift
//  TCIApp
//
//  Created by Quinton Quaye on 6/20/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import UIKit

class walkthroughPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    var viewingIntroWalkthrough = false
    var viewingEventsWalkthrough = false
    var viewingSocialWalkthrough = false
    var viewingPrayerWalkthrough = false
    var viewingPastoralWalkthrough = false
    var viewingChatWalkthrough = false
    var viewingClassWalkthrough = false
    var viewingDashboardWalkthrough = false
    var viewingProfileWalkthrough = false
   
    var pageTitles = [""]
    var pageDescriptions = [""]
    var pageImages = [""]


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if viewingIntroWalkthrough == true {
            pageTitles = ["Welcome!", "Introduction","Events", "Media", "Social", "Prayer", "Pastoral", "Bible", "Chat", "Dashboard", "Profile"]
            
            pageDescriptions = ["Welcome to TCI App! We are glad you are connected with us, lets begin…", "There are a few areas we should review before you get started.", "Will be the place to view your church's upcoming events, parties, practices, plays, classes, etc. will be held", "Where you can view your church's live-stream service, pre-recorded sermons, and other hosted media.", "A place all members share their life’s important events, for everyone to enjoy.", "A delicate place that members can confidently post prayers in faith, while others can agree with them.", "A place where members can stay up to date with their pastor(s) for encouragement and enjoyment.", "Connects to Bible.com, where members can fully utilize and get the most out of their bible.", "A feature that allows members to communicate with one another and stay connected.", "An administrative feature that allows admins to mass email or text their members as well as regulate them.", "Your personal dashboard to your data, tithing, saved content and more!"]
            
            pageImages = ["Intro Background1", "Intro Background 2", "Event Background", "Media Background", "Social Background", "Prayer Background", "Pastoral Blog Background", "Bible Background", "Chat Background", "Dashboard Background", "Profile Background"]
            
        }else if viewingEventsWalkthrough == true {
            pageTitles = ["Adding A Group", "Your Groups","Going","Past","All","Groups","Categories","Groups","Edit Group","Adding An Event","Viewing Members","Message Creator","Viewing Events","Editing An Event","Viewing Group", "Class Videos", "Class Discussion", "Other Events", "Reporting A Group"]
            
            pageDescriptions = ["To add your new group, click the \"New Group\" button in the top right corner", "To view all the groups you are apart of, click the \"See All\" button", "To view the events you are going to, click the \"GOING\" button", "To view past events you gave gone to, click the\"PAST\" button", "To view all events, click the \"ALL\" button", "To find new groups to join, click the \"Groups\" tab at the bottom", "If there are groups created, you may select a category, else, create one when you create your group", "Once you choose a category, choose your group", "If you are the creator of the group, the \"Edit\" button appears", "If you are the creator of the group, the \"Add Event\" button appears", "If you want to view all members apart of the group, click the row of member images", "To contact the group creator for information, click the \" Message\" button in the organizer section", "To view group events, check the bottom of the group page in the events section", "If you are the creator of the group and want to edit an event, click the \"Edit\" button in the top right", "To view the event group, click the group tab at the top of the event page", "To view your class videos, click the video image in the event video section", "To join in class discussions, click the \"Join The Discussion\" button in the group discusssion section", "To view other events from this group, scroll to the bottom of the event page", "Should you find any group with inappropriate behavior, click the (Report Group) button and submit a notice."]
            
            pageImages = ["Group Main Background","Group Main Background 1", "Group Main Background 2", "Group Main Background 3", "Group Main Background 4", "Group Main Background 5", "Group Main Background 6", "Group Main Background 7", "Group Main Background 8", "Group Main Background 9", "Group Main Background 10", "Group Main Background 11", "Group Main Background 12", "Group Main Background 13", "Group Main Background 14", "Group Main Background 15","Group Main Background 16", "Group Main Background 17", "Group Main Background 18"]
            
        }else if viewingSocialWalkthrough == true {
            pageTitles = ["Add", "Edit", "Delete", "Like", "User Details","Reporting A Post"]
            
            pageDescriptions = ["To add your post, click the “plus sign” at the top right.", "To edit a post, click on any of your posts, then click on the edit button in the top right.", "To delete a post, scroll to any of your post on the main social wall, swipe left on your post and click delete.", "To like any post, click the post you are interested in, scroll to the bottom and select the like button.", "To view a post’s user profile, click their post, then click their profile image.","Should you find any post with inappropriate behavior, click the (Report Post) button and submit a notice."]
            
            pageImages = ["Social 1 Background", "Social 2 Background", "Social 3 Background", "Social 4 Background", "Social 5 Background", "Social 6 Background"]
            
        }else if viewingPrayerWalkthrough == true {
            pageTitles = ["Add", "Agree"]
            
            pageDescriptions = ["To add your prayer, click the “plus sign” at the top right.",  "To show someone that you are standing in agreement with them in their prayer, click their prayer, scroll down and click the praying hands."]
            
            pageImages = ["Prayer 1 Background", "Prayer 3 Background"]
            
        }else if viewingPastoralWalkthrough == true {
            pageTitles = ["Add", "Edit", "Delete", "Like"]
            
            pageDescriptions = ["(For admin or pastors only) To add your post, click the “plus sign” at the top right.", "(For admin or pastors only) To edit your post, click on any one, then click on the edit button in the top right.", "(For admin or pastors only) To delete a post, swipe left on any post, then click delete.", "To like any post, simply click the interested post, then scroll to the bottom and select the like button."]
            
            pageImages = ["Pastoral 1 Background", "Pastoral 2 Background", "Pastoral 3 Background", "Pastoral 4 Background"]
            
        }else if viewingChatWalkthrough == true {
            pageTitles = ["Start A Chat", "Re-Chat"]
            
            pageDescriptions = ["To begin a conversation, simply click the compose button at the top right and select your partner.", "To continue a previously started conversation, for conveinience, your chat is placed on the main chat list, just select your partner and chat."]
            
            pageImages = ["Chat 1 Background", "Chat 2 Background"]
            
        }else if viewingClassWalkthrough == true {
            pageTitles = ["Add A Class", "Delete", "Add A Student", "Student Detail", "Contact Parent(s)", "Take Attendance", "Edit A Student", "Delete A Student"]
            
            pageDescriptions = ["(For associates and admins only) To add a class, simply click the add button in the top right.", "(For associates and admins only) To delete a class and its content, simply swipe left on the class you want and click delete.", "(For associates and admins only) To add a student in your class, simply click into your class, then select the add button in the top right.", "(For associates and admins only) To view a students detail information, simply click that student.", "(For associates and admins only) To contact a parent of a specific student, click the desired student, then scroll down and click the contact parent button.", "(For associates and admins only) To take attendance, simply click the attendance button, then select each present student, then click the submit button.", "(For associates and admins only) To edit a students information, click the desired student, then click then click the edit button in the top right.", "(For associates and admins only) To delete a student, simply select the desired student, click the edit button in the top right, scroll down and click delete."]
            
            pageImages = ["Class 1 Background", "Class 2 Background", "Class 3 Background", "Class 4 Background", "Class 5 Background", "Class 6 Background", "Class 7 Background", "Class 8 Background"]
            
        }else if viewingDashboardWalkthrough == true {
            pageTitles = ["Mass Messaging","Complaints","Complaint Detail","Message Plaintiff","Message Defendant","Mark As Resolved","Delete A Complaint", "User Roles"]
            
            pageDescriptions = ["(For admins only) A place to send out important information, notifications and updates about things in your church to everyone, at the same time.","By clicking the complaints tab, you are able to handle all complaints from users.","In the detail of each complaint, you can view each plaintiff and defendant and hopefully resolve their issue.","If you need to get clarity or send a resolvement to the plaintiff, you can click the Message Plaintiff button.","If you need to get clarity or send a resolvement to the defendant, you can click the Message Defendant button.","To mark this complaint as resolved, you can click the Mark As Resolved button, and the main page will mark the message in green.","To clear the queue from resolved complaints, swipe left on the complaint you want to get rid of and click delete.", "By clicking the Roles tab, you are able to regulate any user and give them an administrative role."]
            
            pageImages = ["Dashboard 1 Background", "Dashboard 2 Background", "Dashboard 3 Background", "Dashboard 4 Background", "Dashboard 5 Background", "Dashboard 6 Background", "Dashboard 7 Background", "Dashboard 8 Background"]
            
        }else if viewingProfileWalkthrough == true {
            pageTitles = ["Edit", "Tithe", "Interested Events", "Social Posts", "Prayers", "Prayer Agreements", "Liked Social Posts", "Liked Pastoral Posts", "Delete Account", "Reporting A User"]
            
            pageDescriptions = ["To edit your profile information, simply goto your profile from the main page and click the edit button in the top right.", "To send in your tithe, goto your profile, scroll to the bottom of the page and click tithe.", "Once you have clicked the “Interested” button in Events, that event will then be stored here in “Interests”.", "Once you have posted a social post, that post will also be stored here in “Social”.", "If you have posted a prayer, that prayer will also be stored here in “Prayer”.", "If you are supporting someone in their prayer, that prayer will also be stored here in “Agreements”.", "If you have liked someones social post, that post will be stored here in “Social Likes”", "If you have liked your pastor’s post, that post will be stored here in “Pastoral Likes”", "To delete your account and all your data and information, goto your profile, and scroll to the bottom, then click delete.","Should you find any user repeatedly posting inappropriate behavior, click the (Report Profile) button on their profile page and submit a notice."]
            
            pageImages = ["Profile 1 Background", "Profile 2 Background", "Profile 3 Background", "Profile 4 Background", "Profile 5 Background", "Profile 6 Background", "Profile 7 Background", "Profile 8 Background", "Profile 9 Background", "Profile 10 Background"]
            
        }
        
        
        dataSource = self
        // Create the first walkthrough screen
        if let startingViewController = contentViewController(at: 0) {
            setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalkthroughContentViewController).index
        index -= 1
        return contentViewController(at: index)
    }
    
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalkthroughContentViewController).index
        index += 1
        return contentViewController(at: index)
    }
    
    
    func contentViewController(at index: Int) -> WalkthroughContentViewController?{
        if index < 0 || index >= pageTitles.count {
            return nil
        }
        // create a new view controller and pass suitable data
        if let pageContentViewContoller = storyboard?.instantiateViewController(withIdentifier: "walkthroughContentViewController") as? WalkthroughContentViewController {
            
            pageContentViewContoller.wImage = pageImages[index]
            pageContentViewContoller.wTitle = pageTitles[index]
            pageContentViewContoller.wDescription = pageDescriptions[index]
            pageContentViewContoller.index = index
            
            return pageContentViewContoller
        }
        return nil
        
    }
    
    
    func next(index: Int){
        if let nextViewController = contentViewController(at: index + 1){
            setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

