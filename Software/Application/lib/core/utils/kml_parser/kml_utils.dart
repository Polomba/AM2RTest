import 'dart:developer';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:xml/xml.dart';

class KMLUtility {
  KMLUtility();

  Future<void> createKMLFile(
      String filePath, List<Map<String, double>> coordinates) async {
    final kmlContent = generateKMLContent(coordinates);
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final directoryFiles = directory.listSync();
      final file = File('${directory.path}/$filePath.kml');
      if (directoryFiles.any((element) => element.path == file.path)) {
        log('file already exists, updating...');
        await file.writeAsString(kmlContent);
      } else {
        await file.writeAsString(kmlContent);
        log('KML file created successfully at: $filePath');
      }

      //await sendKMLFileToFTP(filePath); // Send the file to the FTP server
    } catch (e) {
      log('Error creating KML file: $e');
    }
  }

  String generateKMLContent(List<Map<String, double>> coordinates) {
    final StringBuffer kmlBuffer = StringBuffer();

    kmlBuffer.writeln('<?xml version="1.0" encoding="UTF-8"?>');
    kmlBuffer.writeln('<kml xmlns="http://earth.google.com/kml/2.2">');
    kmlBuffer.writeln('  <Document>');

    // Add Placemark with coordinates
    kmlBuffer.writeln('    <Placemark>');
    kmlBuffer.writeln('      <name>New Placemark</name>');
    kmlBuffer.writeln('      <LineString>');
    kmlBuffer.writeln('        <coordinates>');

    for (var coord in coordinates) {
      kmlBuffer.write('${coord['longitude']},${coord['latitude']} ');
    }

    kmlBuffer.writeln('        </coordinates>');
    kmlBuffer.writeln('      </LineString>');
    kmlBuffer.writeln('    </Placemark>');

    kmlBuffer.writeln('  </Document>');
    kmlBuffer.writeln('</kml>');

    return kmlBuffer.toString();
  }

  List<Map<String, double>> getCoordinates(XmlDocument document) {
    List<Map<String, double>> coordinates = [];
    final coordinatesText =
        document.findAllElements('coordinates').first.innerText.trim();
    final coordinatesArray = coordinatesText.split(' ');

    if (coordinatesArray != null && coordinatesArray.isNotEmpty) {
      for (var coord in coordinatesArray) {
        final coordValues = coord.split(',');
        final latitude = double.parse(coordValues[1]);
        final longitude = double.parse(coordValues[0]);
        coordinates.add({'latitude': latitude, 'longitude': longitude});
      }
    }

    return coordinates;
  }
}
