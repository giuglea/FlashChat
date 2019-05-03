//
//  ChatVC.swift
//  MFlashChat
//
//  Created by Andrei Giuglea on 30/04/2019.
//  Copyright © 2019 Andrei Giuglea. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework



class ChatViewController: UIViewController,UITableViewDelegate,UITableViewDataSource ,UITextFieldDelegate {
    
    

    
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    var messageArray : [Message] = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        messageTextfield.delegate = self
        
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
            messageTableView.addGestureRecognizer(tapGesture)
        

        
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        configureTable()
        retreiveMessages()
        
        messageTableView.separatorStyle = .none
        
    }

    
    //MARK: - TableView DataSource Methods
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        //let messageArray = ["First mes","Second mes","Third mes"]
   
        cell.messageBody.text = messageArray[indexPath.row].messageBody
        cell.senderUsername.text = messageArray[indexPath.row].sender
        
        cell.avatarImageView.image = UIImage(named: "egg")
        
        if cell.senderUsername.text == Auth.auth().currentUser?.email as! String {
                
            cell.avatarImageView.backgroundColor = UIColor.flatMint()
            cell.messageBackground.backgroundColor = UIColor.flatSkyBlue()
            
        }
        else{
            
            cell.avatarImageView.backgroundColor = UIColor.flatWatermelon()
            cell.messageBackground.backgroundColor = UIColor.flatWatermelonColorDark()
        }
        
        return cell
    
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    

    @objc func tableViewTapped(){
        messageTextfield.endEditing(true)
    }
    
    
 
    func configureTable(){
        messageTableView.rowHeight = UITableView.automaticDimension
        messageTableView.estimatedRowHeight = 120.0
    }
    
    
    //MARK:- TextField Delegate Methods
    
    
    //TODO: Declare textFieldDidBeginEditing here:
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 308
             self.view.layoutIfNeeded()
        }
    }
    
    
    
    //TODO: Declare textFieldDidEndEditing here:
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.7) {
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
    }

    
    ///////////////////////////////////////////
    
    
    //MARK: - Send & Recieve from Firebase
    
    
    
    @IBAction func sendPressed(_ sender: AnyObject) {
        
        
        //TODO: Send the message to Firebase and save it in our database
        messageTextfield.endEditing(true)
        messageTextfield.isEnabled = false
        sendButton.isEnabled = false
        
        let messagesDB =  Database.database().reference().child("Messages")
        let messagesList = messagesDB.child("yey")
        
        let messageDictionary = ["Sender":Auth.auth().currentUser?.email , "MessageBody":messageTextfield.text!]
        
        messagesList.childByAutoId().setValue(messageDictionary){
            (error,reference) in
            if error != nil  {
                print(error)
            }
            else{
                print("Message saved successfully! ")
                
                self.messageTextfield.isEnabled = true
                self.sendButton.isEnabled = true
                self.messageTextfield.text = ""
            }
        }
        
    }
    

    func retreiveMessages(){
        
        let messageDB = Database.database().reference().child("Messages")
        let messageList = messageDB.child("yey")
        messageList.observe(.childAdded, with:{ (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            let text = snapshotValue["MessageBody"]!
            let sender = snapshotValue["Sender"]!
            
            let message = Message()
            message.messageBody = text
            message.sender = sender
            
            self.messageArray.append(message)
            
            self.configureTable()
            self.messageTableView.reloadData()
            
        })
    }
    
    

    
    
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        
       
        do{
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        }catch{
            print(error)
        }
        
    }
    


}


