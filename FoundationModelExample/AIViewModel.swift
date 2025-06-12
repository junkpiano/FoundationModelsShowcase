import FoundationModels
import Foundation
import SwiftUI
internal import Combine

class AIViewModel: ObservableObject {
    @Published var answer: String = ""
    @Published var isLoading: Bool = false

    @MainActor
    func run(prompt: String) async {
        isLoading = true
        checkModelAvailability()
        // Simulate delay or use actual network call
        if #available(macOS 26.0, *) {
            if SystemLanguageModel.default.availability != .available {
                print("LanguageModelSession is not available on this version.")
                return
            }
            
            let session = LanguageModelSession()
            do {
                let response = try await session.respond(to: prompt)
                answer = response.content
            } catch {
                print("Error: \(error)")
            }
        } else {
            // Fallback on earlier versions
            print("LanguageModelSession is not available on this version.")
        }
        isLoading = false
    }
    
    private func checkModelAvailability() {
        if #available(macOS 26.0, *) {
            let model = SystemLanguageModel.default
            
            switch model.availability {
            case .available:
                // Show your intelligence UI.
                print("LanguageModelSession is available.")
            case .unavailable(.deviceNotEligible):
                // Show an alternative UI.
                print("Device is not eligible for LanguageModelSession.")
            case .unavailable(.appleIntelligenceNotEnabled):
                // Ask the person to turn on Apple Intelligence.
                print("Apple Intelligence is not enabled.")
            case .unavailable(.modelNotReady):
                // The model isn't ready because it's downloading or because of other system reasons.
                print("LanguageModelSession model is not ready.")
            case .unavailable(let other):
                // The model is unavailable for an unknown reason.
                print("LanguageModelSession is unavailable for an unknown reason: \(other)")
            }
        } else {
            print("LanguageModelSession is not available on this version.")
        }
    }
}

