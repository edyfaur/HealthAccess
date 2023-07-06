//
//  SellsView.swift
//  HealthAccess
//
//  Created by Edward Faur on 04.07.2023.
//

import SwiftUI
import FirebaseFirestore


struct SellsView: View {
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()

    private func formatTimestamp(_ timestamp: Timestamp?) -> Text {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"

        if let timestamp = timestamp {
            let date = timestamp.dateValue()
            return Text(dateFormatter.string(from: date))
        } else {
            return Text("Invalid date")
        }
    }

    
    @ObservedObject var model = MedsViewModel()
    @State private var searchText = ""
    @State private var selectedField = "denumire"
    @State private var selectedSortField = "Cod"
    var sortFields = ["Cod","Denumire","Cantitate","Farmacist","Data"]
    
    var filteredItems: [SellsModel] {
        model.s.filter { item in
            let fieldValue: String = {
                switch selectedField {
                case "cod":
                    return item.cod
                case "denumire":
                    return item.denumire
                case "cantitate":
                    return String(describing: item.cantitate)
                case "farmacist":
                    return item.farmacist
                case "data":
                    return String(describing: item.data)
                default:
                    return "denumire"
                }
            }()
            return searchText.isEmpty || fieldValue.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var filteredItems2: [SellsModel]{
        filteredItems.filter{ item in
            return !item.denumire.isEmpty
        }.sorted { (item1: SellsModel, item2: SellsModel) -> Bool in
            switch selectedSortField {
            case "Cod":
                return item1.cod < item2.cod
            case "Denumire":
                return item1.denumire < item2.denumire
            case "Pret":
                return item1.pret < item2.pret
            case "Cantitate":
                return item1.cantitate < item2.cantitate
            case "Farmacist":
                return item1.farmacist < item2.farmacist
            case "Data":
                return item1.data < item2.data
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
                    TableColumn("Pret"){product in
                        Text("\(numberFormatter.string(from: NSNumber(value: product.pret)) ?? "")")
                            .textSelection(.enabled)
                    }
                    TableColumn("Cantitate"){product in
                        Text(String(describing: product.cantitate))
                            .textSelection(.enabled)
                    }
                    TableColumn("Farmacist"){product in
                        Text(String(describing: product.farmacist))
                            .textSelection(.enabled)
                    }
                    TableColumn("Data"){sell in
                        formatTimestamp(sell.data)


                            
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
                Text("Pret").tag("pret")
                Text("Cantitate").tag("cantitate")
                Text("Farmacist").tag("farmacist")
                Text("Data").tag("Data")
            }
            .pickerStyle(MenuPickerStyle())
            
        }
        
        
        
        
        
        
        
    }
    
    
    init() {
        model.getSells()
        
    }
}

struct SellsView_Previews: PreviewProvider {
    static var previews: some View {
        SellsView()
    }
}
