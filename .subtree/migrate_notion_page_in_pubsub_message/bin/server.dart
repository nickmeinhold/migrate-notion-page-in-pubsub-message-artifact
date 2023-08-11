import 'dart:io';

import 'package:discord_application_utils/discord_application_utils.dart';
import 'package:json_utils/json_utils.dart';
import 'package:notion_api_client/notion_api_client.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_gcp_utils/shelf_gcp_utils.dart';

String? tokenForNotion = Platform.environment['NOTION_TOKEN'];

Future<Response> handler(Request request) async {
  try {
    verifyEnvironmentState();

    // Retrieve and log the request body
    String bodyString = await request.readAsString();
    print(bodyString);

    // Extract the Pub/Sub message and use it to make an object that will
    // handle the Discord interaction
    JsonMap pubsubMessage = extractPubSubMessage(bodyString);
    final interactor = DiscordInteractor(interactionJson: pubsubMessage);

    // Retrieve the Notion page URL, which was given as a slash command option
    String pageUrl = interactor.getOptionValue<String>(name: 'url')!;

    var client = NotionClient(token: tokenForNotion!);

    return Response.ok();
  } catch (e, s) {
    print('Exception:\n$e\n\nTrace:\n$s');
    return Response.internalServerError();
  }
}

void main(List<String> args) async {
  shelf_io.serve(handler, '0.0.0.0', 8080).then((server) {
    print('Serving at https://${server.address.host}:${server.port}');
  });
}

void verifyEnvironmentState() {
  if (tokenForNotion == null) throw 'Please set "NOTION_TOKEN" env var.';
}
