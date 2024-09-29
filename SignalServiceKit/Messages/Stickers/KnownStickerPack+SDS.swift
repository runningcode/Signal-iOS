//
// Copyright 2022 Signal Messenger, LLC
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation
public import GRDB

// NOTE: This file is generated by /Scripts/sds_codegen/sds_generate.py.
// Do not manually edit it, instead run `sds_codegen.sh`.

// MARK: - Record

public struct KnownStickerPackRecord: SDSRecord {
    public weak var delegate: SDSRecordDelegate?

    public var tableMetadata: SDSTableMetadata {
        KnownStickerPackSerializer.table
    }

    public static var databaseTableName: String {
        KnownStickerPackSerializer.table.tableName
    }

    public var id: Int64?

    // This defines all of the columns used in the table
    // where this model (and any subclasses) are persisted.
    public let recordType: SDSRecordType
    public let uniqueId: String

    // Properties
    public let dateCreated: Double
    public let info: Data
    public let referenceCount: Int

    public enum CodingKeys: String, CodingKey, ColumnExpression, CaseIterable {
        case id
        case recordType
        case uniqueId
        case dateCreated
        case info
        case referenceCount
    }

    public static func columnName(_ column: KnownStickerPackRecord.CodingKeys, fullyQualified: Bool = false) -> String {
        fullyQualified ? "\(databaseTableName).\(column.rawValue)" : column.rawValue
    }

    public func didInsert(with rowID: Int64, for column: String?) {
        guard let delegate = delegate else {
            owsFailDebug("Missing delegate.")
            return
        }
        delegate.updateRowId(rowID)
    }
}

// MARK: - Row Initializer

public extension KnownStickerPackRecord {
    static var databaseSelection: [SQLSelectable] {
        CodingKeys.allCases
    }

    init(row: Row) {
        id = row[0]
        recordType = row[1]
        uniqueId = row[2]
        dateCreated = row[3]
        info = row[4]
        referenceCount = row[5]
    }
}

// MARK: - StringInterpolation

public extension String.StringInterpolation {
    mutating func appendInterpolation(knownStickerPackColumn column: KnownStickerPackRecord.CodingKeys) {
        appendLiteral(KnownStickerPackRecord.columnName(column))
    }
    mutating func appendInterpolation(knownStickerPackColumnFullyQualified column: KnownStickerPackRecord.CodingKeys) {
        appendLiteral(KnownStickerPackRecord.columnName(column, fullyQualified: true))
    }
}

// MARK: - Deserialization

extension KnownStickerPack {
    // This method defines how to deserialize a model, given a
    // database row.  The recordType column is used to determine
    // the corresponding model class.
    class func fromRecord(_ record: KnownStickerPackRecord) throws -> KnownStickerPack {

        guard let recordId = record.id else {
            throw SDSError.invalidValue()
        }

        switch record.recordType {
        case .knownStickerPack:

            let uniqueId: String = record.uniqueId
            let dateCreatedInterval: Double = record.dateCreated
            let dateCreated: Date = SDSDeserialization.requiredDoubleAsDate(dateCreatedInterval, name: "dateCreated")
            let infoSerialized: Data = record.info
            let info: StickerPackInfo = try SDSDeserialization.unarchive(infoSerialized, name: "info")
            let referenceCount: Int = record.referenceCount

            return KnownStickerPack(grdbId: recordId,
                                    uniqueId: uniqueId,
                                    dateCreated: dateCreated,
                                    info: info,
                                    referenceCount: referenceCount)

        default:
            owsFailDebug("Unexpected record type: \(record.recordType)")
            throw SDSError.invalidValue()
        }
    }
}

// MARK: - SDSModel

extension KnownStickerPack: SDSModel {
    public var serializer: SDSSerializer {
        // Any subclass can be cast to it's superclass,
        // so the order of this switch statement matters.
        // We need to do a "depth first" search by type.
        switch self {
        default:
            return KnownStickerPackSerializer(model: self)
        }
    }

    public func asRecord() throws -> SDSRecord {
        try serializer.asRecord()
    }

    public var sdsTableName: String {
        KnownStickerPackRecord.databaseTableName
    }

    public static var table: SDSTableMetadata {
        KnownStickerPackSerializer.table
    }
}

// MARK: - DeepCopyable

extension KnownStickerPack: DeepCopyable {

    public func deepCopy() throws -> AnyObject {
        // Any subclass can be cast to it's superclass,
        // so the order of this switch statement matters.
        // We need to do a "depth first" search by type.
        guard let id = self.grdbId?.int64Value else {
            throw OWSAssertionError("Model missing grdbId.")
        }

        do {
            let modelToCopy = self
            assert(type(of: modelToCopy) == KnownStickerPack.self)
            let uniqueId: String = modelToCopy.uniqueId
            let dateCreated: Date = modelToCopy.dateCreated
            // NOTE: If this generates build errors, you made need to
            // implement DeepCopyable for this type in DeepCopy.swift.
            let info: StickerPackInfo = try DeepCopies.deepCopy(modelToCopy.info)
            let referenceCount: Int = modelToCopy.referenceCount

            return KnownStickerPack(grdbId: id,
                                    uniqueId: uniqueId,
                                    dateCreated: dateCreated,
                                    info: info,
                                    referenceCount: referenceCount)
        }

    }
}

// MARK: - Table Metadata

extension KnownStickerPackSerializer {

    // This defines all of the columns used in the table
    // where this model (and any subclasses) are persisted.
    static var idColumn: SDSColumnMetadata { SDSColumnMetadata(columnName: "id", columnType: .primaryKey) }
    static var recordTypeColumn: SDSColumnMetadata { SDSColumnMetadata(columnName: "recordType", columnType: .int64) }
    static var uniqueIdColumn: SDSColumnMetadata { SDSColumnMetadata(columnName: "uniqueId", columnType: .unicodeString, isUnique: true) }
    // Properties
    static var dateCreatedColumn: SDSColumnMetadata { SDSColumnMetadata(columnName: "dateCreated", columnType: .double) }
    static var infoColumn: SDSColumnMetadata { SDSColumnMetadata(columnName: "info", columnType: .blob) }
    static var referenceCountColumn: SDSColumnMetadata { SDSColumnMetadata(columnName: "referenceCount", columnType: .int64) }

    public static var table: SDSTableMetadata {
        SDSTableMetadata(
            tableName: "model_KnownStickerPack",
            columns: [
                idColumn,
                recordTypeColumn,
                uniqueIdColumn,
                dateCreatedColumn,
                infoColumn,
                referenceCountColumn,
            ]
        )
    }
}

// MARK: - Save/Remove/Update

@objc
public extension KnownStickerPack {
    func anyInsert(transaction: SDSAnyWriteTransaction) {
        sdsSave(saveMode: .insert, transaction: transaction)
    }

    // Avoid this method whenever feasible.
    //
    // If the record has previously been saved, this method does an overwriting
    // update of the corresponding row, otherwise if it's a new record, this
    // method inserts a new row.
    //
    // For performance, when possible, you should explicitly specify whether
    // you are inserting or updating rather than calling this method.
    func anyUpsert(transaction: SDSAnyWriteTransaction) {
        let isInserting: Bool
        if KnownStickerPack.anyFetch(uniqueId: uniqueId, transaction: transaction) != nil {
            isInserting = false
        } else {
            isInserting = true
        }
        sdsSave(saveMode: isInserting ? .insert : .update, transaction: transaction)
    }

    // This method is used by "updateWith..." methods.
    //
    // This model may be updated from many threads. We don't want to save
    // our local copy (this instance) since it may be out of date.  We also
    // want to avoid re-saving a model that has been deleted.  Therefore, we
    // use "updateWith..." methods to:
    //
    // a) Update a property of this instance.
    // b) If a copy of this model exists in the database, load an up-to-date copy,
    //    and update and save that copy.
    // b) If a copy of this model _DOES NOT_ exist in the database, do _NOT_ save
    //    this local instance.
    //
    // After "updateWith...":
    //
    // a) Any copy of this model in the database will have been updated.
    // b) The local property on this instance will always have been updated.
    // c) Other properties on this instance may be out of date.
    //
    // All mutable properties of this class have been made read-only to
    // prevent accidentally modifying them directly.
    //
    // This isn't a perfect arrangement, but in practice this will prevent
    // data loss and will resolve all known issues.
    func anyUpdate(transaction: SDSAnyWriteTransaction, block: (KnownStickerPack) -> Void) {

        block(self)

        guard let dbCopy = type(of: self).anyFetch(uniqueId: uniqueId,
                                                   transaction: transaction) else {
            return
        }

        // Don't apply the block twice to the same instance.
        // It's at least unnecessary and actually wrong for some blocks.
        // e.g. `block: { $0 in $0.someField++ }`
        if dbCopy !== self {
            block(dbCopy)
        }

        dbCopy.sdsSave(saveMode: .update, transaction: transaction)
    }

    // This method is an alternative to `anyUpdate(transaction:block:)` methods.
    //
    // We should generally use `anyUpdate` to ensure we're not unintentionally
    // clobbering other columns in the database when another concurrent update
    // has occurred.
    //
    // There are cases when this doesn't make sense, e.g. when  we know we've
    // just loaded the model in the same transaction. In those cases it is
    // safe and faster to do a "overwriting" update
    func anyOverwritingUpdate(transaction: SDSAnyWriteTransaction) {
        sdsSave(saveMode: .update, transaction: transaction)
    }

    func anyRemove(transaction: SDSAnyWriteTransaction) {
        sdsRemove(transaction: transaction)
    }

    func anyReload(transaction: SDSAnyReadTransaction) {
        anyReload(transaction: transaction, ignoreMissing: false)
    }

    func anyReload(transaction: SDSAnyReadTransaction, ignoreMissing: Bool) {
        guard let latestVersion = type(of: self).anyFetch(uniqueId: uniqueId, transaction: transaction) else {
            if !ignoreMissing {
                owsFailDebug("`latest` was unexpectedly nil")
            }
            return
        }

        setValuesForKeys(latestVersion.dictionaryValue)
    }
}

// MARK: - KnownStickerPackCursor

@objc
public class KnownStickerPackCursor: NSObject, SDSCursor {
    private let transaction: GRDBReadTransaction
    private let cursor: RecordCursor<KnownStickerPackRecord>?

    init(transaction: GRDBReadTransaction, cursor: RecordCursor<KnownStickerPackRecord>?) {
        self.transaction = transaction
        self.cursor = cursor
    }

    public func next() throws -> KnownStickerPack? {
        guard let cursor = cursor else {
            return nil
        }
        guard let record = try cursor.next() else {
            return nil
        }
        return try KnownStickerPack.fromRecord(record)
    }

    public func all() throws -> [KnownStickerPack] {
        var result = [KnownStickerPack]()
        while true {
            guard let model = try next() else {
                break
            }
            result.append(model)
        }
        return result
    }
}

// MARK: - Obj-C Fetch

@objc
public extension KnownStickerPack {
    class func grdbFetchCursor(transaction: GRDBReadTransaction) -> KnownStickerPackCursor {
        let database = transaction.database
        do {
            let cursor = try KnownStickerPackRecord.fetchCursor(database)
            return KnownStickerPackCursor(transaction: transaction, cursor: cursor)
        } catch {
            DatabaseCorruptionState.flagDatabaseReadCorruptionIfNecessary(
                userDefaults: CurrentAppContext().appUserDefaults(),
                error: error
            )
            owsFailDebug("Read failed: \(error)")
            return KnownStickerPackCursor(transaction: transaction, cursor: nil)
        }
    }

    // Fetches a single model by "unique id".
    class func anyFetch(uniqueId: String,
                        transaction: SDSAnyReadTransaction) -> KnownStickerPack? {
        assert(!uniqueId.isEmpty)

        switch transaction.readTransaction {
        case .grdbRead(let grdbTransaction):
            let sql = "SELECT * FROM \(KnownStickerPackRecord.databaseTableName) WHERE \(knownStickerPackColumn: .uniqueId) = ?"
            return grdbFetchOne(sql: sql, arguments: [uniqueId], transaction: grdbTransaction)
        }
    }

    // Traverses all records.
    // Records are not visited in any particular order.
    class func anyEnumerate(
        transaction: SDSAnyReadTransaction,
        block: (KnownStickerPack, UnsafeMutablePointer<ObjCBool>) -> Void
    ) {
        anyEnumerate(transaction: transaction, batched: false, block: block)
    }

    // Traverses all records.
    // Records are not visited in any particular order.
    class func anyEnumerate(
        transaction: SDSAnyReadTransaction,
        batched: Bool = false,
        block: (KnownStickerPack, UnsafeMutablePointer<ObjCBool>) -> Void
    ) {
        let batchSize = batched ? Batching.kDefaultBatchSize : 0
        anyEnumerate(transaction: transaction, batchSize: batchSize, block: block)
    }

    // Traverses all records.
    // Records are not visited in any particular order.
    //
    // If batchSize > 0, the enumeration is performed in autoreleased batches.
    class func anyEnumerate(
        transaction: SDSAnyReadTransaction,
        batchSize: UInt,
        block: (KnownStickerPack, UnsafeMutablePointer<ObjCBool>) -> Void
    ) {
        switch transaction.readTransaction {
        case .grdbRead(let grdbTransaction):
            let cursor = KnownStickerPack.grdbFetchCursor(transaction: grdbTransaction)
            Batching.loop(batchSize: batchSize,
                          loopBlock: { stop in
                                do {
                                    guard let value = try cursor.next() else {
                                        stop.pointee = true
                                        return
                                    }
                                    block(value, stop)
                                } catch let error {
                                    owsFailDebug("Couldn't fetch model: \(error)")
                                }
                              })
        }
    }

    // Traverses all records' unique ids.
    // Records are not visited in any particular order.
    class func anyEnumerateUniqueIds(
        transaction: SDSAnyReadTransaction,
        block: (String, UnsafeMutablePointer<ObjCBool>) -> Void
    ) {
        anyEnumerateUniqueIds(transaction: transaction, batched: false, block: block)
    }

    // Traverses all records' unique ids.
    // Records are not visited in any particular order.
    class func anyEnumerateUniqueIds(
        transaction: SDSAnyReadTransaction,
        batched: Bool = false,
        block: (String, UnsafeMutablePointer<ObjCBool>) -> Void
    ) {
        let batchSize = batched ? Batching.kDefaultBatchSize : 0
        anyEnumerateUniqueIds(transaction: transaction, batchSize: batchSize, block: block)
    }

    // Traverses all records' unique ids.
    // Records are not visited in any particular order.
    //
    // If batchSize > 0, the enumeration is performed in autoreleased batches.
    class func anyEnumerateUniqueIds(
        transaction: SDSAnyReadTransaction,
        batchSize: UInt,
        block: (String, UnsafeMutablePointer<ObjCBool>) -> Void
    ) {
        switch transaction.readTransaction {
        case .grdbRead(let grdbTransaction):
            grdbEnumerateUniqueIds(transaction: grdbTransaction,
                                   sql: """
                    SELECT \(knownStickerPackColumn: .uniqueId)
                    FROM \(KnownStickerPackRecord.databaseTableName)
                """,
                batchSize: batchSize,
                block: block)
        }
    }

    // Does not order the results.
    class func anyFetchAll(transaction: SDSAnyReadTransaction) -> [KnownStickerPack] {
        var result = [KnownStickerPack]()
        anyEnumerate(transaction: transaction) { (model, _) in
            result.append(model)
        }
        return result
    }

    // Does not order the results.
    class func anyAllUniqueIds(transaction: SDSAnyReadTransaction) -> [String] {
        var result = [String]()
        anyEnumerateUniqueIds(transaction: transaction) { (uniqueId, _) in
            result.append(uniqueId)
        }
        return result
    }

    class func anyCount(transaction: SDSAnyReadTransaction) -> UInt {
        switch transaction.readTransaction {
        case .grdbRead(let grdbTransaction):
            return KnownStickerPackRecord.ows_fetchCount(grdbTransaction.database)
        }
    }

    class func anyRemoveAllWithInstantiation(transaction: SDSAnyWriteTransaction) {
        // To avoid mutationDuringEnumerationException, we need to remove the
        // instances outside the enumeration.
        let uniqueIds = anyAllUniqueIds(transaction: transaction)

        for uniqueId in uniqueIds {
            autoreleasepool {
                guard let instance = anyFetch(uniqueId: uniqueId, transaction: transaction) else {
                    owsFailDebug("Missing instance.")
                    return
                }
                instance.anyRemove(transaction: transaction)
            }
        }
    }

    class func anyExists(
        uniqueId: String,
        transaction: SDSAnyReadTransaction
    ) -> Bool {
        assert(!uniqueId.isEmpty)

        switch transaction.readTransaction {
        case .grdbRead(let grdbTransaction):
            let sql = "SELECT EXISTS ( SELECT 1 FROM \(KnownStickerPackRecord.databaseTableName) WHERE \(knownStickerPackColumn: .uniqueId) = ? )"
            let arguments: StatementArguments = [uniqueId]
            do {
                return try Bool.fetchOne(grdbTransaction.database, sql: sql, arguments: arguments) ?? false
            } catch {
                DatabaseCorruptionState.flagDatabaseReadCorruptionIfNecessary(
                    userDefaults: CurrentAppContext().appUserDefaults(),
                    error: error
                )
                owsFail("Missing instance.")
            }
        }
    }
}

// MARK: - Swift Fetch

public extension KnownStickerPack {
    class func grdbFetchCursor(sql: String,
                               arguments: StatementArguments = StatementArguments(),
                               transaction: GRDBReadTransaction) -> KnownStickerPackCursor {
        do {
            let sqlRequest = SQLRequest<Void>(sql: sql, arguments: arguments, cached: true)
            let cursor = try KnownStickerPackRecord.fetchCursor(transaction.database, sqlRequest)
            return KnownStickerPackCursor(transaction: transaction, cursor: cursor)
        } catch {
            DatabaseCorruptionState.flagDatabaseReadCorruptionIfNecessary(
                userDefaults: CurrentAppContext().appUserDefaults(),
                error: error
            )
            owsFailDebug("Read failed: \(error)")
            return KnownStickerPackCursor(transaction: transaction, cursor: nil)
        }
    }

    class func grdbFetchOne(sql: String,
                            arguments: StatementArguments = StatementArguments(),
                            transaction: GRDBReadTransaction) -> KnownStickerPack? {
        assert(!sql.isEmpty)

        do {
            let sqlRequest = SQLRequest<Void>(sql: sql, arguments: arguments, cached: true)
            guard let record = try KnownStickerPackRecord.fetchOne(transaction.database, sqlRequest) else {
                return nil
            }

            return try KnownStickerPack.fromRecord(record)
        } catch {
            owsFailDebug("error: \(error)")
            return nil
        }
    }
}

// MARK: - SDSSerializer

// The SDSSerializer protocol specifies how to insert and update the
// row that corresponds to this model.
class KnownStickerPackSerializer: SDSSerializer {

    private let model: KnownStickerPack
    public init(model: KnownStickerPack) {
        self.model = model
    }

    // MARK: - Record

    func asRecord() throws -> SDSRecord {
        let id: Int64? = model.grdbId?.int64Value

        let recordType: SDSRecordType = .knownStickerPack
        let uniqueId: String = model.uniqueId

        // Properties
        let dateCreated: Double = archiveDate(model.dateCreated)
        let info: Data = requiredArchive(model.info)
        let referenceCount: Int = model.referenceCount

        return KnownStickerPackRecord(delegate: model, id: id, recordType: recordType, uniqueId: uniqueId, dateCreated: dateCreated, info: info, referenceCount: referenceCount)
    }
}

// MARK: - Deep Copy

#if TESTABLE_BUILD
@objc
public extension KnownStickerPack {
    // We're not using this method at the moment,
    // but we might use it for validation of
    // other deep copy methods.
    func deepCopyUsingRecord() throws -> KnownStickerPack {
        guard let record = try asRecord() as? KnownStickerPackRecord else {
            throw OWSAssertionError("Could not convert to record.")
        }
        return try KnownStickerPack.fromRecord(record)
    }
}
#endif
