import 'package:etrade/db/dbHelper.dart';
import 'package:etrade/models/product.dart';
import 'package:etrade/screens/productAdd.dart';
import 'package:etrade/screens/productDetail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ProductListState();
}

class ProductListState extends State {
  DbHelper dbHelper = new DbHelper();
  List<Product> products;
  int count = 0;
  @override
  Widget build(BuildContext context) {
    if (products == null) {
      products = new List<Product>();
      getData();
    //insertData();
    }
    return Scaffold(
      body: productListItem(),
      // yuvarlak button
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          gotoProductAdd();
        },
        tooltip: "yeni ürün ekle",
        child: Icon(Icons.add),
      ),
    );
  }

  ListView productListItem() {
    return ListView.builder(
      // itemCount kaç kere döneceğini belirtir
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.amberAccent,
          elevation: 2.0, //büyüklük
          child: ListTile(
            // gmail'deki yuvarlak icon
            leading: CircleAvatar(
              backgroundColor: Colors.green,
              child: Text(
                "A",
                textDirection: TextDirection.ltr,
              ),
            ),
            title: Text(this.products[position].name),
            subtitle: Text(this.products[position].description),
            // elemana tıklandığı zaman detail sayfasına git
            onTap: () {
              // bu fonksiyon sayfa yönlendirmesi yapar
              // parametre olarak gönderilecek veriyi vermelisin
              gotoDetail(this.products[position]);
            },
          ),
        );
      },
    );
  }

  void getData() {
    var dbFuture = dbHelper.initializeDb();
    dbFuture.then((result) {
      var productsFuture = dbHelper.getProducts();
      productsFuture.then((data) {
        List<Product> productData = new List<Product>();
        count = data.length;
        for (var item in data) {
          productData.add(Product.fromObject(item));
        }
        setState(() {
          products = productData;
          count = count;
        });
      });
    });
  }

  insertData() {
    var dbFuture = dbHelper.initializeDb();
    dbFuture.then((result) {
      Product product = new Product("1", "aa bilgisayarı", 80.0);
      dbHelper.insert(product);
    });
  }

  void gotoDetail(Product product) async {
    // bir sayfadan diğerine gitmek için push
    // geri gelmek için pop kullanılır
    bool result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => ProductDetail(product)));
        if (result==true) {
          // true ise veri silinmiş veya güncellenmiş olabilir. sayfayı tekrar yükle
         getData(); 
        }
  }

  void gotoProductAdd() async{
    bool result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => ProductAdd()));
        if (result==true) {
          // true ise veri silinmiş veya güncellenmiş olabilir. sayfayı tekrar yükle
         getData(); 
        }
  }
}
