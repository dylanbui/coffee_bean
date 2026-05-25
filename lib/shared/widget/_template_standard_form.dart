import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:flutter/material.dart';

/// Standard Template for Forms that need to be scrollable and have a sticky footer.
/// This version does NOT require manual keyboard height calculation.
class StandardFormTemplate extends StatelessWidget {
  const StandardFormTemplate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Standard Form"), elevation: 0),
      // Keep resizeToAvoidBottomInset as true (default)
      // so the keyboard pushes the scroll view up.
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: CustomScrollView(
          // physics: AlwaysScrollable... ensures bounce effect even if content is short
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false, // Critical: Allows Column + Spacer to work correctly
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- SECTION 1: HEADER ---
                    const SizedBox(height: 40),
                    Text("Header Title", style: TMLabsTextStyle.h1),
                    const Text("Subtext or instructions go here.", style: TextStyle(color: Colors.grey)),

                    // --- SECTION 2: FORM CONTROLS ---
                    const SizedBox(height: 30),
                    ...List.generate(
                      10,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: TextFormField(decoration: InputDecoration(labelText: "Control ${index + 1}")),
                      ),
                    ),

                    // --- SECTION 3: PRIMARY ACTION ---
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(onPressed: () {}, child: const Text("SUBMIT")),
                    ),

                    // --- SECTION 4: FLEXIBLE SPACE ---
                    // This pushes the footer to the bottom when content is short
                    const Spacer(),

                    // --- SECTION 5: FOOTER ---
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Text("Footer links or Copyright © 2024", style: TextStyle(color: Colors.grey)),
                      ),
                    ),
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
