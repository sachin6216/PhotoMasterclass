//
//  Connectivity.swift
//  PhotoMasterclass
//
//  Created by Sachin on 27/03/23.
//

import Foundation
import Reachability

public class Connectivity  {
    public static let shared = Connectivity()
    public init(){}
    
    //MARK:- CHECKING INTERNET CONNECTIVITY
    class public var isConnectedToInternet:Bool {
        var internet = false
        let reachability = try! Reachability()
        if reachability.connection != .unavailable {
            internet = true
        }
        else{
            internet = false
        }
        return internet
    }
}
