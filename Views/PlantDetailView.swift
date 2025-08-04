//
//  PlantDetailView.swift
//  daily_routine_diary
//
//  Created by 池田まさひろ on 2025/07/27.
//

import SwiftUI

struct PlantDetailView: View {
    let plant: Plant
    
    var body: some View {
        VStack(spacing: 20) {
            Image(plant.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxHeight: 300)
                .shadow(radius: 10)
            
            Text(plant.name)
                .font(.largeTitle)
                .bold()
            
            ToolTipView(text:plant.description)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()
            
            Spacer()
        }
        .padding()
        .navigationTitle(plant.name)
    }
}
