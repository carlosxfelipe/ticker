import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';

class BackupService {
  static Future<void> exportDatabase(BuildContext context) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final dbPath = join(appDir.path, 'assets.db');
      final dbFile = File(dbPath);

      if (!await dbFile.exists()) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Arquivo do banco de dados não encontrado.'),
            ),
          );
        }
        return;
      }

      final tempDir = await getTemporaryDirectory();
      final exportPath = join(tempDir.path, 'assets_backup.db');
      await dbFile.copy(exportPath);

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(exportPath)],
          fileNameOverrides: ['assets_backup.db'],
          sharePositionOrigin: Rect.zero,
        ),
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao exportar: $e')));
      }
    }
  }

  static Future<void> importDatabase(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['db'],
      );
      if (result?.files.single.path == null) return;

      final selectedFile = File(result!.files.single.path!);
      final appDir = await getApplicationDocumentsDirectory();
      final dbPath = join(appDir.path, 'assets.db');

      await selectedFile.copy(dbPath);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Banco de dados importado com sucesso.'),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao importar: $e')));
      }
    }
  }
}
