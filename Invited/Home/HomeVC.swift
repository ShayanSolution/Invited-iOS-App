//
//  HomeVC.swift
//  Invited
//
//  Created by ShayanSolutions on 5/22/18.
//  Copyright © 2018 ShayanSolutions. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import Contacts
import TwitterKit
import FBSDKLoginKit
import MessageUI

class UserList: NSObject
{
    var name = String()
    var id = Int()
    var contactList = [ContactData]()
    
}
class EventData: NSObject
{
    var eventID = Int()
    var title = String()
    var eventAddress = String()
    var listID = Int()
    var listName = String()
    var eventTime = String()
    var eventCreatedTime = String()
    var lat = String()
    var long = String()
    var paymentMethod = Int()
    var whoWillPay = String()
    var userID = Int()
    var totalInvited = Int()
    var numberOfInvitationAccepted = Int()
    var numberOfInvitationRejected = Int()
    var eventAcceptedBy = Int()
    var createdBy = String()
    var isCreatedByAdmin = String()
    var confirmed = Int()
    var phone = String()
    var eventType = String()
    var firstName = String()
    var lastName = String()
    var fullName = String()
    var maximumNumberOfPeople = Int()
    var userList = [ContactData]()
    var acceptedEventList = [EventAcceptedData]()
    var invitedBy = UserData()
    
}
class UserData: NSObject
{
    var id = Int()
    var firstName = String()
    var lastName = String()
    var userName = String()
    var email = String()
    var phone = String()
    
}
class EventAcceptedData: NSObject
{
    var id = Int()
    var eventID = Int()
    var invitee = UserData()
    
}
extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String) -> NSMutableAttributedString {
        if #available(iOS 8.2, *) {
            let attrs: [NSAttributedStringKey: Any] = [.font: UIFont.systemFont(ofSize: 15.0, weight: .semibold)]
            
            let boldString = NSMutableAttributedString(string:text, attributes: attrs)
            append(boldString)
        }
        
        else {
            // Fallback on earlier versions
        }
        
        
        return self
    }
    
    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        let normal = NSAttributedString(string: text)
        append(normal)
        
        return self
    }
}



@available(iOS 9.0, *)
class HomeVC : UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,CLLocationManagerDelegate{
    

    
    var locationManager = CLLocationManager()
    
    @IBOutlet var lineView: UIView!

    
    @IBOutlet var myListsButton: UIButton!
    @IBOutlet var createInviteButton: UIButton!
    @IBOutlet var invitesStatusButton: UIButton!
    
    @IBOutlet var myListsView: UIView!
    @IBOutlet var createInviteView: UIView!
    @IBOutlet var invitesStatusView: UIView!
    
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet var mainScrollView: UIScrollView!
    
    
//    var userList = [UserList]()
    
    var contactsView : ContactsView!
    var createEventView : CreateEventView!
    var eventStatusView : EventStatusView!
    var requestEventView : RequestEventView!
    var yourEventsView : YourEventsView!
    var receivedEventsView : ReceivedEventsView!
    var detailView : DetailView!
    var editEventView : CreateEventView!
    var eventDetailView : EventDetailView!
    var sentByMeView : SentByMeView!
    var acceptByMeView : AcceptByMeView!
    
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()
    
    var currentLocationCoordinate : CLLocationCoordinate2D?
    var locationCoordinate : CLLocationCoordinate2D?
    
    var placeSelectedORCancelled : Bool!
    
//    var selectedButton : UIButton!
    
    var currentLocationAddress : String?
    var selectedLocationAddress : String?
    
    var userEventList = [EventData]()
    var requestEventList = [EventData]()
    var receivedRequestEventList = [EventData]()
    var invitedList : [ContactData]!
    var acceptedEventList = [EventAcceptedData]()
    
    var dropDownPickerView : UIPickerView!
    var dropDownPickerView2 : UIPickerView!
    
    var selectedList : UserList?
    var updateSelectedList : UserList?
    var isUpdated : Bool!
//    var isStartNavigationButtonTapped : Bool!
    var listID : Int?
    
    var selectedLat : String?
    var selectedLong : String?
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.mainScrollView.frame.size.width = self.view.frame.size.width
        
//        self.isStartNavigationButtonTapped = false
        self.isUpdated = false
        
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
//        self.locationManager.startUpdatingLocation()
        
        self.detailView  = DetailView.instanceFromNib() as? DetailView
        self.eventDetailView  = EventDetailView.instanceFromNib() as? EventDetailView
        self.acceptByMeView  = AcceptByMeView.instanceFromNib() as? AcceptByMeView
        self.sentByMeView  = SentByMeView.instanceFromNib() as? SentByMeView
        
        
        
        
        
        self.placeSelectedORCancelled = false
        
        
        self.setUpScrollView()
        self.getProfileFromServer()
//        self.fetchUserEventsFromServer()
        
//        self.fetchRequestsFromServer()
//        self.fetchReceivedRequestsFromServer()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.receivedNotification(notification:)), name: Notification.Name("ReceiveNotificationData"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.appDidBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
//        let tapRecognizer = UITapGestureRecognizer()
//        tapRecognizer.addTarget(self, action: #selector(self.didTapView))
//        self.view.addGestureRecognizer(tapRecognizer)
        
//        CNContactStore().requestAccess(for: .contacts, completionHandler: { granted, error in
//            if (granted){
//                
//                BasicFunctions.query()
//                //
//            }
//            
//        })
        
    
    }
    @objc func appDidBecomeActive()
    {
        
//        self.locationManager.startUpdatingLocation()
        self.requestEventView.requestEventTableView.reloadData()
        self.receivedEventsView.receivedEventsTableView.reloadData()
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.detailView.titleTextView.setContentOffset(.zero, animated: false)
        self.eventDetailView.titleTextView.setContentOffset(.zero, animated: false)
        self.acceptByMeView.titleTextView.setContentOffset(.zero, animated: false)
        self.sentByMeView.eventName.setContentOffset(.zero, animated: false)
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        if  self.isUpdated == false && self.placeSelectedORCancelled == true
        {
            let point = CGPoint(x: self.mainScrollView.frame.size.width, y: 0)
            self.mainScrollView.setContentOffset(point, animated: false)
            self.placeSelectedORCancelled = false
            
            self.selectedLocationAddress = BasicFunctions.getPreferences(kSelectedAddress) as? String
            if self.selectedLocationAddress != nil
            {
                self.createEventView.locationTextField.text = self.selectedLocationAddress
                
                
            
            }
//            else
//            {
//                self.createEventView.locationTextField.text = self.currentLocationAddress
//            }
            
        }
        else if self.isUpdated == true && self.placeSelectedORCancelled == true
        {
            let point = CGPoint(x: self.mainScrollView.frame.size.width * 2, y: 0)
            self.mainScrollView.setContentOffset(point, animated: false)
            self.placeSelectedORCancelled = false
            
            self.selectedLocationAddress = BasicFunctions.getPreferences(kSelectedAddress) as? String
            if self.selectedLocationAddress != nil
            {
                self.editEventView.locationTextField.text = self.selectedLocationAddress
                
                
                
            }
//            else
//            {
//                self.reverseGeocodeCoordinate(self.currentLocationCoordinate)
//            }
            
            
        }
//        else if self.isStartNavigationButtonTapped == true
//        {
//            self.isStartNavigationButtonTapped = false
//
//            let point = CGPoint(x: self.mainScrollView.frame.size.width * 2, y: 0)
//            self.mainScrollView.setContentOffset(point, animated: false)
//
//        }
        else
        {
            if (self.lineView.frame.origin.x != self.myListsView.frame.origin.x) {
                
                UIView.animate(withDuration: 0.25) {
                    
                    self.lineView.frame.origin.x = self.myListsView.frame.origin.x
                    
                }
                
            }
            let point = CGPoint(x: 0, y: 0)
            self.mainScrollView.setContentOffset( point, animated: true)
            
            if kUserList.count < 1
            {
            self.getContactListFromServer()
            }
            
        }
        
        
        
        
        
        
    }
//    func fetchAllContactsFromDevice()  {
//
//            var contacts: [CNContact] = {
//                let contactStore = CNContactStore()
//                let keysToFetch = [
//                    CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
//                    CNContactEmailAddressesKey,
//                    CNContactPhoneNumbersKey,
//                    CNContactImageDataAvailableKey,
//                    CNContactThumbnailImageDataKey] as [Any]
//
//                // Get all the containers
//                var allContainers: [CNContainer] = []
//                do {
//                    allContainers = try contactStore.containers(matching: nil)
//                } catch {
//                    print("Error fetching containers")
//                }
//
//
//
//                // Iterate all containers and append their contacts to our results array
//                for container in allContainers {
//                    let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
//
//                    do {
//                        let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
//                        self.results.append(contentsOf: containerResults)
//                        //                        self.storeDataInModelObjects()
//                    } catch {
//                        print("Error fetching results for container")
//                    }
//                }
//                self.storeDataInModelObjects()
//                return self.results
//            }()
//
//    }
//    func storeDataInModelObjects()  {
//
//        kContactList.removeAll()
//
//        for contact in self.results
//        {
//            let contactData = ContactData()
//            contactData.name = contact.givenName + " " + contact.familyName
//            //            contactData.phoneNumber = ((contact.phoneNumbers.first?.value)?.stringValue)!
//            if contact.isKeyAvailable(CNContactPhoneNumbersKey){
//                let phoneNOs=contact.phoneNumbers
//                for item in phoneNOs
//                {
//                    contactData.phoneNumber = item.value.stringValue
//                }
//            }
//
//
//            kContactList.append(contactData)
//        }
//    }
    
    
//    override func viewDidDisappear(_ animated: Bool)
//    {
////        super.viewDidDisappear(true)
//
//        self.view.endEditing(true)
//    }
    
//    @objc func didTapView(){
//        self.view.endEditing(true)
//    }

    
    @objc func receivedNotification(notification : Notification)
    {
//        self.backButtonTapped()
        
        if (self.lineView.frame.origin.x != self.invitesStatusView.frame.origin.x) {

            UIView.animate(withDuration: 0.25) {

                self.lineView.frame.origin.x = self.invitesStatusView.frame.origin.x

            }

        }

        var point = CGPoint(x: 2 * self.mainScrollView.frame.size.width, y: 0)
        self.mainScrollView.setContentOffset( point, animated: true)
        
        
        
        let status = notification.userInfo!["status"] as! String
        if status == "request" ||  status == "cancelled" || status == "closed"
        {


            if (self.eventStatusView.lineView.frame.origin.x != self.eventStatusView.invitesReceivedView.frame.origin.x) {

                UIView.animate(withDuration: 0.25) {

                    self.eventStatusView.lineView.frame.origin.x = self.eventStatusView.invitesReceivedView.frame.origin.x

                }


            }
            point = CGPoint(x: 0, y: 0)
            self.eventStatusView.mainScrollView.setContentOffset( point, animated: true)
            self.fetchRequestsFromServer()
            
        }
        else if status == "confirmed"   //  status == "accepted"
        {

            if (self.eventStatusView.lineView.frame.origin.x != self.eventStatusView.myEventsView.frame.origin.x) {

                UIView.animate(withDuration: 0.25) {

                    self.eventStatusView.lineView.frame.origin.x = self.eventStatusView.myEventsView.frame.origin.x

                }


            }
            point = CGPoint(x: self.eventStatusView.mainScrollView.frame.size.width * 2, y: 0)
            self.eventStatusView.mainScrollView.setContentOffset( point, animated: true)
            self.fetchReceivedRequestsFromServer()
            
            
        }
        
        
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {

        if locations.count > 0
        {
            self.currentLocationCoordinate = locations.last?.coordinate
            kCurrentLocation = self.currentLocationCoordinate
            
            
            self.reverseGeocodeCoordinate((locations.last?.coordinate)!)
            
        }
        
        
        
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
    }
    // Reverse GeoCode.
    func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
        
        BasicFunctions.showActivityIndicator(vu: self.view)
        
        // 1
        let geocoder = GMSGeocoder()
        
        // 2
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            
            BasicFunctions.stopActivityIndicator(vu: self.view)
            
            if error != nil
            {
                BasicFunctions.showAlert(vc: self, msg: error?.localizedDescription)
                return
            }
            
            guard let address = response?.firstResult(), let lines = address.lines else {
                return
            }
            
            // 3
            self.currentLocationAddress = lines.joined(separator: "\n")
            if self.editEventView != nil && self.isUpdated
            {
                self.editEventView.locationTextField.text = self.currentLocationAddress
            }
            else
            {
                self.createEventView.locationTextField.text = self.currentLocationAddress
            }
            
            
        }
    }
    
    @IBAction func menuButtonTapped(_ sender: UIButton)
    {
        BasicFunctions.openLeftMenu(vc: self)
    }
    
    
    @IBAction func addButtonTapped(_ sender: UIButton)
    {
//                CNContactStore().requestAccess(for: .contacts, completionHandler: { granted, error in
//                    if (granted){
//        
//                        BasicFunctions.query()
//                        //
//                    }
//        
//                })
        
        let createListVC = self.storyboard?.instantiateViewController(withIdentifier: "CreateListVC")
        self.present(createListVC!, animated: true, completion: nil)
    }
    
    
    @IBAction func myListsButtonTapped(_ sender: UIButton)
    {
        if (self.lineView.frame.origin.x != self.myListsView.frame.origin.x) {
            
            UIView.animate(withDuration: 0.25) {
                
                self.lineView.frame.origin.x = self.myListsView.frame.origin.x
                
            }
            
        }
        let point = CGPoint(x: 0, y: 0)
        self.mainScrollView.setContentOffset( point, animated: false)
        self.isUpdated = false
    }
    
    @IBAction func createInviteButtonTapped(_ sender: UIButton)
    {
        if (self.lineView.frame.origin.x != self.createInviteView.frame.origin.x) {
            
            UIView.animate(withDuration: 0.25) {
                
                self.lineView.frame.origin.x = self.createInviteView.frame.origin.x
                
            }
            
        }
        self.isUpdated = false
        
        let point = CGPoint(x: self.mainScrollView.frame.size.width, y: 0)
        self.mainScrollView.setContentOffset( point, animated: false)
        
//        self.createEventView.titleTextView.text = "Invite Title"
//        self.createEventView.titleTextView.textColor = UIColor.lightGray
//        self.createEventView.setNumberOfPeopleTextfield.text = ""
//        self.createEventView.setListTextField.text = ""
//        self.createEventView.dateTextField.text = ""
//        self.createEventView.timeTextField.text = ""
        
        
        
//        self.createEventView.locationTextField.text = self.currentLocationAddress
        
//        self.createEventView.setListTextField.text = ""
//        self.selectedList = nil
        
        UserDefaults.standard.removeObject(forKey: kSelectedLat)
        UserDefaults.standard.removeObject(forKey: kSelectedLong)
        UserDefaults.standard.removeObject(forKey: kSelectedAddress)
        UserDefaults.standard.synchronize()
        
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                print("Not determined")
                
                
                
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
//                self.locationManager.startUpdatingLocation()
                
            case .denied, .restricted:
                BasicFunctions.showSettingsAlert(vc: self, msg: "Invited requires access to your location. Please allow it in Settings.")
                self.currentLocationCoordinate = nil
                self.currentLocationAddress = nil
                self.createEventView.locationTextField.text = ""
            }
            
        } else {
            BasicFunctions.showSettingsAlert(vc: self, msg: "Invited requires access to your location. Please allow it in Settings.")
            
        }
        
        
        
        
    }
    
    @IBAction func invitesStatusButtonTapped(_ sender: UIButton)
    {
        if (self.lineView.frame.origin.x != self.invitesStatusView.frame.origin.x) {
            
            UIView.animate(withDuration: 0.25) {
                
                self.lineView.frame.origin.x = self.invitesStatusView.frame.origin.x
                
            }
            
        }
        
        let point = CGPoint(x: 2 * self.mainScrollView.frame.size.width, y: 0)
        self.mainScrollView.setContentOffset( point, animated: false)
        
        
        if self.eventStatusView.lineView.frame.origin.x == 0
        {
            self.fetchRequestsFromServer()
        }
        else if self.eventStatusView.lineView.frame.origin.x == self.eventStatusView.invitesSentView.frame.origin.x
        {
            self.fetchUserEventsFromServer()
        }
        else
        {
            self.fetchReceivedRequestsFromServer()
        }
        
    }
    
    func setUpScrollView()
    {
        self.contactsView = ContactsView.instanceFromNib() as? ContactsView
        
        self.contactsView.frame = CGRect(x: 0 , y: 0, width: Int(self.mainScrollView.frame.size.width), height: Int(self.mainScrollView.frame.size.height))
        self.contactsView.contactsTableView.register(UINib(nibName: "ContactCell", bundle: nil), forCellReuseIdentifier: "ContactCell")
        self.contactsView.contactsTableView.delegate = self
        self.contactsView.contactsTableView.dataSource = self
        
        self.mainScrollView.addSubview(self.contactsView)
        
        self.createEventView = CreateEventView.instanceFromNib() as? CreateEventView
        self.createEventView.frame = CGRect(x: Int(self.mainScrollView.frame.size.width) , y: 0, width: Int(self.mainScrollView.frame.size.width), height: Int(self.mainScrollView.frame.size.height))
        
//        self.createEventView.titleTextField.attributedPlaceholder = NSAttributedString(string: "Invite Title",
//                                                               attributes: [NSAttributedStringKey.foregroundColor: UIColor.darkGray])
//        self.createEventView.titleTextField.attributedPlaceholder = NSAttributedString(string: "Invite Title",
//                                                                                       attributes: [NSAttributedStringKey.foregroundColor: UIColor.darkGray])
        
//        self.createEventView.titleTextView.tag = 1
        self.createEventView.timeTextField.tag = 1
        self.createEventView.dateTextField.tag = 1
        self.createEventView.locationTextField.tag = 3
        self.createEventView.setNumberOfPeopleTextfield.tag = 1
        self.createEventView.setListTextField.tag = 1
        
//        self.createEventView.titleTextView.delegate = self
        self.createEventView.setNumberOfPeopleTextfield.delegate = self
        self.createEventView.timeTextField.delegate = self
        self.createEventView.dateTextField.delegate = self
        self.createEventView.locationTextField.delegate = self
        self.createEventView.setListTextField.delegate = self
        
//        self.createEventView.timeTextField.isUserInteractionEnabled = false
//        self.createEventView.dateTextField.isUserInteractionEnabled = false
//        self.createEventView.locationTextField.isUserInteractionEnabled = false
        
        self.showPicker(textField: self.createEventView.setListTextField)
        
        self.showDatePicker(textField: self.createEventView.dateTextField)
        self.showTimePicker(textField: self.createEventView.timeTextField)
        
        self.addDoneButtonOnKeyboard(textField: self.createEventView.setNumberOfPeopleTextfield)
        
        self.addDoneButtonOnTextViewKeyboard(textView: self.createEventView.titleTextView)
        
//        self.createEventView.iWillPayButton.addTarget(self, action: #selector(self.radioButtonTapped(sender:)), for: UIControlEvents.touchUpInside)
//        self.createEventView.youWillPayButton.addTarget(self, action: #selector(self.radioButtonTapped(sender:)), for: UIControlEvents.touchUpInside)
        
//        self.createEventView.locationTextField.text = self.currentLocationAddress
        
//        self.createEventView.allButton.addTarget(self, action: #selector(self.radioButtonTapped(sender:)), for: UIControlEvents.touchUpInside)
        
//        self.selectedButton = createEventView.iWillPayButton
        
        
        
        self.createEventView.createButton.addTarget(self, action: #selector(self.createButtonTapped), for: UIControlEvents.touchUpInside)
        
        self.createEventView.timeSwitch.addTarget(self, action: #selector(self.switchStateChanged(sender:)), for: UIControlEvents.touchUpInside)
        self.createEventView.dateSwitch.addTarget(self, action: #selector(self.switchStateChanged(sender:)), for: UIControlEvents.touchUpInside)
        self.createEventView.locationSwitch.addTarget(self, action: #selector(self.switchStateChanged(sender:)), for: UIControlEvents.touchUpInside)
        self.createEventView.updateButton.addTarget(self, action: #selector(self.updateButtonTapped), for: UIControlEvents.touchUpInside)
        
        self.mainScrollView.addSubview(self.createEventView)
        
        
        
        self.eventStatusView = EventStatusView.instanceFromNib() as? EventStatusView
        self.eventStatusView.frame = CGRect(x: Int(self.mainScrollView.frame.size.width * 2) , y: 0, width: Int(self.mainScrollView.frame.size.width), height: Int(self.mainScrollView.frame.size.height))
        
        self.eventStatusView.invitesReceivedButton.addTarget(self, action: #selector(self.tapOnEventStatusViewTabs(_:)), for: UIControlEvents.touchUpInside)
        self.eventStatusView.invitesSentButton.addTarget(self, action: #selector(self.tapOnEventStatusViewTabs(_:)), for: UIControlEvents.touchUpInside)
        self.eventStatusView.myEventsButton.addTarget(self, action: #selector(self.tapOnEventStatusViewTabs(_:)), for: UIControlEvents.touchUpInside)
        
        self.setUpStatusScrollView()
        
        self.mainScrollView.addSubview(self.eventStatusView)
        
        
        
        self.mainScrollView.contentSize.width = self.mainScrollView.frame.size.width * 3
        self.mainScrollView.isPagingEnabled = true
    }
    func setUpStatusScrollView()
    {
        self.requestEventView = RequestEventView.instanceFromNib() as? RequestEventView
        
        self.requestEventView.frame = CGRect(x: 0 , y: 0, width: Int(self.eventStatusView.mainScrollView.frame.size.width), height: Int(self.eventStatusView.mainScrollView.frame.size.height))
        
        self.requestEventView.requestEventTableView.register(UINib(nibName: "RequestEventCell", bundle: nil), forCellReuseIdentifier: "RequestEventCell")
        
        self.requestEventView.requestEventTableView.delegate = self
        self.requestEventView.requestEventTableView.dataSource = self
        
        self.eventStatusView.mainScrollView.addSubview(self.requestEventView)
        
        
        self.yourEventsView = YourEventsView.instanceFromNib() as? YourEventsView
        
        self.yourEventsView.frame = CGRect(x: Int(self.view.frame.size.width) , y: 0, width: Int(self.eventStatusView.mainScrollView.frame.size.width), height: Int(self.eventStatusView.mainScrollView.frame.size.height))
        
        self.yourEventsView.yourEventsTableView.register(UINib(nibName: "YourEventsCell", bundle: nil), forCellReuseIdentifier: "YourEventsCell")
        
        self.yourEventsView.yourEventsTableView.delegate = self
        self.yourEventsView.yourEventsTableView.dataSource = self
        
        self.eventStatusView.mainScrollView.addSubview(self.yourEventsView)
        
        
        self.receivedEventsView = ReceivedEventsView.instanceFromNib() as? ReceivedEventsView
        
        self.receivedEventsView.frame = CGRect(x: Int(self.view.frame.size.width * 2) , y: 0, width: Int(self.eventStatusView.mainScrollView.frame.size.width), height: Int(self.eventStatusView.mainScrollView.frame.size.height))
        
        self.receivedEventsView.receivedEventsTableView.register(UINib(nibName: "ReceivedEventsCell", bundle: nil), forCellReuseIdentifier: "ReceivedEventsCell")
        
        self.receivedEventsView.receivedEventsTableView.delegate = self
        self.receivedEventsView.receivedEventsTableView.dataSource = self
        
        self.eventStatusView.mainScrollView.addSubview(self.receivedEventsView)
        
        
        
        self.eventStatusView.mainScrollView.contentSize.width = self.eventStatusView.mainScrollView.frame.size.width * 3
        self.eventStatusView.mainScrollView.isPagingEnabled = true
        
    }
    
    @objc func switchStateChanged(sender : UISwitch)
    {
        if sender.tag == 1
        {
            if sender.isOn
            {
                self.createEventView.locationTextField.isUserInteractionEnabled = true
                self.locationManager.startUpdatingLocation()
            }
            else
            {
                self.createEventView.locationTextField.isUserInteractionEnabled = false
                self.createEventView.locationTextField.text = ""
                self.currentLocationCoordinate = nil
                self.selectedLat = nil
                self.selectedLong = nil
            }
        }
        else if sender.tag == 2
        {
            self.createEventView.dateTextField.text = ""

            if sender.isOn
            {
                self.createEventView.dateTextField.isUserInteractionEnabled = true
            }
            else
            {
                self.createEventView.dateTextField.isUserInteractionEnabled = false
            }
        }
        else if sender.tag == 3
        {
            self.createEventView.timeTextField.text = ""

            if sender.isOn
            {
                self.createEventView.timeTextField.isUserInteractionEnabled = true
            }
            else
            {
                self.createEventView.timeTextField.isUserInteractionEnabled = false
            }
        }
        else if sender.tag == 4
        {
            if sender.isOn
            {
                self.editEventView.locationTextField.isUserInteractionEnabled = true
                self.locationManager.startUpdatingLocation()
            }
            else
            {
                self.editEventView.locationTextField.isUserInteractionEnabled = false
                self.editEventView.locationTextField.text = ""
            }
        }
        else if sender.tag == 5
        {
            self.editEventView.dateTextField.text = ""
            
            if sender.isOn
            {
                self.editEventView.dateTextField.isUserInteractionEnabled = true
            }
            else
            {
                self.editEventView.dateTextField.isUserInteractionEnabled = false
            }
        }
        else if sender.tag == 6
        {
            self.editEventView.timeTextField.text = ""
            
            if sender.isOn
            {
                self.editEventView.timeTextField.isUserInteractionEnabled = true
            }
            else
            {
                self.editEventView.timeTextField.isUserInteractionEnabled = false
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return kUserList.count + 1
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if row == 0
        {
            return "Select List"
        }
        
        if kUserList.count != 0
        {
        return (kUserList[row - 1] ).name
        }
        return ""
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView.tag == 1
        {
        if kUserList.count != 0 && row != 0
        {
            self.selectedList = kUserList[row - 1]
            
            let count = self.selectedList?.contactList.count
            self.createEventView.setNumberOfPeopleTextfield.text = String(count!)
        
        }
        else
        {
            self.selectedList = nil
            self.createEventView.setListTextField.text = ""
            self.createEventView.setNumberOfPeopleTextfield.text = ""
            
        }
        }
        else
        {
            if kUserList.count != 0 && row != 0
            {
                self.updateSelectedList = kUserList[row - 1]
                
                let count = self.updateSelectedList?.contactList.count
                self.editEventView.setNumberOfPeopleTextfield.text = String(count!)
                
            }
            else
            {
                self.updateSelectedList = nil
                self.listID = nil
                
                self.editEventView.setListTextField.text = ""
                self.editEventView.setNumberOfPeopleTextfield.text = ""
                
            }
            
        }
        
    }
    
    
    @objc func tapOnEventStatusViewTabs(_ sender: UIButton)
    {
        self.backButtonTapped()
        var point = CGPoint(x: 0, y: 0)
        
        
        if sender.tag == 1
        {
        if (self.eventStatusView.lineView.frame.origin.x != self.eventStatusView.invitesReceivedView.frame.origin.x) {
            
            UIView.animate(withDuration: 0.25) {
                
                self.eventStatusView.lineView.frame.origin.x = self.eventStatusView.invitesReceivedView.frame.origin.x
                
            }
            
            
        }
            self.eventStatusView.mainScrollView.setContentOffset( point, animated: false)
            self.fetchRequestsFromServer()

        }
        else if sender.tag == 2
        {
            if (self.eventStatusView.lineView.frame.origin.x != self.eventStatusView.invitesSentView.frame.origin.x) {
                
                
                
                UIView.animate(withDuration: 0.25) {
                    
                    self.eventStatusView.lineView.frame.origin.x = self.eventStatusView.invitesSentView.frame.origin.x
                    
                }
                
            }
            
            point = CGPoint(x: self.eventStatusView.mainScrollView.frame.size.width, y: 0)
            self.eventStatusView.mainScrollView.setContentOffset( point, animated: false)
            self.fetchUserEventsFromServer()
            
        }
        else
        {
            if (self.eventStatusView.lineView.frame.origin.x != self.eventStatusView.myEventsView.frame.origin.x) {
                
                
                
                UIView.animate(withDuration: 0.25) {
                    
                    self.eventStatusView.lineView.frame.origin.x = self.eventStatusView.myEventsView.frame.origin.x
                    
                }
                
            }
            
            point = CGPoint(x: self.eventStatusView.mainScrollView.frame.size.width * 2, y: 0)
            self.eventStatusView.mainScrollView.setContentOffset( point, animated: false)
            self.fetchReceivedRequestsFromServer()
            
        }
        
        
    }
    
//    @objc func radioButtonTapped(sender:UIButton)
//    {
//        for button in (sender.superview?.subviews)!
//        {
//            if button.isKind(of: UIButton.self)
//            {
//                (button as! UIButton).isSelected = false
//            }
//        }
//
//        sender.isSelected = true
//        self.selectedButton = sender
//
//    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView.tag == 1
        {
        return kUserList.count
        }
        else if tableView.tag == 2
        {
            return self.requestEventList.count
        }
        else if tableView.tag == 3
        {
            return self.userEventList.count
        }
        else if tableView.tag == 4
        {
            return self.receivedRequestEventList.count
        }
        else if tableView.tag == 5
        {
            return self.acceptedEventList.count
        }
        return self.invitedList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        if tableView.tag == 1
        {
        
            var contactCell   = (tableView.dequeueReusableCell(withIdentifier: "ContactCell"))! as? ContactCell
        if contactCell == nil
        {
            contactCell = Bundle.main.loadNibNamed("ContactCell", owner: nil, options: nil)?[0] as? ContactCell
        }
            
            contactCell?.accessoryType = .detailButton
            contactCell?.deleteButton.isHidden = true
            
        
        let userListObject = kUserList[indexPath.row]
        
            contactCell!.nameLabel.text = userListObject.name
            
            return contactCell!
            
        }
        else if tableView.tag == 2
        {
            var requestEventCell  = (tableView.dequeueReusableCell(withIdentifier: "RequestEventCell"))! as? RequestEventCell
            if requestEventCell == nil
            {
                requestEventCell = Bundle.main.loadNibNamed("RequestEventCell", owner: nil, options: nil)?[0] as? RequestEventCell
            }
            
            let eventData = self.requestEventList[indexPath.row]
            
//            let dateformatter = DateFormatter()
//            dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//
//
//            let date = dateformatter.date(from: eventData.eventTime)
//
////            let createdDate = dateformatter.date(from: eventData.eventCreatedTime)
//
//            dateformatter.dateStyle = .medium
//            dateformatter.timeStyle = .short
            
//            dateformatter.dateStyle = .long
//            dateformatter.dateFormat = "dd/MM/yyyy"
//
//            let formatter2 = DateFormatter()
//            formatter2.dateFormat = "yyyy-MM-dd HH:mm:ss"
//
//            //        let timeString = eventData.eventTime.components(separatedBy: " ")[1
//            let time = formatter2.date(from: eventData.eventTime)
//
//            formatter2.timeStyle = .medium
//            formatter2.dateFormat = "hh:mm a"
            
            var invitedBy : String!
            
            let fullName = BasicFunctions.getNameFromContactList(phoneNumber: eventData.phone)
            
            if fullName == " "
            {
                invitedBy = eventData.phone
            }
            else
            {
                invitedBy = fullName + " " + "(" + eventData.phone + ")"
            }
            

            requestEventCell?.eventName.text = eventData.title
//            requestEventCell?.eventCreatedDate.attributedText = NSMutableAttributedString().bold("Date and time of invite sent : ").normal(dateformatter.string(from: createdDate!))
            
            
            requestEventCell?.createdBy.attributedText = NSMutableAttributedString().bold("Invited by: ").normal(invitedBy)
//            requestEventCell?.listName.attributedText = NSMutableAttributedString().bold("List name : ").normal(eventData.listName)
            requestEventCell?.location.attributedText = NSMutableAttributedString().bold("Location: ").normal(eventData.eventAddress)
//            requestEventCell?.totalInvited.attributedText = NSMutableAttributedString().bold("Total Invited : ").normal(String(eventData.totalInvited))
            
            if eventData.eventTime.isEmpty
            {
                requestEventCell?.eventDateHeightConstraint.constant = 0
            }
            else
            {
                requestEventCell?.eventDateHeightConstraint.constant = 40
                requestEventCell?.date.attributedText = NSMutableAttributedString().bold(BasicFunctions.getTitleAccordingToDateAndTimeFormat(dateTimeString: eventData.eventTime)).normal(eventData.eventTime)
            }
            
            if eventData.eventAddress.isEmpty
            {
                requestEventCell?.locationHeightConstraint.constant = 0
                requestEventCell?.startNavigationViewHeightConstraint.constant = 0
            
            }
            else
            {
                requestEventCell?.locationHeightConstraint.constant = 62
                requestEventCell?.startNavigationViewHeightConstraint.constant = 30.5
                requestEventCell?.location.attributedText = NSMutableAttributedString().bold("Location: ").normal(eventData.eventAddress)
            }
            
            requestEventCell?.expandButton.tag = indexPath.row
            requestEventCell?.startNavigationButton.tag = indexPath.row
            requestEventCell?.acceptButton.tag = indexPath.row
            requestEventCell?.rejectButton.tag = indexPath.row
            
            requestEventCell?.expandButton.addTarget(self, action: #selector(self.showDetailView(sender:)), for: UIControlEvents.touchUpInside)
            requestEventCell?.startNavigationButton.addTarget(self, action: #selector(self.startNavigationButtonTappedFromRequestEvents(sender:)), for: UIControlEvents.touchUpInside)
            requestEventCell?.acceptButton.addTarget(self, action: #selector(self.acceptButtonTapped(sender:)), for: UIControlEvents.touchUpInside)
            requestEventCell?.rejectButton.addTarget(self, action: #selector(self.rejectButtonTapped(sender:)), for: UIControlEvents.touchUpInside)
            
            
            if eventData.confirmed == 0
            {
                
                requestEventCell?.startNavigationButton.isHidden = true
                requestEventCell?.acceptORRejectView.isHidden = true
                requestEventCell?.acceptORRejectLabel.isHidden = false
                requestEventCell?.acceptORRejectLabel.text = "NO"
                requestEventCell?.acceptORRejectLabel.textColor = UIColor.init(red: 255/255, green: 97/255, blue: 71/255, alpha: 1.0)
                
            }
            else if eventData.confirmed == 1
            {
                if !eventData.eventAddress.isEmpty
                {
                    requestEventCell?.startNavigationButton.isHidden = false
                }
                requestEventCell?.acceptORRejectView.isHidden = true
                requestEventCell?.acceptORRejectLabel.isHidden = false
                requestEventCell?.acceptORRejectLabel.text = "YES"
                requestEventCell?.acceptORRejectLabel.textColor = UIColor.init(red: 134/255, green: 224/255, blue: 139/255, alpha: 1.0)
                
            }
            else if eventData.confirmed == 2
            {
                if !eventData.eventAddress.isEmpty
                {
                    requestEventCell?.startNavigationButton.isHidden = false
                }
                requestEventCell?.acceptORRejectView.isHidden = false
                requestEventCell?.acceptORRejectLabel.isHidden = true
//                requestEventCell?.acceptORRejectLabel.text = "Accepted"
//                requestEventCell?.acceptORRejectLabel.textColor = UIColor.init(red: 134/255, green: 224/255, blue: 139/255, alpha: 1.0)
                
            }
            else if eventData.confirmed == 3
            {
                requestEventCell?.startNavigationButton.isHidden = true
                requestEventCell?.acceptORRejectView.isHidden = true
                requestEventCell?.acceptORRejectLabel.isHidden = false
                requestEventCell?.acceptORRejectLabel.text = "Too Late! Offer is no longer valid."
                requestEventCell?.acceptORRejectLabel.textColor = UIColor.red
                
            }
            
            
            
            
            return requestEventCell!
            
        }
        else if tableView.tag == 3
        {
            var yourEventsCell  = (tableView.dequeueReusableCell(withIdentifier: "YourEventsCell"))! as? YourEventsCell
            if yourEventsCell == nil
            {
                yourEventsCell = Bundle.main.loadNibNamed("YourEventsCell", owner: nil, options: nil)?[0] as? YourEventsCell
            }
            
            let eventData = self.userEventList[indexPath.row]
            
//            let dateformatter = DateFormatter()
//            dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//
//            let date = dateformatter.date(from: eventData.eventTime)
//
//            let date2 = dateformatter.date(from: eventData.eventCreatedTime)
//
//            dateformatter.dateStyle = .medium
//            dateformatter.timeStyle = .short
            
            
            
//            dateformatter.dateFormat = "dd/MM/yyyy"
//
//            let formatter2 = DateFormatter()
//            formatter2.dateFormat = "yyyy-MM-dd HH:mm:ss"
//
//            //        let timeString = eventData.eventTime.components(separatedBy: " ")[1
//            let time = formatter2.date(from: eventData.eventTime)
            
//            formatter2.dateFormat = "hh:mm a"
            
//            yourEventsCell?.title.delegate = self

            yourEventsCell?.title.text = eventData.title
            yourEventsCell?.listName.attributedText = NSMutableAttributedString().bold("List name: ").normal(String(format: "%@ (%d)", eventData.listName,eventData.totalInvited))
            yourEventsCell?.createdDate.attributedText = NSMutableAttributedString().bold("Message sent on: ").normal(eventData.eventCreatedTime)
            yourEventsCell?.totalInvited.attributedText = NSMutableAttributedString().bold("Total invited: ").normal(String(eventData.totalInvited))
            
            
            if eventData.eventTime.isEmpty
            {
                yourEventsCell?.dateHeightConstraint.constant = 0
            }
            else
            {
                yourEventsCell?.dateHeightConstraint.constant = 20
                yourEventsCell?.date.attributedText = NSMutableAttributedString().bold(BasicFunctions.getTitleAccordingToDateAndTimeFormat(dateTimeString: eventData.eventTime)).normal(eventData.eventTime)
            }
            
            if eventData.eventAddress.isEmpty
            {
                yourEventsCell?.locationHeightConstraint.constant = 0
                yourEventsCell?.startNavigationButton.isHidden = true
            }
            else
            {
                yourEventsCell?.locationHeightConstraint.constant = 20
                yourEventsCell?.startNavigationButton.isHidden = false
                yourEventsCell?.location.attributedText = NSMutableAttributedString().bold("Location: ").normal(eventData.eventAddress)
            }
            
            if eventData.eventType == "canceled"
            {
                yourEventsCell?.startNavigationButton.isHidden = true
                yourEventsCell?.editView.isHidden = true
                yourEventsCell?.cancelView.isHidden = false
            }
            else
            {
//                yourEventsCell?.startNavigationButton.isHidden = false
                yourEventsCell?.editView.isHidden = false
                yourEventsCell?.cancelView.isHidden = true
            }
            
            if eventData.isCreatedByAdmin == "1"
            {
                yourEventsCell?.editView.isHidden = true
            }
            
            self.updateViewConstraints()
            
            
            yourEventsCell?.expandButton.tag = indexPath.row
            yourEventsCell?.editButton.tag = indexPath.row
            yourEventsCell?.startNavigationButton.tag = indexPath.row
            
            yourEventsCell?.expandButton.addTarget(self, action: #selector(self.showEventDetailView(sender:)), for: UIControlEvents.touchUpInside)
            yourEventsCell?.editButton.addTarget(self, action: #selector(self.showEditView(sender:)), for: UIControlEvents.touchUpInside)
            
            
            yourEventsCell?.startNavigationButton.addTarget(self, action: #selector(self.startNavigationButtonTappedFromUserEvents(sender:)), for: UIControlEvents.touchUpInside)
            
            
            return yourEventsCell!
            
        }
        else if tableView.tag == 4
        {
            var receivedEventsCell  = (tableView.dequeueReusableCell(withIdentifier: "ReceivedEventsCell"))! as? ReceivedEventsCell
            if receivedEventsCell == nil
            {
                receivedEventsCell = Bundle.main.loadNibNamed("ReceivedEventsCell", owner: nil, options: nil)?[0] as? ReceivedEventsCell
            }
            
            
            let eventData = self.receivedRequestEventList[indexPath.row]
            
//            let dateformatter = DateFormatter()
//            dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//
//            let date = dateformatter.date(from: eventData.eventTime)
//
////            let createdDate = dateformatter.date(from: eventData.eventCreatedTime)
//
//            dateformatter.dateStyle = .medium
//            dateformatter.timeStyle = .short
            
//            dateformatter.dateFormat = "dd/MM/yyyy"
//
//            let formatter2 = DateFormatter()
//            formatter2.dateFormat = "yyyy-MM-dd HH:mm:ss"
//
//            //        let timeString = eventData.eventTime.components(separatedBy: " ")[1
//            let time = formatter2.date(from: eventData.eventTime)
//
//            formatter2.dateFormat = "hh:mm a"
            
            var invitedBy : String!

            let fullName = BasicFunctions.getNameFromContactList(phoneNumber: eventData.invitedBy.phone)

            if fullName == " "
            {
                invitedBy = eventData.invitedBy.phone
            }
            else
            {
                invitedBy = fullName + " " + "(" + eventData.invitedBy.phone + ")"
            }
            
            receivedEventsCell?.acceptedORSentByMe.text = eventData.eventType
            receivedEventsCell?.title.attributedText = NSMutableAttributedString().bold("Message name: ").normal(eventData.title)
//            receivedEventsCell?.paymentMethod.attributedText = NSMutableAttributedString().bold("Who will pay : ").normal(eventData.whoWillPay)
            receivedEventsCell?.address.attributedText = NSMutableAttributedString().bold("Location: ").normal(eventData.eventAddress)
            
            
//            receivedEventsCell?.eventCreatedDate.attributedText = NSMutableAttributedString().bold("Date and time of invite sent : ").normal(dateformatter.string(from: createdDate!))
            
//            receivedEventsCell?.date.attributedText = NSMutableAttributedString().bold("Date and time of the event : ").normal(dateformatter.string(from: date!))
            
            if eventData.eventTime.isEmpty
            {
                receivedEventsCell?.dateHeightConstraint.constant = 0
//                receivedEventsCell?.date.attributedText = NSMutableAttributedString().bold("Date and time of event : ").normal("Not Specified")
            }
            else
            {
                receivedEventsCell?.dateHeightConstraint.constant = 60
                receivedEventsCell?.date.attributedText = NSMutableAttributedString().bold(BasicFunctions.getTitleAccordingToDateAndTimeFormat(dateTimeString: eventData.eventTime)).normal(eventData.eventTime)
            }
            
            if eventData.eventAddress.isEmpty
            {
                receivedEventsCell?.locationHeightConstraint.constant = 0
                receivedEventsCell?.startNavigationButton.isHidden = true
            }
            else
            {
                receivedEventsCell?.locationHeightConstraint.constant = 62.5
                receivedEventsCell?.startNavigationButton.isHidden = false
                receivedEventsCell?.address.attributedText = NSMutableAttributedString().bold("Location: ").normal(eventData.eventAddress)
            }
            
            
            if eventData.eventType == "Sent by me."
            {
                if eventData.totalInvited == 0
                {
                    receivedEventsCell?.listName.attributedText = NSMutableAttributedString().bold("List name: ").normal(eventData.listName)
                }
                else
                {
                    receivedEventsCell?.listName.attributedText = NSMutableAttributedString().bold("List name: ").normal(String(format: "%@ (%d)", eventData.listName,eventData.totalInvited))
                }
                
                receivedEventsCell?.totalInvitedHeightConstraint.constant = 40
                receivedEventsCell?.totalInvited.attributedText = NSMutableAttributedString().bold("Total invited: ").normal(String(eventData.totalInvited))
                
                
            }
            else
            {
                receivedEventsCell?.listName.attributedText = NSMutableAttributedString().bold("Invited by: ").normal(invitedBy)
                receivedEventsCell?.totalInvitedHeightConstraint.constant = 0
                
                
                
            }
            
            receivedEventsCell?.updateConstraints()
            

            
//            if eventData.confirmed == 0
//            {
//                receivedEventsCell?.iconAccepted.image = UIImage.init(named: "iconDeclined")
//                receivedEventsCell?.acceptLabel.text = "Rejected"
//                receivedEventsCell?.acceptLabel.textColor = UIColor.init(red: 255/255, green: 97/255, blue: 71/255, alpha: 1.0)
//            }
//            else if eventData.confirmed == 1
//            {
//                receivedEventsCell?.iconAccepted.image = UIImage.init(named: "iconAccepted")
//                receivedEventsCell?.acceptLabel.text = "Accepted"
//                receivedEventsCell?.acceptLabel.textColor = UIColor.init(red: 134/255, green: 224/255, blue: 139/255, alpha: 1.0)
//
//            }
//            else if eventData.confirmed == 2
//            {
//                receivedEventsCell?.iconAccepted.image = UIImage.init(named: "iconActionPending")
//                receivedEventsCell?.acceptLabel.text = "Action Pending"
//                receivedEventsCell?.acceptLabel.textColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.7)
//            }
            
            receivedEventsCell?.expandButton.tag = indexPath.row
            receivedEventsCell?.startNavigationButton.tag = indexPath.row
            
            receivedEventsCell?.expandButton.addTarget(self, action: #selector(self.showReceivedEventDetailView(sender:)), for: UIControlEvents.touchUpInside)
            receivedEventsCell?.startNavigationButton.addTarget(self, action: #selector(self.startNavigationButtonTappedFromReceivedRequestEvents(sender:)), for: UIControlEvents.touchUpInside)
            
            
            
            
            return receivedEventsCell!
            
        }
        else if tableView.tag == 5
        {
            var contactCell  = (tableView.dequeueReusableCell(withIdentifier: "ContactCell"))! as? ContactCell
            if contactCell == nil
            {
                contactCell = Bundle.main.loadNibNamed("ContactCell", owner: nil, options: nil)?[0] as? ContactCell
            }
            
            contactCell?.deleteButton.isHidden = true
            
            
            let eventData = self.acceptedEventList[indexPath.row]
            
            
            var invitedTo : String!
            
            let fullName = BasicFunctions.getNameFromContactList(phoneNumber: eventData.invitee.phone)
            
            if fullName == " "
            {
                invitedTo = eventData.invitee.phone
            }
            else
            {
                invitedTo = fullName + " " + "(" + eventData.invitee.phone + ")"
            }
            
            contactCell?.nameLabel.text = invitedTo
            
            
            return contactCell!
            

        }
        
    
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        if tableView.tag == 1
        {
            
//            if #available(iOS 9.0, *) {
//                let createListVC = self.storyboard?.instantiateViewController(withIdentifier: "CreateListVC") as! CreateListVC
//                createListVC.listData = self.userList[indexPath.row]
//                createListVC.isUpdated = true
//                self.present(createListVC, animated: true, completion: nil)
//
//            } else {
//                // Fallback on earlier versions
//            }
            
                
        }
        else if tableView.tag == 2
        {
    
        }
        else if tableView.tag == 3
        {
            
        }
        
        
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//        if tableView.tag == 3
//        {
//            return 250.0
//        }
//
//
//    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if tableView.tag == 1
        {
        return true
        }
        return false
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            self.deleteList(index: kUserList[indexPath.row].id)
            kUserList.remove(at: indexPath.row)
            self.contactsView.contactsTableView.deleteRows(at: [indexPath], with: .automatic)



        }
    }
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//
//        var editAction = UITableViewRowAction(style: .default, title: "", handler: { (action, indexPath) in
//
//
//
//        })
//
//        var deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
//
//
//            self.deleteList(index: self.userList[indexPath.row].id)
//
//            self.userList.remove(at: indexPath.row)
//            self.contactsView.contactsTableView.deleteRows(at: [indexPath], with: .automatic)
//
//
//
//        })
//
//        return[editAction,deleteAction]
//
//    }
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {

        let listDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "ListDetailVC") as! ListDetailVC
        listDetailVC.listData = kUserList[indexPath.row]
        BasicFunctions.pushVCinNCwithObject(vc: listDetailVC, popTop: false)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.createEventView.locationTextField.isUserInteractionEnabled = true
        if self.editEventView != nil
        {
            self.editEventView.locationTextField.isUserInteractionEnabled = true
        }
        
        
        textField.resignFirstResponder()
        
        return true
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.text == "Invite Title"
        {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text == ""
        {
            textView.text = "Invite Title"
            textView.textColor = UIColor.lightGray
            
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
        if textField.tag == 1 || textField.tag == 2
        {

            self.createEventView.locationTextField.isUserInteractionEnabled = false
            if self.editEventView != nil
            {
                self.editEventView.locationTextField.isUserInteractionEnabled = false
            }
            
        }
        else if textField.tag == 3
        {
            self.view.endEditing(true)
            if self.currentLocationCoordinate != nil
            {
            self.showSearchVC()
            }
            else
            {
                BasicFunctions.showSettingsAlert(vc: self, msg: "Invited requires access to your location. Please allow it in Settings.")
            }
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    @objc func showReceivedEventDetailView(sender:UIButton)
    {
        let eventData = self.receivedRequestEventList[sender.tag]
        
//        let dateformatter = DateFormatter()
//        dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//
//        let date = dateformatter.date(from: eventData.eventTime)
//
//        let createdDate = dateformatter.date(from: eventData.eventCreatedTime)
//
//        dateformatter.dateStyle = .medium
//        dateformatter.timeStyle = .short
        
        if eventData.eventType == "Sent by me."
        {
            
            
            self.sentByMeView.frame = CGRect(x: 0 , y: 44, width: Int(self.view.frame.size.width), height: Int(self.view.frame.size.height - 44))
            
            
            self.sentByMeView.acceptedUserTableView.register(UINib(nibName: "ContactCell", bundle: nil), forCellReuseIdentifier: "ContactCell")
            
            self.sentByMeView.acceptedUserTableView.delegate = self
            self.sentByMeView.acceptedUserTableView.dataSource = self
            
            self.sentByMeView.eventName.text = eventData.title
            self.sentByMeView.listName.attributedText = NSMutableAttributedString().bold("List name: ").normal(String(format: "%@ (%d)", eventData.listName,eventData.totalInvited))
            self.sentByMeView.yesCount.attributedText = NSMutableAttributedString().bold("YES count: ").normal(String(eventData.numberOfInvitationAccepted))
            self.sentByMeView.noCount.attributedText = NSMutableAttributedString().bold("NO count: ").normal(String(eventData.numberOfInvitationRejected))
            self.sentByMeView.createEventDate.attributedText = NSMutableAttributedString().bold("Message Sent On: ").normal(eventData.eventCreatedTime)
            
            var date : String!
            if eventData.eventTime.isEmpty
            {
                date = "Not Specified"
            }
            else
            {
                date = eventData.eventTime
            }
            
            self.sentByMeView.date.attributedText = NSMutableAttributedString().bold(BasicFunctions.getTitleAccordingToDateAndTimeFormat(dateTimeString: date)).normal(date)
            
            var address : String!
            if eventData.eventAddress == ""
            {
                address = "Not Specified"
            }
            else
            {
                address = eventData.eventAddress
            }
            self.sentByMeView.location.attributedText = NSMutableAttributedString().bold("Location: ").normal(address)
            
            
            self.sentByMeView.backButton.addTarget(self, action: #selector(self.backButtonTapped), for: UIControlEvents.touchUpInside)
            
            self.sentByMeView.sendReportButton.tag = eventData.eventID
            self.sentByMeView.sendReportButton.addTarget(self, action: #selector(self.sendButtonTapped(sender:)), for: UIControlEvents.touchUpInside)
            
            self.acceptedEventList.removeAll()
            self.acceptedEventList = eventData.acceptedEventList
            
            self.sentByMeView.acceptedUserTableView.reloadData()
            
            self.view.addSubview(self.sentByMeView)
            
        }
        else
        {
            self.acceptByMeView.frame = CGRect(x: 0 , y: 44, width: Int(self.view.frame.size.width), height: Int(self.view.frame.size.height - 44))

            BasicFunctions.setRoundCornerOfButton(button: self.acceptByMeView.startNavigationButton, radius: 5.0)
            
            
            self.acceptByMeView.titleTextView.attributedText = NSMutableAttributedString().bold("Message name: ").normal(eventData.title)
//            self.acceptByMeView.totalInvited.attributedText = NSMutableAttributedString().bold("Total invited : ").normal(String(eventData.totalInvited))
            self.acceptByMeView.eventReceivedDate.attributedText = NSMutableAttributedString().bold("Message sent on: ").normal(eventData.eventCreatedTime)
            
            if eventData.eventTime.isEmpty
            {
                self.acceptByMeView.eventDate.attributedText = NSMutableAttributedString().bold("Date and time of message: ").normal("Not Specified")
            }
            else
            {
                self.acceptByMeView.eventDate.attributedText = NSMutableAttributedString().bold(BasicFunctions.getTitleAccordingToDateAndTimeFormat(dateTimeString: eventData.eventTime)).normal(eventData.eventTime)
            }
            
            if eventData.eventAddress.isEmpty
            {
                self.acceptByMeView.location.attributedText = NSMutableAttributedString().bold("Location: ").normal("Not Specified")
                self.acceptByMeView.startNavigationButton.isHidden = true
            }
            else
            {
                self.acceptByMeView.location.attributedText = NSMutableAttributedString().bold("Location: ").normal(eventData.eventAddress)
                self.acceptByMeView.startNavigationButton.isHidden = false
            }

            var invitedBy : String!

            let fullName = BasicFunctions.getNameFromContactList(phoneNumber: eventData.invitedBy.phone)

            if fullName == " "
            {
                invitedBy = eventData.invitedBy.phone
            }
            else
            {
                invitedBy = fullName + " " + "(" + eventData.invitedBy.phone + ")"
            }

            self.acceptByMeView.invitedBy.attributedText = NSMutableAttributedString().bold("Invited by: ").normal(invitedBy)


            self.acceptByMeView.backButton.addTarget(self, action: #selector(self.backButtonTapped), for: UIControlEvents.touchUpInside)

            self.acceptByMeView.startNavigationButton.tag = sender.tag
            self.acceptByMeView.startNavigationButton.addTarget(self, action: #selector(self.startNavigationButtonTappedFromReceivedRequestEvents(sender:)), for: UIControlEvents.touchUpInside)
            
            
            self.view.addSubview(self.acceptByMeView)
            
            
        }
        
//        self.specificReceivedRequestEventList.removeAll()
//
//        for event in self.receivedRequestEventList
//        {
//            if eventData.eventID == event.eventID
//            {
//                self.specificReceivedRequestEventList.append(event)
//            }
//        }

//        self.receivedEventDetailView.receivedEventDetailTableView.reloadData()
        // Testing github.
        
    }
    @objc func sendButtonTapped(sender : UIButton)
    {
        let alertController = UIAlertController(title: "Enter Email Address", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Email Address"
            if #available(iOS 10.0, *) {
                textField.textContentType = UITextContentType.emailAddress
            } else {
                // Fallback on earlier versions
            }
        }
        let sendAction = UIAlertAction(title: "Send", style: UIAlertActionStyle.default, handler: { alert -> Void in
            if (alertController.textFields?[0].text?.isEmpty)!
            {
                BasicFunctions.showAlert(vc: self, msg: "Enter email address")
            }
            else
            {
                self.sendReportToSpecificEmailAddress(eventID: sender.tag, emailAddress: (alertController.textFields?[0].text)!)
            }
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        
        alertController.addAction(sendAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    func sendReportToSpecificEmailAddress(eventID : Int, emailAddress : String)
    {
        BasicFunctions.showActivityIndicator(vu: self.view)
        var postParams = [String : Any]()
        postParams["event_id"] = eventID
        postParams["email_address"] = emailAddress
        
        ServerManager.sendReport(postParams, accessToken: BasicFunctions.getPreferences(kAccessToken) as? String) { (result) in
            
            
            BasicFunctions.stopActivityIndicator(vu: self.view)
            self.handleServerResponseOfSendReport(json: result as! [String : Any])
            
            
        }
    }
    func handleServerResponseOfSendReport(json : [String : Any])
    {
//        let status = json["status"] as? String
        
        
        var message = json["message"] as? String
        
        if json["email_address"] != nil
        {
            message = (json["email_address"] as! Array)[0]
            
        }
        
        BasicFunctions.showAlert(vc: self, msg: message)
        
        
        
    }
    
    @objc func showDetailView(sender:UIButton)
    {
    
        self.detailView.frame = CGRect(x: 0 , y: 44, width: Int(self.view.frame.size.width), height: Int(self.view.frame.size.height - 44))
        
        let eventData = self.requestEventList[sender.tag]
        
//        let dateformatter = DateFormatter()
//        dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//
//        let date = dateformatter.date(from: eventData.eventTime)
//
//        let createdDate = dateformatter.date(from: eventData.eventCreatedTime)
//
//        dateformatter.dateStyle = .medium
//        dateformatter.timeStyle = .short
        
//        dateformatter.dateFormat = "dd/MM/yyyy"
//
//        let formatter2 = DateFormatter()
//        formatter2.dateFormat = "yyyy-MM-dd HH:mm:ss"
//
//        //        let timeString = eventData.eventTime.components(separatedBy: " ")[1
//        let time = formatter2.date(from: eventData.eventTime)
//
//        formatter2.dateFormat = "hh:mm a"
        var invitedBy : String!
        
        let fullName = BasicFunctions.getNameFromContactList(phoneNumber: eventData.phone)
        
        if fullName == " "
        {
            invitedBy = eventData.phone
        }
        else
        {
            invitedBy = fullName + " " + "(" + eventData.phone + ")"
        }
        
        self.detailView.titleTextView.text = eventData.title
        
        
        self.detailView.createdBy.attributedText = NSMutableAttributedString().bold("Invited by: ").normal(invitedBy)
//        self.detailView.date.attributedText = NSMutableAttributedString().bold("Date and time of the event : ").normal(eventData.eventTime)
        self.detailView.createdDate.attributedText = NSMutableAttributedString().bold("Message received on: ").normal(eventData.eventCreatedTime)
//        self.detailView.location.attributedText = NSMutableAttributedString().bold("Location : ").normal(eventData.eventAddress)
//        self.detailView.totalInvited.attributedText = NSMutableAttributedString().bold("Total Invited : ").normal(String(eventData.totalInvited))
        
        if eventData.eventTime.isEmpty
        {
            //            self.eventDetailView.dateViewHeightConstraint.constant = -self.eventDetailView.dateView.frame.size.height
            self.detailView.date.attributedText = NSMutableAttributedString().bold("Date and time of Message: ").normal("Not Specified")
            
        }
        else
        {
            self.detailView.date.attributedText = NSMutableAttributedString().bold(BasicFunctions.getTitleAccordingToDateAndTimeFormat(dateTimeString: eventData.eventTime)).normal(eventData.eventTime)
        }
        
        if eventData.eventAddress.isEmpty
        {
            //            self.eventDetailView.locationViewHeightConstraint.constant = -self.eventDetailView.dateView.frame.size.height
            self.detailView.location.attributedText = NSMutableAttributedString().bold("Location: ").normal("Not Specified")
            self.detailView.startNavigationButton.isHidden = true
        }
        else
        {
            self.detailView.location.attributedText = NSMutableAttributedString().bold("Location: ").normal(eventData.eventAddress)
            self.detailView.startNavigationButton.isHidden = false
        }
        
        self.detailView.acceptButton.tag = sender.tag
        self.detailView.rejectButton.tag = sender.tag
        self.detailView.startNavigationButton.tag = sender.tag
        
        if eventData.confirmed == 0
        {
            self.detailView.acceptORRejectButtonView.isHidden = true
            self.detailView.startNavigationView.isHidden = true
            self.detailView.rejectLabel.isHidden = false
            self.detailView.rejectLabel.text = "No"
            self.detailView.rejectLabel.textColor = UIColor.red
        }
        else if eventData.confirmed == 1
        {
            self.detailView.acceptORRejectButtonView.isHidden = true
            self.detailView.startNavigationView.isHidden = false
            self.detailView.rejectLabel.isHidden = true
            
        }
        else if eventData.confirmed == 2
        {
            self.detailView.acceptORRejectButtonView.isHidden = false
            self.detailView.startNavigationView.isHidden = true
            self.detailView.rejectLabel.isHidden = true
            
        }
        else if eventData.confirmed == 3
        {
            self.detailView.acceptORRejectButtonView.isHidden = true
            self.detailView.startNavigationView.isHidden = true
            self.detailView.rejectLabel.isHidden = false
            self.detailView.rejectLabel.text = "Too Late! Offer is no longer valid."
            self.detailView.rejectLabel.textColor = UIColor.red
            
        }
        
//        var paymentMethodString : String!
//
//        if eventData.paymentMethod == 1
//        {
//            paymentMethodString = "Inviter"
//        }
//        else if eventData.paymentMethod == 2
//        {
//            paymentMethodString = "You"
//        }
//        else
//        {
//            paymentMethodString = "Shared"
//        }
        
        BasicFunctions.setRoundCornerOfButton(button: self.detailView.acceptButton, radius: 5.0)
        BasicFunctions.setRoundCornerOfButton(button: self.detailView.rejectButton, radius: 5.0)
        BasicFunctions.setRoundCornerOfButton(button: self.detailView.startNavigationButton, radius: 5.0)
        
        self.detailView.acceptButton.addTarget(self, action: #selector(self.acceptButtonTapped(sender:)), for: UIControlEvents.touchUpInside)
        self.detailView.rejectButton.addTarget(self, action: #selector(self.rejectButtonTapped(sender:)), for: UIControlEvents.touchUpInside)
        
        self.detailView.startNavigationButton.tag = sender.tag
        self.detailView.startNavigationButton.addTarget(self, action: #selector(self.startNavigationButtonTappedFromRequestEvents(sender:)), for: UIControlEvents.touchUpInside)
        
        
        
        self.detailView.backButton.addTarget(self, action: #selector(self.backButtonTapped), for: UIControlEvents.touchUpInside)
        
        self.view.addSubview(detailView)
    }
    @objc func showEventDetailView(sender : UIButton)
    {
        
        self.eventDetailView.frame = CGRect(x: 0 , y: 44, width: Int(self.view.frame.size.width), height: Int(self.view.frame.size.height - 44))
        
        BasicFunctions.setRoundCornerOfButton(button: self.eventDetailView.startNavigationButton, radius: 5.0)
        
        
        let eventData = self.userEventList[sender.tag]
        
//        let dateformatter = DateFormatter()
//        dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//
//        let date = dateformatter.date(from: eventData.eventTime)
//
//        let date2 = dateformatter.date(from: eventData.eventCreatedTime)
//
//        dateformatter.dateStyle = .medium
//        dateformatter.timeStyle = .short
        
        
//        dateformatter.dateFormat = "dd/MM/yyyy"
//
//        let formatter2 = DateFormatter()
//        formatter2.dateFormat = "yyyy-MM-dd HH:mm:ss"
//
//        //        let timeString = eventData.eventTime.components(separatedBy: " ")[1
//        let time = formatter2.date(from: eventData.eventTime)
//
//        formatter2.dateFormat = "hh:mm a"
        
        
        self.eventDetailView.titleTextView.text = eventData.title
        self.eventDetailView.listName.attributedText = NSMutableAttributedString().bold("List name: ").normal(String(format: "%@ (%d)", eventData.listName,eventData.totalInvited))
        self.eventDetailView.createdDate.attributedText = NSMutableAttributedString().bold("Message sent on: ").normal(eventData.eventCreatedTime)
        self.eventDetailView.totalInvited.attributedText = NSMutableAttributedString().bold("Total Invited: ").normal(String(eventData.totalInvited))
        
        
        if eventData.eventTime.isEmpty
        {
//            self.eventDetailView.dateViewHeightConstraint.constant = -self.eventDetailView.dateView.frame.size.height
            self.eventDetailView.date.attributedText = NSMutableAttributedString().bold("Date and time of message: ").normal("Not Specified")
            
        }
        else
        {
            self.eventDetailView.date.attributedText = NSMutableAttributedString().bold(BasicFunctions.getTitleAccordingToDateAndTimeFormat(dateTimeString: eventData.eventTime)).normal(eventData.eventTime)
        }
        
        if eventData.eventAddress.isEmpty
        {
//            self.eventDetailView.locationViewHeightConstraint.constant = -self.eventDetailView.dateView.frame.size.height
            self.eventDetailView.location.attributedText = NSMutableAttributedString().bold("Location: ").normal("Not Specified")
            self.eventDetailView.startNavigationButton.isHidden = true
        }
        else
        {
            self.eventDetailView.location.attributedText = NSMutableAttributedString().bold("Location: ").normal(eventData.eventAddress)
            self.eventDetailView.startNavigationButton.isHidden = false
        }
        
        if eventData.eventType == "canceled"
        {
            self.eventDetailView.startNavigationButton.isHidden = true
        }
        
        
        

        self.eventDetailView.backButton.addTarget(self, action: #selector(self.backButtonTapped), for: UIControlEvents.touchUpInside)
        
        self.eventDetailView.startNavigationButton.tag = sender.tag
        self.eventDetailView.startNavigationButton.addTarget(self, action: #selector(self.startNavigationButtonTappedFromUserEvents(sender:)), for: UIControlEvents.touchUpInside)
        
        self.invitedList = eventData.userList
        
//        self.eventDetailView.inviedListTableView.dataSource = self
//        self.eventDetailView.inviedListTableView.delegate = self
        
        self.view.addSubview(self.eventDetailView)
    }
    @objc func showEditView(sender : UIButton!)
    {
        self.editEventView  = CreateEventView.instanceFromNib() as? CreateEventView
        
        self.editEventView.frame = CGRect(x: 0 , y: 44, width: Int(self.view.frame.size.width), height: Int(self.view.frame.size.height - 44))
        
//        self.editEventView.titleTextView.tag = 2
        self.editEventView.timeTextField.tag = 2
        self.editEventView.dateTextField.tag = 2
        self.editEventView.locationTextField.tag = 3
        self.editEventView.setNumberOfPeopleTextfield.tag = 2
        self.editEventView.setListTextField.tag = 2
        
        self.selectedList = nil
        
        
//        self.editEventView.titleTextView.delegate = self
        self.editEventView.setNumberOfPeopleTextfield.delegate = self
        self.editEventView.timeTextField.delegate = self
        self.editEventView.dateTextField.delegate = self
        self.editEventView.locationTextField.delegate = self
        self.editEventView.setListTextField.delegate = self
        
        self.editEventView.titleTextView.textColor = UIColor.black
        self.editEventView.locationTextField.text = ""
        
        self.isUpdated = true
        
        let eventData = self.userEventList[sender.tag]
        
        self.editEventView.locationSwitch.tag = 4
        self.editEventView.dateSwitch.tag = 5
        self.editEventView.timeSwitch.tag = 6
        
//        self.editEventView.locationSwitch.isOn = true
//        self.editEventView.dateSwitch.isOn = true
//        self.editEventView.timeSwitch.isOn = true
        
        self.editEventView.updateButton.tag = eventData.eventID
        self.editEventView.cancelButton.tag = eventData.eventID
        self.editEventView.deleteButton.tag = eventData.eventID
        self.listID = eventData.listID
        
        for list in kUserList
        {
            if list.id == eventData.listID
            {
                self.updateSelectedList = list
                break
            }
        }
        
        
        self.showDatePicker(textField: self.editEventView.dateTextField)
        self.showTimePicker(textField: self.editEventView.timeTextField)
        
        self.showPicker(textField: self.editEventView.setListTextField)
        
        self.addDoneButtonOnKeyboard(textField: self.editEventView.setNumberOfPeopleTextfield)
        
        self.addDoneButtonOnTextViewKeyboard(textView: self.editEventView.titleTextView)
        
        self.editEventView.locationSwitch.addTarget(self, action: #selector(self.switchStateChanged(sender:)), for: UIControlEvents.touchUpInside)
        self.editEventView.dateSwitch.addTarget(self, action: #selector(self.switchStateChanged(sender:)), for: UIControlEvents.touchUpInside)
        self.editEventView.timeSwitch.addTarget(self, action: #selector(self.switchStateChanged(sender:)), for: UIControlEvents.touchUpInside)
        
        self.editEventView.backButton.isHidden = false
        self.editEventView.backButton.addTarget(self, action: #selector(self.backButtonTapped), for: UIControlEvents.touchUpInside)
        
        self.editEventView.updateButton.addTarget(self, action: #selector(self.updateButtonTapped(sender:)), for: UIControlEvents.touchUpInside)
        
        self.editEventView.cancelButton.addTarget(self, action: #selector(self.cancelButtonTapped(sender:)), for: UIControlEvents.touchUpInside)
        
        self.editEventView.deleteButton.addTarget(self, action: #selector(self.deleteButtonTapped(sender:)), for: UIControlEvents.touchUpInside)
        
        self.editEventView.updateButtonView.isHidden = false
        self.editEventView.createButtonView.isHidden = true
        
        
        
//        let formatter1 = DateFormatter()
//        formatter1.dateFormat = "yyyy-MM-dd HH:mm:ss"
////        let dateString = eventData.eventTime
//        let date = formatter1.date(from: eventData.eventTime)
//
//        formatter1.dateStyle = .medium
//        formatter1.timeStyle = .short
//
//        formatter1.dateFormat = "dd/MM/yyyy"
//
//        let formatter2 = DateFormatter()
//        formatter2.dateFormat = "yyyy-MM-dd HH:mm:ss"
//
////        let timeString = eventData.eventTime.components(separatedBy: " ")[1
//        let time = formatter2.date(from: eventData.eventTime)
//
//        formatter2.dateFormat = "hh:mm a"
//
        self.editEventView.titleTextView.text = eventData.title
//        if time != nil
//        {
//            self.editEventView.timeTextField.text = formatter2.string(from: time!)
//        }
//
//        if date != nil
//        {
//            self.editEventView.dateTextField.text = formatter1.string(from: date!)
//        }
        
        
//        self.editEventView.locationTextField.text = eventData.eventAddress
        self.editEventView.setNumberOfPeopleTextfield.text = String(eventData.maximumNumberOfPeople)
        self.editEventView.setListTextField.text = eventData.listName
        
        self.selectedLat = eventData.lat
        self.selectedLong = eventData.long
        
        UserDefaults.standard.removeObject(forKey: kSelectedLat)
        UserDefaults.standard.removeObject(forKey: kSelectedLong)
        UserDefaults.standard.synchronize()
        
        
        
//        if eventData.paymentMethod == 1
//        {
//            self.editEventView.iWillPayButton.isSelected = true
//            self.editEventView.youWillPayButton.isSelected = false
//            self.editEventView.allButton.isSelected = false
//        }
//        else if eventData.paymentMethod == 2
//        {
//            self.editEventView.iWillPayButton.isSelected = false
//            self.editEventView.youWillPayButton.isSelected = true
//            self.editEventView.allButton.isSelected = false
//        }
//        else
//        {
//            self.editEventView.iWillPayButton.isSelected = false
//            self.editEventView.youWillPayButton.isSelected = false
//            self.editEventView.allButton.isSelected = true
//        }
        
        self.view.addSubview(self.editEventView)
    }
    @objc func backButtonTapped()
    {
        if self.detailView != nil
        {
            self.detailView.removeFromSuperview()
        }
        
        if self.editEventView != nil
        {
            self.editEventView.removeFromSuperview()
            self.isUpdated = false
        }
        
        if self.eventDetailView != nil
        {
            self.eventDetailView.removeFromSuperview()
        }
        
        if self.sentByMeView != nil
        {
            self.sentByMeView.removeFromSuperview()
        }
        
        if self.acceptByMeView != nil
        {
            self.acceptByMeView.removeFromSuperview()
        }
        
    }
    @objc func startNavigationButtonTappedFromRequestEvents(sender : UIButton)
    {
//        self.isStartNavigationButtonTapped = true
//
        let toLat = self.requestEventList[sender.tag].lat
        let toLong = self.requestEventList[sender.tag].long
        
        self.showRouteOnGoogleMap(lat: toLat, long: toLong)
//
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let routeVC : RouteVC = storyboard.instantiateViewController(withIdentifier: "RouteVC") as! RouteVC
//        routeVC.originLocationCoordinate = self.currentLocationCoordinate
//        routeVC.destinationLocationCoordinate = CLLocationCoordinate2D.init(latitude: Double(toLat)!, longitude: Double(toLong)!)
//
//        BasicFunctions.pushVCinNCwithObject(vc: routeVC, popTop: false)
        
        
    }
    @objc func startNavigationButtonTappedFromUserEvents(sender : UIButton)
    {
        
        let toLat = self.userEventList[sender.tag].lat
        let toLong = self.userEventList[sender.tag].long
        
        self.showRouteOnGoogleMap(lat: toLat, long: toLong)
        
    }
    @objc func startNavigationButtonTappedFromReceivedRequestEvents(sender : UIButton)
    {
        
        let toLat = self.receivedRequestEventList[sender.tag].lat
        let toLong = self.receivedRequestEventList[sender.tag].long
        
        self.showRouteOnGoogleMap(lat: toLat, long: toLong)
        
    }
    
    func showRouteOnGoogleMap (lat : String , long : String)
    {
        if self.currentLocationCoordinate != nil
        {
        // if GoogleMap installed
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            UIApplication.shared.openURL(NSURL(string:
                "comgooglemaps://?saddr=\(self.currentLocationCoordinate!.latitude),\(self.currentLocationCoordinate!.longitude)&daddr=\(lat),\(long)&directionsmode=driving")! as URL)
            
        } else {
            // if GoogleMap App is not installed
            UIApplication.shared.openURL(NSURL(string:
                "https://www.google.co.in/maps/dir/?saddr=\(self.currentLocationCoordinate!.latitude),\(self.currentLocationCoordinate!.longitude)&daddr=\(lat),\(long)&directionsmode=driving")! as URL)
        }
        }
        else
        {
            BasicFunctions.showSettingsAlert(vc: self, msg: "Invited requires access to your location. Please allow it in Settings.")
        }
        
    }
    @objc func cancelButtonTapped(sender:UIButton)
    {
        BasicFunctions.showActivityIndicator(vu: self.view)
        
        //        let eventdata = self.userEventList[sender.tag]
        
        var postParams = [String : Any]()
        postParams["event_id"] = sender.tag
        
        ServerManager.cancelEvent(postParams, accessToken: BasicFunctions.getPreferences(kAccessToken) as? String) { (result) in
            
            BasicFunctions.stopActivityIndicator(vu: self.view)
            
            let json = result as! [String : Any]
            let status = json["status"] as? String
            let message = json["message"] as? String
            
            
            if message != nil && message == "Unauthorized"
            {
                BasicFunctions.showAlert(vc: self, msg: "Session Expired. Please login again")
                BasicFunctions.showSigInVC()
                return
                
            }
            
            
            if json["error"] == nil && status == "success"
            {
                
                
                BasicFunctions.showAlert(vc: self, msg: message)
                
                self.backButtonTapped()
                
                self.fetchUserEventsFromServer()
            }
            else
            {
                
                BasicFunctions.showAlert(vc: self, msg: message)
                
                
            }
            
            
            
        }
    }
    @objc func deleteButtonTapped(sender:UIButton)
    {
        BasicFunctions.showActivityIndicator(vu: self.view)
        
//        let eventdata = self.userEventList[sender.tag]
        
        var postParams = [String : Any]()
        postParams["event_id"] = sender.tag
        
        ServerManager.deleteEvent(postParams, accessToken: BasicFunctions.getPreferences(kAccessToken) as? String) { (result) in
            
            BasicFunctions.stopActivityIndicator(vu: self.view)
            
            let json = result as! [String : Any]
            let status = json["status"] as? String
            let message = json["message"] as? String
            
            
            if message != nil && message == "Unauthorized"
            {
                BasicFunctions.showAlert(vc: self, msg: "Session Expired. Please login again")
                BasicFunctions.showSigInVC()
                return
                
            }
            
            
            if json["error"] == nil && status == "success"
            {
                
                
                BasicFunctions.showAlert(vc: self, msg: message)
                    
                self.backButtonTapped()
                
                self.fetchUserEventsFromServer()
            }
            else
            {
                
                BasicFunctions.showAlert(vc: self, msg: message)
                
                
            }
        
            
            
        }
        
    }
    
    @objc func acceptButtonTapped(sender:UIButton)
    {
        BasicFunctions.showActivityIndicator(vu: self.view)
        
        let eventdata = self.requestEventList[sender.tag]
        
        var postParams = [String : Any]()
        postParams["event_id"] = eventdata.eventID
        postParams["request_to"] = BasicFunctions.getPreferences(kUserID)
        
        ServerManager.acceptEventRequest(postParams, accessToken: BasicFunctions.getPreferences(kAccessToken) as? String) { (result) in
            
            BasicFunctions.stopActivityIndicator(vu: self.view)
            
            self.handleServerResponseOfAccept(json: result as! [String : Any])
            
            }
    }
    func handleServerResponseOfAccept(json : [String : Any])
    {
        let status = json["status"] as? String
        let message = json["message"] as? String
        
        if message != nil && message == "Unauthorized"
        {
            BasicFunctions.showAlert(vc: self, msg: "Session Expired. Please login again")
            BasicFunctions.showSigInVC()
            return
            
        }
        
        if json["error"] == nil && status != nil
        {
            if status == "error"
            {
                BasicFunctions.showAlert(vc: self, msg: message!)
                self.fetchRequestsFromServer()
                return
            }
            else if status == "closed"
            {
                if message != nil
                {
                BasicFunctions.showAlert(vc: self, msg: message!)
                }
                self.fetchRequestsFromServer()
                
                return
                
            }
            
            if self.detailView != nil
            {
//                self.detailView.startNavigationView.isHidden = false
                self.detailView.acceptORRejectButtonView.isHidden = true
                self.detailView.rejectLabel.isHidden = true
            }
            BasicFunctions.showAlert(vc: self, msg: status!)
            self.fetchRequestsFromServer()
        }
        else
        {
            if message != nil
            {
                BasicFunctions.showAlert(vc: self, msg: message!)
            }
            
        }
    }
    @objc func rejectButtonTapped(sender:UIButton)
    {
        BasicFunctions.showActivityIndicator(vu: self.view)
        
        let eventdata = self.requestEventList[sender.tag]
        
        var postParams = [String : Any]()
        postParams["event_id"] = eventdata.eventID
        postParams["request_to"] = BasicFunctions.getPreferences(kUserID)
        
        ServerManager.rejectEventRequest(postParams, accessToken: BasicFunctions.getPreferences(kAccessToken) as? String) { (result) in
            
            BasicFunctions.stopActivityIndicator(vu: self.view)
            
            self.handleServerResponseOfReject(json: result as! [String : Any])
        }
        
    }
    
    func handleServerResponseOfReject(json : [String : Any])
    {
        let status = json["status"] as? String
        let message = json["message"] as? String
        
        if message != nil && message == "Unauthorized"
        {
            BasicFunctions.showAlert(vc: self, msg: "Session Expired. Please login again")
            BasicFunctions.showSigInVC()
            return
            
        }
        
        
        if json["error"] == nil && status != nil
        {
            if status == "error"
            {
                BasicFunctions.showAlert(vc: self, msg: "Event has been deleted.")
                self.fetchRequestsFromServer()
                return
            }
            
            if self.detailView != nil
            {
                self.detailView.startNavigationView.isHidden = true
                self.detailView.acceptORRejectButtonView.isHidden = true
                self.detailView.rejectLabel.isHidden = false
                
            }
            BasicFunctions.showAlert(vc: self, msg: status!)
            self.fetchRequestsFromServer()
        }
        else
        {
            let message = json["message"] as? String
            
            if message != nil
            {
                BasicFunctions.showAlert(vc: self, msg: message!)
            }
            
        }
    }
    
    
    func showSearchVC()
    {
        
        
        self.placeSelectedORCancelled = true
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mapVC : MapVC = storyboard.instantiateViewController(withIdentifier: "MapVC") as! MapVC
        mapVC.selectedLocationCoordinate = self.currentLocationCoordinate
        
        
        BasicFunctions.pushVCinNCwithObject(vc: mapVC, popTop: false)
    }
    
//    // Handle the user's selection.
//    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
//        
//        self.selectedLocationAddress = place.formattedAddress
//        self.locationCoordinate = place.coordinate
//        
//        self.placeSelectedORCancelled = true
//        
//        self.dismiss(animated: true, completion: nil)
//    }
//    
//    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
//        // TODO: handle the error.
//        print("Error: ", error.localizedDescription)
//    }
//    
//    // User canceled the operation.
//    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
//        
//        self.placeSelectedORCancelled = true
//        dismiss(animated: true, completion: nil)
//    }
//    
//    // Turn the network activity indicator on and off again.
//    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
//    }
//    
//    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
//        UIApplication.shared.isNetworkActivityIndicatorVisible = false
//    }
    
    
    @IBAction func logoutButtonTapped(_ sender: UIButton)
    {
        
        
        
    
        
        
    }
    
    func getProfileFromServer()
    {
        BasicFunctions.showActivityIndicator(vu: self.view)
        
        ServerManager.getUserProfile(nil, accessToken: BasicFunctions.getPreferences(kAccessToken) as? String) { (result) in
            
            
            BasicFunctions.stopActivityIndicator(vu: self.view)
            
            self.handleServerResponseOfGetProfile(json: result as? [String : Any])
            
        }
    }
    func handleServerResponseOfGetProfile(json : [String : Any]?)
    {
        let message = json?["message"] as? String
        let userData = json?["user"] as? [String : Any]
        
        if message != nil && message == "Unauthorized"
        {
            BasicFunctions.showAlert(vc: self, msg: "Session Expired. Please login again")
            BasicFunctions.showSigInVC()
            return
            
        }
        
        if json?["error"] == nil && userData != nil
        {

            let dobString = userData?["dob"] as? String ?? ""
            let dorString = userData?["dateofrelation"] as? String ?? ""

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dobDate = dateFormatter.date(from: dobString)
            let dorDate = dateFormatter.date(from: dorString)

            dateFormatter.dateFormat = "dd/MM/yyyy"
            
            let userProfileData = UserProfileData()
            userProfileData.authID = userData?["id"] as? Int ?? 0
            userProfileData.authToken = BasicFunctions.getPreferences(kAccessToken) as? String ?? ""
            userProfileData.firstName = userData?["firstName"] as? String ?? ""
            userProfileData.lastName = userData?["lastName"] as? String ?? ""
            userProfileData.email = userData?["email"] as? String ?? ""
            if dobDate != nil
            {
                userProfileData.dob = dateFormatter.string(from: dobDate!)
            }
            
            if dorDate != nil
            {
                userProfileData.dor = dateFormatter.string(from: dorDate!)
            }
            
            
            let userProfile = UserProfile.init(id: userProfileData.authID, accessToken: userProfileData.authToken, firstName: userProfileData.firstName, lastName: userProfileData.lastName, email: userProfileData.email, dob: userProfileData.dob, dor: userProfileData.dor)
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: userProfile)
            BasicFunctions.setPreferences(encodedData, key: kUserProfile)
            
            kLoggedInUserProfile = NSKeyedUnarchiver.unarchiveObject(with: BasicFunctions.getPreferences(kUserProfile) as! Data) as! UserProfile
            
            if kLoggedInUserProfile.dob == ""
            {
                self.contactsView.dobView.isHidden = false
            }
            
            
        }
        else if message != nil
        {
            BasicFunctions.showAlert(vc: self, msg: message!)
        }
    }
    
    func getContactListFromServer()
    {
        BasicFunctions.showActivityIndicator(vu: self.view)
        
        var postParams = [String : Any]()
        postParams["user_id"] = BasicFunctions.getPreferencesForInt(kUserID)
        
        ServerManager.getContactList(postParams, accessToken: BasicFunctions.getPreferences(kAccessToken) as? String) { (result) in
            
            
            BasicFunctions.stopActivityIndicator(vu: self.view)
            
            self.handleServerResponse(json: result as! [String : Any])
            
        }
    }
    
    func handleServerResponse(json : [String : Any])
    {
        let status = json["status"] as? String
        let message = json["message"] as? String
        
        if message != nil && message == "Unauthorized"
        {
            BasicFunctions.showAlert(vc: self, msg: "Session Expired. Please login again")
            BasicFunctions.showSigInVC()
            return
            
        }
        
        
        if json["error"] == nil && status == nil
        {
            
            
        
        kUserList.removeAll()
        
        var contactListArray : [[String : Any]]!
        if (json["user_contact_list"] as? [[String : Any]]) != nil
        {
            
            contactListArray = json["user_contact_list"] as? [[String : Any]]
        

        for list in contactListArray {

            let userListObject = UserList()
            userListObject.name = list["list_name"] as! String
            userListObject.id = list["id"] as! Int
            
            var contactsArray : [[String : Any]]!
            if list["contacts"] as? [[String : Any]]  != nil
            {
                contactsArray = list["contacts"] as? [[String : Any]]
            }
            
            for contact in contactsArray
            {
                let contactData = ContactData()
                
                if contact["phone"] as? String != nil
                {
                    contactData.phoneNumber = contact["phone"] as! String
                }
                
//                if contact["name"] as? String != nil
//                {
                    contactData.name = BasicFunctions.getNameFromContactList(phoneNumber: contactData.phoneNumber)
//                }
                
                
                
                userListObject.contactList.append(contactData)
            }
            
            kUserList.append(userListObject)
        }
        self.contactsView.contactsTableView.reloadData()
        }
        }
        else if status != nil
        {
            if status == "error"
            {
                kUserList.removeAll()
                self.contactsView.contactsTableView.reloadData()
                
            }
        }
        else
        {
            let message = json["message"] as? String
            
            if message != nil
            {
                BasicFunctions.showAlert(vc: self, msg: message!)
            }
            
        }
    }
    
    // UITimePickerMethods
    
    func showTimePicker(textField:UITextField!){
        
        //Formate Date
        self.timePicker.datePickerMode = .time
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.cancelClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.doneTimePicker(sender:)))
        doneButton.tag = textField.tag
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        
        // add toolbar to textField
        textField.inputAccessoryView = toolbar
        // add datepicker to textField
        textField.inputView = self.timePicker
        
    }
    
    @objc func doneTimePicker(sender : UIBarButtonItem){
        //For date formate
        
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        
        if sender.tag == 1
        {
            self.createEventView.timeTextField.text = formatter.string(from: self.timePicker.date)
        }
        else
        {
            self.editEventView.timeTextField.text = formatter.string(from: self.timePicker.date)
            
        }
        
        self.createEventView.locationTextField.isUserInteractionEnabled = true
        if self.editEventView != nil
        {
            self.editEventView.locationTextField.isUserInteractionEnabled = true
        }
        
        //dismiss date picker dialog
        self.view.endEditing(true)
    }
    
//    @objc func cancelTimePicker(){
//        //cancel button dismiss datepicker dialog
//        self.view.endEditing(true)
//    }
    
    
    // UIDatePicker Methods
    
    func showDatePicker(textField:UITextField!){
        
        //Formate Date
        self.datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.cancelClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.donedatePicker(sender:)))
        doneButton.tag = textField.tag
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        
        // add toolbar to textField
        textField.inputAccessoryView = toolbar
        // add datepicker to textField
        textField.inputView = self.datePicker
        
    }
    
    @objc func donedatePicker(sender : UIBarButtonItem){
        //For date formate
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        if sender.tag == 1
        {
            self.createEventView.dateTextField.text = formatter.string(from: self.datePicker.date)
        }
        else
        {
            self.editEventView.dateTextField.text = formatter.string(from: self.datePicker.date)
            
        }
        
        self.createEventView.locationTextField.isUserInteractionEnabled = true
        if self.editEventView != nil
        {
            self.editEventView.locationTextField.isUserInteractionEnabled = true
        }
        
        //dismiss date picker dialog
        self.view.endEditing(true)
    }
    
//    @objc func cancelDatePicker(){
//        //cancel button dismiss datepicker dialog
//
//        self.createEventView.locationTextField.isUserInteractionEnabled = true
//
//        self.view.endEditing(true)
//    }
    
    
    
    @objc func createButtonTapped()
    {
        if (self.createEventView.titleTextView.text?.isEmpty)! || self.createEventView.titleTextView.text == "Invite Title"
        {
            BasicFunctions.showAlert(vc: self, msg: "Please put the title of the event.")
            return
        }

        else if self.selectedList == nil
        {
            BasicFunctions.showAlert(vc: self, msg: "Please select List.")
            return
            
        }
        else if (self.createEventView.setNumberOfPeopleTextfield.text?.isEmpty)!
        {
            BasicFunctions.showAlert(vc: self, msg: "Please select number of people.")
            return
            
        }
        else if (self.createEventView.locationTextField.text?.isEmpty)! && self.createEventView.locationSwitch.isOn
        {
            BasicFunctions.showAlert(vc: self, msg: "Please select location.")
            return
        }
        else if (self.createEventView.dateTextField.text?.isEmpty)! && self.createEventView.dateSwitch.isOn
        {
            BasicFunctions.showAlert(vc: self, msg: "Please select date.")
            return
        }
        else if (self.createEventView.timeTextField.text?.isEmpty)! && self.createEventView.timeSwitch.isOn
        {
            BasicFunctions.showAlert(vc: self, msg: "Please select time.")
            return
        }
        else if self.createEventView.setNumberOfPeopleTextfield.text == "0" || Int(self.createEventView.setNumberOfPeopleTextfield.text!)! > (self.selectedList?.contactList.count)!
        {
            BasicFunctions.showAlert(vc: self, msg: "Please put valid number of people.")
            return
        }
    
        
        
        
        BasicFunctions.showActivityIndicator(vu: self.view)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        let date = timeFormatter.date(from: self.createEventView.timeTextField.text!)
        
        timeFormatter.dateFormat = "HH:mm"
        
        
        var time24 : String!
        if date != nil
        {
            time24 = timeFormatter.string(from: date!)
        }
        
        var postParams = [String:Any]()
        postParams["user_id"] = BasicFunctions.getPreferences(kUserID)
        postParams["title"] = self.createEventView.titleTextView.text
        postParams["payment_method"] = 1
        postParams["event_address"] = self.createEventView.locationTextField.text
        postParams["list_id"] = self.selectedList?.id
        postParams["max_invited"] = self.createEventView.setNumberOfPeopleTextfield.text
        
        var dateString : String!
        var timeString : String!
        if self.createEventView.dateSwitch.isOn && self.createEventView.timeSwitch.isOn
        {
            dateString = dateFormatter.string(from: self.datePicker.date)
            timeString = time24 + ":00"
        }
        else if self.createEventView.dateSwitch.isOn && !self.createEventView.timeSwitch.isOn
        {
            dateString = dateFormatter.string(from: self.datePicker.date)
            timeString = ""
        }
        else if !self.createEventView.dateSwitch.isOn && self.createEventView.timeSwitch.isOn
        {
            dateString = ""
            timeString = time24 + ":00"
        }
        else
        {
            dateString = ""
            timeString = ""
        }
        
        postParams["event_date"] = dateString
        postParams["event_only_time"] = timeString
        
        
        
        let selectedLat = BasicFunctions.getPreferences(kSelectedLat)
        let selectedLong = BasicFunctions.getPreferences(kSelectedLong)
        
        var lat: Any!
        var long: Any!
        
        if self.createEventView.locationSwitch.isOn
        {
            if self.selectedLat == nil && self.selectedLong == nil
            {
                
            if self.currentLocationCoordinate != nil
            {
                lat = self.currentLocationCoordinate?.latitude
                long = self.currentLocationCoordinate?.longitude
            }
            }
            else
            {
                lat = selectedLat
                long = selectedLong
            }
        }
        else
        {
            lat = ""
            long = ""
        }
        
        postParams["latitude"] = lat
        postParams["longitude"] = long
        
        
        
        
        ServerManager.createEvent(postParams, accessToken: BasicFunctions.getPreferences(kAccessToken) as? String) { (result) in
            
            BasicFunctions.stopActivityIndicator(vu: self.view)
            
            let json = result as? [String : Any]
            let message = json?["message"] as? String
            
            
            if message != nil && message == "Unauthorized"
            {
                BasicFunctions.showAlert(vc: self, msg: "Session Expired. Please login again")
                BasicFunctions.showSigInVC()
                return
                
            }
            
            
            if json?["error"] == nil
            {
                
                self.createEventView.titleTextView.text = "Invite Title"
                self.createEventView.titleTextView.textColor = UIColor.lightGray
                self.createEventView.timeTextField.text = ""
                self.createEventView.dateTextField.text = ""
                self.createEventView.locationTextField.text = self.currentLocationAddress
                self.createEventView.setListTextField.text = ""
                self.createEventView.setNumberOfPeopleTextfield.text = ""
//                self.createEventView.iWillPayButton.isSelected = true
//                self.createEventView.youWillPayButton.isSelected = false
//                self.createEventView.allButton.isSelected = false
                self.selectedList = nil
                
                UserDefaults.standard.removeObject(forKey: kSelectedLat)
                UserDefaults.standard.removeObject(forKey: kSelectedLong)
                UserDefaults.standard.removeObject(forKey: kSelectedAddress)
                UserDefaults.standard.synchronize()
                
            
                
                self.dropDownPickerView.selectRow(0, inComponent: 0, animated: false)
                
                if message != nil
                {
                BasicFunctions.showAlert(vc: self, msg: message)
                }
                
                
//                let alert = UIAlertController.init(title: "Invited", message: "Event Created successfully.Are you sure you want to send invitation to those members in the selected list whose don't install the app?", preferredStyle: UIAlertControllerStyle.alert)
//                alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil))
//                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
//
//
//                if (MFMessageComposeViewController.canSendText())
//                {
//                    let controller = MFMessageComposeViewController()
//                    controller.body = "Testing SMS Feature with shayan solutions."
//                    let phoneNumberString = "03338717137,03366006260"
//                    let recipientsArray = phoneNumberString.components(separatedBy: ",")
//                    controller.recipients = recipientsArray
//                    controller.messageComposeDelegate = self
//                    self.present(controller, animated: true, completion: nil)
//                }
//                else
//                {
//                    print("Error")
//                }
//                }))
//
//                self.present(alert, animated: true, completion: nil)
            }
            else
            {
                if message != nil
                {
                    BasicFunctions.showAlert(vc: self, msg: message)
                }
                
            }
            
        }
        
    }
//    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
//        self.dismiss(animated: true, completion: nil)
//    }
//    func addPhoneNumber(phNo : String) {
//        if #available(iOS 9.0, *) {
//            let store = CNContactStore()
//            let contact = CNMutableContact()
//            let homePhone = CNLabeledValue(label: CNLabelHome, value: CNPhoneNumber(stringValue :phNo ))
//            contact.phoneNumbers = [homePhone]
//            let controller = CNContactViewController(forUnknownContact : contact)
//            controller.contactStore = store
//            controller.delegate = self
//            self.navigationController?.setNavigationBarHidden(false, animated: true)
//            self.navigationController!.pushViewController(controller, animated: true)
//        }
//    }
//    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
//        print("dismiss contact")
//
//        self.navigationController?.popViewController(animated: true)
//    }
//    func contactViewController(_ viewController: CNContactViewController, shouldPerformDefaultActionFor property: CNContactProperty) -> Bool {
//        return true
//    }
    @objc func updateButtonTapped(sender : UIButton)
    {
        if (self.editEventView.titleTextView.text?.isEmpty)! || self.editEventView.titleTextView.text == "Invite Title"
        {
            BasicFunctions.showAlert(vc: self, msg: "Please put the title of the event.")
            return
        }
        else if self.updateSelectedList == nil && self.listID == nil
        {
            BasicFunctions.showAlert(vc: self, msg: "Please select List.")
            return
            
        }
        else if (self.editEventView.setNumberOfPeopleTextfield.text?.isEmpty)!
        {
            BasicFunctions.showAlert(vc: self, msg: "Please select number of people.")
            return
            
        }
        else if (self.editEventView.locationTextField.text?.isEmpty)! && self.editEventView.locationSwitch.isOn
        {
            BasicFunctions.showAlert(vc: self, msg: "Please select location.")
            return
        }
        else if (self.editEventView.dateTextField.text?.isEmpty)! && self.editEventView.dateSwitch.isOn
        {
            BasicFunctions.showAlert(vc: self, msg: "Please select date.")
            return
        }
        else if (self.editEventView.timeTextField.text?.isEmpty)! && self.editEventView.timeSwitch.isOn
        {
            BasicFunctions.showAlert(vc: self, msg: "Please select time.")
            
            return
        }
        else if self.editEventView.setNumberOfPeopleTextfield.text == "0" || Int(self.editEventView.setNumberOfPeopleTextfield.text!)! > (self.updateSelectedList?.contactList.count)!
        {
            BasicFunctions.showAlert(vc: self, msg: "Please put valid number of people.")
        }

        
        
        
        BasicFunctions.showActivityIndicator(vu: self.view)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        let date = timeFormatter.date(from: self.editEventView.timeTextField.text!)
        
        timeFormatter.dateFormat = "HH:mm"
        
        var time24 : String!
        if date != nil
        {
            time24 = timeFormatter.string(from: date!)
        }
        
        var postParams = [String:Any]()
        postParams["user_id"] = BasicFunctions.getPreferences(kUserID)
        postParams["title"] = self.editEventView.titleTextView.text
        postParams["payment_method"] = 1
        postParams["event_address"] = self.editEventView.locationTextField.text
        postParams["event_id"] = sender.tag
        postParams["max_invited"] = self.editEventView.setNumberOfPeopleTextfield.text
        
        var dateString : String!
        var timeString : String!
        if self.editEventView.dateSwitch.isOn && self.editEventView.timeSwitch.isOn
        {
            dateString = dateFormatter.string(from: self.datePicker.date)
            timeString = time24 + ":00"
        }
        else if self.editEventView.dateSwitch.isOn && !self.editEventView.timeSwitch.isOn
        {
            dateString = dateFormatter.string(from: self.datePicker.date)
            timeString = ""
        }
        else if !self.editEventView.dateSwitch.isOn && self.editEventView.timeSwitch.isOn
        {
            dateString = ""
            timeString = time24 + ":00"
        }
        else
        {
            dateString = ""
            timeString = ""
        }
        
        postParams["event_date"] = dateString
        postParams["event_only_time"] = timeString
        
        if self.updateSelectedList != nil
        {
            postParams["list_id"] = self.updateSelectedList?.id
        }
        else
        {
            postParams["list_id"] = self.listID
        }
        
    
        let selectedLat = BasicFunctions.getPreferences(kSelectedLat)
        let selectedLong = BasicFunctions.getPreferences(kSelectedLong)
        
        var lat: Any!
        var long: Any!
        
        if self.editEventView.locationSwitch.isOn
        {
            if selectedLat == nil && selectedLong == nil
            {
                
                if self.currentLocationCoordinate != nil
                {
                    lat = self.currentLocationCoordinate?.latitude
                    long = self.currentLocationCoordinate?.longitude
                }
            }
            else
            {
                lat = selectedLat
                long = selectedLong
            }
        }
        else
        {
            lat = ""
            long = ""
        }
        
        postParams["latitude"] = lat
        postParams["longitude"] = long
        
        ServerManager.updateEvent(postParams, accessToken: BasicFunctions.getPreferences(kAccessToken) as? String) { (result) in
            
            BasicFunctions.stopActivityIndicator(vu: self.view)
            
            let json = result as! [String : Any]
            let message = json["message"] as? String
            
            if message != nil && message == "Unauthorized"
            {
                BasicFunctions.showAlert(vc: self, msg: "Session Expired. Please login again")
                BasicFunctions.showSigInVC()
                return
                
            }
            
            
            if json["error"] == nil
            {
                
                self.editEventView.titleTextView.text = "Invite Title"
                self.editEventView.titleTextView.textColor = UIColor.lightGray
                self.editEventView.timeTextField.text = ""
                self.editEventView.dateTextField.text = ""
                self.editEventView.locationTextField.text = self.currentLocationAddress
                self.editEventView.setListTextField.text = ""
                self.editEventView.setNumberOfPeopleTextfield.text = ""
//                self.editEventView.iWillPayButton.isSelected = true
//                self.editEventView.youWillPayButton.isSelected = false
//                self.editEventView.allButton.isSelected = false
                self.listID = nil
                self.updateSelectedList = nil
                
                UserDefaults.standard.removeObject(forKey: kSelectedLat)
                UserDefaults.standard.removeObject(forKey: kSelectedLong)
                UserDefaults.standard.removeObject(forKey: kSelectedAddress)
                UserDefaults.standard.synchronize()
                
                self.dropDownPickerView.selectRow(0, inComponent: 0, animated: false)
                
                self.isUpdated = false
                
                let msg = json["success"] as! String
                BasicFunctions.showAlert(vc: self, msg: msg)
                self.backButtonTapped()
                self.fetchUserEventsFromServer()
                
            }
            else
            {
                self.isUpdated = true
                if message != nil
                {
                    BasicFunctions.showAlert(vc: self, msg: message)
                }
            }
            
        }
        
    }
    
    
    func fetchUserEventsFromServer()
    {
        BasicFunctions.showActivityIndicator(vu: self.view)
        
        var postParams = [String:Any]()
        postParams["user_id"] = BasicFunctions.getPreferences(kUserID)
        
        ServerManager.getUserEvents(postParams, accessToken: BasicFunctions.getPreferences(kAccessToken) as? String) { (result) in
            
            BasicFunctions.stopActivityIndicator(vu: self.view)
            self.handleServerResponse(result as! [String : Any])
            
        }
        
    }
    
    func handleServerResponse(_ json: [String: Any])
    {
        let status = json["status"] as? String
        let message = json["message"] as? String
        
        if message != nil && message == "Unauthorized"
        {
            BasicFunctions.showAlert(vc: self, msg: "Session Expired. Please login again")
            BasicFunctions.showSigInVC()
            return
            
        }
        
        
        if  json["error"] == nil && status == nil
        {
            
            var eventsArray : [[String : Any]]!
            if json["user_events"] as? [[String : Any]] != nil
            {
                eventsArray = json["user_events"] as? [[String : Any]]
            
            self.userEventList.removeAll()
            
            for event in eventsArray!
            {
            let eventData = EventData()
            eventData.eventID = event["id"] as! Int
            eventData.userID = event["user_id"] as! Int
            eventData.title = event["title"] as! String
            eventData.eventAddress = event["event_address"] as! String
            eventData.eventTime = BasicFunctions.checkFormat(dateTimeString: event["event_time"] as? String ?? "")
            eventData.eventCreatedTime = BasicFunctions.checkFormat(dateTimeString: event["event_update_time"] as? String ?? "")
            eventData.listName = event["list_name"] as! String
            eventData.listID = event["list_id"] as! Int
            eventData.totalInvited = event["list_count"] as! Int
            eventData.lat = event["latitude"] as! String
            eventData.long = event["longitude"] as! String
            eventData.paymentMethod = event["payment_method"] as? Int ?? 0
            eventData.maximumNumberOfPeople = event["max_invited"] as? Int ?? 0
            eventData.isCreatedByAdmin = event["is_created_by_admin"] as? String ?? "0"
                
            if event["canceled_at"] as? String != nil
            {
                eventData.eventType = "canceled"
            }
                
            
            
//            let userList = event["list_users"] as? [[String : Any]]
//
//
//            for contact in userList!
//            {
//                let contactData = ContactData()
//                contactData.name = contact["name"] as! String
//                contactData.phoneNumber = contact["phone"] as! String
//                contactData.confirmed = contact["confirmed"] as! Int
//
//                eventData.userList.append(contactData)
//
//            }
            
            self.userEventList.append(eventData)
                
            }
            self.yourEventsView.yourEventsTableView.reloadData()
            
            
        }
        }
        else if status == "error"
        {
            self.userEventList.removeAll()
            self.yourEventsView.yourEventsTableView.reloadData()
            
        }
        else
        {
            if message != nil
            {
            BasicFunctions.showAlert(vc: self, msg: message)
            }
        }
        
        
    }
    
    func fetchRequestsFromServer()
    {
        BasicFunctions.showActivityIndicator(vu: self.view)
        
        var postParams = [String:Any]()
        postParams["request_to"] = BasicFunctions.getPreferences(kUserID)
        
        ServerManager.getRequests(postParams, accessToken: BasicFunctions.getPreferences(kAccessToken) as? String) { (result) in
            
            
            BasicFunctions.stopActivityIndicator(vu: self.view)
            self.handleServerResponseOfRequests(result as! [String : Any])
            
        }
        
    }
    
    func handleServerResponseOfRequests(_ json: [String: Any])
    {
        let status = json["status"] as? String
        let message = json["message"] as? String
        
        if message != nil && message == "Unauthorized"
        {
            BasicFunctions.showAlert(vc: self, msg: "Session Expired. Please login again")
            BasicFunctions.showSigInVC()
            return
            
        }
        
        
        if  json["error"] == nil && status == nil
        {
            
            var eventsArray : [[String : Any]]!
            if json["event_requests"] as? [[String : Any]] != nil
            {
                eventsArray = json["event_requests"] as? [[String : Any]]
            
                self.requestEventList.removeAll()
            
            for event in eventsArray!
            {
                let eventData = EventData()

                eventData.eventID = event["event_id"] as? Int ?? 0
                eventData.title = event["event_title"] as? String ?? ""
                eventData.totalInvited = event["total_invited"] as? Int ?? 0
                eventData.createdBy = event["create_by"] as? String ?? ""
                eventData.eventAddress = event["address"] as? String ?? ""
                eventData.confirmed = event["confirmed"] as? Int ?? 0
                eventData.eventTime = BasicFunctions.checkFormat(dateTimeString: event["event_time"] as? String ?? "")
                eventData.phone = event["phone"] as? String ?? ""
                eventData.paymentMethod = event["payment_method"] as? Int ?? 0
                eventData.listName = event["list_name"] as? String ?? ""
                eventData.eventCreatedTime = BasicFunctions.checkFormat(dateTimeString: event["updated_at"] as? String ?? "")
                
                
                if event["latitude"] as? String != nil
                {
                eventData.lat = event["latitude"] as! String
                }
                
                if event["longitude"] as? String != nil
                {
                eventData.long = event["longitude"] as! String
                }
                
//                eventData.fullName = BasicFunctions.getNameFromContactList(phoneNumber: eventData.phone)
                
                self.requestEventList.append(eventData)
                
            }
            self.requestEventView.requestEventTableView.reloadData()
            if self.requestEventList.count > 0
            {
            self.requestEventView.requestEventTableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: UITableViewScrollPosition.top, animated: true)
            }
            
            
        }
        }
        else if status == "error"
        {
            self.requestEventList.removeAll()
            self.requestEventView.requestEventTableView.reloadData()
            
        }
        else
        {
            
            if message != nil
            {
                BasicFunctions.showAlert(vc: self, msg: message)
            }
        }
        
        
    }
//    func getNameFromPhoneNumber(phone : String) -> String
//    {
//        for contctData in kContactList
//        {
//            if contctData.phoneNumber.stringByRemovingWhitespaces == phone
//            {
//                return contctData.name
//            }
//        }
//        return " "
//    }
    func fetchReceivedRequestsFromServer()
    {
        BasicFunctions.showActivityIndicator(vu: self.view)
        
        var postParams = [String:Any]()
        postParams["created_by"] = BasicFunctions.getPreferences(kUserID)
        
        ServerManager.getReceivedRequests(postParams, accessToken: BasicFunctions.getPreferences(kAccessToken) as? String) { (result) in
            
            
            BasicFunctions.stopActivityIndicator(vu: self.view)
            self.handleServerResponseOfReceivedRequests(result as! [String : Any])
            
        }
        
    }
    
    func handleServerResponseOfReceivedRequests(_ json: [String: Any])
    {
        let status = json["status"] as? String
        let message = json["message"] as? String
        
        if message != nil && message == "Unauthorized"
        {
            BasicFunctions.showAlert(vc: self, msg: "Session Expired. Please login again")
            BasicFunctions.showSigInVC()
            return
            
        }
        
        
        if  json["error"] == nil && status == nil
        {
            
            var eventsArray : [[String : Any]]!
            
            
            eventsArray = json["received_requests"] as? [[String : Any]]
                
            self.receivedRequestEventList.removeAll()
                
            for event in eventsArray
                {
                    let eventData = EventData()
                    eventData.eventID = event["id"] as! Int
                    eventData.title = event["title"] as! String
                    eventData.listID = event["list_id"] as! Int
                    eventData.eventAddress = event["event_address"] as! String
//                    eventData.totalInvited = event["requests_count"] as! Int
                    eventData.numberOfInvitationAccepted = event["accepted_requests_count"] as? Int ?? 0
                    eventData.numberOfInvitationRejected = event["reject_requests_count"] as? Int ?? 0
                    eventData.eventTime = BasicFunctions.checkFormat(dateTimeString: event["event_time"] as? String ?? "")
                    eventData.eventCreatedTime = BasicFunctions.checkFormat(dateTimeString: event["updated_at"] as? String ?? "")
                    eventData.eventType = event["event_type"] as! String
//                    eventData.eventAddress = event["address"] as! String
//                    eventData.confirmed = event["confirmed"] as! Int
//                    eventData.phone = event["phone"] as! String
//                    eventData.eventAcceptedBy = event["event_accepted"] as! Int
                    eventData.paymentMethod = event["payment_method"] as! Int
                    eventData.whoWillPay = event["who_will_pay"] as! String
                    eventData.lat = event["latitude"] as! String
                    eventData.long = event["longitude"] as! String
                    
//                    if event["contact_list"] as? [String : Any] != nil
//                    {
//                    let contactDictionary = event["contact_list"] as! [String : Any]
//                    eventData.listName = contactDictionary["list_name"] as! String
//                    }
                    
                    if event["list_name"] as! String == ""
                    {
                        eventData.listName = "Deleted"
                    }
                    else
                    {
                        eventData.listName = event["list_name"] as! String
                    }
                    
                    for list in kUserList
                    {
                        if list.id == eventData.listID
                        {
                            eventData.totalInvited = list.contactList.count
                            break
                        }
                        
                    }
                    
                    let owner = event["owner"] as! [String : Any]
                    
                    let userData = UserData()
                    userData.id = owner["id"] as! Int
                    userData.email = owner["email"] as? String ?? ""
                    userData.phone = owner["phone"] as? String ?? ""
                    
                    eventData.invitedBy = userData
                    
                    let acceptedRequestArray = event["accepted_requests"] as! [[String : Any]]
                    
                    
                    
                    for acceptedEvent in acceptedRequestArray
                    {
                        let eventAcceptedData = EventAcceptedData()
                        eventAcceptedData.id = acceptedEvent["id"] as! Int
                        eventAcceptedData.eventID = acceptedEvent["event_id"] as! Int
                        
                        if acceptedEvent["invitee"] as? [String : Any] != nil
                        {
                        let invitee = acceptedEvent["invitee"] as! [String : Any]
                        
                        let userData = UserData()
                        userData.id = invitee["id"] as! Int
                        userData.email = invitee["email"] as? String ?? ""
                        userData.phone = invitee["phone"] as? String ?? ""
                        
                        eventAcceptedData.invitee = userData
                        }
                        
                        eventData.acceptedEventList.append(eventAcceptedData)
                    }
                    
                    
                    
                    self.receivedRequestEventList.append(eventData)
                    
                }
                self.receivedEventsView.receivedEventsTableView.reloadData()
                
                
            
        }
        else if status == "error"
        {
            self.receivedRequestEventList.removeAll()
            self.receivedEventsView.receivedEventsTableView.reloadData()
            
        }
        else
        {
            
            BasicFunctions.showAlert(vc: self, msg: message)
        }
    }
    
        
        
    
    func deleteList(index : Int!)
    {
        BasicFunctions.showActivityIndicator(vu: self.view)
        
        var postParams = [String:Any]()
        postParams["list_id"] = index
        
        
        ServerManager.deleteList(postParams, accessToken: BasicFunctions.getPreferences(kAccessToken) as? String) { (result) in
            
            
            BasicFunctions.stopActivityIndicator(vu: self.view)
            
            let json = result as! [String : Any]
            let status = json["status"] as? String
            let message = json["message"] as? String
            
            if message != nil && message == "Unauthorized"
            {
                BasicFunctions.showAlert(vc: self, msg: "Session Expired. Please login again")
                BasicFunctions.showSigInVC()
                return
                
            }
            
            
            if json["error"] == nil && status == "success"
            {
                
                self.getContactListFromServer()
            }
            else
            {
                
                BasicFunctions.showAlert(vc: self, msg: message)
                
            }
                
            
            
            
        }
        
    }
    
//    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
//
//        print("Link Selected!")
//
//        return true
//    }
    
    
    
    func showPicker(textField:UITextField!)
    {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true 
        toolBar.tintColor = UIColor.blue
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelClick))
        
        doneButton.tag = textField.tag
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        self.dropDownPickerView = UIPickerView()
        self.dropDownPickerView.dataSource = self
        self.dropDownPickerView.delegate = self
        self.dropDownPickerView.tag = textField.tag
        
        if textField.tag == 2
        {
            let row = kUserList.index(where: {$0.id == self.listID})
            self.dropDownPickerView.selectRow(row! + 1, inComponent: 0, animated: false)
        }
        
        
        textField.inputView = self.dropDownPickerView
        textField.inputAccessoryView = toolBar
        
    }
    
    // When Press Done Button on PickerView
    @objc func doneClick(sender : UIBarButtonItem) {
        if sender.tag == 1
        {
        if self.selectedList != nil
        {
        self.createEventView.setListTextField.text = self.selectedList?.name
        }
        }
        else
        {
        if self.updateSelectedList != nil
        {
        self.editEventView.setListTextField.text = self.updateSelectedList?.name
        }
            
        }
        
        self.createEventView.locationTextField.isUserInteractionEnabled = true
        if self.editEventView != nil
        {
            self.editEventView.locationTextField.isUserInteractionEnabled = true
        }
        
        self.view.endEditing(true)
    }
    //When Press Cancel on PickerView
    @objc func cancelClick() {
        
        self.createEventView.locationTextField.isUserInteractionEnabled = true
        if self.editEventView != nil
        {
            self.editEventView.locationTextField.isUserInteractionEnabled = true
        }
        
        self.view.endEditing(true)
    }
    
    func addDoneButtonOnKeyboard(textField:UITextField!)
    {
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()


        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)

        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.cancelClick))

        toolbar.setItems([spaceButton,doneButton], animated: false)


        // add toolbar to textField
        textField.inputAccessoryView = toolbar
    }
    func addDoneButtonOnTextViewKeyboard(textView:UITextView!)
    {
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.cancelClick))
        
        toolbar.setItems([spaceButton,doneButton], animated: false)
        
        
        // add toolbar to textField
        textView.inputAccessoryView = toolbar
    }
    
    @objc func doneButtonAction()
    {
        self.view.endEditing(true)
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
