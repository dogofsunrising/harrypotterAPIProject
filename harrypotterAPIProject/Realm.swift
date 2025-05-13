import RealmSwift
import Foundation

class Result: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var harryPotterJSON: String?
    @Persisted var user_image: String
}
