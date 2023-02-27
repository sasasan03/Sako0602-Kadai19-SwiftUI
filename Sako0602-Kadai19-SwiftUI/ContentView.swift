//
//  ContentView.swift
//  Sako0602-Kadai19-SwiftUI
//
//  Created by sako0602 on 2023/02/21.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isPresentedAddView = false
    @State private var isPresentedEditVIew = false
    @State var editFruit: FruitsData? = nil
    @State private var fruitArray = [
        FruitsData(name: "りんご", isChecked: false),
        FruitsData(name: "みかん", isChecked: true),
        FruitsData(name: "バナナ", isChecked: false),
        FruitsData(name: "パイナップル", isChecked: true)
    ]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(fruitArray.indices, id: \.self) { index in
                    HStack{
                        Button {
                            fruitArray[index].isChecked.toggle()
                            saveData()
                        } label: {
                            HStack{
                                Image(systemName: fruitArray[index].isChecked
                                      ? "checkmark"
                                      : ""
                                )
                                .foregroundColor(Color.red)
                                .frame(width: 30, height: 30)
                                Text(fruitArray[index].name)
                            }
                        }
                        .foregroundColor(Color.black)
                        Spacer()
                        Button {
                            editFruit = fruitArray[index]
                        } label: {
                            Image(systemName: "info.circle")
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }.onDelete { fruitIndex in
                    fruitArray.remove(atOffsets: fruitIndex)
                    saveData()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isPresentedAddView = true
                    }, label: {
                        Image(systemName: "plus")
                    })
                    .padding()
                }
            }
            .sheet(isPresented: $isPresentedAddView) {
                FruitsAddView(
                    save: { name in
                        fruitArray.append(FruitsData(name: name, isChecked: false))
                        saveData()
                        isPresentedAddView = false
                    } ,cancel: {
                        isPresentedAddView = false
                    }
                )
            }
            .sheet(item: $editFruit) { editFruit in
                EditView (
                    fruitNewItem: editFruit.name,
                    save: { name in
                        guard let index = fruitArray.firstIndex(where: {
                            $0.id == editFruit.id
                        }) else { return }
                        fruitArray[index].name = name
                        fruitArray[index].isChecked = false
                        saveData()
                        isPresentedEditVIew = false
                    },
                    cancel: {
                        isPresentedEditVIew = false
                    }
                )
            }
            .onAppear(){
                guard let fruitLoadData = loadData() else{
                    return
                }
                fruitArray = fruitLoadData
            }
        }
    }
    
    func saveData() {
        let jsonEncoder = JSONEncoder()
        guard let data = try? jsonEncoder.encode(fruitArray) else {
            return
        }
        UserDefaults.standard.set(data, forKey: "data")
    }
    
    func loadData() -> [FruitsData]? {
        let jsonDecoder = JSONDecoder()
        guard let data = UserDefaults.standard.data(forKey: "data"),
              let array = try? jsonDecoder.decode([FruitsData].self, from: data) else {
            return nil
        }
        return array
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
