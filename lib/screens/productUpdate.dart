import 'package:etrade/db/dbHelper.dart';
import 'package:etrade/models/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class ProductUpdate extends StatefulWidget {
  Product product;
  ProductUpdate(this.product);
  @override
  State<StatefulWidget> createState() => ProductUpdateState(product);
}

class ProductUpdateState extends State {
  Product product;
  ProductUpdateState(this.product);
  DbHelper dbHelper = new DbHelper();
  // textfield alanlarına yazılanlar buraya gelir
  TextEditingController txtName = new TextEditingController();
  TextEditingController txtDescription = new TextEditingController();
  TextEditingController txtPrice = new TextEditingController();
  int _id = 0;
  @override
  Widget build(BuildContext context) {
    txtSetValue(product.name, product.description, product.price.toString(),
        product.id);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ürün Düzenle",
          textDirection: TextDirection.ltr,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(13.0),
        child: Container(
          child: Column(
            children: <Widget>[
              Text(
                "Yeni Ürün Ekle",
                textDirection: TextDirection.ltr,
              ),
              TextField(
                controller: txtName,
                decoration: InputDecoration(labelText: "Ürün Adı"),
              ),
              TextField(
                controller: txtDescription,
                decoration: InputDecoration(labelText: "Ürün Açıklama"),
              ),
              TextField(
                controller: txtPrice,
                decoration: InputDecoration(labelText: "Ürün Fiyatı"),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          update();
        },
        tooltip: "ürün düzenle",
        child: Icon(Icons.update),
      ),
    );
  }

  void txtSetValue(String name, String description, String price, int id) {
    setState(() {
      txtName.text = name;
      txtDescription.text = description;
      txtPrice.text = price;
      _id = id;
    });
  }

  void update() async {
    double price = double.tryParse(txtPrice.text);
    if (price != null) {
      Product product = new Product.withId(
          _id, txtName.text, txtDescription.text, double.parse(txtPrice.text));
      var result = await dbHelper.update(product);
      if (result != null) {
        await Navigator.push(
        context, MaterialPageRoute(builder: (context) => MyHomePage()));
        AlertDialog alertDialog = new AlertDialog(
          title: Text("Başarılı"),
          content: Text("${txtName.text} eklendi"),
        );
        showDialog(context: context, builder: (_) => alertDialog);
      }
    }
  }
}
