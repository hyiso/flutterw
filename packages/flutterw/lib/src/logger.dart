import 'package:cli_util/cli_logging.dart';

Logger get logger => _logger;

late Logger _logger;

void initLogger(bool isVerbose) {
  _logger = isVerbose ? VerboseLogger() : StandardLogger();
}

void logError(String message) {
  logger.stderr(logger.ansi.error(message));
}
