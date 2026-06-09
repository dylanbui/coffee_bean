// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_point.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTblStorePointCollection on Isar {
  IsarCollection<TblStorePoint> get tblStorePoints => this.collection();
}

const TblStorePointSchema = CollectionSchema(
  name: r'TblStorePoint',
  id: -2628566148609846578,
  properties: {
    r'catIds': PropertySchema(id: 0, name: r'catIds', type: IsarType.longList),
    r'description': PropertySchema(
      id: 1,
      name: r'description',
      type: IsarType.string,
    ),
    r'images': PropertySchema(
      id: 2,
      name: r'images',
      type: IsarType.objectList,

      target: r'TblImage',
    ),
    r'isActive': PropertySchema(id: 3, name: r'isActive', type: IsarType.bool),
    r'name': PropertySchema(id: 4, name: r'name', type: IsarType.string),
    r'points': PropertySchema(id: 5, name: r'points', type: IsarType.double),
    r'searchName': PropertySchema(
      id: 6,
      name: r'searchName',
      type: IsarType.string,
    ),
    r'serverId': PropertySchema(id: 7, name: r'serverId', type: IsarType.long),
  },

  estimateSize: _tblStorePointEstimateSize,
  serialize: _tblStorePointSerialize,
  deserialize: _tblStorePointDeserialize,
  deserializeProp: _tblStorePointDeserializeProp,
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

  getId: _tblStorePointGetId,
  getLinks: _tblStorePointGetLinks,
  attach: _tblStorePointAttach,
  version: '3.3.2',
);

int _tblStorePointEstimateSize(
  TblStorePoint object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.catIds;
    if (value != null) {
      bytesCount += 3 + value.length * 8;
    }
  }
  {
    final value = object.description;
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
  bytesCount += 3 + object.searchName.length * 3;
  return bytesCount;
}

void _tblStorePointSerialize(
  TblStorePoint object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLongList(offsets[0], object.catIds);
  writer.writeString(offsets[1], object.description);
  writer.writeObjectList<TblImage>(
    offsets[2],
    allOffsets,
    TblImageSchema.serialize,
    object.images,
  );
  writer.writeBool(offsets[3], object.isActive);
  writer.writeString(offsets[4], object.name);
  writer.writeDouble(offsets[5], object.points);
  writer.writeString(offsets[6], object.searchName);
  writer.writeLong(offsets[7], object.serverId);
}

TblStorePoint _tblStorePointDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TblStorePoint();
  object.catIds = reader.readLongList(offsets[0]);
  object.description = reader.readStringOrNull(offsets[1]);
  object.id = id;
  object.images = reader.readObjectList<TblImage>(
    offsets[2],
    TblImageSchema.deserialize,
    allOffsets,
    TblImage(),
  );
  object.isActive = reader.readBool(offsets[3]);
  object.name = reader.readString(offsets[4]);
  object.points = reader.readDouble(offsets[5]);
  object.searchName = reader.readString(offsets[6]);
  object.serverId = reader.readLong(offsets[7]);
  return object;
}

P _tblStorePointDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongList(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readObjectList<TblImage>(
            offset,
            TblImageSchema.deserialize,
            allOffsets,
            TblImage(),
          ))
          as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readDouble(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _tblStorePointGetId(TblStorePoint object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _tblStorePointGetLinks(TblStorePoint object) {
  return [];
}

void _tblStorePointAttach(
  IsarCollection<dynamic> col,
  Id id,
  TblStorePoint object,
) {
  object.id = id;
}

extension TblStorePointByIndex on IsarCollection<TblStorePoint> {
  Future<TblStorePoint?> getByServerId(int serverId) {
    return getByIndex(r'serverId', [serverId]);
  }

  TblStorePoint? getByServerIdSync(int serverId) {
    return getByIndexSync(r'serverId', [serverId]);
  }

  Future<bool> deleteByServerId(int serverId) {
    return deleteByIndex(r'serverId', [serverId]);
  }

  bool deleteByServerIdSync(int serverId) {
    return deleteByIndexSync(r'serverId', [serverId]);
  }

  Future<List<TblStorePoint?>> getAllByServerId(List<int> serverIdValues) {
    final values = serverIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'serverId', values);
  }

  List<TblStorePoint?> getAllByServerIdSync(List<int> serverIdValues) {
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

  Future<Id> putByServerId(TblStorePoint object) {
    return putByIndex(r'serverId', object);
  }

  Id putByServerIdSync(TblStorePoint object, {bool saveLinks = true}) {
    return putByIndexSync(r'serverId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByServerId(List<TblStorePoint> objects) {
    return putAllByIndex(r'serverId', objects);
  }

  List<Id> putAllByServerIdSync(
    List<TblStorePoint> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'serverId', objects, saveLinks: saveLinks);
  }
}

extension TblStorePointQueryWhereSort
    on QueryBuilder<TblStorePoint, TblStorePoint, QWhere> {
  QueryBuilder<TblStorePoint, TblStorePoint, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterWhere> anyServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'serverId'),
      );
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterWhere> anyName() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'name'),
      );
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterWhere> anySearchName() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'searchName'),
      );
    });
  }
}

extension TblStorePointQueryWhere
    on QueryBuilder<TblStorePoint, TblStorePoint, QWhereClause> {
  QueryBuilder<TblStorePoint, TblStorePoint, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterWhereClause> idBetween(
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

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterWhereClause> serverIdEqualTo(
    int serverId,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'serverId', value: [serverId]),
      );
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterWhereClause>
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

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterWhereClause>
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

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterWhereClause>
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

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterWhereClause> serverIdBetween(
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

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterWhereClause> nameEqualTo(
    String name,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'name', value: [name]),
      );
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterWhereClause> nameNotEqualTo(
    String name,
  ) {
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

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterWhereClause> nameGreaterThan(
    String name, {
    bool include = false,
  }) {
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

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterWhereClause> nameLessThan(
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

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterWhereClause> nameBetween(
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

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterWhereClause> nameStartsWith(
    String NamePrefix,
  ) {
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

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterWhereClause> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'name', value: ['']),
      );
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterWhereClause>
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

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterWhereClause>
  searchNameEqualTo(String searchName) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'searchName', value: [searchName]),
      );
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterWhereClause>
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

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterWhereClause>
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

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterWhereClause>
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

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterWhereClause>
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

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterWhereClause>
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

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterWhereClause>
  searchNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'searchName', value: ['']),
      );
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterWhereClause>
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

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterWhereClause> catIdsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'catIds', value: [null]),
      );
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterWhereClause>
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

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterWhereClause> catIdsEqualTo(
    List<int>? catIds,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'catIds', value: [catIds]),
      );
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterWhereClause>
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

extension TblStorePointQueryFilter
    on QueryBuilder<TblStorePoint, TblStorePoint, QFilterCondition> {
  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition>
  catIdsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'catIds'),
      );
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition>
  catIdsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'catIds'),
      );
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition>
  catIdsElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'catIds', value: value),
      );
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition>
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

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition>
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

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition>
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

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition>
  catIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'catIds', length, true, length, true);
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition>
  catIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'catIds', 0, true, 0, true);
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition>
  catIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'catIds', 0, false, 999999, true);
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition>
  catIdsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'catIds', 0, true, length, include);
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition>
  catIdsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'catIds', length, include, 999999, true);
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition>
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

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition>
  descriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'description'),
      );
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition>
  descriptionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'description'),
      );
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition>
  descriptionEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition>
  descriptionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition>
  descriptionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition>
  descriptionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'description',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition>
  descriptionStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition>
  descriptionEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition>
  descriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition>
  descriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'description',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition>
  descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'description', value: ''),
      );
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition>
  descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'description', value: ''),
      );
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition>
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

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
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

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition> idBetween(
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

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition>
  imagesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'images'),
      );
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition>
  imagesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'images'),
      );
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition>
  imagesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'images', length, true, length, true);
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition>
  imagesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'images', 0, true, 0, true);
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition>
  imagesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'images', 0, false, 999999, true);
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition>
  imagesLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'images', 0, true, length, include);
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition>
  imagesLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'images', length, include, 999999, true);
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition>
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

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition>
  isActiveEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isActive', value: value),
      );
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition>
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

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition>
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

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition>
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

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition>
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

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition>
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

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition> nameMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition>
  nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition>
  nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition>
  pointsEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'points',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition>
  pointsGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'points',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition>
  pointsLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'points',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition>
  pointsBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'points',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition>
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

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition>
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

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition>
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

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition>
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

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition>
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

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition>
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

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition>
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

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition>
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

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition>
  searchNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'searchName', value: ''),
      );
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition>
  searchNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'searchName', value: ''),
      );
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition>
  serverIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'serverId', value: value),
      );
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition>
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

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition>
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

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition>
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

extension TblStorePointQueryObject
    on QueryBuilder<TblStorePoint, TblStorePoint, QFilterCondition> {
  QueryBuilder<TblStorePoint, TblStorePoint, QAfterFilterCondition>
  imagesElement(FilterQuery<TblImage> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'images');
    });
  }
}

extension TblStorePointQueryLinks
    on QueryBuilder<TblStorePoint, TblStorePoint, QFilterCondition> {}

extension TblStorePointQuerySortBy
    on QueryBuilder<TblStorePoint, TblStorePoint, QSortBy> {
  QueryBuilder<TblStorePoint, TblStorePoint, QAfterSortBy> sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterSortBy>
  sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterSortBy> sortByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterSortBy>
  sortByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterSortBy> sortByPoints() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'points', Sort.asc);
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterSortBy> sortByPointsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'points', Sort.desc);
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterSortBy> sortBySearchName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'searchName', Sort.asc);
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterSortBy>
  sortBySearchNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'searchName', Sort.desc);
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterSortBy> sortByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.asc);
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterSortBy>
  sortByServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.desc);
    });
  }
}

extension TblStorePointQuerySortThenBy
    on QueryBuilder<TblStorePoint, TblStorePoint, QSortThenBy> {
  QueryBuilder<TblStorePoint, TblStorePoint, QAfterSortBy> thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterSortBy>
  thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterSortBy> thenByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterSortBy>
  thenByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterSortBy> thenByPoints() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'points', Sort.asc);
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterSortBy> thenByPointsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'points', Sort.desc);
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterSortBy> thenBySearchName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'searchName', Sort.asc);
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterSortBy>
  thenBySearchNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'searchName', Sort.desc);
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterSortBy> thenByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.asc);
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QAfterSortBy>
  thenByServerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverId', Sort.desc);
    });
  }
}

extension TblStorePointQueryWhereDistinct
    on QueryBuilder<TblStorePoint, TblStorePoint, QDistinct> {
  QueryBuilder<TblStorePoint, TblStorePoint, QDistinct> distinctByCatIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'catIds');
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QDistinct> distinctByDescription({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QDistinct> distinctByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isActive');
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QDistinct> distinctByName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QDistinct> distinctByPoints() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'points');
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QDistinct> distinctBySearchName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'searchName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TblStorePoint, TblStorePoint, QDistinct> distinctByServerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'serverId');
    });
  }
}

extension TblStorePointQueryProperty
    on QueryBuilder<TblStorePoint, TblStorePoint, QQueryProperty> {
  QueryBuilder<TblStorePoint, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TblStorePoint, List<int>?, QQueryOperations> catIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'catIds');
    });
  }

  QueryBuilder<TblStorePoint, String?, QQueryOperations> descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<TblStorePoint, List<TblImage>?, QQueryOperations>
  imagesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'images');
    });
  }

  QueryBuilder<TblStorePoint, bool, QQueryOperations> isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isActive');
    });
  }

  QueryBuilder<TblStorePoint, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<TblStorePoint, double, QQueryOperations> pointsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'points');
    });
  }

  QueryBuilder<TblStorePoint, String, QQueryOperations> searchNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'searchName');
    });
  }

  QueryBuilder<TblStorePoint, int, QQueryOperations> serverIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'serverId');
    });
  }
}
