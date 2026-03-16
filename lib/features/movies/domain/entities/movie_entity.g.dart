
part of 'movie_entity.dart';

class CastEntityAdapter extends TypeAdapter<CastEntity> {
  @override
  final int typeId = 1;

  @override
  CastEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CastEntity(
      name: fields[0] as String,
      characterName: fields[1] as String,
      urlSmallImage: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CastEntity obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.characterName)
      ..writeByte(2)
      ..write(obj.urlSmallImage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CastEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MovieEntityAdapter extends TypeAdapter<MovieEntity> {
  @override
  final int typeId = 0;

  @override
  MovieEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MovieEntity(
      id: fields[0] as int,
      title: fields[1] as String,
      summary: fields[2] as String,
      mediumCoverImage: fields[3] as String,
      rating: fields[4] as double,
      year: fields[5] as int,
      genres: (fields[6] as List).cast<String>(),
      runtime: fields[7] as int?,
      backgroundImage: fields[8] as String?,
      likeCount: fields[9] as int?,
      screenshots: (fields[10] as List).cast<String>(),
      cast: (fields[11] as List).cast<CastEntity>(),
    );
  }

  @override
  void write(BinaryWriter writer, MovieEntity obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.summary)
      ..writeByte(3)
      ..write(obj.mediumCoverImage)
      ..writeByte(4)
      ..write(obj.rating)
      ..writeByte(5)
      ..write(obj.year)
      ..writeByte(6)
      ..write(obj.genres)
      ..writeByte(7)
      ..write(obj.runtime)
      ..writeByte(8)
      ..write(obj.backgroundImage)
      ..writeByte(9)
      ..write(obj.likeCount)
      ..writeByte(10)
      ..write(obj.screenshots)
      ..writeByte(11)
      ..write(obj.cast);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
