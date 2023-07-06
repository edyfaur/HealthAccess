//
//  ContentView.swift
//  HealthAccess
//
//  Created by Edward Faur on 25.05.2023.
//

import SwiftUI


struct ContentView: View {
    @State private var selectedTab: Tab? = nil
    @State private var searchText = ""
    @ObservedObject var model = AuthenticationViewModel()
    
    @State private var userRole: String? = nil
    
    enum Tab {
        case stock
        case meds
        case addMeds
        case billing
        case sells
    }
    
    var body: some View {
            VStack{
                NavigationView {
                    
                        if let userRole = userRole{
                            
                            if userRole == "ADMIN" {
                                List {
                                    Spacer()
                                    Button(action: {
                                        selectedTab = .stock
                                    }) {
                                        Label("Stoc", systemImage: "list.bullet")
                                            .font(.system(size: 15))
                                            .padding(8)
                                    }
                                    
                                    Button(action: {
                                        selectedTab = .meds
                                    }) {
                                        Label("Meds", systemImage: "list.bullet")
                                            .font(.system(size: 15))
                                            .padding(8)
                                    }
                                    
                                    Button(action: {
                                        selectedTab = .sells
                                    }) {
                                        Label("Vanzari", systemImage: "list.bullet")
                                            .font(.system(size: 15))
                                            .padding(8)
                                    }
                                    .frame(height: 12)

                                    
                                    Button(action: {
                                        selectedTab = .addMeds
                                    }) {
                                        Label("Add Meds", systemImage: "plus.circle")
                                            .font(.system(size: 15))
                                            .padding(8)
                                    }
                                    
                                    Button(action: {
                                        selectedTab = .billing
                                    }) {
                                        Label("Check Out", systemImage: "plus.circle")
                                            .font(.system(size: 15))
                                            .padding(8)
                                    }
                                    .frame(height: 12)
                                    
                                    
                            
                                }
                                //.background(Color("Color 1"))
                                .frame(minWidth: 170,maxWidth: 175)
                                .listStyle(SidebarListStyle())
                                
                            }else if userRole == "USER" {
                                List {
                                    Spacer()
                                    Button(action: {
                                        selectedTab = .stock
                                    }) {
                                        Label("Stoc", systemImage: "list.bullet")
                                            .font(.system(size: 15))
                                            .padding(8)
                                    }
                                    Button(action: {
                                        selectedTab = .billing
                                    }) {
                                        Label("Check Out", systemImage: "plus.circle")
                                            .font(.system(size: 15))
                                            .padding(8)
                                    }
                                    .frame(height: 12)


                            
                                }
                                //.background(Color("Color 1"))
                                .listStyle(SidebarListStyle())
                                .frame(minWidth: 100, idealWidth: 150, maxWidth: 300)
                                
                            }
                        } else {
                            // Tratați eroarea aici, de exemplu afișați un mesaj de eroare într-o alertă
                           EmptyView()
                        }

                   
                    switch selectedTab {
                    case .stock:
                        StockView()
                    case .meds:
                        MedsView()
                    case .addMeds:
                        AddMedsView()
                    case .billing:
                        BillingView()
                    case .sells:
                        SellsView()
                    case .none:
                        BillingView()
                    }
                    
                    
                }
                //.frame(maxHeight: 650)
                .onAppear{
                    getUserRole()
                }
            }
            
            //.frame(minWidth: 50, idealWidth: 50, maxWidth: 300)

        
        
    }
       
    private func getUserRole() {
        model.getUserRole { role, error in
            if let role = role {
                self.userRole = role
            } else if error != nil {
                // Tratează eroarea
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
