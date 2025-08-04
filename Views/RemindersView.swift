

import SwiftUI
import SwiftData
import UserNotifications

struct RemindersView: View {
    
    @AppStorage("ReminderTime") private var reminderTime: Double = Date().timeIntervalSince1970
    
    @AppStorage("RemindersOn") private var isRemindersOn = false
    @State private var selectedDate = Date().addingTimeInterval(86400)
    @State private var isSettingsDialogShowing = false
    
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: selectedDate)
    }
    
    var body: some View {
        ZStack{
            LinearGradient(
                gradient: Gradient(colors: [Color.green.opacity(0.4), Color.teal.opacity(0.3)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        VStack(spacing: 20) {
            Spacer()
            Text("リマインダー")
                .font(.system(size: 48, weight: .heavy, design: .rounded))
                .foregroundColor(.black)
                .shadow(radius: 3)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Spacer()
            ToolTipView(text: "下のボタンを押してリマインダーを設定しよう")
                .font(.system(size:15))
                .frame(maxWidth: .infinity, alignment: .center)
            Spacer()
            
            Toggle(isOn: $isRemindersOn) {
                Text("リマインダーを設定:")
                    .font(.system(size:20))
            }
            .padding()
            if isRemindersOn {
                HStack {
                    Text("何時に設定する？")
                    Spacer()
                    DatePicker("", selection: $selectedDate, displayedComponents: .hourAndMinute)
                }
                .padding()
                
                // Tooltip saying when reminders are set for
                VStack(alignment: .leading, spacing: 10) {
                    Text(Image(systemName: "bell.and.waves.left.and.right"))
                    Text("\(formattedTime) に通知を受け取ります。")
                }
                .foregroundStyle(Color.blue)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(Color.blue, lineWidth: 1)
                        .background(Color("light-blue"))
                }
            }
            else {
                // Tooltip to turn reminders on
                ToolTipView(text: "リマインダーを設定して日々の管理に役だてよう！")
            }
            
            Spacer()
            HStack{
                Image("reminders")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 300)
                
                Image("reminders2")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 300)
            }
            Text("Icons by Icons8")
                .foregroundColor(Color.gray)
            
            Spacer()
        }}
        .padding(.trailing, 2)
        .onAppear(perform: {
            selectedDate = Date(timeIntervalSince1970: reminderTime)
        })
        .onChange(of: isRemindersOn) { oldValue, newValue in
            let notificationCenter = UNUserNotificationCenter.current()
            
            notificationCenter.getNotificationSettings { settings in
                switch settings.authorizationStatus {
                case .authorized:
                    if newValue {
                        print("通知が許可されました。")
                        scheduleNotifications()
                    } else {
                        print("通知をオフにしたため、通知をキャンセルします。")
                        notificationCenter.removeAllPendingNotificationRequests()
                    }
                case .denied:
                    print("通知が拒否されました。")
                    isRemindersOn = false
                    isSettingsDialogShowing = true
                case .notDetermined:
                    print("通知の許可を確認してください")
                    requestNotificationPermission()
                default:
                    break
                }
            }
        }
        .onChange(of: selectedDate) { oldValue, newValue in
            let notificationCenter = UNUserNotificationCenter.current()
            
            // 日付が変わるとリマインダーをリセット
            notificationCenter.removeAllPendingNotificationRequests()
            
            // 新しいリマインダーをスケジュール
            scheduleNotifications()
            
            // 新しい時間をセーブ
            reminderTime = selectedDate.timeIntervalSince1970
        }
        .alert(isPresented: $isSettingsDialogShowing) {
            
            Alert(title: Text("通知が拒否されました。"), message: Text("通知が許可されていないため、リマインダーが送られません。設定で通知を許可してください。"), primaryButton: .default(Text("設定に進む"), action: {
                // 設定
                goToSettings()
            }), secondaryButton: .cancel())
        }
    }
    
    func goToSettings() {
        
        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
            
            if UIApplication.shared.canOpenURL(appSettings) {
                
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        }
    }
    
    func requestNotificationPermission() {
        let notificationCenter = UNUserNotificationCenter.current()

        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("権限が許可されました。")
                // 通知をスケジュール
                scheduleNotifications()
                
            } else {
                print("権限が拒否されました。")
                isRemindersOn = false
                // 許可がなく通知を送れない場合
                isSettingsDialogShowing = true
            }

            if let error = error {
                print("リクエスト許可のエラー: \(error.localizedDescription)")
            }
        }
    }
    
    func scheduleNotifications() {
        
        let notificationCenter = UNUserNotificationCenter.current()

        // 通知を作成
        let content = UNMutableNotificationContent()
        content.title = "毎日週間帳"
        content.body = "今日も課題を成し遂げよう！"
        content.sound = .default

       
        var dateComponents = DateComponents()
        dateComponents.hour = Calendar.autoupdatingCurrent.component(.hour, from: selectedDate)
        dateComponents.minute = Calendar.autoupdatingCurrent.component(.minute, from: selectedDate)

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

       
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // 通知をスケジュールする
        notificationCenter.add(request) { error in
            if let error = error {
                print("通知のスケジュールエラー: \(error.localizedDescription)")
            } else {
                print("今日の通知が設定されました。")
            }
        }
    }
}

#Preview {
    RemindersView()
}
