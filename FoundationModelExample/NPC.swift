import FoundationModels
import RegexBuilder

@Generable
struct NPC {
    let name: String
    let encounter: Encounter

    @Generable
    enum Encounter {
        case orderCoffee(String)
        case wantToTalkToManager(complaint: String)
    }
}

@Generable
struct GuidedNPC {
    @Guide(description: "A full name")
    let name: String
    @Guide(.range(1...10))
    let level: Int
    @Guide(.count(3))
    let attributes: [Attribute]
    let encounter: Encounter

    @Generable
    enum Attribute {
        case sassy
        case tired
        case hungry
    }

    @Generable
    enum Encounter {
        case orderCoffee(String)
        case wantToTalkToManager(complaint: String)
    }
}

@Generable
struct RegexGuidedNPC {
    @Guide(
        Regex {
            Capture {
                ChoiceOf {
                    "Mr"
                    "Mrs"
                }
            }
            ". "
            OneOrMore(.word)
        }
    )
    let name: String
}

