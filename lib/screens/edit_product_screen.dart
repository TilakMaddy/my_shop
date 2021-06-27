import 'package:flutter/material.dart';
import 'package:my_shop/models/Product.dart';
import 'package:my_shop/providers/products.dart';
import 'package:provider/provider.dart';

class EditProductsScreen extends StatefulWidget {
  EditProductsScreen({Key? key}) : super(key: key);

  static const routeName = '/edit-products';

  @override
  _EditProductsScreenState createState() => _EditProductsScreenState();
}

class _EditProductsScreenState extends State<EditProductsScreen> {
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var coming_from = 0; // 0 -> add, 1 -> edit
  var _editedProd = Product(
    id: '',
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );
  var isInit = true;
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  @override
  void dispose() {
    _imageUrlController.dispose();
    super.dispose();
  }

  void _saveForm() {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    Provider.of<Products>(context, listen: false).addProduct(_editedProd);
    Navigator.of(context).pop();
    // print(_editedProd.description);
    // print(_editedProd.imageUrl);
    // print(_editedProd.price);
    // print(_editedProd.title);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInit) {
      final prodId = ModalRoute.of(context)?.settings.arguments;
      if (prodId == null) {
        isInit = false;
        return;
      }

      coming_from = 1;
      _editedProd = Provider.of<Products>(context, listen: false)
          .findById(prodId as String);
      _initValues = {};
      _initValues['title'] = _editedProd.title;
      _initValues['description'] = _editedProd.description;
      _initValues['price'] = _editedProd.price.toString();
      // _initValues['imageUrl'] = _editedProd.imageUrl;
      _imageUrlController.text = _editedProd.imageUrl;
    }
    isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(coming_from == 0 ? 'Add Product' : 'Edit Product'),
        actions: [
          IconButton(
            onPressed: () {
              _saveForm();
            },
            icon: Icon(Icons.save),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _initValues['title'],
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  // return null; => input is correct
                  // return 'U are illegal to this page' => input is correct
                  if (value == null || value.isEmpty) {
                    return 'Please provide a value!';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedProd = Product(
                    description: _editedProd.description,
                    id: '',
                    imageUrl: _editedProd.imageUrl,
                    price: _editedProd.price,
                    title: (value != null) ? value : '',
                  );
                },
              ),
              TextFormField(
                initialValue: _initValues['price'],
                decoration: InputDecoration(
                  labelText: 'Price',
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Please enter a number greater than 0';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedProd = Product(
                    description: _editedProd.description,
                    id: '',
                    imageUrl: _editedProd.imageUrl,
                    price: double.parse(value!),
                    title: _editedProd.title,
                  );
                },
              ),
              TextFormField(
                initialValue: _initValues['description'],
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedProd = Product(
                    description: (value != null) ? value : '',
                    id: '',
                    imageUrl: _editedProd.imageUrl,
                    price: _editedProd.price,
                    title: _editedProd.title,
                  );
                },
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 8, right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: _imageUrlController.text.isEmpty
                        ? Text('Enter a URL')
                        : FittedBox(
                            child: Image.network(
                              _imageUrlController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Image URL',
                      ),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      onEditingComplete: () {
                        setState(() {});
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an image URL';
                        }
                        if (!value.startsWith('http')) {
                          return 'Please enter a valid URL';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProd = Product(
                          description: _editedProd.description,
                          id: '',
                          imageUrl: (value != null) ? value : '',
                          price: _editedProd.price,
                          title: _editedProd.title,
                        );
                      },
                    ),
                  )
                ],
              ),
              Container(
                padding: EdgeInsets.only(top: 30),
                child: Row(children: [
                  Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      _saveForm();
                    },
                    child: Text('Save'),
                  ),
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
