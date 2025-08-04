//
//  PlantListView.swift
//  daily_routine_diary
//
//  Created by 池田まさひろ on 2025/07/27.
//

import SwiftUI

struct PlantListView: View {
    @AppStorage("totalCompletedCount") private var totalCompletedCount: Int = 0
    
    private let plants: [Plant] = [
        Plant(name: "クローバー", imageName: "clover", unlockThreshold: 0,
              description: "幸運の象徴として知られるクローバー。棍棒を意味する「クラブ」から名がとられている。"),
        Plant(name: "チューリップ", imageName: "tulip", unlockThreshold: 5,
              description: "鮮やかな花弁のチューリップ。チューリップの美しさに惹かれ、17世紀には「チューリップバブル」が起こったとか。"),
        Plant(name: "ひまわり", imageName: "sunflower", unlockThreshold: 15,
              description: "太陽に向かって咲くひまわり。衛星「ひまわり一号」が打ち上げられた7月14日はひまわりの日と呼ばれている。"),
        Plant(name: "バラ", imageName: "rose", unlockThreshold: 35,
              description: "気品あふれるバラ。一説によると7000年前から存在していたとか。"),
        Plant(name: "さくら", imageName: "sakura", unlockThreshold: 60,
              description: "春に満開となる桜。ソメイヨシノは全てクローンであり、同じ場所では同じ時期に咲く。"),
        Plant(name: "モミジ", imageName: "momiji", unlockThreshold: 100,
              description: "秋に赤く染まるモミジ。もともとは「揉出」(もみづ)という、染料を揉んで染色する様子から来ている。"),
        Plant(name: "ネモフィラ", imageName: "nemophila", unlockThreshold: 140,
              description: "一面に咲く青い花で有名なネモフィラ。森の周辺に群生し、「nemos(小さな森)」と「phileo(愛する)」というギリシャ語に由来する。"),
        Plant(name: "スイレン", imageName: "waterlily", unlockThreshold: 200,
              description: "水面に浮かぶように咲くスイレン。潜っては咲くので、古代エジプトでは「再生の象徴」とされた。"),
        Plant(name: "ラベンダー", imageName: "lavender", unlockThreshold: 260,
              description: "淡い紫色の香り高い花。ラテン語の「洗う(lavare)」から来ており、古代ローマ人は入浴時に匂いを楽しんだとされる。"),
        Plant(name: "ヒガンバナ", imageName: "redspiderlily", unlockThreshold: 330,
              description: "触るとかぶれる。「彼岸(春分や秋分)」に咲く花なので、彼岸花と呼ばれるようになった")
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color.green.opacity(0.3), Color.blue.opacity(0.2)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(plants) { plant in
                            if totalCompletedCount >= plant.unlockThreshold {
                                NavigationLink(destination: PlantDetailView(plant: plant)) {
                                    PlantCardView(plant: plant, isLocked: false, remaining: 0)
                                }
                                .buttonStyle(.plain)
                            } else {
                                PlantCardView(plant: plant, isLocked: true, remaining: plant.unlockThreshold - totalCompletedCount)
                            }
                        }
                    }
                    .padding()
                }
                .navigationTitle("植物図鑑")
            }
        }
    }
}

