import 'package:etrade/db/dbHelper.dart';
import 'package:etrade/models/product.dart';
import 'package:etrade/screens/productUpdate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductDetail extends StatefulWidget {
  Product product;
  ProductDetail(this.product);

  @override
  State<StatefulWidget> createState() => ProductDetailState(product);
}
DbHelper dbHelper = new DbHelper();
enum Choice { Delete, Update }

class ProductDetailState extends State {
  Product product;
  ProductDetailState(this.product);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ürün Detayı | ${product.name}",
          textDirection: TextDirection.ltr,
        ),
        actions: <Widget>[
          PopupMenuButton<Choice>(
            onSelected: select,
            itemBuilder: (BuildContext context) => <PopupMenuEntry<Choice>>[
                  PopupMenuItem<Choice>(
                    // tıklandığında ne olacak
                    value: Choice.Delete,
                    child: Text("Delete"),
                  ),
                  PopupMenuItem<Choice>(
                    // tıklandığında ne olacak
                    value: Choice.Update,
                    child: Text("Update"),
                  )
                ],
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Center(
          child: Container(
            child: Column(
              children: <Widget>[
                // rehber listeleme
                ListTile(
                  // sol taraf
                  leading: Icon(Icons.shop),
                  title: Text("${product.id}"),
                  subtitle: Text(product.description),
                ),
                Text("${product.price}"),
                ButtonTheme.bar(
                  child: ButtonBar(
                    children: <Widget>[
                      FlatButton(
                        child: Text("sepete ekle"),
                        onPressed: () {
                          AlertDialog alertDialog = new AlertDialog(
                            title: Text("Başarılı"),
                            content: Text("${product.name} sepete eklendi"),
                          );
                          showDialog(
                              context: context, builder: (_) => alertDialog);
                        },
                      ),
                      FlatButton(
                        child: Text("sepetten çıkar"),
                        onPressed: () {},
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  void select(Choice choice) async{
    int result; 
    switch (choice) {
      case Choice.Delete:
       result= await dbHelper.delete(product.id);
        Navigator.pop(context,true);
        if (result!=0) {
          AlertDialog alertDialog = new AlertDialog(
                title: Text("Başarılı"),
                content: Text("${product.name} silindi"),
              );
              showDialog(context: context, builder: (_) => alertDialog);
        }
        else{
          AlertDialog alertDialog = new AlertDialog(
                title: Text("Başarılı"),
                content: Text("${product.name} silinemedi"),
              );
              showDialog(context: context, builder: (_) => alertDialog);
        }
        break;
        case Choice.Update:
         bool result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => ProductUpdate(product)));
        if (result==true) {
          Navigator.pop(context, true);
        }
        break;
      default:
    }
  }
}
