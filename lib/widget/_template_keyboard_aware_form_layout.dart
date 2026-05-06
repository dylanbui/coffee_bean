/*
 * Created with Android Studio
 * Package: 
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 5/5/26 - 23:58
 * To change this template use File | Settings | File Templates.
 */

import 'package:flutter/material.dart';

/// A standard template for pages with Forms and sticky Footers (Policy/Link).
/// Automatically handles UI collapsing when the keyboard appears without breaking the layout.
class KeyboardAwareFormTemplate extends StatefulWidget {
  const KeyboardAwareFormTemplate({super.key});

  @override
  State<KeyboardAwareFormTemplate> createState() => _KeyboardAwareFormTemplateState();
}

class _KeyboardAwareFormTemplateState extends State<KeyboardAwareFormTemplate> {
  // Controls keyboard status to update UI (e.g., shrinking the Logo)
  bool _isKeyboardVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Register Template"), elevation: 0),
      // CRITICALLY IMPORTANT: Disable automatic resizing to manage height manually
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        // Tap outside to hide the keyboard
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // 1. Get the height occupied by the keyboard
            final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
            // 2. Calculate the actual available height
            double availableHeight = constraints.maxHeight - keyboardHeight;

            // Update keyboard visibility state
            bool isVisible = keyboardHeight > 0;
            if (_isKeyboardVisible != isVisible) {
              // Use addPostFrameCallback to avoid setState errors during build
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) setState(() => _isKeyboardVisible = isVisible);
              });
            }

            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Container(
                height: availableHeight, // Force Container height to match the available area
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: <Widget>[
                    // --- SECTION 1: LOGO / HEADER ---
                    // Use _isKeyboardVisible to adjust Padding/Size dynamically
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.only(top: _isKeyboardVisible ? 20.0 : 60.0, bottom: _isKeyboardVisible ? 20.0 : 40.0),
                      child: Text(
                        "APP LOGO",
                        style: TextStyle(fontSize: _isKeyboardVisible ? 20 : 32, fontWeight: FontWeight.bold),
                      ),
                    ),

                    // --- SECTION 2: INPUT FIELDS ---
                    const TextField(decoration: InputDecoration(labelText: "Phone Number")),
                    const SizedBox(height: 20),
                    const TextField(decoration: InputDecoration(labelText: "Password")),

                    // --- SECTION 3: PRIMARY BUTTON ---
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                        child: const Text("CONTINUE", style: TextStyle(color: Colors.white)),
                      ),
                    ),

                    // --- SECTION 4: FLEXIBLE SPACER (MOST IMPORTANT) ---
                    // When the keyboard appears, this area will shrink first
                    const Expanded(child: SizedBox.shrink()),

                    // --- SECTION 5: FOOTER (POLICY / LINKS) ---
                    // Always stays at the bottom when the keyboard is hidden
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20, top: 10),
                      child: Column(
                        children: [
                          const Text("By continuing, you agree to our Terms", style: TextStyle(color: Colors.grey, fontSize: 12)),
                          TextButton(onPressed: () {}, child: const Text("Already have an account? Login")),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
