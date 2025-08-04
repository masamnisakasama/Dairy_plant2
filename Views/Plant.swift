//
//  Plant.swift
//  daily_routine_diary
//
//  Created by 池田まさひろ on 2025/07/27.
//
import Foundation

struct Plant: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
    let unlockThreshold: Int
    let description: String  // ← 説明を追加
}
