import 'package:test/test.dart';
import 'package:tmx/tmx.dart' as tmx;

main() {
  // GID is 1-based
  group('Map.getTileByGID', () {
    tmx.Tile tile;
    tmx.TileMap map;
    setUp(() {
      map = new tmx.TileMap();
      // 2 tilesets:
      // 1 tileset with 1 tile
      // 1 tileset with 3 tiles
      // 1 tileset with 1 tile
      map.tilesets.add(new tmx.Tileset(1));
      map.tilesets.add(new tmx.Tileset(2)..height = 64..width = 32);
      map.tilesets.add(new tmx.Tileset(5));
      // The last tile of the second tileset has a gid = 4
      tile =  map.getTileByGID(4);
    });

    test('returns an empty Tile if GID is 0', () {
      tile = map.getTileByGID(0);
      expect(tile.isEmpty, isTrue);
    });

    group('returns a valid Tile for GID 4', () {
      test('with tileId = 2', () {
        expect(tile.tileId, equals(2));
      });

      test('with width = 32', () {
        expect(tile.width, equals(32));
      });

      test('with height = 64', () {
        expect(tile.height, equals(64));
      });

      test('with globalId = 4', () {
        expect(tile.gid, equals(4));
      });

      test('with x = null', ()=> expect(tile.x, isNull));
      test('with y = null', ()=> expect(tile.y, isNull));
    });
  });

  group('Map.getTileByLocalID', () {
    tmx.TileMap map;
    tmx.Tileset tileset = new tmx.Tileset(1)
      ..name = 'Humans'
      ..height = 64
      ..width = 32;
    setUp(() {
      map = new tmx.TileMap();
      map.tilesets.add(tileset);
    });

    test('raises an ArgumentError if tileset is not present', () {
      expect( () => map.getTileByLocalID('Nonexistant Tile', 0),
        throwsA(new isInstanceOf<ArgumentError>())
      );
    });

    group('returns a tile', () {
      var tile;
      setUp(() => tile = map.getTileByLocalID('Humans', 0));

      test('with the expected Tileset', () => expect(tile.tileset, equals(tileset)));
      test('with the expected local tile ID', () => expect(tile.tileId, equals(0)));
    });

  });

  group('Map.getTileByPhrase', () {
    tmx.TileMap map;
    tmx.Tileset tileset = new tmx.Tileset(1)
      ..name = 'Humans'
      ..height = 64
      ..width = 32;
    setUp(() {
      map = new tmx.TileMap();
      map.tilesets.add(tileset);
    });

    test('raises an ArgumentError if tile phrase is not in the correct format', () {
      expect( () => map.getTileByPhrase('Nonexistant Tile'),
        throwsArgumentError
      );
    });

    test('raises an ArgumentError if tileset is not present', () {
      expect( () => map.getTileByPhrase('Nonexistant Tile|0'),
        throwsArgumentError);
    });

    test('raises an ArgumentError if tile id is not a parsable integer', () {
      expect( () => map.getTileByPhrase('Humans|cupcake'),
        throwsArgumentError);
    });

    group('returns a tile', () {
      var tile;
      setUp(() => tile = map.getTileByPhrase('Humans|0'));

      test('with the expected Tileset', () => expect(tile.tileset, equals(tileset)));
      test('with the expected local tile ID', () => expect(tile.tileId, equals(0)));
    });
  });

  group('Map.getTileset', () {
    tmx.TileMap map;
    tmx.Tileset tileset = new tmx.Tileset(1)..name = 'Humans';
    setUp(() {
      map = new tmx.TileMap();
      map.tilesets.add(tileset);
    });

    test('raises an ArgumentError if tileset is not present', () {
      expect( () => map.getTileset('Quackers'),
          throwsA(new isInstanceOf<ArgumentError>()));
    });

    test('returns the expected tileset', () {
      expect(map.getTileset('Humans'), equals(tileset));
    });
  });
}
