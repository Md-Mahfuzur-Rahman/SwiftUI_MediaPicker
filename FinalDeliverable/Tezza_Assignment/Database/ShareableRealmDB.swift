 
import SwiftUI
import RealmSwift

class ShareableRealmDB  {
    static let shared = ShareableRealmDB()
    
    let userDefaults = UserDefaults.standard
    
    lazy var realm:Realm = {
        let schemaVersion = getSchemaVersion()
        do {
            let config = Realm.Configuration(
                // Set the new schema version. This must be greater than the previously used
                // version (if you've never set a schema version before, the version is 0).
                schemaVersion: schemaVersion,
                // Set the block which will be called automatically when opening a Realm with
                // a schema version lower than the one set above
                migrationBlock: { migration, oldSchemaVersion in
                    // We haven’t migrated anything yet, so oldSchemaVersion == 0
                    if (oldSchemaVersion < 1) {
                        // Nothing to do!
                        // Realm will automatically detect new properties and removed properties
                        // And will update the schema on disk automatically
                    }
                })
            // Tell Realm to use this new configuration object for the default Realm
            Realm.Configuration.defaultConfiguration = config
            let realm = try! Realm()
            print("ProjectSavingManager => Realm is in action \(schemaVersion)")
            return realm
        }
    }()
    private func getSchemaVersion() -> UInt64 {
        let version = userDefaults.value(forKey: "ShareableRealmDB_SchemaVersion") as! UInt64
        print("=== ShareableRealmDB_SchemaVersion = \(version)")
        return version
    }
    private func setSchemaVersion() {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        let versionNo = formatVersionString(appVersion)
        //let arrValues = appBuild.split(separator: ".")
        //let arrValues = appVersion.split(separator: ".")
        // Must have 3 value. Example: 1.0.0, //Each value should be maximum 2 digits
//        let versionNo = 1000000 * (arrValues[0] as NSString).integerValue +
//                        10000 * (arrValues[1] as NSString).integerValue +
//                        100 * (arrValues[2] as NSString).integerValue
//        let versionNo = 1000000 * (arrValues[0] as NSString).integerValue +
//                        10000 * (arrValues[1] as NSString).integerValue +
//                        100 * (arrValues[2] as NSString).integerValue

        //print("ProjectSavingManager schemaVersion: \(appVersion) \(appBuild) => \(versionNo)")
        //print("ProjectSavingManager schemaVersion: \(appVersion) => \(UInt64(versionNo))")
        //userDefaults.set(UInt64(versionNo), forKey: "ShareableRealmDB_SchemaVersion")
        userDefaults.set(UInt64(versionNo), forKey: "ShareableRealmDB_SchemaVersion")
    }
    private func formatVersionString(_ version: String) -> String {
        let components = version.components(separatedBy: ".")
        // Ensure there are at least three components
        guard components.count >= 3 else {
            return version // Invalid version format
        }
        let paddedComponents = components.map { component -> String in
            let padded = String(repeating: "0", count: max(0, 2 - component.count)) + component
            return padded
        }
        return paddedComponents.joined()
    }

    func setConfig(){
        setSchemaVersion()
        let schemaVersion = getSchemaVersion()
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: schemaVersion,
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
            })
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        print("ProjectSavingManager => Realm is in action \(schemaVersion)")
    }
}


