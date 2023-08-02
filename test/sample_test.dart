import 'package:calisma/homePage.dart';
import 'package:calisma/linkitem.dart';
import 'package:calisma/linkstorage.dart';
import 'package:flutter_pagination/flutter_pagination.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  group('LinkItem tests', () {

    test('Test LinkItem incrementUpVotes', () {
      final linkItem = LinkItem(name: 'Test', urlLink: 'https://example.com');
      expect(linkItem.upVotes, 0);

      linkItem.incrementUpVotes();
      expect(linkItem.upVotes, 1);

      linkItem.incrementUpVotes();
      expect(linkItem.upVotes, 2);
    });

    test('Test LinkItem decrementUpVotes', () {
      final linkItem = LinkItem(name: 'Test', urlLink: 'https://example.com');
      linkItem.upVotes = 3;
      expect(linkItem.upVotes, 3);

      linkItem.decrementUpVotes();
      expect(linkItem.upVotes, 2);
    });

    test('Test LinkItem totalVotes', () {
      final linkItem = LinkItem(name: 'Test', urlLink: 'https://example.com');
      linkItem.upVotes = 5;
      linkItem.downVotes = 3;
      expect(linkItem.totalVotes, 2);

      linkItem.incrementUpVotes();
      expect(linkItem.totalVotes, 3);

      linkItem.incrementDownVotes();
      expect(linkItem.totalVotes, 2);
    });

    test('Test LinkItem toJSONEncodable', () {
      final linkItem = LinkItem(name: 'Test', urlLink: 'https://example.com');
      linkItem.upVotes = 5;
      linkItem.downVotes = 3;

      final json = linkItem.toJSONEncodable();
      expect(json['name'], 'Test');
      expect(json['urlLink'], 'https://example.com');
      expect(json['upVotes'], 5);
      expect(json['downVotes'], 3);
    });
  });



    testWidgets('LinkStorage saves and retrieves items correctly',
            (WidgetTester tester) async {
          final linkStorage = LinkStorage();
          final linkItems = [
            LinkItem(name: 'Test 1', urlLink: 'https://example.com/1'),
            LinkItem(name: 'Test 2', urlLink: 'https://example.com/2'),
          ];

          await linkStorage.saveItems(linkItems);

          final storedItems = await linkStorage.getStoredItems();
          expect(storedItems.length, linkItems.length);
          for (int i = 0; i < storedItems.length; i++) {
            expect(storedItems[i].name, linkItems[i].name);
            expect(storedItems[i].urlLink, linkItems[i].urlLink);
          }
        });



}
