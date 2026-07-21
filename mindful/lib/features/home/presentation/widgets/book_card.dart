import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class BooksSection extends StatelessWidget {
  const BooksSection({super.key});


  final List<Map<String,String>> books = const [

    {
      "title":"Atomic Habits",
      "author":"James Clear",
      "category":"Productivity",
    },

    {
      "title":"The Daily Stoic",
      "author":"Ryan Holiday",
      "category":"Stoicism",
    },

  ];


  @override
  Widget build(BuildContext context) {

    return Column(

      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        Text(
          "Books Picked For You",

          style:
          AppTheme.titleLarge.copyWith(
            color: Colors.white,
          ),
        ),


        const SizedBox(height:16),


        ListView.builder(

          shrinkWrap:true,

          physics:
          const NeverScrollableScrollPhysics(),

          itemCount:books.length,


          itemBuilder:(context,index){

            return Container(

              margin:
              const EdgeInsets.only(
                bottom:14,
              ),

              padding:
              const EdgeInsets.all(18),


              decoration:BoxDecoration(

                color:
                AppTheme.surface,

                borderRadius:
                BorderRadius.circular(18),

              ),


              child:Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children:[


                  Text(
                    books[index]["title"]!,

                    style:
                    AppTheme.titleMedium.copyWith(
                      color:Colors.white,
                    ),
                  ),


                  const SizedBox(height:8),


                  Text(
                    "${books[index]["author"]} • ${books[index]["category"]}",

                    style:
                    AppTheme.bodyMedium.copyWith(
                      color:
                      AppTheme.textSecondary,
                    ),
                  ),


                ],
              ),
            );

          },
        ),

      ],
    );
  }
}