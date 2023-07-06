//
//  AddMedsView.swift
//  HealthAccess
//
//  Created by Edward Faur on 21.06.2023.
//

import SwiftUI

struct AddMedsView: View {
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()

    
    @State private var code = ""
    @State private var code1 = ""
    @State private var name = ""
    @State private var manufacturer = ""
    @State private var substance = ""
    @State private var form = ""
    @State private var packaging = ""
    @State private var prescription = ""
    @State private var stock: Int = 0
    @State private var price: Double = 0
    @State private var quantity = 0
    @State private var showCode: Bool = false
    @State private var showName: Bool = false
    @State private var suggestions: [String] = ["A", "B", "C1", "C2", "C3", "D", "O"]
    
    @ObservedObject var model = MedsViewModel()
    
    
    
    var body: some View {
        VStack {
            Spacer()
            VStack{
                VStack {
                    TextField("Cod", text: $code)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .onChange(of: code) { newValue in
                            showCode = true
                        }
                    
                    
                    if showCode && !code.isEmpty {
                        ScrollView {
                            ForEach(suggestions
                                    
                                    , id: \.self) { suggestion in
                                ZStack {
                                    Button(action: {
                                        code = suggestion
                                        
                                        //showSuggestions = false
                                        
                                    }) {
                                        Text(suggestion)
                                    }
                                    .onChange(of: code){newValue in
                                        showCode = false
                                        model.getData(for: code.lowercased())
                                        
                                    }
                                    
                                    
                                }
                            }
                        }
                        .frame(maxHeight: 100)
                        
                        
                    }
                }
                VStack{
                    TextField("Denumire", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .onChange(of: name) { newValue in
                            showName = true
                        }
                    if showName && !name.isEmpty{
                        ScrollView {
                            ForEach(model.list.filter({ $0.field_4.localizedCaseInsensitiveContains(name) }).sorted{ item1, item2 in
                                return item1.field_4<item2.field_4
                                
                            }, id: \.self) { suggestion in
                                ZStack {
                                    Button(action: {
                                        name = "\(suggestion.field_4)"
                                        manufacturer = "\(suggestion.field_7)"
                                        substance = "\(suggestion.field_3)"
                                        form = "\(suggestion.field_5)"
                                        prescription = "\(suggestion.field_10)"
                                        packaging = "\(suggestion.field_9)"
                                        price = (suggestion.field_14)
                                        quantity = (suggestion.field_11)
                                        
                                        
                                    }) {
                                        Text(suggestion.field_4)
                                    }
                                    .onChange(of: name){newValue in
                                        showName = false
                                        
                                    }
                                    
                                }
                            }
                        }
                        .frame(maxHeight: 100)
                        
                        
                        
                    }
                }
                TextField("Producator", text: $manufacturer)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                TextField("Substanta", text: $substance)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                TextField("Forma", text: $form)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                TextField("Ambalaj", text: $packaging)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                TextField("Tip prescriptie", text: $prescription)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                TextField("Pret/UT", value: $price, formatter: numberFormatter)
                
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                TextField("Cantitate/UT", value: $quantity, formatter: NumberFormatter())
                
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                TextField("Stoc", value: $stock, formatter: NumberFormatter())
                
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

            }
            
            .frame(width: 400)
            
            Button(action: {
                stock *= quantity
                model.addData(ambalaj: packaging, cod: code, denumire: name, forma: form, prescriptie: prescription, producator: manufacturer, substanta: substance, pret: price, cantitate: quantity, stoc: stock)
                
                
                code = ""
                name = ""
                manufacturer = ""
                substance = ""
                form = ""
                packaging = ""
                prescription = ""
                price = 0
                quantity = 0
                stock = 0
                
            }) {
                Text("Adauga")
                    .font(.title3)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color("Color 1"))
                    .cornerRadius(10)
            }
            .frame(maxWidth: 100, maxHeight:35)
            .buttonStyle(PlainButtonStyle())
            .foregroundColor(.white)
            .background(Color("Color 1"))
            .cornerRadius(5)
            
            
            Spacer()
            
        }
        .padding()
        
    }
//        init(){
//            model.getData(for: code.lowercased())
//        }
}

struct AddMedsView_Previews: PreviewProvider {
    static var previews: some View {
        AddMedsView()
    }
}
