import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ManageShimmer extends StatelessWidget {
  const ManageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 130,
        width: 175,
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 100,
                      height: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: Colors.white,
                      ),
                    ),
                  ),

                ],
              ),
              SizedBox(height: 20,),
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade200,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height:16 ,
                    width: 124,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),

                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              // SizedBox(height: 20,),
              // Row(
              //   children: [
              //     Shimmer.fromColors(
              //       baseColor: Colors.grey.shade300,
              //       highlightColor: Colors.grey.shade200,
              //       child: Container(
              //         height:30 ,
              //         width: 160,
              //         decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(4),
              //
              //           color: Colors.white,
              //         ),
              //       ),
              //     ),
              //     SizedBox(width:1,),
              //
              //   ],
              // )

            ],
          ),
        ),
      ),
    );
  }
}
