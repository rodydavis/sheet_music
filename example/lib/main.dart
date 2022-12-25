import 'package:flutter/material.dart';
import 'package:tonic/tonic.dart';

import 'package:sheet_music/sheet_music.dart';
import 'package:sheet_music/util/notes.dart';
import 'package:sheet_music/util/pitch_asset.dart';
import 'package:sheet_music/util/scale_asset.dart';
import 'package:sheet_music/util/scales.dart';

void main() {
  runApp(MaterialApp(home: SheetMusicExample()));
}

class SheetMusicExample extends StatefulWidget {
  @override
  SheetMusicExampleState createState() => SheetMusicExampleState();
}

class SheetMusicExampleState extends State<SheetMusicExample> {
  String? name, number, scale, pitch, timeSignature, source, notes, id;
  bool? coda, chorus, trebleClef;
  int? verses, count;

  void _pickScale(BuildContext context) {
    showModalBottomSheet<String>(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            ListTile(
              title: Text(
                'Scales',
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: scalesMajor.length,
                    itemBuilder: (BuildContext context, int index) {
                      final String _currentScale =
                          scalesMajor[index].toString();
                      return ListTile(
                        contentPadding: const EdgeInsets.all(5.0),
                        leading: SizedBox(
                          height: 60.0,
                          width: 60.0,
                          child: Image.asset(
                            getScaleAsset(_currentScale,
                                trebleClef: trebleClef),
                            package: sheetMusicPackageName,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        title: Text(
                          _currentScale,
                        ),
                        subtitle: Text(scalesMinor[index].toString()),
                        onTap: () {
                          Navigator.pop(context, _currentScale);
                        },
                      );
                    })),
          ]));
        }).then((String? value) {
      if (value != null) {
        setState(() => scale = value);
      }
    });
  }

  void _pickPitch(BuildContext context) {
    final List<String> _notesList = trebleClef ?? true
        ? pitchesTreble.reversed.toList()
        : pitchesBass.reversed.toList();
    showModalBottomSheet<String>(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            ListTile(
              title: Text(
                'Notes',
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ListView.builder(
                    itemCount: _notesList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final String _currentPitch = _notesList[index].toString();
                      final String _pitchName =
                          getPitchName(pitch: _currentPitch, scale: scale);

                      return ListTile(
                        contentPadding: const EdgeInsets.all(5.0),
                        leading: SizedBox(
                          height: 60.0,
                          width: 60.0,
                          child: Image.asset(
                            getPitchAsset(_pitchName, trebleClef: trebleClef),
                            package: sheetMusicPackageName,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        title: Text(
                          _pitchName,
                        ),
                        onTap: () {
                          final Pitch _pitchInfo = Pitch.parse(_pitchName);
                          Navigator.pop(context, _pitchInfo.toString());
                        },
                      );
                    }),
              ),
            ),
          ]));
        }).then((String? value) {
      if (value != null) {
        setState(() => pitch = value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        title: const Text('Sheet Music Example'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SheetMusic(
                height: 160.0,
                width: 300.0,
                backgroundColor: Colors.white,
                trebleClef: trebleClef,
                scale: scale,
                pitch: pitch,
                clefTap: () => setState(() => trebleClef = trebleClef ?? true),
                scaleTap: () => _pickScale(context),
                pitchTap: () => _pickPitch(context),
              ),
              ListTile(
                title: const Text('Scale'),
                subtitle: Text(scale ?? 'none'),
                trailing: const Icon(Icons.search),
                onTap: () => _pickScale(context),
              ),
              ListTile(
                title: const Text('Pitch'),
                subtitle: Text(pitch ?? 'None'),
                trailing: const Icon(Icons.search),
                onTap: () => _pickPitch(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
