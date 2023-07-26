import 'package:discord_api_client/discord_api_client.dart';

import 'credentials.dart' as credentials;

void main() async {
  final client = DiscordClient(
      applicationId: credentials.applicationId,
      guildId: credentials.guildId,
      botToken: credentials.botToken,
      version: 8);

  var slashCommand = ApplicationCommand(
      type: ApplicationCommandType.chatInput,
      name: 'migrate',
      description: 'Migrate a Notion page into the current channel...',
      options: [
        ApplicationCommandOption(
            type: ApplicationCommandOptionType.string,
            name: 'url',
            description: 'Enter the URL of the Notion page to migrate')
      ]);

  var response = await client.createCommand(slashCommand);

  // var response = await client.getCommands();
  // var response = await client.deletCommand('...');

  print(response.body);
}
