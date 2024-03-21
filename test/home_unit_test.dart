import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/networking/api_service.dart';

import 'home_unit_test.mocks.dart';

final responseBody = '''
        {
          "error": false,
          "message": "success",
          "count": 20,
          "restaurants": []
        }
      ''';

@GenerateMocks([http.Client])
void main() {
  group('fetchRestaurant', () {
    test('returns an Restaurant List if the http call completes successfully',
        () async {
      final client = MockClient();
      when(client.get(Uri.parse('${ApiService.baseUrl}/list')))
          .thenAnswer((_) async => http.Response(responseBody,200));

          expect(await ApiService().fetchRestList(client: client), isA<RestaurantResult>());
    });

    test('throws an exception if the http call completes with an error', () {
      final client = MockClient();
      when(client.get(Uri.parse(ApiService.baseUrl + '/list')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(ApiService().fetchRestList(client: client), throwsException);
    });
  });
}
