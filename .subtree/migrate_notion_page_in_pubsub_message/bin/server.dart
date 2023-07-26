import 'dart:convert';

import 'package:discord_application_utils/discord_application_utils.dart';
import 'package:http/http.dart' as http;
import 'package:json_utils/json_utils.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

Future<Response> handler(Request request) async {
  try {
    final String bodyString = await request.readAsString();
    final JsonMap bodyJson = jsonDecode(bodyString);
    // print('body:\n$bodyJson');
    print(bodyString);

    final JsonMap messageJson = bodyJson['message'] as JsonMap? ??
        (throw MalformedJsonException(
            'The "message" key was not found at the top level', bodyJson));

    final String encodedMessageData = messageJson['data'] as String? ??
        (throw MalformedJsonException(
            '"data" key was not found in "message" object', bodyJson));

    final JsonMap decodedMessageJson =
        json.decode(utf8.decode(base64.decode(encodedMessageData))) as JsonMap;
    print('decodedMessageJson: $decodedMessageJson');

    final Interaction interaction = Interaction.fromJson(decodedMessageJson);

    print(interaction);

    // construct the uri we will use to update the Discord response
    var uri = Uri.parse(
        "https://discord.com/api/v8/webhooks/${interaction.applicationId}/${interaction.token}/messages/@original");

    // Make a http call to edit the interaction response
    var response = await http
        .patch(uri, body: {'content': interaction.data?.options.first.value});

    print('response:\n${response.body}');

    return Response.ok('...');
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
