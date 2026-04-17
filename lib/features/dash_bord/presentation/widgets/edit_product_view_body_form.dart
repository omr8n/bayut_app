// class EditProductViewBodyForm extends StatefulWidget {
//   const EditProductViewBodyForm({super.key});

//   @override
//   State<EditProductViewBodyForm> createState() =>
//       _EditProductViewBodyFormState();
// }

// class _EditProductViewBodyFormState extends State<EditProductViewBodyForm> {
//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _formKey,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           CustomText(text: 'Product title*', isTitle: true),
//           const SizedBox(height: 10),
//           TextFormField(
//             // controller: _titleController,
//             key: const ValueKey('Title'),
//             validator: (value) {
//               if (value!.isEmpty) {
//                 return 'Please enter a Title';
//               }
//               return null;
//             },
//             decoration: inputDecoration,
//           ),
//           const SizedBox(height: 20),
//           Row(
//             children: [
//               Expanded(
//                 flex: 1,
//                 child: FittedBox(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       CustomText(text: 'Price in \$*', isTitle: true),
//                       const SizedBox(height: 10),
//                       SizedBox(
//                         width: 100,
//                         child: TextFormField(
//                           // controller: _priceController,
//                           key: const ValueKey('Price \$'),
//                           keyboardType: TextInputType.number,
//                           validator: (value) {
//                             if (value!.isEmpty) {
//                               return 'Price is missed';
//                             }
//                             return null;
//                           },
//                           inputFormatters: <TextInputFormatter>[
//                             FilteringTextInputFormatter.allow(
//                               RegExp(r'[0-9.]'),
//                             ),
//                           ],
//                           decoration: inputDecoration,
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       CustomText(text: 'Porduct category*', isTitle: true),
//                       const SizedBox(height: 10),
//                       Container(
//                         //   color: _scaffoldColor,
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 8),
//                           child: catDropDownWidget(),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       CustomText(text: 'Measure unit*', isTitle: true),
//                       const SizedBox(height: 10),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           CustomText(text: 'Kg'),
//                           Radio(
//                             //   value: 1,
//                             //   groupValue: val,
//                             //   onChanged: (value) {
//                             //     setState(() {
//                             //     //  val = 1;
//                             //  //     _isPiece = false;
//                             //     });
//                             //   },
//                             activeColor: Colors.green,
//                             value: 1,
//                           ),
//                           CustomText(text: 'Piece'),
//                           Radio(
//                             value: 2,
//                             // groupValue: val,
//                             // onChanged: (value) {
//                             //   setState(() {
//                             //     val = 2;
//                             //     _isPiece = true;
//                             //   });
//                             // },
//                             activeColor: Colors.green,
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 15),
//                       Row(
//                         children: [
//                           // Checkbox(
//                           //   value: _isOnSale,
//                           //   onChanged: (newValue) {
//                           //     setState(() {
//                           //    //   _isOnSale = newValue!;
//                           //     });
//                           //   },
//                           // ),
//                           const SizedBox(width: 5),
//                           CustomText(text: 'Sale', isTitle: true),
//                         ],
//                       ),
//                       const SizedBox(height: 5),
//                       AnimatedSwitcher(
//                         duration: const Duration(seconds: 1),
//                         child:
//                             //  !_isOnSale
//                             //     ? Container()
//                             //     :
//                             Row(
//                               children: [
//                                 CustomText(
//                                   text: "wf",
//                                   //    "\$" +
//                                   // _salePrice.toStringAsFixed(
//                                   //   2,
//                                   // ),
//                                 ),
//                                 const SizedBox(width: 10),
//                                 // salePourcentageDropDownWidget(
//                                 //     ),
//                               ],
//                             ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Expanded(
//                 flex: 3,
//                 child: Padding(
//                   padding: const EdgeInsets.all(10),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(12),
//                       color: Theme.of(context).scaffoldBackgroundColor,
//                     ),
//                     // child: ClipRRect(
//                     //   borderRadius: const BorderRadius.all(
//                     //     Radius.circular(12),
//                     //   ),
//                     //   child: _pickedImage == null
//                     //       ? Image.network(_imageUrl)
//                     //       : (kIsWeb)
//                     //       ? Image.memory(webImage, fit: BoxFit.fill)
//                     //       : Image.file(
//                     //           _pickedImage!,
//                     //           fit: BoxFit.fill,
//                     //         ),
//                     // ),
//                   ),
//                 ),
//               ),
//               Expanded(
//                 flex: 1,
//                 child: Column(
//                   children: [
//                     FittedBox(
//                       child: TextButton(
//                         onPressed: () {
//                           _pickImage();
//                         },
//                         child: CustomText(
//                           text: 'Update image',
//                           color: Colors.blue,
//                         ),
//                       ),
//                     ),
//                   ],
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
//                   onPressed: () async {
//                     GlobalMethods.warningDialog(
//                       title: 'Delete?',
//                       subtitle: 'Press okay to confirm',
//                       fct: () async {
//                         // await FirebaseFirestore.instance
//                         //     .collection('products')
//                         //     .doc(widget.id)
//                         //     .delete();
//                         // await Fluttertoast.showToast(
//                         //   msg: "Product has been deleted",
//                         //   toastLength: Toast.LENGTH_LONG,
//                         //   gravity: ToastGravity.CENTER,
//                         //   timeInSecForIosWeb: 1,
//                         // );
//                         // while (Navigator.canPop(context)) {
//                         //   Navigator.pop(context);
//                         // }
//                       },
//                       context: context,
//                     );
//                   },
//                   text: 'Delete',
//                   icon: IconlyBold.danger,
//                   backgroundColor: Colors.red.shade700,
//                 ),
//                 ButtonsWidget(
//                   onPressed: () {
//                     _updateProduct();
//                   },
//                   text: 'Update',
//                   icon: IconlyBold.setting,
//                   backgroundColor: Colors.blue,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
