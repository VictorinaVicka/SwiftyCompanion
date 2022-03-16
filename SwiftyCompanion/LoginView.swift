//
//  LoginView.swift
//   SwiftyCompanion
//
//  Created by Виктория Воробьева on 27.01.2022.
//

import SwiftUI

struct LoginView: View {
    @State private var login = ""
    @State private var isEditing = false
    @State private var tokenAuthorization = TokenAuthorization()
    let title = "SwiftyCompanion"
    var imageOffset = CGFloat(-50)

    init(getToken: Bool = true) {
        var titleSize = CGFloat(40)
        let titleFont = "Arial Rounded MT Bold"
        let screenWidth = UIScreen.main.bounds.size.width

        func titleWidth() -> CGFloat {
            return title.widthOfString(usingFont: UIFont(name: titleFont, size: titleSize)!)
        }
        while titleWidth() > screenWidth {
            titleSize *= 0.9
            imageOffset *= 0.7
        }

        UINavigationBar.appearance().largeTitleTextAttributes = [
            .font : UIFont(name: titleFont, size: titleSize)!
        ]
        if getToken {
            self.tokenAuthorization.getToken()
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                Text("Swifty Companion")
                    .font(.custom("name-of-font", size: 25))
                Image("logo_42").resizable().scaledToFill().frame(width: /*@START_MENU_TOKEN@*/150.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/150.0/*@END_MENU_TOKEN@*/)
                VStack {
                    Text("Please, enter a login to search")
                }
                .font(.custom("name-of-font", size: 20))
                .padding(.bottom, 30.0)
                
                TextField("Login", text: $login, onEditingChanged: { isEditing in self.isEditing = isEditing })
                    .padding(7)
                    .padding(.horizontal, 25)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal, 15)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                NavigationLink(destination: InfoView(login: login, tokenAuthorization: $tokenAuthorization)) {
                    Text("Search")
                        .foregroundColor(Color.black)
                }
                .padding(.top)
                .disabled(login.isEmpty)
            }
            .navigationBarHidden(isEditing)
            .padding(.vertical, 200)
            .background(Color.green)
        }
        .background(Color.green)
    }
}

extension String {
   func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
