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
    @State private var imageOffset: CGSize = .zero
    @State private var isDrawerOpen: Bool = false
    
    let pages:[Page] = PagesData
    @State private var  activePage: Int = 0
    
    func resetImage(){
        return withAnimation(.spring()){
            imageScale = 1
            imageOffset = .zero
        }
    }
    
    var body: some View {
        NavigationView{
            ZStack{
                Color.clear
                
                Image(PagesData[activePage].name)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                    .padding()
                    .shadow(radius: 10)
                    .opacity(isAnimating ? 1 : 0)
                    .animation(.linear(duration: 0.5), value: isAnimating)
                    .offset(imageOffset)
                    .scaleEffect(imageScale)
                    .onTapGesture(count: 2, perform: {
                        if imageScale == 1 {
                            withAnimation(.spring()){
                                imageScale = 5
                            }
                        } else{
                            resetImage()
                        }
                    })
                    .gesture(
                        DragGesture()
                            .onChanged{ value in
                                withAnimation(.linear(duration: 1)){
                                    imageOffset = value.translation
                                }
                            }
                            .onEnded{ _ in
                                withAnimation(.linear(duration: 0.5)){
                                    imageOffset = .zero
                                }
                            }
                        )
                    .gesture(
                     MagnificationGesture()
                        .onChanged({ value in
                            withAnimation(.linear(duration: 1)){
                                if imageScale >= 1 && imageScale < 5{
                                    imageScale = value
                                }
                            }
                        })
                        .onEnded({ _ in
                            withAnimation(.spring()){
                                if imageScale > 5 {
                                    imageScale = 5
                                } else if imageScale < 1 {
                                    resetImage()
                                }
                            }
                        })
                    )
                
                
            }
            .navigationTitle("Pinch and Zoom")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: {
                isAnimating = true
            })
            .overlay(
            InfoPanel(offset: imageOffset, scale: imageScale)
                .padding(.horizontal),
            alignment: .top
            )
            .overlay(
                HStack{
                    Button {
                        withAnimation(.spring()){
                            if imageScale > 1 {
                                imageScale -= 1
                            }
                        }
                    } label: {
                        Image(systemName: "minus.magnifyingglass")
                            .font(.system(size: 32))
                    }
                    Button {
                        withAnimation(.spring()){
                            resetImage()
                        }
                    } label: {
                        Image(systemName: "arrow.up.left.and.down.right.magnifyingglass")
                            .font(.system(size: 32))
                    }
                    Button {
                        withAnimation(.spring()){
                            if imageScale < 5 {
                                imageScale += 1
                            }
                        }
                    } label: {
                        Image(systemName: "plus.magnifyingglass")
                            .font(.system(size: 32))
                    }
                    
                }
                    .padding(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20))
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)
                    .opacity(isAnimating ? 1 : 0)
                    .animation(.linear(duration: 1), value: isAnimating)
                    
                ,alignment: .bottom
            )
            .overlay (
                HStack{
                    Image(systemName: isDrawerOpen ? "chevron.compact.right" : "chevron.compact.left")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                        .padding(8)
                        .onTapGesture {
                            withAnimation(.easeOut(duration: 0.3)){
                                isDrawerOpen.toggle()
                            }
                        }
                    ForEach(pages){ page in
                        Image("thumb-" + page.name)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80)
                            .cornerRadius(5)
                            .shadow(radius: 4)
                            .padding(.trailing, 10)
                            .onTapGesture(perform: {
                                withAnimation(.linear(duration: 0.5)){
                                    activePage = page.id
                                    isDrawerOpen = false
                                }
                                
                            })
                        
                    }
                }
                .padding(EdgeInsets(top: 12, leading: 8, bottom: 12, trailing: 8))
                .background(.ultraThinMaterial)
                .cornerRadius(10)
                .opacity(isAnimating ? 1 : 0)
                .animation(.linear(duration: 0.5), value: isAnimating)
                .frame(maxWidth: 260)
                .padding(.top, UIScreen.main.bounds.height / 2)
                .offset(x: isDrawerOpen ? 15 : 210)
                
                ,alignment: .topTrailing
                
            )
            
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
