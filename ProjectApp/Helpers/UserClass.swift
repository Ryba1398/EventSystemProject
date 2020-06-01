//
//  UserClass.swift
//  ProjectApp
//
//  Created by Николай Рыбин on 15.04.2020.
//  Copyright © 2020 Николай Рыбин. All rights reserved.
//


import Foundation


struct AuthInfo: Codable {
    
    var status: Bool?
    var login: String?
    var password: String?
    var token: String?
    var deathTime: Double?
    
    init( status: Bool, login: String, password: String, token: String, deathTime: Double?) {
        self.status = status
        self.login = login
        self.password = password
        self.token = token
        self.deathTime = deathTime
    }
}



struct User{
    
    var name: String?
    var surName: String?
    
    var mail: String?
    var login: String?
    var password: String?
    
    init(name: String, surName: String, mail: String, login: String, password: String) {
        self.name = name
        self.surName = surName
        self.mail = mail
        self.login = login
        self.password = password
    }
}


enum Requests {
    case events
    case event(Int)
    case person(String)
}

struct AuthResponse: Codable {
    let accessToken: String
    let expiresIn: Int
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
    }
}


struct RequestInfo{
    
    static let adress = "https://event-admin.tapir.ws/api/"
    static let member = "event-members/"
    static let events = "events"
    static let event  = "events/"
    
    static func getAdress(type: Requests) -> String {
        
        switch type {
        case .events:
            return adress + events
        case .event(let id):
            return adress + event + String(id)
        case .person(let uuid):
            return adress + member + uuid
        default:
            return  ""
        }        
    }
    
    
    
    static var header  = ["AccessToken": ""]
    
    static func getHeader() -> [String: String] {
        return header
    }
    
}


//---------------------------------

struct Events: Codable {
    let data: [Event]
}

struct Event: Codable {
    let id: Int
    let title, location: String
    let peopleCapacity: Int?
    let registrationType, status: String
    let startsAt, endsAt: Double
    
    let registrationTypeValues = ["anyone": "Свободная регистрация", "moderation": "Регистрация с ручной модерацией"]
    
    func getRegistrationType() -> String {
        return registrationTypeValues[registrationType] ?? ""
    }
    
    let eventStatusValues = ["registration_opened": "Регистрация открыта", "registration_closed": "Регистрация закрыта", "in_progress": "В процессе", "finished": "Завершено", "archive": "Архив"]
    
    func getEventStatus() -> String {
        return eventStatusValues[status] ?? ""
    }
    
    enum CodingKeys: String, CodingKey {
        case id, title, location
        case peopleCapacity = "people_capacity"
        case registrationType = "registration_type"
        case status
        case startsAt = "starts_at"
        case endsAt = "ends_at"
    }
}

//--------------------------------

struct EventInfo: Codable {
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let event: Event
    let rooms: [Room]?
    let memberRoles: [MemberRole]?
    
    enum CodingKeys: String, CodingKey {
        case event, rooms
        case memberRoles = "member_roles"
    }
}

// MARK: - MemberRole
struct MemberRole: Codable {
    let id: Int
    let name, roomsAvailable: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case roomsAvailable = "rooms_available"
    }
}

// MARK: - Room
struct Room: Codable {
    let id: Int
    let name: String
    let roomDescription: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case roomDescription = "description"
    }
}

//------------------------------------------------


// MARK: - Welcome
struct Guest: Codable {
    let data: GuestInfo
}

// MARK: - DataClass
struct GuestInfo: Codable {
    let member: Member
    let role: Role
}

// MARK: - Member
struct Member: Codable {
    let uuid: String
    let registeredAt: Int
    let firstName, lastName, sex, phone: String
    let email: String
    
    enum CodingKeys: String, CodingKey {
        case uuid
        case registeredAt = "registered_at"
        case firstName = "first_name"
        case lastName = "last_name"
        case sex, phone, email
    }
}

// MARK: - Role
struct Role: Codable {
    let id: Int
    let name, roomsAvailable: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case roomsAvailable = "rooms_available"
    }
}
