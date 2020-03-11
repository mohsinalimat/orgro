import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:org_flutter/org_flutter.dart';
import 'package:orgro/src/actions/actions.dart';
import 'package:orgro/src/navigation.dart';
import 'package:url_launcher/url_launcher.dart';

class DocumentPage extends StatefulWidget {
  const DocumentPage({
    @required this.title,
    @required this.child,
    this.textScale,
    Key key,
  })  : assert(child != null),
        super(key: key);

  final String title;
  final Widget child;
  final double textScale;

  @override
  _DocumentPageState createState() => _DocumentPageState();
}

class _DocumentPageState extends State<DocumentPage> {
  double _textScale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _textScale ??= widget.textScale ?? MediaQuery.textScaleFactorOf(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.title == null ? const Text('Orgro') : Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.repeat),
            onPressed: OrgController.of(context).cycleVisibility,
          ),
          TextSizeButton(
            value: _textScale,
            onChanged: (value) => setState(() => _textScale = value),
          ),
          const ScrollTopButton(),
          const ScrollBottomButton(),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: _textScale),
            // Builder required to get modified textScaleFactor into the context
            child: Builder(
              builder: (context) => OrgRootWidget(
                child: widget.child,
                style: GoogleFonts.firaMono(fontSize: 18),
                onLinkTap: (url) => launch(url, forceSafariVC: false),
                onSectionLongPress: (section) =>
                    narrow(context, widget.title, section),
              ),
            ),
          ),
        ],
      ),
    );
  }
}