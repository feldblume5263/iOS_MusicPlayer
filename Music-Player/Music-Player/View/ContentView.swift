//
//  ContentView.swift
//  Music-Player
//
//  Created by Junhong Park on 2022/01/12.
//

import SwiftUI
import MediaPlayer

struct ContentView: View {
    
    @State private var player = MPMusicPlayerController.applicationMusicPlayer
    @State var isPlaying = false
    @State var isFullPlayer: Bool = false
    @State var alertVisible: Bool = false
    @ObservedObject var authViewModel = AuthViewModel()
    
    var body: some View {
        if authViewModel.authStatus {
            ZStack {
                NavigationView {
                    LibraryView(player: player)
                        .padding(.bottom, 80)
                        .padding(.top, 20)
                }
                .edgesIgnoringSafeArea(.bottom)
                BlurView()
                    .opacity(isFullPlayer ? 0.5 : 0.0)
                VStack {
                    Spacer()
                    MiniPlayerView(player: player, isFullPlayer: $isFullPlayer)
                        .frame(minHeight: 450, idealHeight: 600, maxHeight: 750, alignment: .bottom)
                }
                .edgesIgnoringSafeArea(.bottom)
                .navigationBarColor(backgroundColor: mainUIColor, tintColor: .white)
            }
        } else {
            Spacer()
            Text("미디어 및 Apple Music 권한 설정이 필요합니다.")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Spacer()
            Button("설정창으로 가기") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            .font(.subheadline)
            .foregroundColor(.primary)
            Spacer()
        }
    }
}

struct BlurView: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

struct NavigationBarColor: ViewModifier {

  init(backgroundColor: UIColor, tintColor: UIColor) {
    let coloredAppearance = UINavigationBarAppearance()
    coloredAppearance.configureWithOpaqueBackground()
    coloredAppearance.backgroundColor = backgroundColor
    coloredAppearance.titleTextAttributes = [.foregroundColor: tintColor]
    coloredAppearance.largeTitleTextAttributes = [.foregroundColor: tintColor]
                   
    UINavigationBar.appearance().standardAppearance = coloredAppearance
    UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
    UINavigationBar.appearance().compactAppearance = coloredAppearance
    UINavigationBar.appearance().tintColor = tintColor
  }

  func body(content: Content) -> some View {
    content
  }
}

extension View {
  func navigationBarColor(backgroundColor: UIColor, tintColor: UIColor) -> some View {
    self.modifier(NavigationBarColor(backgroundColor: backgroundColor, tintColor: tintColor))
  }
}
