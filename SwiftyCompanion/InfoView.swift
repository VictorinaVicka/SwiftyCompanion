//
//  InfoView.swift
//   SwiftyCompanion
//
//  Created by Виктория Воробьева on 27.01.2022.
//

import SwiftUI

struct InfoView: View {
    let login: String
    @Binding var tokenAuthorization: TokenAuthorization

    var body: some View {
        if let token = tokenAuthorization.token {
            if let user = tokenAuthorization.getUser(login: login) {
                proceed(user: user, login: login, token: token)
            } else {
                Text("No such user, try another one.")
            }
        } else {
            if let user = getTestUser(login: login) {
                proceed(user: user, login: login, token: nil)
            } else {
                Text("No such user, try another one.")
            }
        }
    }
}

struct proceed: View {
    let user: User
    let login: String
    let token: Token?
    
    var body: some View {
        List {
            HStack {
            user.getImage(token: token)?
                .frame(width: 150, height: 150, alignment: .center)
                Spacer()
                Text("\(user.displayname)")
                    .font(.system(size: 18, design: .rounded))
            }
            showUser(user: user)
            showSkills(user: user)
            showAchievements(user: user)
            
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle(Text(login))
    }
}

struct showUser: View {
    let user: User

    var body: some View {
        Section(header: VStack {
            Text("Student information").font(customHeadline())
        }) {
            HStack(spacing: 100) {
                Text("Email")
                Text(user.email)
            }
            
            let activeCampus = user.campus.filter { $0.active == true }
            ForEach(activeCampus) { campus in
                HStack(spacing: 80) {
                    Text("Campus")
                    Text(" \(campus.city), \(campus.country)")
                    }
                }
            HStack(spacing: 95) {
                Text("Piscine")
                Text("\(user.pool_month ?? "") \(user.pool_year ?? "")")
            }
            HStack(spacing: 100) {
                Text("Wallet")
                Text("\(user.wallet)")
            }
            HStack(spacing: 20) {
                Text("Evaluation points")
                Text("\(user.correction_point ?? 0)")
            }
        }
        .font(.system(size: 18, design: .rounded))
    }
}

struct showSkills: View {
    let user: User

    var body: some View {
        Section(header: VStack {
            Text("Skills and Projects").font(customHeadline())
            HStack {
                Text("Cursus").padding(.leading)
                Spacer()
                Text("Level").padding(.trailing)
            }
        }) {
            let cursusUsers = user.cursus_users.filter { !$0.skills.isEmpty }
            if !cursusUsers.isEmpty {
                ForEach(cursusUsers.sorted { $0.level > $1.level }) { cursusUser in
                    if !cursusUser.skills.isEmpty {
                        NavigationLink(destination: ProjectsView(cursusUser: cursusUser, projectUser: user.projects_users)) {
                            Text("\(cursusUser.cursus.name)")
                            Spacer()
                            Text("\(cursusUser.level)")
                        }
                    }
                }
                .font(customBody())
            } else { Text("No skills/projects yet") }
        }
    }
}

struct showAchievements: View {
    let user: User
    
    var body: some View {
        Section(header: VStack {
            Text("Achievements").font(customHeadline())
        }) {
            let achievements = user.achievements
            if !achievements.isEmpty {
                ForEach(achievements) { achievement in
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(achievement.name)")
                            .font(.system(size: 16))
                        Text("\(achievement.description)")
                            .font(.system(size: 10))
                    }
                }
            }
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        let logins = ["tfarenga"]
        ForEach(logins, id: \.self) { login in
            InfoView(login: login, tokenAuthorization: .constant(TokenAuthorization())).preferredColorScheme(.light)
        }
    }
}
