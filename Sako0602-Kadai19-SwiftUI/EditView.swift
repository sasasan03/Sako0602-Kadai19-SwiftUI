//
//  TestView.swift
//  Kadai16-Sako0602-SwiftUI
//
//  Created by sako0602 on 2023/01/28.
//

import SwiftUI

struct EditView: View {
    
    @Environment(\.dismiss) var dismiss
    @State var fruitNewItem: String
    @State private var textFruits = ""
    let save: (String) -> Void
    let cancel: () -> Void
    
    var body: some View {
        NavigationStack{
            HStack{
                Text("名前")
                TextField("", text: $fruitNewItem)
                    .frame(width: 210,height: 50)
                    .border(Color.black)
                    .padding()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel"){
                        cancel()
                        dismiss()
                    }
                }
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("save"){
                        save(fruitNewItem)
                        dismiss()
                    }
                }
            }
            .padding()
        }
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(
            fruitNewItem: "",
            save: { _ in },
            cancel: {}
        )
    }
}
