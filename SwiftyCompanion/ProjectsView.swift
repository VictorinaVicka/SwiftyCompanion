//
//  ProjectsView.swift
//   SwiftyCompanion
//
//  Created by Виктория Воробьева on 27.01.2022.
//

import SwiftUI

struct ProjectsView: View {
    var cursusUser: CursusUser
    var projectUser: [ProjectsUser]

    var body: some View {
        List {
            Section(header:
                VStack {
                    Text("Skills").font(customHeadline())
                    HStack {
                        Text("Skill").padding(.leading)
                        Spacer()
                        Text("Level").padding(.trailing)
                    }
                }
            ) {
                ForEach(cursusUser.skills) { skill in
                    HStack {
                        Text(skill.name)
                        Spacer()
                        Text(String(skill.level))
                    }
                }
                .font(customBody())
            }

            Section(header:
                VStack {
                    Text("Finished Projects").font(customHeadline())
                    HStack {
                        Text("Project").padding(.leading)
                        Spacer()
                        Text("Level").padding(.trailing)
                    }
                }
            ) {
                let cursusID = cursusUser.cursus.id
                let filtered = projectUser.filter { $0.cursusIDS.contains(where: { $0 == cursusID }) }
                ForEach(filtered) { project in
                    if project.status == "finished" {
                        HStack {
                            Text(project.project.name).foregroundColor(project.getColor())
                            Spacer()
                            Text(String(project.finalMark ?? 0))
                        }
                    }
                }
                .font(customBody())
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle(Text(String(cursusUser.cursus.name)), displayMode: .inline)
    }
}

struct ProjectsView_Previews: PreviewProvider {
    static var previews: some View {
        let user = getTestUser(login: "tfarenga")!
        ForEach(0...user.cursus_users.count - 1, id: \.self) { n in
            ProjectsView(cursusUser: user.cursus_users[n], projectUser: user.projects_users)
        }
    }
}
