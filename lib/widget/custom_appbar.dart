  import 'package:cuplex/views/search/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

customAppBar({backButton}) {
    return PreferredSize(
      preferredSize: Size(double.infinity, 65.sp),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 26.h,),
          Container(
            padding: EdgeInsets.only(top : 18.sp, bottom : 0, left : 18.sp),
            child: Row(
              children: [
                backButton == true 
                ? GestureDetector(
                  onTap: (){
                    Get.back();
                  },
                  child: SizedBox(
                    width: 40.w,
                    child: const Icon(Icons.arrow_back_ios, color: Colors.white,),
                  ),
                )
                : SizedBox(width: 30.w),
                SizedBox(
                  height: 36.h,
                  width: 280.0.w,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25.0),
                    child: TextFormField( 
                      onTap: () {
                        Get.to(() => const SearchPage(), );
                      },
                      readOnly: true,
                      decoration: InputDecoration(
                        filled: true,
                        contentPadding: EdgeInsets.only(top: 6.0.sp, left: 15.0.sp, right: 10.sp),
                        fillColor: const Color.fromARGB(255, 221, 221, 221),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        hintText: 'Search',
                        hintStyle:  const TextStyle(fontSize: 14, color: Color.fromARGB(255, 110, 108, 110)),
                        prefixIconConstraints: BoxConstraints(
                          maxWidth: 62.0.w,
                          minWidth: 52.0.w
                        ),
                        prefixIcon: const Icon(Icons.search, color: Color.fromARGB(255, 110, 108, 110))
                      ),
                    ),
                  ),
                ),                
                SizedBox(width: backButton == true ? 20.w : 30.w),
              ],
            ),
          ),
        ],
      ),
    );
  }