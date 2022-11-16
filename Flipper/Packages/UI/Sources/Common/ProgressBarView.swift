import SwiftUI

struct ProgressBarView: View {
    let image: String
    @State var text: String
    let color: Color
    let progress: Double

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 9)
                .stroke(color, lineWidth: 3)

            GeometryReader { reader in
                color.frame(width: reader.size.width * progress)
            }

            HStack {
                Image(image)
                    .padding([.leading, .top, .bottom], 9)

                Spacer()

                Text(text)
                    .foregroundColor(.white)
                    .font(.haxrCorpNeue(size: 40))
                    .padding(.bottom, 4)

                Spacer()

                Image(image)
                    .padding([.leading, .top, .bottom], 9)
                    .opacity(0)
            }
        }
        .frame(height: 46)
        .background(color.opacity(0.54))
        .cornerRadius(9)
        .task {
            if text == "..." {
                while !Task.isCancelled {
                    try? await Task.sleep(milliseconds: 333)
                    text = String(repeating: ".", count: text.count % 3 + 1)
                }
            }
        }
    }
}
