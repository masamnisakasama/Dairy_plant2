import SwiftUI
import SwiftData

struct SettingsView: View {
    @Query(sort: \Day.date) private var allDays: [Day]
    @Query(filter: #Predicate<Thing> { !$0.isHidden }) private var things: [Thing]
    @Environment(\.modelContext) private var context

    @AppStorage("rewardText") private var rewardText: String = ""
    @AppStorage("totalCompletedCount") private var totalCompletedCount: Int = 0
    @State private var isShowingRewardInput = false

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.85, green: 0.95, blue: 0.95),
                    Color(red: 0.70, green: 0.85, blue: 0.85)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                Spacer()

                Text("設定")
                    .font(.system(size: 50, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .center)

                // 達成数の表示とコメント
                VStack(spacing: 8) {
                    Text("🌱 今までに達成したタスク数")
                        .bold()
                        .font(.system(size: 20))

                    Text("\(totalCompletedCount) 回")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.green)

                    Text(progressMessage)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding()

                // ご褒美表示と入力ボタン
                VStack(spacing: 8) {
                    Text("🎁 毎日のタスク全完了後のご褒美")
                        .bold()
                        .font(.system(size: 18))

                    Text(rewardText.isEmpty ? "まだご褒美は設定されていません" : rewardText)
                        .foregroundColor(rewardText.isEmpty ? .gray : .primary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .font(.system(size: 15))

                    Button(action: {
                        isShowingRewardInput = true
                    }) {
                        Text("ご褒美を入力・編集する")
                            .font(.headline)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()

                Spacer()

                // カード風リンク群
                VStack(spacing: 16) {
                    Link(destination: URL(string: "https://apps.apple.com/app/id6749202473?action=write-review")!) {
                        HStack {
                            Image(systemName: "star.bubble.fill")
                                .foregroundColor(.yellow)
                                .font(.system(size: 30))
                                .frame(width: 40)
                            Text("アプリを評価する")
                                .font(.title3)
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
                    }

                    ShareLink(item: URL(string: "https://apps.apple.com/app/id6749202473")!) {
                        HStack {
                            Image(systemName: "square.and.arrow.up.fill")
                                .foregroundColor(.blue)
                                .font(.system(size: 30))
                                .frame(width: 40)
                            Text("このアプリを勧める")
                                .font(.title3)
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
                    }

                    Link(destination: URL(string: "https://drive.google.com/file/d/1Sqam7K4Qb67m9E-S6N5lVehDrxgR6eoH/view?usp=sharing")!) {
                        HStack {
                            Image(systemName: "doc.text.magnifyingglass")
                                .foregroundColor(.green)
                                .font(.system(size: 30))
                                .frame(width: 40)
                            Text("プライバシーポリシー")
                                .font(.title3)
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
                    }
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding()
        }
        .sheet(isPresented: $isShowingRewardInput) {
            RewardInputView(rewardText: $rewardText, isPresented: $isShowingRewardInput)
        }
    }

    // 達成数に応じた励ましコメント
    var progressMessage: String {
        switch totalCompletedCount {
        case 0:
            return "まだ始まったばかりです！今日から始めましょう 🌱"
        case 1..<10:
            return "いいスタートです！続けてみましょう 🌿"
        case 10..<50:
            return "素晴らしい習慣ができてきました 🌼"
        case 50..<150:
            return "頑張りが花開くようです！🌻"
        case 150..<300:
            return "あなたの努力が光り輝いています！！ 🌸✨"
        
        default:
            return "継続を具現化したような存在ですね！🌷"
        }
    }
}

// ご褒美入力用ビュー（元コードのまま）
struct RewardInputView: View {
    @Binding var rewardText: String
    @Binding var isPresented: Bool

    @State private var draftText: String = ""

    var body: some View {
        NavigationView {
            VStack {
                TextField("ご褒美を入力してください", text: $draftText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Spacer()
            }
            .navigationTitle("ご褒美入力")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        rewardText = draftText
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") {
                        isPresented = false
                    }
                }
            }
            .onAppear {
                draftText = rewardText
            }
        }
    }
}

