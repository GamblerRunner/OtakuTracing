import 'package:graphql/client.dart';

class GrahpqlData {
  static const String _endpoint = 'https://graphql.anilist.co';
  final GraphQLClient client;

  GrahpqlData({GraphQLClient? injectedClient})
      : client = injectedClient ?? _buildClient();

  static GraphQLClient _buildClient() {
    final Link link = HttpLink(_endpoint);

    return GraphQLClient(
      link: link,
      cache: GraphQLCache(),
    );
  }

  Future<QueryResult> query(
      String queryString, {
        Map<String, dynamic>? variables,
      }) async {
    try {
      _buildClient();
      final QueryResult result = await client.query(
        QueryOptions(
          document: gql(queryString),
          variables: variables ?? {},
        ),
      );

      if (result.hasException) {
        throw result.exception!;
      }
      print(result);
      return result;
    } catch (e) {
      throw e.toString();
    }
  }
}