import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/mock_data.dart';
import '../../core/theme.dart';
import '../../widgets/public_footer.dart';
import '../../widgets/public_header.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  String _selectedCategory = 'Advising';
  bool _isSubmitted = false;
  String _ticketId = '';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitted = true;
        _ticketId = 'TICK-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Inquiry Ticket #$_ticketId dispatched!'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const PublicHeader(activeRoute: AppConstants.routeContact),

            // Hero Banner
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 64 : 20,
                vertical: 48,
              ),
              color: AppColors.primaryDark,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Contact & Academic Support',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Get in touch with the Registrar, Faculty Advising, or AI Academic Support Team.',
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Main Content: Form + FAQ
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 64 : 20,
                vertical: 40,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: isDesktop
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 3, child: _buildInquiryForm()),
                          const SizedBox(width: 36),
                          Expanded(flex: 2, child: _buildFaqSection()),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInquiryForm(),
                          const SizedBox(height: 36),
                          _buildFaqSection(),
                        ],
                      ),
              ),
            ),

            const PublicFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildInquiryForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Send an Inquiry',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Our academic advisors and technical support response time is within 24 hours.',
          style: TextStyle(
            fontSize: 13.5,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 20),

        if (_isSubmitted)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.successBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.success.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                const Icon(Icons.check_circle, size: 48, color: AppColors.success),
                const SizedBox(height: 12),
                const Text(
                  'Inquiry Ticket Received!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF065F46),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Ticket ID: #$_ticketId\nAn academic counselor will contact you shortly.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF065F46),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isSubmitted = false;
                      _nameController.clear();
                      _emailController.clear();
                      _subjectController.clear();
                      _messageController.clear();
                    });
                  },
                  child: const Text('Submit Another Inquiry'),
                ),
              ],
            ),
          )
        else
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.person_outline, size: 20),
                    ),
                    validator: (v) => v!.isEmpty ? 'Please enter your name' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                      prefixIcon: Icon(Icons.email_outlined, size: 20),
                    ),
                    validator: (v) => !v!.contains('@') ? 'Enter a valid email' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Inquiry Category',
                      prefixIcon: Icon(Icons.category_outlined, size: 20),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Advising',
                        child: Text('Academic Advising'),
                      ),
                      DropdownMenuItem(
                        value: 'Enrollment',
                        child: Text('Course Enrollment'),
                      ),
                      DropdownMenuItem(
                        value: 'Technical',
                        child: Text('Portal Technical Issue'),
                      ),
                      DropdownMenuItem(
                        value: 'General',
                        child: Text('General Inquiry'),
                      ),
                    ],
                    onChanged: (val) => setState(() => _selectedCategory = val!),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _messageController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Message / Details',
                      alignLabelWithHint: true,
                    ),
                    validator: (v) => v!.isEmpty ? 'Please enter your message' : null,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _handleSubmit,
                      icon: const Icon(Icons.send_rounded, size: 18),
                      label: const Text('Submit Inquiry'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFaqSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Frequently Asked Questions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        ...MockData.faqs.map((faq) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ExpansionTile(
              title: Text(
                faq.question,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    faq.answer,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 24),

        // Contact Info Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Academic Administration Office',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 12),
              Text(
                '📍 Turing Computing Complex, Level 4\n'
                '📧 registrar@edupulse.ai\n'
                '📞 +1 (800) 555-EDUPULSE\n'
                '⏰ Hours: Mon-Fri 08:30 AM - 05:30 PM',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
