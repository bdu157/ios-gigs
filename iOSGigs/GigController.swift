//
//  GigController.swift
//  iOSGigs
//
//  Created by Dongwoo Pae on 5/30/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import Foundation
import UIKit


enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum NetworkError: Error {
    case noAuth
    case badAuth
    case otherError
    case badData
    case noDecode
}

class GigController {
    
    var gigs: [Gig] = []
    
    var bearer: Bearer?
    
    private let baseUrl = URL(string: "https://lambdagigs.vapor.cloud/api")!
    
    
    //sign up - POST
    func signUp(with user: User, completion: @escaping (Error?)-> ()) {
        let signUpURL = baseUrl.appendingPathComponent("users/signup")
        
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            NSLog("Error encoding user object: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    
    //log in - POST
    func logIn(with user: User, completion: @escaping (Error?)-> ()) {
        let logInURL = baseUrl.appendingPathComponent("users/login")
        
        var request = URLRequest(url: logInURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            NSLog("Error encoding user object: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            if let error = error {
                completion(error)
                return
            }
            
            guard let data = data else {
                completion(NSError())
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                self.bearer = try decoder.decode(Bearer.self, from: data)
                
            } catch {
                
                NSLog("Error decoding bearer obejct: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
    
    //fetching gigs - GET
    func fetchGigs(completion:@escaping (Error?)-> Void) {
        guard let bearer = self.bearer else {
            completion(NSError())
            return
        }
        
        let gigsURL = baseUrl.appendingPathComponent("gigs")
        
        var request = URLRequest(url: gigsURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(NSError())
                return
        }
            if let _ = error {
                completion(NSError())
                return
            }
            
            guard let data = data else {
                completion(NSError())
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let gigss = try decoder.decode([Gig].self, from: data)
                self.gigs = [gigss[0]]
            } catch {
                NSLog("Error decoding animal objects: \(error)")
                completion(NSError())
                return
            }
            completion(nil)
            }.resume()
    }
    //create gig - POST

    func CreateGig(title: String, description: String, dueDate:Date, completion: @escaping (Error?)->Void) {
      
        let gigss = Gig(title: title, description: description, dueDate: dueDate)
        
        let createURL = baseUrl.appendingPathComponent("gigs")
        
        guard let bearer = bearer else {
                completion(NSError())
                return
        }
        
        
        var request = URLRequest(url: createURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        let jsonEncoder = JSONEncoder()
        
        do {
            let jsonData = try jsonEncoder.encode(gigss)
            request.httpBody = jsonData
        } catch {
            NSLog("Error encoding user object: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            if let error = error {
                completion(error)
                return
            }
            
            self.gigs.append(gigss)
            
            completion(nil)
            }.resume()
    }
}
