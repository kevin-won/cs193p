//
//  ContentView.swift
//  a1
//
//  Created by Kevin Won on 6/13/22.
//

import SwiftUI

struct ContentView: View {
    var vehicleEmojis = ["🚝", "🚛", "🏍", "🛩", "✈️", "🚒", "🛴", "🚑", "🚂"]
    var animalEmojis = ["🐎", "🦕", "🐊", "🐳", "🦖", "🐿", "🦙", "🐃", "🐶"]
    var faceEmojis = ["😤", "😃", "😇", "🙃", "😂", "😧", "🤥", "🥹", "🥰", "🥸"]
    @State var emojis = ["🚝", "🚛", "🏍", "🛩", "✈️", "🚒", "🛴", "🚑", "🚂"]
    var body: some View {
        VStack {
            Text("Memorize!")
                .font(.title)
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 75))]) {
                    ForEach(emojis, id: \.self, content: { emoji in
                        CardView(content: emoji).aspectRatio(2/3, contentMode: .fit)
                    })
                }
                .padding()
            }
            .foregroundColor(.red)
            Spacer()
            HStack(spacing: 40) {
                VStack {
                    vehicleButton
                    Text("Vehicles")
                        .font(.footnote)
                        .foregroundColor(Color.blue)
                }
                VStack {
                    animalButton
                    Text("Animals")
                        .font(.footnote)
                        .foregroundColor(Color.blue)
                }
                VStack {
                    faceButton
                    Text("Faces")
                        .font(.footnote)
                        .foregroundColor(Color.blue)
                }
            }
            .font(.largeTitle)
            .padding(.horizontal)
        }
    }
    var vehicleButton: some View {
        Button(action: {
            emojis = vehicleEmojis.shuffled()
        }, label: {
            Image(systemName: "car")
        })
    }
    
    var animalButton: some View {
        Button(action: {
            emojis = animalEmojis.shuffled()
        }, label: {
            Image(systemName: "pawprint.fill")
        })
    }
    var faceButton: some View {
        Button(action: {
            emojis = faceEmojis.shuffled()
        }, label: {
            Image(systemName: "face.smiling")
        })
    }
    

}

struct CardView: View {
    var content: String
    @State var isFaceUp: Bool = true
    
    var body : some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 20)
            if isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.stroke(lineWidth: 3)
                Text(content).font(.largeTitle)
            } else {
                shape.fill()
            }
        }
        .onTapGesture {
            isFaceUp = !isFaceUp
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
