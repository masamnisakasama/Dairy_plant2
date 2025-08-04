//
//  LinearGradientProgressBar.swift
//  daily_routine_diary
//
//  Created by 池田まさひろ on 2025/07/27.
//
/*
 import SwiftUI
 
 struct LinearGradientProgressBar: View {
 var numerator: Double
 var denominator: Double
 
 var progress: Double {
 denominator == 0 ? 0 : min(numerator / denominator, 1.0)
 }
 
 var body: some View {
 GeometryReader { geometry in
 ZStack(alignment: .leading) {
 // 背景バー（灰色）
 RoundedRectangle(cornerRadius: 10)
 .frame(height: 20)
 .foregroundColor(Color.gray.opacity(0.3))
 
 // プログレスバー（グラデーション）
 RoundedRectangle(cornerRadius: 10)
 .frame(width: geometry.size.width * progress, height: 20)
 .foregroundStyle(
 LinearGradient(colors: [Color.blue, Color.green],
 startPoint: .leading,
 endPoint: .trailing)
 )
 }
 }
 .frame(height: 20)
 .animation(.easeOut(duration: 0.3), value: progress)
 }
 }
 
 */
