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
    enum SortOption: String, CaseIterable {
        case recent = "Recently Posted"
        case upvotes = "Number of Upvotes"
    }
    
    @EnvironmentObject var uploadVM: UploadViewModel
    @FirestoreQuery(collectionPath: "uploads") var uploads: [Upload]
    @State private var sheetIsPresented = false
    @State private var currentTime = Date()
    @State private var selectedSortOption: SortOption = .recent
    @Environment(\.dismiss) private var dismiss
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
                ZStack {
                    Rectangle()
                        .fill(Color.yellow)
                        .frame(width: 300, height: 40)
                        .cornerRadius(20)
                    Text(countdownString())
                        .font(.title2)
                        .bold()
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .padding(.horizontal)
                }
                
                Text("Today's Theme: \(todayAdj)")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.orange)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .padding(.bottom)
                
                Picker("Sort by:", selection: $selectedSortOption) {
                    ForEach(SortOption.allCases, id: \.self) { SortOption in
                        Text(SortOption.rawValue).tag(SortOption)
                    }
                }
                
                List {
                    ForEach(uploads.sorted(by: sortPosts), id: \.id) { upload in
                        NavigationLink {
                            VoteView(upload: upload, vote: Vote())
                        } label: {
                            Text(upload.name)
                        }
                        .bold()
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
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
            .background(
                LinearGradient(
                    gradient: Gradient(
                        colors: [Color.yellow.opacity(0.2), Color.yellow.opacity(0.1)]
                    ),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
            )
        }
        .background(
            LinearGradient(
                gradient: Gradient(
                    colors: [Color.yellow.opacity(0.2), Color.yellow.opacity(0.1)]
                ),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
        )
        .accentColor(.orange)
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
                UploadView(upload: Upload(), dailyAdjective: todayAdj)
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
    
    private func sortPosts(_ upload1: Upload, _ upload2: Upload) -> Bool {
        switch selectedSortOption {
        case .recent:
            return upload1.postedDate > upload2.postedDate
        case .upvotes:
            return upload1.upvotes > upload2.upvotes
        }
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
