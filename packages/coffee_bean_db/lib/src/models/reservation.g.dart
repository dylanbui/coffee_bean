// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTblReservationCollection on Isar {
  IsarCollection<TblReservation> get tblReservations => this.collection();
}

const TblReservationSchema = CollectionSchema(
  name: r'TblReservation',
  id: 6978522229281745801,
  properties: {
    r'address': PropertySchema(id: 0, name: r'address', type: IsarType.string),
    r'catIds': PropertySchema(id: 1, name: r'catIds', type: IsarType.longList),
    r'closingTime': PropertySchema(
      id: 2,
      name: r'closingTime',
      type: IsarType.string,
    ),
    r'images': PropertySchema(
      id: 3,
      name: r'images',
      type: IsarType.objectList,

      target: r'TblImage',
    ),
    r'isActive': PropertySchema(id: 4, name: r'isActive', type: IsarType.bool),
    r'latitude': PropertySchema(
      id: 5,
      name: r'latitude',
      type: IsarType.double,
    ),
    r'longitude': PropertySchema(
      id: 6,
      name: r'longitude',
      type: IsarType.double,
    ),
    r'name': PropertySchema(id: 7, name: r'name', type: IsarType.string),
    r'openingTime': PropertySchema(
      id: 8,
      name: r'openingTime',
      type: IsarType.string,
    ),
    r'phone': PropertySchema(id: 9, name: r'phone', type: IsarType.string),
    r'searchName': PropertySchema(
      id: 10,
      name: r'searchName',
      type: IsarType.string,
    ),
    r'serverId': PropertySchema(id: 11, name: r'serverId', type: IsarType.long),
  },

  estimateSize: _tblReservationEstimateSize,
  serialize: _tblReservationSerialize,
  deserialize: _tblReservationDeserialize,
  deserializeProp: _tblReservationDeserializeProp,
  idName: r'id',
  indexes: {
    r'serverId': IndexSchema(
      id: -7950187970872907662,
      name: r'serverId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'serverId',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'name': IndexSchema(
      id: 879695947855722453,
      name: r'name',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'name',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'address': IndexSchema(
      id: -259407546592846288,
      name: r'address',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'address',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'searchName': IndexSchema(
      id: 3842613567125804748,
      name: r'searchName',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'searchName',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'catIds': IndexSchema(
      id: 2864043476753028885,
      name: r'catIds',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'catIds',
          type: IndexType.hash,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {r'TblImage': TblImageSchema},

  getId: _tblReservationGetId,
  getLinks: _tblReservationGetLinks,
  attach: _tblReservationAttach,
  version: '3.3.2',
);

int _tblReservationEstimateSize(
  TblReservation object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.address.length * 3;
  {
    final value = object.catIds;
    if (value != null) {
      bytesCount += 3 + value.length * 8;
    }
  }
  {
    final value = object.closingTime;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.images;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[TblImage]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += TblImageSchema.estimateSize(value, offsets, allOffsets);
        }
      }
    }
  }
  bytesCount += 3 + object.name.length * 3;
  {
    final value = object.openingTime;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.phone;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.searchName.length * 3;
  return bytesCount;
}

void _tblReservationSerialize(
  TblReservation object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.address);
  writer.writeLongList(offsets[1], object.catIds);
  writer.writeString(offsets[2], object.closingTime);
  writer.writeObjectList<TblImage>(
    offsets[3],
    allOffsets,
    TblImageSchema.serialize,
    object.images,
  );
  writer.writeBool(offsets[4], object.isActive);
  writer.writeDouble(offsets[5], object.latitude);
  writer.writeDouble(offsets[6], object.longitude);
  writer.writeString(offsets[7], object.name);
  writer.writeString(offsets[8], object.openingTime);
  writer.writeString(offsets[9], object.phone);
  writer.writeString(offsets[10], object.searchName);
  writer.writeLong(offsets[11], object.serverId);
}

TblReservation _tblReservationDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TblReservation();
  object.address = reader.readString(offsets[0]);
  object.catIds = reader.readLongList(offsets[1]);
  object.closingTime = reader.readStringOrNull(offsets[2]);
  object.id = id;
  object.images = reader.readObjectList<TblImage>(
    offsets[3],
    TblImageSchema.deserialize,
    allOffsets,
    TblImage(),
  );
  object.isActive = reader.readBool(offsets[4]);
  object.latitude = reader.readDouble(offsets[5]);
  object.longitude = reader.readDouble(offsets[6]);
  object.name = reader.readString(offsets[7]);
  object.openingTime = reader.readStringOrNull(offsets[8]);
  object.phone = reader.readStringOrNull(offsets[9]);
  object.searchName = reader.readString(offsets[10]);
  object.serverId = reader.readLong(offsets[11]);
  return object;
}

P _tblReservationDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLongList(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readObjectList<TblImage>(
            offset,
            TblImageSchema.deserialize,
            allOffsets,
            TblImage(),
          ))
          as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readDouble(offset)) as P;
    case 6:
      return (reader.readDouble(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _tblReservationGetId(TblReservation object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _tblReservationGetLinks(TblReservation object) {
  return [];
}

void _tblReservationAttach(
  IsarCollection<dynamic> col,
  Id id,
  TblReservation object,
) {
  object.id = id;
}

extension TblReservationByIndex on IsarCollection<TblReservation> {
  Future<TblReservation?> getByServerId(int serverId) {
    return getByIndex(r'serverId', [serverId]);
  }

  TblReservation? getByServerIdSync(int serverId) {
    return getByIndexSync(r'serverId', [serverId]);
  }

  Future<bool> deleteByServerId(int serverId) {
    return deleteByIndex(r'serverId', [serverId]);
  }

  bool deleteByServerIdSync(int serverId) {
    return deleteByIndexSync(r'serverId', [serverId]);
  }

  Future<List<TblReservation?>> getAllByServerId(List<int> serverIdValues) {
    final values = serverIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'serverId', values);
  }

  List<TblReservation?> getAllByServerIdSync(List<int> serverIdValues) {
    final values = serverIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'serverId', values);
  }

  Future<int> deleteAllByServerId(List<int> serverIdValues) {
    final values = serverIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'serverId', values);
  }

  int deleteAllByServerIdSync(List<int> serverIdValues) {
    final values = serverIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'serverId', values);
  }

  Future<Id> putByServerId(TblReservation object) {
    return putByIndex(r'serverId', object);
  }

  Id putByServerIdSync(TblReservation object, {bool saveLinks = true}) {
    return putByIndexSync(r'serverId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByServerId(List<TblReservation> objects) {
    return putAllByIndex(r'serverId', objects);
  }

  List<Id> putAllByServerIdSync(
    List<TblReservation> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'serverId', objects, saveLinks: saveLinks);
  }
}

extension TblReservationQueryWhereSort
    on QueryBuilder<TblReservation, TblReservation, QWhere> {
  QueryBuilder<TblReservation, TblReservation, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterWhere> anyServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'serverId'),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterWhere> anyName() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'name'),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterWhere> anyAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'address'),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterWhere> anySearchName() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'searchName'),
      );
    });
  }
}

extension TblReservationQueryWhere
    on QueryBuilder<TblReservation, TblReservation, QWhereClause> {
  QueryBuilder<TblReservation, TblReservation, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterWhereClause> idNotEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterWhereClause>
  serverIdEqualTo(int serverId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'serverId', value: [serverId]),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterWhereClause>
  serverIdNotEqualTo(int serverId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'serverId',
                lower: [],
                upper: [serverId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'serverId',
                lower: [serverId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'serverId',
                lower: [serverId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'serverId',
                lower: [],
                upper: [serverId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterWhereClause>
  serverIdGreaterThan(int serverId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'serverId',
          lower: [serverId],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterWhereClause>
  serverIdLessThan(int serverId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'serverId',
          lower: [],
          upper: [serverId],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterWhereClause>
  serverIdBetween(
    int lowerServerId,
    int upperServerId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'serverId',
          lower: [lowerServerId],
          includeLower: includeLower,
          upper: [upperServerId],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterWhereClause> nameEqualTo(
    String name,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'name', value: [name]),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterWhereClause>
  nameNotEqualTo(String name) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'name',
                lower: [],
                upper: [name],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'name',
                lower: [name],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'name',
                lower: [name],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'name',
                lower: [],
                upper: [name],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterWhereClause>
  nameGreaterThan(String name, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'name',
          lower: [name],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterWhereClause> nameLessThan(
    String name, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'name',
          lower: [],
          upper: [name],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterWhereClause> nameBetween(
    String lowerName,
    String upperName, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'name',
          lower: [lowerName],
          includeLower: includeLower,
          upper: [upperName],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterWhereClause>
  nameStartsWith(String NamePrefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'name',
          lower: [NamePrefix],
          upper: ['$NamePrefix\u{FFFFF}'],
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterWhereClause>
  nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'name', value: ['']),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterWhereClause>
  nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.lessThan(indexName: r'name', upper: ['']),
            )
            .addWhereClause(
              IndexWhereClause.greaterThan(indexName: r'name', lower: ['']),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.greaterThan(indexName: r'name', lower: ['']),
            )
            .addWhereClause(
              IndexWhereClause.lessThan(indexName: r'name', upper: ['']),
            );
      }
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterWhereClause>
  addressEqualTo(String address) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'address', value: [address]),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterWhereClause>
  addressNotEqualTo(String address) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'address',
                lower: [],
                upper: [address],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'address',
                lower: [address],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'address',
                lower: [address],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'address',
                lower: [],
                upper: [address],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterWhereClause>
  addressGreaterThan(String address, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'address',
          lower: [address],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterWhereClause>
  addressLessThan(String address, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'address',
          lower: [],
          upper: [address],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterWhereClause>
  addressBetween(
    String lowerAddress,
    String upperAddress, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'address',
          lower: [lowerAddress],
          includeLower: includeLower,
          upper: [upperAddress],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterWhereClause>
  addressStartsWith(String AddressPrefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'address',
          lower: [AddressPrefix],
          upper: ['$AddressPrefix\u{FFFFF}'],
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterWhereClause>
  addressIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'address', value: ['']),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterWhereClause>
  addressIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.lessThan(indexName: r'address', upper: ['']),
            )
            .addWhereClause(
              IndexWhereClause.greaterThan(indexName: r'address', lower: ['']),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.greaterThan(indexName: r'address', lower: ['']),
            )
            .addWhereClause(
              IndexWhereClause.lessThan(indexName: r'address', upper: ['']),
            );
      }
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterWhereClause>
  searchNameEqualTo(String searchName) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'searchName', value: [searchName]),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterWhereClause>
  searchNameNotEqualTo(String searchName) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'searchName',
                lower: [],
                upper: [searchName],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'searchName',
                lower: [searchName],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'searchName',
                lower: [searchName],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'searchName',
                lower: [],
                upper: [searchName],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterWhereClause>
  searchNameGreaterThan(String searchName, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'searchName',
          lower: [searchName],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterWhereClause>
  searchNameLessThan(String searchName, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'searchName',
          lower: [],
          upper: [searchName],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterWhereClause>
  searchNameBetween(
    String lowerSearchName,
    String upperSearchName, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'searchName',
          lower: [lowerSearchName],
          includeLower: includeLower,
          upper: [upperSearchName],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterWhereClause>
  searchNameStartsWith(String SearchNamePrefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'searchName',
          lower: [SearchNamePrefix],
          upper: ['$SearchNamePrefix\u{FFFFF}'],
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterWhereClause>
  searchNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'searchName', value: ['']),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterWhereClause>
  searchNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.lessThan(indexName: r'searchName', upper: ['']),
            )
            .addWhereClause(
              IndexWhereClause.greaterThan(
                indexName: r'searchName',
                lower: [''],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.greaterThan(
                indexName: r'searchName',
                lower: [''],
              ),
            )
            .addWhereClause(
              IndexWhereClause.lessThan(indexName: r'searchName', upper: ['']),
            );
      }
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterWhereClause>
  catIdsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'catIds', value: [null]),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterWhereClause>
  catIdsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'catIds',
          lower: [null],
          includeLower: false,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterWhereClause> catIdsEqualTo(
    List<int>? catIds,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'catIds', value: [catIds]),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterWhereClause>
  catIdsNotEqualTo(List<int>? catIds) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'catIds',
                lower: [],
                upper: [catIds],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'catIds',
                lower: [catIds],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'catIds',
                lower: [catIds],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'catIds',
                lower: [],
                upper: [catIds],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension TblReservationQueryFilter
    on QueryBuilder<TblReservation, TblReservation, QFilterCondition> {
  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  addressEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'address',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  addressGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'address',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  addressLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'address',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  addressBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'address',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  addressStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'address',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  addressEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'address',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  addressContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'address',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  addressMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'address',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  addressIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'address', value: ''),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  addressIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'address', value: ''),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  catIdsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'catIds'),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  catIdsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'catIds'),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  catIdsElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'catIds', value: value),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  catIdsElementGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'catIds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  catIdsElementLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'catIds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  catIdsElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'catIds',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  catIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'catIds', length, true, length, true);
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  catIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'catIds', 0, true, 0, true);
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  catIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'catIds', 0, false, 999999, true);
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  catIdsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'catIds', 0, true, length, include);
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  catIdsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'catIds', length, include, 999999, true);
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  catIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'catIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  closingTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'closingTime'),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  closingTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'closingTime'),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  closingTimeEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'closingTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  closingTimeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'closingTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  closingTimeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'closingTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  closingTimeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'closingTime',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  closingTimeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'closingTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  closingTimeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'closingTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  closingTimeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'closingTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  closingTimeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'closingTime',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  closingTimeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'closingTime', value: ''),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  closingTimeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'closingTime', value: ''),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  idLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  imagesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'images'),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  imagesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'images'),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  imagesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'images', length, true, length, true);
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  imagesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'images', 0, true, 0, true);
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  imagesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'images', 0, false, 999999, true);
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  imagesLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'images', 0, true, length, include);
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  imagesLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'images', length, include, 999999, true);
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  imagesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'images',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  isActiveEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isActive', value: value),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  latitudeEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'latitude',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  latitudeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'latitude',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  latitudeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'latitude',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  latitudeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'latitude',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  longitudeEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'longitude',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  longitudeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'longitude',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  longitudeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'longitude',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  longitudeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'longitude',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  nameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'name',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  nameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  nameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'name',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  openingTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'openingTime'),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  openingTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'openingTime'),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  openingTimeEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'openingTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  openingTimeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'openingTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  openingTimeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'openingTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  openingTimeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'openingTime',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  openingTimeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'openingTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  openingTimeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'openingTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  openingTimeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'openingTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  openingTimeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'openingTime',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  openingTimeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'openingTime', value: ''),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  openingTimeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'openingTime', value: ''),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  phoneIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'phone'),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  phoneIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'phone'),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  phoneEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'phone',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  phoneGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'phone',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  phoneLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'phone',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  phoneBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'phone',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  phoneStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'phone',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  phoneEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'phone',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  phoneContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'phone',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  phoneMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'phone',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  phoneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'phone', value: ''),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  phoneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'phone', value: ''),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  searchNameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'searchName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  searchNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'searchName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  searchNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'searchName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  searchNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'searchName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  searchNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'searchName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  searchNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'searchName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  searchNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'searchName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  searchNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'searchName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  searchNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'searchName', value: ''),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  searchNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'searchName', value: ''),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  serverIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'serverId', value: value),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  serverIdGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'serverId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  serverIdLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'serverId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  serverIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'serverId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension TblReservationQueryObject
    on QueryBuilder<TblReservation, TblReservation, QFilterCondition> {
  QueryBuilder<TblReservation, TblReservation, QAfterFilterCondition>
  imagesElement(FilterQuery<TblImage> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'images');
    });
  }
}

extension TblReservationQueryLinks
    on QueryBuilder<TblReservation, TblReservation, QFilterCondition> {}

extension TblReservationQuerySortBy
    on QueryBuilder<TblReservation, TblReservation, QSortBy> {
  QueryBuilder<TblReservation, TblReservation, QAfterSortBy> sortByAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.asc);
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterSortBy>
  sortByAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.desc);
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterSortBy>
  sortByClosingTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'closingTime', Sort.asc);
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterSortBy>
  sortByClosingTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'closingTime', Sort.desc);
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterSortBy> sortByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterSortBy>
  sortByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterSortBy> sortByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.asc);
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterSortBy>
  sortByLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.desc);
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterSortBy> sortByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.asc);
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterSortBy>
  sortByLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.desc);
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterSortBy>
  sortByOpeningTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openingTime', Sort.asc);
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterSortBy>
  sortByOpeningTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openingTime', Sort.desc);
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterSortBy> sortByPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.asc);
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterSortBy> sortByPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.desc);
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterSortBy>
  sortBySearchName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'searchName', Sort.asc);
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterSortBy>
  sortBySearchNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'searchName', Sort.desc);
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterSortBy> sortByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.asc);
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterSortBy>
  sortByServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.desc);
    });
  }
}

extension TblReservationQuerySortThenBy
    on QueryBuilder<TblReservation, TblReservation, QSortThenBy> {
  QueryBuilder<TblReservation, TblReservation, QAfterSortBy> thenByAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.asc);
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterSortBy>
  thenByAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.desc);
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterSortBy>
  thenByClosingTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'closingTime', Sort.asc);
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterSortBy>
  thenByClosingTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'closingTime', Sort.desc);
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterSortBy> thenByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterSortBy>
  thenByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterSortBy> thenByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.asc);
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterSortBy>
  thenByLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.desc);
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterSortBy> thenByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.asc);
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterSortBy>
  thenByLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.desc);
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterSortBy>
  thenByOpeningTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openingTime', Sort.asc);
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterSortBy>
  thenByOpeningTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openingTime', Sort.desc);
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterSortBy> thenByPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.asc);
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterSortBy> thenByPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.desc);
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterSortBy>
  thenBySearchName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'searchName', Sort.asc);
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterSortBy>
  thenBySearchNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'searchName', Sort.desc);
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterSortBy> thenByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.asc);
    });
  }

  QueryBuilder<TblReservation, TblReservation, QAfterSortBy>
  thenByServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.desc);
    });
  }
}

extension TblReservationQueryWhereDistinct
    on QueryBuilder<TblReservation, TblReservation, QDistinct> {
  QueryBuilder<TblReservation, TblReservation, QDistinct> distinctByAddress({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'address', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TblReservation, TblReservation, QDistinct> distinctByCatIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'catIds');
    });
  }

  QueryBuilder<TblReservation, TblReservation, QDistinct>
  distinctByClosingTime({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'closingTime', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TblReservation, TblReservation, QDistinct> distinctByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isActive');
    });
  }

  QueryBuilder<TblReservation, TblReservation, QDistinct> distinctByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'latitude');
    });
  }

  QueryBuilder<TblReservation, TblReservation, QDistinct>
  distinctByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'longitude');
    });
  }

  QueryBuilder<TblReservation, TblReservation, QDistinct> distinctByName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TblReservation, TblReservation, QDistinct>
  distinctByOpeningTime({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'openingTime', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TblReservation, TblReservation, QDistinct> distinctByPhone({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'phone', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TblReservation, TblReservation, QDistinct> distinctBySearchName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'searchName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TblReservation, TblReservation, QDistinct> distinctByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'serverId');
    });
  }
}

extension TblReservationQueryProperty
    on QueryBuilder<TblReservation, TblReservation, QQueryProperty> {
  QueryBuilder<TblReservation, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TblReservation, String, QQueryOperations> addressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'address');
    });
  }

  QueryBuilder<TblReservation, List<int>?, QQueryOperations> catIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'catIds');
    });
  }

  QueryBuilder<TblReservation, String?, QQueryOperations>
  closingTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'closingTime');
    });
  }

  QueryBuilder<TblReservation, List<TblImage>?, QQueryOperations>
  imagesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'images');
    });
  }

  QueryBuilder<TblReservation, bool, QQueryOperations> isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isActive');
    });
  }

  QueryBuilder<TblReservation, double, QQueryOperations> latitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'latitude');
    });
  }

  QueryBuilder<TblReservation, double, QQueryOperations> longitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'longitude');
    });
  }

  QueryBuilder<TblReservation, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<TblReservation, String?, QQueryOperations>
  openingTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'openingTime');
    });
  }

  QueryBuilder<TblReservation, String?, QQueryOperations> phoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'phone');
    });
  }

  QueryBuilder<TblReservation, String, QQueryOperations> searchNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'searchName');
    });
  }

  QueryBuilder<TblReservation, int, QQueryOperations> serverIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'serverId');
    });
  }
}
