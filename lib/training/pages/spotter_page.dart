import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mob_archery/training/enums/registered_by.dart';

class SpotterPage extends StatefulWidget {
  const SpotterPage({super.key});

  @override
  State<SpotterPage> createState() => _SpotterPageState();
}

class _SpotterPageState extends State<SpotterPage> {
  late final TextEditingController spotterController;

  @override
  void initState() {
    super.initState();
    spotterController = TextEditingController(text: 'Ricardo Almeida');
  }

  @override
  void dispose() {
    spotterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: Modular.to.pop),
        title: const Text('Registro do Spotter'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 14),
            child: Icon(Icons.more_vert_rounded, color: Color(0xFFFF5C00)),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text(
                    'Informacoes do Registro',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Confirme os detalhes da operacao assistida',
                    style: TextStyle(color: Color(0xFF6B7A99)),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: const Color(0xFFFFD9C6)),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.group_outlined, color: Color(0xFFFF5C00)),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Registro por Spotter',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'O auxilio por spotter esta ativado',
                                style: TextStyle(color: Color(0xFF6B7A99)),
                              ),
                            ],
                          ),
                        ),
                        Switch(value: true, onChanged: null),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  const Text(
                    'Nome do Spotter Responsavel',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: spotterController,
                    decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.check_circle_outline, color: Colors.green),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: FilledButton(
                onPressed: () {
                  Modular.to.pushNamed(
                    '/training/register-end',
                    arguments: {
                      'registeredBy': RegisteredBy.spotter.name,
                      'spotterName': spotterController.text,
                    },
                  );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5C00),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Finalizar Registro'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
