//
//  ChatController.swift
//  MessangerSwiftUi
//
//  Created by User on 21/08/2020.
//  Copyright © 2020 User. All rights reserved.
//

import Combine
import SwiftUI

class ChatController : ObservableObject {
    
    var didChange = PassthroughSubject<Void, Never>()
    
    @Published var messages = [ChatMessage]()
    
    func sendMessage(_ chatMessage: ChatMessage) {
        messages.append(chatMessage)
        didChange.send(())
        
    }
    
    func boxoffice() {
        converesction()
        didChange.send(())
    }
    
    func converesction() {
        let parameters = ["token": "dac5f4e6b1ba0e81cb6e1a73934d6ebf","conv_id":"200525093518"]
        
        guard let url = URL(string: "http://appvelo.com/conference_app/messages/conversations") else { return }
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                DispatchQueue.main.async {
                    do {
                        let parsedData = try JSONSerialization.jsonObject(with: data) as! [String:Any]
                        let currentConditions = parsedData["data"] as! [[String:Any]]
                        
                        print(currentConditions)
                        self.messages.removeAll()
                        for result in currentConditions {
                            let msg = result["msg"] as! String
                            self.messages.append(ChatMessage(message: msg, avatar: "man", color: .blue, isMe: true))
                            
                            self.messages.append(ChatMessage(message: msg, avatar: "lady", color: .gray, isMe: false))
                            
                        }
                        
                        
                    } catch {
                        print(error)
                    }
                    return
                    
                }
                
            }
        }.resume()
        
        DispatchQueue.main.async {
            self.boxoffice()
        }
    }
}
