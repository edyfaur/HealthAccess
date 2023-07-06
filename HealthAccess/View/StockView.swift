//
//  StockView.swift
//  HealthAccess
//
//  Created by Edward Faur on 21.06.2023.
//

import SwiftUI

struct StockView: View{
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    
    
    @ObservedObject var model = MedsViewModel()
    @State private var searchText = ""
    @State private var selectedField = "denumire"
    @State private var selectedSortField = "Cod"
    var sortFields = ["Cod","Denumire","Substanta","Forma","Prescriptie","Producator","Ambalaj"]
    
    var filteredItems: [StockModel] {
        model.l.filter { item in
            let fieldValue: String = {
                switch selectedField {
                case "cod":
                    return item.cod
                case "denumire":
                    return item.denumire
                case "substanta":
                    return item.substanta
                case "forma":
                    return item.forma
                case "prescriptie":
                    return item.prescriptie
                case "producator":
                    return item.producator
                case "ambalaj":
                    return item.ambalaj
                default:
                    return "denumire"
                }
            }()
            return searchText.isEmpty || fieldValue.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var filteredItems2: [StockModel]{
        filteredItems.filter{
            item in
            return !item.denumire.isEmpty
        }.sorted { item1, item2 in
            switch selectedSortField {
            case "Cod":
                return item1.cod < item2.cod
            case "Denumire":
                return item1.denumire < item2.denumire
            case "Substanta":
                return item1.substanta < item2.substanta
            case "Forma":
                return item1.forma < item2.forma
            case "Prescriptie":
                return item1.prescriptie < item2.prescriptie
            case "Producator":
                return item1.producator < item2.producator
            case "Ambalaj":
                return item1.ambalaj < item2.ambalaj
            default:
                return item1.cod < item2.cod
            }
        }
    }
    
    
    var body: some View {
        NavigationView{
            VStack{
                Table(filteredItems2){
                    TableColumn("Cod"){product in
                        Text(String(describing: product.cod))
                            .textSelection(.enabled)
                    }
                    TableColumn("Denumire"){product in
                        Text(String(describing: product.denumire))
                            .textSelection(.enabled)
                    }
                    TableColumn("Substanta"){product in
                        Text(String(describing: product.substanta))
                            .textSelection(.enabled)
                    }
                    TableColumn("Forma"){product in
                        Text(String(describing: product.forma))
                            .textSelection(.enabled)
                    }
                    TableColumn("Prescriptie"){product in
                        Text(String(describing: product.prescriptie))
                            .textSelection(.enabled)
                    }
                    TableColumn("Ambalaj"){product in
                        Text(String(describing: product.ambalaj))
                            .textSelection(.enabled)
                    }
                    TableColumn("Pret/UT"){product in
                        Text(String(describing: product.pret))
                            .textSelection(.enabled)
                    }
                    TableColumn("Cantitate UT/Ambalaj"){product in
                        Text(String(describing: product.cantitate))
                            .textSelection(.enabled)
                    }
                    TableColumn("Stoc"){product in
                        Text("\(String(describing: (product.stoc/product.cantitate))) cutii + \(String(describing: (product.stoc%product.cantitate))) bucati")
                            .textSelection(.enabled)
                    }
                }
            }
            .frame(minWidth: 1240,maxWidth: .infinity)
            
            .edgesIgnoringSafeArea(.horizontal)
           
            
        }
        .searchable(text: $searchText, placement: .toolbar,prompt: "Search")
        .frame(minWidth: 1200)
        .toolbar{
            Text("Sortare dupa:")
                .foregroundColor(Color.gray)
            Picker("Sortare", selection:$selectedSortField){
                ForEach(sortFields, id: \.self) { field in
                    Text(field)
                }
            }
            .pickerStyle(MenuPickerStyle())
            Spacer()
            Picker("Select Field", selection: $selectedField) {
                Text("Cod").tag("cod")
                Text("Denumire").tag("denumire")
                Text("Substanta").tag("substanta")
                Text("Forma").tag("forma")
                Text("Prescriptie").tag("prescriptie")
                Text("Producator").tag("producator")
                Text("Ambalaj").tag("ambalaj")
            }
            .pickerStyle(MenuPickerStyle())
            
        }
      
    }
    
    
    init() {
        model.getStock()
        
    }
}



struct StockView_Previews: PreviewProvider {
    static var previews: some View {
        StockView()
    }
}
