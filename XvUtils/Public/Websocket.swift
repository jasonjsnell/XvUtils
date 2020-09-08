//
//  Websocket.swift
//  XvUtils
//
//  Created by Jason Snell on 8/26/20.
//  Copyright © 2020 Jason J. Snell. All rights reserved.
//

import Foundation

//another object that can listen to this class's updates
public protocol WebSocketObserver:class {
    
    func didConnect()
    func didDisconnect()
    func didReceivePing()
    func didThrowPingError()
    func didReceive(json:[String:Any])
    func didReceive(text:String)
    func didReceive(data:Data)
    
}

/*
 Example:
 
 let ws:WebSocket = WebSocket()
 ws.observer = self
 ws.debug = true
 ws.setup(with: "wss://echo.websocket.org", pingInterval: 1.0)
 ws.connect()
 ws.startPing()
 
 */

public class WebSocket:NSObject, URLSessionWebSocketDelegate {
    
    
    //MARK: - Vars
    //the class that receives updates
    public weak var observer:WebSocketObserver?
    
    //to see pings and messages
    public var debug:Bool = true
    
    //socket task
    fileprivate var webSocketTask:URLSessionWebSocketTask?
    
    fileprivate var pingInterval:TimeInterval = 5.0
    

    //MARK: - Init
    
    public func setup(urlString:String, pingInterval:TimeInterval = 5.0) {
        
        //create the websocket session on the operation queue
        let urlSession:URLSession = URLSession(
            configuration: .default,
            delegate: self,
            delegateQueue: OperationQueue()
        )
    
        //create a url
        if let url:URL = URL(string: urlString) {
            
            //init the socket task
            webSocketTask = urlSession.webSocketTask(with: url)
            
        } else {
            print("WebSocket: Error: Unable to create URL from", urlString)
        }
        
        self.pingInterval = pingInterval
    }
    
    //MARK: - URLSessionWebSocketDelegate methods
    public func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        
        if (debug) { print("WebSocket: Connect") }
        
        observer?.didConnect()
        
    }
    
    public func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        
        if (debug) { print("WebSocket: Disconnect") }
        
        observer?.didDisconnect()
    }
    
    
    
    //MARK: - Connection
    public func connect(){
        
        if (webSocketTask != nil) {
        
            webSocketTask!.resume()
        
        } else {
            if (debug) { print("WebSocket: Error: webSocketTask is nil in connect()") }
        }
    }
    
    public func disconnect() {
        
        if (webSocketTask != nil) {
            
            //reason desc text
            let reason:Data? = "Closing connection".data(using: .utf8)
            
            //cancel connection
            webSocketTask!.cancel(with: .goingAway, reason: reason)
        
        } else {
            if (debug) { print("WebSocket: Error: webSocketTask is nil in disconnect()") }
        }
    }
    
    //MARK: - Ping
    public func startPing(){
        ping()
    }
    
    //tests the server connection by sending in a ping
    fileprivate func ping() {
        
        if (webSocketTask != nil) {
            
            webSocketTask!.sendPing { error in
                
                if let error:Error = error {
                    
                    print("WebSocket: Ping error: \(error)")
                    self.observer?.didThrowPingError()
                    
                    //try to reconnect
                    self.connect()
                    
                } else {
                    
                    //if (self.debug) { print("WebSocket: Ping") }
                    self.observer?.didReceivePing()
                    
                    DispatchQueue.global().asyncAfter(deadline: .now() + self.pingInterval) {
                        self.ping()
                    }
                }
            }
            
        } else {
            print("WebSocket: Error: webSocketTask is nil in ping()")
        }
        
    }
    
    //MARK: - Send
    public func send(text:String) {
        
        if (webSocketTask != nil) {
        
            webSocketTask!.send(.string(text)) { error in
                
                if let error:Error = error {
                    print("WebSocket: Error when sending: \(text)")
                    print("WebSocket: Send error: \(error)")
                }
            }
            
        } else {
            print("WebSocket: Error: webSocketTask is nil in send()")
        }
    }
    
    public func send(json:[String:Any]){
        if let jsonStr:String = JSON.getString(fromJSON: json) {
            send(text: jsonStr)
        } else {
            print("Websocket: Error: Unable to convery JSON to string")
            print("Websocket: Error: JSON input:", json)
        }
    }
    
    
    //MARK: - Receive
    
    public func startReceiving(){
        
        //begins receive loop
        receive()
    }
    
    fileprivate func receive() {
        
        if (webSocketTask != nil) {
            
            webSocketTask!.receive { result in
                
                switch result {
                
                case .success(let message):
                     
                    switch message {
                     
                    case .data(let data):
                       
                        if (self.debug) { print("WebSocket: Data received: \(data)") }
                        self.observer?.didReceive(data: data)
                     
                    case .string(let text):
                    
                        print("WebSocket: Received text")
                        self._processReceived(text: text)
                     
                    @unknown default:
                        
                        print("WebSocket: Error: Unknown received in receive()")
                    }
                    
                   
                case .failure(let error):
                   
                    print("Error when receiving \(error)")
                }
                   
                self.receive()
            }
            
        } else {
            print("WebSocket: Error: webSocketTask is nil in receive()")
        }
    }
    
    //sees if incoming text is JSON format or text
    fileprivate func _processReceived(text:String) {
        
        //try converting text to JSON format
        if let json:[String:Any] = JSON.getJSON(fromStr: text){
            
            observer?.didReceive(json: json)
        
        }  else {
            //else send as text
            observer?.didReceive(text: text)
        }
    }
}
