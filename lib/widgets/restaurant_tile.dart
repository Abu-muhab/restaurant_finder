import 'package:flutter/material.dart';
import 'package:restaurantfinder/constants.dart';

class RestaurantTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          SizedBox(
            height: 140,
            width: 140,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset("images/res_img.jpg",fit: BoxFit.cover,),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Qatar Restaurant",
                style: TextStyle(color: Colors.white, fontSize: 19),
              ),
              SizedBox(
                height: 5,
              ),
              Wrap(
                spacing: 5,
                children: [
                  Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 15,
                  ),
                  Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 15,
                  ),
                  Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 15,
                  ),
                  Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 15,
                  ),
                  Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 15,
                  )
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Icon(
                    Icons.directions_outlined,
                    color: Colors.blueGrey,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "5 miles away",
                    style: TextStyle(color: Colors.blueGrey),
                  )
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Chip(
                label: Text(
                  "Open",
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.green,
              )
            ],
          )
        ],
      ),
    );
  }
}
