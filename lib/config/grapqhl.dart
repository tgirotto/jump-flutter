import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:greece/config/storage.dart';
import 'package:greece/model/jwt.dart';

class GraphQL {
  // static String endpoint = 'https://api.jump.getpolygraph.com/graphql';
  // static String endpoint = 'https://dev.api.jump.getpolygraph.com/graphql';
  // static String endpoint = 'http://192.168.178.172:3000/graphql';
  static String endpoint = 'http://192.168.1.6/graphql';

  static final httpLink = HttpLink(
    endpoint,
  );

  static final AuthLink authLink = AuthLink(getToken: () async {
    const String refreshTokenGql = """
      mutation refresh {
        refresh {
          access_token,
          refresh_token
        }
      }
    """;
    //check the refresh time of the token
    String? refreshedAtString =
        await JumpStorage.storage.read(key: "refreshed_at");

    if (refreshedAtString != null) {
      DateTime refreshedAt = DateTime.parse(refreshedAtString);
      DateTime xMinutesAfter = refreshedAt.add(const Duration(minutes: 5));
      DateTime now = DateTime.now();
      // print(xMinutesAfter);
      // print(now);
      //if the refresh time plus x minutes is after now, then it means it's time to refresh the token
      if (xMinutesAfter.isBefore(now)) {
        QueryResult result = await refreshClient.mutate(MutationOptions(
          document: gql(refreshTokenGql),
        ));

        Jwt token = Jwt.fromJson(result.data?['refresh']);

        await JumpStorage.storage
            .write(key: 'access_token', value: token.accessToken);
        await JumpStorage.storage
            .write(key: 'refresh_token', value: token.refreshToken);

        //need to keep track of when the token was refreshed to make sure that we know when to update it later
        final now = DateTime.now();
        await JumpStorage.storage
            .write(key: 'refreshed_at', value: now.toIso8601String());
      }
    }

    //if the refresh time was more than x min ago, then refresh it
    String? string = await JumpStorage.storage.read(key: "access_token");

    if (string != null) {
      return "Bearer " + string;
    }

    return "";
  });

  static final AuthLink refreshLink = AuthLink(getToken: () async {
    String? string = await JumpStorage.storage.read(key: "refresh_token");

    if (string != null) {
      return "Bearer " + string;
    }

    return "";
  });

  static GraphQLClient refreshClient = GraphQLClient(
    link: refreshLink.concat(httpLink),
    cache: GraphQLCache(store: InMemoryStore()),
    defaultPolicies: DefaultPolicies(
      watchQuery: Policies(
        fetch: FetchPolicy.networkOnly,
      ),
      query: Policies(
        fetch: FetchPolicy.networkOnly,
      ),
      mutate: Policies(
        fetch: FetchPolicy.networkOnly,
      ),
    ),
  );

  static GraphQLClient client = GraphQLClient(
    link: authLink.concat(httpLink),
    cache: GraphQLCache(store: InMemoryStore()),
    defaultPolicies: DefaultPolicies(
      watchQuery: Policies(
        fetch: FetchPolicy.networkOnly,
      ),
      query: Policies(
        fetch: FetchPolicy.networkOnly,
      ),
      mutate: Policies(
        fetch: FetchPolicy.networkOnly,
      ),
    ),
  );
}
