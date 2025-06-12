import FoundationModels
import Foundation

class FMF {
    var session: LanguageModelSession
    init(session: LanguageModelSession = LanguageModelSession()) {
        self.session = session
    }
    
    /// Handle  Errors
    func handleErrors(prompt: String) async throws {
        // initalize without any history
        session = LanguageModelSession()

        do {
            let answer = try await session.respond(to: prompt)
            print(answer.content)
        } catch LanguageModelSession.GenerationError.exceededContextWindowSize {
            // New session, with some history from the previous session
            
            session = newSession(previousSession: session)
        } catch LanguageModelSession.GenerationError.unsupportedLanguageOrLocale {
            // Unsupported language in prompt.
            
            session = LanguageModelSession()
        }
    }

    private func newSession(previousSession: LanguageModelSession)
        -> LanguageModelSession
    {
        let allEntries = previousSession.transcript.entries
        var condensedEntries = [Transcript.Entry]()
        if let firstEntry = allEntries.first {
            condensedEntries.append(firstEntry)
            if allEntries.count > 1, let lastEntry = allEntries.last {
                condensedEntries.append(lastEntry)
            }
        }
        let condensedTranscript = Transcript(entries: condensedEntries)
        // Note: transcript includes instructions.
        return LanguageModelSession(transcript: condensedTranscript)
    }
    
    // MARK: Basic Usage

    func basicUsage(prompt: String) async throws -> String {
        let response = try await session.respond(to: prompt)
        return response.content
    }

    // MARK: Sampling

    func greedySample(prompt: String) async throws -> String {
        // Deterministic output
        let response = try await session.respond(
            to: prompt,
            options: GenerationOptions(sampling: .greedy)
        )

        return response.content
    }

    func lowVarianceSample(prompt: String) async throws -> String {
        // Low-variance output
        let response = try await session.respond(
            to: prompt,
            options: GenerationOptions(temperature: 0.5)
        )
        return response.content
    }

    func highVarianceSample(prompt: String) async throws -> String {
        // High-variance output
        let response = try await session.respond(
            to: prompt,
            options: GenerationOptions(temperature: 2.0)
        )
        return response.content
    }
    
    // MARK: Language Check

    func checkLanguageSupport() -> Bool {
        let supportedLanguages = SystemLanguageModel.default.supportedLanguages
        guard supportedLanguages.contains(Locale.current.language) else {
          // Show message
          return false
        }
        
        return true
    }
    
    // MARK: NPC
    
    func responseNPC(prompt: String) async throws -> NPC {
        // Initialize the session with instructions
        let response = try await session.respond(to: prompt, generating: NPC.self)
        return response.content
    }
        
}
