/*       Techdegree project #1
 
 First of all thank you so much for reviewing all that mess below,
 and I'm sorry for my spelling in advance! Cheers =)
 
 
 The following code is assigning ANY number of players to ANY number
 of teams while maintaining the average height of each team as close
 to the rest of the teams as possible
 
 Some input on how the general logic of the assigning process works:
 
 1. I decided to use Dictionaries of Tuples to store multiple types
 of data, all together in a consistent manner.
 
 2. I gave all the players an Integer Key for easier and more
 transparent referencing during assigning players to teams
 
 3. Inside the TEAMS Dictionary, I decided to store all information
 on each of the players, even though that is less effective vs.
 storing just a reference key, in this particular case it would
 be a better shot for a code's readability and logic transparency
 
 4. First I assign just the Experienced players to the TEAMS
 Dictionary and only then I assign inexperienced players
 Disregarding whether I assign an experienced or an inexperienced player
 the logic maintains the average team height balancing
 
 5. To implement balanced average height of the players in all teams
 I'm following a very straightforward logic:
 Find the team with a least total height (by total height I mean the sum
 of all of the team's players' height) and assign the tallest player
 remaining in the unassigned players list to that team. This should
 repeat unless all of the players are assigned
 
 6. Personalized letters are stored as a Dictionary with a String type
 key and a String type value to store the letter itself. As Date and
 Time is yet out of the scope of the course at the moment I'll use
 just a String values
 
*/

import UIKit

/*
 -----------------
 FUNCTIONS
 -----------------
 */

/*  --- tallestPlayer---
 This function receives:
 1. Boolean value for wheather we're looking for a tallest Experienced (true) or Inexperienced (false) player
 2. a Dictionary of all players
 
 This function returns:
A key for a tallest (experienced or inexperienced) player within provided players dictionary

 */
func tallestPlayer(amongExperienced isExperienced: Bool, _ players: [Int: (name: String, height: Int, hasExperience: Bool, guardianName: String)]) -> (Int) {
    var playerBuffer: (index: Int, player: (name: String, height: Int, hasExperience: Bool, guardianName: String)) = (-1, ("", -1, false, ""))
    for player in players {
        if player.value.hasExperience == isExperienced {
            if playerBuffer.player.height == 0 { //cheching if the buffer is empty i.e. weather it's the first time we run the loop
                playerBuffer.player = player.value
                playerBuffer.index = player.key
            } else if playerBuffer.player.height <= player.value.height { //checking if the stored height is higher then the one pulled out of the players Dictionary
                playerBuffer.player = player.value
                playerBuffer.index = player.key
            }
        }
    }
    return playerBuffer.index
}


/*  --- shortestTeam---
 This function receives:
 1. A Dictioanary of all teams at the moment
 
 This function returns:
 A String type key of the team with a least total height.
 
 */
func shortestTeam(among teams: [String: [(name: String, height: Int, hasExperience: Bool, guardianName: String)]]) -> (String) {
    let totalHeightOfTeams = totalHeightOf(teams) // Calls the totalHeightOf function to get the height valuse to compare
    var leastTotalHeightBuffer: (teamName: String, totalHeight: Int) = ("", 0)
    for totalHeightOfTeam in totalHeightOfTeams {
        if leastTotalHeightBuffer.teamName == "" && leastTotalHeightBuffer.totalHeight == 0 { //appending a very first value to the buffer variable
            leastTotalHeightBuffer = (totalHeightOfTeam.key, totalHeightOfTeam.value)         //to compare with in a further iterations
        } else if leastTotalHeightBuffer.totalHeight >= totalHeightOfTeam.value {             //checking if the stored height in the buffer is realy the least
            leastTotalHeightBuffer = (totalHeightOfTeam.key, totalHeightOfTeam.value)
        }
    }
    return leastTotalHeightBuffer.teamName
}

/*  ---totalHeightOf---
 This function receives:
 1. A Dictioanary of all teams at the moment
 
 This function returns:
 A Dictionary with a String type key (stores team's name) and an Integer value (to store team's total height).
 
 */
func totalHeightOf(_ teams: [String: [(name: String, height: Int, hasExperience: Bool, guardianName: String)]]) -> ([String: Int]){
    var teamsHeight: [String: Int] = [:] // Declaring an empty Dictionary to store each team's summary height
    for team in teams {
        if !team.value.isEmpty{ //Checking if the team is empty (no players were assigned yet)
            for player in team.value {
                if teamsHeight[team.key] == nil {         //Checking if the Value for current key is empty
                    teamsHeight[team.key] = player.height  //Assingning initial value for key in the height Dictionary
                } else {
                    teamsHeight[team.key]! += player.height //Adding up to the existing height value
                }
            }
        } else {
            teamsHeight[team.key] = 0
        }
    }
    return teamsHeight
}

/*  ---assign---
 This function receives:
 1. A Dictioanary of all teams at the moment
 
 This function returns:
 A Dictionary with a String type key (stores team's name) and an Array of players as a vlue for key to store all the teams' players.
 
 */
func assign(_ players: [Int: (name: String, height: Int, hasExperience: Bool, guardianName: String)], to teams: [String: [(name: String, height: Int, hasExperience: Bool, guardianName: String)]]) -> ([String: [(name: String, height: Int, hasExperience: Bool, guardianName: String)]]){
    var playersMutable = players //mutable variable to store all players list.
    var teamsMutable = teams //mutable variable to store players assigned for each team
    
    while tallestPlayer(amongExperienced: true, playersMutable) >= 0 {   // Here I assign the experienced players to the teams
        //the following line calls the shortestTeam function to find whitch team has least height at the moment and assigns a tallest player (done through the tallestPlayer function call) to it and at the same time this player is removed from the playersMutable Dictionary
        teamsMutable[shortestTeam(among: teamsMutable)]?.append(playersMutable.removeValue(forKey: tallestPlayer(amongExperienced: true, playersMutable))!)
    }
    
    while tallestPlayer(amongExperienced: false, playersMutable) >= 0 { // Here I assign the inexperienced players to the teams - a bit of a violation of the DRY principle =)
               //the following line calls the shortestTeam function to find whitch team has least height at the moment and assigns a tallest player (done through the tallestPlayer function call) to it and at the same time this player is removed from the playersMutable Dictionary
        teamsMutable[shortestTeam(among: teamsMutable)]?.append(playersMutable.removeValue(forKey: tallestPlayer(amongExperienced: false, playersMutable))!)
    }
    
    return teamsMutable
}

func printTheAverageHeight(of teams: [String: [(name: String, height: Int, hasExperience: Bool, guardianName: String)]]) {
    var averageHeight: Double
    var totalHeight: Double
    var numberOfPlayersInTeam: Int
    for team in teams {
        averageHeight = 0
        totalHeight = 0
        numberOfPlayersInTeam = 0
        for player in team.value{
            numberOfPlayersInTeam += 1
            totalHeight += Double(player.height)
        }
        averageHeight = totalHeight / Double(numberOfPlayersInTeam)
        print("An average height of \"\(team.key)\" soccer team is \(String(format: "%.2f", averageHeight))\"")
    }
}

/*  ---makeLetters---
 This function receives:
 1. A Dictionarry of all the players
 2. A Dictionary of all teams at the moment
 3. A Dictionary of dates for teams' first practice day
 
 
 This function returns:
 A Dictionary with an Int type key (stores player's reference) and a String type as a value for key to store all the letters.
 
 */
func makeLetters(for players:  [Int: (name: String, height: Int, hasExperience: Bool, guardianName: String)], asMembersOf teams: [String: [(name: String, height: Int, hasExperience: Bool, guardianName: String)]], for firstTeamsPracticeDates: [String: String]) -> ([Int: String]) {
    var lettersToGuardians: [Int: String] = [:]
    for team in teams {
        for teamMember in team.value {
            for playerKey in players {
                if playerKey.value.name == teamMember.name {
                    lettersToGuardians[playerKey.key] =
                    "Dear \(teamMember.guardianName)!\n\nI'm very proud to inform you that \(teamMember.name) is now a player for \(team.key) soccer team,\nplease fell free to come to the frist \(team.key)'s practice session on \(firstTeamsPracticeDates[team.key] ?? "DEFAULT DATE - SOMETHING IS MISSING HERE!!!").\n\nSincerly yours,\nCouch."
                }
            }
        }
    }
    return lettersToGuardians
}

/*  ---printThe---
 This function receives:
 1. A Dictionarry of all the letters
 2. A Dictionary of all the players
 
 
 This function returns:
 VOID
 */
func printThe(_ lettersToGuardians: [Int: String], of players:  [Int: (name: String, height: Int, hasExperience: Bool, guardianName: String)]){
    let divider = "\n------------------------------------------------------------------------------------------\n"
    for letterToGuardians in lettersToGuardians{
        print("\(divider)The following letter is for \(players[letterToGuardians.key]?.name ?? "DEFAULT PLAYER NAME - SOMETHING IS MISSING HERE!!!")'s guardians.\(divider)\n\(letterToGuardians.value)\(divider)\n")
    }
}

/*
 -----------------
 END OF FUNCTIONS
 -----------------
 */

// Declaring and assigning the main players list as a Dictionary of Tuples
let players: [Int: (name: String, height: Int, hasExperience: Bool, guardianName: String)] = [
    0: ("Joe Smith", 42, true, "Jim and Jan Smith"),
    1: ("Jill Tanner", 36, true, "Clara Tanner"),
    2: ("Bill Bon", 43, true, "Sara and Jenny Bon"),
    3: ("Eva Gordon", 45, false, "Wendy and Mike Gordon"),
    4: ("Matt Gill", 40, false, "Charles and Sylvia Gill"),
    5: ("Kimmy Stein", 41, false, "Bill and Hillary Stein"),
    6: ("Sammy Adams", 45, false, "Jeff Adams"),
    7: ("Karl Saygan", 42, true, "Heather Bledsoe"),
    8: ("Suzane Greenberg", 44, true, "Henrietta Dumas"),
    9: ("Sal Dali", 41, false, "Gala Dali"),
    10: ("Joe Kavalier", 39, false, "Sam and Elaine Kavalier"),
    11: ("Ben Finkelstein", 44, false, "Aaron and Jill Finkelstein"),
    12: ("Diego Soto", 41, true, "Robin and Sarika Soto"),
    13: ("Chloe Alaska", 47, false, "David and Jamie Alaska"),
    14: ("Arnold Willis", 43, false, "Claire Willis"),
    15: ("Phillip Helm", 44, true, "Thomas Helm and Eva Jones"),
    16: ("Les Clay", 42, true, "Wynonna Brown"),
    17: ("Herschel Krustofski", 45, true, "Hyman and Rachel Krustofski")
    ]

//Declaring team names as a variable of Dictionary of Arrays of Tuples.
//Initially only team names are declared
var teams: [String: [(name: String, height: Int, hasExperience: Bool, guardianName: String)]] =
    ["Dragons": [],
     "Sharks": [],
     "Raptors": []]

//Declaring the first practice days Dictionary as a constant
let firstTeamsPracticeDates: [String: String] =
    ["Dragons": "March 17, 1pm",
     "Sharks": "March 17, 3pm",
     "Raptors": "March 18, 1pm"]

teams = assign(players, to: teams) // Assigning players to teams
printTheAverageHeight(of: teams)

//Declaring the letters Dictionary as a constant and calling the makeLetters function to fill the Dictionary
//Here I'm using the Int type as a key which corresponds to a player's Dictionary key
let letters: [Int: String] = makeLetters(for: players, asMembersOf: teams, for: firstTeamsPracticeDates)

printThe(letters, of: players)

