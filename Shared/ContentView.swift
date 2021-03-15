//
//  ContentView.swift
//  Shared
//
//  Created by Erik Mikac on 3/14/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var expenses = Expenses()
    @State private var showingAddExpense = false
    var body: some View {
        NavigationView {
            List {
                ForEach(expenses.items) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }
                        
                        Spacer()
                        
                        Text("$\(item.amount)")
                            .foregroundColor(styleUnder10(amount: item.amount) ? Color.green : styleUnder100(amount: item.amount) ? Color.blue : Color.red)
                          
                        
                    }
                }
                .onDelete(perform: removeItems)            }
                .navigationTitle("iExpense")
                .navigationBarItems(leading: EditButton()
                 ,trailing: Button(action: {
                self.showingAddExpense = true
            }){
                Image(systemName: "plus")
            })
                
        }
        .sheet(isPresented: $showingAddExpense) {
            AddView(expenses: self.expenses)
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
    
    func styleOverAmount100(amount: Int) -> Bool {
        return amount > 99
    }
    func styleUnder100(amount: Int) -> Bool {
        return amount <= 99
    }
    
    func styleUnder10(amount: Int) -> Bool {
        return amount <= 10
    }
}

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Int
}

class Expenses: ObservableObject {
    @Published var items = [ExpenseItem]() {
    didSet {
        print("Did Set!")
        let encoder = JSONEncoder()
        
        if let encoded = try?
            encoder.encode(items) {
            UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let items =
            UserDefaults.standard.data(forKey: "Items") {
            let decoder = JSONDecoder()
            
            if let decoded = try?
                decoder.decode([ExpenseItem].self, from: items) {
                self.items = decoded
                return
            }
        }
        self.items = []
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
