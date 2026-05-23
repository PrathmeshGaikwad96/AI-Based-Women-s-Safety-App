import 'package:basic/main.dart';
import 'package:flutter/material.dart';


class SafetyStoreScreen extends StatefulWidget {
  const SafetyStoreScreen({super.key});

  @override
  State<SafetyStoreScreen> createState() => _SafetyStoreScreenState();
}

class _SafetyStoreScreenState extends State<SafetyStoreScreen> {
  final _categories = const ['All', 'Pepper Sprays', 'Alarms', 'GPS', 'Keychains'];
  int _selectedCategory = 0;
  String _searchQuery = '';

  // Local Cart State
  final Map<_StoreItem, int> _cart = {};

  int get _cartCount => _cart.values.fold(0, (sum, qty) => sum + qty);
  double get _cartTotal => _cart.entries.fold(0.0, (sum, entry) => sum + (entry.key.price * entry.value));

  final List<_StoreItem> _items = const [
    _StoreItem(
      title: 'SHRI Pepper Spray',
      rating: 4.9,
      reviews: 120,
      price: 299.00,
      tag: 'BEST SELLER',
      imageStyle: _ImageStyle.pepperSpray,
      favorite: true,
      category: 'Pepper Sprays',
    ),
    _StoreItem(
      title: '130dB Personal Siren Alarm',
      rating: 4.8,
      reviews: 85,
      price: 399.00,
      imageStyle: _ImageStyle.siren,
      category: 'Alarms',
    ),
    _StoreItem(
      title: 'Smart GPS Tracking Keychain',
      rating: 5.0,
      reviews: 42,
      price: 899.00,
      imageStyle: _ImageStyle.keychain,
      category: 'Keychains',
    ),
    _StoreItem(
      title: 'Elite Safety Preparedness Kit',
      rating: 4.7,
      reviews: 214,
      price: 1499.00,
      imageStyle: _ImageStyle.kit,
      category: 'GPS',
    ),
    _StoreItem(
      title: 'Stealth Black Pepper Spray',
      rating: 4.9,
      reviews: 151,
      price: 349.00,
      imageStyle: _ImageStyle.stealth,
      category: 'Pepper Sprays',
    ),
    _StoreItem(
      title: 'Tactical Flashlight & Strobe',
      rating: 4.8,
      reviews: 108,
      price: 599.00,
      imageStyle: _ImageStyle.flashlight,
      category: 'Alarms',
    ),
    _StoreItem(
      title: 'Mini Real-time GPS Tracker',
      rating: 4.6,
      reviews: 64,
      price: 1999.00,
      imageStyle: _ImageStyle.tracker,
      category: 'GPS',
    ),
    _StoreItem(
      title: 'Heavy Duty Door Stop Alarm',
      rating: 4.7,
      reviews: 73,
      price: 449.00,
      imageStyle: _ImageStyle.doorStop,
      category: 'Alarms',
    ),
    _StoreItem(
      title: 'Defender Ring with Hidden Blade',
      rating: 4.5,
      reviews: 39,
      price: 249.00,
      imageStyle: _ImageStyle.ring,
      category: 'Keychains',
    ),
    _StoreItem(
      title: 'Steel Tactical Defense Pen',
      rating: 4.8,
      reviews: 92,
      price: 499.00,
      imageStyle: _ImageStyle.pen,
      category: 'Keychains',
    ),
    _StoreItem(
      title: 'Smart Safety Watch with SOS',
      rating: 4.9,
      reviews: 156,
      price: 3499.00,
      imageStyle: _ImageStyle.watch,
      category: 'GPS',
    ),
    _StoreItem(
      title: 'SOS Wireless Panic Button',
      rating: 4.7,
      reviews: 80,
      price: 699.00,
      imageStyle: _ImageStyle.siren,
      category: 'Alarms',
    ),
    _StoreItem(
      title: 'Strobe Light & Sound Alarm',
      rating: 4.4,
      reviews: 48,
      price: 329.00,
      imageStyle: _ImageStyle.siren,
      category: 'Alarms',
    ),
    _StoreItem(
      title: 'Max-Strength Pocket Pepper Gel',
      rating: 4.8,
      reviews: 112,
      price: 399.00,
      imageStyle: _ImageStyle.gel,
      category: 'Pepper Sprays',
    ),
    _StoreItem(
      title: 'Lipstick Concealed Pepper Spray',
      rating: 4.7,
      reviews: 88,
      price: 279.00,
      imageStyle: _ImageStyle.pepperSpray,
      category: 'Pepper Sprays',
    ),
    _StoreItem(
      title: 'Portable Travel Door Lock',
      rating: 4.6,
      reviews: 54,
      price: 799.00,
      imageStyle: _ImageStyle.keychain,
      category: 'Keychains',
    ),
    _StoreItem(
      title: 'Mini Siren & LED Keychain',
      rating: 4.5,
      reviews: 67,
      price: 299.00,
      imageStyle: _ImageStyle.keychain,
      category: 'Keychains',
    ),
    _StoreItem(
      title: 'Magnetic GPS Tracker Clip',
      rating: 4.7,
      reviews: 41,
      price: 1249.00,
      imageStyle: _ImageStyle.tracker,
      category: 'GPS',
    ),
    _StoreItem(
      title: 'Premium Safety Defense Kit',
      rating: 4.9,
      reviews: 180,
      price: 2499.00,
      imageStyle: _ImageStyle.kit,
      category: 'GPS',
    ),
    _StoreItem(
      title: 'High-Decibel Self-Defense Wand',
      rating: 4.6,
      reviews: 55,
      price: 499.00,
      imageStyle: _ImageStyle.siren,
      category: 'Alarms',
    ),
  ];

  void _addToCart(_StoreItem item) {
    setState(() {
      if (_cart.containsKey(item)) {
        _cart[item] = _cart[item]! + 1;
      } else {
        _cart[item] = 1;
      }
    });
    _showCartSheet();
  }

  void _updateCartQuantity(_StoreItem item, int delta, StateSetter setSheetState) {
    setState(() {
      if (!_cart.containsKey(item)) return;
      final newQty = _cart[item]! + delta;
      if (newQty <= 0) {
        _cart.remove(item);
      } else {
        _cart[item] = newQty;
      }
    });
    setSheetState(() {});
  }

  void _showCartSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setSheetState) {
            final cartItems = _cart.entries.toList();
            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 5,
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        const Icon(Icons.shopping_cart_rounded, color: AppColors.primaryBlue),
                        const SizedBox(width: 8),
                        Text(
                          'Shopping Cart (${_cartCount} items)',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: cartItems.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.shopping_bag_outlined,
                                    size: 64, color: AppColors.textMuted.withOpacity(0.5)),
                                const SizedBox(height: 12),
                                const Text(
                                  'Your cart is empty',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textDark,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Add safety products to get started.',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textMuted.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.all(16),
                            itemCount: cartItems.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 12),
                            itemBuilder: (context, idx) {
                              final entry = cartItems[idx];
                              final item = entry.key;
                              final qty = entry.value;
                              return Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: const Color(0xFFE2E8F0)),
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: SizedBox(
                                        width: 50,
                                        height: 50,
                                        child: _ProductImage(style: item.imageStyle),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.title,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 13.5,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.textDark,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '₹${item.price.toStringAsFixed(2)}',
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.primaryBlue,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        _CircleQtyBtn(
                                          icon: Icons.remove_rounded,
                                          onTap: () {
                                            _updateCartQuantity(item, -1, setSheetState);
                                          },
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                          child: Text(
                                            '$qty',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.textDark,
                                            ),
                                          ),
                                        ),
                                        _CircleQtyBtn(
                                          icon: Icons.add_rounded,
                                          onTap: () {
                                            _updateCartQuantity(item, 1, setSheetState);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                  if (cartItems.isNotEmpty) ...[
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Amount',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textMuted,
                                ),
                              ),
                              Text(
                                '₹${_cartTotal.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.textDark,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                _showRazorpaySheet();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryBlue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Proceed to Pay',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showRazorpaySheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setSheetState) {
            // Internal state variables for checkout
            String paymentMethod = 'UPI';
            String upiId = 'success@razorpay';
            String cardNo = '4111 2222 3333 4444';
            String cardExpiry = '12/28';
            String cardCvv = '123';
            String cardHolder = 'ROSHNI PATEL';
            String selectedBank = 'SBI';
            String simState = 'idle'; // 'idle', 'processing', 'success', 'failure'
            String processingMsg = '';

            void _runSimulation(bool success) {
              setSheetState(() {
                simState = 'processing';
                processingMsg = 'Connecting to Razorpay Sandbox...';
              });

              Future.delayed(const Duration(milliseconds: 800), () {
                if (!mounted) return;
                setSheetState(() {
                  processingMsg = 'Authorizing payment with bank...';
                });

                Future.delayed(const Duration(milliseconds: 800), () {
                  if (!mounted) return;
                  setSheetState(() {
                    processingMsg = 'Finalizing transaction...';
                  });

                  Future.delayed(const Duration(milliseconds: 600), () {
                    if (!mounted) return;
                    setSheetState(() {
                      simState = success ? 'success' : 'failure';
                    });

                    Future.delayed(const Duration(milliseconds: 1500), () {
                      if (!mounted) return;
                      if (success) {
                        Navigator.of(context).pop(); // Dismiss sheet
                        final orderId = 'pay_${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
                        final orderAmount = _cartTotal;
                        setState(() {
                          _cart.clear();
                        });
                        _showOrderSuccessDialog(orderId, orderAmount);
                      } else {
                        setSheetState(() {
                          simState = 'idle'; // Return to form
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: AppColors.danger,
                            behavior: SnackBarBehavior.floating,
                            content: Row(
                              children: [
                                Icon(Icons.error_outline_rounded, color: Colors.white),
                                SizedBox(width: 8),
                                Text('Payment failed. Please try a different payment method.'),
                              ],
                            ),
                          ),
                        );
                      }
                    });
                  });
                });
              });
            }

            Widget _buildUpiAppChip(String appName, String label) {
              return InkWell(
                onTap: () {
                  setSheetState(() {
                    upiId = '${appName.toLowerCase()}@razorpay';
                  });
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.mobile_screen_share_rounded, size: 14, color: AppColors.primaryBlue.withOpacity(0.8)),
                      const SizedBox(width: 6),
                      Text(
                        label,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            Widget _buildMethodTab(String name, IconData icon) {
              final isActive = name == paymentMethod;
              return Expanded(
                child: InkWell(
                  onTap: () => setSheetState(() => paymentMethod = name),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isActive ? const Color(0xFF3399FF) : Colors.transparent,
                          width: 3,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          icon,
                          color: isActive ? const Color(0xFF3399FF) : AppColors.textMuted,
                          size: 20,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          name,
                          style: TextStyle(
                            color: isActive ? const Color(0xFF3399FF) : AppColors.textMuted,
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            Widget _buildCheckoutContent() {
              if (simState == 'processing') {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  color: const Color(0xFF0F172A),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(
                            strokeWidth: 4,
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3399FF)),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          processingMsg,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Please do not close this window or hit back',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (simState == 'success') {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  color: const Color(0xFF0F172A),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_rounded, size: 72, color: AppColors.success),
                        SizedBox(height: 16),
                        Text(
                          'Payment Successful',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (simState == 'failure') {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  color: const Color(0xFF0F172A),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cancel_rounded, size: 72, color: AppColors.danger),
                        SizedBox(height: 16),
                        Text(
                          'Payment Failed',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Column(
                children: [
                  Row(
                    children: [
                      _buildMethodTab('UPI', Icons.qr_code_rounded),
                      _buildMethodTab('Card', Icons.credit_card_rounded),
                      _buildMethodTab('Netbanking', Icons.account_balance_rounded),
                    ],
                  ),
                  if (paymentMethod == 'UPI')
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Pay using UPI',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildUpiAppChip('GPay', 'Google Pay'),
                              _buildUpiAppChip('PhonePe', 'PhonePe'),
                              _buildUpiAppChip('Paytm', 'Paytm'),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Or enter UPI ID',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextField(
                            onChanged: (val) => upiId = val,
                            controller: TextEditingController(text: upiId)..selection = TextSelection.fromPosition(TextPosition(offset: upiId.length)),
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: 'username@bank',
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Color(0xFF3399FF)),
                              ),
                            ),
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  if (paymentMethod == 'Card')
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Card Details',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            onChanged: (val) => cardNo = val,
                            controller: TextEditingController(text: cardNo)..selection = TextSelection.fromPosition(TextPosition(offset: cardNo.length)),
                            decoration: InputDecoration(
                              isDense: true,
                              labelText: 'Card Number',
                              labelStyle: const TextStyle(fontSize: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  onChanged: (val) => cardExpiry = val,
                                  controller: TextEditingController(text: cardExpiry)..selection = TextSelection.fromPosition(TextPosition(offset: cardExpiry.length)),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    labelText: 'Expiry (MM/YY)',
                                    labelStyle: const TextStyle(fontSize: 12),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextField(
                                  onChanged: (val) => cardCvv = val,
                                  controller: TextEditingController(text: cardCvv)..selection = TextSelection.fromPosition(TextPosition(offset: cardCvv.length)),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    labelText: 'CVV',
                                    labelStyle: const TextStyle(fontSize: 12),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  obscureText: true,
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            onChanged: (val) => cardHolder = val,
                            controller: TextEditingController(text: cardHolder)..selection = TextSelection.fromPosition(TextPosition(offset: cardHolder.length)),
                            decoration: InputDecoration(
                              isDense: true,
                              labelText: 'Card Holder Name',
                              labelStyle: const TextStyle(fontSize: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  if (paymentMethod == 'Netbanking')
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Select Bank',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<String>(
                            value: selectedBank,
                            items: const [
                              DropdownMenuItem(value: 'SBI', child: Text('State Bank of India', style: TextStyle(fontSize: 13))),
                              DropdownMenuItem(value: 'HDFC', child: Text('HDFC Bank', style: TextStyle(fontSize: 13))),
                              DropdownMenuItem(value: 'ICICI', child: Text('ICICI Bank', style: TextStyle(fontSize: 13))),
                              DropdownMenuItem(value: 'AXIS', child: Text('Axis Bank', style: TextStyle(fontSize: 13))),
                            ],
                            onChanged: (val) => setSheetState(() => selectedBank = val ?? 'SBI'),
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Sandbox controls
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amber.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.science_outlined, size: 16, color: Colors.amber.shade800),
                            const SizedBox(width: 6),
                            Text(
                              'RAZORPAY SANDBOX CONTROLS',
                              style: TextStyle(
                                color: Colors.amber.shade900,
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 36,
                                child: ElevatedButton.icon(
                                  onPressed: () => _runSimulation(true),
                                  icon: const Icon(Icons.check_circle_outline_rounded, size: 14, color: Colors.white),
                                  label: const Text('Simulate Success', style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.success,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    padding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: SizedBox(
                                height: 36,
                                child: ElevatedButton.icon(
                                  onPressed: () => _runSimulation(false),
                                  icon: const Icon(Icons.highlight_off_rounded, size: 14, color: Colors.white),
                                  label: const Text('Simulate Failure', style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.danger,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    padding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    child: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () => _runSimulation(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3399FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'PAY ₹${_cartTotal.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      decoration: const BoxDecoration(
                        color: Color(0xFF0F172A),
                        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.shield_rounded, color: Colors.blueAccent, size: 20),
                                  const SizedBox(width: 6),
                                  const Text(
                                    'razorpay',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 17,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  Text(
                                    ' checkout',
                                    style: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFB020),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'TEST MODE',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'SHRI Safety Gear Store',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Order #SHRI-89472',
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 11,
                                ),
                              ),
                              Text(
                                '₹${_cartTotal.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    _buildCheckoutContent(),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showOrderSuccessDialog(String orderId, double amount) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(
                    color: Color(0xFFDCFCE7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_outline_rounded,
                    color: AppColors.success,
                    size: 44,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Order Placed!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your order has been confirmed successfully.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textMuted.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    children: [
                      _buildDialogDetailRow('Transaction ID', orderId),
                      const SizedBox(height: 8),
                      _buildDialogDetailRow('Amount Paid', '₹${amount.toStringAsFixed(2)}'),
                      const SizedBox(height: 8),
                      _buildDialogDetailRow('Delivery Option', 'Standard (2-3 days)'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Done',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDialogDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textMuted,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filter items based on category chip and search query
    final filteredItems = _items.where((item) {
      final matchesCategory = _selectedCategory == 0 || item.category == _categories[_selectedCategory];
      final matchesSearch = item.title.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: const TextScaler.linear(1.0),
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          bottom: false,
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    children: [
                      _TopBar(
                        cartCount: _cartCount,
                        onCartTap: _showCartSheet,
                        onBackTap: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(height: 12),
                      _SearchBar(
                        hint: 'Search safety gear...',
                        onChanged: (val) {
                          setState(() {
                            _searchQuery = val;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 34,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _categories.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 10),
                          itemBuilder: (context, i) {
                            final selected = i == _selectedCategory;
                            return _CategoryChip(
                              text: _categories[i],
                              selected: selected,
                              onTap: () => setState(() => _selectedCategory = i),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.68,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _ProductCard(
                      item: filteredItems[index],
                      onBuyTap: () => _addToCart(filteredItems[index]),
                    ),
                    childCount: filteredItems.length,
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: SizedBox(height: MediaQuery.of(context).padding.bottom + 10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.cartCount,
    required this.onCartTap,
    required this.onBackTap,
  });

  final int cartCount;
  final VoidCallback onCartTap;
  final VoidCallback onBackTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: onBackTap,
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFF2F4FA),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE9ECF6)),
            ),
            child: Icon(Icons.chevron_left_rounded,
                size: 22, color: AppColors.textDark.withOpacity(0.9)),
          ),
        ),
        const SizedBox(width: 10),
        Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: const BoxDecoration(
                color: AppColors.primaryBlue,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.storefront_rounded,
                  size: 13, color: Colors.white),
            ),
            const SizedBox(width: 8),
            const Text(
              'Safety Store',
              style: TextStyle(
                color: AppColors.textDark,
                fontSize: 15.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const Spacer(),
        InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: onCartTap,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F4FA),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE9ECF6)),
                ),
                child: Icon(Icons.shopping_bag_outlined,
                    size: 20, color: AppColors.textDark.withOpacity(0.85)),
              ),
              if (cartCount > 0)
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF4D77),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        '$cartCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.hint, required this.onChanged});
  final String hint;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4FA),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE9ECF6)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          Icon(Icons.search_rounded, size: 18, color: AppColors.textMuted.withOpacity(0.85)),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  color: AppColors.textMuted.withOpacity(0.75),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
              style: const TextStyle(
                color: AppColors.textDark,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              cursorColor: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  final String text;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryBlue : const Color(0xFFF2F4FA),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: selected ? AppColors.primaryBlue : const Color(0xFFE9ECF6)),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.textMuted.withOpacity(0.95),
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.item, required this.onBuyTap});
  final _StoreItem item;
  final VoidCallback onBuyTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF6F7FB),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE9ECF6)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image
            SizedBox(
              height: 116,
              child: Stack(
                children: [
                  Positioned.fill(child: _ProductImage(style: item.imageStyle)),
                  if (item.favorite)
                    Positioned(
                      right: 10,
                      top: 10,
                      child: Container(
                        width: 26,
                        height: 26,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFE6EF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.favorite_rounded,
                            size: 14, color: Color(0xFFFF4D77)),
                      ),
                    ),
                  if (item.tag != null)
                    Positioned(
                      left: 10,
                      bottom: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF4D77),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item.tag!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8.5,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textDark,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, size: 14, color: Color(0xFFFFC542)),
                        const SizedBox(width: 4),
                        Text(
                          '${item.rating.toStringAsFixed(1)} (${item.reviews})',
                          style: TextStyle(
                            color: AppColors.textMuted.withOpacity(0.95),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '₹${item.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: AppColors.textDark,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 34,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue,
                          borderRadius: BorderRadius.circular(999),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryBlue.withOpacity(0.20),
                              blurRadius: 16,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(999),
                          onTap: onBuyTap,
                          child: const Center(
                            child: Text(
                              'Buy Now',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleQtyBtn extends StatelessWidget {
  const _CircleQtyBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: const Color(0xFFF2F4FA),
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFE9ECF6)),
        ),
        child: Icon(icon, size: 16, color: AppColors.textDark.withOpacity(0.8)),
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  const _ProductImage({required this.style});
  final _ImageStyle style;

  @override
  Widget build(BuildContext context) {
    switch (style) {
      case _ImageStyle.pepperSpray:
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFF7E8A), Color(0xFFFFD3D8)],
            ),
          ),
          child: Center(
            child: Container(
              width: 38,
              height: 74,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.85),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Container(
                  width: 22,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFF111827),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
        );

      case _ImageStyle.siren:
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0B0F14), Color(0xFF1F2937)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Container(
              width: 56,
              height: 74,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Color(0xFF9CA3AF),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );

      case _ImageStyle.keychain:
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0B0F14), Color(0xFF2B3441)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Container(
              width: 74,
              height: 74,
              decoration: BoxDecoration(
                color: const Color(0xFF111827),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Center(
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFF9CA3AF),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF374151), width: 4),
                  ),
                ),
              ),
            ),
          ),
        );

      case _ImageStyle.kit:
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0B0F14), Color(0xFF1F2937)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 56,
                  height: 66,
                  decoration: BoxDecoration(
                    color: const Color(0xFF16A34A),
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFBBF24),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
        );

      case _ImageStyle.stealth:
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFEFF2FF), Color(0xFFFFFFFF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Container(
              width: 40,
              height: 78,
              decoration: BoxDecoration(
                color: const Color(0xFF111827),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        );

      case _ImageStyle.flashlight:
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFEFF2FF), Color(0xFFFFFFFF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Transform.rotate(
              angle: -0.35,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 58,
                    height: 20,
                    decoration: BoxDecoration(
                      color: const Color(0xFF111827),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: const Color(0xFF111827),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

      case _ImageStyle.tracker:
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white24),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.location_on_rounded, color: Colors.redAccent, size: 24),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.greenAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

      case _ImageStyle.ring:
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFDBA74), Color(0xFFF97316)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 6),
              ),
              child: Center(
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: const BoxDecoration(
                    color: Colors.deepPurple,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        );

      case _ImageStyle.pen:
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF334155), Color(0xFF1E293B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Transform.rotate(
              angle: 0.5,
              child: Container(
                width: 10,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.grey, width: 1),
                ),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: 8,
                    height: 20,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ),
          ),
        );

      case _ImageStyle.watch:
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0F172A), Color(0xFF374151)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade800, width: 2),
              ),
              child: Center(
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFF991B1B),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      'SOS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );

      case _ImageStyle.doorStop:
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE2E8F0), Color(0xFF94A3B8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Transform.rotate(
              angle: -0.4,
              child: Container(
                width: 70,
                height: 30,
                decoration: const BoxDecoration(
                  color: Color(0xFF1E293B),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(4),
                    bottomRight: Radius.circular(4),
                  ),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 25,
                    height: 20,
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
            ),
          ),
        );

      case _ImageStyle.gel:
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0D9488), Color(0xFFCCFBF1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Container(
              width: 32,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Container(
                    width: 32,
                    height: 18,
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'GEL',
                    style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        );
    }
  }
}

enum _ImageStyle {
  pepperSpray,
  siren,
  keychain,
  kit,
  stealth,
  flashlight,
  tracker,
  ring,
  pen,
  watch,
  doorStop,
  gel,
}

class _StoreItem {
  final String title;
  final double rating;
  final int reviews;
  final double price;
  final String? tag;
  final _ImageStyle imageStyle;
  final bool favorite;
  final String category;

  const _StoreItem({
    required this.title,
    required this.rating,
    required this.reviews,
    required this.price,
    required this.imageStyle,
    required this.category,
    this.tag,
    this.favorite = false,
  });
}