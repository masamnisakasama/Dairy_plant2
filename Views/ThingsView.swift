import SwiftUI
import SwiftData

struct ThingsView: View {
    
    @Environment(\.modelContext) private var context
    
    @Query(filter: Day.currentDayPredicate(), sort: \.date) private var today: [Day]
    @Query(filter: #Predicate<Thing> { $0.isHidden == false }) private var things: [Thing]
    
    @State private var showAddView: Bool = false
    @State private var showCongratsAlert: Bool = false
    @AppStorage("rewardText") private var rewardText: String = ""
    @AppStorage("lastShownDate") private var lastShownDate: String = ""
    @AppStorage("totalCompletedCount") private var totalCompletedCount: Int = 0
    
    var body: some View {
        ZStack {
            // グラデーション背景で自然で柔らかい印象に
            LinearGradient(
                gradient: Gradient(colors: [Color.green.opacity(0.4), Color.teal.opacity(0.3)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Spacer()
                
                Text("今日の目標決定")
                    .font(.system(size: 42, weight: .heavy, design: .rounded))
                    .foregroundColor(.black)
                    .shadow(radius: 3)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                if things.isEmpty {
                    VStack(spacing: 16) {
                        Image("things")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 280)
                            .shadow(radius: 6)
                        Text("Icons by Icons8")
                            .foregroundColor(.white.opacity(0.7))
                            .font(.footnote)
                        
                        ToolTipView(text: "小さいことから始めよう。下のボタンを押して今日のTo-Doリストを決めていこう!")
                            .padding()
                            .background(.thinMaterial)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                } else {
                    List {
                        ForEach(things) { thing in
                            let today = getToday()
                            HStack {
                                Text(thing.title)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                Spacer()
                                Button {
                                    if today.things.contains(thing) {
                                        today.things.removeAll { $0 == thing }
                                    } else {
                                        today.things.append(thing)
                                        thing.isHidden = true
                                        totalCompletedCount += 1
                                    }
                                    try? context.save()
                                    checkCompletion()
                                } label: {
                                    Image(systemName: today.things.contains(thing) ? "checkmark.circle.fill" : "checkmark.circle")
                                        .font(.title2)
                                        .foregroundStyle(today.things.contains(thing) ? .blue : .gray)
                                }
                                .buttonStyle(.plain)
                            }
                            .padding(.vertical, 8)
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                let thingToDelete = things[index]
                                let today = getToday()
                                today.things.removeAll { $0 == thingToDelete }
                                context.delete(thingToDelete)
                            }
                            try? context.save()
                            checkCompletion()
                        }
                    }
                    .listStyle(.insetGrouped)
                    .scrollContentBackground(.hidden)
                    .background(Color.white.opacity(0.1))
                    
                    ToolTipView(text: "タスクを終えたらチェックマークを押そう")
                        .font(.callout)
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.vertical, 8)
                }
                
                Spacer()
                
                Button("リストの追加") {
                    showAddView.toggle()
                }
                .font(.title2.bold())
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue.opacity(0.85))
                .foregroundColor(.white)
                .cornerRadius(14)
                .shadow(radius: 4)
                .padding(.horizontal)
                
                Spacer()
            }
            .sheet(isPresented: $showAddView) {
                AddThingView()
                    .presentationDetents([.fraction(0.3)])
                    .presentationDragIndicator(.visible)
            }
            .onAppear {
                checkCompletion()
            }
            .onChange(of: today.first?.things.count ?? 0) {
                checkCompletion()
            }
            /*
            .alert("お疲れ様です！", isPresented: $showCongratsAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(rewardText.isEmpty ? "ご褒美をどうぞ！" : "ご褒美をどうぞ！\n\(rewardText)")
                    .font(.system(size: 16))
            }
             */
        }
    }
    
    func getToday() -> Day {
        if let firstToday = today.first {
            return firstToday
        } else {
            let newToday = Day()
            context.insert(newToday)
            try? context.save()
            return newToday
        }
    }
    
    func checkCompletion() {
        let today = getToday()
        if !things.isEmpty && today.things.count == things.count {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let currentDateString = formatter.string(from: Date())
            
            if lastShownDate != currentDateString {
                showCongratsAlert = true
                lastShownDate = currentDateString
                totalCompletedCount += today.things.count
            }
        }
    }
}

