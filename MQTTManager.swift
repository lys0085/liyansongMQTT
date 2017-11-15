//
//  MQTTManager.swift
//  Bracelet
//
//  Created by liyansong on 2017/7/21.
//  Copyright © 2017年 admin. All rights reserved.
//

import UIKit
import CocoaMQTT
class MQTTManager: NSObject ,CocoaMQTTDelegate{
    
    static let share = MQTTManager()
    
    var mqtt:CocoaMQTT?
    var username:String?
    var password:String?
    var host:String?
    var port:UInt16?
    var clientIdPid = ""
    override init() {
        super.init()
    }
    
    func subscribe(topic:String)  {
        let topicString = String.init(format: "%@/%@%@/+", RootTopic,topic,funcTopic)
        print(topicString)
        mqtt?.subscribe(topicString, qos: CocoaMQTTQOS.qos0)
        mqtt?.subscribe(topicString+"/"+HRHighTopic, qos: CocoaMQTTQOS.qos0)
    }
    
    func unsubscribe(topic:String)  {
        let topicString = String.init(format: "%@/%@%@/+", RootTopic,topic,funcTopic)
        mqtt?.unsubscribe(topicString)
        mqtt?.unsubscribe(topicString+"/"+HRHighTopic)
    }
    
    
    func connect(username:String,password:String,host:String,port:UInt16)  {
        self.username = username
        self.password = password
        self.host = host
        self.port = port
        if mqtt!.connState != .connected {
            if let ID = UserDefaults.standard.string(forKey: "clientId" + username) {
                clientIdPid = ID
            } else {
                clientIdPid  = username + "_" + String(ProcessInfo().processIdentifier)
                UserDefaults.standard.set(clientIdPid, forKey: "clientId" + username)
            }
            print("clientId")
            print(clientIdPid)
            mqtt = CocoaMQTT(clientID: clientIdPid, host: host, port: port)
            if let mqtt = mqtt {
                mqtt.username = username
                mqtt.password = password
                //          mqtt.willMessage = CocoaMQTTWill(topic:"v1.0/regist/57bec7e6cc96586442651585/12345", message:"did")
                mqtt.keepAlive = 30
                mqtt.delegate = self
                mqtt.autoReconnect = true
                mqtt.autoReconnectTimeInterval = 10
                mqtt.connect()
            }
        }
    }
    
    func publish(topic:String,paramet:NSMutableDictionary)  {
        
        //        let dis = ["name":"lxs","HR":99] as [String : Any]
        let data : NSData! = try? JSONSerialization.data(withJSONObject: paramet, options: []) as NSData!
        //                MQTTManager.share.publish(topic: "car", data: String(data:data as Data,encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!)
        
        let topicString = String.init(format: "%@/%@%@/%@", RootTopic,username!,funcTopic,topic)
        print(topicString)
        mqtt?.publish(topicString, withString: String(data:data as Data,encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, qos: CocoaMQTTQOS.qos0, retained: false, dup: false)
    }
    
    func disconnect()  {
        mqtt?.disconnect()
    }
    
    
    func mqtt(mqtt: CocoaMQTT, didConnect host: String, port: Int) {
        print("didConnect \(host):\(port)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: MQTTReconnect), object: self,
                                        userInfo: nil)
        print("didConnectAck")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
        
        print("didReceiveMessage")
        print(message.topic)
        
        if message.topic.components(separatedBy: "/").count >= 6 && message.topic.components(separatedBy: "/")[5] == HRHighTopic{
            alertNF(message: message)
        } else if message.topic.components(separatedBy: "/").count > 2{
            nomalNF(message: message)
        } else {
            return
        }
        
    }
    
    func nomalNF(message: CocoaMQTTMessage)  {
//        let user:ConcernUser = ConcernUser()
//        user.userNo = message.topic.components(separatedBy: "/")[2]
//        let jsonData:Data = message.string!.data(using: .utf8)!
//        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as! NSDictionary
//
//        if dict != nil {
//            if let heartRate = dict!["heartRate"]{
//                user.HR = heartRate as? Int
//            }
//        }else {
//            return
//        }
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NFHRMessage), object: self,
//                                        userInfo: ["data":user])
    }
    
    func alertNF(message: CocoaMQTTMessage)  {
//        let user:ConcernUser = ConcernUser()
//        user.userNo = message.topic.components(separatedBy: "/")[2]
//        let jsonData:Data = message.string!.data(using: .utf8)!
//        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as! NSDictionary
//        if dict != nil {
//            if let heartRate = dict!["heartRate"]{
//                user.HR = heartRate as? Int
//            }
//            for item in dict!.allKeys {
//                if (item as? String)?.substring(to: String.Index.init(encodedOffset: 1)) == "M" {
//                    user.HRCode = item as? String
//                    break
//                }
//            }
//            user.HRCodeMessage = dict!.value(forKey: user.HRCode!) as? String
//        }else {
//            return
//        }
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NFALARTHRMessage), object: self,
//                                        userInfo: ["data":user])
        
    }
    
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishComplete id: UInt16) {
        print("didPublishComplete")
    }
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        print("didPublishMessage")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        print("didPublishAck")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topic: String) {
        print("didSubscribeTopic")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
        print("didUnsubscribeTopic")
    }
    
    func mqttDidPing(_ mqtt: CocoaMQTT) {
        print("mqttDidPing")
    }
    
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
        print("mqttDidReceivePong")
    }
    
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        print("mqttDidDisconnect")
    }
    
    
}

