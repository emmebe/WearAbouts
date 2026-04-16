//
//  DressCodingServ.swift
//  WearAbouts
//
//  Created by Emma Ebeling on 4/16/26.
//

import Foundation

class CulturalDressCodeService {
    
    // Comprehensive dress code database by country
    static func getDressCode(country: String) -> DressCodeInfo {
        let database = dressCodeDatabase()
        
        // Find exact match
        if let info = database[country] {
            return info
        }
        
        // Default for unknown countries
        return DressCodeInfo(
            strictnessLevel: "Moderate",
            generalGuidance: "Research local customs for \(country). When in doubt, err on the side of modesty, especially at religious sites.",
            shoulders: .recommended,
            chest: .recommended,
            midriff: .recommended,
            legs: .casual,
            knees: .recommended,
            headCovering: .notRequired,
            religiousSites: "Cover shoulders and knees at religious sites.",
            businessAttire: "Business casual to formal depending on industry.",
            beachWear: "Standard beachwear acceptable at designated beaches.",
            notes: []
        )
    }
    
    private static func dressCodeDatabase() -> [String: DressCodeInfo] {
        return [
            // EAST ASIA
            "Japan": DressCodeInfo(
                strictnessLevel: "Moderate",
                generalGuidance: "Japan values modesty and conservative dress, especially in professional and traditional settings. However, the younger generation and tourist areas are more relaxed.",
                shoulders: .casual,
                chest: .required,
                midriff: .recommended,
                legs: .casual,
                knees: .casual,
                headCovering: .notRequired,
                religiousSites: "Remove shoes before entering temples and shrines. Shoulders covered recommended but not strictly enforced for tourists.",
                businessAttire: "Very conservative. Dark suits required for business. Avoid flashy colors or accessories.",
                beachWear: "Standard beachwear acceptable at beaches, but cover up when leaving beach areas.",
                notes: [
                    "Chest coverage is MORE important than leg coverage - opposite of Western norms",
                    "Low-cut tops or visible cleavage considered inappropriate even in casual settings",
                    "Shorts and short skirts are common and acceptable in cities",
                    "Tattoos may need to be covered at public baths (onsen) and some establishments",
                    "Remove shoes when entering homes, traditional restaurants, temples, and some hotels"
                ]
            ),
            
            "South Korea": DressCodeInfo(
                strictnessLevel: "Moderate",
                generalGuidance: "South Korea is fashion-forward but conservative regarding showing skin. Modesty is valued, especially chest coverage.",
                shoulders: .casual,
                chest: .required,
                midriff: .recommended,
                legs: .casual,
                knees: .casual,
                headCovering: .notRequired,
                religiousSites: "Modest dress required at Buddhist temples. Shoulders and knees should be covered.",
                businessAttire: "Conservative business attire required. Dark suits for formal settings.",
                beachWear: "Beachwear acceptable at beaches only.",
                notes: [
                    "Similar to Japan: chest coverage prioritized over leg coverage",
                    "Crop tops and low-cut tops are rare even in summer",
                    "Mini skirts and shorts are common and fashionable",
                    "Older generation may disapprove of revealing clothing",
                    "Seoul's Gangnam area is more fashion-forward and accepting"
                ]
            ),
            
            "China": DressCodeInfo(
                strictnessLevel: "Casual",
                generalGuidance: "China is generally relaxed about dress codes in major cities, but conservative dress appreciated in rural areas and religious sites.",
                shoulders: .casual,
                chest: .recommended,
                midriff: .casual,
                legs: .casual,
                knees: .casual,
                headCovering: .notRequired,
                religiousSites: "Modest dress at Buddhist and Taoist temples. Remove shoes when required.",
                businessAttire: "Business formal in major cities. Conservative colors preferred.",
                beachWear: "Standard beachwear at beaches.",
                notes: [
                    "Major cities like Beijing, Shanghai are very relaxed",
                    "Rural and traditional areas more conservative",
                    "Avoid politically sensitive clothing (e.g., Free Tibet messages)",
                    "Temple visits require modest dress out of respect"
                ]
            ),
            
            // SOUTHEAST ASIA
            "Thailand": DressCodeInfo(
                strictnessLevel: "Moderate",
                generalGuidance: "Thailand is relaxed in tourist areas but very conservative at religious sites. The Royal Family is deeply respected - dress modestly when visiting palaces.",
                shoulders: .casual,
                chest: .casual,
                midriff: .casual,
                legs: .casual,
                knees: .casual,
                headCovering: .notRequired,
                religiousSites: "STRICT: Shoulders and knees MUST be covered at temples and palaces. Scarves available for rent/loan at major sites.",
                businessAttire: "Business casual to formal. Lightweight fabrics due to heat.",
                beachWear: "Beachwear acceptable at beaches and islands. Cover up in towns.",
                notes: [
                    "Grand Palace in Bangkok enforces STRICT dress code (no shorts, no shoulders showing, no sandals)",
                    "Beach towns like Phuket very relaxed",
                    "Never disrespect images of the King or Royal Family",
                    "Shoes must be removed before entering temples and homes",
                    "Pointing feet at people or Buddha images is offensive"
                ]
            ),
            
            "Indonesia": DressCodeInfo(
                strictnessLevel: "Moderate",
                generalGuidance: "Indonesia is the world's largest Muslim country, but dress codes vary significantly by region. Bali is relaxed; Aceh province enforces Islamic law.",
                shoulders: .recommended,
                chest: .recommended,
                midriff: .recommended,
                legs: .recommended,
                knees: .recommended,
                headCovering: .notRequired,
                religiousSites: "Modest dress required at mosques. Women may need headscarves (usually provided). Sarongs required at Hindu temples in Bali.",
                businessAttire: "Business casual to conservative depending on region.",
                beachWear: "Bali beaches: standard beachwear acceptable. More conservative regions: cover up.",
                notes: [
                    "BALI: Very tourist-friendly and relaxed (Hindu majority)",
                    "JAKARTA: More conservative, cover shoulders and knees",
                    "ACEH PROVINCE: Sharia law enforced, conservative dress REQUIRED",
                    "Avoid tight or revealing clothing outside tourist areas",
                    "Respect Islamic prayer times and Ramadan"
                ]
            ),
            
            // MIDDLE EAST
            "Saudi Arabia": DressCodeInfo(
                strictnessLevel: "Strict",
                generalGuidance: "MANDATORY modest dress enforced by law. Women must wear abaya (full-length robe). As of 2019, headscarves no longer legally required for women but HIGHLY recommended.",
                shoulders: .required,
                chest: .required,
                midriff: .required,
                legs: .required,
                knees: .required,
                headCovering: .recommended,
                religiousSites: "Women MUST cover hair at mosques. Full abaya required. Men must wear long pants.",
                businessAttire: "Men: suit and tie. Women: conservative business attire with abaya.",
                beachWear: "Gender-segregated beaches exist. Very conservative swimwear required.",
                notes: [
                    "LEGAL REQUIREMENT: Women must wear loose-fitting, full-length abaya in public",
                    "Headscarf (hijab) technically optional since 2019 but STRONGLY recommended",
                    "Men: long pants required, shoulders covered, no shorts in public",
                    "Western-style clothing under abaya is acceptable",
                    "Mutaween (religious police) may enforce dress codes",
                    "Conservative dress is LAW, not just custom"
                ]
            ),
            
            "United Arab Emirates": DressCodeInfo(
                strictnessLevel: "Moderate",
                generalGuidance: "Dubai and Abu Dhabi are cosmopolitan but still conservative. Modest dress required in public areas, malls, and government buildings. Beach resorts more relaxed.",
                shoulders: .recommended,
                chest: .required,
                midriff: .required,
                legs: .recommended,
                knees: .recommended,
                headCovering: .notRequired,
                religiousSites: "Women MUST cover hair at mosques (scarves provided). Abaya required at Sheikh Zayed Grand Mosque.",
                businessAttire: "Business formal. Conservative dress expected.",
                beachWear: "Resorts and designated beaches: standard swimwear OK. Cover up when leaving beach.",
                notes: [
                    "DUBAI: More relaxed but still modest dress in malls and public",
                    "Shoulders and knees should be covered in malls (signs posted)",
                    "Swimwear only at pools and beaches - cover up immediately after",
                    "Fines possible for indecent clothing (crop tops, short shorts in malls)",
                    "During Ramadan: extra modesty expected during daylight hours",
                    "Hotel areas and beaches more lenient than city centers"
                ]
            ),
            
            "Iran": DressCodeInfo(
                strictnessLevel: "Strict",
                generalGuidance: "MANDATORY Islamic dress code enforced by law. ALL women (including tourists) MUST wear hijab covering hair and loose-fitting clothing covering arms and legs.",
                shoulders: .required,
                chest: .required,
                midriff: .required,
                legs: .required,
                knees: .required,
                headCovering: .required,
                religiousSites: "Women MUST wear chador (full-body covering) at major religious sites.",
                businessAttire: "Conservative Islamic dress required.",
                beachWear: "Gender-segregated areas. Islamic swimwear required.",
                notes: [
                    "LEGAL REQUIREMENT: Headscarf (hijab) MANDATORY for all women in public",
                    "Loose-fitting manteau (coat) covering to knees or below required",
                    "Long pants or long skirt required",
                    "Arms must be covered to wrists",
                    "No bright colors or tight clothing",
                    "Morality police (Gasht-e Ershad) enforce dress codes",
                    "Penalties include fines, warnings, or detention"
                ]
            ),
            
            "Turkey": DressCodeInfo(
                strictnessLevel: "Casual",
                generalGuidance: "Turkey is secular with relaxed dress codes in cities like Istanbul and coastal areas. More conservative in rural and eastern regions.",
                shoulders: .casual,
                chest: .casual,
                midriff: .casual,
                legs: .casual,
                knees: .casual,
                headCovering: .notRequired,
                religiousSites: "Women should cover hair with scarf at mosques (provided at entrance). Shoulders and knees covered.",
                businessAttire: "Western business attire acceptable.",
                beachWear: "Coastal resorts: standard beachwear fine.",
                notes: [
                    "ISTANBUL: Very cosmopolitan, Western clothing normal",
                    "Coastal areas and resorts: relaxed dress codes",
                    "Eastern/rural regions: more conservative, modest dress appreciated",
                    "Mosques provide coverings for visitors",
                    "Remove shoes before entering mosques"
                ]
            ),
            
            // SOUTH ASIA
            "India": DressCodeInfo(
                strictnessLevel: "Moderate",
                generalGuidance: "India is diverse with varying dress norms. Generally conservative - modest dress shows respect. Cover shoulders, chest, and knees especially in religious sites and rural areas.",
                shoulders: .recommended,
                chest: .required,
                midriff: .casual,
                legs: .recommended,
                knees: .recommended,
                headCovering: .notRequired,
                religiousSites: "Cover head at Sikh temples (scarves provided). Shoulders and knees covered at most religious sites. Remove shoes.",
                businessAttire: "Business formal in major cities. Women may wear traditional salwar kameez or Western business attire.",
                beachWear: "Goa beaches: standard beachwear OK. Other beaches: more conservative.",
                notes: [
                    "Traditional dress (sari, salwar kameez) shows cultural respect",
                    "Midriff showing is normal with saris but in traditional context",
                    "Western-style crop tops may be seen as inappropriate",
                    "GOA: Very relaxed, beach culture",
                    "North India generally more conservative than South",
                    "Cover up in religious sites and rural areas",
                    "Avoid public displays of affection"
                ]
            ),
            
            // EUROPE
            "France": DressCodeInfo(
                strictnessLevel: "Casual",
                generalGuidance: "France is very relaxed about dress. Fashion-forward culture. No specific restrictions except at religious sites.",
                shoulders: .casual,
                chest: .casual,
                midriff: .casual,
                legs: .casual,
                knees: .casual,
                headCovering: .notRequired,
                religiousSites: "Modest dress at churches and cathedrals. Shoulders covered, no short shorts.",
                businessAttire: "Business formal, very fashion-conscious.",
                beachWear: "Topless sunbathing common at beaches. Standard swimwear everywhere.",
                notes: [
                    "Very fashion-conscious culture",
                    "Athletic wear/sweatpants avoided in city centers",
                    "Cover up for churches (Notre-Dame, etc.)",
                    "No religious face coverings in public (burqa ban)"
                ]
            ),
            
            "Italy": DressCodeInfo(
                strictnessLevel: "Casual",
                generalGuidance: "Italy is relaxed but fashion-conscious. Modest dress required at major churches and Vatican City.",
                shoulders: .casual,
                chest: .casual,
                midriff: .casual,
                legs: .casual,
                knees: .casual,
                headCovering: .notRequired,
                religiousSites: "VATICAN: Strict dress code. Knees and shoulders MUST be covered. No shorts, no short skirts, no tank tops.",
                businessAttire: "Business formal, highly fashion-conscious.",
                beachWear: "Standard European beachwear.",
                notes: [
                    "VATICAN CITY: Strictly enforced dress code",
                    "St. Peter's Basilica: will deny entry for dress code violations",
                    "Major churches (Duomo, etc.): shoulders and knees covered",
                    "Italians are very fashion-conscious",
                    "Avoid beachwear in cities"
                ]
            ),
            
            // AMERICAS
            "United States": DressCodeInfo(
                strictnessLevel: "Casual",
                generalGuidance: "Extremely relaxed dress codes. Freedom of expression valued. Dress varies greatly by region and context.",
                shoulders: .casual,
                chest: .casual,
                midriff: .casual,
                legs: .casual,
                knees: .casual,
                headCovering: .notRequired,
                religiousSites: "Modest dress appreciated at religious sites but rarely enforced.",
                businessAttire: "Business casual to formal depending on industry and region.",
                beachWear: "Standard beachwear everywhere.",
                notes: [
                    "Very casual - almost anything acceptable",
                    "Upscale restaurants may have dress codes",
                    "Southern states tend to be slightly more conservative",
                    "Major cities very diverse and accepting"
                ]
            ),
            
            "Mexico": DressCodeInfo(
                strictnessLevel: "Casual",
                generalGuidance: "Mexico is generally relaxed, especially in tourist areas. More conservative in rural areas and at religious sites.",
                shoulders: .casual,
                chest: .casual,
                midriff: .casual,
                legs: .casual,
                knees: .casual,
                headCovering: .notRequired,
                religiousSites: "Modest dress at churches. Shoulders covered appreciated.",
                businessAttire: "Business casual to formal.",
                beachWear: "Beach resorts very relaxed. Standard beachwear everywhere.",
                notes: [
                    "Coastal resorts (Cancun, Playa del Carmen): very relaxed",
                    "Mexico City: casual but fashion-conscious",
                    "Rural areas: more conservative appreciated",
                    "Catholic churches: cover shoulders out of respect"
                ]
            ),
            
            "Brazil": DressCodeInfo(
                strictnessLevel: "Casual",
                generalGuidance: "Brazil is very relaxed about dress. Beach culture prominent. Revealing clothing normal and accepted.",
                shoulders: .casual,
                chest: .casual,
                midriff: .casual,
                legs: .casual,
                knees: .casual,
                headCovering: .notRequired,
                religiousSites: "Modest dress at churches.",
                businessAttire: "Business casual, more relaxed than North America/Europe.",
                beachWear: "Very minimal swimwear normal (string bikinis, sungas). Topless sunbathing less common than Europe.",
                notes: [
                    "Beach culture - revealing clothing normal",
                    "Rio de Janeiro: very casual and relaxed",
                    "Brazilians are body-positive and unselfconscious",
                    "Cover up at churches"
                ]
            )
        ]
    }
}

// MARK: - Data Models

struct DressCodeInfo {
    let strictnessLevel: String // "Casual", "Moderate", "Strict"
    let generalGuidance: String
    let shoulders: DressRequirement
    let chest: DressRequirement
    let midriff: DressRequirement
    let legs: DressRequirement
    let knees: DressRequirement
    let headCovering: DressRequirement
    let religiousSites: String
    let businessAttire: String
    let beachWear: String
    let notes: [String]
    
    var formattedGuidance: String {
        var text = generalGuidance + "\n\n"
        
        text += "📍 Key Guidelines:\n"
        if shoulders != .casual { text += "• Shoulders: \(shoulders.description)\n" }
        if chest != .casual { text += "• Chest: \(chest.description)\n" }
        if midriff != .casual { text += "• Midriff: \(midriff.description)\n" }
        if knees != .casual { text += "• Knees: \(knees.description)\n" }
        if headCovering != .notRequired { text += "• Head covering: \(headCovering.description)\n" }
        
        text += "\n🏛 Religious Sites:\n\(religiousSites)\n"
        
        if !notes.isEmpty {
            text += "\n💡 Important Notes:\n"
            for note in notes.prefix(3) {
                text += "• \(note)\n"
            }
        }
        
        return text
    }
}

enum DressRequirement {
    case notRequired
    case casual
    case recommended
    case required
    
    var description: String {
        switch self {
        case .notRequired: return "Not required"
        case .casual: return "No restrictions"
        case .recommended: return "Coverage recommended for respect"
        case .required: return "MUST be covered (legally or culturally enforced)"
        }
    }
}
