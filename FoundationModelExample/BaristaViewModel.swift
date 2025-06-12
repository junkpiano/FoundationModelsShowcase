internal import Combine
import Foundation
import FoundationModels

class BaristaViewModel: ObservableObject {
    @Published var answer: String = ""
    @Published var isLoading: Bool = false

    init(
        answer: String = "",
        isLoading: Bool = false,
    ) {
        self.answer = answer
        self.isLoading = isLoading
    }

    /// Prompting a session
    @MainActor
    func run(prompt: String) async throws -> String {
        // initialize the session with instructions
        let fmf: FMF = FMF(session: LanguageModelSession(
            instructions: """
                You are a friendly barista in a world full of pixels.
                Respond to the player’s question.
                """
        ))
        
        
        let response = try await fmf.basicUsage(prompt: prompt)
        return response
    }
    
    @MainActor
    func spawnNPC(prompt: String) async throws -> NPC {
        // initialize the session with instructions
        let fmf: FMF = FMF(session: LanguageModelSession(
            instructions: """
                You are a coffee barista simulator game creator.
                Create a new NPC with the following attributes:
                - Name
                - Description
                - Personality traits
                - Favorite drink
                - Background story
                - Unique quirks or habits
                """
        ))
        
        let response = try await fmf.responseNPC(prompt: prompt)
        return response
    }

}
