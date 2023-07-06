//
//  BillingView.swift
//  HealthAccess
//
//  Created by Edward Faur on 21.06.2023.
//

import SwiftUI

//class ProductList: ObservableObject {
//    @Published var productList: [Product] = []
//}


struct Product: Identifiable, Hashable {
    var id: String
    
    var code: String
    var name: String
    var price: Double
    var quantity: Int
    var priceTotal: Double
}

struct BillingView: View {
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    @State private var productList:[Product]=[]
    @State private var selectedProductID: String = ""
    @State private var selectedProductName: String = ""
    @State private var selectedProductCode: String = ""
    @State private var selectedProductPrice: Double = 0
    @State private var autoQuantity: Int = 0
    @State private var manualQuantity: Int = 0
    @State private var productStock: Int = 0
    @State private var productTotal: Double = 0
    @State private var selectedField = "denumire"
    @State private var selectedSortField = "Cod"
    @State private var searchText = ""
    @State private var total: Double = 0
    @State private var discount: Double = 0
    @State private var includeRecipe : Bool = false
    @State private var userRole : String?
    @ObservedObject var model = MedsViewModel()
    @StateObject private var viewModel = AuthenticationViewModel()
    
    var filteredItems: [StockModel] {
        model.l.filter { item in
            let fieldValue: String = {
                switch selectedField {
                case "denumire":
                    return item.denumire
                case "substanta":
                    return item.substanta
                default:
                    return "denumire"
                }
            }()
            return searchText.isEmpty || fieldValue.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    
    
    
    
    var body: some View {
        VStack{
            if let userRole = userRole{
                if userRole == "ADMIN" || userRole == "USER"{
                VStack{
                    NavigationView {
                        VStack{
                            
                            Table(productList) {
                                TableColumn("Produs", value: \.name)
                                TableColumn("Pret/UT") {product in
                                    Text(String(describing: (numberFormatter.string(from: NSNumber(value: product.price)) ?? "")))
                                }
                                TableColumn("Cantitate") {product in
                                    Text(String(describing: product.quantity))
                                }
                                TableColumn("Pret") {product in
                                    Text(String(describing: (numberFormatter.string(from: NSNumber(value: product.priceTotal)) ?? "")))
                                        .onAppear{
                                            updateTotal(with: product.priceTotal)
                                            
                                            
                                        }
                                    
                                }
                                TableColumn("Valoare compensata ") {product in
                                    Text("\(String(describing: getDiscount(with: product.code)))%")
                                        .onAppear{
                                            
                                        }
                                    
                                }
                                
                                
                                TableColumn("") { product in
                                    if let index = productList.firstIndex(where: { $0.id == product.id }) {
                                        Button(action: {
                                            deleteProduct(at: index)
                                            updateTotal(with: -(product.priceTotal))
                                        }){
                                            Image(systemName: "trash.fill")
                                        }
                                    }
                                }
                            }
                            .frame(maxHeight: 200, alignment:.topLeading)
                            
                            Divider()
                            
                            VStack{
                                Text("TOTAL: \(numberFormatter.string(from: NSNumber(value: total)) ?? "")")
                                
                        
                                HStack{
                                    Text("Produs: \(selectedProductName)")
                                    Divider()
                                    Text("Pret/UT: \(numberFormatter.string(from: NSNumber(value: selectedProductPrice)) ?? "")")
                                    Divider()
                                    Text("Numar bucati: \(manualQuantity)")
                                    Picker("", selection: $manualQuantity) {
                                        if autoQuantity >= 1 {
                                            ForEach(1...autoQuantity, id: \.self) { number in
                                                Text("\(number)")
                                                    .tag(number)
                                            }
                                        } else {
                                            Text("Nu există opțiuni disponibile")
                                        }
                                    }
                                    .frame(width: 15)
                                    .pickerStyle(MenuPickerStyle())
                                    Divider()
                                    Text("Pret: \(numberFormatter.string(from: NSNumber(value: productTotal)) ?? "")")
                                        .onChange(of: includeRecipe){ _ in
                                            
                                            if includeRecipe{
                                                
                                                productTotal = detDiscount(price: productTotal, discount: getDiscount(with: selectedProductCode))
                                                print("DISCOUNT: \(detDiscount(price: productTotal, discount: getDiscount(with: selectedProductCode)))")}
                                            else{
                                                productTotal = Double(manualQuantity) * selectedProductPrice
                                            }
                                            
                                        }
                                    Divider()
                                    
                                    if includeRecipe{
                                        
                                        Text("Noul pret: \(numberFormatter.string(from: NSNumber(value: detDiscount(price: productTotal, discount: getDiscount(with: selectedProductCode)))) ?? "")")
                                            .onChange(of: includeRecipe){_ in
                                                productTotal = detDiscount(price: productTotal, discount: getDiscount(with: selectedProductCode))
                                                print("DISCOUNT: \(detDiscount(price: productTotal, discount: getDiscount(with: selectedProductCode)))")
                                                
                                                
                                            }
                                    }
                                    
                                }
                                .frame(height: 60)
                                
                                HStack{
                                    Button(action: generateInvoice){
                                        Text("Factura")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                            .padding()
                                        //.frame(maxWidth: .infinity)
                                            .background(Color("Color 1"))
                                            .cornerRadius(10)
                                        
                                    }
                                    .frame(maxHeight:20)
                                    .buttonStyle(PlainButtonStyle())
                                    .foregroundColor(.white)
                                    .background(Color("Color 1"))
                                    .cornerRadius(5)
                                    Button(action: {addProduct()})
                                    {
                                        Text("Adauga Produs")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                            .padding()
                                        //.frame(maxWidth: .infinity)
                                            .background(Color("Color 1"))
                                            .cornerRadius(10)
                                    }
                                    .frame(maxHeight:20)
                                    .buttonStyle(PlainButtonStyle())
                                    .foregroundColor(.white)
                                    .background(Color("Color 1"))
                                    .cornerRadius(5)
                                    Toggle(isOn:$includeRecipe){
                                        Text("Reteta")
                                    }
                                }

                            }
                        
                        }
                        .frame(minWidth: 800)
                        
                        
                        
                        
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16){
                            ForEach(filteredItems.filter{
                                item in
                                return (item.stoc != 0)
                            }.sorted{ item1, item2 in
                                return item1.denumire < item2.denumire
                                
                                
                            }, id: \.id) { item in
                                VStack {
                                    Text("\(item.denumire)")
                                        .tag(item.id)
                                    Text("\(item.substanta)")
                                    Text("\(item.stoc/item.cantitate) bucati")
                                    Button(action: {
                                        selectedProductID = item.id
                                    }) {
                                        Text("Vinde")
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                //.background(Color.blue.opacity(0.2))
                                .background(Color("Color 1").opacity(0.2))
                                .cornerRadius(10)
                            }
                        }
                        
                        .padding()
                        .onChange(of: selectedProductID) { newValue in
                            if let product = model.l.first(where: { $0.id == newValue }) {
                                selectedProductCode = product.cod
                                selectedProductName = product.denumire
                                selectedProductPrice = product.pret
                                autoQuantity = product.cantitate
                                manualQuantity = autoQuantity
                                productStock = product.stoc
                                productTotal = Double(autoQuantity) * selectedProductPrice
                            }
                        }
                    }
                   
                    .searchable(text: $searchText, placement: .toolbar)
                    .toolbar(){
                        
                    }
                
                }

                .frame(maxHeight:500)
                }else if userRole == "" {
                    VStack{
                        Image("logo2")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 500)
                        Text("Bun venit")
                            .font(.title)
                        Text("Contului nu i-a fost atribuit niciun rol. Contactați administratorul.")
                    }
                }
                
            }else {
                // Tratați eroarea aici, de exemplu afișați un mesaj de eroare într-o alertă
               EmptyView()
            }
        }
        .onAppear{
            getUserRole()
        }
    }
    init() {
        model.getStock()
        
    }
    func getUserRole() {
        viewModel.getUserRole { role, error in
            if let role = role {
                userRole = role
            } else if error != nil {
                // Tratează eroarea
            }
        }
    }
    func generateInvoice() {
        let currentDate = Date()
        for product in productList {
            model.sell(cod: product.code, denumire: product.name, pret: product.priceTotal, cantitate: product.quantity, farmacist: viewModel.displayName, data: currentDate)
            
            if let stockToUpdate = model.l.first(where: { $0.cod == product.code }) {
                model.updateData(stockToUpdate: stockToUpdate, quantitySold: product.quantity)
            }
        }
        
        productList.removeAll()
        total = 0
    }



    func getDiscount(with cod:String) -> Double{
        switch cod{
        case "A":
            return 90
        case "B":
            return 50
        case "C1":
            return 100
        case "C2":
            return 100
        case "C3":
            return 100
        case "D":
            return 20
        default:
            return 0
        }
        
    }
    func deleteProduct(at index: Int) {
        productList.remove(at: index)
    }
    func detDiscount(price: Double, discount: Double) -> Double{
        let discountAmount = price * (discount/100)
        let newPrice = price - discountAmount
        return newPrice

        
    }
    
    func updateTotal(with priceTotal: Double) {
            total += priceTotal
        }
    func addProduct() {
        // Verificăm dacă există un produs selectat
        guard !(selectedProductID.isEmpty) else {
            return
        }
        
        // Creăm un obiect Product folosind valorile selectate
        let newProduct = Product(id: selectedProductID, code: selectedProductCode, name: selectedProductName, price: selectedProductPrice, quantity: manualQuantity, priceTotal: productTotal)
        
        // Adăugăm noul produs într-o nouă listă (de exemplu, productList)
        productList.append(newProduct)
        
        // Resetăm valorile selectate pentru a permite utilizatorului să selecteze un alt produs
        selectedProductID = ""
        selectedProductName = ""
        selectedProductPrice = 0
        manualQuantity = 0
        productTotal = 0
        productStock = 0
        autoQuantity = 0
        includeRecipe = false
        var _ = print("Adauga produs")
    }
    
    
    
    
}


struct BillingView_Previews: PreviewProvider {
    static var previews: some View {
        BillingView()
    }
}
