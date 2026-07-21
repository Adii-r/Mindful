import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class AuthorsSection extends StatelessWidget {
  const AuthorsSection({super.key});

  final List<Map<String, String>> authors = const [
    {
      "name": "James Clear",
      "image": "assets/images/author1.png",
    },
    {
      "name": "Robin Sharma",
      "image": "assets/images/author2.png",
    },
    {
      "name": "Ryan Holiday",
      "image": "assets/images/author3.png",
    },
    {
      "name": "Marcus Aurelius",
      "image": "assets/images/author4.png",
    },
  ];

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [

        Text(
          "Authors For You",
          style: AppTheme.titleLarge.copyWith(
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 16),


        SizedBox(
          height: 120,

          child: ListView.builder(
            scrollDirection: Axis.horizontal,

            itemCount: authors.length,

            itemBuilder: (context,index){

              return Container(
                width: 90,

                margin: const EdgeInsets.only(
                  right: 18,
                ),

                child: Column(
                  children: [

                    CircleAvatar(
                      radius: 35,

                      backgroundImage:
                      AssetImage(
                        authors[index]["image"]!,
                      ),
                    ),


                    const SizedBox(height: 10),


                    Text(
                      authors[index]["name"]!,

                      maxLines: 2,

                      textAlign: TextAlign.center,

                      style:
                      AppTheme.bodySmall.copyWith(
                        color: Colors.white,
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