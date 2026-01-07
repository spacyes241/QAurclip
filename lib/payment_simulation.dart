import 'package:flutter/material.dart';
import 'package:urclip_app/models/video_model.dart';
import 'package:urclip_app/local_storage.dart';
import 'package:urclip_app/ConfirmPhonePage.dart';
import 'package:urclip_app/ConfirmPaymentPage.dart';

class PaymentSimulationPage extends StatefulWidget {
  final VideoModel video;

  const PaymentSimulationPage({
    super.key,
    required this.video,
  });

  @override
  State<PaymentSimulationPage> createState() =>
      _PaymentSimulationPageState();
}

class _PaymentSimulationPageState extends State<PaymentSimulationPage> {
  String _selectedPayment = 'QRIS';

  final TextEditingController _referralController =
      TextEditingController(text: "123456e123123");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),

              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Row(
                  children: [
                    Icon(Icons.arrow_back_ios,
                        size: 18, color: Colors.black87),
                    Text(
                      "Back",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // PAYMENT METHODS CARD
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Suggested for you",
                      style: TextStyle(
                        color: Color(0xFF6B5E96),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 10),

                    _buildRadioItem("QRIS"),
                    _buildRadioItem("DANA"),
                    _buildRadioItem("OVO"),
                    _buildRadioItem("GOPAY"),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                "More payment option",
                style: TextStyle(
                  color: Color(0xFF6B5E96),
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 12),

              _buildOptionCard(
                title: "Crypto",
                icon: Icons.currency_bitcoin,
                iconColor: Colors.orange,
              ),

              const SizedBox(height: 12),

              _buildOptionCard(
                title: "Credit/ Debit Card",
                icon: Icons.credit_card,
                iconColor: Colors.indigo,
              ),

              const SizedBox(height: 24),

              const Text(
                "Enter Referral Code",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xFF2D3E50),
                ),
              ),

              const SizedBox(height: 8),

              TextField(
                controller: _referralController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 16),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Color(0xFF2D3E50)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: Color(0xFF2D3E50), width: 2),
                  ),
                  suffixIcon: const Icon(Icons.check_circle,
                      color: Colors.green),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _handleContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF555B3E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Continue",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: Colors.white),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ================= LOGIC =================

  Future<void> _handleContinue() async {
    // ✅ REAL PURCHASE (WORKING)
    await LocalStorage.purchaseVideo(widget.video);

    // UI FLOW ONLY
    if (_selectedPayment == 'GOPAY' ||
        _selectedPayment == 'OVO' ||
        _selectedPayment == 'DANA') {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Confirmphonepage(
            title: widget.video.title,
            amount: "IDR 25.000",
            paymentMethod: _selectedPayment,
            onPaymentSuccess: () {},
          ),
        ),
      );
    } else {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Confirmpaymentpage(
            title: widget.video.title,
            amount: "IDR 25.000",
            onPaymentSuccess: () {},
          ),
        ),
      );
    }

    if (mounted) Navigator.pop(context, true);
  }

  // ================= UI HELPERS =================

  Widget _buildHeader() {
    return Container(
      child: Image.asset('images/logourclip.png', height: 60),
    );
  }

  Widget _buildRadioItem(String value) {
    final isSelected = _selectedPayment == value;

    return GestureDetector(
      onTap: () => setState(() => _selectedPayment = value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        color: Colors.transparent,
        child: Row(
          children: [
            Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF6B5E96)
                      : Colors.grey,
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        height: 10,
                        width: 10,
                        decoration: const BoxDecoration(
                          color: Color(0xFF6B5E96),
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: isSelected
                    ? const Color(0xFF6B5E96)
                    : Colors.grey[600],
                fontWeight:
                    isSelected ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
            const Spacer(),
            SizedBox(
              height: 24,
              child: _getPaymentLogo(value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required String title,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF6B5E96),
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios,
              size: 16, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _getPaymentLogo(String type) {
    const double h = 25;

    switch (type) {
      case 'QRIS':
        return const Text(
          "QRIS",
          style: TextStyle(
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic),
        );
      case 'DANA':
        return Image.asset('images/dana.png', height: h);
      case 'OVO':
        return Image.asset('images/ovo.png', height: h);
      case 'GOPAY':
        return Image.asset('images/gopay.png', height: h);
      default:
        return const SizedBox();
    }
  }
}
