//
//  globalClasses.swift
//  guiApp
//
//  Created by Leo on 14.08.2023.
//

import SwiftUI

///Retrieve Requests Classess
//Classes that are going to be used to retrieve requestss
class Team: Codable {
    var id: Int
    var name: String
    var nodeID: String
}

class Account: Codable {
    var id: String?
    var name: String?
}

class Member: Codable {
    var id: Int
    var name: String
    var account: Account?
    var nodeID: String
}

class ServiceInstance: Codable {
    var id: Int
    var name: String
    var localized_name: String?
    var nodeID: String
}

class Request: Codable{
    var id: Int
    var sourceID: String?
    var subject: String
    var category: String
    var impact: String?
    var status: String?
    var next_target_at: String?
    var completed_at: String?
    var team: Team?
    var member: Member?
    var grouped_into: String?
    var service_instance: ServiceInstance?
    var created_at: String?
    var updated_at: String?
    var nodeID: String?
}
