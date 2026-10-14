import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

// ============ LOCALIZATION ============
class L10n {
  static final Map<String, Map<String, String>> t = {
    'en': {
      'appTitle': 'My Carpool Diary',
      'dashboard': 'Dashboard', 'addTrip': 'Add Trip',
      'settlement': 'Settlement', 'members': 'Members',
      'totalStatus': 'Total Status', 'totalKm': 'Total Distance',
      'totalFuel': 'Total Fuel', 'avgMileage': 'Average Mileage',
      'totalCost': 'Total Cost', 'addNewTrip': 'Add New Trip',
      'totalKmLabel': 'Total Distance (km)', 'fuelType': 'Fuel Type',
      'fuelQty': 'Fuel Quantity (L/units)',
      'fuelPrice': 'Price (per L/unit)',
      'whoWasPresent': 'Who was present today?',
      'saveTrip': 'Save Trip',
      'weeklySettlement': 'Weekly Settlement',
      'eachPassengerPays': '(Each passenger pays to owner)',
      'backup': 'Backup', 'restore': 'Restore',
      'addMember': 'Add Member', 'memberName': 'Name',
      'mobileNumber': 'Mobile Number', 'profilePhoto': 'Profile Photo',
      'selectAvatar': 'Select Avatar',
      'chooseFromGallery': 'Choose from Gallery',
      'save': 'Save', 'cancel': 'Cancel',
      'tripSaved': 'Trip saved successfully!',
      'backupReady': 'Backup is ready!',
      'backupRestored': 'Backup restored successfully!',
      'petrol': 'Petrol', 'diesel': 'Diesel',
      'cng': 'CNG', 'electric': 'Electric',
      'noMembers': 'No members yet. Add members first!',
      'owner': 'Owner (You)',
    },
    'gu': {
      'appTitle': 'મારી કારપુલ ડાયરી',
      'dashboard': 'ડેશબોર્ડ', 'addTrip': 'ટ્રિપ ઉમેરો',
      'settlement': 'હિસાબ', 'members': 'સભ્યો',
      'totalStatus': 'કુલ સ્ટેટસ', 'totalKm': 'કુલ કિમી ચાલ્યું',
      'totalFuel': 'કુલ ફ્યુઅલ વપરાશ', 'avgMileage': 'એવરેજ મઈલેજ',
      'totalCost': 'કુલ ખર્ચ', 'addNewTrip': 'નવી ટ્રિપ ઉમેરો',
      'totalKmLabel': 'કુલ કિમી (km)', 'fuelType': 'ફ્યુઅલનો પ્રકાર',
      'fuelQty': 'ફ્યુઅલ જથ્થો (લીટર/યુનિટ)',
      'fuelPrice': 'ભાવ (પ્રતિ લીટર/યુનિટ)',
      'whoWasPresent': 'આજે કોણ હાજર હતું?',
      'saveTrip': 'ટ્રિપ સેવ કરો',
      'weeklySettlement': 'આ અઠવાડિયાનો હિસાબ',
      'eachPassengerPays': '(દરેક પેસેન્જર માલિકને કેટલા આપશે)',
      'backup': 'બેકઅપ લો', 'restore': 'બેકઅપ રીસ્ટોર કરો',
      'addMember': 'સભ્ય ઉમેરો', 'memberName': 'નામ',
      'mobileNumber': 'મોબાઈલ નંબર', 'profilePhoto': 'પ્રોફાઈલ ફોટો',
      'selectAvatar': 'અવતાર પસંદ કરો',
      'chooseFromGallery': 'ગેલેરીમાંથી પસંદ કરો',
      'save': 'સેવ કરો', 'cancel': 'રદ કરો',
      'tripSaved': 'ટ્રિપ સફળતાપૂર્વક ઉમેરાઈ!',
      'backupReady': 'બેકઅપ તૈયાર છે!',
      'backupRestored': 'બેકઅપ રીસ્ટોર થઈ ગયો!',
      'petrol': 'પેટ્રોલ', 'diesel': 'ડીઝલ',
      'cng': 'સીએનજી', 'electric': 'ઇલેક્ટ્રિક',
      'noMembers': 'કોઈ સભ્ય નથી. પહેલાં સભ્યો ઉમેરો!',
      'owner': 'માલિક (તમે)',
    },
    'hi': {
      'appTitle': 'मेरी कारपूल डायरी',
      'dashboard': 'डैशबोर्ड', 'addTrip': 'ट्रिप जोड़ें',
      'settlement': 'हिसाब', 'members': 'सदस्य',
      'totalStatus': 'कुल स्थिति', 'totalKm': 'कुल किलोमीटर',
      'totalFuel': 'कुल ईंधन', 'avgMileage': 'औसत माइलेज',
      'totalCost': 'कुल खर्च', 'addNewTrip': 'नई ट्रिप जोड़ें',
      'totalKmLabel': 'कुल किलोमीटर (km)', 'fuelType': 'ईंधन का प्रकार',
      'fuelQty': 'ईंधन मात्रा (लीटर/यूनिट)',
      'fuelPrice': 'कीमत (प्रति लीटर/यूनिट)',
      'whoWasPresent': 'आज कौन उपस्थित था?',
      'saveTrip': 'ट्रिप सेव करें',
      'weeklySettlement': 'इस सप्ताह का हिसाब',
      'eachPassengerPays': '(प्रत्येक यात्री मालिक को कितने देगा)',
      'backup': 'बैकअप लो', 'restore': 'बैकअप रिस्टोर करें',
      'addMember': 'सदस्य जोड़ें', 'memberName': 'नाम',
      'mobileNumber': 'मोबाइल नंबर', 'profilePhoto': 'प्रोफाइल फोटो',
      'selectAvatar': 'अवतार चुनें',
      'chooseFromGallery': 'गैलरी से चुनें',
      'save': 'सेव करें', 'cancel': 'रद्द करें',
      'tripSaved': 'ट्रिप सफलतापूर्वक सेव हुई!',
      'backupReady': 'बैकअप तैयार है!',
      'backupRestored': 'बैकअप रिस्टोर हो गया!',
      'petrol': 'पेट्रोल', 'diesel': 'डीज़ल',
      'cng': 'सीएनजी', 'electric': 'इलेक्ट्रिक',
      'noMembers': 'कोई सदस्य नहीं। पहले सदस्य जोड़ें!',
      'owner': 'मालिक (आप)',
    },
  };
  static String tr(BuildContext context, String key) {
    final lc = Localizations.localeOf(context).languageCode;
    return t[lc]?[key] ?? t['en']![key] ?? key;
  }
}

// ============ MODELS ============
class Member {
  String id;
  String name;
  String mobile;
  String? photoPath;
  int? avatarIcon;
  Member({required this.id, required this.name, required this.mobile, this.photoPath, this.avatarIcon});
  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'mobile': mobile, 'photoPath': photoPath, 'avatarIcon': avatarIcon};
  factory Member.fromJson(Map<String, dynamic> j) => Member(id: j['id'], name: j['name'], mobile: j['mobile'], photoPath: j['photoPath'], avatarIcon: j['avatarIcon']);
}

class MemberAdapter extends TypeAdapter<Member> {
  @override
  final int typeId = 1;
  @override
  Member read(BinaryReader r) {
    final n = r.readByteCount();
    final f = <int, dynamic>{for (int i = 0; i < n; i++) r.readByte(): r.read()};
    return Member(id: f[0], name: f[1], mobile: f[2], photoPath: f[3], avatarIcon: f[4]);
  }
  @override
  void write(BinaryWriter w, Member o) {
    w.writeByteCount(5);
    w..writeByte(0)..write(o.id)..writeByte(1)..write(o.name)..writeByte(2)..write(o.mobile)..writeByte(3)..write(o.photoPath)..writeByte(4)..write(o.avatarIcon);
  }
}

class Trip {
  DateTime date;
  double distanceKm;
  double fuelQty;
  double fuelPrice;
  String fuelType;
  List<String> passengerIds;
  Trip({required this.date, required this.distanceKm, required this.fuelQty, required this.fuelPrice, required this.fuelType, required this.passengerIds});
  double get totalCost => fuelQty * fuelPrice;
  Map<String, dynamic> toJson() => {'date': date.toIso8601String(), 'distanceKm': distanceKm, 'fuelQty': fuelQty, 'fuelPrice': fuelPrice, 'fuelType': fuelType, 'passengerIds': passengerIds};
  factory Trip.fromJson(Map<String, dynamic> j) => Trip(date: DateTime.parse(j['date']), distanceKm: j['distanceKm'], fuelQty: j['fuelQty'], fuelPrice: j['fuelPrice'], fuelType: j['fuelType'], passengerIds: List<String>.from(j['passengerIds']));
}

class TripAdapter extends TypeAdapter<Trip> {
  @override
  final int typeId = 0;
  @override
  Trip read(BinaryReader r) {
    final n = r.readByteCount();
    final f = <int, dynamic>{for (int i = 0; i < n; i++) r.readByte(): r.read()};
    return Trip(date: f[0], distanceKm: f[1], fuelQty: f[2], fuelPrice: f[3], fuelType: f[4], passengerIds: List<String>.from(f[5]));
  }
  @override
  void write(BinaryWriter w, Trip o) {
    w.writeByteCount(6);
    w..writeByte(0)..write(o.date)..writeByte(1)..write(o.distanceKm)..writeByte(2)..write(o.fuelQty)..writeByte(3)..write(o.fuelPrice)..writeByte(4)..write(o.fuelType)..writeByte(5)..write(o.passengerIds);
  }
}

// ============ MAIN ============
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TripAdapter());
  Hive.registerAdapter(MemberAdapter());
  await Hive.openBox<Trip>('trips');
  await Hive.openBox<Member>('members');
  runApp(const CarPoolApp());
}

class CarPoolApp extends StatefulWidget {
  const CarPoolApp({super.key});
  @override
  State<CarPoolApp> createState() => _CarPoolAppState();
}

class _CarPoolAppState extends State<CarPoolApp> {
  Locale _locale = const Locale('en');
  void setLocale(Locale l) => setState(() => _locale = l);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carpool Tracker',
      locale: _locale,
      supportedLocales: const [Locale('en'), Locale('gu'), Locale('hi')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(primarySwatch: Colors.deepPurple, useMaterial3: true),
      home: HomePage(setLocale: setLocale),
    );
  }
}

class HomePage extends StatefulWidget {
  final Function(Locale) setLocale;
  const HomePage({super.key, required this.setLocale});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _idx = 0;
  Box<Trip> get tb => Hive.box<Trip>('trips');
  Box<Member> get mb => Hive.box<Member>('members');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.tr(context, 'appTitle')),
        centerTitle: true,
        actions: [
          PopupMenuButton<Locale>(
            onSelected: widget.setLocale,
            icon: const Icon(Icons.language),
            itemBuilder: (_) => const [
              PopupMenuItem(value: Locale('en'), child: Text('English')),
              PopupMenuItem(value: Locale('gu'), child: Text('ગુજરાતી')),
              PopupMenuItem(value: Locale('hi'), child: Text('हिंदी')),
            ],
          ),
          PopupMenuButton<String>(
            onSelected: (v) async {
              if (v == 'backup') await _export();
              if (v == 'restore') await _import();
            },
            itemBuilder: (_) => [
              PopupMenuItem(value: 'backup', child: Text(L10n.tr(context, 'backup'))),
              PopupMenuItem(value: 'restore', child: Text(L10n.tr(context, 'restore'))),
            ],
          ),
        ],
      ),
      body: [_dashboard(), _addTrip(), _settlement(), _members()][_idx],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _idx,
        onTap: (i) => setState(() => _idx = i),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.dashboard), label: L10n.tr(context, 'dashboard')),
          BottomNavigationBarItem(icon: const Icon(Icons.add_circle), label: L10n.tr(context, 'addTrip')),
          BottomNavigationBarItem(icon: const Icon(Icons.calculate), label: L10n.tr(context, 'settlement')),
          BottomNavigationBarItem(icon: const Icon(Icons.people), label: L10n.tr(context, 'members')),
        ],
      ),
    );
  }

  // ========== DASHBOARD ==========
  Widget _dashboard() {
    final trips = tb.values.toList();
    final tk = trips.fold(0.0, (s, t) => s + t.distanceKm);
    final tf = trips.fold(0.0, (s, t) => s + t.fuelQty);
    final tc = trips.fold(0.0, (s, t) => s + t.totalCost);
    final ml = tf > 0 ? tk / tf : 0.0;
    return Padding(padding: const EdgeInsets.all(16), child: ListView(children: [
      Text(L10n.tr(context, 'totalStatus'), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      const SizedBox(height: 20),
      _card(L10n.tr(context, 'totalKm'), '${tk.toStringAsFixed(1)} km', Icons.directions_car, Colors.blue),
      _card(L10n.tr(context, 'totalFuel'), '${tf.toStringAsFixed(2)} L', Icons.local_gas_station, Colors.orange),
      _card(L10n.tr(context, 'avgMileage'), '${ml.toStringAsFixed(2)} km/l', Icons.speed, Colors.green),
      _card(L10n.tr(context, 'totalCost'), '₹ ${tc.toStringAsFixed(0)}', Icons.currency_rupee, Colors.red),
    ]));
  }

  Widget _card(String t, String v, IconData i, Color c) => Card(
    margin: const EdgeInsets.only(bottom: 15), elevation: 4,
    child: ListTile(
      leading: CircleAvatar(backgroundColor: c, child: Icon(i, color: Colors.white)),
      title: Text(t, style: const TextStyle(fontSize: 16)),
      trailing: Text(v, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: c)),
    ),
  );

  // ========== ADD TRIP ==========
  Widget _addTrip() {
    final members = mb.values.toList();
    if (members.isEmpty) {
      return Center(child: Padding(padding: const EdgeInsets.all(20), child: Text(L10n.tr(context, 'noMembers'), textAlign: TextAlign.center, style: const TextStyle(fontSize: 18))));
    }
    final fuels = ['petrol', 'diesel', 'cng', 'electric'];
    String selFuel = fuels[0];
    List<String> selPax = [];
    final kmC = TextEditingController(), fqC = TextEditingController(), fpC = TextEditingController();

    return Padding(padding: const EdgeInsets.all(16), child: StatefulBuilder(builder: (context, set) => SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(L10n.tr(context, 'addNewTrip'), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      const SizedBox(height: 20),
      TextField(controller: kmC, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: L10n.tr(context, 'totalKmLabel'), border: const OutlineInputBorder())),
      const SizedBox(height: 15),
      DropdownButtonFormField<String>(
        value: selFuel,
        decoration: InputDecoration(labelText: L10n.tr(context, 'fuelType'), border: const OutlineInputBorder()),
        items: fuels.map((f) => DropdownMenuItem(value: f, child: Text(L10n.tr(context, f)))).toList(),
        onChanged: (v) => set(() => selFuel = v!),
      ),
      const SizedBox(height: 15),
      TextField(controller: fqC, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: L10n.tr(context, 'fuelQty'), border: const OutlineInputBorder())),
      const SizedBox(height: 15),
      TextField(controller: fpC, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: L10n.tr(context, 'fuelPrice'), border: const OutlineInputBorder())),
      const SizedBox(height: 20),
      Text(L10n.tr(context, 'whoWasPresent'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
      const SizedBox(height: 10),
      ...members.map((m) => CheckboxListTile(
        title: Text(m.name), subtitle: Text(m.mobile),
        value: selPax.contains(m.id),
        onChanged: (s) => set(() => s == true ? selPax.add(m.id) : selPax.remove(m.id)),
      )),
      const SizedBox(height: 20),
      SizedBox(width: double.infinity, child: ElevatedButton.icon(
        onPressed: () async {
          await tb.add(Trip(
            date: DateTime.now(),
            distanceKm: double.tryParse(kmC.text) ?? 0,
            fuelQty: double.tryParse(fqC.text) ?? 0,
            fuelPrice: double.tryParse(fpC.text) ?? 0,
            fuelType: selFuel,
            passengerIds: selPax,
          ));
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(L10n.tr(context, 'tripSaved'))));
          setState(() => _idx = 0);
        },
        icon: const Icon(Icons.save), label: Text(L10n.tr(context, 'saveTrip')),
        style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
      )),
    ]))));
  }

  // ========== SETTLEMENT ==========
  Widget _settlement() {
    final trips = tb.values.toList();
    final members = mb.values.toList();
    Map<String, double> dues = {for (var m in members) m.id: 0.0};
    for (var t in trips) {
      final share = t.totalCost / (t.passengerIds.length + 1);
      for (var pid in t.passengerIds) dues[pid] = (dues[pid] ?? 0) + share;
    }
    return Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(L10n.tr(context, 'weeklySettlement'), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        IconButton(icon: const Icon(Icons.picture_as_pdf, color: Colors.red), onPressed: () => _genWeeklyPDF(trips, members, dues)),
      ]),
      Text(L10n.tr(context, 'eachPassengerPays'), style: const TextStyle(color: Colors.grey)),
      const SizedBox(height: 20),
      Expanded(child: ListView(children: [
        ...members.map((m) {
          final amt = dues[m.id] ?? 0;
          return Card(margin: const EdgeInsets.only(bottom: 10), child: ListTile(
            leading: _avatar(m),
            title: Text(m.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(m.mobile),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              Text('₹ ${amt.toStringAsFixed(0)}', style: TextStyle(fontSize: 20, color: amt > 0 ? Colors.green : Colors.red, fontWeight: FontWeight.bold)),
              IconButton(icon: const Icon(Icons.picture_as_pdf, size: 20), onPressed: () => _genPersonalPDF(m, trips)),
            ]),
          ));
        }),
      ])),
    ]));
  }

  // ========== MEMBERS ==========
  Widget _members() {
    final members = mb.values.toList();
    return Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(L10n.tr(context, 'members'), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ElevatedButton.icon(onPressed: _addMember, icon: const Icon(Icons.add), label: Text(L10n.tr(context, 'addMember'))),
      ]),
      const SizedBox(height: 20),
      Expanded(child: ListView.builder(
        itemCount: members.length,
        itemBuilder: (_, i) {
          final m = members[i];
          return Card(margin: const EdgeInsets.only(bottom: 10), child: ListTile(
            leading: _avatar(m),
            title: Text(m.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(m.mobile),
            trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () async {
              await mb.delete(m.id);
              setState(() {});
            }),
          ));
        },
      )),
    ]));
  }

  Widget _avatar(Member m) {
    if (m.photoPath != null && File(m.photoPath!).existsSync()) {
      return CircleAvatar(backgroundImage: FileImage(File(m.photoPath!)));
    }
    final icons = [Icons.face, Icons.person, Icons.account_circle, Icons.sentiment_satisfied];
    return CircleAvatar(child: Icon(m.avatarIcon != null ? icons[m.avatarIcon!] : Icons.person));
  }

  Future<void> _addMember() async {
    final nameC = TextEditingController(), mobC = TextEditingController();
    String? photo;
    int? av;
    await showDialog(context: context, builder: (ctx) => StatefulBuilder(builder: (ctx, set) => AlertDialog(
      title: Text(L10n.tr(ctx, 'addMember')),
      content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: nameC, decoration: InputDecoration(labelText: L10n.tr(ctx, 'memberName'))),
        const SizedBox(height: 10),
        TextField(controller: mobC, keyboardType: TextInputType.phone, decoration: InputDecoration(labelText: L10n.tr(ctx, 'mobileNumber'))),
        const SizedBox(height: 20),
        Text(L10n.tr(ctx, 'profilePhoto'), style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: () async {
            final img = await ImagePicker().pickImage(source: ImageSource.gallery);
            if (img != null) {
              final dir = await getApplicationDocumentsDirectory();
              final saved = File('${dir.path}/${DateTime.now().millisecondsSinceEpoch}${path.extension(img.path)}');
              await File(img.path).copy(saved.path);
              set(() { photo = saved.path; av = null; });
            }
          },
          icon: const Icon(Icons.photo), label: Text(L10n.tr(ctx, 'chooseFromGallery')),
        ),
        const SizedBox(height: 20),
        Text(L10n.tr(ctx, 'selectAvatar'), style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Icons.face, Icons.person, Icons.account_circle, Icons.sentiment_satisfied
        ].asMap().entries.map((e) => GestureDetector(
          onTap: () => set(() { av = e.key; photo = null; }),
          child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(
            border: Border.all(color: av == e.key ? Colors.deepPurple : Colors.grey, width: 2),
            borderRadius: BorderRadius.circular(50),
          ), child: Icon(e.value, size: 40)),
        )).toList()),
      ])),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: Text(L10n.tr(ctx, 'cancel'))),
        ElevatedButton(onPressed: () async {
          if (nameC.text.isNotEmpty) {
            await mb.put(DateTime.now().millisecondsSinceEpoch.toString(), Member(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              name: nameC.text, mobile: mobC.text, photoPath: photo, avatarIcon: av,
            ));
            Navigator.pop(ctx);
            setState(() {});
          }
        }, child: Text(L10n.tr(ctx, 'save'))),
      ],
    )));
  }

  // ========== BACKUP ==========
  Future<void> _export() async {
    try {
      final data = {
        'trips': tb.values.map((t) => t.toJson()).toList(),
        'members': mb.values.map((m) => m.toJson()).toList(),
      };
      final dir = await getApplicationDocumentsDirectory();
      final f = File('${dir.path}/carpool_${DateTime.now().millisecondsSinceEpoch}.json');
      await f.writeAsString(jsonEncode(data));
      await Share.shareXFiles([XFile(f.path)]);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(L10n.tr(context, 'backupReady'))));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _import() async {
    try {
      final r = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['json']);
      if (r != null && r.files.single.path != null) {
        final s = await File(r.files.single.path!).readAsString();
        final d = jsonDecode(s);
        await tb.clear();
        await mb.clear();
        for (var t in d['trips']) await tb.add(Trip.fromJson(t));
        for (var m in d['members']) await mb.put(m['id'], Member.fromJson(m));
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(L10n.tr(context, 'backupRestored'))));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  // ========== PDF ==========
  Future<void> _genWeeklyPDF(List<Trip> trips, List<Member> members, Map<String, double> dues) async {
    final pdf = pw.Document();
    final df = DateFormat('dd/MM/yyyy');
    final tk = trips.fold(0.0, (s, t) => s + t.distanceKm);
    final tf = trips.fold(0.0, (s, t) => s + t.fuelQty);
    final tc = trips.fold(0.0, (s, t) => s + t.totalCost);
    final ml = tf > 0 ? tk / tf : 0.0;
    pdf.addPage(pw.Page(build: (c) => pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
      pw.Text('Carpool Weekly Report', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
      pw.SizedBox(height: 10),
      pw.Text('Date: ${df.format(DateTime.now())}'),
      pw.SizedBox(height: 20),
      pw.Text('Summary', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
      pw.Text('Total Distance: ${tk.toStringAsFixed(1)} km'),
      pw.Text('Total Fuel: ${tf.toStringAsFixed(2)} L'),
      pw.Text('Avg Mileage: ${ml.toStringAsFixed(2)} km/l'),
      pw.Text('Total Cost: Rs ${tc.toStringAsFixed(0)}'),
      pw.SizedBox(height: 20),
      pw.Text('Settlement', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
      pw.Table.fromTextArray(headers: ['Name', 'Mobile', 'Amount Due'],
        data: members.map((m) => [m.name, m.mobile, 'Rs ${(dues[m.id] ?? 0).toStringAsFixed(0)}']).toList()),
    ])));
    await Printing.layoutPdf(onLayout: (f) async => pdf.save());
  }

  Future<void> _genPersonalPDF(Member m, List<Trip> trips) async {
    final pdf = pw.Document();
    final df = DateFormat('dd/MM/yyyy');
    final mt = trips.where((t) => t.passengerIds.contains(m.id)).toList();
    double share = 0;
    final rows = <List<String>>[];
    for (var t in mt) {
      final s = t.totalCost / (t.passengerIds.length + 1);
      share += s;
      rows.add([df.format(t.date), t.distanceKm.toStringAsFixed(1), 'Rs ${s.toStringAsFixed(0)}']);
    }
    pdf.addPage(pw.Page(build: (c) => pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
      pw.Text('Personal Report: ${m.name}', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
      pw.SizedBox(height: 10),
      pw.Text('Mobile: ${m.mobile}'),
      pw.SizedBox(height: 20),
      pw.Text('Total Trips: ${mt.length}'),
      pw.Text('Your Total Share: Rs ${share.toStringAsFixed(0)}'),
      pw.SizedBox(height: 20),
      pw.Table.fromTextArray(headers: ['Date', 'Km', 'Your Share'], data: rows),
    ])));
    await Printing.layoutPdf(onLayout: (f) async => pdf.save());
  }
}

// Helper extension
extension MapEntries<K, V> on Map<K, V> {
  Iterable<MapEntry<int, V>> asMap() sync* {
    int i = 0;
    for (final v in values) yield MapEntry(i++, v);
  }
}
