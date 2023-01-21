import Core
import Logging
import SwiftUI
import NotificationCenter

public struct WidgetView: View {
    @EnvironmentObject var widget: WidgetService
    @EnvironmentObject var emulateService: EmulateService
    @EnvironmentObject var device: Device

    public var isError: Bool {
        widget.isError
    }

    public init() {
    }

    public var body: some View {
        VStack(spacing: 0) {
            Divider()
                .foregroundColor(.black4)

            switch widget.state {
            case .idle, .emulating:
                WidgetKeysView()
            case .loading:
                Text("Loading")
            case .error(let error):
                ErrorView(error: error) {
                    print("on back")
                }
            }
        }
        .onAppear {
            device.connect()
        }
        .onDisappear {
            widget.stopEmulate()
            device.disconnect()
        }
        .edgesIgnoringSafeArea(.all)
        .onChange(of: emulateService.state) { state in
            if
                state == .staring ||
                state == .started ||
                state == .closed
            {
                feedback(style: .soft)
            }
        }
    }
}
