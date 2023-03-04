//
//  ContentView.swift
//  Sako0602-Kadai19-SwiftUI
//
//  Created by sako0602 on 2023/02/21.
//

import SwiftUI

struct ContentView: View {

    enum Error: Swift.Error {
        case saveError
        case loadError
    }
    
    @State private var isPresentedAddView = false
    @State private var isPresentedEditVIew = false
    @State var editFruit: FruitsData? = nil
    @State private var fruitArray = [
        FruitsData(name: "りんご", isChecked: false),
        FruitsData(name: "みかん", isChecked: true),
        FruitsData(name: "バナナ", isChecked: false),
        FruitsData(name: "パイナップル", isChecked: true)
    ]
    
    private let userDefaultsKey = "data"

    var body: some View {
        NavigationStack {
            List {
                ForEach(fruitArray.indices, id: \.self) { index in
                    HStack{
                        Button {
                            do {
                                fruitArray[index].isChecked.toggle()
                                try saveData()
                            } catch {
                                // ユーザーにエラー発生を提示する場合はここで処理する
                            }
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
                    do {
                        fruitArray.remove(atOffsets: fruitIndex)
                        try saveData()
                    } catch {
                        // ユーザーにエラー発生を提示する場合はここで処理する
                    }
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
                        do {
                            fruitArray.append(FruitsData(name: name, isChecked: false))
                            try saveData()
                            isPresentedAddView = false
                        } catch {
                            // ユーザーにエラー発生を提示する場合はここで処理する
                        }
                    } ,cancel: {
                        isPresentedAddView = false
                    }
                )
            }
            .sheet(item: $editFruit) { editFruit in
                EditView (
                    fruitNewItem: editFruit.name,
                    save: { name in
                        do {
                            guard let index = fruitArray.firstIndex(where: {
                                $0.id == editFruit.id
                            }) else { return }
                            fruitArray[index].name = name
                            fruitArray[index].isChecked = false
                            try saveData()
                            isPresentedEditVIew = false
                        } catch {
                            // ユーザーにエラー発生を提示する場合はここで処理する
                        }
                    },
                    cancel: {
                        isPresentedEditVIew = false
                    }
                )
            }
            .onAppear(){
                do {
                    fruitArray = try loadData()
                } catch {
                    // ユーザーにエラー発生を提示する場合はここで処理する
                }
            }
        }
    }

    private func saveData() throws {
        let jsonEncoder = JSONEncoder()
        guard let data = try? jsonEncoder.encode(fruitArray) else {
            throw Error.saveError
        }
        UserDefaults.standard.set(data, forKey: userDefaultsKey)
    }
    
    private func loadData() throws -> [FruitsData] {
        let jsonDecoder = JSONDecoder()
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey),
              let array = try? jsonDecoder.decode([FruitsData].self, from: data) else {
            throw Error.loadError
        }
        return array
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
