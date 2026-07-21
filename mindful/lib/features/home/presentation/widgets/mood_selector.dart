import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class MoodSelector extends StatefulWidget {
  const MoodSelector({super.key});

  @override
  State<MoodSelector> createState() => _MoodSelectorState();
}

class _MoodSelectorState extends State<MoodSelector> {

  int selectedIndex = -1;

  final moods = [
    {
      "emoji": "😊",
      "name": "Happy",
    },
    {
      "emoji": "😌",
      "name": "Calm",
    },
    {
      "emoji": "😔",
      "name": "Sad",
    },
    {
      "emoji": "😤",
      "name": "Stressed",
    },
  ];


  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [

        Text(
          "How are you feeling right now?",
          style: AppTheme.titleLarge.copyWith(
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 16),


        Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,

          children: List.generate(
            moods.length,

                (index) {

              final selected =
                  selectedIndex == index;


              return GestureDetector(

                onTap: () {

                  setState(() {
                    selectedIndex = index;
                  });

                },


                child: Column(
                  children: [

                    AnimatedContainer(
                      duration:
                      const Duration(
                        milliseconds: 200,
                      ),

                      width: 60,
                      height: 60,


                      decoration: BoxDecoration(

                        color: selected
                            ? AppTheme.secondary
                            : AppTheme.surface,


                        shape: BoxShape.circle,

                        border: Border.all(
                          color: selected
                              ? AppTheme.secondary
                              : Colors.transparent,
                        ),
                      ),


                      child: Center(

                        child: Text(
                          moods[index]["emoji"]!,
                          style: const TextStyle(
                            fontSize: 28,
                          ),
                        ),

                      ),
                    ),


                    const SizedBox(height: 8),


                    Text(
                      moods[index]["name"]!,

                      style:
                      AppTheme.bodySmall.copyWith(
                        color:
                        selected
                            ? Colors.white
                            : AppTheme.textSecondary,
                      ),
                    ),

                  ],
                ),
              );

            },
          ),
        ),

      ],
    );
  }
}