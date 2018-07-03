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
    var userID = Int()
    var totalInvited = Int()
    var createdBy = String()
    var confirmed = Int()
    var phone = String()
    var firstName = String()
    var lastName = String()
    var fullName = String()
    var maximumNumberOfPeople = Int()
    var userList = [ContactData]()
    
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
class HomeVC : UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,CLLocationManagerDelegate {
    
    
    var locationManager = CLLocationManager()
    
    @IBOutlet var lineView: UIView!
    
    @IBOutlet var contactListButton: UIButton!
    @IBOutlet var createNewButton: UIButton!
    @IBOutlet var eventstatusButton: UIButton!
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet var mainScrollView: UIScrollView!
    
    
    var userList = [UserList]()
    
    var contactsView : ContactsView!
    var createEventView : CreateEventView!
    var eventStatusView : EventStatusView!
    var requestEventView : RequestEventView!
    var yourEventsView : YourEventsView!
    var receivedEventsView : ReceivedEventsView!
    var detailView : DetailView!
    var editEventView : CreateEventView!
    var eventDetailView : EventDetailView!
    var receivedEventDetailView : ReceivedEventDetailView!
    
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()
    
    var currentLocationCoordinate : CLLocationCoordinate2D!
    var locationCoordinate : CLLocationCoordinate2D?
    
    var placeSelectedORCancelled : Bool!
    
    var selectedButton : UIButton!
    
    var currentLocationAddress : String?
    var selectedLocationAddress : String?
    
    var userEventList = [EventData]()
    var requestEventList = [EventData]()
    var receivedRequestEventList = [EventData]()
    var invitedList : [ContactData]!
    var specificReceivedRequestEventList = [EventData]()
    
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
        
//        self.isStartNavigationButtonTapped = false
        self.isUpdated = false
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        
        
        
        
        self.updateDeviceToken()
        
        self.placeSelectedORCancelled = false
        
        self.setUpScrollView()
//        self.fetchUserEventsFromServer()
        
//        self.fetchRequestsFromServer()
//        self.fetchReceivedRequestsFromServer()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.receivedNotification(notification:)), name: Notification.Name("ReceiveNotificationData"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.appDidBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
//        let tapRecognizer = UITapGestureRecognizer()
//        tapRecognizer.addTarget(self, action: #selector(self.didTapView))
//        self.view.addGestureRecognizer(tapRecognizer)
        
    
    }
    @objc func appDidBecomeActive()
    {
        self.fetchRequestsFromServer()
        self.fetchReceivedRequestsFromServer()

    
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.locationManager.startUpdatingLocation()
        
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
            if (self.lineView.frame.origin.x != self.contactListButton.frame.origin.x) {
                
                UIView.animate(withDuration: 0.25) {
                    
                    self.lineView.frame.origin.x = self.contactListButton.frame.origin.x
                    
                }
                
            }
            let point = CGPoint(x: 0, y: 0)
            self.mainScrollView.setContentOffset( point, animated: true)
            
//            self.fetchAllContactsFromDevice()
            self.getContactListFromServer()
            
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
        
        if (self.lineView.frame.origin.x != self.eventstatusButton.frame.origin.x) {

            UIView.animate(withDuration: 0.25) {

                self.lineView.frame.origin.x = self.eventstatusButton.frame.origin.x

            }

        }

        var point = CGPoint(x: 2 * self.mainScrollView.frame.size.width, y: 0)
        self.mainScrollView.setContentOffset( point, animated: true)
        
        
        
        let status = notification.userInfo!["status"] as! String
        if status == "request" ||  status == "cancelled" || status == "closed"
        {


            if (self.eventStatusView.lineView.frame.origin.x != self.eventStatusView.requestButton.frame.origin.x) {

                UIView.animate(withDuration: 0.25) {

                    self.eventStatusView.lineView.frame.origin.x = self.eventStatusView.requestButton.frame.origin.x

                }


            }
            point = CGPoint(x: 0, y: 0)
            self.eventStatusView.mainScrollView.setContentOffset( point, animated: true)
            self.fetchRequestsFromServer()
            
        }
        else if status == "confirmed"
        {

            if (self.eventStatusView.lineView.frame.origin.x != self.eventStatusView.receivedButton.frame.origin.x) {

                UIView.animate(withDuration: 0.25) {

                    self.eventStatusView.lineView.frame.origin.x = self.eventStatusView.receivedButton.frame.origin.x

                }


            }
            point = CGPoint(x: self.eventStatusView.mainScrollView.frame.size.width * 2, y: 0)
            self.eventStatusView.mainScrollView.setContentOffset( point, animated: true)
            self.fetchReceivedRequestsFromServer()
            
            
        }
        
        
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {

        self.currentLocationCoordinate = locations.last?.coordinate
        

        self.reverseGeocodeCoordinate((locations.last?.coordinate)!)
        
        
        
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
            
            guard let address = response?.firstResult(), let lines = address.lines else {
                return
            }
            
            // 3
            self.currentLocationAddress = lines.joined(separator: "\n")
//            self.createEventView.locationTextField.text = self.currentLocationAddress
            
            
        }
    }

    
    @IBAction func addButtonTapped(_ sender: UIButton)
    {
        let createListVC = self.storyboard?.instantiateViewController(withIdentifier: "CreateListVC")
        self.present(createListVC!, animated: true, completion: nil)
    }
    
    
    @IBAction func contactListButtonTapped(_ sender: UIButton)
    {
        if (self.lineView.frame.origin.x != self.contactListButton.frame.origin.x) {
            
            UIView.animate(withDuration: 0.25) {
                
                self.lineView.frame.origin.x = self.contactListButton.frame.origin.x
                
            }
            
        }
        let point = CGPoint(x: 0, y: 0)
        self.mainScrollView.setContentOffset( point, animated: true)
        self.isUpdated = false
    }
    
    @IBAction func createNewButtonTapped(_ sender: UIButton)
    {
        if (self.lineView.frame.origin.x != self.createNewButton.frame.origin.x) {
            
            UIView.animate(withDuration: 0.25) {
                
                self.lineView.frame.origin.x = self.createNewButton.frame.origin.x
                
            }
            
        }
        self.isUpdated = false
        
        let point = CGPoint(x: self.mainScrollView.frame.size.width, y: 0)
        self.mainScrollView.setContentOffset( point, animated: true)
        
        self.createEventView.locationTextField.text = self.currentLocationAddress
        
        self.createEventView.setListTextField.text = ""
        self.selectedList = nil
        
        UserDefaults.standard.removeObject(forKey: kSelectedLat)
        UserDefaults.standard.removeObject(forKey: kSelectedLong)
        UserDefaults.standard.removeObject(forKey: kSelectedAddress)
        UserDefaults.standard.synchronize()
        
        
        
    }
    
    @IBAction func eventStatusButtonTapped(_ sender: UIButton)
    {
        if (self.lineView.frame.origin.x != self.eventstatusButton.frame.origin.x) {
            
            UIView.animate(withDuration: 0.25) {
                
                self.lineView.frame.origin.x = self.eventstatusButton.frame.origin.x
                
            }
            
        }
        
        let point = CGPoint(x: 2 * self.mainScrollView.frame.size.width, y: 0)
        self.mainScrollView.setContentOffset( point, animated: true)
        self.fetchRequestsFromServer()
        
    }
    
    func setUpScrollView()
    {
        self.contactsView = ContactsView.instanceFromNib() as! ContactsView
        
        self.contactsView.frame = CGRect(x: 0 , y: 0, width: Int(self.view.frame.size.width), height: Int(self.mainScrollView.frame.size.height))
        self.contactsView.contactsTableView.register(UINib(nibName: "ContactCell", bundle: nil), forCellReuseIdentifier: "ContactCell")
        self.contactsView.contactsTableView.delegate = self
        self.contactsView.contactsTableView.dataSource = self
        
        self.mainScrollView.addSubview(self.contactsView)
        
        self.createEventView = CreateEventView.instanceFromNib() as! CreateEventView
        self.createEventView.frame = CGRect(x: Int(self.view.frame.size.width) , y: 0, width: Int(self.mainScrollView.frame.size.width), height: Int(self.mainScrollView.frame.size.height))
        
//        self.createEventView.titleTextField.attributedPlaceholder = NSAttributedString(string: "Invite Title",
//                                                               attributes: [NSAttributedStringKey.foregroundColor: UIColor.darkGray])
//        self.createEventView.titleTextField.attributedPlaceholder = NSAttributedString(string: "Invite Title",
//                                                                                       attributes: [NSAttributedStringKey.foregroundColor: UIColor.darkGray])
        
        self.createEventView.titleTextField.tag = 1
        self.createEventView.timeTextField.tag = 1
        self.createEventView.dateTextField.tag = 1
        self.createEventView.locationTextField.tag = 3
        self.createEventView.setNumberOfPeopleTextfield.tag = 1
        self.createEventView.setListTextField.tag = 1
        
        self.createEventView.titleTextField.delegate = self
        self.createEventView.setNumberOfPeopleTextfield.delegate = self
        self.createEventView.timeTextField.delegate = self
        self.createEventView.dateTextField.delegate = self
        self.createEventView.locationTextField.delegate = self
        self.createEventView.setListTextField.delegate = self
        
        self.showPicker(textField: self.createEventView.setListTextField)
        
        self.showDatePicker(textField: self.createEventView.dateTextField)
        self.showTimePicker(textField: self.createEventView.timeTextField)
        
        self.addDoneButtonOnKeyboard(textField: self.createEventView.setNumberOfPeopleTextfield)
        
        self.createEventView.iWillPayButton.addTarget(self, action: #selector(self.radioButtonTapped(sender:)), for: UIControlEvents.touchUpInside)
        self.createEventView.youWillPayButton.addTarget(self, action: #selector(self.radioButtonTapped(sender:)), for: UIControlEvents.touchUpInside)
        
        self.createEventView.titleTextField.text = self.currentLocationAddress
        
        self.createEventView.allButton.addTarget(self, action: #selector(self.radioButtonTapped(sender:)), for: UIControlEvents.touchUpInside)
        
        self.selectedButton = createEventView.iWillPayButton
        
        
        
        self.createEventView.createButton.addTarget(self, action: #selector(self.createButtonTapped), for: UIControlEvents.touchUpInside)
//        self.createEventView.updateButton.addTarget(self, action: #selector(self.updateButtonTapped), for: UIControlEvents.touchUpInside)
        
        self.mainScrollView.addSubview(self.createEventView)
        
        
        
        self.eventStatusView = EventStatusView.instanceFromNib() as! EventStatusView
        self.eventStatusView.frame = CGRect(x: Int(self.view.frame.size.width * 2) , y: 0, width: Int(self.mainScrollView.frame.size.width), height: Int(self.mainScrollView.frame.size.height))
        
        self.eventStatusView.requestButton.addTarget(self, action: #selector(self.tapOnEventStatusViewTabs(_:)), for: UIControlEvents.touchUpInside)
        self.eventStatusView.yourEventsButton.addTarget(self, action: #selector(self.tapOnEventStatusViewTabs(_:)), for: UIControlEvents.touchUpInside)
        self.eventStatusView.receivedButton.addTarget(self, action: #selector(self.tapOnEventStatusViewTabs(_:)), for: UIControlEvents.touchUpInside)
        
        self.setUpStatusScrollView()
        
        self.mainScrollView.addSubview(self.eventStatusView)
        
        
        
        self.mainScrollView.contentSize.width = self.mainScrollView.frame.size.width * 3
        self.mainScrollView.isPagingEnabled = true
    }
    func setUpStatusScrollView()
    {
         self.requestEventView = RequestEventView.instanceFromNib() as! RequestEventView
        
        self.requestEventView.frame = CGRect(x: 0 , y: 0, width: Int(self.eventStatusView.mainScrollView.frame.size.width), height: Int(self.eventStatusView.mainScrollView.frame.size.height))
        
        self.requestEventView.requestEventTableView.register(UINib(nibName: "RequestEventCell", bundle: nil), forCellReuseIdentifier: "RequestEventCell")
        
        self.requestEventView.requestEventTableView.delegate = self
        self.requestEventView.requestEventTableView.dataSource = self
        
        self.eventStatusView.mainScrollView.addSubview(self.requestEventView)
        
        
        self.yourEventsView = YourEventsView.instanceFromNib() as! YourEventsView
        
        self.yourEventsView.frame = CGRect(x: Int(self.view.frame.size.width) , y: 0, width: Int(self.eventStatusView.mainScrollView.frame.size.width), height: Int(self.eventStatusView.mainScrollView.frame.size.height))
        
        self.yourEventsView.yourEventsTableView.register(UINib(nibName: "YourEventsCell", bundle: nil), forCellReuseIdentifier: "YourEventsCell")
        
        self.yourEventsView.yourEventsTableView.delegate = self
        self.yourEventsView.yourEventsTableView.dataSource = self
        
        self.eventStatusView.mainScrollView.addSubview(self.yourEventsView)
        
        
        self.receivedEventsView = ReceivedEventsView.instanceFromNib() as! ReceivedEventsView
        
        self.receivedEventsView.frame = CGRect(x: Int(self.view.frame.size.width * 2) , y: 0, width: Int(self.eventStatusView.mainScrollView.frame.size.width), height: Int(self.eventStatusView.mainScrollView.frame.size.height))
        
        self.receivedEventsView.receivedEventsTableView.register(UINib(nibName: "ReceivedEventsCell", bundle: nil), forCellReuseIdentifier: "ReceivedEventsCell")
        
        self.receivedEventsView.receivedEventsTableView.delegate = self
        self.receivedEventsView.receivedEventsTableView.dataSource = self
        
        self.eventStatusView.mainScrollView.addSubview(self.receivedEventsView)
        
        
        
        self.eventStatusView.mainScrollView.contentSize.width = self.eventStatusView.mainScrollView.frame.size.width * 3
        self.eventStatusView.mainScrollView.isPagingEnabled = true
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return self.userList.count + 1
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if row == 0
        {
            return "Select List"
        }
        
        if self.userList.count != 0
        {
        return (self.userList[row - 1] ).name
        }
        return ""
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView.tag == 1
        {
        if self.userList.count != 0 && row != 0
        {
        self.selectedList = self.userList[row - 1]
        
        }
        else
        {
            self.selectedList = nil
            self.createEventView.setListTextField.text = ""
            
        }
        }
        else
        {
            if self.userList.count != 0 && row != 0
            {
                self.updateSelectedList = self.userList[row - 1]
                
            }
            else
            {
                self.updateSelectedList = nil
                self.listID = nil
                
                self.editEventView.setListTextField.text = ""
                
            }
            
        }
        
    }
    
    
    @IBAction func tapOnEventStatusViewTabs(_ sender: UIButton)
    {
        self.backButtonTapped()
        var point = CGPoint(x: 0, y: 0)
        
        
        if sender.tag == 1
        {
        if (self.eventStatusView.lineView.frame.origin.x != self.eventStatusView.requestButton.frame.origin.x) {
            
            UIView.animate(withDuration: 0.25) {
                
                self.eventStatusView.lineView.frame.origin.x = self.eventStatusView.requestButton.frame.origin.x
                
            }
            
            
        }
            self.eventStatusView.mainScrollView.setContentOffset( point, animated: true)
            self.fetchRequestsFromServer()

        }
        else if sender.tag == 2
        {
            if (self.eventStatusView.lineView.frame.origin.x != self.eventStatusView.yourEventsButton.frame.origin.x) {
                
                
                
                UIView.animate(withDuration: 0.25) {
                    
                    self.eventStatusView.lineView.frame.origin.x = self.eventStatusView.yourEventsButton.frame.origin.x
                    
                }
                
            }
            
            point = CGPoint(x: self.eventStatusView.mainScrollView.frame.size.width, y: 0)
            self.eventStatusView.mainScrollView.setContentOffset( point, animated: true)
            self.fetchUserEventsFromServer()
            
        }
        else
        {
            if (self.eventStatusView.lineView.frame.origin.x != self.eventStatusView.receivedButton.frame.origin.x) {
                
                
                
                UIView.animate(withDuration: 0.25) {
                    
                    self.eventStatusView.lineView.frame.origin.x = self.eventStatusView.receivedButton.frame.origin.x
                    
                }
                
            }
            
            point = CGPoint(x: self.eventStatusView.mainScrollView.frame.size.width * 2, y: 0)
            self.eventStatusView.mainScrollView.setContentOffset( point, animated: true)
            self.fetchReceivedRequestsFromServer()
            
        }
        
        
    }
    
    @objc func radioButtonTapped(sender:UIButton)
    {
        for button in (sender.superview?.subviews)!
        {
            if button.isKind(of: UIButton.self)
            {
                (button as! UIButton).isSelected = false
            }
        }
        
        sender.isSelected = true
        self.selectedButton = sender
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView.tag == 1
        {
        return self.userList.count
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
            return self.specificReceivedRequestEventList.count
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
            
        
        let userListObject = self.userList[indexPath.row]
        
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
            
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            
            let date = dateformatter.date(from: eventData.eventTime)
            
            dateformatter.dateStyle = .medium
            dateformatter.timeStyle = .short
            
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
            if eventData.fullName == " "
            {
                invitedBy = eventData.phone
            }
            else
            {
                invitedBy = eventData.fullName + " " + "(" + eventData.phone + ")"
            }
            

            requestEventCell?.eventName.text = eventData.title
            requestEventCell?.date.attributedText = NSMutableAttributedString().bold("Date : ").normal(dateformatter.string(from: date!))
            requestEventCell?.createdBy.attributedText = NSMutableAttributedString().bold("Invited by : ").normal(invitedBy)
            requestEventCell?.totalInvited.attributedText = NSMutableAttributedString().bold("Total Invited : ").normal(String(eventData.totalInvited))
            
            requestEventCell?.expandButton.tag = indexPath.row
            requestEventCell?.startNavigationButton.tag = indexPath.row
            requestEventCell?.acceptButton.tag = indexPath.row
            requestEventCell?.rejectButton.tag = indexPath.row
            
            requestEventCell?.expandButton.addTarget(self, action: #selector(self.showDetailView(sender:)), for: UIControlEvents.touchUpInside)
            requestEventCell?.startNavigationButton.addTarget(self, action: #selector(self.startNavigationButtonTapped(sender:)), for: UIControlEvents.touchUpInside)
            requestEventCell?.acceptButton.addTarget(self, action: #selector(self.acceptButtonTapped(sender:)), for: UIControlEvents.touchUpInside)
            requestEventCell?.rejectButton.addTarget(self, action: #selector(self.rejectButtonTapped(sender:)), for: UIControlEvents.touchUpInside)
            
            
            if eventData.confirmed == 0
            {
                requestEventCell?.startNavigationButton.isHidden = true
                requestEventCell?.acceptORRejectView.isHidden = true
                requestEventCell?.acceptORRejectLabel.isHidden = false
                requestEventCell?.acceptORRejectLabel.text = "Rejected"
                requestEventCell?.acceptORRejectLabel.textColor = UIColor.init(red: 255/255, green: 97/255, blue: 71/255, alpha: 1.0)
                
            }
            else if eventData.confirmed == 1
            {
                requestEventCell?.startNavigationButton.isHidden = false
                requestEventCell?.acceptORRejectView.isHidden = true
                requestEventCell?.acceptORRejectLabel.isHidden = false
                requestEventCell?.acceptORRejectLabel.text = "Accepted"
                requestEventCell?.acceptORRejectLabel.textColor = UIColor.init(red: 134/255, green: 224/255, blue: 139/255, alpha: 1.0)
                
            }
            else if eventData.confirmed == 2
            {
                requestEventCell?.startNavigationButton.isHidden = false
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
                requestEventCell?.acceptORRejectLabel.text = "Too late, event has been closed."
                requestEventCell?.acceptORRejectLabel.textColor = UIColor.black
                
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
            
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let date = dateformatter.date(from: eventData.eventTime)
            
            let date2 = dateformatter.date(from: eventData.eventCreatedTime)
            
            dateformatter.dateStyle = .medium
            dateformatter.timeStyle = .short
            
//            dateformatter.dateFormat = "dd/MM/yyyy"
//
//            let formatter2 = DateFormatter()
//            formatter2.dateFormat = "yyyy-MM-dd HH:mm:ss"
//
//            //        let timeString = eventData.eventTime.components(separatedBy: " ")[1
//            let time = formatter2.date(from: eventData.eventTime)
            
//            formatter2.dateFormat = "hh:mm a"

            yourEventsCell?.title.text = eventData.title
            yourEventsCell?.listName.attributedText = NSMutableAttributedString().bold("List name : ").normal(eventData.listName)
            yourEventsCell?.createdDate.attributedText = NSMutableAttributedString().bold("Date and time of invite sent : ").normal(dateformatter.string(from: date2!))
            yourEventsCell?.location.attributedText = NSMutableAttributedString().bold("Location : ").normal(eventData.eventAddress)
            yourEventsCell?.totalInvited.attributedText = NSMutableAttributedString().bold("Total invited : ").normal(String(eventData.totalInvited))
            yourEventsCell?.date.attributedText = NSMutableAttributedString().bold("Date and time of the event : ").normal(dateformatter.string(from: date!))
            
            
            yourEventsCell?.expandButton.tag = indexPath.row
            yourEventsCell?.editButton.tag = indexPath.row
            yourEventsCell?.deleteButton.tag = indexPath.row
            
            yourEventsCell?.expandButton.addTarget(self, action: #selector(self.showEventDetailView(sender:)), for: UIControlEvents.touchUpInside)
            yourEventsCell?.editButton.addTarget(self, action: #selector(self.showEditView(sender:)), for: UIControlEvents.touchUpInside)
            yourEventsCell?.deleteButton.addTarget(self, action: #selector(self.deleteButtonTapped(sender:)), for: UIControlEvents.touchUpInside)
            
            
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
            
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let date = dateformatter.date(from: eventData.eventTime)
            
            dateformatter.dateStyle = .medium
            dateformatter.timeStyle = .short
            
//            dateformatter.dateFormat = "dd/MM/yyyy"
//
//            let formatter2 = DateFormatter()
//            formatter2.dateFormat = "yyyy-MM-dd HH:mm:ss"
//
//            //        let timeString = eventData.eventTime.components(separatedBy: " ")[1
//            let time = formatter2.date(from: eventData.eventTime)
//
//            formatter2.dateFormat = "hh:mm a"
            
            var invitedTo : String!
            if eventData.fullName == " "
            {
                invitedTo = eventData.phone
            }
            else
            {
                invitedTo = eventData.fullName + " " + "(" + eventData.phone + ")"
            }
            
            receivedEventsCell?.title.text = eventData.title
            receivedEventsCell?.date.attributedText = NSMutableAttributedString().bold("Date : ").normal(dateformatter.string(from: date!))
            
            
            receivedEventsCell?.invitedBy.attributedText = NSMutableAttributedString().bold("Invited to : ").normal(invitedTo)
            
            
            if eventData.confirmed == 0
            {
                receivedEventsCell?.iconAccepted.image = UIImage.init(named: "iconDeclined")
                receivedEventsCell?.acceptLabel.text = "Rejected"
                receivedEventsCell?.acceptLabel.textColor = UIColor.init(red: 255/255, green: 97/255, blue: 71/255, alpha: 1.0)
            }
            else if eventData.confirmed == 1
            {
                receivedEventsCell?.iconAccepted.image = UIImage.init(named: "iconAccepted")
                receivedEventsCell?.acceptLabel.text = "Accepted"
                receivedEventsCell?.acceptLabel.textColor = UIColor.init(red: 134/255, green: 224/255, blue: 139/255, alpha: 1.0)
                
            }
            else if eventData.confirmed == 2
            {
                receivedEventsCell?.iconAccepted.image = UIImage.init(named: "iconActionPending")
                receivedEventsCell?.acceptLabel.text = "Action Pending"
                receivedEventsCell?.acceptLabel.textColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.7)
            }
            
            receivedEventsCell?.expandButton.tag = indexPath.row
            receivedEventsCell?.expandButton.addTarget(self, action: #selector(self.showReceivedEventDetailView(sender:)), for: UIControlEvents.touchUpInside)
            
            
            
            
            return receivedEventsCell!
            
        }
        else if tableView.tag == 5
        {
            var receivedEventsCell  = (tableView.dequeueReusableCell(withIdentifier: "ReceivedEventsCell"))! as? ReceivedEventsCell
            if receivedEventsCell == nil
            {
                receivedEventsCell = Bundle.main.loadNibNamed("ReceivedEventsCell", owner: nil, options: nil)?[0] as? ReceivedEventsCell
            }
            
            
            let eventData = self.specificReceivedRequestEventList[indexPath.row]
            
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let date = dateformatter.date(from: eventData.eventTime)
            
            dateformatter.dateStyle = .medium
            dateformatter.timeStyle = .short
            
//            dateformatter.dateFormat = "dd/MM/yyyy"
//
//            let formatter2 = DateFormatter()
//            formatter2.dateFormat = "yyyy-MM-dd HH:mm:ss"
//
//            //        let timeString = eventData.eventTime.components(separatedBy: " ")[1
//            let time = formatter2.date(from: eventData.eventTime)
//
//            formatter2.dateFormat = "hh:mm a"
            
            var invitedTo : String!
            if eventData.fullName == " "
            {
                invitedTo = eventData.phone
            }
            else
            {
                invitedTo = eventData.fullName + " " + "(" + eventData.phone + ")"
            }
            
            receivedEventsCell?.title.text = eventData.title
            receivedEventsCell?.date.attributedText = NSMutableAttributedString().bold("Date : ").normal(dateformatter.string(from: date!))
            
            
            receivedEventsCell?.invitedBy.attributedText = NSMutableAttributedString().bold("Invited to : ").normal(invitedTo)
            
            if eventData.confirmed == 0
            {
                receivedEventsCell?.iconAccepted.image = UIImage.init(named: "iconDeclined")
                receivedEventsCell?.acceptLabel.text = "Rejected"
                receivedEventsCell?.acceptLabel.textColor = UIColor.init(red: 255/255, green: 97/255, blue: 71/255, alpha: 1.0)
            }
            else if eventData.confirmed == 1
            {
                receivedEventsCell?.iconAccepted.image = UIImage.init(named: "iconAccepted")
                receivedEventsCell?.acceptLabel.text = "Accepted"
                receivedEventsCell?.acceptLabel.textColor = UIColor.init(red: 134/255, green: 224/255, blue: 139/255, alpha: 1.0)
                
            }
            else if eventData.confirmed == 2
            {
                receivedEventsCell?.iconAccepted.image = UIImage.init(named: "iconActionPending")
                receivedEventsCell?.acceptLabel.text = "Action Pending"
                receivedEventsCell?.acceptLabel.textColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.7)
            }
            
            receivedEventsCell?.expandButton.isHidden = true
//            receivedEventsCell?.expandButton.addTarget(self, action: #selector(self.showReceivedEventDetailView(sender:)), for: UIControlEvents.touchUpInside)
            
            
            
            
            return receivedEventsCell!
            

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
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//
//
//
//        }
//    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        var editAction = UITableViewRowAction(style: .default, title: "", handler: { (action, indexPath) in
            
        
            
        })
        
        var deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            
            
            self.deleteList(index: self.userList[indexPath.row].id)
            
            self.userList.remove(at: indexPath.row)
            self.contactsView.contactsTableView.deleteRows(at: [indexPath], with: .automatic)
            
            
            
        })
        
        return[editAction,deleteAction]
        
    }
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        let listDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "ListDetailVC") as! ListDetailVC
        listDetailVC.listData = self.userList[indexPath.row]
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
            self.showSearchVC()
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    @objc func showReceivedEventDetailView(sender:UIButton)
    {
        self.receivedEventDetailView  = ReceivedEventDetailView.instanceFromNib() as! ReceivedEventDetailView
        
        self.receivedEventDetailView.frame = CGRect(x: 0 , y: 0, width: Int(self.receivedEventsView.frame.size.width), height: Int(self.receivedEventsView.frame.size.height))
        
        self.receivedEventDetailView.receivedEventDetailTableView.register(UINib(nibName: "ReceivedEventsCell", bundle: nil), forCellReuseIdentifier: "ReceivedEventsCell")
        
        self.receivedEventDetailView.receivedEventDetailTableView.delegate = self
        self.receivedEventDetailView.receivedEventDetailTableView.dataSource = self
        
        self.receivedEventDetailView.backButton.addTarget(self, action: #selector(self.backButtonTapped), for: UIControlEvents.touchUpInside)
        
        self.receivedEventsView.addSubview(self.receivedEventDetailView)
        
        
        let eventData = self.receivedRequestEventList[sender.tag]
        
        self.specificReceivedRequestEventList.removeAll()
        
        for event in self.receivedRequestEventList
        {
            if eventData.eventID == event.eventID
            {
                self.specificReceivedRequestEventList.append(event)
            }
        }

        self.receivedEventDetailView.receivedEventDetailTableView.reloadData()
        // Testing github.
        
    }
    
    
    @objc func showDetailView(sender:UIButton)
    {
        self.detailView  = DetailView.instanceFromNib() as! DetailView
        
        self.detailView.frame = CGRect(x: 0 , y: 0, width: Int(self.requestEventView.frame.size.width), height: Int(self.requestEventView.frame.size.height))
        
        let eventData = self.requestEventList[sender.tag]
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let date = dateformatter.date(from: eventData.eventTime)
        
        dateformatter.dateStyle = .medium
        dateformatter.timeStyle = .short
        
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
        if eventData.fullName.isEmpty
        {
            invitedBy = eventData.phone
        }
        else
        {
            invitedBy = eventData.fullName + " " + "(" + eventData.phone + ")"
        }
        
        self.detailView.title.text = eventData.title
        self.detailView.createdBy.attributedText = NSMutableAttributedString().bold("Invited by : ").normal(invitedBy)
        self.detailView.date.attributedText = NSMutableAttributedString().bold("Date : ").normal(dateformatter.string(from: date!))
        self.detailView.location.attributedText = NSMutableAttributedString().bold("Location : ").normal(eventData.eventAddress)
        self.detailView.totalInvited.attributedText = NSMutableAttributedString().bold("Total Invited : ").normal(String(eventData.totalInvited))
        
        self.detailView.acceptButton.tag = sender.tag
        self.detailView.rejectButton.tag = sender.tag
        self.detailView.startNavigationButton.tag = sender.tag
        
        if eventData.confirmed == 0
        {
            self.detailView.acceptORRejectButtonView.isHidden = true
            self.detailView.startNavigationView.isHidden = true
            self.detailView.rejectLabel.isHidden = false
        }
        else if eventData.confirmed == 1
        {
            self.detailView.acceptORRejectButtonView.isHidden = true
            self.detailView.startNavigationView.isHidden = false
            self.detailView.rejectLabel.isHidden = true
            
        }
        else if eventData.confirmed == 3
        {
            self.detailView.acceptORRejectButtonView.isHidden = true
            self.detailView.startNavigationView.isHidden = true
            self.detailView.rejectLabel.isHidden = false
            self.detailView.rejectLabel.text = "Too late. Event has been closed."
            self.detailView.rejectLabel.textColor = UIColor.black
            
        }
        
        
        if eventData.paymentMethod == 1
        {
            self.detailView.paymentMethodLabel.text = "I will pay."
        }
        else if eventData.paymentMethod == 2
        {
            self.detailView.paymentMethodLabel.text = "You will pay."
        }
        else
        {
            self.detailView.paymentMethodLabel.text = "All members will pay."
        }
        
        BasicFunctions.setRoundCornerOfButton(button: self.detailView.acceptButton, radius: 5.0)
        BasicFunctions.setRoundCornerOfButton(button: self.detailView.rejectButton, radius: 5.0)
        BasicFunctions.setRoundCornerOfButton(button: self.detailView.startNavigationButton, radius: 5.0)
        
        self.detailView.acceptButton.addTarget(self, action: #selector(self.acceptButtonTapped(sender:)), for: UIControlEvents.touchUpInside)
        self.detailView.rejectButton.addTarget(self, action: #selector(self.rejectButtonTapped(sender:)), for: UIControlEvents.touchUpInside)
        self.detailView.startNavigationButton.addTarget(self, action: #selector(self.startNavigationButtonTapped(sender:)), for: UIControlEvents.touchUpInside)
        
        
        
        self.detailView.backButton.addTarget(self, action: #selector(self.backButtonTapped), for: UIControlEvents.touchUpInside)
        
        self.requestEventView.addSubview(detailView)
    }
    @objc func showEventDetailView(sender : UIButton)
    {
        self.eventDetailView  = EventDetailView.instanceFromNib() as! EventDetailView
        
        self.eventDetailView.frame = CGRect(x: 0 , y: 0, width: Int(self.yourEventsView.frame.size.width), height: Int(self.yourEventsView.frame.size.height))
        
        let eventData = self.userEventList[sender.tag]
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let date = dateformatter.date(from: eventData.eventTime)
        
        let date2 = dateformatter.date(from: eventData.eventCreatedTime)
        
        dateformatter.dateStyle = .medium
        dateformatter.timeStyle = .short
        
//        dateformatter.dateFormat = "dd/MM/yyyy"
//
//        let formatter2 = DateFormatter()
//        formatter2.dateFormat = "yyyy-MM-dd HH:mm:ss"
//
//        //        let timeString = eventData.eventTime.components(separatedBy: " ")[1
//        let time = formatter2.date(from: eventData.eventTime)
//
//        formatter2.dateFormat = "hh:mm a"
        
        
        self.eventDetailView.title.text = eventData.title
        self.eventDetailView.listName.attributedText = NSMutableAttributedString().bold("List name : ").normal(eventData.listName)
        self.eventDetailView.createdDate.attributedText = NSMutableAttributedString().bold("Date and time of invite sent : ").normal(dateformatter.string(from: date2!))
        self.eventDetailView.location.attributedText = NSMutableAttributedString().bold("Location : ").normal(eventData.eventAddress)
        self.eventDetailView.totalInvited.attributedText = NSMutableAttributedString().bold("Total Invited : ").normal(String(eventData.totalInvited))
        self.eventDetailView.date.attributedText = NSMutableAttributedString().bold("Date and time of event : ").normal(dateformatter.string(from: date!))
        

        self.eventDetailView.backButton.addTarget(self, action: #selector(self.backButtonTapped), for: UIControlEvents.touchUpInside)
        
        self.invitedList = eventData.userList
        
//        self.eventDetailView.inviedListTableView.dataSource = self
//        self.eventDetailView.inviedListTableView.delegate = self
        
        self.yourEventsView.addSubview(self.eventDetailView)
    }
    @objc func showEditView(sender : UIButton!)
    {
        self.editEventView  = CreateEventView.instanceFromNib() as! CreateEventView
        
        self.editEventView.frame = CGRect(x: 0 , y: 0, width: Int(self.yourEventsView.frame.size.width), height: Int(self.yourEventsView.frame.size.height))
        
        self.editEventView.titleTextField.tag = 2
        self.editEventView.timeTextField.tag = 2
        self.editEventView.dateTextField.tag = 2
        self.editEventView.locationTextField.tag = 3
        self.editEventView.setNumberOfPeopleTextfield.tag = 2
        self.editEventView.setListTextField.tag = 2
        
        self.selectedList = nil
        
        
        self.editEventView.titleTextField.delegate = self
        self.editEventView.setNumberOfPeopleTextfield.delegate = self
        self.editEventView.timeTextField.delegate = self
        self.editEventView.dateTextField.delegate = self
        self.editEventView.locationTextField.delegate = self
        self.editEventView.setListTextField.delegate = self
        
        self.isUpdated = true
        
        let eventData = self.userEventList[sender.tag]
        
        self.editEventView.updateButton.tag = eventData.eventID
        self.listID = eventData.listID
        
        
        self.showDatePicker(textField: self.editEventView.dateTextField)
        self.showTimePicker(textField: self.editEventView.timeTextField)
        
        self.showPicker(textField: self.editEventView.setListTextField)
        
        self.addDoneButtonOnKeyboard(textField: self.editEventView.setNumberOfPeopleTextfield)
        
        self.editEventView.iWillPayButton.addTarget(self, action: #selector(self.radioButtonTapped(sender:)), for: UIControlEvents.touchUpInside)
        self.editEventView.youWillPayButton.addTarget(self, action: #selector(self.radioButtonTapped(sender:)), for: UIControlEvents.touchUpInside)
        self.editEventView.allButton.addTarget(self, action: #selector(self.radioButtonTapped(sender:)), for: UIControlEvents.touchUpInside)
        
        self.editEventView.backButton.isHidden = false
        self.editEventView.backButton.addTarget(self, action: #selector(self.backButtonTapped), for: UIControlEvents.touchUpInside)
        
        self.editEventView.updateButton.addTarget(self, action: #selector(self.updateButtonTapped(sender:)), for: UIControlEvents.touchUpInside)
        
        self.editEventView.updateButtonView.isHidden = false
        self.editEventView.createButtonView.isHidden = true
        
        
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        let dateString = eventData.eventTime
        let date = formatter1.date(from: eventData.eventTime)
        
        formatter1.dateStyle = .medium
        formatter1.timeStyle = .short
        
        formatter1.dateFormat = "dd/MM/yyyy"

        let formatter2 = DateFormatter()
        formatter2.dateFormat = "yyyy-MM-dd HH:mm:ss"

//        let timeString = eventData.eventTime.components(separatedBy: " ")[1
        let time = formatter2.date(from: eventData.eventTime)

        formatter2.dateFormat = "hh:mm a"
        
        self.editEventView.titleTextField.text = eventData.title
        self.editEventView.timeTextField.text = formatter2.string(from: time!)
        self.editEventView.dateTextField.text = formatter1.string(from: date!)
        self.editEventView.locationTextField.text = eventData.eventAddress
        self.editEventView.setNumberOfPeopleTextfield.text = String(eventData.maximumNumberOfPeople)
        self.editEventView.setListTextField.text = eventData.listName
        
        self.selectedLat = eventData.lat
        self.selectedLong = eventData.long
        
        UserDefaults.standard.removeObject(forKey: kSelectedLat)
        UserDefaults.standard.removeObject(forKey: kSelectedLong)
        UserDefaults.standard.synchronize()
        
        
        
        if eventData.paymentMethod == 1
        {
            self.editEventView.iWillPayButton.isSelected = true
            self.editEventView.youWillPayButton.isSelected = false
            self.editEventView.allButton.isSelected = false
        }
        else if eventData.paymentMethod == 2
        {
            self.editEventView.iWillPayButton.isSelected = false
            self.editEventView.youWillPayButton.isSelected = true
            self.editEventView.allButton.isSelected = false
        }
        else
        {
            self.editEventView.iWillPayButton.isSelected = false
            self.editEventView.youWillPayButton.isSelected = false
            self.editEventView.allButton.isSelected = true
        }
        
        self.yourEventsView.addSubview(self.editEventView)
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
        
        if self.receivedEventDetailView != nil
        {
            self.receivedEventDetailView.removeFromSuperview()
        }
        
    }
    @objc func startNavigationButtonTapped(sender:UIButton)
    {
//        self.isStartNavigationButtonTapped = true
//
        let toLat = self.requestEventList[sender.tag].lat
        let toLong = self.requestEventList[sender.tag].long
//
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let routeVC : RouteVC = storyboard.instantiateViewController(withIdentifier: "RouteVC") as! RouteVC
//        routeVC.originLocationCoordinate = self.currentLocationCoordinate
//        routeVC.destinationLocationCoordinate = CLLocationCoordinate2D.init(latitude: Double(toLat)!, longitude: Double(toLong)!)
//
//        BasicFunctions.pushVCinNCwithObject(vc: routeVC, popTop: false)
        
        // if GoogleMap installed
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            UIApplication.shared.openURL(NSURL(string:
                "comgooglemaps://?saddr=\(self.currentLocationCoordinate.latitude),\(self.currentLocationCoordinate.longitude)&daddr=\(toLat),\(toLong)&directionsmode=driving")! as URL)

        } else {
            // if GoogleMap App is not installed
            UIApplication.shared.openURL(NSURL(string:
                "https://www.google.co.in/maps/dir/?saddr=\(self.currentLocationCoordinate.latitude),\(self.currentLocationCoordinate.longitude)&daddr=\(self.locationCoordinate?.latitude),\(self.locationCoordinate?.longitude)&directionsmode=driving")! as URL)
        }
        
    }
    @objc func deleteButtonTapped(sender:UIButton)
    {
        BasicFunctions.showActivityIndicator(vu: self.view)
        
        let eventdata = self.userEventList[sender.tag]
        
        var postParams = [String : Any]()
        postParams["event_id"] = eventdata.eventID
        
        ServerManager.deleteEvent(postParams, accessToken: BasicFunctions.getPreferences(kAccessToken) as! String) { (result) in
            
            BasicFunctions.stopActivityIndicator(vu: self.view)
            
            let json = result as! [String : Any]
            let message = json["message"] as? String
            
            
            if message != nil && message == "Unauthorized"
            {
                BasicFunctions.showAlert(vc: self, msg: "Session Expired. Please login again")
                BasicFunctions.showSigInVC()
                return
                
            }
            
            
            if json["error"] == nil && json["status"] == nil
            {
                
                
                if message != nil
                {
                    BasicFunctions.showAlert(vc: self, msg: json["message"] as! String)
                    
                    
                
                self.fetchUserEventsFromServer()
                }
            }
            else
            {
                let status = json["status"] as? String
                if status != nil
                {
                    if status == "error"
                    {
                        BasicFunctions.showAlert(vc: self, msg: json["message"] as! String)
                        return
                        
                    }
                }
                BasicFunctions.showAlert(vc: self, msg: json["message"] as! String)
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
        
        ServerManager.acceptEventRequest(postParams, accessToken: BasicFunctions.getPreferences(kAccessToken) as! String) { (result) in
            
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
                BasicFunctions.showAlert(vc: self, msg: status!)
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
            let message = json["message"] as? String
            
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
        
        ServerManager.rejectEventRequest(postParams, accessToken: BasicFunctions.getPreferences(kAccessToken) as! String) { (result) in
            
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
                BasicFunctions.showAlert(vc: self, msg: status!)
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
        BasicFunctions.showActivityIndicator(vu: self.view)
        
        
        
        ServerManager.signOut(nil, accessToken: BasicFunctions.getPreferences(kAccessToken) as! String) { (result) in
            
            
            BasicFunctions.stopActivityIndicator(vu: self.view)
            
            
            if result == nil
            {
//                let defaults = UserDefaults.standard
//                defaults.removeObject(forKey: kUserID)
//
//                defaults.synchronize()
                
//                UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
                
                BasicFunctions.setBoolPreferences(false, forkey: kIfUserLoggedIn)
                
                
//                let storyBoard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
//                let vc = storyBoard.instantiateViewController(withIdentifier: "LogInNC")
//                (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = vc
                
                BasicFunctions.showSigInVC()

            }
            else
            {
                let json = result as! [String : Any]
                BasicFunctions.showAlert(vc: self, msg: json["message"] as! String)
                
            }
            
            
            
        }
        
        
    }
    
    
    
    func getContactListFromServer()
    {
        BasicFunctions.showActivityIndicator(vu: self.view)
        
        var postParams = [String : Any]()
        postParams["user_id"] = BasicFunctions.getPreferencesForInt(kUserID)
        
        ServerManager.getContactList(postParams, accessToken: BasicFunctions.getPreferences(kAccessToken) as! String) { (result) in
            
            
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
            
            
        
        self.userList.removeAll()
        
        var contactListArray : [[String : Any]]!
        if (json["user_contact_list"] as? [[String : Any]]) != nil
        {
            
            contactListArray = json["user_contact_list"] as! [[String : Any]]
        

        for list in contactListArray {

            let userListObject = UserList()
            userListObject.name = list["list_name"] as! String
            userListObject.id = list["id"] as! Int
            
            var contactsArray : [[String : Any]]!
            if list["contacts"] as? [[String : Any]]  != nil
            {
                contactsArray = list["contacts"] as! [[String : Any]]
            }
            
            for contact in contactsArray
            {
                let contactData = ContactData()
                if contact["name"] as? String != nil
                {
                contactData.name = contact["name"] as! String
                }
                if contact["phone"] as? String != nil
                {
                contactData.phoneNumber = contact["phone"] as! String
                }
                
                
                userListObject.contactList.append(contactData)
            }
            
            self.userList.append(userListObject)
        }
        self.contactsView.contactsTableView.reloadData()
        }
        }
        else if status != nil
        {
            if status == "error"
            {
                self.userList.removeAll()
                self.contactsView.contactsTableView.reloadData()
                
            }
        }
        else
        {
            let message = json["message"] as? String
            
            if message != nil
            {
                BasicFunctions.showAlert(vc: self, msg: status as! String)
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
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.bordered, target: self, action: #selector(self.cancelClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.bordered, target: self, action: #selector(self.doneTimePicker(sender:)))
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
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.bordered, target: self, action: #selector(self.cancelClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.bordered, target: self, action: #selector(self.donedatePicker(sender:)))
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
        if (self.createEventView.titleTextField.text?.isEmpty)!
        {
            BasicFunctions.showAlert(vc: self, msg: "Please put the title of the event.")
            return
        }
        else if (self.createEventView.timeTextField.text?.isEmpty)!
        {
            BasicFunctions.showAlert(vc: self, msg: "Please select time.")
            return
        }
        else if (self.createEventView.dateTextField.text?.isEmpty)!
        {
            BasicFunctions.showAlert(vc: self, msg: "Please select date.")
            return
        }
        else if (self.createEventView.locationTextField.text?.isEmpty)!
        {
            BasicFunctions.showAlert(vc: self, msg: "Please select location.")
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
        
        
        
        
        BasicFunctions.showActivityIndicator(vu: self.view)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        let date = timeFormatter.date(from: self.createEventView.timeTextField.text!)
        
        timeFormatter.dateFormat = "HH:mm"
        let date24 = timeFormatter.string(from: date!)
        
        var postParams = [String:Any]()
        postParams["user_id"] = BasicFunctions.getPreferences(kUserID)
        postParams["title"] = self.createEventView.titleTextField.text
        postParams["event_time"] = dateFormatter.string(from: self.datePicker.date) + " " + date24 + ":00"
        postParams["payment_method"] = self.selectedButton.tag
        postParams["event_address"] = self.createEventView.locationTextField.text
        postParams["list_id"] = self.selectedList?.id
        postParams["max_invited"] = self.createEventView.setNumberOfPeopleTextfield.text
        
        let selectedLat = BasicFunctions.getPreferences(kSelectedLat)
        let selectedLong = BasicFunctions.getPreferences(kSelectedLong)
        
        if selectedLat == nil && selectedLong == nil
        {
            postParams["latitude"] = self.currentLocationCoordinate.latitude
            postParams["longitude"] = self.currentLocationCoordinate.longitude
        }
        else
        {
            postParams["latitude"] = selectedLat
            postParams["longitude"] = selectedLong
            
            
        }
        
        
        
        
        ServerManager.createEvent(postParams, accessToken: BasicFunctions.getPreferences(kAccessToken) as! String) { (result) in
            
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
                
                self.createEventView.titleTextField.text = ""
                self.createEventView.timeTextField.text = ""
                self.createEventView.dateTextField.text = ""
                self.createEventView.locationTextField.text = self.currentLocationAddress
                self.createEventView.setListTextField.text = ""
                self.createEventView.setNumberOfPeopleTextfield.text = ""
                self.createEventView.iWillPayButton.isSelected = true
                self.createEventView.youWillPayButton.isSelected = false
                self.createEventView.allButton.isSelected = false
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
    @objc func updateButtonTapped(sender : UIButton)
    {
        if (self.editEventView.titleTextField.text?.isEmpty)!
        {
            BasicFunctions.showAlert(vc: self, msg: "Please put the title of the event.")
            return
        }
        else if (self.editEventView.timeTextField.text?.isEmpty)!
        {
            BasicFunctions.showAlert(vc: self, msg: "Please select time.")
            return
        }
        else if (self.editEventView.dateTextField.text?.isEmpty)!
        {
            BasicFunctions.showAlert(vc: self, msg: "Please select date.")
            return
        }
        else if (self.editEventView.locationTextField.text?.isEmpty)!
        {
            BasicFunctions.showAlert(vc: self, msg: "Please select location.")
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
        
        
        BasicFunctions.showActivityIndicator(vu: self.view)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        let date = timeFormatter.date(from: self.editEventView.timeTextField.text!)
        
        timeFormatter.dateFormat = "HH:mm"
        let date24 = timeFormatter.string(from: date!)
        
        var postParams = [String:Any]()
        postParams["user_id"] = BasicFunctions.getPreferences(kUserID)
        postParams["title"] = self.editEventView.titleTextField.text
        postParams["event_time"] = dateFormatter.string(from: self.datePicker.date) + " " + date24 + ":00"
        postParams["payment_method"] = self.selectedButton.tag
        postParams["event_address"] = self.editEventView.locationTextField.text
        postParams["event_id"] = sender.tag
        postParams["max_invited"] = self.editEventView.setNumberOfPeopleTextfield.text
        
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
        
        if selectedLat == nil && selectedLong == nil
        {
            postParams["latitude"] = self.selectedLat
            postParams["longitude"] = self.selectedLong
        }
        else
        {
            postParams["latitude"] = selectedLat
            postParams["longitude"] = selectedLong
            
        }
        
        ServerManager.updateEvent(postParams, accessToken: BasicFunctions.getPreferences(kAccessToken) as! String) { (result) in
            
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
                
                self.editEventView.titleTextField.text = ""
                self.editEventView.timeTextField.text = ""
                self.editEventView.dateTextField.text = ""
                self.editEventView.locationTextField.text = self.currentLocationAddress
                self.editEventView.setListTextField.text = ""
                self.editEventView.setNumberOfPeopleTextfield.text = ""
                self.editEventView.iWillPayButton.isSelected = true
                self.editEventView.youWillPayButton.isSelected = false
                self.editEventView.allButton.isSelected = false
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
        
        ServerManager.getUserEvents(postParams, accessToken: BasicFunctions.getPreferences(kAccessToken) as! String) { (result) in
            
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
            eventsArray = json["user_events"] as! [[String : Any]]
            
            self.userEventList.removeAll()
            
            for event in eventsArray!
            {
            let eventData = EventData()
            eventData.eventID = event["id"] as! Int
            eventData.userID = event["user_id"] as! Int
            eventData.title = event["title"] as! String
            eventData.eventAddress = event["event_address"] as! String
            eventData.eventTime = event["event_time"] as! String
            eventData.eventCreatedTime = event["event_created_time"] as! String
            eventData.listName = event["list_name"] as! String
            eventData.listID = event["list_id"] as! Int
            eventData.totalInvited = event["list_count"] as! Int
            eventData.lat = event["latitude"] as! String
            eventData.long = event["longitude"] as! String
            eventData.paymentMethod = event["payment_method"] as! Int
            eventData.maximumNumberOfPeople = event["max_invited"] as! Int
            
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
            let message = json["message"] as? String
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
        
        ServerManager.getRequests(postParams, accessToken: BasicFunctions.getPreferences(kAccessToken) as! String) { (result) in
            
            
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
                eventsArray = json["event_requests"] as! [[String : Any]]
            
                self.requestEventList.removeAll()
            
            for event in eventsArray!
            {
                let eventData = EventData()
                eventData.eventID = event["event_id"] as! Int
                eventData.title = event["event_title"] as! String
                eventData.totalInvited = event["total"] as! Int
                eventData.createdBy = event["create_by"] as! String
                eventData.eventAddress = event["address"] as! String
                eventData.confirmed = event["confirmed"] as! Int
                eventData.eventTime = event["event_time"] as! String
                eventData.phone = event["phone"] as! String
                eventData.paymentMethod = event["payment_method"] as! Int
                
                if event["latitude"] as? String != nil
                {
                eventData.lat = event["latitude"] as! String
                }
                
                if event["longitude"] as? String != nil
                {
                eventData.long = event["longitude"] as! String
                }
                
                eventData.fullName = self.getNameFromPhoneNumber(phone: eventData.phone)
                
                self.requestEventList.append(eventData)
                
            }
            self.requestEventView.requestEventTableView.reloadData()
            
            
        }
        }
        else if status == "error"
        {
            self.requestEventList.removeAll()
            self.requestEventView.requestEventTableView.reloadData()
            
        }
        else
        {
            
            let message = json["message"] as? String
            if message != nil
            {
                BasicFunctions.showAlert(vc: self, msg: message)
            }
        }
        
        
    }
    func getNameFromPhoneNumber(phone : String) -> String
    {
        for contctData in kContactList
        {
            if contctData.phoneNumber.stringByRemovingWhitespaces == phone
            {
                return contctData.name
            }
        }
        return " "
    }
    func fetchReceivedRequestsFromServer()
    {
        BasicFunctions.showActivityIndicator(vu: self.view)
        
        var postParams = [String:Any]()
        postParams["created_by"] = BasicFunctions.getPreferences(kUserID)
        
        ServerManager.getReceivedRequests(postParams, accessToken: BasicFunctions.getPreferences(kAccessToken) as! String) { (result) in
            
            
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
            if json["Received Requests"] as? [[String : Any]] != nil
            {
                eventsArray = json["Received Requests"] as! [[String : Any]]
                
                self.receivedRequestEventList.removeAll()
                
                for event in eventsArray!
                {
                    let eventData = EventData()
                    eventData.eventID = event["event_id"] as! Int
                    eventData.title = event["title"] as! String
                    eventData.eventTime = event["event_time"] as! String
//                    eventData.createdBy = event["create_by"] as! String
//                    eventData.eventAddress = event["address"] as! String
                    eventData.confirmed = event["confirmed"] as! Int
                    eventData.phone = event["phone"] as! String
                    
                    if event["firstName"] as? String != nil
                    {
                    eventData.firstName = event["firstName"] as! String
                    }
                    
                    if event["lastName"] as? String != nil
                    {
                    eventData.lastName = event["lastName"] as! String
                    }
                    
                    eventData.fullName = self.getNameFromPhoneNumber(phone: eventData.phone)
                    
                    self.receivedRequestEventList.append(eventData)
                    
                }
                self.receivedEventsView.receivedEventsTableView.reloadData()
                
                
            }
        }
        else if status == "error"
        {
            self.receivedRequestEventList.removeAll()
            self.receivedEventsView.receivedEventsTableView.reloadData()
            
        }
        else
        {
            let status = json["status"] as? String
            if status != nil
            {
                if status == "error"
                {
                    BasicFunctions.showAlert(vc: self, msg: json["message"] as! String)
                    return
                    
                }
            }
            BasicFunctions.showAlert(vc: self, msg: json["message"] as! String)
        }
    }
    
        
        
    func updateDeviceToken()
    {
        BasicFunctions.showActivityIndicator(vu: self.view)
        
        var postParams = [String:Any]()
        postParams["user_id"] = BasicFunctions.getPreferences(kUserID)
        postParams["device_token"] = BasicFunctions.getPreferences(kDeviceToken)
        postParams["platform"] = "ios"
        
        ServerManager.updateDeviceToken(postParams, accessToken: BasicFunctions.getPreferences(kAccessToken) as! String) { (result) in
            
            
            BasicFunctions.stopActivityIndicator(vu: self.view)
            
            let json = result as? [String : Any]
            
            let message = json!["message"] as? String
            
            if message != nil && message == "Unauthorized"
            {
                BasicFunctions.showAlert(vc: self, msg: "Session Expired. Please login again")
                BasicFunctions.showSigInVC()
                return
                
            }
            
            
        }
        
    }
    func deleteList(index : Int!)
    {
        BasicFunctions.showActivityIndicator(vu: self.view)
        
        var postParams = [String:Any]()
        postParams["list_id"] = index
        
        
        ServerManager.deleteList(postParams, accessToken: BasicFunctions.getPreferences(kAccessToken) as! String) { (result) in
            
            
            BasicFunctions.stopActivityIndicator(vu: self.view)
            
            let json = result as! [String : Any]
            let message = json["message"] as? String
            
            if message != nil && message == "Unauthorized"
            {
                BasicFunctions.showAlert(vc: self, msg: "Session Expired. Please login again")
                BasicFunctions.showSigInVC()
                return
                
            }
            
            
            if json["error"] == nil && json["status"] == nil
            {
                self.getContactListFromServer()
            }
            else
            {
                let status = json["status"] as? String
                if status != nil
                {
                    if status == "error"
                    {
                        BasicFunctions.showAlert(vc: self, msg: json["message"] as! String)
                        return
                        
                    }
                }
                
                BasicFunctions.showAlert(vc: self, msg: json["message"] as! String)
                
            }
            
            
        }
        
    }
    
    
    
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
            let row = self.userList.index(where: {$0.id == self.listID})
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

        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.bordered, target: self, action: #selector(self.cancelClick))

        toolbar.setItems([spaceButton,doneButton], animated: false)


        // add toolbar to textField
        textField.inputAccessoryView = toolbar
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
