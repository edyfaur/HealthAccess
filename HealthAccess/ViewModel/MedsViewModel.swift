//
//  MedsViewModel.swift
//  HealthAccess
//
//  Created by Edward Faur on 19.06.2023.
//

import Foundation
import Firebase
import FirebaseFirestore


class MedsViewModel: ObservableObject{
    @Published var list = [MedsModel]()
    @Published var l = [StockModel]()
    @Published var s = [SellsModel]()
   
    let db = Firestore.firestore()
    
    func getStock(){
        
        db.collection("lista_s").getDocuments { snapshot, error in
            
            if error == nil {
                if let snapshot = snapshot {
                    
                    DispatchQueue.main.async{
                        self.l = snapshot.documents.map{ s in
                            
                            return StockModel(id: s.documentID,
                                             ambalaj: s["ambalaj"] as? String ?? "",
                                             cod: s["cod"] as? String ?? "",
                                             denumire: s["denumire"] as? String ?? "",
                                             forma: s["forma"] as? String ?? "",
                                             prescriptie: s["prescriptie"] as? String ?? "",
                                             producator: s["producator"] as? String ?? "",
                                              substanta: s["substanta"] as? String ?? "",
                                              pret: s["pret"] as? Double ?? 0,
                                              cantitate: s["cantitate"] as? Int ?? 0,
                                              stoc: s["stoc"] as? Int ?? 0
                                              
                            )
                            
                            
                        }
                    }
                    
                }
            }else{
                
            }
        }
    }
    
    func addData(ambalaj: String,cod: String,denumire: String,forma: String,prescriptie: String,producator: String,substanta: String, pret: Double, cantitate: Int, stoc: Int){
        db.collection("lista_s").addDocument(data: ["ambalaj": ambalaj,"cod": cod,"denumire": denumire,"forma": forma,"prescriptie": prescriptie,"producator": producator,"substanta": substanta,"pret": pret,"cantitate":cantitate, "stoc": stoc]) { error in
            
            if error == nil{
                self.getStock()
            }
            else{
                
            }
        }
    }
    func getSells(){
        
        db.collection("vanzari").getDocuments { snapshot, error in
            
            if error == nil {
                if let snapshot = snapshot {
                    
                    DispatchQueue.main.async{
                        self.s = snapshot.documents.map{ s in
                            
                            return SellsModel(id: s.documentID,
                                             cod: s["cod"] as? String ?? "",
                                             denumire: s["denumire"] as? String ?? "",
                                              pret: s["pret"] as? Double ?? 0,
                                              cantitate: s["cantitate"] as? Int ?? 0,
                                              farmacist: s["farmacist"] as? String ?? "",
                                              data: s["data"] as? Timestamp ?? Timestamp()
                                              
                                              
                            )
                            
                            
                        }
                    }
                    
                }
            }else{
                
            }
        }
    }
    func sell(cod: String,denumire: String, pret: Double, cantitate: Int, farmacist: String, data: Date){
        db.collection("vanzari").addDocument(data: ["cod": cod,"denumire": denumire,"pret": pret,"cantitate":cantitate,"farmacist":farmacist, "data": data]) { error in
            
            if error == nil{
                self.getSells()
            }
            else{
                
            }
        }
    }
    
    func updateData(stockToUpdate: StockModel, quantitySold: Int) {
    
        // Calculate the new stock value after the quantity sold
        let newStockValue = stockToUpdate.stoc - quantitySold
        
        // Set the data to update
        db.collection("lista_s").document(stockToUpdate.id).setData(["stoc": newStockValue], merge: true) { error in
            // Check for errors
            if error == nil {
                // Get the new data
                self.getStock()
            }
        }
    }

    
   
    func getData(for listName: String){
        
        db.collection("lista_\(listName)").getDocuments { snapshot, error in
            
            if error == nil {
                if let snapshot = snapshot {
                    
                    DispatchQueue.main.async{
                        self.list = snapshot.documents.map{ d in
                            
                            return MedsModel(id: d.documentID,
                                             field_4: d["field_4"] as? String ?? "",
                                             field_7: d["field_7"] as? String ?? "",
                                             field_3: d["field_3"] as? String ?? "",
                                             field_5: d["field_5"] as? String ?? "",
                                             field_9: d["field_9"] as? String ?? "",
                                             field_10: d["field_10"] as? String ?? "",
                                             field_11: d["field_11"] as? Int ?? 0,
                                             field_14: d["field_14"] as? Double ?? 0
                            )
                        }
                    }
                    
                }
            }
            else{
                
            }
        }
    }
    
    func deleteData(for listName: String, dataToDelete: MedsModel) {
            
            
            // Specify the document to delete
            db.collection("lista_\(listName)").document(dataToDelete.id).delete { error in
                
                // Check for errors
                if error == nil {
                    // No errors
                    
                    // Update the UI from the main thread
                    DispatchQueue.main.async {
                        
                        // Remove the todo that was just deleted
                        self.list.removeAll { data in
                            
                            // Check for the todo to remove
                            return data.id == dataToDelete.id
                        }
                    }
                    
                    
                }
            }
            
        }
}


