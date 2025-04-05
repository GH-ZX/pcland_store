import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pcland_store/services/app_localizations.dart';
import 'package:pcland_store/providers/cart_provider.dart';
import 'package:pcland_store/providers/user_provider.dart';
import 'package:pcland_store/providers/product_provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  String _paymentMethod = 'cod'; // Default payment method

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user;

    _nameController = TextEditingController(text: user?.name ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _phoneController = TextEditingController(text: user?.phoneNumber ?? '');
    _addressController = TextEditingController(text: user?.address ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _placeOrder() {
    if (_formKey.currentState!.validate()) {
      // Process the order
      final cartProvider = Provider.of<CartProvider>(context, listen: false);

      // Here you would normally send the order to your backend
      // For now, we'll just show a success message and clear the cart

      showDialog(
        context: context,
        builder:
            (ctx) => AlertDialog(
              title: Text(
                AppLocalizations.of(context).translate('order_placed'),
              ),
              content: Text(
                AppLocalizations.of(context).translate('order_success'),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    cartProvider.clearCart();
                    Navigator.of(ctx).pop();
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: Text(AppLocalizations.of(context).translate('ok')),
                ),
              ],
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(localizations.translate('checkout'))),
      body: Form(
        key: _formKey,
        child: Stepper(
          currentStep: _currentStep,
          onStepContinue: () {
            if (_currentStep < 2) {
              setState(() {
                _currentStep += 1;
              });
            } else {
              _placeOrder();
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() {
                _currentStep -= 1;
              });
            } else {
              Navigator.of(context).pop();
            }
          },
          controlsBuilder: (context, details) {
            return Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: details.onStepContinue,
                      child: Text(
                        _currentStep == 2
                            ? localizations.translate('place_order')
                            : localizations.translate('continue'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: details.onStepCancel,
                      child: Text(
                        _currentStep == 0
                            ? localizations.translate('cancel')
                            : localizations.translate('back'),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          steps: [
            // Step 1: Shipping Information
            Step(
              title: Text(localizations.translate('shipping_info')),
              content: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: localizations.translate('name'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return localizations.translate('required_field');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: localizations.translate('email'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return localizations.translate('required_field');
                      }
                      if (!value.contains('@')) {
                        return localizations.translate('invalid_email');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: localizations.translate('phone'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return localizations.translate('required_field');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      labelText: localizations.translate('address'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return localizations.translate('required_field');
                      }
                      return null;
                    },
                  ),
                ],
              ),
              isActive: _currentStep >= 0,
              state: _currentStep > 0 ? StepState.complete : StepState.indexed,
            ),

            // Step 2: Payment Method
            Step(
              title: Text(localizations.translate('payment_method')),
              content: Column(
                children: [
                  RadioListTile<String>(
                    title: Text(localizations.translate('cash_on_delivery')),
                    value: 'cod',
                    groupValue: _paymentMethod,
                    onChanged: (value) {
                      setState(() {
                        _paymentMethod = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: Text(localizations.translate('credit_card')),
                    value: 'credit',
                    groupValue: _paymentMethod,
                    onChanged: (value) {
                      setState(() {
                        _paymentMethod = value!;
                      });
                    },
                  ),
                  if (_paymentMethod == 'credit')
                    Column(
                      children: [
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: localizations.translate('card_number'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator:
                              _paymentMethod == 'credit'
                                  ? (value) {
                                    if (value == null || value.isEmpty) {
                                      return localizations.translate(
                                        'required_field',
                                      );
                                    }
                                    return null;
                                  }
                                  : null,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: localizations.translate(
                                    'expiry_date',
                                  ),
                                  hintText: 'MM/YY',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                validator:
                                    _paymentMethod == 'credit'
                                        ? (value) {
                                          if (value == null || value.isEmpty) {
                                            return localizations.translate(
                                              'required_field',
                                            );
                                          }
                                          return null;
                                        }
                                        : null,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'CVV',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                obscureText: true,
                                validator:
                                    _paymentMethod == 'credit'
                                        ? (value) {
                                          if (value == null || value.isEmpty) {
                                            return localizations.translate(
                                              'required_field',
                                            );
                                          }
                                          return null;
                                        }
                                        : null,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                ],
              ),
              isActive: _currentStep >= 1,
              state: _currentStep > 1 ? StepState.complete : StepState.indexed,
            ),

            // Step 3: Order Summary
            Step(
              title: Text(localizations.translate('order_summary')),
              content: Column(
                children: [
                  ...cartProvider.items.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 60,
                            height: 60,
                            child: Image.asset(
                              productProvider.getImagePath(item.imageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${item.quantity} x ${item.price.toStringAsFixed(2)} ${localizations.isArabic ? 'ريال' : 'SAR'}',
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${(item.price * item.quantity).toStringAsFixed(2)} ${localizations.isArabic ? 'ريال' : 'SAR'}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        localizations.translate('subtotal'),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${cartProvider.totalAmount.toStringAsFixed(2)} ${localizations.isArabic ? 'ريال' : 'SAR'}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        localizations.translate('shipping'),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        cartProvider.totalAmount > 500
                            ? localizations.translate('free')
                            : '15.00 ${localizations.isArabic ? 'ريال' : 'SAR'}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color:
                              cartProvider.totalAmount > 500
                                  ? Colors.green
                                  : null,
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        localizations.translate('total'),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        '${(cartProvider.totalAmount + (cartProvider.totalAmount > 500 ? 0 : 15)).toStringAsFixed(2)} ${localizations.isArabic ? 'ريال' : 'SAR'}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              isActive: _currentStep >= 2,
              state: StepState.indexed,
            ),
          ],
        ),
      ),
    );
  }
}
