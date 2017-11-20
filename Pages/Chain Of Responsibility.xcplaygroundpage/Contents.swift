import UIKit

/*:

 Chain Of Responsibility
 --------------------------

 ### Description:
- The Chain of Responsibility pattern avoids coupling the sender of a request to the receiver by giving more than one object a chance to handle the request. ATM use the Chain of Responsibility in money giving mechanism.
 */
/*:
 ### Example
 */
/*:
- Skill of Developer
*/
enum Skill: Int {
    case junior = 1, senior
}

extension Skill: Comparable {
    static func <(lhs: Skill, rhs: Skill) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

/*:
- Ticket
*/
class Ticket {
    let minimumSkillSet: Skill
    let name: String
    var isCompleted: Bool

    init(minimumSkillSet: Skill, name: String, completed: Bool = false) {
        self.minimumSkillSet = minimumSkillSet
        self.name = name
        self.isCompleted = completed
    }
}

/*:
 - Developer
 */

class Developer {
    let name: String
    let skill: Skill
    var isBusy: Bool
    var nextDev: Developer?

    init(name: String, skill: Skill, isBusy: Bool = false, nextDev: Developer?) {
        self.name = name
        self.skill = skill
        self.isBusy = isBusy
        self.nextDev = nextDev
    }

    func startWork(on ticket: Ticket) -> Bool {

        guard skill >= ticket.minimumSkillSet && !isBusy else {
            print("Error: " + "\(name) is busy or not have enough experience for this ticket")
            guard let nextDev = nextDev else {
                print("No one is available for this ticket")
                return false
            }
            return nextDev.startWork(on:ticket)
        }

        isBusy = true
        print("\(name)(\(skill)) has started to work on ticket called: \(ticket.name)")
        ticket.isCompleted = true
        return true
    }
}

class DevTeam {

    var developers: [Developer]

    private var firstDevForTicket: Developer {
        return developers.first!
    }

    init(_ developers: [Developer]) {
        self.developers = developers
    }

    func startWork(on ticket: Ticket) {
        firstDevForTicket.startWork(on: ticket)
    }
}

/*:
 ### Usage
 */
let matej =   Developer(name: "Matej", skill: .senior, nextDev: nil)
let andreas = Developer(name: "Andreas", skill: .senior, nextDev: matej)
let yani =   Developer(name: "Yani", skill: .junior, nextDev: andreas)
let alper =   Developer(name: "Alper", skill: .junior, nextDev: yani)

var develoloperTeam = DevTeam([alper, andreas, matej])

var tickets = [Ticket(minimumSkillSet: .junior, name: "Change texts"),
               Ticket(minimumSkillSet: .junior, name: "Fix memory leaks"),
               Ticket(minimumSkillSet: .junior, name: "Send application to fabric for testing"),
               Ticket(minimumSkillSet: .junior, name: "Change provisioning profiles"),
               Ticket(minimumSkillSet: .junior, name: "Release application on appstore")]

for ticket in tickets {
    print ("\n Starting to work on ticket: \(ticket.name)" +
           "\n Status of Developers:")
    develoloperTeam.startWork(on: ticket)
}

/*:
 >**Further Examples:** [Design Patterns in Swift](https://github.com/kingreza/Swift-Chain-Of-Responsibility)
 */
