//
//  ContentView.swift
//  MessangerSwiftUi
//
//  Created by User on 21/08/2020.
//  Copyright © 2020 User. All rights reserved.
//

import SwiftUI

struct ChatMessage : Hashable {
    var id: String = UUID().uuidString
    var message: String
    var avatar: String
    var color: Color
    var isMe: Bool = false
}

struct ContentView : View {
    
    @State var composedMessage: String = ""
    @EnvironmentObject var chatController: ChatController
    
    var body: some View {
        
        VStack {
            
            List {
                ForEach(chatController.messages, id: \.self) { msg in
                    ChatRow(chatMessage: msg)
                }
            }.onAppear {
                self.chatController.boxoffice()
                UITableView.appearance().separatorStyle = .none
            }.onDisappear {
                UITableView.appearance().separatorStyle = .singleLine
            }
            HStack {
                TextField("Message...", text: $composedMessage).frame(minHeight: CGFloat(30)).textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: sendMessage) {
                    Text("Send")
                }
            }.frame(minHeight: CGFloat(50)).padding()
        }
    }
    func sendMessage() {
        chatController.sendMessage(ChatMessage(message: composedMessage, avatar: "man", color: .blue, isMe: true))
        composedMessage = ""
    }
}
struct ChatRow : View {
    var chatMessage: ChatMessage
    var body: some View {
        Group {
            if !chatMessage.isMe {
                HStack {
                    Group {
                        Image(chatMessage.avatar).resizable()
                            .frame(width: 50, height: 50, alignment: .center)
                            .cornerRadius(20)
                        .overlay(Circle().stroke(Color.white, lineWidth: 5))
                        
                        Text(chatMessage.message)
                            .padding(10)
                            .foregroundColor(Color.white)
                            .background(chatMessage.color)
                            .cornerRadius(10)
                    }
                }
            } else {
                HStack {
                    Group {
                        Spacer()
                        Text(chatMessage.message)
                            .bold()
                            .foregroundColor(Color.white)
                            .padding(10)
                            .background(chatMessage.color)
                            .cornerRadius(10)
                        Image(chatMessage.avatar).resizable()
                            .frame(width: 50, height: 50, alignment: .center)
                            .cornerRadius(20)
                            .overlay(Circle().stroke(Color.white, lineWidth: 5))
                    }
                }
            }
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ChatController())
    }
}
#endif
