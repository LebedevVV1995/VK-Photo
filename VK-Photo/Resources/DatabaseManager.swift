//
//  DatabaseManager.swift
//  VK-Photo
//
//  Created by Владимир on 09.04.2022.
//  Copyright © 2022 Владимир. All rights reserved.
//

import Foundation
import FirebaseDatabase

final class DatabaseManeger {
    
    static let shared = DatabaseManeger()
    
    let database = Database.database().reference()
    
    static func safeEmail(emailAddress: String) -> String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}

//MARK: - Account Management

extension DatabaseManeger {
    public func userExists(with email: String,
                                completion: @escaping((Bool) -> Void)) {
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        database.child(safeEmail).observeSingleEvent(of: .value, with: { snapshot in
            guard snapshot.value as? String != nil else {
                completion(false)
                return
            }
            completion(true)
        })
    }
    ///Insert new user to database
    public func insertUser(with user: VKPhotoUser, completion: @escaping (Bool) -> Void){
        database.child(user.safeEmail).setValue([
            "first_name": user.firstName,
            "last_name": user.lastName
            ], withCompletionBlock: { [weak self] error, _ in
                guard let strongSelf = self else {
                    return
                }
                guard error == nil else{
                    print("failed to write to database")
                    completion(false)
                    return
                }
                strongSelf.database.child("users").observeSingleEvent(of: .value, with: { snapshot in
                    if var usersCollection = snapshot.value as? [[String: String]] {
                        // append to user dictionary
                        let newElement = [
                                "name": user.firstName + " " + user.lastName,
                                "email": user.safeEmail
                        ]
                        
                        usersCollection.append(newElement)

                        strongSelf.database.child("users").setValue(usersCollection, withCompletionBlock: { error, _ in
                            guard error == nil else {
                                completion(false)
                                return
                            }
                            completion(true)
                        })
                    } else {
                        //create that array
                        let newCllection: [[String: String]] = [
                            [
                                "name": user.firstName + " " + user.lastName,
                                "email": user.safeEmail
                            ]
                        ]
                        strongSelf.database.child("users").setValue(newCllection, withCompletionBlock: { error, _ in
                            guard error == nil else {
                                completion(false)
                                return
                            }
                            completion(true)
                        })
                    }
                })
        })
    }
    public func getAllUsers(completion: @escaping (Result<[[String: String]], Error>) -> Void) {
           database.child("users").observeSingleEvent(of: .value, with: { snapshot in
               guard let value = snapshot.value as? [[String: String]] else {
                   completion(.failure(DatabaseError.failedToFetch))
                   return
               }
               completion(.success(value))
           })
       }
    
    public enum DatabaseError: Error {
        case failedToFetch
    }
    
    
}

struct VKPhotoUser {
    let firstName: String
    let lastName: String
    let emailAddress: String
    //let profilePicture: String
    
    var safeEmail: String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
    var profilePictureFileName: String {
        return "\(safeEmail)_profile_picture.png"
    }
}
