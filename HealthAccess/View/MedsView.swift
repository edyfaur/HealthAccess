//
//  MedsView.swift
//  HealthAccess
//
//  Created by Edward Faur on 20.06.2023.
//

import SwiftUI

struct MedsView: View {
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    @State private var searchText = ""
    @State private var selectedList = ""
    @State private var selectedField = "field_4"
    @State private var selectedSortField = "Denumire"
    @ObservedObject var model = MedsViewModel()
    
    var sortFields = ["Denumire","Producator","Substanta","Forma","Ambalaj","Prescriptie"]
    
    var filtered: [MedsModel]{
        model.list.filter{ item in
            let fieldValue: String = {
                switch selectedField{
                case "field_4":
                    return item.field_4
                case "field_7":
                    return item.field_7
                case "field_3":
                    return item.field_3
                case "field_5":
                    return item.field_5
                case "field_9":
                    return item.field_9
                case "field_10":
                    return item.field_10
                default:
                    return "field_4"
                }
            }()
            return searchText.isEmpty || fieldValue.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var filteredItems:[MedsModel]{
        filtered.filter{
            item in
            return !item.field_4.isEmpty
        }.sorted { item1, item2 in
            switch selectedSortField {
            case "Denumire":
                return item1.field_4 < item2.field_4
            case "Producator":
                return item1.field_7 < item2.field_7
            case "Substanta":
                return item1.field_3 < item2.field_3
            case "Forma":
                return item1.field_5 < item2.field_5
            case "Ambalaj":
                return item1.field_9 < item2.field_9
            case "Prescriptie":
                return item1.field_10 < item2.field_10
            default:
                return item1.field_4 < item2.field_4
            }
        }
    }
    
    
    
    
    var body: some View {
        NavigationView{
            VStack{
                Table(filteredItems){
                    TableColumn("Denumire"){product in
                        Text(String(describing: product.field_4))
                            .textSelection(.enabled)
                    }
                    TableColumn("Substanta"){product in
                        Text(String(describing: product.field_3))
                            .textSelection(.enabled)
                    }
                    TableColumn("Forma"){product in
                        Text(String(describing: product.field_5))
                            .textSelection(.enabled)
                    }
                    TableColumn("Producător"){product in
                        Text(String(describing: product.field_7))
                            .textSelection(.enabled)
                    }
                    TableColumn("Prescriptie"){product in
                        Text(String(describing: product.field_10))
                            .textSelection(.enabled)
                    }
                    TableColumn("Ambalaj"){product in
                        Text(String(describing: product.field_9))
                            .textSelection(.enabled)
                    }
                    TableColumn("Pret/UT"){product in
                        Text(String(describing: product.field_14))
                            .textSelection(.enabled)
                    }
                    TableColumn("Cantitate UT/Ambalaj"){product in
                        Text(String(describing: product.field_11))
                            .textSelection(.enabled)
                    }
                }
                
            }
            .frame(minWidth: 1240,maxWidth: .infinity)
            
            .edgesIgnoringSafeArea(.horizontal)
            
        }
        
        .frame(minWidth: 1200)
        .searchable(text: $searchText,placement: .toolbar,prompt: "Search")
        .toolbar{
            Picker("", selection: $selectedList) {
                Text("List A").tag("a")
                Text("List B").tag("b")
                Text("List C1").tag("c1")
                Text("List C2").tag("c2")
                Text("List C3").tag("c3")
                Text("List D").tag("d")
                Text("List OTC").tag("o")
            }
            .frame(alignment: .top)
            .pickerStyle(InlinePickerStyle())
            .onChange(of: selectedList) { newList in
                model.getData(for: newList)}
            Spacer()
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
                Text("Denumire").tag("field_4")
                Text("Producator").tag("field_7")
                Text("Substanta").tag("field_3")
                Text("Forma").tag("field_5")
                Text("Ambalaj").tag("field_9")
                Text("Prescriptie").tag("field_10")
                Spacer()
            }
            .pickerStyle(MenuPickerStyle())
            
            
        }
        
        
    }
    
}

struct MedsView_Previews: PreviewProvider {
    static var previews: some View {
        MedsView()
    }
}
