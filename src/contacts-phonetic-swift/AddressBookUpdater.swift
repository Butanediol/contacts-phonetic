import AddressBook

struct AddressBookUpdater {
    private let converter: PhoneticConverter
    private let overwritesExisting: Bool

    init(converter: PhoneticConverter, overwritesExisting: Bool) {
        self.converter = converter
        self.overwritesExisting = overwritesExisting
    }

    func run() {
        guard let addressBook = ABAddressBook.shared() else { return }

        print("--------------------")
        (addressBook.people() ?? []).compactMap { $0 as? ABPerson }.forEach(update)
        _ = addressBook.save()
    }

    private func update(_ person: ABPerson) {
        let givenName = person.string(for: kABFirstNameProperty)
        let familyName = person.string(for: kABLastNameProperty)
        guard givenName != nil || familyName != nil else { return }

        print("\(givenName ?? "") \(familyName ?? "")")

        let phoneticGivenName = updatedPhoneticName(
            current: person.string(for: kABFirstNamePhoneticProperty),
            source: givenName
        )
        let phoneticFamilyName = updatedPhoneticName(
            current: person.string(for: kABLastNamePhoneticProperty),
            source: familyName
        )

        person.set(phoneticGivenName, for: kABFirstNamePhoneticProperty)
        person.set(phoneticFamilyName, for: kABLastNamePhoneticProperty)

        if phoneticGivenName != nil || phoneticFamilyName != nil {
            print("\r\(phoneticGivenName ?? "") \(phoneticFamilyName ?? "")")
        }
        print("--------------------")
    }

    private func updatedPhoneticName(current: String?, source: String?) -> String? {
        let result = overwritesExisting || current?.isEmpty != false
            ? source.flatMap(converter.convert)
            : current
        return result == source ? nil : result
    }
}

private extension ABPerson {
    func string(for property: String) -> String? {
        value(forProperty: property) as? String
    }

    func set(_ value: String?, for property: String) {
        if let value {
            setValue(value, forProperty: property)
        } else {
            removeValue(forProperty: property)
        }
    }
}
