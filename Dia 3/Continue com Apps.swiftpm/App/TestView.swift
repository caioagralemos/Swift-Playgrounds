//
//  SwiftUIView.swift
//  
//
//  Created by Stephen Wakulchik on 1/4/22.
//

import SwiftUI

struct TestView: View {
    @State var isOn = false
    
    var body: some View {
        VStack {
            Button("Press Me") {
                isOn.toggle()
            }

            Circle()
                .frame(maxHeight: 200)
                .foregroundColor(isOn ? .yellow : .black)
                .shadow(color: isOn ? .red : .green, radius: 8)
                .animation(.default, value: isOn)
            

        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
