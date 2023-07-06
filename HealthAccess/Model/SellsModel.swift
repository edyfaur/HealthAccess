//
//  SellsModel.swift
//  HealthAccess
//
//  Created by Edward Faur on 03.07.2023.
//

import Foundation
import FirebaseFirestore



struct SellsModel: Identifiable,Hashable{

    var id: String
    
    var cod: String
    var denumire: String
    var pret: Double
    var cantitate: Int
    var farmacist: String
    var data: Timestamp
    
    
    
   
    
    


}


