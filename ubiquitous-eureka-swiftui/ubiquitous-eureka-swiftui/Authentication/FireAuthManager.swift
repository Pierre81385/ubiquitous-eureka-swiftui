//
//  FireAuthManager.swift
//  ubiquitous-eureka-swiftui
//
//  Created by m1_air on 8/27/24.
//

import Foundation
import FirebaseAuth

class FireAuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var success: Bool = false
    @Published var status: String = ""
    @Published var loggedIn: Bool = false
    private var handle: AuthStateDidChangeListenerHandle?
    
    func CreateUser() {
         Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
              if error != nil {
                  self.success = false
                  self.status = error?.localizedDescription ?? ""
              } else {
                  self.success = true
                  self.status = "User created!"
              }
          }
        }
    
    func ListenForUserState() {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            switch user {
            case .none:
                print("USER NOT FOUND IN CHECK AUTH STATE")
                self.loggedIn = false
            case .some(let user):
                print("FOUND: \(user.uid)!")
                self.loggedIn = true
            }
        }
    }
    
    func StopListenerForUserState() {
        if(handle != nil){
            Auth.auth().removeStateDidChangeListener(handle!)
        }
    }
    

    
    func GetCurrentUser() -> Bool {
        if Auth.auth().currentUser != nil {
            self.success = true
            self.status = "Found user uid: \(String(describing: Auth.auth().currentUser?.uid))"
            self.loggedIn = true
            return self.loggedIn
        } else {
            self.success = false
            self.status = "User not found!"
            self.loggedIn = false
            return self.loggedIn
        }
    }
    
    func SignInWithEmailAndPassword() {
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                   if error != nil {
                       self.success = false
                       self.status = error?.localizedDescription ?? ""
                   } else {
                       self.success = true
                       self.status = "Successfully signed in!"
                   }
               }
           
    }
    
    func SendEmailVerfication(){
        Auth.auth().currentUser?.sendEmailVerification { error in
            if error != nil {
                self.success = false
                self.status = error?.localizedDescription ?? ""
            } else {
                self.success = true
                self.status = "Email verification sent!"
            }
        }
    }
    
    func UpdateEmail(newEmail: String) {
        Auth.auth().currentUser?.sendEmailVerification(beforeUpdatingEmail: newEmail) { error in
            if error != nil {
                self.success = false
                self.status = error?.localizedDescription ?? ""
            } else {
                self.success = true
                self.status = "Email updated!"
            }
        }
    }
    
    func UpdatePassword(newPassword: String) {
        Auth.auth().currentUser?.updatePassword(to: newPassword) { error in
            if error != nil {
                self.success = false
                self.status = error?.localizedDescription ?? ""
            } else {
                self.success = true
                self.status = "Password updated!"
            }
        }
    }
    
    func SendPasswordReset(){
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if error != nil {
                self.success = false
                self.status = error?.localizedDescription ?? ""
            } else {
                self.success = true
                self.status = "Password reset sent to \(self.email)!"
            }
        }
    }
    
    func DeleteCurrentUser() {
        let user = Auth.auth().currentUser

        user?.delete { error in
            if error != nil {
                self.success = false
                self.status = error?.localizedDescription ?? ""
            } else {
                self.success = true
                self.status = "User deleted!"
            }
        }
    }
    
    func SignOut(){
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            self.success = true
            self.status = "Signed out!"
        } catch let signOutError as NSError {
            self.success = false
            self.status = signOutError.description
        }
    }
}
