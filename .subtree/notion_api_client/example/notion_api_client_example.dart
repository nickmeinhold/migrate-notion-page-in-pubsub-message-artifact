import 'package:api_client_utils/api_client_utils.dart';
import 'package:notion_api_client/notion_api_client.dart';
import 'package:notion_api_client/src/pageable.dart';

import 'credentials.dart';

const pageId = 'ba16e52f6bf04eb5927fda3a45c38d53';

void main() async {
  var client = NotionClient(token: token);

  try {
    PageableResponse? response =
        await client.getBlockChildren(id: pageId, recursive: true);

    if (response == null) {
      print('There was nothing returned!');
      return;
    }

    // TODO: do something with the results
    print(response.results);

    while (response!.hasMore) {
      print("There was more than one page of results.");
      response = await client.getBlockChildren(id: pageId, recursive: true);
      // TODO: do something with the results
    }
  } on APIRequestException catch (error) {
    print(error.getJsonValue(key: 'message'));
  } finally {
    client.close();
  }
}
