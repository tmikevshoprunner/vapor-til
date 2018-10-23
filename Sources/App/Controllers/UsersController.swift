import Vapor

struct UsersController: RouteCollection {
    
    func boot(router: Router) throws {
        let userGroup = router.grouped("api", "users")
        
        userGroup.get(use: getAllHandler)
        userGroup.get(User.parameter, use: getHandler)
        userGroup.get(User.parameter, "acronyms", use: getAcronymsHandler)
        userGroup.post(User.self, use: createHandler)
    }
    
    func createHandler(_ req: Request, user: User) throws -> Future<User> {
        return user.save(on: req)
    }
    
    func getAllHandler(_ req: Request) throws -> Future<[User]> {
        return User.query(on: req).all()
    }
    
    func getHandler(_ req: Request) throws -> Future<User> {
        return try req.parameters.next(User.self)
    }
    
    func getAcronymsHandler(_ req: Request) throws -> Future<[Acronym]> {
        return try req.parameters.next(User.self).flatMap(to: [Acronym].self, { (user) in
            return try user.acronyms.query(on: req).all()
        })
    }
}
