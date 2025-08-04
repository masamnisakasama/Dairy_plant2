//
//  WeeklyBarGraphView.swift
//  daily_routine_diary
//
//  Created by 池田まさひろ on 2025/07/27.

import SwiftUI

struct weeklyBarGraphViewv2: View {
    var dailyCounts: [Int]
    
    var maxCount: Int {
        max(dailyCounts.max() ?? 1, 1)  // 0除算防止のため1以上
    }
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 16) {
            ForEach(0..<dailyCounts.count, id: \.self) { i in
                let height = CGFloat(dailyCounts[i]) / CGFloat(maxCount) * 150
                
                VStack {
                    Text("\(dailyCounts[i])")
                        .font(.caption2)
                        .rotationEffect(.degrees(-45))
                        .offset(y: -4)
                    Rectangle()
                        .fill(Color.blue.gradient)
                        .frame(width: 20, height: max(0, height))  // ここを修正
                        .cornerRadius(4)
                    Text(shortDayString(for: i))
                        .font(.caption2)
                }
            }
        }
        .padding()
    }
    
    func shortDayString(for index: Int) -> String {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        guard let dayDate = calendar.date(byAdding: .day, value: index - 6, to: today) else {
            return ""
        }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "E"
        return formatter.string(from: dayDate)
    }
}

struct WeeklyBarGraphView: View {
    
    var dailyCounts: [Int]
    
    var maxCount: Int {
        max(dailyCounts.max() ?? 1, 1) // 0除算防止
    }
    
    var body: some View {
        ToolTipView(text:"過去7日のタスク完了数")
            .font(.system(size: 35))
            .frame(maxWidth: .infinity, alignment: .center)
        
        HStack(alignment: .bottom, spacing: 24) {
            ForEach(0..<dailyCounts.count, id: \.self) { i in
                let height = CGFloat(dailyCounts[i]) / CGFloat(maxCount) * 150
                
                VStack {
                    Text("\(dailyCounts[i])")
                        .font(.caption2)
                        .rotationEffect(.degrees(-45))
                        .offset(y: -4)
                        .font(.system(size: 15))
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.blue]),
                                startPoint: .bottom,
                                endPoint: .top
                            )
                        )
                        .frame(width: 20, height: max(0, height))
                        .shadow(color: Color.blue.opacity(0.4), radius: 4, x: 0, y: 2)
                    
                    Text(shortDayString(for: i))
                        .font(.caption2)
                        .font(.system(size: 15))
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.blue, lineWidth: 2)
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)
        )
        .padding()
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    
    func shortDayString(for index: Int) -> String {
        let calendar = Calendar.current
        
        // 今週の月曜日を取得（日本のカレンダーは週の始まりが月曜）
        guard let weekStart = calendar.dateInterval(of: .weekOfYear, for: Date())?.start else {
            return ""
        }
        
        // index日後の日付を計算（月曜 + index日）
        guard let dayDate = calendar.date(byAdding: .day, value: index, to: weekStart) else {
            return ""
        }
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "E"  // 短縮曜日表示（例: 月, 火, 水）
        
        return formatter.string(from: dayDate)
    }
}

// 過去7日間の「完了タスク数」を返す

/*
func getDay(for date: Date) -> Day? {
    let calendar = Calendar.current
    return allDays.first(where: { calendar.isDate($0.date, inSameDayAs: date) })
}

func getCompletedTasksForLast7Days() -> [Int] {
    let calendar = Calendar.current
    let today = calendar.startOfDay(for: Date())
    var results: [Int] = []

    for offset in (0..<7).reversed() {
        guard let dayDate = calendar.date(byAdding: .day, value: -offset, to: today) else {
            results.append(0)
            continue
        }
        
        if let day = getDay(for: dayDate) {
            results.append(day.things.count)  // 完了タスク数が things.count ならここでカウント
        } else {
            results.append(0)
        }
    }
    return results
}
func shortDayString(for index: Int) -> String {
    let calendar = Calendar.current

    // 今週の月曜日を取得（日本のカレンダーは週の始まりが月曜）
    guard let weekStart = calendar.dateInterval(of: .weekOfYear, for: Date())?.start else {
        return ""
    }

    // index日後の日付を計算（月曜 + index日）
    guard let dayDate = calendar.date(byAdding: .day, value: index, to: weekStart) else {
        return ""
    }

    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ja_JP")
    formatter.dateFormat = "E"  // 短縮曜日表示（例: 月, 火, 水）

    return formatter.string(from: dayDate)
}

func createMailUrl() -> URL? {
    var mailUrlComponents = URLComponents()
    mailUrlComponents.scheme = "mailto"
    mailUrlComponents.path = ""
    mailUrlComponents.queryItems = [
        URLQueryItem(name: "subject", value: "毎日週間帳へのフィードバック")
    ]
    return mailUrlComponents.url
}

WeeklyBarGraphView(dailyCounts: getCompletedTasksForLast7Days())
    .padding(.horizontal)
*/
