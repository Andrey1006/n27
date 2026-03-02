import Foundation

struct AttractionDetail {
    let imageName: String
    let title: String
    let shortDescription: String
    let region: String
    let tags: [String]
    let timeNeeded: String
    let ticketInfo: String
    let bestSeason: String
    let accessibility: String
    let overviewText: String
    let highlights: [String]
    let historyText: String
    let tips: [String]
    let gettingThere: String
}

enum AttractionDetailService {

    static func detail(for imageName: String) -> AttractionDetail? {
        allDetails.first { $0.imageName == imageName }
    }

    private static let allDetails: [AttractionDetail] = [
        
        AttractionDetail(
            imageName: "attraction1",
            title: "Tower of London",
            shortDescription: "Historic castle on the Thames",
            region: "London",
            tags: ["2-3 hours", "Family-friendly", "Royal & Historic", "Must-see"],
            timeNeeded: "2-3 hours",
            ticketInfo: "£29.90 adults,\n£14.90 children",
            bestSeason: "Spring & Autumn",
            accessibility: "Wheelchair accessible with some limitations",
            overviewText: "One of the world's most famous fortresses, the Tower of London has served as royal palace, prison, armory, and treasury. Home to the Crown Jewels and a thousands years of history.",
            highlights: [
                "The Crown Jewels collection",
                "Medieval White Tower",
                "Yeoman Warders (Beefeaters) tours",
                "Tower Ravens",
                "Royal Armouries collection",
                "Traitors' Gate"
            ],
            historyText: "Founded by William the Conqueror in 1066, the Tower has been a symbol of royal power for nearly a thousand years. It has witnessed executions, imprisonments, and the safeguarding of the Crown Jewels.",
            tips: [
                "Book tickets online to skip queues",
                "Arrive early to see the Crown Jewels before crowds",
                "Join a Yeoman Warder tour for fascinating stories",
                "Allow at least 3 hours to see everything"
            ],
            gettingThere: "Tower Hill Underground station (District & Circle lines). 5-minute walk from the station. Also accessible via Tower Gateway DLR."
        ),
        
        AttractionDetail(
            imageName: "attraction3",
            title: "Stonehenge",
            shortDescription: "Prehistoric monument and mystery",
            region: "South",
            tags: ["1-2 hours", "Royal & Historic", "Free", "Must-see", "Historic"],
            timeNeeded: "1-2 hours",
            ticketInfo: "£21.50 adults, £12.90 children",
            bestSeason: "Summer solstice or early morning",
            accessibility: "Accessible shuttle and viewing areas",
            overviewText: "One of the world's most famous prehistoric monuments, Stonehenge stands as a testament to ancient engineering. The stone circle has captivated visitors for centuries with its mystery and majesty.",
            highlights: [
                "The iconic stone circle",
                "Visitor center with reconstructed Neolithic houses",
                "Audio guide with theories and history",
                "Burial mounds and landscape",
                "Exhibition of artifacts"
            ],
            historyText: "Built in several stages from around 3000 BC to 1600 BC, Stonehenge's purpose remains debated. Theories range from astronomical observatory to ceremonial site. The bluestones were transported from Wales, over 150 miles away.",
            tips: [
                "Book advance tickets - often sells out",
                "Visit at sunrise or sunset for magical atmosphere",
                "Allow time for the visitor center",
                "Consider the audio guide for full experience"
            ],
            gettingThere: "Located near Salisbury, Wiltshire. Closest train station is Salisbury (9 miles). Stonehenge Tour bus runs from Salisbury station. By car: off A303, well signposted."
        ),
        
        AttractionDetail(
            imageName: "attraction5",
            title: "Windsor Castle",
            shortDescription: "The Queen's weekend residence",
            region: "South",
            tags: ["2-3 hours", "Royal & Historic", "Royal", "Must-see"],
            timeNeeded: "2-3 hours",
            ticketInfo: "£28.50 adults, £16.50 children",
            bestSeason: "Spring & Summer",
            accessibility: "Limited access due to historic nature",
            overviewText: "The oldest and largest occupied castle in the world, Windsor Castle has been home to British monarchs for over 900 years. The State Apartments are truly spectacular.",
            highlights: [
                "State Apartments",
                "St George's Chapel",
                "Queen Mary's Dolls' House",
                "Changing of the Guard (select days)",
                "Round Tower views",
                "Semi-State Rooms (autumn/winter)"
            ],
            historyText: "Founded by William the Conqueror in the 11th century, Windsor Castle has been remodeled by successive monarchs. It survived a major fire in 1992 and remains the King's favorite weekend residence.",
            tips: [
                "Check if State Apartments are open - they close for royal events",
                "Changing of the Guard on Tuesdays, Thursdays & Saturdays",
                "Buy tickets online to save time",
                "Combine with a walk around Windsor town"
            ],
            gettingThere: "Windsor & Eton Central or Windsor & Eton Riverside stations (both 5-minute walk). Direct trains from London Waterloo or Paddington (30-50 minutes)."
        ),
        
        AttractionDetail(
            imageName: "attraction7",
            title: "Peak District National Park",
            shortDescription: "Rolling hills and historic estates",
            region: "Midlands",
            tags: ["Full day", "Parks & Nature", "Free", "Nature", "Hiking"],
            timeNeeded: "Full day",
            ticketInfo: "Free entry to park",
            bestSeason: "Spring to autumn",
            accessibility: "Some accessible trails",
            overviewText: "Britain's first national park offers dramatic limestone valleys, gritstone edges, and charming market towns. Popular for hiking, cycling, and exploring grand estates like Chatsworth House.",
            highlights: [
                "Mam Tor viewpoint",
                "Chatsworth House",
                "Dovedale stepping stones",
                "Castleton caves",
                "Bakewell (home of Bakewell tart)",
                "Stanage Edge climbing"
            ],
            historyText: "Designated as Britain's first national park in 1951, the Peak District has been shaped by thousands of years of human activity from prehistoric times through the Industrial Revolution.",
            tips: [
                "Parking can be difficult on sunny weekends",
                "Weather changes quickly at elevation",
                "Try a Bakewell tart in Bakewell",
                "Many excellent walking trails for all abilities"
            ],
            gettingThere: "Train stations at Buxton, Matlock, or Sheffield with bus connections. Car recommended. From London: 3-4 hours by car. Manchester: 1 hour."
        ),
        
        AttractionDetail(
            imageName: "attraction9",
            title: "Jurassic Coast",
            shortDescription: "185 million years of geological history",
            region: "Coast",
            tags: ["Full day or multi-day", "Parks & Nature", "Free", "Nature", "Beaches"],
            timeNeeded: "Full day or multi-day",
            ticketInfo: "Free",
            bestSeason: "Spring through autumn",
            accessibility: "Beach areas vary",
            overviewText: "England's first natural UNESCO World Heritage Site spans 95 miles of stunning coastline. Famous for fossils, dramatic rock formations like Durdle Door, and beautiful beaches.",
            highlights: [
                "Durdle Door natural arch",
                "Lulworth Cove",
                "Fossil hunting beaches",
                "Old Harry Rocks",
                "Chesil Beach",
                "Charmouth fossil walks"
            ],
            historyText: "The Jurassic Coast reveals 185 million years of Earth's history in its cliffs and beaches. Mary Anning, pioneering fossil hunter, made groundbreaking discoveries here in the early 1800s.",
            tips: [
                "Check tide times for beach access",
                "Fossil hunting best after storms",
                "Bring sturdy shoes for cliff walks",
                "Several beaches have parking fees"
            ],
            gettingThere: "Best accessed by car. Train stations at Weymouth, Dorchester, and Exeter with bus services to coastal towns. Popular spots: Lulworth Cove has parking."
        ),
        
        AttractionDetail(
            imageName: "attraction11",
            title: "Camden Market",
            shortDescription: "Eclectic market in North London",
            region: "London",
            tags: ["2-3 hours", "Markets", "Food", "Free"],
            timeNeeded: "2-3 hours",
            ticketInfo: "Free entry",
            bestSeason: "Year-round",
            accessibility: "Can be crowded but accessible",
            overviewText: "A vibrant maze of markets offering everything from vintage clothes to international street food. Camden's alternative culture and creative spirit make it a unique London experience.",
            highlights: [
                "Camden Lock Market",
                "Vintage clothing stalls",
                "International street food",
                "Live music venues",
                "Regent's Canal walks",
                "Unique crafts and art"
            ],
            historyText: "Camden Market grew from a small arts and crafts fair in 1974 to become one of London's most famous markets. It became synonymous with punk and alternative culture in the 1980s and remains a creative hub.",
            tips: [
                "Weekends are very crowded - weekdays are calmer",
                "Bring cash as some stalls don't take cards",
                "Great for people-watching and street photography",
                "Walk along Regent's Canal to Little Venice"
            ],
            gettingThere: "Camden Town or Chalk Farm Underground stations (Northern line). Both 5-minute walk. Many buses including 24, 27, 29, 31, 88, 134, 168, 214."
        ),
        
        AttractionDetail(
            imageName: "attraction2",
            title: "British Museum",
            shortDescription: "World cultures and history under one roof",
            region: "London",
            tags: ["2-4 hours", "Free", "Museums", "Historic"],
            timeNeeded: "2-4 hours",
            ticketInfo: "Free entry (donation suggested)",
            bestSeason: "Year-round",
            accessibility: "Fully accessible",
            overviewText: "One of the world's greatest museums, the British Museum houses a vast collection spanning two million years of human history. From Egyptian mummies to the Parthenon sculptures.",
            highlights: [
                "Egyptian mummies and the Rosetta Stone",
                "Parthenon sculptures",
                "Reading Room",
                "Assyrian reliefs",
                "Greek and Roman galleries",
                "Temporary exhibitions"
            ],
            historyText: "Founded in 1753, the British Museum was the first national public museum in the world. Its collection has grown through exploration and donation to represent cultures across the globe.",
            tips: [
                "Free entry - book timed slots online",
                "Allow at least 3 hours for main highlights",
                "Early morning or late afternoon less crowded",
                "Free highlights tours available"
            ],
            gettingThere: "Russell Square, Holborn, or Tottenham Court Road Underground stations. Multiple bus routes. Central London location."
        ),
        
        AttractionDetail(
            imageName: "attraction4",
            title: "Lake District National Park",
            shortDescription: "Mountains, lakes, and literary heritage",
            region: "North",
            tags: ["Full day", "Parks & Nature", "Free", "Nature", "Hiking"],
            timeNeeded: "Full day or multi-day",
            ticketInfo: "Free entry to park",
            bestSeason: "Late spring through early autumn",
            accessibility: "Varied - some accessible trails available",
            overviewText: "England's largest national park offers stunning mountain scenery, pristine lakes, and charming villages. Home to Scafell Pike (England's highest mountain) and inspiration for Wordsworth and Beatrix Potter.",
            highlights: [
                "Windermere - largest natural lake",
                "Scafell Pike summit",
                "Beatrix Potter's Hill Top",
                "Castlerigg Stone Circle",
                "Buttermere valley",
                "Picturesque villages like Grasmere"
            ],
            historyText: "The Lake District has inspired artists and writers for centuries. William Wordsworth, Samuel Taylor Coleridge, and Beatrix Potter all called this region home. It became a UNESCO World Heritage Site in 2017.",
            tips: [
                "Stay at least 2-3 days to explore properly",
                "Weather changes quickly - bring layers",
                "Popular trails can be busy in summer",
                "Windermere has boat services for exploring"
            ],
            gettingThere: "Train to Windermere, Penrith, or Oxenholme stations. Local buses connect villages. Car recommended for flexibility. From London: 4-5 hours by train or car."
        ),
        
        AttractionDetail(
            imageName: "attraction6",
            title: "Roman Baths",
            shortDescription: "Ancient spa in the heart of Bath",
            region: "South",
            tags: ["1-2 hours", "Museums", "Historic", "Must-see"],
            timeNeeded: "1-2 hours",
            ticketInfo: "£25 adults, £16.50 children",
            bestSeason: "Year-round",
            accessibility: "Wheelchair accessible with assistance",
            overviewText: "One of the finest historic sites in Northern Europe, the Roman Baths are remarkably well preserved. Walk where Romans walked 2,000 years ago in this atmospheric complex.",
            highlights: [
                "The Great Bath",
                "Roman Temple",
                "Museum of Roman artifacts",
                "Sacred Spring",
                "East and West Baths",
                "Audio guide included"
            ],
            historyText: "Built around 70 AD, the baths were a center of worship and bathing for Romans in Britain. Dedicated to the goddess Sulis Minerva, the site remained lost for centuries after Roman departure until rediscovery in the 1880s.",
            tips: [
                "Visit in the evening for atmospheric torch-lit experience (July-August)",
                "Book ahead - very popular",
                "Combine with Bath Abbey visit next door",
                "The Georgian city of Bath is a UNESCO World Heritage Site"
            ],
            gettingThere: "Bath Spa train station, 10-minute walk. Direct trains from London Paddington (90 minutes). City center location - easy to walk from anywhere in Bath."
        ),
        
        AttractionDetail(
            imageName: "attraction8",
            title: "York Minster",
            shortDescription: "Gothic masterpiece cathedral",
            region: "North",
            tags: ["1-2 hours", "Royal & Historic", "Historic", "Architecture"],
            timeNeeded: "1-2 hours",
            ticketInfo: "£16 adults, free for children under 16",
            bestSeason: "Year-round",
            accessibility: "Ground floor accessible",
            overviewText: "One of the world's most magnificent cathedrals, York Minster dominates the skyline of historic York. Its medieval stained glass windows are unrivaled, and the building itself is an architectural triumph.",
            highlights: [
                "Great East Window - largest medieval stained glass window",
                "Chapter House with original ceiling",
                "Tower climb for city views (275 steps)",
                "Underground museum",
                "Evensong services",
                "Rose Window"
            ],
            historyText: "Standing on the site of a Roman fortress, the current Gothic cathedral was begun in 1220 and took 250 years to complete. It has been the center of Christianity in the North of England for over 1,000 years.",
            tips: [
                "Climb the tower early to avoid crowds",
                "Check for services if you want quiet viewing",
                "Combination ticket includes the tower and underground",
                "Explore the medieval streets around the Minster"
            ],
            gettingThere: "York railway station, 15-minute walk through the city. Direct trains from London (2 hours), Edinburgh (2.5 hours). Central location in York - easy to walk."
        ),
        
        AttractionDetail(
            imageName: "attraction10",
            title: "Warwick Castle",
            shortDescription: "Medieval fortress with 1,100 years of history",
            region: "Midlands",
            tags: ["3-4 hours", "Castles", "Family-friendly", "Castle"],
            timeNeeded: "3-4 hours",
            ticketInfo: "£32 adults, £26 children (advance booking)",
            bestSeason: "Summer for outdoor events",
            accessibility: "Some areas accessible",
            overviewText: "One of England's finest medieval castles, Warwick Castle offers interactive experiences, beautiful grounds, and well-preserved fortifications. A perfect blend of history and entertainment.",
            highlights: [
                "State Rooms and Great Hall",
                "Castle dungeons",
                "Towers and ramparts walk",
                "Bird of prey shows",
                "Medieval trebuchet demonstration",
                "Peacock gardens"
            ],
            historyText: "Built by William the Conqueror in 1068, Warwick Castle was a key fortress for centuries. The Earls of Warwick wielded tremendous power, including the 'Kingmaker' Richard Neville during the Wars of the Roses.",
            tips: [
                "Book online for significant discounts",
                "Arrive early as it gets very busy",
                "Check show times for birds of prey and trebuchet",
                "Combine with visit to Warwick town"
            ],
            gettingThere: "Warwick train station, 10-minute walk. Direct trains from London Marylebone (90 minutes) and Birmingham (30 minutes). Parking available on-site."
        ),
        
        AttractionDetail(
            imageName: "attraction12",
            title: "Buckingham Palace",
            shortDescription: "The King's official London residence",
            region: "London",
            tags: ["2 hours", "Royal & Historic", "Royal", "Must-see"],
            timeNeeded: "2 hours",
            ticketInfo: "£30-£45 (State Rooms, summer only)",
            bestSeason: "Summer (July-September for State Rooms)",
            accessibility: "Accessible with advance notice",
            overviewText: "The working headquarters of the British monarchy, Buckingham Palace is an iconic symbol of Britain. The State Rooms are open to visitors in summer, offering a glimpse into royal life.",
            highlights: [
                "State Rooms tour (summer only)",
                "Changing of the Guard ceremony",
                "Royal Mews",
                "Queen's Gallery",
                "The Throne Room",
                "Palace gardens (summer tours)"
            ],
            historyText: "Originally built as a townhouse for the Duke of Buckingham in 1703, the building became the official royal residence in 1837 when Queen Victoria ascended the throne. It now serves as the administrative headquarters of the monarchy.",
            tips: [
                "State Rooms only open July-September - book well ahead",
                "Changing of the Guard is free (check schedule)",
                "Queen's Gallery and Royal Mews open year-round",
                "Arrive early for good Changing of the Guard views"
            ],
            gettingThere: "Victoria, St James's Park, or Green Park Underground stations (all 5-10 minute walk). Multiple bus routes to Victoria."
        ),
        
        AttractionDetail(
            imageName: "attraction13",
            title: "Cotswolds",
            shortDescription: "Quintessential English villages",
            region: "Countryside",
            tags: ["Full day", "Parks & Nature", "Free", "Villages", "Scenic"],
            timeNeeded: "Full day or multi-day",
            ticketInfo: "Free (individual attractions may charge)",
            bestSeason: "Spring and autumn",
            accessibility: "Varied by location",
            overviewText: "An Area of Outstanding Natural Beauty, the Cotswolds embody the English countryside with honey-colored stone villages, rolling hills, and timeless charm. Perfect for leisurely exploration.",
            highlights: [
                "Bourton-on-the-Water 'Venice of the Cotswolds'",
                "Bibury with Arlington Row",
                "Stow-on-the-Wold market town",
                "Broadway Tower viewpoint",
                "Cotswold Way walking trail",
                "Traditional tea rooms and pubs"
            ],
            historyText: "The Cotswolds prospered in medieval times from the wool trade, which funded the beautiful churches and manor houses seen today. The distinctive honey-colored limestone has been used in construction for centuries.",
            tips: [
                "Rent a car - public transport is limited",
                "Avoid peak summer weekends when villages get crowded",
                "Stay overnight to experience the peace",
                "Many excellent walks between villages"
            ],
            gettingThere: "Train to Moreton-in-Marsh, Kingham, or Oxford, then bus or car. From London: 2 hours by car. Multiple charming villages to explore."
        ),
        
        AttractionDetail(
            imageName: "attraction14",
            title: "Kew Gardens",
            shortDescription: "World-leading botanical gardens",
            region: "London",
            tags: ["3-4 hours", "Parks & Nature", "Nature", "Gardens", "Family-friendly"],
            timeNeeded: "3-4 hours",
            ticketInfo: "£19.50 adults, £6 children",
            bestSeason: "Spring for cherry blossoms, summer for roses",
            accessibility: "Fully accessible",
            overviewText: "A UNESCO World Heritage Site, Kew Gardens houses the world's largest collection of living plants. With glasshouses, galleries, and 330 acres of landscaped gardens, it's a botanical paradise.",
            highlights: [
                "Palm House Victorian glasshouse",
                "Temperate House - world's largest Victorian glasshouse",
                "Treetop Walkway",
                "Japanese Gateway and Garden",
                "Princess of Wales Conservatory",
                "Waterlily House"
            ],
            historyText: "Founded in 1840, Kew Gardens has played a vital role in global plant conservation and research for nearly 200 years. The gardens house over 30,000 different plants and a seed bank with billions of seeds.",
            tips: [
                "Book tickets online for discount",
                "Allow at least half a day to explore properly",
                "Different seasons offer different highlights",
                "Bring a picnic or use on-site cafes"
            ],
            gettingThere: "Kew Gardens Underground station (District line & Overground), 5-minute walk. Riverboat services also available from Westminster Pier (seasonal)."
        ),

        AttractionDetail(
            imageName: "attraction15",
            title: "Edinburgh Castle",
            shortDescription: "Historic fortress overlooking Scotland's capital",
            region: "Scotland",
            tags: ["2-4 hours", "History", "Castles", "City Landmark", "Scotland", "Family-friendly"],
            timeNeeded: "2-4 hours",
            ticketInfo: "~£19.50 adults, concessions available",
            bestSeason: "Spring–early autumn; August for Festival atmosphere",
            accessibility: "Partial accessibility due to historic structure",
            overviewText: "Dominating the skyline of Edinburgh, this iconic fortress has served as royal residence, military stronghold and national symbol for centuries.",
            highlights: [
                "Crown Jewels of Scotland",
                "Stone of Destiny",
                "Great Hall",
                "Mons Meg cannon",
                "Panoramic city views"
            ],
            historyText: "With origins in the 12th century, the castle has played a central role in Scotland's turbulent history and royal heritage.",
            tips: [
                "Arrive at opening time",
                "Buy tickets online",
                "Stay for the One O'Clock Gun",
                "Wear comfortable shoes"
            ],
            gettingThere: "Located at the top of the Royal Mile; 15-minute walk from Waverley Station."
        ),

        AttractionDetail(
            imageName: "attraction16",
            title: "Giant's Causeway",
            shortDescription: "Unique natural rock formation on the coast",
            region: "Northern Ireland",
            tags: ["2-3 hours", "Nature", "UNESCO", "Coastal Views", "Hiking", "Family-friendly"],
            timeNeeded: "2-3 hours",
            ticketInfo: "Free access to rocks; Visitor Centre ~£15 adults",
            bestSeason: "Late spring & summer for milder weather",
            accessibility: "Shuttle bus available; uneven terrain near rocks",
            overviewText: "This UNESCO World Heritage Site features around 40,000 interlocking basalt columns formed by volcanic activity millions of years ago.",
            highlights: [
                "Hexagonal basalt columns",
                "Coastal cliff trails",
                "Visitor Centre exhibition",
                "Legendary tales of Finn McCool",
                "Dramatic Atlantic views"
            ],
            historyText: "Formed by ancient volcanic eruptions, the site is steeped in Irish mythology and geological significance.",
            tips: [
                "Wear sturdy shoes",
                "Check weather forecast",
                "Visit early to avoid crowds",
                "Combine with Causeway Coastal Route drive"
            ],
            gettingThere: "Accessible by car; bus tours from Belfast available."
        ),

        AttractionDetail(
            imageName: "attraction17",
            title: "Snowdonia National Park",
            shortDescription: "Mountain landscapes and dramatic Welsh scenery",
            region: "Wales",
            tags: ["4-8 hours", "Nature", "Hiking", "Mountains", "Scenic Views", "Family-friendly"],
            timeNeeded: "4-8 hours",
            ticketInfo: "Free entry; parking fees apply",
            bestSeason: "Late spring to early autumn",
            accessibility: "Limited — terrain varies by trail",
            overviewText: "Home to Mount Snowdon (Yr Wyddfa), the highest peak in Wales, Snowdonia offers breathtaking mountain landscapes, lakes, and hiking trails for all levels.",
            highlights: [
                "Mount Snowdon summit",
                "Snowdon Mountain Railway",
                "Llyn Padarn",
                "Scenic hiking trails",
                "Welsh mountain villages"
            ],
            historyText: "Designated a national park in 1951, Snowdonia is rich in Welsh culture, legends, and industrial heritage.",
            tips: [
                "Check weather before hiking",
                "Start early for summit climbs",
                "Book railway tickets in advance",
                "Bring layered clothing"
            ],
            gettingThere: "Best accessed by car; trains to Bangor + bus connections available."
        ),

        AttractionDetail(
            imageName: "attraction18",
            title: "The Shard",
            shortDescription: "London's tallest skyscraper with panoramic views",
            region: "London",
            tags: ["1-2 hours", "City Views", "Modern Landmark", "Architecture", "Family-friendly"],
            timeNeeded: "1-2 hours",
            ticketInfo: "~£32 adults, discounts for children",
            bestSeason: "Year-round; sunset for best views",
            accessibility: "Fully accessible",
            overviewText: "Designed by Renzo Piano, The Shard is the tallest building in the UK. Its viewing platform offers 360° panoramic views across London's skyline.",
            highlights: [
                "Indoor & outdoor viewing decks",
                "360° London panorama",
                "Sunset city views",
                "Interactive digital displays",
                "Iconic glass architecture"
            ],
            historyText: "Completed in 2012, The Shard quickly became one of London's most recognizable modern landmarks.",
            tips: [
                "Book sunset time slot",
                "Check weather for clear visibility",
                "Combine with Borough Market visit",
                "Allow extra time for security"
            ],
            gettingThere: "Located next to London Bridge Station (Underground & National Rail)."
        )
    ]
}
