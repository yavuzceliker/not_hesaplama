import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(NotHesaplama());
}

class NotHesaplama extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dinamik Not Hesaplama',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme:ThemeData(brightness:Brightness.dark ) ,
      themeMode: ThemeMode.system,

      home: DinamikNotHesaplama(),
    );
  }
}

class DinamikNotHesaplama extends StatefulWidget {
  @override
  _DinamikNotHesaplamaState createState() => _DinamikNotHesaplamaState();
}

class _DinamikNotHesaplamaState extends State<DinamikNotHesaplama> {
  double krediToplam = 0, ortalamaToplam = 0;
  List<Ders> dersListesi = List<Ders>();
  int sayac = 0;
  String dersAdi;
  double kredi, harfNotu;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Dinamik Not Hesaplama"),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
              backgroundColor: Colors.orange,
              child: Icon(
                Icons.refresh,
              ),
              mini: true,
              onPressed: () {
                setState(() {
                  kredi = 1;
                  harfNotu = 4;
                  krediToplam = 0;
                  ortalamaToplam = 0;
                  dersListesi.clear();
                });
              }),
          FloatingActionButton(
            onPressed: () {
              setState(
                () {
                  if (_formKey.currentState.validate()) {
                    krediToplam += kredi;
                    ortalamaToplam += (kredi * harfNotu);
                    dersListesi.add(Ders(dersAdi, kredi, harfNotu));
                  } else
                    return "Formu boş bırakmayınız.";
                },
              );
            },
            child: Icon(
              Icons.add,
              size: 35,
            ),
          ),
        ],
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        if (orientation == Orientation.portrait)
          return uygulama();
        else
          return uygulamaYatay();
      }),
    );
  }

  Widget uygulama() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        //NOT HESAPLAMA EKRANI
        Container(
          padding: EdgeInsets.all(8),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        borderSide: BorderSide(color: Colors.red, width: 2)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        borderSide: BorderSide(color: Colors.purple, width: 2)),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    hintText: "Ders adını giriniz",
                    labelText: "Ders Adı",
                  ),
                  autovalidate: true,
                  validator: (e) {
                    if (e.length < 2)
                      return "Ders adı en az iki karakter olmalı.";
                  },
                  onChanged: (e) {
                    dersAdi = e;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      margin: EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        border: Border.all(color: Colors.purple, width: 2),
                      ),
                      child: DropdownButton<double>(
                          items: dersKredileri(),
                          value: kredi,
                          onChanged: (e) {
                            setState(() {
                              kredi = e;
                            });
                          }),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      margin: EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        border: Border.all(color: Colors.purple, width: 2),
                      ),
                      child: DropdownButton<double>(
                          items: harfNotlari(),
                          value: harfNotu,
                          onChanged: (e) {
                            setState(() {
                              harfNotu = e;
                            });
                          }),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  color: Colors.blue,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: RichText(
                      text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Ortalama: ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                        ),
                      ),
                      TextSpan(
                        text:
                            "${(ortalamaToplam / (krediToplam == 0 ? 1 : krediToplam)).toStringAsFixed(2)}",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  )),
                ),
              ],
            ),
          ),
        ),
        //HESAPLANAN DERSLERİN LİSTESİ
        Expanded(
          child: Container(
            padding: EdgeInsets.all(5),
            child: ListView.builder(
                itemCount: dersListesi.length,
                itemBuilder: (context, i) {
                  sayac++;
                  return Dismissible(
                    direction: DismissDirection.startToEnd,
                    key: Key("$sayac"),
                    onDismissed: (direction) {
                      setState(() {
                        debugPrint(i.toString());
                        krediToplam -= dersListesi[i]._kredi;
                        ortalamaToplam -=
                            (dersListesi[i]._kredi * dersListesi[i]._harfNotu);
                        dersListesi.removeAt(i);
                      });
                    },
                    child: Card(
                      color: Colors.grey.shade200,
                      child: ListTile(
                        leading: Icon(
                          Icons.check,
                          size: 30,
                        ),
                        title: Text(dersListesi[i]._dersAdi),
                        subtitle: Text(
                            "Kredi: ${dersListesi[i]._kredi.toInt()}   Harf Notu: ${dersListesi[i]._harfNotu}"),
                        trailing: Icon(
                          Icons.arrow_right,
                          size: 30,
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ),
      ],
    );
  }

  Widget uygulamaYatay() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            padding: EdgeInsets.all(8),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          borderSide: BorderSide(color: Colors.red, width: 2)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          borderSide:
                              BorderSide(color: Colors.purple, width: 2)),
                      hintText: "Ders adını giriniz",
                      labelText: "Ders Adı",
                    ),
                    autovalidate: true,
                    validator: (e) {
                      if (e.length < 2)
                        return "Ders adı en az iki karakter olmalı.";
                    },
                    onChanged: (e) {
                      dersAdi = e;
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6),
                        margin: EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          border: Border.all(color: Colors.purple, width: 2),
                        ),
                        child: DropdownButtonHideUnderline(

                          child: DropdownButton<double>(
                              items: dersKredileri(),
                              value: kredi,
                              onChanged: (e) {
                                setState(() {
                                  kredi = e;
                                });
                              }),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6),
                        margin: EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          border: Border.all(color: Colors.purple, width: 2),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<double>(
                              items: harfNotlari(),
                              value: harfNotu,
                              onChanged: (e) {
                                setState(() {
                                  harfNotu = e;
                                });
                              }),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    color: Colors.blue,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: RichText(
                        text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Ortalama: ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                          ),
                        ),
                        TextSpan(
                          text:
                              "${(ortalamaToplam / (krediToplam == 0 ? 1 : krediToplam)).toStringAsFixed(2)}",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(5),
            child: ListView.builder(
                itemCount: dersListesi.length,
                itemBuilder: (context, i) {
                  sayac++;
                  return Dismissible(
                    direction: DismissDirection.startToEnd,
                    key: Key("$sayac"),
                    onDismissed: (direction) {
                      setState(() {
                        debugPrint(i.toString());
                        krediToplam -= dersListesi[i]._kredi;
                        ortalamaToplam -=
                            (dersListesi[i]._kredi * dersListesi[i]._harfNotu);
                        dersListesi.removeAt(i);
                      });
                    },
                    child: Card(
                      color: Colors.grey.shade200,
                      child: ListTile(
                        leading: Icon(
                          Icons.check,
                          size: 30,
                        ),
                        title: Text(dersListesi[i]._dersAdi),
                        subtitle: Text(
                            "Kredi: ${dersListesi[i]._kredi.toInt()}   Harf Notu: ${dersListesi[i]._harfNotu}"),
                        trailing: Icon(
                          Icons.arrow_right,
                          size: 30,
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ),
      ],
    );
  }

  List<DropdownMenuItem<double>> dersKredileri() {
    return List.generate(10, (i) {
      return DropdownMenuItem<double>(
        child: Text("${i + 1} Kredi"),
        value: (i + 1).toDouble(),
      );
    });
  }

  List<DropdownMenuItem<double>> harfNotlari() {
    return [
      DropdownMenuItem<double>(child: Text("AA"), value: 4),
      DropdownMenuItem<double>(child: Text("BA"), value: 3.5),
      DropdownMenuItem<double>(child: Text("BB"), value: 3),
      DropdownMenuItem<double>(child: Text("CB"), value: 2.5),
      DropdownMenuItem<double>(child: Text("CC"), value: 2),
      DropdownMenuItem<double>(child: Text("DC"), value: 1.5),
      DropdownMenuItem<double>(child: Text("DD"), value: 1),
      DropdownMenuItem<double>(child: Text("FD"), value: 0.5),
      DropdownMenuItem<double>(child: Text("FF"), value: 0),
    ];
  }
}

class Ders {
  String _dersAdi;
  double _kredi, _harfNotu;

  Ders(this._dersAdi, this._kredi, this._harfNotu);
}
