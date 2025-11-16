// ignore_for_file: avoid_print

import 'dart:io';

String? getVersionFromPubspec() {
  final pubspec = File('pubspec.yaml');
  if (!pubspec.existsSync()) return null;
  final lines = pubspec.readAsLinesSync();
  for (final line in lines) {
    final trimmed = line.trim();
    if (trimmed.startsWith('version:')) {
      return trimmed.split(':').last.trim();
    }
  }
  return null;
}

void main() async {
  final version = getVersionFromPubspec();
  if (version == null) {
    print('Não foi possível encontrar a versão no pubspec.yaml');
    exit(1);
  }

  // Gera o APK de release
  final build = await Process.start('flutter', ['build', 'apk', '--release']);
  stdout.addStream(build.stdout);
  stderr.addStream(build.stderr);
  final exitCode = await build.exitCode;
  if (exitCode != 0) {
    print('Erro ao gerar o APK de release.');
    exit(exitCode);
  }

  // Copia o APK para a pasta releases com a versão correta
  final src = 'build/app/outputs/flutter-apk/app-release.apk';
  final dest = 'releases/ticker-v$version.apk';
  final srcFile = File(src);
  if (!srcFile.existsSync()) {
    print('APK não encontrado em $src');
    exit(1);
  }
  await srcFile.copy(dest);
  print('APK de release gerado e copiado para $dest');
}
