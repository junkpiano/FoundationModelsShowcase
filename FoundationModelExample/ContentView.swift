import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = AIViewModel()

    @ObservedObject private var networkStatus = NetworkStatusMonitor()

    @State var prompt: String = ""

    var body: some View {
        NavigationStack {
            VStack {
                TextField("Prompt", text: $prompt)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                    .glassEffect()
                    .onSubmit {
                        Task {
                            await runTasks()
                        }
                    }
                ScrollView {
                    VStack {
                        if viewModel.isLoading {
                            ProgressView()
                        }
                        Text(viewModel.answer.mdString())
                            .font(.body)
                            .lineLimit(nil)  // or .lineLimit(10) for max lines
                            .multilineTextAlignment(.leading)  // optional: .center, .trailing
                            .padding()
                    }
                }
                .navigationTitle("FoundationModelsExample")
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Label(networkStatus.status.rawValue, systemImage: "wifi")
                        .labelStyle(.titleAndIcon)
                        .lineLimit(1)
                        .layoutPriority(1)
                }
            }
        }
    }

    func runTasks() async {
        async let result1: Void = viewModel.run(prompt: prompt)
        _ = await (result1)
    }
}

extension String {
    func mdString() -> AttributedString {
        let normalized = replacingOccurrences(of: "\n", with: "  \n")
        do {
            let attributedString = try AttributedString(
                markdown: normalized,
                options: .init(
                    allowsExtendedAttributes: true,
                    interpretedSyntax: .inlineOnlyPreservingWhitespace,
                )
            )
            return attributedString
        } catch {
            print("Couldn't parse: \(error)")
            return AttributedString("Error parsing markdown")
        }
    }
}

#Preview {
    ContentView()
}
