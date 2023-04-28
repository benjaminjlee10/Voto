//
//  MainView.swift
//  Voto
//
//  Created by Benjamin Lee on 4/26/23.
// 

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct MainView: View {
    @EnvironmentObject var uploadVM: UploadViewModel
    @FirestoreQuery(collectionPath: "uploads") var uploads: [Upload]
    @State private var sheetIsPresented = false
    @Environment(\.dismiss) private var dismiss
    @State private var currentTime = Date()
    @State var user: User
    
    @AppStorage("adjective") private var todayAdj = ""
    @AppStorage("lastAdjectiveUpdate") private var lastAdjectiveUpdate = Date.distantPast.timeIntervalSince1970
    
    private var randomAdjective: String {
        let adjectives = ["amazing", "fantastic", "wonderful", "marvelous", "terrific"]
        return adjectives.randomElement()!
    }
    
    private var shouldUpdateAdjective: Bool {
        let calendar = Calendar.current
        let lastUpdateComponents = calendar.dateComponents([.year, .month, .day], from: Date(timeIntervalSince1970: lastAdjectiveUpdate))
        let currentComponents = calendar.dateComponents([.year, .month, .day], from: currentTime)
        
        if lastUpdateComponents != currentComponents {
            lastAdjectiveUpdate = currentTime.timeIntervalSince1970
            todayAdj = randomAdjective
            return true
        }
        else {
            return false
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Text(countdownString())
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .padding(.bottom)
                
//                if shouldUpdateAdjective {
//                    Task {
//                        print("changed today's adjective")
//                    }
//                }
                
                Text("Today's Theme: \(todayAdj)")
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .padding(.bottom)
                
                List {
                    ForEach(uploads) { upload in
                        NavigationLink {
                            VoteView(upload: upload, vote: Vote())
                        } label: {
                            Text(upload.name)
                        }
                    }
                }
                .listStyle(.plain)
                .navigationTitle("Posts of the Day")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            sheetIsPresented.toggle()
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                updateTime()
            }
            if shouldUpdateAdjective || todayAdj == "" {
                todayAdj = randomAdjective
            }
        }
        .sheet(isPresented: $sheetIsPresented) {
            NavigationStack {
                UploadView(upload: Upload())
            }
        }
    }
    
    private func updateTime() {
        let calendar = Calendar.current
        let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: Date())!
        let startOfTomorrow = calendar.date(byAdding: .day, value: 1, to: endOfDay)!
        let interval = endOfDay.timeIntervalSince(currentTime)
        if interval <= 0 {
            currentTime = startOfTomorrow
        } else {
            currentTime = Date()
        }
    }
    
    private func countdownString() -> String {
        let calendar = Calendar.current
        let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: Date())!
        let interval = endOfDay.timeIntervalSince(currentTime)
        let hours = Int(interval) / 3600
        let minutes = Int(interval) / 60 % 60
        let seconds = Int(interval) % 60
        return String(format: "Time Remaining: %02d:%02d:%02d", hours, minutes, seconds)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(user: User())
            .environmentObject(UploadViewModel())
    }
}

private extension Date {
    var hourAndMinute: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
}
