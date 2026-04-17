// import 'dart:developer';
// import 'dart:io';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// // import 'package:grocery_app_dashboard/features/dash_bord/presentation/widgets/custom_text.dart';
// import 'package:iconly/iconly.dart';
// import 'package:image_picker/image_picker.dart';

// import '../../core/helper/functions/global_methods.dart';
// import '../../core/utils/utils.dart';
// import '../dash_bord/presentation/widgets/buttons.dart';

// import 'package:firebase/firebase.dart' as fb;

// class EditProductView extends StatefulWidget {
//   const EditProductView({
//     super.key,
//     // required this.id,
//     // required this.title,
//     // required this.price,
//     // required this.salePrice,
//     // required this.productCat,
//     // required this.imageUrl,
//     // required this.isOnSale,
//     // required this.isPiece
//   });
//   static const String routeName = '/edit-product-screen';
//   // final String id, title, price, productCat, imageUrl;
//   // final bool isPiece, isOnSale;
//   // final double salePrice;
//   @override
//   _EditProductViewState createState() => _EditProductViewState();
// }

// class _EditProductViewState extends State<EditProductView> {
//   final _formKey = GlobalKey<FormState>();
//   // Title and price controllers
//   //late final TextEditingController _titleController, _priceController;
//   // Category
//   // late String _catValue;
//   // Sale
//   // String? _salePercent;
//   // late String percToShow;
//   // late double _salePrice;
//   // late bool _isOnSale;
//   // Image
//   // File? _pickedImage;
//   // Uint8List webImage = Uint8List(10);
//   // late String _imageUrl;
//   // kg or Piece,
//   // late int val;
//   // late bool _isPiece;
//   // while loading
//   // // bool _isLoading = false;
//   @override
//   void initState() {
//     //  _titleController = TextEditingController();
//     // set the price and title initial values and initialize the controllers
//     // _priceController = TextEditingController(text: widget.price);
//     // _titleController = TextEditingController(text: widget.title);
//     // // Set the variables
//     // _salePrice = widget.salePrice;
//     // _catValue = widget.productCat;
//     // _isOnSale = widget.isOnSale;
//     // _isPiece = widget.isPiece;
//     // val = _isPiece ? 2 : 1;
//     // _imageUrl = widget.imageUrl;
//     // // Calculate the percentage
//     // percToShow = (100 -
//     //             (_salePrice * 100) /
//     //                 double.parse(
//     //                     widget.price)) // WIll be the price instead of 1.88
//     //         .round()
//     //         .toStringAsFixed(1) +
//     //     '%';
//     super.initState();
//   }

//   @override
//   void dispose() {
//     // Dispose the controllers
//     // _priceController.dispose();
//     // _titleController.dispose();
//     super.dispose();
//   }

//   void _updateProduct() async {
//     // final isValid = _formKey.currentState!.validate();
//     // FocusScope.of(context).unfocus();

//     // if (isValid) {
//     //   _formKey.currentState!.save();

//     //   try {
//     //     Uri? imageUri;
//     //     setState(() {
//     //       _isLoading = true;
//     //     });
//     //     if (_pickedImage != null) {
//     //       fb.StorageReference storageRef = fb
//     //           .storage()
//     //           .ref()
//     //           .child('productsImages')
//     //           .child(widget.id + 'jpg');
//     //       final fb.UploadTaskSnapshot uploadTaskSnapshot =
//     //           await storageRef.put(kIsWeb ? webImage : _pickedImage).future;
//     //       imageUri = await uploadTaskSnapshot.ref.getDownloadURL();
//     //     }
//     //     await FirebaseFirestore.instance
//     //         .collection('products')
//     //         .doc(widget.id)
//     //         .update({
//     //       'title': _titleController.text,
//     //       'price': _priceController.text,
//     //       'salePrice': _salePrice,
//     //       'imageUrl':
//     //           _pickedImage == null ? widget.imageUrl : imageUri.toString(),
//     //       'productCategoryName': _catValue,
//     //       'isOnSale': _isOnSale,
//     //       'isPiece': _isPiece,
//     //     });
//     //     await Fluttertoast.showToast(
//     //       msg: "Product has been updated",
//     //       toastLength: Toast.LENGTH_LONG,
//     //       gravity: ToastGravity.CENTER,
//     //       timeInSecForIosWeb: 1,
//     //     );
//     //   } on FirebaseException catch (error) {
//     //     GlobalMethods.errorDialog(
//     //         subtitle: '${error.message}', context: context);
//     //     setState(() {
//     //       _isLoading = false;
//     //     });
//     //   } catch (error) {
//     //     GlobalMethods.errorDialog(subtitle: '$error', context: context);
//     //     setState(() {
//     //       _isLoading = false;
//     //     });
//     //   } finally {
//     //     setState(() {
//     //       _isLoading = false;
//     //     });
//     //   }
//     // }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // final theme = Utils(context).getTheme;
//     // final color = theme == true ? Colors.white : Colors.black;
//     // final _scaffoldColor = Theme.of(context).scaffoldBackgroundColor;
//     Size size = Utils(context).getScreenSize;

//     var inputDecoration = InputDecoration(
//       filled: true,
//       // fillColor: _scaffoldColor,
//       border: InputBorder.none,
//       focusedBorder: OutlineInputBorder(
//         borderSide: BorderSide(
//           // color: color,
//           width: 1.0,
//         ),
//       ),
//     );
//     return Scaffold(
//       // key: context.read<MenuController>().getEditProductscaffoldKey,
//       // drawer: const SideMenu(),
//       body: SingleChildScrollView(
//         child: Center(
//           child: Column(
//             children: [
//               // Header(
//               //   showTexField: false,
//               //   fct: () {
//               //     context
//               //         .read<MenuController>()
//               //         .controlEditProductsMenu();
//               //   },
//               //   title: 'Edit this product',
//               // ),
//               Container(
//                 width: size.width > 650 ? 650 : size.width,
//                 color: Theme.of(context).cardColor,
//                 padding: const EdgeInsets.all(16),
//                 margin: const EdgeInsets.all(16),
//                 child: EditProductViewBodyForm(),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   DropdownButtonHideUnderline salePourcentageDropDownWidget(Color color) {
//     return DropdownButtonHideUnderline(
//       child: DropdownButton<String>(
//         style: TextStyle(color: color),
//         items: const [
//           DropdownMenuItem<String>(child: Text('10%'), value: '10'),
//           DropdownMenuItem<String>(child: Text('15%'), value: '15'),
//           DropdownMenuItem<String>(child: Text('25%'), value: '25'),
//           DropdownMenuItem<String>(child: Text('50%'), value: '50'),
//           DropdownMenuItem<String>(child: Text('75%'), value: '75'),
//           DropdownMenuItem<String>(child: Text('0%'), value: '0'),
//         ],
//         onChanged: (value) {
//           // if (value == '0') {
//           //   return;
//           // } else {
//           //   setState(() {
//           //     _salePercent = value;
//           //     _salePrice = double.parse(widget.price) -
//           //         (double.parse(value!) * double.parse(widget.price) / 100);
//           //   });
//           // }
//         },
//         // hint: Text(_salePercent ?? percToShow),
//         // value: _salePercent,
//       ),
//     );
//   }

//   //   DropdownButtonHideUnderline catDropDownWidget() {
//   //     return DropdownButtonHideUnderline(
//   //       child: DropdownButton<String>(
//   //         style: TextStyle(),
//   //         items: const [
//   //           DropdownMenuItem<String>(
//   //             child: Text('Vegetables'),
//   //             value: 'Vegetables',
//   //           ),
//   //           DropdownMenuItem<String>(child: Text('Fruits'), value: 'Fruits'),
//   //           DropdownMenuItem<String>(child: Text('Grains'), value: 'Grains'),
//   //           DropdownMenuItem<String>(child: Text('Nuts'), value: 'Nuts'),
//   //           DropdownMenuItem<String>(child: Text('Herbs'), value: 'Herbs'),
//   //           DropdownMenuItem<String>(child: Text('Spices'), value: 'Spices'),
//   //         ],
//   //         onChanged: (value) {
//   //           setState(() {
//   //             //_catValue = value!;
//   //           });
//   //         },
//   //         hint: const Text('Select a Category'),
//   //         // value: "",
//   //         // value: _catValue,
//   //       ),
//   //     );
//   //   }

//   //   Future<void> _pickImage() async {
//   //     // MOBILE
//   //     if (!kIsWeb) {
//   //       final ImagePicker _picker = ImagePicker();
//   //       XFile? image = await _picker.pickImage(source: ImageSource.gallery);

//   //       if (image != null) {
//   //         var selected = File(image.path);

//   //         setState(() {
//   //           //  _pickedImage = selected;
//   //         });
//   //       } else {
//   //         log('No file selected');
//   //         // showToast("No file selected");
//   //       }
//   //     }
//   //     // WEB
//   //     else if (kIsWeb) {
//   //       final ImagePicker _picker = ImagePicker();
//   //       XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//   //       if (image != null) {
//   //         var f = await image.readAsBytes();
//   //         setState(() {
//   //           // _pickedImage = File("a");
//   //           // webImage = f;
//   //         });
//   //       } else {
//   //         log('No file selected');
//   //       }
//   //     } else {
//   //       log('Perm not granted');
//   //     }
//   //   }
//   // }

//   // class EditProductView extends StatefulWidget {
//   //   const EditProductView({super.key});
//   //   static const String routeName = '/edit-product-screen';

//   //   @override
//   //   State<EditProductView> createState() => _EditProductViewState();
//   // }

//   // class _EditProductViewState extends State<EditProductView> {
//   //   final _formKey = GlobalKey<FormState>();

//   //   // Controllers
//   //   final _titleController = TextEditingController();
//   //   final _priceController = TextEditingController();

//   //   // States
//   //   String? _catValue;
//   //   bool _isPiece = false;
//   //   bool _isOnSale = false;
//   //   double? _salePrice;
//   //   File? _pickedImage;
//   //   Uint8List? _webImage;

//   //   @override
//   //   void dispose() {
//   //     _titleController.dispose();
//   //     _priceController.dispose();
//   //     super.dispose();
//   //   }

//   //   void _updateProduct() {
//   //     if (!_formKey.currentState!.validate()) return;

//   //     log("Title: ${_titleController.text}");
//   //     log("Price: ${_priceController.text}");
//   //     log("Category: $_catValue");
//   //     log("Unit: ${_isPiece ? "Piece" : "Kg"}");
//   //     log("OnSale: $_isOnSale");
//   //     log("SalePrice: $_salePrice");
//   //     log("Image selected: ${_pickedImage != null || _webImage != null}");
//   //   }

//   //   @override
//   //   Widget build(BuildContext context) {
//   //     final size = MediaQuery.of(context).size;

//   //     final inputDecoration = InputDecoration(
//   //       filled: true,
//   //       border: InputBorder.none,
//   //       focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.0)),
//   //     );

//   //     return Scaffold(
//   //       appBar: AppBar(title: const Text("Edit Product")),
//   //       body: SingleChildScrollView(
//   //         child: Center(
//   //           child: Container(
//   //             width: size.width > 650 ? 650 : size.width,
//   //             padding: const EdgeInsets.all(16),
//   //             margin: const EdgeInsets.all(16),
//   //             color: Theme.of(context).cardColor,
//   //             child: Form(
//   //               key: _formKey,
//   //               child: Column(
//   //                 crossAxisAlignment: CrossAxisAlignment.start,
//   //                 children: [
//   //                   // Title
//   //                   const Text(
//   //                     "Product title*",
//   //                     style: TextStyle(fontWeight: FontWeight.bold),
//   //                   ),
//   //                   const SizedBox(height: 10),
//   //                   TextFormField(
//   //                     controller: _titleController,
//   //                     validator: (value) =>
//   //                         value!.isEmpty ? "Enter a title" : null,
//   //                     decoration: inputDecoration,
//   //                   ),
//   //                   const SizedBox(height: 20),

//   //                   // Price
//   //                   const Text(
//   //                     "Price in \$*",
//   //                     style: TextStyle(fontWeight: FontWeight.bold),
//   //                   ),
//   //                   const SizedBox(height: 10),
//   //                   TextFormField(
//   //                     controller: _priceController,
//   //                     keyboardType: TextInputType.number,
//   //                     validator: (value) => value!.isEmpty ? "Enter price" : null,
//   //                     decoration: inputDecoration,
//   //                   ),
//   //                   const SizedBox(height: 20),

//   //                   // Category
//   //                   const Text(
//   //                     "Product category*",
//   //                     style: TextStyle(fontWeight: FontWeight.bold),
//   //                   ),
//   //                   const SizedBox(height: 10),
//   //                   DropdownButtonFormField<String>(
//   //                     value: _catValue,
//   //                     items: const [
//   //                       DropdownMenuItem(
//   //                         value: "Vegetables",
//   //                         child: Text("Vegetables"),
//   //                       ),
//   //                       DropdownMenuItem(value: "Fruits", child: Text("Fruits")),
//   //                       DropdownMenuItem(value: "Grains", child: Text("Grains")),
//   //                     ],
//   //                     onChanged: (val) => setState(() => _catValue = val),
//   //                     validator: (value) =>
//   //                         value == null ? "Select a category" : null,
//   //                   ),
//   //                   const SizedBox(height: 20),

//   //                   // Unit
//   //                   const Text(
//   //                     "Measure unit*",
//   //                     style: TextStyle(fontWeight: FontWeight.bold),
//   //                   ),
//   //                   Row(
//   //                     children: [
//   //                       Radio(
//   //                         value: false,
//   //                         groupValue: _isPiece,
//   //                         onChanged: (val) => setState(() => _isPiece = val!),
//   //                       ),
//   //                       const Text("Kg"),
//   //                       Radio(
//   //                         value: true,
//   //                         groupValue: _isPiece,
//   //                         onChanged: (val) => setState(() => _isPiece = val!),
//   //                       ),
//   //                       const Text("Piece"),
//   //                     ],
//   //                   ),

//   //                   // Sale
//   //                   Row(
//   //                     children: [
//   //                       Checkbox(
//   //                         value: _isOnSale,
//   //                         onChanged: (val) => setState(() => _isOnSale = val!),
//   //                       ),
//   //                       const Text("On Sale"),
//   //                     ],
//   //                   ),
//   //                   if (_isOnSale)
//   //                     TextFormField(
//   //                       initialValue: _salePrice?.toString(),
//   //                       keyboardType: TextInputType.number,
//   //                       decoration: const InputDecoration(
//   //                         labelText: "Sale Price",
//   //                       ),
//   //                       onChanged: (val) => _salePrice = double.tryParse(val),
//   //                     ),

//   //                   const SizedBox(height: 20),

//   //                   // Image
//   //                   _pickedImage != null
//   //                       ? Image.file(_pickedImage!, height: 150)
//   //                       : _webImage != null
//   //                       ? Image.memory(_webImage!, height: 150)
//   //                       : const Placeholder(fallbackHeight: 150),
//   //                   TextButton(
//   //                     onPressed: _pickImage,
//   //                     child: const Text("Pick Image"),
//   //                   ),

//   //                   const SizedBox(height: 30),

//   //                   // Buttons
//   //                   Row(
//   //                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//   //                     children: [
//   //                       ElevatedButton.icon(
//   //                         onPressed: () => log("Delete pressed"),
//   //                         icon: const Icon(Icons.delete),
//   //                         label: const Text("Delete"),
//   //                         style: ElevatedButton.styleFrom(
//   //                           backgroundColor: Colors.red,
//   //                         ),
//   //                       ),
//   //                       ElevatedButton.icon(
//   //                         onPressed: _updateProduct,
//   //                         icon: const Icon(Icons.save),
//   //                         label: const Text("Update"),
//   //                       ),
//   //                     ],
//   //                   ),
//   //                 ],
//   //               ),
//   //             ),
//   //           ),
//   //         ),
//   //       ),
//   //     );
//   //   }

//   //   Future<void> _pickImage() async {
//   //     final ImagePicker picker = ImagePicker();
//   //     final image = await picker.pickImage(source: ImageSource.gallery);

//   //     if (image == null) return;

//   //     if (kIsWeb) {
//   //       final bytes = await image.readAsBytes();
//   //       setState(() => _webImage = bytes);
//   //     } else {
//   //       setState(() => _pickedImage = File(image.path));
//   //     }
//   //   }
//   // }
// }
