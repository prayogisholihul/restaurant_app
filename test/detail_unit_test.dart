import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:restaurant_app/data/model/detail_restaurant.dart';
import 'package:restaurant_app/networking/api_service.dart';

import 'detail_unit_test.mocks.dart';

final id = 'rqdv5juczeskfw1e867';
final responseBody = '''
        {
          "error": false,
          "message": "zxc",
          "restaurant": {
            "id": "zxc",
            "name": "zxc",
            "description": "zxc",
            "city": "zxc",
            "address": "zxc",
            "pictureId": "zxc",
            "categories": [],
            "menus": {
              "foods": [],
              "drinks": []
            },
            "rating": 9.2,
            "customerReviews": []
          }
        }
      ''';

@GenerateMocks([http.Client])
void main() {
  group('fetchRestaurantDetail', () {
    test('returns an Restaurant Detail if the http call completes successfully',
            () async {
          final client = MockClient();
          when(client.get(Uri.parse(ApiService.baseUrl + '/detail/$id')))
              .thenAnswer((_) async => http.Response(responseBody,200));

          expect(await ApiService().fetchRestDetail(id, client: client), isA<DetailRestaurantResult>());
        });

    test('throws an exception if the http call completes with an error', () {
      final client = MockClient();
      when(client.get(Uri.parse(ApiService.baseUrl + '/detail/$id')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(ApiService().fetchRestDetail(id, client: client), throwsException);
    });
  });
}