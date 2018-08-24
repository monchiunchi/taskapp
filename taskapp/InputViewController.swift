//
//  InputViewController.swift
//  taskapp
//
//  Created by tetsuro miyagawa on 2018/08/20.
//  Copyright © 2018年 tetsuro miyagawa. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class InputViewController: UIViewController {

    
    @IBOutlet weak var titleTextView: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var dateView: UIDatePicker!
    
    var task: Task!
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGes: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGes) //viewは定義してない
        
        titleTextView.text = task.title
        textView.text = task.contents
        dateView.date = task.date
        
    }

    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        try! realm.write {
            self.task.title = self.titleTextView.text!//optional?
            self.task.contents = self.textView.text
            self.task.date = self.dateView.date
            self.realm.add(self.task, update: true)//追加.add
        }
        setNotification(task: task) //通知メソッド↓
        
        super.viewWillDisappear(animated)
    }
    
    func setNotification(task: Task) {
        
        let content = UNMutableNotificationContent()
        if task.title == "" {
            content.title = "(タイトルなし)"
        }else{
            content.title = task.title
        }
        
        if task.contents == "" {
            content.body = "(内容なし)"
        }else{
            content.body = task.contents
        }
        content.sound = UNNotificationSound.default()
        
        let calender = Calendar.current
        let dateComponents = calender.dateComponents([.year, .month, .day, .hour, .minute], from: task.date)
        //= Calender.current.dateComponents
        
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest.init(identifier: String(task.id), content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request){
            (error) in print(error ?? "ローカル通知登録OK") //inはクロージャ？
        }
        center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
            for request in requests {
                print("/---------------")
                print(request)
                print("---------------/")
            }
        }
    }
            
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //safeareaとview、constraint
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
