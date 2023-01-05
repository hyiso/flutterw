import 'package:cli_util/cli_logging.dart';

Logger get logger => Logger.standard();

void logError(String message) {
  logger.stderr(logger.ansi.error(message));
}
