import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Requestshimmer extends StatelessWidget {
  const Requestshimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return
      Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 361.0,
        height: 218.0,
        decoration: BoxDecoration(
          border: Border.all(
              width: 0.3,
              color: Color(0xFFE4E7EC)
          ),
          borderRadius: BorderRadius.circular(20),
          color: Color(0xFFFCFCFC),
        ),
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade200,
          child:
          Padding(
            padding: const EdgeInsets.only(left: 20.0,top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 10,),
                    Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade200,
                      child: Container(
                        height:35 ,
                        width: 160,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),

                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20,),

                Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade200,
                  child: Container(
                    height:30 ,
                    width: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),

                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade200,
                  child: Container(
                    height:30 ,
                    width: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),

                      color: Colors.white,
                    ),
                  ),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
