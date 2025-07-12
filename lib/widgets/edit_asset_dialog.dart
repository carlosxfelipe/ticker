import 'package:flutter/material.dart';
import 'package:ticker/database/database_helper.dart';

class EditAssetDialog extends StatefulWidget {
  final Map<String, dynamic> asset;
  final VoidCallback onSaved;

  const EditAssetDialog({
    super.key,
    required this.asset,
    required this.onSaved,
  });

  @override
  State<EditAssetDialog> createState() => _EditAssetDialogState();
}

class _EditAssetDialogState extends State<EditAssetDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tickerController;
  late TextEditingController _quantityController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _tickerController = TextEditingController(text: widget.asset['ticker']);
    _quantityController = TextEditingController(
      text: widget.asset['quantity'].toString(),
    );
    _priceController = TextEditingController(
      text: widget.asset['average_price'].toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Editar Ativo'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _tickerController,
                decoration: const InputDecoration(
                  labelText: 'Ticker',
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                validator:
                    (value) =>
                        (value == null || value.isEmpty)
                            ? 'Campo obrigatório'
                            : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _quantityController,
                keyboardType: const TextInputType.numberWithOptions(),
                decoration: const InputDecoration(
                  labelText: 'Quantidade',
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                validator:
                    (value) =>
                        (value == null || value.isEmpty)
                            ? 'Campo obrigatório'
                            : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _priceController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Preço Médio',
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                validator:
                    (value) =>
                        (value == null || value.isEmpty)
                            ? 'Campo obrigatório'
                            : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final ticker = _tickerController.text.trim().toUpperCase();
              final quantity = int.tryParse(_quantityController.text.trim());
              final averagePrice = double.tryParse(
                _priceController.text.trim().replaceAll(',', '.'),
              );

              if (quantity == null || averagePrice == null) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Valores numéricos inválidos.')),
                );
                return;
              }

              try {
                await DatabaseHelper().updateAsset({
                  'id': widget.asset['id'],
                  'ticker': ticker,
                  'quantity': quantity,
                  'average_price': averagePrice,
                });

                if (!context.mounted) return;
                widget.onSaved();
                Navigator.of(context).pop();
              } catch (e) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erro ao atualizar: $e')),
                );
              }
            }
          },
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
