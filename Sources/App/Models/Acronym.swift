import Vapor
import FluentPostgreSQL

final class Acronym: Codable {
    var id: Int?
    var short: String
    var long: String
    
    var userID: User.ID
    
    init(short: String, long: String, userID: User.ID) {
        self.short = short
        self.long = long
        self.userID = userID
    }
}

extension Acronym: PostgreSQLModel {}
extension Acronym: Content {}
extension Acronym: Parameter {}

extension Acronym {
    
    var user: Parent<Acronym, User> {
        return parent(\.userID)
    }
    
}

extension Acronym: Migration {
    
    static func prepare(on conn: Database.Connection) -> Future<Void> {
        return Database.create(self, on: conn, closure: { (builder) in
            try addProperties(to: builder)
            
            builder.reference(from: \.userID, to: \User.id)
        })
    }

}
