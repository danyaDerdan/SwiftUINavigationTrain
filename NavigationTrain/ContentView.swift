import SwiftUI

struct ContentView: View {
    @State var isSettingsOpen = false
    @ObservedObject var settings = Settings()
    var body: some View {
        
        NavigationStack() {
            VStack(spacing: 50) {
                Label("Notifications - \(settings.isNotificationsOn ? "On" : "Off")", systemImage: "person.crop.circle").foregroundStyle(settings.colors[settings.colorIndex])
            }
            .navigationTitle("Меню")
            .navigationDestination(isPresented: $isSettingsOpen) {SettingsView()}
            .navigationBarItems(
                trailing: Button(action: {isSettingsOpen = true},
                                 label: {Label("Setting", systemImage: "gearshape")}) )
            .navigationBarTitleDisplayMode(.inline)
            
                    
            
        }
        .environmentObject(settings)
    }
}

class Settings: ObservableObject {
    @Published var colorIndex = 0
    @Published var isNotificationsOn = false
    let colors: [Color] = [.black, .red, .blue, .yellow]
}

struct SettingsView : View {
    @EnvironmentObject var settings : Settings
    var body: some View {
        NavigationView {
            VStack{
                Form {
                    Section(header: Text("General"), footer: Text("Lets go")) {
                        Picker(selection: Binding(get: { settings.colorIndex }, set: {
                            settings.colorIndex = $0
                        }),
                               label: Label("Color", systemImage: "circle.fill").foregroundStyle(settings.colors[settings.colorIndex]),
                               content: {
                            ForEach(0..<settings.colors.count, id: \.self) {
                                Text(settings.colors[$0].description.capitalized).tag($0)
                            }
                        })
                        Toggle(isOn: Binding(get: {settings.isNotificationsOn}, set: { settings.isNotificationsOn = $0})) {
                        Label("Enable notifications", systemImage: "bell.fill")
                    }
                    }.navigationTitle("Settings")
                    Section(header: Text("Notifications"), footer: Text("This header is about notifications")) {
                        Text("Notifications are enabled: \(settings.isNotificationsOn.description)")
                        Button("Toggle notifications") { settings.isNotificationsOn.toggle() }
                    }
                }
                Text("Settings page").padding()
            }
        }.animation(.spring(), value: settings.colorIndex)
    }
}

#Preview {
    ContentView()
}
