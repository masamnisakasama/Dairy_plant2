//
//  PlantCardView.swift
//  daily_routine_diary
//
//  Created by 池田まさひろ on 2025/07/27.
//
import SwiftUI

struct PlantCardView: View {
    let plant: Plant
    let isLocked: Bool
    let remaining: Int

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(isLocked ? Color.white.opacity(0.3) : Color.white.opacity(0.9))
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)

            HStack(spacing: 16) {
                Image(systemName: isLocked ? "lock.circle.fill" : "leaf.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(isLocked ? .gray : .green)

                VStack(alignment: .leading, spacing: 6) {
                    Text(isLocked ? "？？？" : plant.name)
                        .font(.headline)
                        .foregroundColor(isLocked ? .gray : .primary)
                    
                    Text(isLocked ? "あと \(remaining) 回で解放" : plant.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
    }
}
