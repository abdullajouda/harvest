import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:harvest/customer/models/delivery-data.dart';
import 'package:harvest/customer/models/user.dart';
import 'package:harvest/customer/views/Drop-Menu-Views/Profile/user_address_list_tile.dart';
import 'package:harvest/helpers/Localization/localization.dart';
import 'package:harvest/helpers/api.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/helpers/services.dart';
import 'package:harvest/widgets/Loader.dart';
import 'package:harvest/widgets/add_new_address_dialog.dart';
import 'package:harvest/widgets/alerts/myAlerts.dart';
import 'package:harvest/widgets/auth_widgets/set_location_sheet.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'edit_address_dialog.dart';

class UserAddresses extends StatefulWidget {
  @override
  _UserAddressesState createState() => _UserAddressesState();
}

class _UserAddressesState extends State<UserAddresses> {
  List<DeliveryAddresses> addresses = [];
  bool load = false;
  bool loadFunc = false;
  int _selectedIndex = 0;
  int _tapped;

  getAddresses() async {
    setState(() {
      addresses = [];
      load = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var request = await get(ApiHelper.api + 'allAddressForUser', headers: {
      'Accept': 'application/json',
      'Accept-Language': '${prefs.getString('language')}',
      'Authorization': 'Bearer ${prefs.getString('userToken')}'
    });
    var response = json.decode(request.body);
    DeliveryAddresses _address = DeliveryAddresses.fromJson(
        response['items'][0]);
    List locations = response['items'];
    // print(locations);
    locations.forEach((element) {
      DeliveryAddresses deliveryAddress = DeliveryAddresses.fromJson(element);
      addresses.add(deliveryAddress);
    });
    Services().setDefaultAddress(
      _address.id,
        address: _address.address,
        buildingNumber: _address.buildingNumber,
        city: _address.city.name,
        deliveryCost: _address.city.deliveryCost,
        lat: _address.lat,
        lng: _address.lan,
        minOrder: _address.city.minOrder,
        unitNumber: _address.unitNumber);

    setState(() {
      load = false;
    });
  }

  setDefaultAddress(int id) async {
    setState(() {
      loadFunc = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var request =
        await get(ApiHelper.api + 'changeDefultAddress/$id', headers: {
      'Accept': 'application/json',
      'Accept-Language': '${prefs.getString('language')}',
      'Authorization': 'Bearer ${prefs.getString('userToken')}'
    });
    var response = json.decode(request.body);
    var op = Provider.of<UserFunctions>(context, listen: false);
    User user = User.fromJson(response['items']);
    DeliveryAddresses _address = DeliveryAddresses.fromJson(
        response['items']['delivery_addresses'][0]);
    Services().setDefaultAddress(
        _address.id,
        address: _address.address,
        buildingNumber: _address.buildingNumber,
        city: _address.city.name,
        deliveryCost: _address.city.deliveryCost,
        lat: _address.lat,
        lng: _address.lan,
        minOrder: _address.city.minOrder,
        unitNumber: _address.unitNumber);
    op.setUser(user);
    MyAlert.addedToCart(2, context);
    // Fluttertoast.showToast(msg: response['message']);
    setState(() {
      loadFunc = false;
    });
  }

  Future deleteAddress(DeliveryAddresses address) async {
    setState(() {
      loadFunc = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var request =
        await get(ApiHelper.api + 'deleteAddress/${address.id}', headers: {
      'Accept': 'application/json',
          'Accept-Language': '${prefs.getString('language')}',
      'Authorization': 'Bearer ${prefs.getString('userToken')}'
    });
    var response = json.decode(request.body);
    Fluttertoast.showToast(msg: response['message']);
    if (response['status'] == true) {
      setState(() {
        addresses.remove(address);
      });
      var op = Provider.of<UserFunctions>(context, listen: false);
      User user = User.fromJson(response['items']);
      DeliveryAddresses _address = DeliveryAddresses.fromJson(
          response['items']['delivery_addresses'][0]);
      Services().setDefaultAddress(
          _address.id,
          address: _address.address,
          buildingNumber: _address.buildingNumber,
          city: _address.city.name,
          deliveryCost: _address.city.deliveryCost,
          lat: _address.lat,
          lng: _address.lan,
          minOrder: _address.city.minOrder,
          unitNumber: _address.unitNumber);

      op.setUser(user);
    }

    setState(() {
      loadFunc = false;
    });
  }

  openMap(DeliveryAddresses address) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) => EditAddressDialog(
        path: 1,
        deliveryAddresses: address,
      ),
    ).then((value) => getAddresses());
  }

  @override
  void initState() {
    getAddresses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 35),
      child: load
          ? Loader()
          : Column(
              children: [
                ListView.separated(
                  shrinkWrap: true,
                  itemCount: addresses.length,
                  separatorBuilder: (context, index) => SizedBox(height: 30),
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final bool _isSelected = _isAddressSelected(index);
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        UserAddressListTile(
                          index: index,
                          onEdit: () {
                            openMap(addresses[index]);
                          },
                          onRemove: () {
                            deleteAddress(addresses[index]);
                          },
                          address: addresses[index],
                          isSelected: _isSelected,
                          onTap: () {
                            setState(() => _selectedIndex = index);
                            setDefaultAddress(addresses[index].id);
                          },
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 20),
                FlatButton.icon(
                  onPressed: () {
                    // openMap();
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      enableDrag: false,
                      backgroundColor: Colors.transparent,
                      builder: (_) => AddNewAddressDialog(
                          // deliveryAddresses: addresses[_selectedIndex],
                          ),
                    ).then((value) => getAddresses());
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  color: CColors.fadeBlue,
                  icon: Icon(Icons.add, color: CColors.darkGreen, size: 18),
                  label: Text(
                    "add_new_adress".trs(context),
                    style: TextStyle(
                      color: CColors.darkGreen,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  bool _isAddressSelected(int index) => _selectedIndex == index;
}
