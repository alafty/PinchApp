//
//  ContentView.swift
//  Pinch
//
//  Created by Mohamed El-Alafty on 25/07/2022.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isAnimating: Bool = false
    @State private var imageScale: CGFloat = 1
    var body: some View {
        NavigationView{
            ZStack{
                Image("magazine-front-cover")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                    .padding()
                    .shadow(radius: 10)
                    .opacity(isAnimating ? 1 : 0)
                    .animation(.linear(duration: 0.5), value: isAnimating)
                    .scaleEffect(imageScale)
                    .onTapGesture(count: 2, perform: {
                        if imageScale == 1 {
                            withAnimation(.spring()){
                                imageScale = 5
                            }
                        } else{
                            withAnimation(.spring()){
                                imageScale = 1
                            }
                        }
                    })
                
                
            }
            .navigationTitle("Pinch and Zoom")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: {
                isAnimating = true
            })
        }
        .navigationViewStyle(.stack)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
