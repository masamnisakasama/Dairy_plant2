import SwiftUI
import SwiftData

struct TodayView: View {
    
    @Environment(\.modelContext) private var context
    @Binding var selectedTab: Tab
    
    @Query(filter: Day.currentDayPredicate(), sort: \.date) private var today: [Day]
    @Query(filter: #Predicate<Thing> { !$0.isHidden }) private var things: [Thing]
    
    var body: some View {
        ZStack {
            // 背景：グラデーション + ブラー付きのレイヤーで深みを出す
            LinearGradient(
                gradient: Gradient(colors: [Color.green.opacity(0.4), Color.teal.opacity(0.3)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Spacer(minLength: 20)
                
                Text("植物習慣帳")
                    .font(.system(size: 48, weight: .heavy, design: .rounded))
                    .foregroundStyle(LinearGradient(colors: [.green, .mint], startPoint: .leading, endPoint: .trailing))
                    .padding(.top)
                
                Text("今日のやることリストを決めよう！")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.black)
                    .padding(.bottom, 8)

                if getToday().things.count > 0 {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(getToday().things) { thing in
                                HStack {
                                    Image(systemName: "leaf.circle.fill")
                                        .foregroundColor(.green)
                                        .imageScale(.large)
                                    
                                    VStack(alignment: .leading) {
                                        Text(thing.title)
                                            .font(.headline)
                                            .foregroundColor(.primary)
                                    }
                                    Spacer()
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.white.opacity(0.9))
                                        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
                                )
                                .padding(.horizontal)
                            }
                        }
                        .padding(.top)
                    }

                    ToolTipView(text: "🌿 Good Job! いいですね！")
                        .font(.system(size: 22))
                    
                    ToolTipView(text: "あなたは今日 \(getToday().things.count) 個のタスクを終えました。ナイスワーク！")
                        .font(.caption)
                        .foregroundColor(.gray)

                    Spacer()
                    
                } else {
                    Spacer()

                    HStack(spacing: 16) {
                        Image("today1")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 150)
                        Image("today2")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 150)
                    }

                    Text("Icons by Icons8")
                        .foregroundColor(.gray)
                        .font(.caption)

                    ToolTipView(text: "一日一日を大切に過ごそう。\n下のボタンから今日のタスクを登録しよう！")
                        .padding()
                        .foregroundColor(.white)

                    Button(action: {
                        selectedTab = Tab.things
                    }) {
                        Text("登録")
                            .font(.title2.bold())
                            .padding()
                            .frame(maxWidth: 200)
                            .background(
                                LinearGradient(colors: [.green, .mint], startPoint: .leading, endPoint: .trailing)
                            )
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(radius: 4)
                    }
                    .padding(.top)

                    Spacer()
                }
            }
            .padding()
        }
    }

    func getToday() -> Day {
        if let existing = today.first {
            return existing
        } else {
            let newDay = Day()
            context.insert(newDay)
            try? context.save()
            return newDay
        }
    }
}

#Preview {
    TodayView(selectedTab: Binding.constant(.today))
}

