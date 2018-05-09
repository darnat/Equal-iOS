//
//  Holder.swift
//  Equal
//
//  Created by Alexis DARNAT on 4/23/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import CoreData

@objc(Holder)
public final class Holder: Model {

    private enum CodingKeys: String, CodingKey {
        case percentage, payer, participant_id
        static let allValues = [percentage, payer, participant_id]
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.value(forKey: "percentage") as? Double, forKey: .percentage)
        try container.encode(self.value(forKey: "payer") as? Bool, forKey: .payer)
        try container.encodeIfPresent(self.value(forKeyPath: "participant.id") as? Int, forKey: .participant_id)
    }
}

extension Holder: CoreDataDecodable, Synchronizable {
    public struct DTO: Decodable & HasPrimaryKey {
        public var id: Int
        let payer: Bool
        let percentage: Double
        let participantId: Int
    }

    public func update(from dto: DTO) throws {
        self.setValue(dto.id, forKey: "id")
        self.setValue(dto.payer, forKey: "payer")
        self.setValue(dto.percentage, forKey: "percentage")
        guard let moc = managedObjectContext else { return }
        let participant = try Participant.FindFirst(in: moc, with: NSPredicate(format: "id == %d", dto.participantId))
        self.setValue(participant, forKey: "participant")
    }
}
