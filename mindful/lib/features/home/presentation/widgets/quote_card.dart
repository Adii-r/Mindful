import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class QuoteCard extends StatelessWidget {
  const QuoteCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      width: double.infinity,

      padding: const EdgeInsets.all(24),


      decoration: BoxDecoration(

        gradient: AppTheme.primaryGradient,

        borderRadius:
        BorderRadius.circular(24),

      ),


      child: Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,


        children: [

          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,

            children: [

              Text(
                "Quote For You",
                style:
                AppTheme.titleMedium.copyWith(
                  color: Colors.white,
                ),
              ),


              Icon(
                Icons.favorite_border,
                color: Colors.white,
              ),

            ],
          ),


          const SizedBox(height: 24),


          Text(
            "\"Small steps every day create big changes.\"",

            style:
            AppTheme.headlineLarge.copyWith(
              color: Colors.white,
              fontStyle: FontStyle.italic,
            ),
          ),


          const SizedBox(height: 20),


          Text(
            "— James Clear",

            style:
            AppTheme.bodyMedium.copyWith(
              color: Colors.white70,
            ),
          ),


        ],
      ),
    );
  }
}