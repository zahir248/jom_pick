import 'package:flutter/material.dart';
import 'package:jom_pick/HomeScreen.dart';
import 'package:jom_pick/setting.dart';

class UserManual extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 50.0),
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      // Navigate to the home page and replace the current page
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Setting()),
                      );
                    },
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'User Manual',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            SizedBox(height: 16),

            SizedBox(height: 8),
            SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Introduction',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                 Text(
                    'This user manual provides information on how to use the application',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center, // Center alignment for this specific text
                  ),
                SizedBox(height: 18),
                // Text(
                //   '2. Getting Started',
                //   style: TextStyle(
                //     fontSize: 20,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                // SizedBox(height: 13),
                // Text(
                //   'To get started, follow these steps:',
                //   style: TextStyle(fontSize: 16),
                // ),
                SizedBox(height: 8),
                Text('1. Remark on your parcel',
                style:TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                ),
                SizedBox(height: 13,),
                Text('1. Please include your JomPick ID at the end of your address at your parcel/document for admin reference.'),
                Text('2. You can get your JomPick ID at Setting > Profile. '),
                SizedBox(height: 10,),
                Text('Example : ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5,),
                Text('No. 112 Taman Scientex 1, Jalan Tambun Perdana 2, 17100 Durian Tunggal Melaka ("Your JomPick ID")'),

                SizedBox(height: 15),
                Text('2. Due Date Extension',
                  style:TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 13,),
                Text('1. You can extend your pick up due date up to 3 days. '),
                Text('2. Go to Home Screen > Items (under Activities section) > Details for your item > Extend Pick-Up Due Date > Cofirm.'),
                SizedBox(height: 15,),

                Text('3. Penalty',
                  style:TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 13,),
                Text('1. You will be penalized if you did not pick up your item within the due date. '),
                Text('2. You item will be charged RM 1.00 per day after the due date for 7 days if you did not pick up your item.'),
                SizedBox(height: 15,),

                Text('4. Disposed Item',
                  style:TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 13,),
                Text('1. Your item will be disposed after 7 days penaty period if you did not pick up your item.'),
                Text('2. You can get the direction to your disposed item pick up location if you need want to pick up the item only if the item is not permanently disposed by the management.'),
                Text('3. You can go to Penalty > Details for your item > Look for pick up location.'),
                Text('4. After you know the pick up location, go to Home Screen >  Pick Up Store (under Activities section) > Search your pick up location.'),

                // Text('Pending Items :',
                // style: TextStyle(
                //     fontSize: 16,
                //     fontWeight: FontWeight.bold
                //   ),
                // ),
                // SizedBox(height: 10),
                // Text(' 1. Open Items box at the homescreen'),
                // Text(' 2. Click on Details button for your item'),
                // Text(' 3. You can extend your pickup day up to 3 days but only for once'),
                // Text(' 4. Click Pick-up Detail button see pick-up option'),
                // Text(' 5. Click Go button if you want to get direction to your pick-up location '),
                // Text(' 6. Click Select button on Choose Pick-up date to choose a specific pick-up date'),
                // Text(' 7. Click Pick Now button to pick-up your item at current time'),
                // Text(' 8. Click Show button when you arrived at pick-up location to let the staff verify your item by scanning the QR code'),
              ],
            ),
            SizedBox(height: 8),

            // Add more steps as needed
          ],
        ),
      ),
    );
  }
}
