import 'package:etrade/db/dbHelper.dart';
import 'package:etrade/models/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductAdd extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ProductAddState();
}

class ProductAddState extends State {
  // dbHelper
  DbHelper dbHelper = new DbHelper();

  // textfield alanlarına yazılanlar buraya gelir
  TextEditingController txtName = new TextEditingController();
  TextEditingController txtDescription = new TextEditingController();
  TextEditingController txtPrice = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Yeni Ürün Ekle",
          textDirection: TextDirection.ltr,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(13.0),
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
                keyboardType: TextInputType.number),
            FlatButton(
              child: Text("Ekle"),
              onPressed: () {
                insertProduct();
              },
            )
          ],
        ),
      ),
    );
  }

  void insertProduct() async {
    double price = double.tryParse(txtPrice.text);
    if ( price!=null) {
      Product product = new Product(
          txtName.text, txtDescription.text, double.parse(txtPrice.text));
      var result = await dbHelper.insert(product);
      if (result != 0) {
        Navigator.pop(context, true);
        AlertDialog alertDialog = new AlertDialog(
          title: Text("Başarılı"),
          content: Text("${txtName.text} eklendi"),
        );
        showDialog(context: context, builder: (_) => alertDialog);
      }
    } else {
      AlertDialog alertDialog = new AlertDialog(
        title: Text("Üzgünüm Bir sorun oluştu"),
        content: Text("Ürün fiyatı sıfırdan büyük olmalıdır"),
      );
      showDialog(context: context, builder: (_) => alertDialog);
    }
  }
}
