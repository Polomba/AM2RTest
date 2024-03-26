import 'package:flutter/material.dart';
import 'package:generic_project/core/components/custom_scaffold.dart';

class MoreInfoUI extends StatelessWidget {
  const MoreInfoUI({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      showLeading: const BackButton(
        color: Colors.black,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 32,
          ),
          const Text(
            'Mais Informação',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 16,
          ),
          const Text(
            'Qualidade do Ar',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(
            height: 16,
          ),
          const Text(
            'Segundo a Agência Portuguesa do Ambiente a qualidade do ar está assente sobre vários parâmetros que determinam uma de cinco classificações. ',
            style: TextStyle(fontSize: 15, color: Colors.grey),
          ),
          const SizedBox(
            height: 16,
          ),
          Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Container(
                  height: 48,
                  width: 100,
                  decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: Colors.greenAccent[400]),
                  child: const Center(
                    child: Text(
                      'Muito Bom',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  height: 48,
                  width: 100,
                  decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: Colors.green),
                  child: const Center(
                    child: Text(
                      'Bom',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  height: 48,
                  width: 100,
                  decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: Colors.yellow[700]),
                  child: const Center(
                    child: Text(
                      'Médio',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ]),
              const SizedBox(
                height: 10,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Container(
                  height: 48,
                  width: 100,
                  decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: Colors.amber[800]),
                  child: const Center(
                    child: Text(
                      'Fraco',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  height: 48,
                  width: 100,
                  decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: Colors.red[400]),
                  child: const Center(
                    child: Text(
                      'Mau',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ]),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          const Text(
            'As classificações são importantes para perceber o nível de poluição em cada zona e determinar a possibilidade de existirem incêndios próximos ou até mesmo as horas com mais fluxo de trânsito. ',
            style: TextStyle(
                color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 48,
          ),
          const Row(
            children: [
              Text(
                'Tipos de Ocorrência',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                width: 8,
              ),
              Icon(Icons.info),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          const Row(
            children: [
              Icon(
                Icons.info,
                size: 26,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Incêndio',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              SizedBox(
                width: 10,
              ),
              Icon(
                Icons.info,
                size: 26,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Trânsito',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          const Row(
            children: [
              Icon(
                Icons.info,
                size: 26,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Acidente',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              SizedBox(
                width: 10,
              ),
              Icon(
                Icons.info,
                size: 26,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Acidente',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ],
          )
        ],
      ),
    );
  }
}
