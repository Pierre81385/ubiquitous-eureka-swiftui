//
//  FireAuthManager.swift
//  ubiquitous-eureka-swiftui
//
//  Created by m1_air on 8/27/24.
//

import Foundation
import FirebaseAuth
import Observation

@Observable class FireAuthViewModel {
    var currentUser: User? = nil
    var email: String = ""
    var password: String = ""
    var displayName: String = ""
    var avatarURL: String = ""
    var success: Bool = false
    var status: String = ""
    var loggedIn: Bool = false
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
                self.currentUser = user
                self.loggedIn = true
            }
        }
    }
    
    func StopListenerForUserState() {
        if(handle != nil){
            Auth.auth().removeStateDidChangeListener(handle!)
        }
    }
    

    
    func GetCurrentUser() {
        if Auth.auth().currentUser != nil {
            self.currentUser = Auth.auth().currentUser
            self.success = true
            self.status = "Found user uid: \(String(describing: Auth.auth().currentUser?.uid))"
            self.loggedIn = true
        } else {
            self.success = false
            self.status = "User not found!"
            self.loggedIn = false
        }
    }
    
    func SignInWithEmailAndPassword() {
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                   if error != nil {
                       self.StopListenerForUserState()
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
    
    func updateDisplayName() {

        let changeRequest = currentUser!.createProfileChangeRequest()
        changeRequest.displayName = displayName

        changeRequest.commitChanges { error in
            if let error = error {
                print("Failed to update Display Name: \(error.localizedDescription)")
            } else {
                // Optionally reload the user profile to verify the change
                self.currentUser!.reload { reloadError in
                    if let reloadError = reloadError {
                        print("Failed to reload user profile: \(reloadError.localizedDescription)")
                    } else {
                        if self.currentUser!.displayName == self.displayName {
                            self.success = true
                            self.status = "Display name updated successfully!"
                        } else {
                            self.success = false
                            self.status = "Display name update failed!"                        }
                    }
                }
            }
        }
    }
    
    func updateAvatar() {
        
        guard let newPhotoURL = URL(string: avatarURL) else {
            print("Invalid URL string: \(avatarURL)")
            return
        }

        let changeRequest = currentUser!.createProfileChangeRequest()
        changeRequest.photoURL = newPhotoURL

        changeRequest.commitChanges { error in
            if let error = error {
                print("Failed to update avatar: \(error.localizedDescription)")
            } else {
                // Optionally reload the user profile to verify the change
                self.currentUser!.reload { reloadError in
                    if let reloadError = reloadError {
                        print("Failed to reload user profile: \(reloadError.localizedDescription)")
                    } else {
                        if self.currentUser!.photoURL == newPhotoURL {
                            print("Avatar updated successfully!")
                        } else {
                            print("Avatar update failed: URL mismatch.")
                        }
                    }
                }
            }
        }
    }
}
