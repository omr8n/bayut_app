// // // // // // // import 'dart:io';
// // // // // // // import 'dart:typed_data';

// // // // // // // import 'package:dotted_border/dotted_border.dart';
// // // // // // // import 'package:flutter/foundation.dart';
// // // // // // // import 'package:flutter/material.dart';
// // // // // // // import 'package:flutter/services.dart';
// // // // // // // import 'package:grocery_app_dashboard/core/constants/app_constants.dart';
// // // // // // // import 'package:grocery_app_dashboard/core/utils/utils.dart';
// // // // // // // import 'package:grocery_app_dashboard/features/dash_bord/presentation/widgets/buttons.dart';
// // // // // // // import 'package:grocery_app_dashboard/features/dash_bord/presentation/widgets/custom_text.dart';
// // // // // // // import 'package:grocery_app_dashboard/features/dash_bord/presentation/widgets/custom_text_form_field.dart';
// // // // // // // import 'package:iconly/iconly.dart';
// // // // // // // import 'package:image_picker/image_picker.dart';

// // // // // // // class AddProductViewForm extends StatefulWidget {
// // // // // // //   const AddProductViewForm({super.key});

// // // // // // //   @override
// // // // // // //   State<AddProductViewForm> createState() => _AddProductViewFormState();
// // // // // // // }

// // // // // // // class _AddProductViewFormState extends State<AddProductViewForm> {
// // // // // // //   final _formKey = GlobalKey<FormState>();
// // // // // // //   String? _catValue = 'Vegetables';
// // // // // // //   late final TextEditingController _titleController, _priceController;
// // // // // // //   int _groupValue = 1;
// // // // // // //   bool isPiece = false;
// // // // // // //   XFile? _pickedImage;
// // // // // // //   Uint8List webImage = Uint8List(8);
// // // // // // //   @override
// // // // // // //   void initState() {
// // // // // // //     _priceController = TextEditingController();
// // // // // // //     _titleController = TextEditingController();

// // // // // // //     super.initState();
// // // // // // //   }

// // // // // // //   @override
// // // // // // //   void dispose() {
// // // // // // //     if (mounted) {
// // // // // // //       _priceController.dispose();
// // // // // // //       _titleController.dispose();
// // // // // // //     }
// // // // // // //     super.dispose();
// // // // // // //   }

// // // // // // //   //  bool _isLoading = false;
// // // // // // //   void _uploadForm() async {
// // // // // // //     // final isValid = _formKey.currentState!.validate();
// // // // // // //     // FocusScope.of(context).unfocus();

// // // // // // //     // if (isValid) {
// // // // // // //     //   _formKey.currentState!.save();
// // // // // // //     //   if (_pickedImage == null) {
// // // // // // //     //     GlobalMethods.errorDialog(
// // // // // // //     //         subtitle: 'Please pick up an image', context: context);
// // // // // // //     //     return;
// // // // // // //     //   }
// // // // // // //     //   final _uuid = const Uuid().v4();
// // // // // // //     //   try {
// // // // // // //     //     setState(() {
// // // // // // //     //       _isLoading = true;
// // // // // // //     //     });
// // // // // // //     //     fb.StorageReference storageRef =
// // // // // // //     //         fb.storage().ref().child('productsImages').child(_uuid + 'jpg');
// // // // // // //     //     final fb.UploadTaskSnapshot uploadTaskSnapshot =
// // // // // // //     //         await storageRef.put(kIsWeb ? webImage : _pickedImage).future;
// // // // // // //     //     Uri imageUri = await uploadTaskSnapshot.ref.getDownloadURL();
// // // // // // //     //     await FirebaseFirestore.instance.collection('products').doc(_uuid).set({
// // // // // // //     //       'id': _uuid,
// // // // // // //     //       'title': _titleController.text,
// // // // // // //     //       'price': _priceController.text,
// // // // // // //     //       'salePrice': 0.1,
// // // // // // //     //       'imageUrl': imageUri.toString(),
// // // // // // //     //       'productCategoryName': _catValue,
// // // // // // //     //       'isOnSale': false,
// // // // // // //     //       'isPiece': isPiece,
// // // // // // //     //       'createdAt': Timestamp.now(),
// // // // // // //     //     });
// // // // // // //     //     _clearForm();
// // // // // // //     //     Fluttertoast.showToast(
// // // // // // //     //       msg: "Product uploaded succefully",
// // // // // // //     //       toastLength: Toast.LENGTH_LONG,
// // // // // // //     //       gravity: ToastGravity.CENTER,
// // // // // // //     //       timeInSecForIosWeb: 1,
// // // // // // //     //       // backgroundColor: ,
// // // // // // //     //       // textColor: ,
// // // // // // //     //       // fontSize: 16.0
// // // // // // //     //     );
// // // // // // //     //   } on FirebaseException catch (error) {
// // // // // // //     //     GlobalMethods.errorDialog(
// // // // // // //     //         subtitle: '${error.message}', context: context);
// // // // // // //     //     setState(() {
// // // // // // //     //       _isLoading = false;
// // // // // // //     //     });
// // // // // // //     //   } catch (error) {
// // // // // // //     //     GlobalMethods.errorDialog(subtitle: '$error', context: context);
// // // // // // //     //     setState(() {
// // // // // // //     //       _isLoading = false;
// // // // // // //     //     });
// // // // // // //     //   } finally {
// // // // // // //     //     setState(() {
// // // // // // //     //       _isLoading = false;
// // // // // // //     //     });
// // // // // // //     //   }
// // // // // // //     // }
// // // // // // //   }
// // // // // // //   void _onCategoryChanged(String? category) {
// // // // // // //     setState(() {
// // // // // // //       _catValue = category;
// // // // // // //     });
// // // // // // //   }

// // // // // // //   void _clearForm() {
// // // // // // //     isPiece = false;
// // // // // // //     _groupValue = 1;
// // // // // // //     _priceController.clear();
// // // // // // //     _titleController.clear();
// // // // // // //     setState(() {
// // // // // // //       _pickedImage = null;
// // // // // // //       webImage = Uint8List(8);
// // // // // // //     });
// // // // // // //   }

// // // // // // //   @override
// // // // // // //   Widget build(BuildContext context) {
// // // // // // //     Size size = Utils(context).getScreenSize;

// // // // // // //     return Form(
// // // // // // //       key: _formKey,
// // // // // // //       child: Column(
// // // // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // //         mainAxisAlignment: MainAxisAlignment.start,
// // // // // // //         mainAxisSize: MainAxisSize.min,
// // // // // // //         children: <Widget>[
// // // // // // //           CustomText(
// // // // // // //             text: 'Product title*',
// // // // // // //             // color: color,
// // // // // // //             isTitle: true,
// // // // // // //           ),
// // // // // // //           const SizedBox(height: 10),
// // // // // // //           CustomTextFormField(
// // // // // // //             controller: _titleController,
// // // // // // //             key: const ValueKey('Title'),
// // // // // // //             validator: (value) {
// // // // // // //               if (value!.isEmpty) {
// // // // // // //                 return 'Please enter a Title';
// // // // // // //               }
// // // // // // //               return null;
// // // // // // //             },
// // // // // // //           ),
// // // // // // //           const SizedBox(height: 20),
// // // // // // //           Row(
// // // // // // //             children: [
// // // // // // //               Expanded(
// // // // // // //                 flex: 2,
// // // // // // //                 child: FittedBox(
// // // // // // //                   child: Column(
// // // // // // //                     crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // //                     mainAxisAlignment: MainAxisAlignment.start,
// // // // // // //                     children: [
// // // // // // //                       CustomText(
// // // // // // //                         text: 'Price in \$*',
// // // // // // //                         //      color: color,
// // // // // // //                         isTitle: true,
// // // // // // //                       ),
// // // // // // //                       const SizedBox(height: 10),
// // // // // // //                       SizedBox(
// // // // // // //                         width: 100,
// // // // // // //                         child: CustomTextFormField(
// // // // // // //                           controller: _priceController,
// // // // // // //                           key: const ValueKey('Price \$'),
// // // // // // //                           keyboardType: TextInputType.number,
// // // // // // //                           validator: (value) {
// // // // // // //                             if (value!.isEmpty) {
// // // // // // //                               return 'Price is missed';
// // // // // // //                             }
// // // // // // //                             return null;
// // // // // // //                           },
// // // // // // //                           inputFormatters: <TextInputFormatter>[
// // // // // // //                             FilteringTextInputFormatter.allow(
// // // // // // //                               RegExp(r'[0-9.]'),
// // // // // // //                             ),
// // // // // // //                           ],
// // // // // // //                         ),
// // // // // // //                       ),
// // // // // // //                       const SizedBox(height: 20),
// // // // // // //                       CustomText(
// // // // // // //                         text: 'Porduct category*',
// // // // // // //                         // color: color,
// // // // // // //                         isTitle: true,
// // // // // // //                       ),
// // // // // // //                       const SizedBox(height: 10),

// // // // // // //                       // Drop down menu code here
// // // // // // //                       DropdownButton<String>(
// // // // // // //                         hint: const Text('Select Category'),
// // // // // // //                         value: _catValue,
// // // // // // //                         items: AppConstants.categoryDropDownList,
// // // // // // //                         onChanged: _onCategoryChanged,
// // // // // // //                       ),
// // // // // // //                       // _categoryDropDown(),
// // // // // // //                       const SizedBox(height: 20),
// // // // // // //                       CustomText(
// // // // // // //                         text: 'Measure unit*',
// // // // // // //                         // color: color,
// // // // // // //                         isTitle: true,
// // // // // // //                       ),
// // // // // // //                       const SizedBox(height: 10),
// // // // // // //                       // Radio button code here
// // // // // // //                       Row(
// // // // // // //                         children: [
// // // // // // //                           CustomText(
// // // // // // //                             text: 'KG',
// // // // // // //                             // color: color,
// // // // // // //                           ),
// // // // // // //                           Radio(
// // // // // // //                             value: 1,
// // // // // // //                             groupValue: _groupValue,
// // // // // // //                             onChanged: (valuee) {
// // // // // // //                               setState(() {
// // // // // // //                                 _groupValue = 1;
// // // // // // //                                 isPiece = false;
// // // // // // //                               });
// // // // // // //                             },
// // // // // // //                             activeColor: Colors.green,
// // // // // // //                           ),
// // // // // // //                           CustomText(
// // // // // // //                             text: 'Piece',
// // // // // // //                             // color: color,
// // // // // // //                           ),
// // // // // // //                           Radio(
// // // // // // //                             value: 2,

// // // // // // //                             groupValue: _groupValue,
// // // // // // //                             onChanged: (valuee) {
// // // // // // //                               setState(() {
// // // // // // //                                 _groupValue = 2;
// // // // // // //                                 isPiece = true;
// // // // // // //                               });
// // // // // // //                             },
// // // // // // //                             activeColor: Colors.green,
// // // // // // //                           ),
// // // // // // //                         ],
// // // // // // //                       ),
// // // // // // //                     ],
// // // // // // //                   ),
// // // // // // //                 ),
// // // // // // //               ),
// // // // // // //               // Image to be picked code is here
// // // // // // //               Expanded(
// // // // // // //                 flex: 4,
// // // // // // //                 child: Padding(
// // // // // // //                   padding: const EdgeInsets.all(8.0),
// // // // // // //                   child: Container(
// // // // // // //                     height: size.width > 650 ? 350 : size.width * 0.45,
// // // // // // //                     decoration: BoxDecoration(
// // // // // // //                       color: Theme.of(context).scaffoldBackgroundColor,
// // // // // // //                       borderRadius: BorderRadius.circular(12.0),
// // // // // // //                     ),
// // // // // // //                     child: _pickedImage == null
// // // // // // //                         ? dottedBorder(color: Theme.of(context).primaryColor)
// // // // // // //                         : ClipRRect(
// // // // // // //                             borderRadius: BorderRadius.circular(12),
// // // // // // //                             child: kIsWeb
// // // // // // //                                 ? Image.memory(webImage, fit: BoxFit.fill)
// // // // // // //                                 : Image.file(_pickedImage!, fit: BoxFit.fill),
// // // // // // //                           ),
// // // // // // //                   ),
// // // // // // //                 ),
// // // // // // //               ),
// // // // // // //               Expanded(
// // // // // // //                 flex: 1,
// // // // // // //                 child: FittedBox(
// // // // // // //                   child: Column(
// // // // // // //                     children: [
// // // // // // //                       TextButton(
// // // // // // //                         onPressed: () {
// // // // // // //                           setState(() {
// // // // // // //                             _pickedImage = null;
// // // // // // //                             webImage = Uint8List(8);
// // // // // // //                           });
// // // // // // //                         },
// // // // // // //                         child: CustomText(text: 'Clear', color: Colors.red),
// // // // // // //                       ),
// // // // // // //                       TextButton(
// // // // // // //                         onPressed: () {},
// // // // // // //                         child: CustomText(
// // // // // // //                           text: 'Update image',
// // // // // // //                           color: Colors.blue,
// // // // // // //                         ),
// // // // // // //                       ),
// // // // // // //                     ],
// // // // // // //                   ),
// // // // // // //                 ),
// // // // // // //               ),
// // // // // // //             ],
// // // // // // //           ),
// // // // // // //           Padding(
// // // // // // //             padding: const EdgeInsets.all(18.0),
// // // // // // //             child: Row(
// // // // // // //               mainAxisAlignment: MainAxisAlignment.spaceAround,
// // // // // // //               children: [
// // // // // // //                 ButtonsWidget(
// // // // // // //                   onPressed: _clearForm,
// // // // // // //                   text: 'Clear form',
// // // // // // //                   icon: IconlyBold.danger,
// // // // // // //                   backgroundColor: Colors.red.shade300,
// // // // // // //                 ),
// // // // // // //                 ButtonsWidget(
// // // // // // //                   onPressed: () {
// // // // // // //                     _uploadForm();
// // // // // // //                   },
// // // // // // //                   text: 'Upload',
// // // // // // //                   icon: IconlyBold.upload,
// // // // // // //                   backgroundColor: Colors.blue,
// // // // // // //                 ),
// // // // // // //               ],
// // // // // // //             ),
// // // // // // //           ),
// // // // // // //         ],
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }
// // // // // // // }

// // // // // // // Future<void> _pickImage() async {
// // // // // // //   if (!kIsWeb) {
// // // // // // //     final ImagePicker _picker = ImagePicker();
// // // // // // //     XFile? image = await _picker.pickImage(source: ImageSource.gallery);
// // // // // // //     if (image != null) {
// // // // // // //       var selected = File(image.path);
// // // // // // //       // setState(() {
// // // // // // //       //   _pickedImage = selected;
// // // // // // //       // });
// // // // // // //     } else {
// // // // // // //       print('No image has been picked');
// // // // // // //     }
// // // // // // //   } else if (kIsWeb) {
// // // // // // //     final ImagePicker _picker = ImagePicker();
// // // // // // //     XFile? image = await _picker.pickImage(source: ImageSource.gallery);
// // // // // // //     if (image != null) {
// // // // // // //       var f = await image.readAsBytes();
// // // // // // //       // setState(() {
// // // // // // //       //   webImage = f;
// // // // // // //       //   _pickedImage = File('a');
// // // // // // //       // });
// // // // // // //     } else {
// // // // // // //       print('No image has been picked');
// // // // // // //     }
// // // // // // //   } else {
// // // // // // //     print('Something went wrong');
// // // // // // //   }
// // // // // // // }

// // // // // // // Widget dottedBorder({required Color color}) {
// // // // // // //   return Padding(
// // // // // // //     padding: const EdgeInsets.all(8.0),
// // // // // // //     child: DottedBorder(
// // // // // // //       // dashPattern: const [6.7],
// // // // // // //       // borderType: BorderType.RRect,
// // // // // // //       // color: color,
// // // // // // //       // radius: const Radius.circular(12),
// // // // // // //       child: Center(
// // // // // // //         child: Column(
// // // // // // //           mainAxisAlignment: MainAxisAlignment.center,
// // // // // // //           crossAxisAlignment: CrossAxisAlignment.center,
// // // // // // //           children: [
// // // // // // //             Icon(Icons.image_outlined, color: color, size: 50),
// // // // // // //             const SizedBox(height: 20),
// // // // // // //             TextButton(
// // // // // // //               onPressed: (() {
// // // // // // //                 _pickImage();
// // // // // // //               }),
// // // // // // //               child: CustomText(text: 'Choose an image', color: Colors.blue),
// // // // // // //             ),
// // // // // // //           ],
// // // // // // //         ),
// // // // // // //       ),
// // // // // // //     ),
// // // // // // //   );
// // // // // // // }

// // // // // // //   // Widget _categoryDropDown() {
// // // // // // //   //   // final color = Utils(context).color;
// // // // // // //   //   return Container(
// // // // // // //   //     color: Theme.of(context).scaffoldBackgroundColor,
// // // // // // //   //     child: Padding(
// // // // // // //   //       padding: const EdgeInsets.all(8.0),
// // // // // // //   //       child: DropdownButtonHideUnderline(
// // // // // // //   //         child: DropdownButton<String>(
// // // // // // //   //           style: TextStyle(
// // // // // // //   //             // color: color,
// // // // // // //   //             fontWeight: FontWeight.w600,
// // // // // // //   //             fontSize: 18,
// // // // // // //   //           ),
// // // // // // //   //           value: _catValue,
// // // // // // //   //           onChanged: (value) {
// // // // // // //   //             setState(() {
// // // // // // //   //               _catValue = value!;
// // // // // // //   //             });
// // // // // // //   //             print(_catValue);
// // // // // // //   //           },
// // // // // // //   //           hint: const Text('Select a category'),
// // // // // // //   //           items: const [
// // // // // // //   //             DropdownMenuItem(value: 'Vegetables', child: Text('Vegetables')),
// // // // // // //   //             DropdownMenuItem(value: 'Fruits', child: Text('Fruits')),
// // // // // // //   //             DropdownMenuItem(value: 'Grains', child: Text('Grains')),
// // // // // // //   //             DropdownMenuItem(value: 'Nuts', child: Text('Nuts')),
// // // // // // //   //             DropdownMenuItem(value: 'Herbs', child: Text('Herbs')),
// // // // // // //   //             DropdownMenuItem(value: 'Spices', child: Text('Spices')),
// // // // // // //   //           ],
// // // // // // //   //         ),
// // // // // // //   //       ),
// // // // // // //   //     ),
// // // // // // //   //   );
// // // // // // //   // }

// // // // // // import 'dart:io';
// // // // // // // import 'dart:typed_data';

// // // // // // import 'package:dotted_border/dotted_border.dart';
// // // // // // import 'package:flutter/foundation.dart';
// // // // // // import 'package:flutter/material.dart';
// // // // // // import 'package:flutter/services.dart';
// // // // // // import 'package:flutter_bloc/flutter_bloc.dart';
// // // // // // import 'package:grocery_app_dashboard/core/constants/app_constants.dart';
// // // // // // import 'package:grocery_app_dashboard/core/cubits/add_product_cubit/add_product_cubit.dart';
// // // // // // import 'package:grocery_app_dashboard/core/entites/product_entity.dart';
// // // // // // import 'package:grocery_app_dashboard/core/helper/functions/global_methods.dart';
// // // // // // import 'package:grocery_app_dashboard/core/utils/utils.dart';
// // // // // // import 'package:grocery_app_dashboard/features/dash_bord/presentation/widgets/buttons.dart';
// // // // // // import 'package:grocery_app_dashboard/features/dash_bord/presentation/widgets/custom_text.dart';
// // // // // // import 'package:grocery_app_dashboard/features/dash_bord/presentation/widgets/custom_text_form_field.dart';
// // // // // // import 'package:iconly/iconly.dart';
// // // // // // import 'package:image_picker/image_picker.dart';

// // // // // // class AddProductViewForm extends StatefulWidget {
// // // // // //   const AddProductViewForm({
// // // // // //     super.key,
// // // // // //     required this.isEdit,
// // // // // //     this.productEntity,
// // // // // //   });

// // // // // //   final bool isEdit;
// // // // // //   final ProductEntity? productEntity;
// // // // // //   @override
// // // // // //   State<AddProductViewForm> createState() => _AddProductViewFormState();
// // // // // // }

// // // // // // class _AddProductViewFormState extends State<AddProductViewForm> {
// // // // // //   final _formKey = GlobalKey<FormState>();
// // // // // //   String? _catValue = 'Vegetables';
// // // // // //   late final TextEditingController _titleController, _priceController;
// // // // // //   int _groupValue = 1;
// // // // // //   bool isPiece = false;
// // // // // //   XFile? _pickedImage;
// // // // // //   Uint8List webImage = Uint8List(8);

// // // // // //   @override
// // // // // //   void initState() {
// // // // // //     _priceController = TextEditingController();
// // // // // //     _titleController = TextEditingController();
// // // // // //     super.initState();
// // // // // //   }

// // // // // //   @override
// // // // // //   void dispose() {
// // // // // //     if (mounted) {
// // // // // //       _priceController.dispose();
// // // // // //       _titleController.dispose();
// // // // // //     }
// // // // // //     super.dispose();
// // // // // //   }

// // // // // //   Future<void> _pickImage() async {
// // // // // //     final ImagePicker picker = ImagePicker();
// // // // // //     XFile? image = await picker.pickImage(source: ImageSource.gallery);
// // // // // //     if (image != null) {
// // // // // //       if (kIsWeb) {
// // // // // //         var f = await image.readAsBytes();
// // // // // //         setState(() {
// // // // // //           webImage = f;
// // // // // //           _pickedImage = image;
// // // // // //         });
// // // // // //       } else {
// // // // // //         setState(() {
// // // // // //           _pickedImage = image;
// // // // // //         });
// // // // // //       }
// // // // // //     } else {
// // // // // //       debugPrint('No image has been picked');
// // // // // //     }
// // // // // //   }

// // // // // //   void _uploadForm() async {
// // // // // //     if (!_formKey.currentState!.validate()) return;

// // // // // //     if (_pickedImage == null) {
// // // // // //       GlobalMethods.showErrorORWarningDialog(
// // // // // //         context: context,
// // // // // //         subtitle: "Please pick up an image",
// // // // // //         fct: () {},
// // // // // //       );
// // // // // //       return;
// // // // // //     }

// // // // // //     if (_catValue == null) {
// // // // // //       GlobalMethods.showErrorORWarningDialog(
// // // // // //         context: context,
// // // // // //         subtitle: "Please select a category",
// // // // // //         fct: () {},
// // // // // //       );
// // // // // //       return;
// // // // // //     }
// // // // // //     final productInput = ProductEntity(
// // // // // //       name: _titleController.text.trim(),
// // // // // //       reviews: [],
// // // // // //       // description: _descriptionController.text.trim(),
// // // // // //       // quantity: _quantityController.text.trim(),
// // // // // //       price: double.tryParse(_priceController.text.trim()) ?? 0.0,
// // // // // //       image: _pickedImage, // null إذا لم تُختَر صورة جديدة
// // // // // //       // imageUrl: _pickedImage == null,
// // // // // //       category: _catValue!,
// // // // // //       productId: widget.isEdit ? widget.productEntity!.productId : '',
// // // // // //       isPiece: isPiece,
// // // // // //     );

// // // // // //     // final productInput = ProductEntity(
// // // // // //     //   name: _titleController.text.trim(),
// // // // // //     //   reviews: [],
// // // // // //     //   description: _descriptionController.text.trim(),
// // // // // //     //   quantity: _quantityController.text.trim(),
// // // // // //     //   price: double.tryParse(_priceController.text.trim()) ?? 0.0,
// // // // // //     //   image: _pickedImage ?? XFile(''),
// // // // // //     //   category: _categoryValue!,
// // // // // //     //   productId: isEdit ? productEntity!.productId : '',
// // // // // //     // );

// // // // // //     final cubit = context.read<AddProductCubit>();

// // // // // //     if (widget.isEdit) {
// // // // // //       cubit.editProduct(productInput);
// // // // // //     } else {
// // // // // //       cubit.addProduct(productInput);
// // // // // //     }
// // // // // //     // final isValid = _formKey.currentState!.validate();
// // // // // //     // FocusScope.of(context).unfocus();

// // // // // //     // if (!isValid) return;
// // // // // //     // if (_pickedImage == null) {
// // // // // //     //   ScaffoldMessenger.of(
// // // // // //     //     context,
// // // // // //     //   ).showSnackBar(const SnackBar(content: Text('Please pick an image')));
// // // // // //     //   return;
// // // // // //     // }

// // // // // //     // // TODO: upload to Firebase or Supabase here
// // // // // //     // debugPrint('Uploading product...');
// // // // // //     // debugPrint('Title: ${_titleController.text}');
// // // // // //     // debugPrint('Price: ${_priceController.text}');
// // // // // //     // debugPrint('Category: $_catValue');
// // // // // //     // debugPrint('isPiece: $isPiece');
// // // // // //     _clearForm();
// // // // // //   }

// // // // // //   void _onCategoryChanged(String? category) {
// // // // // //     setState(() {
// // // // // //       _catValue = category;
// // // // // //     });
// // // // // //   }

// // // // // //   void _clearForm() {
// // // // // //     isPiece = false;
// // // // // //     _groupValue = 1;
// // // // // //     _priceController.clear();
// // // // // //     _titleController.clear();
// // // // // //     setState(() {
// // // // // //       _pickedImage = null;
// // // // // //       webImage = Uint8List(8);
// // // // // //     });
// // // // // //   }

// // // // // //   Widget dottedBorder({required Color color}) {
// // // // // //     return Padding(
// // // // // //       padding: const EdgeInsets.all(8.0),
// // // // // //       child: DottedBorder(
// // // // // //         options: RectDottedBorderOptions(color: Colors.blue),
// // // // // //         // borderType: BorderType.RRect,
// // // // // //         //  radius: const Radius.circular(12),
// // // // // //         //    dashPattern: const [6, 4],
// // // // // //         //  color: color,
// // // // // //         child: Center(
// // // // // //           child: Column(
// // // // // //             mainAxisAlignment: MainAxisAlignment.center,
// // // // // //             children: [
// // // // // //               Icon(Icons.image_outlined, color: color, size: 50),
// // // // // //               const SizedBox(height: 20),
// // // // // //               TextButton(
// // // // // //                 onPressed: _pickImage,
// // // // // //                 child: const CustomText(
// // // // // //                   text: 'Choose an image',
// // // // // //                   color: Colors.blue,
// // // // // //                 ),
// // // // // //               ),
// // // // // //             ],
// // // // // //           ),
// // // // // //         ),
// // // // // //       ),
// // // // // //     );
// // // // // //   }

// // // // // //   @override
// // // // // //   Widget build(BuildContext context) {
// // // // // //     Size size = Utils(context).getScreenSize;

// // // // // //     return Form(
// // // // // //       key: _formKey,
// // // // // //       child: Column(
// // // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //         children: <Widget>[
// // // // // //           /// Title
// // // // // //           const CustomText(text: 'Product title*', isTitle: true),
// // // // // //           const SizedBox(height: 10),
// // // // // //           CustomTextFormField(
// // // // // //             controller: _titleController,
// // // // // //             key: const ValueKey('Title'),
// // // // // //             validator: (value) {
// // // // // //               if (value!.isEmpty) return 'Please enter a Title';
// // // // // //               return null;
// // // // // //             },
// // // // // //           ),
// // // // // //           const SizedBox(height: 20),

// // // // // //           /// Price + Category + Measure unit + Image
// // // // // //           Row(
// // // // // //             crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //             children: [
// // // // // //               /// Left side form
// // // // // //               Expanded(
// // // // // //                 flex: 2,
// // // // // //                 child: FittedBox(
// // // // // //                   child: Column(
// // // // // //                     crossAxisAlignment: CrossAxisAlignment.start,
// // // // // //                     children: [
// // // // // //                       /// Price
// // // // // //                       const CustomText(text: 'Price in \$*', isTitle: true),
// // // // // //                       const SizedBox(height: 10),
// // // // // //                       SizedBox(
// // // // // //                         width: 100,
// // // // // //                         child: CustomTextFormField(
// // // // // //                           controller: _priceController,
// // // // // //                           key: const ValueKey('Price \$'),
// // // // // //                           keyboardType: TextInputType.number,
// // // // // //                           validator: (value) {
// // // // // //                             if (value!.isEmpty) return 'Price is required';
// // // // // //                             return null;
// // // // // //                           },
// // // // // //                           inputFormatters: <TextInputFormatter>[
// // // // // //                             FilteringTextInputFormatter.allow(
// // // // // //                               RegExp(r'[0-9.]'),
// // // // // //                             ),
// // // // // //                           ],
// // // // // //                         ),
// // // // // //                       ),

// // // // // //                       const SizedBox(height: 20),

// // // // // //                       /// Category
// // // // // //                       const CustomText(
// // // // // //                         text: 'Product category*',
// // // // // //                         isTitle: true,
// // // // // //                       ),
// // // // // //                       const SizedBox(height: 10),
// // // // // //                       DropdownButton<String>(
// // // // // //                         hint: const Text('Select Category'),
// // // // // //                         value: _catValue,
// // // // // //                         items: AppConstants.categoryDropDownList,
// // // // // //                         onChanged: _onCategoryChanged,
// // // // // //                       ),

// // // // // //                       const SizedBox(height: 20),

// // // // // //                       /// Measure Unit
// // // // // //                       const CustomText(text: 'Measure unit*', isTitle: true),
// // // // // //                       const SizedBox(height: 10),
// // // // // //                       Row(
// // // // // //                         children: [
// // // // // //                           Radio<int>(
// // // // // //                             value: 1,
// // // // // //                             groupValue: _groupValue,
// // // // // //                             onChanged: (value) {
// // // // // //                               setState(() {
// // // // // //                                 _groupValue = value!;
// // // // // //                                 isPiece = false;
// // // // // //                               });
// // // // // //                             },
// // // // // //                             activeColor: Colors.green,
// // // // // //                           ),
// // // // // //                           const CustomText(text: 'KG'),
// // // // // //                           const SizedBox(width: 20),
// // // // // //                           Radio<int>(
// // // // // //                             value: 2,
// // // // // //                             groupValue: _groupValue,
// // // // // //                             onChanged: (value) {
// // // // // //                               setState(() {
// // // // // //                                 _groupValue = value!;
// // // // // //                                 isPiece = true;
// // // // // //                               });
// // // // // //                             },
// // // // // //                             activeColor: Colors.green,
// // // // // //                           ),
// // // // // //                           const CustomText(text: 'Piece'),
// // // // // //                         ],
// // // // // //                       ),
// // // // // //                     ],
// // // // // //                   ),
// // // // // //                 ),
// // // // // //               ),

// // // // // //               /// Image preview
// // // // // //               Expanded(
// // // // // //                 flex: 4,
// // // // // //                 child: Padding(
// // // // // //                   padding: const EdgeInsets.all(8.0),
// // // // // //                   child: Container(
// // // // // //                     height: size.width > 650 ? 350 : size.width * 0.45,
// // // // // //                     decoration: BoxDecoration(
// // // // // //                       color: Theme.of(context).scaffoldBackgroundColor,
// // // // // //                       borderRadius: BorderRadius.circular(12.0),
// // // // // //                     ),
// // // // // //                     child: _pickedImage == null
// // // // // //                         ? dottedBorder(color: Theme.of(context).primaryColor)
// // // // // //                         : ClipRRect(
// // // // // //                             borderRadius: BorderRadius.circular(12),
// // // // // //                             child: kIsWeb
// // // // // //                                 ? Image.memory(webImage, fit: BoxFit.fill)
// // // // // //                                 : Image.file(
// // // // // //                                     File(_pickedImage!.path),
// // // // // //                                     fit: BoxFit.fill,
// // // // // //                                   ),
// // // // // //                           ),
// // // // // //                   ),
// // // // // //                 ),
// // // // // //               ),

// // // // // //               /// Clear & Update image buttons
// // // // // //               Expanded(
// // // // // //                 flex: 1,
// // // // // //                 child: FittedBox(
// // // // // //                   child: Column(
// // // // // //                     mainAxisAlignment: MainAxisAlignment.center,
// // // // // //                     crossAxisAlignment: CrossAxisAlignment.center,
// // // // // //                     children: [
// // // // // //                       TextButton(
// // // // // //                         onPressed: _clearForm,
// // // // // //                         child: const CustomText(
// // // // // //                           text: 'Clear',
// // // // // //                           color: Colors.red,
// // // // // //                         ),
// // // // // //                       ),
// // // // // //                       TextButton(
// // // // // //                         onPressed: _pickImage,
// // // // // //                         child: const CustomText(
// // // // // //                           text: 'Update image',
// // // // // //                           color: Colors.blue,
// // // // // //                         ),
// // // // // //                       ),
// // // // // //                     ],
// // // // // //                   ),
// // // // // //                 ),
// // // // // //               ),
// // // // // //             ],
// // // // // //           ),

// // // // // //           /// Bottom buttons
// // // // // //           Padding(
// // // // // //             padding: const EdgeInsets.all(18.0),
// // // // // //             child: Row(
// // // // // //               mainAxisAlignment: MainAxisAlignment.spaceAround,
// // // // // //               children: [
// // // // // //                 ButtonsWidget(
// // // // // //                   onPressed: _clearForm,
// // // // // //                   text: 'Clear form',
// // // // // //                   icon: IconlyBold.danger,
// // // // // //                   backgroundColor: Colors.red.shade300,
// // // // // //                 ),
// // // // // //                 ButtonsWidget(
// // // // // //                   onPressed: _uploadForm,
// // // // // //                   text: 'Upload',
// // // // // //                   icon: IconlyBold.upload,
// // // // // //                   backgroundColor: Colors.blue,
// // // // // //                 ),
// // // // // //               ],
// // // // // //             ),
// // // // // //           ),
// // // // // //         ],
// // // // // //       ),
// // // // // //     );
// // // // // //   }
// // // // // // }

// // // // // import 'dart:io';
// // // // // import 'dart:typed_data';

// // // // import 'package:dotted_border/dotted_border.dart';
// // // // import 'package:flutter/foundation.dart';
// // // // import 'package:flutter/material.dart';
// // // // import 'package:flutter/services.dart';
// // // // import 'package:flutter_bloc/flutter_bloc.dart';
// // // // import 'package:grocery_app_dashboard/core/constants/app_constants.dart';
// // // // import 'package:grocery_app_dashboard/core/cubits/add_product_cubit/add_product_cubit.dart';
// // // // import 'package:grocery_app_dashboard/core/entites/product_entity.dart';
// // // // import 'package:grocery_app_dashboard/core/helper/functions/global_methods.dart';
// // // // import 'package:grocery_app_dashboard/core/utils/utils.dart';
// // // // import 'package:grocery_app_dashboard/features/dash_bord/presentation/widgets/buttons.dart';
// // // // import 'package:grocery_app_dashboard/features/dash_bord/presentation/widgets/custom_text.dart';
// // // // import 'package:grocery_app_dashboard/features/dash_bord/presentation/widgets/custom_text_form_field.dart';
// // // // import 'package:iconly/iconly.dart';
// // // // import 'package:image_picker/image_picker.dart';

// // // // class AddProductViewForm extends StatefulWidget {
// // // //   const AddProductViewForm({
// // // //     super.key,
// // // //     required this.isEdit,
// // // //     this.productEntity,
// // // //   });

// // // //   final bool isEdit;
// // // //   final ProductEntity? productEntity;

// // // //   @override
// // // //   State<AddProductViewForm> createState() => _AddProductViewFormState();
// // // // }

// // // // class _AddProductViewFormState extends State<AddProductViewForm> {
// // // //   final _formKey = GlobalKey<FormState>();
// // // //   String? _catValue = 'Vegetables';
// // // //   late final TextEditingController _titleController, _priceController;
// // // //   int _groupValue = 1;
// // // //   bool isPiece = false;

// // // //   XFile? _pickedImage;
// // // //   Uint8List webImage = Uint8List(8);
// // // //   String? _imageUrl; // رابط الصورة من الإنترنت
// // // //   final TextEditingController _imageUrlController = TextEditingController();

// // // //   @override
// // // //   void initState() {
// // // //     _priceController = TextEditingController();
// // // //     _titleController = TextEditingController();

// // // //     if (widget.isEdit && widget.productEntity != null) {
// // // //       final product = widget.productEntity!;
// // // //       _titleController.text = product.name;
// // // //       _priceController.text = product.price.toString();
// // // //       _catValue = product.category;
// // // //       isPiece = product.isPiece;
// // // //       _groupValue = isPiece ? 2 : 1;

// // // //       if (product.image != null) {
// // // //         _pickedImage = product.image;
// // // //       } else if (product.imageUrl != null) {
// // // //         _imageUrl = product.imageUrl;
// // // //         _imageUrlController.text = _imageUrl!;
// // // //       }
// // // //     }

// // // //     super.initState();
// // // //   }

// // // //   @override
// // // //   void dispose() {
// // // //     if (mounted) {
// // // //       _priceController.dispose();
// // // //       _titleController.dispose();
// // // //       _imageUrlController.dispose();
// // // //     }
// // // //     super.dispose();
// // // //   }

// // // //   Future<void> _pickImage() async {
// // // //     final ImagePicker picker = ImagePicker();
// // // //     XFile? image = await picker.pickImage(source: ImageSource.gallery);
// // // //     if (image != null) {
// // // //       if (kIsWeb) {
// // // //         var f = await image.readAsBytes();
// // // //         setState(() {
// // // //           webImage = f;
// // // //           _pickedImage = image;
// // // //           _imageUrl = null;
// // // //           _imageUrlController.clear();
// // // //         });
// // // //       } else {
// // // //         setState(() {
// // // //           _pickedImage = image;
// // // //           _imageUrl = null;
// // // //           _imageUrlController.clear();
// // // //         });
// // // //       }
// // // //     }
// // // //   }

// // // //   void _addImageFromUrl() {
// // // //     showDialog(
// // // //       context: context,
// // // //       builder: (ctx) => AlertDialog(
// // // //         title: const Text("Add Image from URL"),
// // // //         content: TextField(
// // // //           controller: _imageUrlController,
// // // //           decoration: const InputDecoration(hintText: "Enter image URL"),
// // // //         ),
// // // //         actions: [
// // // //           TextButton(
// // // //             onPressed: () {
// // // //               Navigator.pop(ctx);
// // // //             },
// // // //             child: const Text("Cancel"),
// // // //           ),
// // // //           ElevatedButton(
// // // //             onPressed: () {
// // // //               if (_imageUrlController.text.trim().isEmpty) return;
// // // //               setState(() {
// // // //                 _imageUrl = _imageUrlController.text.trim();
// // // //                 _pickedImage = null;
// // // //               });
// // // //               Navigator.pop(ctx);
// // // //             },
// // // //             child: const Text("Add"),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }

// // // //   // void _uploadForm() async {
// // // //   //   if (!_formKey.currentState!.validate()) return;

// // // //   //   if (_pickedImage == null && _imageUrl == null) {
// // // //   //     GlobalMethods.showErrorORWarningDialog(
// // // //   //       context: context,
// // // //   //       subtitle: "Please pick or enter an image",
// // // //   //       fct: () {},
// // // //   //     );
// // // //   //     return;
// // // //   //   }

// // // //   //   if (_catValue == null) {
// // // //   //     GlobalMethods.showErrorORWarningDialog(
// // // //   //       context: context,
// // // //   //       subtitle: "Please select a category",
// // // //   //       fct: () {},
// // // //   //     );
// // // //   //     return;
// // // //   //   }

// // // //   //   final productInput = ProductEntity(
// // // //   //     name: _titleController.text.trim(),
// // // //   //     reviews: [],
// // // //   //     price: double.tryParse(_priceController.text.trim()) ?? 0.0,
// // // //   //     image: _pickedImage,
// // // //   //     imageUrl: _imageUrl,
// // // //   //     category: _catValue!,
// // // //   //     productId: widget.isEdit ? widget.productEntity!.productId : '',
// // // //   //     isPiece: isPiece,
// // // //   //   );

// // // //   //   final cubit = context.read<AddProductCubit>();
// // // //   //   if (widget.isEdit) {
// // // //   //     cubit.editProduct(productInput);
// // // //   //   } else {
// // // //   //     cubit.addProduct(productInput);
// // // //   //   }

// // // //   //   _clearForm();
// // // //   // }
// // // //   void _uploadForm() async {
// // // //     if (!_formKey.currentState!.validate()) return;

// // // //     // تحديث _imageUrl تلقائيًا من TextField إذا موجود
// // // //     if (_imageUrlController.text.trim().isNotEmpty) {
// // // //       _imageUrl = _imageUrlController.text.trim();
// // // //     }

// // // //     if (_pickedImage == null && (_imageUrl == null || _imageUrl!.isEmpty)) {
// // // //       GlobalMethods.showErrorORWarningDialog(
// // // //         context: context,
// // // //         subtitle: "Please pick or enter an image",
// // // //         fct: () {},
// // // //       );
// // // //       return;
// // // //     }

// // // //     if (_catValue == null) {
// // // //       GlobalMethods.showErrorORWarningDialog(
// // // //         context: context,
// // // //         subtitle: "Please select a category",
// // // //         fct: () {},
// // // //       );
// // // //       return;
// // // //     }

// // // //     final productInput = ProductEntity(
// // // //       name: _titleController.text.trim(),
// // // //       reviews: [],
// // // //       price: double.tryParse(_priceController.text.trim()) ?? 0.0,
// // // //       image: _pickedImage,
// // // //       imageUrl: _imageUrl,
// // // //       category: _catValue!,
// // // //       productId: widget.isEdit ? widget.productEntity!.productId : '',
// // // //       isPiece: isPiece,
// // // //     );

// // // //     final cubit = context.read<AddProductCubit>();
// // // //     if (widget.isEdit) {
// // // //       cubit.editProduct(productInput);
// // // //     } else {
// // // //       cubit.addProduct(productInput);
// // // //     }

// // // //     _clearForm();
// // // //   }

// // // //   void _onCategoryChanged(String? category) {
// // // //     setState(() {
// // // //       _catValue = category;
// // // //     });
// // // //   }

// // // //   void _clearForm() {
// // // //     isPiece = false;
// // // //     _groupValue = 1;
// // // //     _priceController.clear();
// // // //     _titleController.clear();
// // // //     _imageUrlController.clear();
// // // //     setState(() {
// // // //       _pickedImage = null;
// // // //       _imageUrl = null;
// // // //       webImage = Uint8List(8);
// // // //     });
// // // //   }

// // // //   Widget dottedBorder({required Color color}) {
// // // //     return Padding(
// // // //       padding: const EdgeInsets.all(8.0),
// // // //       child: DottedBorder(
// // // //         options: RectDottedBorderOptions(color: color),
// // // //         child: Center(
// // // //           child: Column(
// // // //             mainAxisAlignment: MainAxisAlignment.center,
// // // //             children: [
// // // //               Icon(Icons.image_outlined, color: color, size: 50),
// // // //               const SizedBox(height: 20),
// // // //               TextButton(
// // // //                 onPressed: _pickImage,
// // // //                 child: const CustomText(
// // // //                   text: 'Choose an image',
// // // //                   color: Colors.blue,
// // // //                 ),
// // // //               ),
// // // //             ],
// // // //           ),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     Size size = Utils(context).getScreenSize;

// // // //     return Form(
// // // //       key: _formKey,
// // // //       child: Column(
// // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // //         children: [
// // // //           /// Title
// // // //           const CustomText(text: 'Product title*', isTitle: true),
// // // //           const SizedBox(height: 10),
// // // //           CustomTextFormField(
// // // //             controller: _titleController,
// // // //             key: const ValueKey('Title'),
// // // //             validator: (value) =>
// // // //                 value!.isEmpty ? 'Please enter a Title' : null,
// // // //           ),
// // // //           const SizedBox(height: 20),

// // // //           /// Price + Category + Measure unit + Image
// // // //           Row(
// // // //             crossAxisAlignment: CrossAxisAlignment.start,
// // // //             children: [
// // // //               /// Left side form
// // // //               Expanded(
// // // //                 flex: 2,
// // // //                 child: FittedBox(
// // // //                   child: Column(
// // // //                     crossAxisAlignment: CrossAxisAlignment.start,
// // // //                     children: [
// // // //                       /// Price
// // // //                       const CustomText(text: 'Price in \$*', isTitle: true),
// // // //                       const SizedBox(height: 10),
// // // //                       SizedBox(
// // // //                         width: 100,
// // // //                         child: CustomTextFormField(
// // // //                           controller: _priceController,
// // // //                           key: const ValueKey('Price \$'),
// // // //                           keyboardType: TextInputType.number,
// // // //                           validator: (value) =>
// // // //                               value!.isEmpty ? 'Price is required' : null,
// // // //                           inputFormatters: <TextInputFormatter>[
// // // //                             FilteringTextInputFormatter.allow(
// // // //                               RegExp(r'[0-9.]'),
// // // //                             ),
// // // //                           ],
// // // //                         ),
// // // //                       ),
// // // //                       const SizedBox(height: 20),

// // // //                       /// Category
// // // //                       const CustomText(
// // // //                         text: 'Product category*',
// // // //                         isTitle: true,
// // // //                       ),
// // // //                       const SizedBox(height: 10),
// // // //                       DropdownButton<String>(
// // // //                         hint: const Text('Select Category'),
// // // //                         value: _catValue,
// // // //                         items: AppConstants.categoryDropDownList,
// // // //                         onChanged: _onCategoryChanged,
// // // //                       ),

// // // //                       const SizedBox(height: 20),

// // // //                       /// Measure Unit
// // // //                       const CustomText(text: 'Measure unit*', isTitle: true),
// // // //                       const SizedBox(height: 10),
// // // //                       Row(
// // // //                         children: [
// // // //                           Radio<int>(
// // // //                             value: 1,
// // // //                             groupValue: _groupValue,
// // // //                             onChanged: (value) {
// // // //                               setState(() {
// // // //                                 _groupValue = value!;
// // // //                                 isPiece = false;
// // // //                               });
// // // //                             },
// // // //                             activeColor: Colors.green,
// // // //                           ),
// // // //                           const CustomText(text: 'KG'),
// // // //                           const SizedBox(width: 20),
// // // //                           Radio<int>(
// // // //                             value: 2,
// // // //                             groupValue: _groupValue,
// // // //                             onChanged: (value) {
// // // //                               setState(() {
// // // //                                 _groupValue = value!;
// // // //                                 isPiece = true;
// // // //                               });
// // // //                             },
// // // //                             activeColor: Colors.green,
// // // //                           ),
// // // //                           const CustomText(text: 'Piece'),
// // // //                         ],
// // // //                       ),
// // // //                     ],
// // // //                   ),
// // // //                 ),
// // // //               ),

// // // //               /// Image preview
// // // //               Expanded(
// // // //                 flex: 4,
// // // //                 child: Padding(
// // // //                   padding: const EdgeInsets.all(8.0),
// // // //                   child: Container(
// // // //                     height: size.width > 650 ? 350 : size.width * 0.45,
// // // //                     decoration: BoxDecoration(
// // // //                       color: Theme.of(context).scaffoldBackgroundColor,
// // // //                       borderRadius: BorderRadius.circular(12.0),
// // // //                     ),
// // // //                     child: _imageUrl != null
// // // //                         ? Image.network(_imageUrl!, fit: BoxFit.fill)
// // // //                         : _pickedImage != null
// // // //                         ? (kIsWeb
// // // //                               ? Image.memory(webImage, fit: BoxFit.fill)
// // // //                               : Image.file(
// // // //                                   File(_pickedImage!.path),
// // // //                                   fit: BoxFit.fill,
// // // //                                 ))
// // // //                         : dottedBorder(color: Theme.of(context).primaryColor),
// // // //                   ),
// // // //                 ),
// // // //               ),

// // // //               /// Clear & Update image buttons
// // // //               Expanded(
// // // //                 flex: 1,
// // // //                 child: FittedBox(
// // // //                   child: Column(
// // // //                     mainAxisAlignment: MainAxisAlignment.center,
// // // //                     children: [
// // // //                       TextButton(
// // // //                         onPressed: _clearForm,
// // // //                         child: const CustomText(
// // // //                           text: 'Clear',
// // // //                           color: Colors.red,
// // // //                         ),
// // // //                       ),
// // // //                       TextButton(
// // // //                         onPressed: _pickImage,
// // // //                         child: const CustomText(
// // // //                           text: 'Upload from Device',
// // // //                           color: Colors.blue,
// // // //                         ),
// // // //                       ),
// // // //                       TextButton(
// // // //                         onPressed: _addImageFromUrl,
// // // //                         child: const CustomText(
// // // //                           text: 'Add from URL',
// // // //                           color: Colors.orange,
// // // //                         ),
// // // //                       ),
// // // //                     ],
// // // //                   ),
// // // //                 ),
// // // //               ),
// // // //             ],
// // // //           ),

// // // //           /// Bottom buttons
// // // //           Padding(
// // // //             padding: const EdgeInsets.all(18.0),
// // // //             child: Row(
// // // //               mainAxisAlignment: MainAxisAlignment.spaceAround,
// // // //               children: [
// // // //                 ButtonsWidget(
// // // //                   onPressed: _clearForm,
// // // //                   text: 'Clear form',
// // // //                   icon: IconlyBold.danger,
// // // //                   backgroundColor: Colors.red.shade300,
// // // //                 ),
// // // //                 ButtonsWidget(
// // // //                   onPressed: _uploadForm,
// // // //                   text: 'Upload',
// // // //                   icon: IconlyBold.upload,
// // // //                   backgroundColor: Colors.blue,
// // // //                 ),
// // // //               ],
// // // //             ),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }
// // // // }

// // // // // import 'dart:io';
// // // // // import 'dart:typed_data';

// // // // // import 'package:flutter/foundation.dart';
// // // // // import 'package:flutter/material.dart';
// // // // // import 'package:grocery_app_dashboard/core/constants/app_constants.dart';
// // // // // import 'package:grocery_app_dashboard/core/entites/product_entity.dart';
// // // // // // import 'package:grocery_app_dashboard/core/entities/product_entity.dart';
// // // // // import 'package:image_picker/image_picker.dart';

// // // // // class AddProductViewForm extends StatefulWidget {
// // // // //   final bool isEdit;
// // // // //   final ProductEntity? productEntity;

// // // // //   const AddProductViewForm({
// // // // //     super.key,
// // // // //     this.isEdit = false,
// // // // //     this.productEntity,
// // // // //   });

// // // // //   @override
// // // // //   State<AddProductViewForm> createState() => _AddProductViewFormState();
// // // // // }

// // // // // class _AddProductViewFormState extends State<AddProductViewForm> {
// // // // //   final TextEditingController _priceController = TextEditingController();
// // // // //   final TextEditingController _titleController = TextEditingController();
// // // // //   final TextEditingController _imageUrlController = TextEditingController();

// // // // //   XFile? _pickedImage;
// // // // //   Uint8List? webImage;
// // // // //   String? _catValue;

// // // // //   @override
// // // // //   void initState() {
// // // // //     super.initState();
// // // // //     if (widget.isEdit && widget.productEntity != null) {
// // // // //       _titleController.text = widget.productEntity!.name;
// // // // //       _priceController.text = widget.productEntity!.price.toString();
// // // // //       _catValue = widget.productEntity!.category;
// // // // //       _imageUrlController.text = widget.productEntity!.imageUrl ?? '';
// // // // //     }
// // // // //   }

// // // // //   @override
// // // // //   void dispose() {
// // // // //     _priceController.dispose();
// // // // //     _titleController.dispose();
// // // // //     _imageUrlController.dispose();
// // // // //     super.dispose();
// // // // //   }

// // // // //   Future<void> _pickImage() async {
// // // // //     final ImagePicker picker = ImagePicker();
// // // // //     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

// // // // //     if (pickedFile != null) {
// // // // //       if (kIsWeb) {
// // // // //         final bytes = await pickedFile.readAsBytes();
// // // // //         setState(() {
// // // // //           webImage = bytes;
// // // // //           _pickedImage = pickedFile;
// // // // //         });
// // // // //       } else {
// // // // //         setState(() {
// // // // //           _pickedImage = pickedFile;
// // // // //         });
// // // // //       }
// // // // //     }
// // // // //   }

// // // // //   void _onCategoryChanged(String? newValue) {
// // // // //     setState(() {
// // // // //       _catValue = newValue;
// // // // //     });
// // // // //   }

// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     final validCategories = AppConstants.categoryDropDownList;

// // // // //     return SingleChildScrollView(
// // // // //       child: Column(
// // // // //         children: [
// // // // //           GestureDetector(
// // // // //             onTap: _pickImage,
// // // // //             child: SizedBox(
// // // // //               height: 150,
// // // // //               width: double.infinity,
// // // // //               child: _pickedImage != null
// // // // //                   ? (kIsWeb
// // // // //                         ? Image.memory(webImage!, fit: BoxFit.cover)
// // // // //                         : Image.file(
// // // // //                             File(_pickedImage!.path),
// // // // //                             fit: BoxFit.cover,
// // // // //                           ))
// // // // //                   : (widget.isEdit &&
// // // // //                         widget.productEntity != null &&
// // // // //                         widget.productEntity!.imageUrl != null &&
// // // // //                         widget.productEntity!.imageUrl!.isNotEmpty)
// // // // //                   ? Image.network(
// // // // //                       widget.productEntity!.imageUrl!,
// // // // //                       fit: BoxFit.cover,
// // // // //                       errorBuilder: (context, error, stackTrace) =>
// // // // //                           const Icon(Icons.broken_image, size: 50),
// // // // //                     )
// // // // //                   : Container(
// // // // //                       color: Colors.grey[300],
// // // // //                       child: const Center(child: Text("Pick an Image")),
// // // // //                     ),
// // // // //             ),
// // // // //           ),
// // // // //           const SizedBox(height: 20),
// // // // //           TextField(
// // // // //             controller: _titleController,
// // // // //             decoration: const InputDecoration(labelText: "Product Name"),
// // // // //           ),
// // // // //           const SizedBox(height: 20),
// // // // //           TextField(
// // // // //             controller: _priceController,
// // // // //             keyboardType: TextInputType.number,
// // // // //             decoration: const InputDecoration(labelText: "Price"),
// // // // //           ),
// // // // //           const SizedBox(height: 20),
// // // // //           DropdownButton<String>(
// // // // //             hint: const Text('Select Category'),
// // // // //             value: validCategories.any((item) => item.value == _catValue)
// // // // //                 ? _catValue
// // // // //                 : null,
// // // // //             items: validCategories,
// // // // //             onChanged: _onCategoryChanged,
// // // // //           ),
// // // // //           const SizedBox(height: 30),
// // // // //           ElevatedButton(
// // // // //             onPressed: () {
// // // // //               final productId = widget.isEdit && widget.productEntity != null
// // // // //                   ? widget.productEntity!.productId
// // // // //                   : DateTime.now().millisecondsSinceEpoch.toString();

// // // // //               final product = ProductEntity(
// // // // //                 productId: productId,
// // // // //                 name: _titleController.text.trim(),
// // // // //                 price: double.tryParse(_priceController.text) ?? 0.0,
// // // // //                 category: _catValue ?? '',
// // // // //                 imageUrl:
// // // // //                     _pickedImage?.path ?? widget.productEntity?.imageUrl ?? '',
// // // // //                 reviews: [],
// // // // //                 isPiece: true,
// // // // //               );

// // // // //               debugPrint("✅ Product Saved: ${product.toString()}");
// // // // //             },
// // // // //             child: Text(widget.isEdit ? "Update Product" : "Add Product"),
// // // // //           ),
// // // // //         ],
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // // }

// // // // // import 'dart:io';
// // // // // import 'dart:typed_data';

// // // // // import 'package:flutter/foundation.dart';
// // // // // import 'package:flutter/material.dart';
// // // // // import 'package:grocery_app_dashboard/core/constants/app_constants.dart';
// // // // // import 'package:grocery_app_dashboard/core/entities/product_entity.dart';
// // // // // import 'package:image_picker/image_picker.dart';

// // // // // class AddProductViewForm extends StatefulWidget {
// // // // //   final bool isEdit;
// // // // //   final ProductEntity? productEntity;

// // // // //   const AddProductViewForm({
// // // // //     super.key,
// // // // //     this.isEdit = false,
// // // // //     this.productEntity,
// // // // //   });

// // // // //   @override
// // // // //   State<AddProductViewForm> createState() => _AddProductViewFormState();
// // // // // }

// // // // // class _AddProductViewFormState extends State<AddProductViewForm> {
// // // // //   final TextEditingController _priceController = TextEditingController();
// // // // //   final TextEditingController _titleController = TextEditingController();
// // // // //   final TextEditingController _imageUrlController = TextEditingController();

// // // // //   XFile? _pickedImage;
// // // // //   Uint8List? webImage;
// // // // //   String? _catValue;

// // // // //   @override
// // // // //   void initState() {
// // // // //     super.initState();
// // // // //     if (widget.isEdit && widget.productEntity != null) {
// // // // //       _titleController.text = widget.productEntity!.name;
// // // // //       _priceController.text = widget.productEntity!.price.toString();
// // // // //       _catValue = widget.productEntity!.category;
// // // // //       _imageUrlController.text = widget.productEntity!.imageUrl ?? '';
// // // // //     }
// // // // //   }

// // // // //   @override
// // // // //   void dispose() {
// // // // //     _priceController.dispose();
// // // // //     _titleController.dispose();
// // // // //     _imageUrlController.dispose();
// // // // //     super.dispose();
// // // // //   }

// // // // //   Future<void> _pickImage() async {
// // // // //     final ImagePicker picker = ImagePicker();
// // // // //     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

// // // // //     if (pickedFile != null) {
// // // // //       if (kIsWeb) {
// // // // //         final bytes = await pickedFile.readAsBytes();
// // // // //         setState(() {
// // // // //           webImage = bytes;
// // // // //           _pickedImage = pickedFile;
// // // // //         });
// // // // //       } else {
// // // // //         setState(() {
// // // // //           _pickedImage = pickedFile;
// // // // //         });
// // // // //       }
// // // // //     }
// // // // //   }

// // // // //   void _onCategoryChanged(String? newValue) {
// // // // //     setState(() {
// // // // //       _catValue = newValue;
// // // // //     });
// // // // //   }

// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     final validCategories = AppConstants.categoryDropDownList;

// // // // //     return SingleChildScrollView(
// // // // //       padding: const EdgeInsets.all(16),
// // // // //       child: Column(
// // // // //         children: [
// // // // //           // ---------- Image Picker ----------
// // // // //           GestureDetector(
// // // // //             onTap: _pickImage,
// // // // //             child: SizedBox(
// // // // //               height: 150,
// // // // //               width: double.infinity,
// // // // //               child: _pickedImage != null
// // // // //                   ? (kIsWeb
// // // // //                       ? Image.memory(webImage!, fit: BoxFit.cover)
// // // // //                       : Image.file(File(_pickedImage!.path), fit: BoxFit.cover))
// // // // //                   : (widget.isEdit &&
// // // // //                           widget.productEntity != null &&
// // // // //                           widget.productEntity!.imageUrl != null)
// // // // //                       ? Image.network(widget.productEntity!.imageUrl!,
// // // // //                           fit: BoxFit.cover, errorBuilder:
// // // // //                               (context, error, stackTrace) {
// // // // //                           return const Center(
// // // // //                               child: Icon(Icons.broken_image, size: 50));
// // // // //                         })
// // // // //                       : Container(
// // // // //                           color: Colors.grey[300],
// // // // //                           child: const Center(child: Text("Pick an Image")),
// // // // //                         ),
// // // // //             ),
// // // // //           ),

// // // // //           const SizedBox(height: 20),

// // // // //           // ---------- Product Name ----------
// // // // //           TextField(
// // // // //             controller: _titleController,
// // // // //             decoration: const InputDecoration(labelText: "Product Name"),
// // // // //           ),

// // // // //           const SizedBox(height: 20),

// // // // //           // ---------- Product Price ----------
// // // // //           TextField(
// // // // //             controller: _priceController,
// // // // //             keyboardType: TextInputType.number,
// // // // //             decoration: const InputDecoration(labelText: "Price"),
// // // // //           ),

// // // // //           const SizedBox(height: 20),

// // // // //           // ---------- Category ----------
// // // // //           DropdownButton<String>(
// // // // //             hint: const Text('Select Category'),
// // // // //             value: validCategories.any((item) => item.value == _catValue)
// // // // //                 ? _catValue
// // // // //                 : null,
// // // // //             items: validCategories,
// // // // //             onChanged: _onCategoryChanged,
// // // // //           ),

// // // // //           const SizedBox(height: 30),

// // // // //           ElevatedButton(
// // // // //             onPressed: () {
// // // // //               final productId = widget.isEdit && widget.productEntity != null
// // // // //                   ? widget.productEntity!.productId
// // // // //                   : DateTime.now().millisecondsSinceEpoch.toString();

// // // // //               final product = ProductEntity(
// // // // //                 productId: productId,
// // // // //                 name: _titleController.text.trim(),
// // // // //                 price: double.tryParse(_priceController.text) ?? 0.0,
// // // // //                 category: _catValue ?? '',
// // // // //                 imageUrl: _pickedImage != null
// // // // //                     ? _pickedImage!.path
// // // // //                     : widget.productEntity?.imageUrl ?? '',
// // // // //               );

// // // // //               debugPrint("✅ Product Saved: ${product.toString()}");
// // // // //             },
// // // // //             child: Text(widget.isEdit ? "Update Product" : "Add Product"),
// // // // //           ),
// // // // //         ],
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // // }

// // // import 'dart:io';
// // // // import 'dart:typed_data';

// // // import 'package:dotted_border/dotted_border.dart';
// // // import 'package:flutter/foundation.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:flutter/services.dart';
// // // import 'package:flutter_bloc/flutter_bloc.dart';
// // // import 'package:grocery_app_dashboard/core/constants/app_constants.dart';
// // // import 'package:grocery_app_dashboard/core/cubits/add_product_cubit/add_product_cubit.dart';
// // // import 'package:grocery_app_dashboard/core/entites/product_entity.dart';
// // // import 'package:grocery_app_dashboard/core/helper/functions/global_methods.dart';
// // // import 'package:grocery_app_dashboard/core/utils/utils.dart';
// // // import 'package:grocery_app_dashboard/features/dash_bord/presentation/widgets/buttons.dart';
// // // import 'package:grocery_app_dashboard/features/dash_bord/presentation/widgets/custom_text.dart';
// // // import 'package:grocery_app_dashboard/features/dash_bord/presentation/widgets/custom_text_form_field.dart';
// // // import 'package:iconly/iconly.dart';
// // // import 'package:image_picker/image_picker.dart';

// // // class AddProductViewForm extends StatefulWidget {
// // //   const AddProductViewForm({
// // //     super.key,
// // //     required this.isEdit,
// // //     this.productEntity,
// // //   });

// // //   final bool isEdit;
// // //   final ProductEntity? productEntity;

// // //   @override
// // //   State<AddProductViewForm> createState() => _AddProductViewFormState();
// // // }

// // // class _AddProductViewFormState extends State<AddProductViewForm> {
// // //   final _formKey = GlobalKey<FormState>();
// // //   String? _catValue = 'Vegetables';
// // //   late final TextEditingController _titleController, _priceController;
// // //   int _groupValue = 1;
// // //   bool isPiece = false;
// // //   bool _isOnSale = false;
// // //   double? _salePrice;
// // //   XFile? _pickedImage;
// // //   Uint8List webImage = Uint8List(8);
// // //   String? _imageUrl; // رابط الصورة من الإنترنت
// // //   final TextEditingController _imageUrlController = TextEditingController();
// // //   late String percToShow;
// // //   ProductEntity? productEntity;
// // //   // Title and price controllers
// // //   //late final TextEditingController _titleController, _priceController;

// // //   // Sale
// // //   // String? _salePercent;
// // //   // late String percToShow;
// // //   // late double _salePrice;
// // //   // late bool _isOnSale;
// // //   // Image
// // //   // File? _pickedImage;
// // //   // Uint8List webImage = Uint8List(10);
// // //   // late String _imageUrl;
// // //   // kg or Piece,
// // //   // late int val;
// // //   // late bool _isPiece;
// // //   // while loading
// // //   @override
// // //   void initState() {
// // //     _priceController = TextEditingController(
// // //       text: productEntity!.price.toString(),
// // //     );
// // //     _titleController = TextEditingController(text: productEntity!.name);

// // //     // if (widget.isEdit && widget.productEntity != null) {
// // //     //   final product = widget.productEntity!;
// // //     //   _titleController.text = product.name;
// // //     //   _priceController.text = product.price.toString();
// // //     //   _catValue = product.category;
// // //     //   isPiece = product.isPiece;
// // //     //   _groupValue = isPiece ? 2 : 1;

// // //     //   if (product.image != null) {
// // //     //     _pickedImage = product.image;
// // //     //   } else if (product.imageUrl != null && product.imageUrl!.isNotEmpty) {
// // //     //     _imageUrl = product.imageUrl;
// // //     //     _imageUrlController.text = _imageUrl!;
// // //     //   }
// // //     // }
// // //     _salePrice = widget.productEntity!.salePrice;
// // //     _catValue = widget.productEntity!.category;
// // //     _isOnSale = widget.productEntity!.isOnSale!;
// // //     isPiece = widget.productEntity!.isPiece; // val = _isPiece ? 2 : 1;
// // //     _imageUrl = widget.productEntity!.imageUrl;
// // //     // Calculate the percentage
// // //     percToShow =
// // //     widget.  productEntity.  (100 -
// // //                 (_salePrice * 100) /
// // //                     double.parse(
// // //                       widget.price,
// // //                     )) // WIll be the price instead of 1.88
// // //             .round()
// // //             .toStringAsFixed(1) +
// // //         '%';

// // //     super.initState();
// // //   }

// // //   @override
// // //   void dispose() {
// // //     if (mounted) {
// // //       _priceController.dispose();
// // //       _titleController.dispose();
// // //       _imageUrlController.dispose();
// // //     }
// // //     super.dispose();
// // //   }

// // //   Future<void> _pickImage() async {
// // //     final ImagePicker picker = ImagePicker();
// // //     XFile? image = await picker.pickImage(source: ImageSource.gallery);
// // //     if (image != null) {
// // //       if (kIsWeb) {
// // //         var f = await image.readAsBytes();
// // //         setState(() {
// // //           webImage = f;
// // //           _pickedImage = image;
// // //           _imageUrl = null;
// // //           _imageUrlController.clear();
// // //         });
// // //       } else {
// // //         setState(() {
// // //           _pickedImage = image;
// // //           _imageUrl = null;
// // //           _imageUrlController.clear();
// // //         });
// // //       }
// // //     }
// // //   }

// // //   void _addImageFromUrl() {
// // //     showDialog(
// // //       context: context,
// // //       builder: (ctx) => AlertDialog(
// // //         title: const Text("Add Image from URL"),
// // //         content: TextField(
// // //           controller: _imageUrlController,
// // //           decoration: const InputDecoration(hintText: "Enter image URL"),
// // //         ),
// // //         actions: [
// // //           TextButton(
// // //             onPressed: () {
// // //               Navigator.pop(ctx);
// // //             },
// // //             child: const Text("Cancel"),
// // //           ),
// // //           ElevatedButton(
// // //             onPressed: () {
// // //               if (_imageUrlController.text.trim().isEmpty) return;
// // //               setState(() {
// // //                 _imageUrl = _imageUrlController.text.trim();
// // //                 _pickedImage = null;
// // //               });
// // //               Navigator.pop(ctx);
// // //             },
// // //             child: const Text("Add"),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   // void _uploadForm() async {
// // //   //   if (!_formKey.currentState!.validate()) return;

// // //   //   if (_imageUrlController.text.trim().isNotEmpty) {
// // //   //     _imageUrl = _imageUrlController.text.trim();
// // //   //   }

// // //   //   if (_pickedImage == null && (_imageUrl == null || _imageUrl!.isEmpty)) {
// // //   //     GlobalMethods.showErrorORWarningDialog(
// // //   //       context: context,
// // //   //       subtitle: "Please pick or enter an image",
// // //   //       fct: () {},
// // //   //     );
// // //   //     return;
// // //   //   }

// // //   //   if (_catValue == null || _catValue!.isEmpty) {
// // //   //     GlobalMethods.showErrorORWarningDialog(
// // //   //       context: context,
// // //   //       subtitle: "Please select a category",
// // //   //       fct: () {},
// // //   //     );
// // //   //     return;
// // //   //   }

// // //   //   final productInput = ProductEntity(
// // //   //     name: _titleController.text.trim(),
// // //   //     reviews: [],
// // //   //     price: double.tryParse(_priceController.text.trim()) ?? 0.0,
// // //   //     image: _pickedImage,
// // //   //     imageUrl: _imageUrl,
// // //   //     category: _catValue!,
// // //   //     productId: widget.isEdit ? widget.productEntity?.productId ?? '' : '',
// // //   //     isPiece: isPiece,
// // //   //   );

// // //   //   final cubit = context.read<AddProductCubit>();
// // //   //   if (widget.isEdit) {
// // //   //     cubit.editProduct(productInput);
// // //   //   } else {
// // //   //     cubit.addProduct(productInput);
// // //   //   }

// // //   //   _clearForm();
// // //   // }

// // //   // void _uploadForm() async {
// // //   //   if (!_formKey.currentState!.validate()) return;

// // //   //   if (_imageUrlController.text.trim().isNotEmpty) {
// // //   //     _imageUrl = _imageUrlController.text.trim();
// // //   //   }

// // //   //   if (_pickedImage == null && (_imageUrl == null || _imageUrl!.isEmpty)) {
// // //   //     GlobalMethods.showErrorORWarningDialog(
// // //   //       context: context,
// // //   //       subtitle: "Please pick or enter an image",
// // //   //       fct: () {},
// // //   //     );
// // //   //     return;
// // //   //   }

// // //   //   if (_catValue == null || _catValue!.isEmpty) {
// // //   //     GlobalMethods.showErrorORWarningDialog(
// // //   //       context: context,
// // //   //       subtitle: "Please select a category",
// // //   //       fct: () {},
// // //   //     );
// // //   //     return;
// // //   //   }

// // //   //   final productInput = ProductEntity(
// // //   //     name: _titleController.text.trim(),
// // //   //     reviews: [],
// // //   //     price: double.tryParse(_priceController.text.trim()) ?? 0.0,
// // //   //     image: _pickedImage,
// // //   //     imageUrl: _imageUrl,
// // //   //     category: _catValue!,
// // //   //     productId: widget.isEdit ? widget.productEntity?.productId ?? '' : '',
// // //   //     isPiece: isPiece,
// // //   //   );

// // //   //   // ✅ هنا نضيف الـ debugPrint
// // //   //   debugPrint('_pickedImage: $_pickedImage');
// // //   //   debugPrint('_imageUrl: $_imageUrl');

// // //   //   final cubit = context.read<AddProductCubit>();
// // //   //   if (widget.isEdit) {
// // //   //     cubit.editProduct(productInput);
// // //   //   } else {
// // //   //     cubit.addProduct(productInput);
// // //   //   }

// // //   //   _clearForm();
// // //   // }
// // //   void _uploadForm() async {
// // //     if (!_formKey.currentState!.validate()) return;

// // //     // لو المستخدم كتب URL في TextField
// // //     if (_imageUrlController.text.trim().isNotEmpty) {
// // //       _imageUrl = _imageUrlController.text.trim();
// // //     }

// // //     // تحقق من وجود صورة (سواء من الجهاز أو URL)
// // //     if (_pickedImage == null && (_imageUrl == null || _imageUrl!.isEmpty)) {
// // //       GlobalMethods.showErrorORWarningDialog(
// // //         context: context,
// // //         subtitle: "Please pick or enter an image",
// // //         fct: () {},
// // //       );
// // //       return;
// // //     }

// // //     // تحقق من وجود فئة
// // //     if (_catValue == null || _catValue!.isEmpty) {
// // //       GlobalMethods.showErrorORWarningDialog(
// // //         context: context,
// // //         subtitle: "Please select a category",
// // //         fct: () {},
// // //       );
// // //       return;
// // //     }

// // //     final productInput = ProductEntity(
// // //       name: _titleController.text.trim(),
// // //       reviews: [],
// // //       price: double.tryParse(_priceController.text.trim()) ?? 0.0,
// // //       image: _pickedImage,
// // //       imageUrl: _imageUrl,
// // //       category: _catValue!,
// // //       productId: widget.isEdit ? widget.productEntity?.productId ?? '' : '',
// // //       isPiece: isPiece,
// // //       // 🆕 أضف الحقل
// // //       salePrice: _isOnSale ? _salePrice ?? 0.0 : 0.0,
// // //       isOnSale: _isOnSale,
// // //     );

// // //     // Debug
// // //     debugPrint('🔍 Picked Image: $_pickedImage');
// // //     debugPrint('🔍 Image URL: $_imageUrl');
// // //     debugPrint('🔍 On Sale: $_isOnSale , Sale Price: $_salePrice');

// // //     final cubit = context.read<AddProductCubit>();
// // //     if (widget.isEdit) {
// // //       cubit.editProduct(productInput);
// // //     } else {
// // //       cubit.addProduct(productInput);
// // //     }

// // //     _clearForm();
// // //   }

// // //   void _onCategoryChanged(String? category) {
// // //     setState(() {
// // //       _catValue = category;
// // //     });
// // //   }

// // //   void _clearForm() {
// // //     if (!widget.isEdit) {
// // //       _priceController.clear();
// // //       _titleController.clear();
// // //       _imageUrlController.clear();
// // //     }

// // //     setState(() {
// // //       isPiece = false;
// // //       _groupValue = 1;
// // //       _pickedImage = null;
// // //       _imageUrl = null;
// // //       webImage = Uint8List(8);
// // //       _isOnSale = false;
// // //       _salePrice = null;
// // //     });
// // //   }

// // //   // void _clearForm() {
// // //   //   isPiece = false;
// // //   //   _groupValue = 1;
// // //   //   _priceController.clear();
// // //   //   _titleController.clear();
// // //   //   _imageUrlController.clear();
// // //   //   setState(() {
// // //   //     _pickedImage = null;
// // //   //     _imageUrl = null;
// // //   //     webImage = Uint8List(8);
// // //   //   });
// // //   // }

// // //   Widget dottedBorder({required Color color}) {
// // //     return Padding(
// // //       padding: const EdgeInsets.all(8.0),
// // //       child: DottedBorder(
// // //         options: RectDottedBorderOptions(color: color),
// // //         child: Center(
// // //           child: Column(
// // //             mainAxisAlignment: MainAxisAlignment.center,
// // //             children: [
// // //               Icon(Icons.image_outlined, color: color, size: 50),
// // //               const SizedBox(height: 20),
// // //               TextButton(
// // //                 onPressed: _pickImage,
// // //                 child: const CustomText(
// // //                   text: 'Choose an image',
// // //                   color: Colors.blue,
// // //                 ),
// // //               ),
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     Size size = Utils(context).getScreenSize;

// // //     return Form(
// // //       key: _formKey,
// // //       child: Column(
// // //         crossAxisAlignment: CrossAxisAlignment.start,
// // //         children: [
// // //           /// Title
// // //           const CustomText(text: 'Product title*', isTitle: true),
// // //           const SizedBox(height: 10),
// // //           CustomTextFormField(
// // //             controller: _titleController,
// // //             key: const ValueKey('Title'),
// // //             validator: (value) =>
// // //                 value!.isEmpty ? 'Please enter a Title' : null,
// // //           ),
// // //           const SizedBox(height: 20),

// // //           /// Price + Category + Measure unit + Image
// // //           Row(
// // //             crossAxisAlignment: CrossAxisAlignment.start,
// // //             children: [
// // //               /// Left side form
// // //               Expanded(
// // //                 flex: 2,
// // //                 child: FittedBox(
// // //                   child: Column(
// // //                     crossAxisAlignment: CrossAxisAlignment.start,
// // //                     children: [
// // //                       /// Price
// // //                       const CustomText(text: 'Price in \$*', isTitle: true),
// // //                       const SizedBox(height: 10),
// // //                       SizedBox(
// // //                         width: 100,
// // //                         child: CustomTextFormField(
// // //                           controller: _priceController,
// // //                           key: const ValueKey('Price \$'),
// // //                           keyboardType: TextInputType.number,
// // //                           validator: (value) =>
// // //                               value!.isEmpty ? 'Price is required' : null,
// // //                           inputFormatters: <TextInputFormatter>[
// // //                             FilteringTextInputFormatter.allow(
// // //                               RegExp(r'[0-9.]'),
// // //                             ),
// // //                           ],
// // //                         ),
// // //                       ),
// // //                       const SizedBox(height: 20),

// // //                       /// Category
// // //                       const CustomText(
// // //                         text: 'Product category*',
// // //                         isTitle: true,
// // //                       ),
// // //                       const SizedBox(height: 10),
// // //                       DropdownButton<String>(
// // //                         hint: const Text('Select Category'),
// // //                         value: _catValue,
// // //                         items: AppConstants.categoryDropDownList,
// // //                         onChanged: _onCategoryChanged,
// // //                       ),

// // //                       const SizedBox(height: 20),
// // //                       // Row(
// // //                       //   children: [
// // //                       //     Checkbox(
// // //                       //       value: _isOnSale,
// // //                       //       onChanged: (val) =>
// // //                       //           setState(() => _isOnSale = val!),
// // //                       //     ),
// // //                       //     const Text("On Sale"),
// // //                       //   ],
// // //                       // ),
// // //                       // if (_isOnSale)
// // //                       //   TextFormField(
// // //                       //     initialValue: _salePrice?.toString(),
// // //                       //     keyboardType: TextInputType.number,
// // //                       //     decoration: const InputDecoration(
// // //                       //       labelText: "Sale Price",
// // //                       //     ),
// // //                       //     onChanged: (val) => _salePrice = double.tryParse(val),
// // //                       //   ),
// // //                       /// On Sale section
// // //                       Row(
// // //                         children: [
// // //                           Checkbox(
// // //                             value: _isOnSale,
// // //                             onChanged: (val) {
// // //                               setState(() => _isOnSale = val ?? false);
// // //                             },
// // //                           ),
// // //                           const Text("On Sale"),
// // //                         ],
// // //                       ),
// // //                       AnimatedSwitcher(
// // //                         duration: const Duration(seconds: 1),
// // //                         child:
// // //                             //  !_isOnSale
// // //                             //     ? Container()
// // //                             //     :
// // //                             Row(
// // //                               children: [
// // //                                 CustomText(
// // //                                   //    text: "wf",
// // //                                   text: "\$" + _salePrice.toStringAsFixed(2),
// // //                                 ),
// // //                                 const SizedBox(width: 10),
// // //                                 salePourcentageDropDownWidget(context),
// // //                               ],
// // //                             ),
// // //                       ),

// // //                       /// Sale Price field
// // //                       // if (_isOnSale)
// // //                       //   SizedBox(
// // //                       //     width:
// // //                       //         150, // ممكن تستبدلها بـ Expanded() لو تحب يتمدد
// // //                       //     child: TextFormField(
// // //                       //       initialValue: _salePrice?.toString(),
// // //                       //       keyboardType: TextInputType.number,
// // //                       //       decoration: const InputDecoration(
// // //                       //         labelText: "Sale Price",
// // //                       //         border: OutlineInputBorder(),
// // //                       //       ),
// // //                       //       onChanged: (val) =>
// // //                       //           _salePrice = double.tryParse(val),
// // //                       //     ),
// // //                       //   ),

// // //                       /// Measure Unit
// // //                       const CustomText(text: 'Measure unit*', isTitle: true),
// // //                       const SizedBox(height: 10),
// // //                       Row(
// // //                         children: [
// // //                           //  CustomText(text: "Kg"),
// // //                           Radio<int>(
// // //                             value: 1,
// // //                             groupValue: _groupValue,
// // //                             onChanged: (value) {
// // //                               setState(() {
// // //                                 _groupValue = value!;
// // //                                 isPiece = false;
// // //                               });
// // //                             },
// // //                             activeColor: Colors.green,
// // //                           ),
// // //                           const CustomText(text: 'KG'),
// // //                           const SizedBox(width: 20),
// // //                           Radio<int>(
// // //                             value: 2,
// // //                             groupValue: _groupValue,
// // //                             onChanged: (value) {
// // //                               setState(() {
// // //                                 _groupValue = value!;
// // //                                 isPiece = true;
// // //                               });
// // //                             },
// // //                             activeColor: Colors.green,
// // //                           ),
// // //                           const CustomText(text: 'Piece'),
// // //                         ],
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 ),
// // //               ),

// // //               /// Image preview
// // //               Expanded(
// // //                 flex: 4,
// // //                 child: Padding(
// // //                   padding: const EdgeInsets.all(8.0),
// // //                   child: Container(
// // //                     height: size.width > 650 ? 350 : size.width * 0.45,
// // //                     decoration: BoxDecoration(
// // //                       color: Theme.of(context).scaffoldBackgroundColor,
// // //                       borderRadius: BorderRadius.circular(12.0),
// // //                     ),
// // //                     child: (_imageUrl != null && _imageUrl!.isNotEmpty)
// // //                         ? Image.network(_imageUrl!, fit: BoxFit.fill)
// // //                         : (_pickedImage != null
// // //                               ? (kIsWeb
// // //                                     ? Image.memory(webImage, fit: BoxFit.fill)
// // //                                     : Image.file(
// // //                                         File(_pickedImage!.path),
// // //                                         fit: BoxFit.fill,
// // //                                       ))
// // //                               : dottedBorder(
// // //                                   color: Theme.of(context).primaryColor,
// // //                                 )),
// // //                   ),
// // //                 ),
// // //               ),

// // //               /// Clear & Update image buttons
// // //               Expanded(
// // //                 flex: 1,
// // //                 child: FittedBox(
// // //                   child: Column(
// // //                     mainAxisAlignment: MainAxisAlignment.center,
// // //                     children: [
// // //                       TextButton(
// // //                         onPressed: _clearForm,
// // //                         child: const CustomText(
// // //                           text: 'Clear',
// // //                           color: Colors.red,
// // //                         ),
// // //                       ),
// // //                       TextButton(
// // //                         onPressed: _pickImage,
// // //                         child: const CustomText(
// // //                           text: 'Upload from Device',
// // //                           color: Colors.blue,
// // //                         ),
// // //                       ),
// // //                       TextButton(
// // //                         onPressed: _addImageFromUrl,
// // //                         child: const CustomText(
// // //                           text: 'Add from URL',
// // //                           color: Colors.orange,
// // //                         ),
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 ),
// // //               ),
// // //             ],
// // //           ),

// // //           /// Bottom buttons
// // //           Padding(
// // //             padding: const EdgeInsets.all(18.0),
// // //             child: Row(
// // //               mainAxisAlignment: MainAxisAlignment.spaceAround,
// // //               children: [
// // //                 ButtonsWidget(
// // //                   onPressed: _clearForm,
// // //                   text: 'Clear form',
// // //                   icon: IconlyBold.danger,
// // //                   backgroundColor: Colors.red.shade300,
// // //                 ),
// // //                 ButtonsWidget(
// // //                   onPressed: _uploadForm,
// // //                   text: 'Upload',
// // //                   icon: IconlyBold.upload,
// // //                   backgroundColor: Colors.blue,
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }

// // // DropdownButtonHideUnderline salePourcentageDropDownWidget(Color color) {
// // //   return DropdownButtonHideUnderline(
// // //     child: DropdownButton<String>(
// // //       style: TextStyle(color: color),
// // //       items: const [
// // //         DropdownMenuItem<String>(child: Text('10%'), value: '10'),
// // //         DropdownMenuItem<String>(child: Text('15%'), value: '15'),
// // //         DropdownMenuItem<String>(child: Text('25%'), value: '25'),
// // //         DropdownMenuItem<String>(child: Text('50%'), value: '50'),
// // //         DropdownMenuItem<String>(child: Text('75%'), value: '75'),
// // //         DropdownMenuItem<String>(child: Text('0%'), value: '0'),
// // //       ],
// // //       onChanged: (value) {
// // //         if (value == '0') {
// // //           return;
// // //         } else {
// // //           setState(() {
// // //             _salePercent = value;
// // //             _salePrice =
// // //                 double.parse(widget.price) -
// // //                 (double.parse(value!) * double.parse(widget.price) / 100);
// // //           });
// // //         }
// // //       },
// // //       // hint: Text(_salePercent ?? percToShow),
// // //       // value: _salePercent,
// // //     ),
// // //   );
// // // }

// // import 'dart:io';
// // import 'dart:typed_data';

// // import 'package:dotted_border/dotted_border.dart';
// // import 'package:flutter/foundation.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:grocery_app_dashboard/core/constants/app_constants.dart';
// // import 'package:grocery_app_dashboard/core/cubits/add_product_cubit/add_product_cubit.dart';
// // import 'package:grocery_app_dashboard/core/entites/product_entity.dart';
// // import 'package:grocery_app_dashboard/core/helper/functions/global_methods.dart';
// // import 'package:grocery_app_dashboard/core/utils/utils.dart';
// // import 'package:grocery_app_dashboard/features/dash_bord/presentation/widgets/buttons.dart';
// // import 'package:grocery_app_dashboard/features/dash_bord/presentation/widgets/custom_text.dart';
// // import 'package:grocery_app_dashboard/features/dash_bord/presentation/widgets/custom_text_form_field.dart';
// // import 'package:iconly/iconly.dart';
// // import 'package:image_picker/image_picker.dart';

// // class AddProductViewForm extends StatefulWidget {
// //   const AddProductViewForm({
// //     super.key,
// //     required this.isEdit,
// //     this.productEntity,
// //   });

// //   final bool isEdit;
// //   final ProductEntity? productEntity;

// //   @override
// //   State<AddProductViewForm> createState() => _AddProductViewFormState();
// // }

// // class _AddProductViewFormState extends State<AddProductViewForm> {
// //   final _formKey = GlobalKey<FormState>();
// //   String? _catValue = 'Vegetables';
// //   late final TextEditingController _titleController, _priceController;
// //   int _groupValue = 1;
// //   bool isPiece = false;
// //   bool _isOnSale = false;
// //   double? _salePrice;
// //   XFile? _pickedImage;
// //   Uint8List webImage = Uint8List(8);
// //   String? _imageUrl;
// //   final TextEditingController _imageUrlController = TextEditingController();
// //   late String percToShow;

// //   // @override
// //   // void initState() {
// //   //   _priceController = TextEditingController(
// //   //     text: widget.productEntity?.price.toString() ?? '',
// //   //   );
// //   //   _titleController = TextEditingController(
// //   //     text: widget.productEntity?.name ?? '',
// //   //   );

// //   //   _salePrice = widget.productEntity?.salePrice;
// //   //   _catValue = widget.productEntity?.category ?? 'Vegetables';
// //   //   _isOnSale = widget.productEntity?.isOnSale ?? false;
// //   //   isPiece = widget.productEntity?.isPiece ?? false;
// //   //   _imageUrl = widget.productEntity?.imageUrl;

// //   //   if (_isOnSale && _salePrice != null && widget.productEntity != null) {
// //   //     percToShow =
// //   //         (100 - ((_salePrice! * 100) / widget.productEntity!.price))
// //   //             .toStringAsFixed(1) +
// //   //         '%';
// //   //   } else {
// //   //     percToShow = '0%';
// //   //   }

// //   //   super.initState();
// //   // }

// //   // @override
// //   // void dispose() {
// //   //   if (mounted) {
// //   //     _priceController.dispose();
// //   //     _titleController.dispose();
// //   //     _imageUrlController.dispose();
// //   //   }
// //   //   super.dispose();
// //   // }
// //   @override
// //   void initState() {
// //     super.initState();

// //     _priceController = TextEditingController(
// //       text: widget.productEntity?.price.toString() ?? '',
// //     );
// //     _titleController = TextEditingController(
// //       text: widget.productEntity?.name ?? '',
// //     );

// //     _salePrice = widget.productEntity?.salePrice;
// //     _catValue = widget.productEntity?.category ?? 'Vegetables';
// //     _isOnSale = widget.productEntity?.isOnSale ?? false;
// //     isPiece = widget.productEntity?.isPiece ?? false;
// //     _imageUrl = widget.productEntity?.imageUrl;

// //     if (_isOnSale && _salePrice != null && widget.productEntity != null) {
// //       percToShow =
// //           (100 - ((_salePrice! * 100) / widget.productEntity!.price))
// //               .toStringAsFixed(1) +
// //           '%';
// //     } else {
// //       percToShow = '0%';
// //     }

// //     // 👇 إذا كان تعديل + OnSale نسمع لتغيير السعر
// //     if (widget.isEdit && _isOnSale) {
// //       _priceController.addListener(_updateSalePriceWhenPriceChanges);
// //     }
// //   }

// //   void _updateSalePriceWhenPriceChanges() {
// //     if (!_isOnSale) return;

// //     final price = double.tryParse(_priceController.text) ?? 0.0;
// //     if (price <= 0) return;

// //     // نستخرج النسبة من percToShow (مثلاً "20%")
// //     final perc = double.tryParse(percToShow.replaceAll('%', '')) ?? 0;
// //     if (perc > 0) {
// //       setState(() {
// //         _salePrice = price - (price * perc / 100);
// //       });
// //     }
// //   }

// //   @override
// //   void dispose() {
// //     _priceController.removeListener(_updateSalePriceWhenPriceChanges);
// //     _priceController.dispose();
// //     _titleController.dispose();
// //     _imageUrlController.dispose();
// //     super.dispose();
// //   }

// //   Future<void> _pickImage() async {
// //     final ImagePicker picker = ImagePicker();
// //     XFile? image = await picker.pickImage(source: ImageSource.gallery);
// //     if (image != null) {
// //       if (kIsWeb) {
// //         var f = await image.readAsBytes();
// //         setState(() {
// //           webImage = f;
// //           _pickedImage = image;
// //           _imageUrl = null;
// //           _imageUrlController.clear();
// //         });
// //       } else {
// //         setState(() {
// //           _pickedImage = image;
// //           _imageUrl = null;
// //           _imageUrlController.clear();
// //         });
// //       }
// //     }
// //   }

// //   void _addImageFromUrl() {
// //     showDialog(
// //       context: context,
// //       builder: (ctx) => AlertDialog(
// //         title: const Text("Add Image from URL"),
// //         content: TextField(
// //           controller: _imageUrlController,
// //           decoration: const InputDecoration(hintText: "Enter image URL"),
// //         ),
// //         actions: [
// //           TextButton(
// //             onPressed: () {
// //               Navigator.pop(ctx);
// //             },
// //             child: const Text("Cancel"),
// //           ),
// //           ElevatedButton(
// //             onPressed: () {
// //               if (_imageUrlController.text.trim().isEmpty) return;
// //               setState(() {
// //                 _imageUrl = _imageUrlController.text.trim();
// //                 _pickedImage = null;
// //               });
// //               Navigator.pop(ctx);
// //             },
// //             child: const Text("Add"),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   void _uploadForm() async {
// //     if (!_formKey.currentState!.validate()) return;

// //     if (_imageUrlController.text.trim().isNotEmpty) {
// //       _imageUrl = _imageUrlController.text.trim();
// //     }

// //     if (_pickedImage == null && (_imageUrl == null || _imageUrl!.isEmpty)) {
// //       GlobalMethods.showErrorORWarningDialog(
// //         context: context,
// //         subtitle: "Please pick or enter an image",
// //         fct: () {},
// //       );
// //       return;
// //     }

// //     if (_catValue == null || _catValue!.isEmpty) {
// //       GlobalMethods.showErrorORWarningDialog(
// //         context: context,
// //         subtitle: "Please select a category",
// //         fct: () {},
// //       );
// //       return;
// //     }

// //     final productInput = ProductEntity(
// //       name: _titleController.text.trim(),
// //       reviews: [],
// //       price: double.tryParse(_priceController.text.trim()) ?? 0.0,
// //       image: _pickedImage,
// //       imageUrl: _imageUrl,
// //       category: _catValue!,
// //       productId: widget.isEdit ? widget.productEntity?.productId ?? '' : '',
// //       isPiece: isPiece,
// //       salePrice: _isOnSale ? _salePrice ?? 0.0 : 0.0,
// //       isOnSale: _isOnSale,
// //     );

// //     debugPrint('🔍 Picked Image: $_pickedImage');
// //     debugPrint('🔍 Image URL: $_imageUrl');
// //     debugPrint('🔍 On Sale: $_isOnSale , Sale Price: $_salePrice');

// //     final cubit = context.read<AddProductCubit>();
// //     if (widget.isEdit) {
// //       cubit.editProduct(productInput);
// //     } else {
// //       cubit.addProduct(productInput);
// //     }

// //     _clearForm();
// //   }

// //   void _onCategoryChanged(String? category) {
// //     setState(() {
// //       _catValue = category;
// //     });
// //   }

// //   void _clearForm() {
// //     if (!widget.isEdit) {
// //       _priceController.clear();
// //       _titleController.clear();
// //       _imageUrlController.clear();
// //     }

// //     setState(() {
// //       isPiece = false;
// //       _groupValue = 1;
// //       _pickedImage = null;
// //       _imageUrl = null;
// //       webImage = Uint8List(8);
// //       _isOnSale = false;
// //       _salePrice = null;
// //       percToShow = '0%';
// //     });
// //   }

// //   Widget dottedBorder({required Color color}) {
// //     return Padding(
// //       padding: const EdgeInsets.all(8.0),
// //       child: DottedBorder(
// //         //  options: CircularDottedBorderOptions(color: Colors.purple)),
// //         child: Center(
// //           child: Column(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               Icon(Icons.image_outlined, color: color, size: 50),
// //               const SizedBox(height: 20),
// //               TextButton(
// //                 onPressed: _pickImage,
// //                 child: const CustomText(
// //                   text: 'Choose an image',
// //                   color: Colors.blue,
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     Size size = Utils(context).getScreenSize;

// //     return Form(
// //       key: _formKey,
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           const CustomText(text: 'Product title*', isTitle: true),
// //           const SizedBox(height: 10),
// //           CustomTextFormField(
// //             controller: _titleController,
// //             key: const ValueKey('Title'),
// //             validator: (value) =>
// //                 value!.isEmpty ? 'Please enter a Title' : null,
// //           ),
// //           const SizedBox(height: 20),

// //           Row(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Expanded(
// //                 flex: 2,
// //                 child: FittedBox(
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       const CustomText(text: 'Price in \$*', isTitle: true),
// //                       const SizedBox(height: 10),
// //                       SizedBox(
// //                         width: 100,
// //                         child: CustomTextFormField(
// //                           controller: _priceController,
// //                           key: const ValueKey('Price \$'),
// //                           keyboardType: TextInputType.number,
// //                           validator: (value) =>
// //                               value!.isEmpty ? 'Price is required' : null,
// //                           inputFormatters: <TextInputFormatter>[
// //                             FilteringTextInputFormatter.allow(
// //                               RegExp(r'[0-9.]'),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                       const SizedBox(height: 20),

// //                       const CustomText(
// //                         text: 'Product category*',
// //                         isTitle: true,
// //                       ),
// //                       const SizedBox(height: 10),
// //                       DropdownButton<String>(
// //                         hint: const Text('Select Category'),
// //                         value: _catValue,
// //                         items: AppConstants.categoryDropDownList,
// //                         onChanged: _onCategoryChanged,
// //                       ),
// //                       const SizedBox(height: 20),

// //                       Row(
// //                         children: [
// //                           Checkbox(
// //                             value: _isOnSale,
// //                             onChanged: (val) {
// //                               setState(() => _isOnSale = val ?? false);
// //                             },
// //                           ),
// //                           const Text("On Sale"),
// //                         ],
// //                       ),
// //                       AnimatedSwitcher(
// //                         duration: const Duration(milliseconds: 300),
// //                         child: !_isOnSale
// //                             ? const SizedBox.shrink()
// //                             : Row(
// //                                 children: [
// //                                   CustomText(
// //                                     text:
// //                                         "\$" +
// //                                         (_salePrice ?? 0.0).toStringAsFixed(2),
// //                                   ),
// //                                   const SizedBox(width: 10),
// //                                   salePourcentageDropDownWidget(context),
// //                                 ],
// //                               ),
// //                       ),

// //                       const CustomText(text: 'Measure unit*', isTitle: true),
// //                       const SizedBox(height: 10),
// //                       Row(
// //                         children: [
// //                           Radio<int>(
// //                             value: 1,
// //                             groupValue: _groupValue,
// //                             onChanged: (value) {
// //                               setState(() {
// //                                 _groupValue = value!;
// //                                 isPiece = false;
// //                               });
// //                             },
// //                             activeColor: Colors.green,
// //                           ),
// //                           const CustomText(text: 'KG'),
// //                           const SizedBox(width: 20),
// //                           Radio<int>(
// //                             value: 2,
// //                             groupValue: _groupValue,
// //                             onChanged: (value) {
// //                               setState(() {
// //                                 _groupValue = value!;
// //                                 isPiece = true;
// //                               });
// //                             },
// //                             activeColor: Colors.green,
// //                           ),
// //                           const CustomText(text: 'Piece'),
// //                         ],
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),

// //               Expanded(
// //                 flex: 4,
// //                 child: Padding(
// //                   padding: const EdgeInsets.all(8.0),
// //                   child: Container(
// //                     height: size.width > 650 ? 350 : size.width * 0.45,
// //                     decoration: BoxDecoration(
// //                       color: Theme.of(context).scaffoldBackgroundColor,
// //                       borderRadius: BorderRadius.circular(12.0),
// //                     ),
// //                     child: (_imageUrl != null && _imageUrl!.isNotEmpty)
// //                         ? Image.network(_imageUrl!, fit: BoxFit.fill)
// //                         : (_pickedImage != null
// //                               ? (kIsWeb
// //                                     ? Image.memory(webImage, fit: BoxFit.fill)
// //                                     : Image.file(
// //                                         File(_pickedImage!.path),
// //                                         fit: BoxFit.fill,
// //                                       ))
// //                               : dottedBorder(
// //                                   color: Theme.of(context).primaryColor,
// //                                 )),
// //                   ),
// //                 ),
// //               ),

// //               Expanded(
// //                 flex: 1,
// //                 child: FittedBox(
// //                   child: Column(
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     children: [
// //                       TextButton(
// //                         onPressed: _clearForm,
// //                         child: const CustomText(
// //                           text: 'Clear',
// //                           color: Colors.red,
// //                         ),
// //                       ),
// //                       TextButton(
// //                         onPressed: _pickImage,
// //                         child: const CustomText(
// //                           text: 'Upload from Device',
// //                           color: Colors.blue,
// //                         ),
// //                       ),
// //                       TextButton(
// //                         onPressed: _addImageFromUrl,
// //                         child: const CustomText(
// //                           text: 'Add from URL',
// //                           color: Colors.orange,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),

// //           Padding(
// //             padding: const EdgeInsets.all(18.0),
// //             child: Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceAround,
// //               children: [
// //                 ButtonsWidget(
// //                   onPressed: _clearForm,
// //                   text: 'Clear form',
// //                   icon: IconlyBold.danger,
// //                   backgroundColor: Colors.red.shade300,
// //                 ),
// //                 ButtonsWidget(
// //                   onPressed: _uploadForm,
// //                   text: 'Upload',
// //                   icon: IconlyBold.upload,
// //                   backgroundColor: Colors.blue,
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   DropdownButtonHideUnderline salePourcentageDropDownWidget(
// //     BuildContext context,
// //   ) {
// //     final color = Theme.of(context).primaryColor;

// //     return DropdownButtonHideUnderline(
// //       child: DropdownButton<String>(
// //         style: TextStyle(color: color),
// //         items: const [
// //           DropdownMenuItem<String>(child: Text('10%'), value: '10'),
// //           DropdownMenuItem<String>(child: Text('15%'), value: '15'),
// //           DropdownMenuItem<String>(child: Text('25%'), value: '25'),
// //           DropdownMenuItem<String>(child: Text('50%'), value: '50'),
// //           DropdownMenuItem<String>(child: Text('75%'), value: '75'),
// //           DropdownMenuItem<String>(child: Text('0%'), value: '0'),
// //         ],
// //         onChanged: (value) {
// //           if (value == null || value == '0') return;

// //           setState(() {
// //             final price = double.tryParse(_priceController.text) ?? 0.0;
// //             _salePrice = price - (price * double.parse(value) / 100);
// //             percToShow = value + '%';
// //           });
// //         },
// //         hint: Text(percToShow),
// //       ),
// //     );
// //   }
// // }

// import 'dart:io';
// import 'dart:typed_data';

// import 'package:dotted_border/dotted_border.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:grocery_app_dashboard/core/constants/app_constants.dart';
// import 'package:grocery_app_dashboard/core/cubits/add_product_cubit/add_product_cubit.dart';
// import 'package:grocery_app_dashboard/core/entites/product_entity.dart';
// import 'package:grocery_app_dashboard/core/helper/functions/global_methods.dart';
// import 'package:grocery_app_dashboard/core/utils/utils.dart';
// import 'package:grocery_app_dashboard/features/dash_bord/presentation/widgets/buttons.dart';
// import 'package:grocery_app_dashboard/features/dash_bord/presentation/widgets/custom_text.dart';
// import 'package:grocery_app_dashboard/features/dash_bord/presentation/widgets/custom_text_form_field.dart';
// import 'package:iconly/iconly.dart';
// import 'package:image_picker/image_picker.dart';

// class AddProductViewForm extends StatefulWidget {
//   const AddProductViewForm({
//     super.key,
//     required this.isEdit,
//     this.productEntity,
//   });

//   final bool isEdit;
//   final ProductEntity? productEntity;

//   @override
//   State<AddProductViewForm> createState() => _AddProductViewFormState();
// }

// class _AddProductViewFormState extends State<AddProductViewForm> {
//   final _formKey = GlobalKey<FormState>();
//   String? _catValue = 'Vegetables';
//   late final TextEditingController _titleController, _priceController;
//   int _groupValue = 1;
//   bool isPiece = false;
//   bool _isOnSale = false;
//   double? _salePrice;
//   XFile? _pickedImage;
//   Uint8List webImage = Uint8List(8);
//   String? _imageUrl;
//   final TextEditingController _imageUrlController = TextEditingController();
//   late String percToShow;

//   @override
//   void initState() {
//     super.initState();

//     _priceController = TextEditingController(
//       text: widget.productEntity?.price.toString() ?? '',
//     );
//     _titleController = TextEditingController(
//       text: widget.productEntity?.name ?? '',
//     );

//     _salePrice = widget.productEntity?.salePrice;
//     _catValue = widget.productEntity?.category ?? 'Vegetables';
//     _isOnSale = widget.productEntity?.isOnSale ?? false;
//     isPiece = widget.productEntity?.isPiece ?? false;
//     _imageUrl = widget.productEntity?.imageUrl;

//     if (_isOnSale && _salePrice != null && widget.productEntity != null) {
//       percToShow =
//           (100 - ((_salePrice! * 100) / widget.productEntity!.price))
//               .toStringAsFixed(1) +
//           '%';
//     } else {
//       percToShow = '0%';
//     }

//     // 👇 إذا كنا في وضع تعديل نضيف listener دائماً على السعر
//     // هذا يسمح بإعادة حساب salePrice متى ما تغير السعر أثناء الـ edit
//     if (widget.isEdit) {
//       _priceController.addListener(_updateSalePriceWhenPriceChanges);
//     }
//   }

//   void _updateSalePriceWhenPriceChanges() {
//     final price = double.tryParse(_priceController.text) ?? 0.0;

//     // إذا صار السعر صفر أو أقل: نلغّي الـ OnSale ونمسح قيمة الخصم
//     if (price <= 0) {
//       if (_isOnSale || (_salePrice != null && _salePrice != 0)) {
//         setState(() {
//           _isOnSale = false;
//           _salePrice = null;
//           percToShow = '0%';
//         });
//       }
//       return;
//     }

//     // إذا ليس عليه خصم الآن لا نفعل إعادة الحساب (إلا عند السعر صفر الذي تعاملنا معه فوق)
//     if (!_isOnSale) return;

//     // نعيد حساب salePrice بناءً على percToShow الحالية
//     final perc = double.tryParse(percToShow.replaceAll('%', '')) ?? 0;
//     if (perc > 0) {
//       setState(() {
//         _salePrice = price - (price * perc / 100);
//       });
//     }
//   }

//   @override
//   void dispose() {
//     // نزيل الـ listener لو اضفناه
//     _priceController.removeListener(_updateSalePriceWhenPriceChanges);
//     _priceController.dispose();
//     _titleController.dispose();
//     _imageUrlController.dispose();
//     super.dispose();
//   }

//   Future<void> _pickImage() async {
//     final ImagePicker picker = ImagePicker();
//     XFile? image = await picker.pickImage(source: ImageSource.gallery);
//     if (image != null) {
//       if (kIsWeb) {
//         var f = await image.readAsBytes();
//         setState(() {
//           webImage = f;
//           _pickedImage = image;
//           _imageUrl = null;
//           _imageUrlController.clear();
//         });
//       } else {
//         setState(() {
//           _pickedImage = image;
//           _imageUrl = null;
//           _imageUrlController.clear();
//         });
//       }
//     }
//   }

//   void _addImageFromUrl() {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text("Add Image from URL"),
//         content: TextField(
//           controller: _imageUrlController,
//           decoration: const InputDecoration(hintText: "Enter image URL"),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(ctx);
//             },
//             child: const Text("Cancel"),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               if (_imageUrlController.text.trim().isEmpty) return;
//               setState(() {
//                 _imageUrl = _imageUrlController.text.trim();
//                 _pickedImage = null;
//               });
//               Navigator.pop(ctx);
//             },
//             child: const Text("Add"),
//           ),
//         ],
//       ),
//     );
//   }

//   void _uploadForm() async {
//     if (!_formKey.currentState!.validate()) return;

//     if (_imageUrlController.text.trim().isNotEmpty) {
//       _imageUrl = _imageUrlController.text.trim();
//     }

//     if (_pickedImage == null && (_imageUrl == null || _imageUrl!.isEmpty)) {
//       GlobalMethods.showErrorORWarningDialog(
//         context: context,
//         subtitle: "Please pick or enter an image",
//         fct: () {},
//       );
//       return;
//     }

//     if (_catValue == null || _catValue!.isEmpty) {
//       GlobalMethods.showErrorORWarningDialog(
//         context: context,
//         subtitle: "Please select a category",
//         fct: () {},
//       );
//       return;
//     }

//     final productInput = ProductEntity(
//       name: _titleController.text.trim(),
//       reviews: [],
//       price: double.tryParse(_priceController.text.trim()) ?? 0.0,
//       image: _pickedImage,
//       imageUrl: _imageUrl,
//       category: _catValue!,
//       productId: widget.isEdit ? widget.productEntity?.productId ?? '' : '',
//       isPiece: isPiece,
//       salePrice: _isOnSale ? _salePrice ?? 0.0 : 0.0,
//       isOnSale: _isOnSale,
//     );

//     debugPrint('🔍 Picked Image: $_pickedImage');
//     debugPrint('🔍 Image URL: $_imageUrl');
//     debugPrint('🔍 On Sale: $_isOnSale , Sale Price: $_salePrice');

//     final cubit = context.read<AddProductCubit>();
//     if (widget.isEdit) {
//       cubit.editProduct(productInput);
//     } else {
//       cubit.addProduct(productInput);
//     }

//     _clearForm();
//   }

//   void _onCategoryChanged(String? category) {
//     setState(() {
//       _catValue = category;
//     });
//   }

//   void _clearForm() {
//     if (!widget.isEdit) {
//       _priceController.clear();
//       _titleController.clear();
//       _imageUrlController.clear();
//     }

//     setState(() {
//       isPiece = false;
//       _groupValue = 1;
//       _pickedImage = null;
//       _imageUrl = null;
//       webImage = Uint8List(8);
//       _isOnSale = false;
//       _salePrice = null;
//       percToShow = '0%';
//     });
//   }

//   Widget dottedBorder({required Color color}) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: DottedBorder(
//         //  options: CircularDottedBorderOptions(color: Colors.purple)),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.image_outlined, color: color, size: 50),
//               const SizedBox(height: 20),
//               TextButton(
//                 onPressed: _pickImage,
//                 child: const CustomText(
//                   text: 'Choose an image',
//                   color: Colors.blue,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     Size size = Utils(context).getScreenSize;

//     return Form(
//       key: _formKey,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const CustomText(text: 'Product title*', isTitle: true),
//           const SizedBox(height: 10),
//           CustomTextFormField(
//             controller: _titleController,
//             key: const ValueKey('Title'),
//             validator: (value) =>
//                 value!.isEmpty ? 'Please enter a Title' : null,
//           ),
//           const SizedBox(height: 20),

//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 flex: 2,
//                 child: FittedBox(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const CustomText(text: 'Price in \$*', isTitle: true),
//                       const SizedBox(height: 10),
//                       SizedBox(
//                         width: 100,
//                         child: CustomTextFormField(
//                           controller: _priceController,
//                           key: const ValueKey('Price \$'),
//                           keyboardType: TextInputType.number,
//                           validator: (value) =>
//                               value!.isEmpty ? 'Price is required' : null,
//                           inputFormatters: <TextInputFormatter>[
//                             FilteringTextInputFormatter.allow(
//                               RegExp(r'[0-9.]'),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 20),

//                       const CustomText(
//                         text: 'Product category*',
//                         isTitle: true,
//                       ),
//                       const SizedBox(height: 10),
//                       DropdownButton<String>(
//                         hint: const Text('Select Category'),
//                         value: _catValue,
//                         items: AppConstants.categoryDropDownList,
//                         onChanged: _onCategoryChanged,
//                       ),
//                       const SizedBox(height: 20),

//                       Row(
//                         children: [
//                           Checkbox(
//                             value: _isOnSale,
//                             onChanged: (val) {
//                               final price =
//                                   double.tryParse(_priceController.text) ?? 0.0;
//                               // منع تفعيل OnSale اذا السعر صفر أو <=0
//                               if (val == true && price <= 0) {
//                                 GlobalMethods.showErrorORWarningDialog(
//                                   context: context,
//                                   subtitle:
//                                       "Price must be greater than 0 to mark product On Sale",
//                                   fct: () {},
//                                 );
//                                 return;
//                               }
//                               setState(() {
//                                 _isOnSale = val ?? false;
//                                 if (!_isOnSale) {
//                                   _salePrice = null;
//                                   percToShow = '0%';
//                                 } else {
//                                   // لو فعّلنا OnSale بدون قيمة سابقة للخصم، خليه يساوي السعر كقيمة ابتدائية
//                                   final p =
//                                       double.tryParse(_priceController.text) ??
//                                       0.0;
//                                   if (_salePrice == null) _salePrice = p;
//                                 }
//                               });
//                             },
//                           ),
//                           const Text("On Sale"),
//                         ],
//                       ),
//                       AnimatedSwitcher(
//                         duration: const Duration(milliseconds: 300),
//                         child: !_isOnSale
//                             ? const SizedBox.shrink()
//                             : Row(
//                                 children: [
//                                   CustomText(
//                                     text:
//                                         "\$" +
//                                         (_salePrice ?? 0.0).toStringAsFixed(2),
//                                   ),
//                                   const SizedBox(width: 10),
//                                   salePourcentageDropDownWidget(context),
//                                 ],
//                               ),
//                       ),

//                       const CustomText(text: 'Measure unit*', isTitle: true),
//                       const SizedBox(height: 10),
//                       Row(
//                         children: [
//                           Radio<int>(
//                             value: 1,
//                             groupValue: _groupValue,
//                             onChanged: (value) {
//                               setState(() {
//                                 _groupValue = value!;
//                                 isPiece = false;
//                               });
//                             },
//                             activeColor: Colors.green,
//                           ),
//                           const CustomText(text: 'KG'),
//                           const SizedBox(width: 20),
//                           Radio<int>(
//                             value: 2,
//                             groupValue: _groupValue,
//                             onChanged: (value) {
//                               setState(() {
//                                 _groupValue = value!;
//                                 isPiece = true;
//                               });
//                             },
//                             activeColor: Colors.green,
//                           ),
//                           const CustomText(text: 'Piece'),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               Expanded(
//                 flex: 4,
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Container(
//                     height: size.width > 650 ? 350 : size.width * 0.45,
//                     decoration: BoxDecoration(
//                       color: Theme.of(context).scaffoldBackgroundColor,
//                       borderRadius: BorderRadius.circular(12.0),
//                     ),
//                     child: (_imageUrl != null && _imageUrl!.isNotEmpty)
//                         ? Image.network(_imageUrl!, fit: BoxFit.fill)
//                         : (_pickedImage != null
//                               ? (kIsWeb
//                                     ? Image.memory(webImage, fit: BoxFit.fill)
//                                     : Image.file(
//                                         File(_pickedImage!.path),
//                                         fit: BoxFit.fill,
//                                       ))
//                               : dottedBorder(
//                                   color: Theme.of(context).primaryColor,
//                                 )),
//                   ),
//                 ),
//               ),

//               Expanded(
//                 flex: 1,
//                 child: FittedBox(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       TextButton(
//                         onPressed: _clearForm,
//                         child: const CustomText(
//                           text: 'Clear',
//                           color: Colors.red,
//                         ),
//                       ),
//                       TextButton(
//                         onPressed: _pickImage,
//                         child: const CustomText(
//                           text: 'Upload from Device',
//                           color: Colors.blue,
//                         ),
//                       ),
//                       TextButton(
//                         onPressed: _addImageFromUrl,
//                         child: const CustomText(
//                           text: 'Add from URL',
//                           color: Colors.orange,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),

//           Padding(
//             padding: const EdgeInsets.all(18.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 ButtonsWidget(
//                   onPressed: _clearForm,
//                   text: 'Clear form',
//                   icon: IconlyBold.danger,
//                   backgroundColor: Colors.red.shade300,
//                 ),
//                 ButtonsWidget(
//                   onPressed: _uploadForm,
//                   text: 'Upload',
//                   icon: IconlyBold.upload,
//                   backgroundColor: Colors.blue,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   DropdownButtonHideUnderline salePourcentageDropDownWidget(
//     BuildContext context,
//   ) {
//     final color = Theme.of(context).primaryColor;

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
//           if (value == null || value == '0') return;

//           setState(() {
//             final price = double.tryParse(_priceController.text) ?? 0.0;
//             _salePrice = price - (price * double.parse(value) / 100);
//             percToShow = value + '%';
//           });
//         },
//         hint: Text(percToShow),
//       ),
//     );
//   }
// }
