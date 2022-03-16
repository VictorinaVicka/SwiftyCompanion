//
//  User.swift
//   SwiftyCompanion
//
//  Created by Виктория Воробьева on 27.01.2022.
//

import SwiftUI

struct User: Codable {
    let login, email, image_url, displayname: String
    let pool_month, pool_year: String?
    let correction_point: Int?
    let wallet: Int
    let campus: [Campus]
    let cursus_users: [CursusUser]
    let projects_users: [ProjectsUser]
    let achievements: [Achievements]
    
    func getImage(token: Token?) -> Image? {
        let group = DispatchGroup()
        var image: Image?

        if token == nil {
            guard let pathString = Bundle.main.path(forResource: "user", ofType: "jpg") else {
                fatalError("login.jpg not found")
            }
            image = Image(uiImage: UIImage(named: pathString)!)

        } else {
            let url = URL(string: image_url)!
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(token!.access_token)", forHTTPHeaderField: "Authorization")
            
            group.enter()
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                    group.leave()
                    return
                }
                image = Image(uiImage: UIImage(data: data)!)
                group.leave()
            }.resume()
            group.wait()
        }
        return image
    }
}

struct Campus: Codable, Identifiable {
    let id: Int
    let city, country: String
    let active: Bool
}

struct CursusUser: Codable, Identifiable {
    let id: Int
    let level: Float
    let skills: [Skills]
    let cursus: Cursus
}

struct Skills: Codable, Identifiable {
    var id: Int
    let name: String
    let level: Float
}

struct Cursus: Codable {
    let id: Int
    let name: String
}

struct ProjectsUser: Codable, Identifiable {
    let id: Int
    let finalMark: Int?
    let status: String
    let validated: Bool?
    let project: Project
    let cursusIDS: [Int]

    enum CodingKeys: String, CodingKey {
        case id
        case finalMark = "final_mark"
        case status
        case validated = "validated?"
        case project
        case cursusIDS = "cursus_ids"
    }

    func getColor() -> Color {
        if self.validated == true {
            return Color.green
        } else {
            return Color.red
        }
    }
}

struct Achievements: Codable, Identifiable {
    let id: Int
    let name, description: String
}

struct Project: Codable {
    let name: String
}

func getTestUser(login: String) -> User? {
    guard let pathString = Bundle.main.path(forResource: login, ofType: "json") else { return nil }
    guard let jsonString = try? String(contentsOfFile: pathString, encoding: .utf8) else { return nil }
    guard let jsonData = jsonString.data(using: .utf8) else { return nil }
    guard let jsonDictionary = try? JSONDecoder().decode(User.self, from: jsonData) else { return nil }
    return jsonDictionary
}

