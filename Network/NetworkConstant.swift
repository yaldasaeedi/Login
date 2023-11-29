//
//  NetworkConstant.swift
//  Login
//
//  Created by yalda saeedi on 9/6/1402 AP.
//

import Foundation

class NetworkConstant {
        
        public static var shared: NetworkConstant = NetworkConstant()
        
        private init(){
            
        }
        
    public var servarAddress : String {
            get{
                return "https://app.neshanmap.ir/iran-map-api"
            }
        }
       

        
    
    
}
