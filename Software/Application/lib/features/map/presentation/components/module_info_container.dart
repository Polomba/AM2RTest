import 'package:flutter/material.dart';
import 'package:generic_project/core/data/models/module/module_model.dart';
import 'package:generic_project/core/utils/decoders/iqar_decoder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ModuleInfoContainer extends StatelessWidget {
  final ModuleModel? module;
  const ModuleInfoContainer({
    super.key,
    this.module,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Visibility(
      visible: module != null,
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(module?.name ?? ''),
              const SizedBox(
                height: 12,
              ),
              Container(
                height: 48,
                padding: const EdgeInsets.all(16),
                decoration: ShapeDecoration(
                  color: IQArDecoder.decodeColor(module?.iqAr ?? 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n?.mapModuleInfoAirQualityText ?? '',
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      IQArDecoder.decodeIQArStatus(module?.iqAr ?? 6, l10n),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                )),
              ),
              const SizedBox(
                height: 12,
              ),
              const Row(
                children: [
                  Icon(Icons.place_outlined),
                  SizedBox(
                    width: 8,
                  ),
                  Text('Ciclovia Famalicão - Póvoa')
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                height: 48,
                padding: const EdgeInsets.all(16),
                decoration: ShapeDecoration(
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Acidente Registado',
                      style: TextStyle(color: Colors.white),
                    ),
                    Icon(
                      Icons.car_crash,
                      color: Colors.white,
                    ),
                  ],
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
