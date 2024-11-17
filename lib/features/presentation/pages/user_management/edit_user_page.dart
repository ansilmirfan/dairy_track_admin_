// ignore_for_file: library_private_types_in_public_api

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dairy_track_admin/core/constants/constants.dart';
import 'package:dairy_track_admin/features/data/models/driver_model.dart';
import 'package:dairy_track_admin/features/data/models/store_model.dart';
import 'package:dairy_track_admin/features/presentation/getx/user_management.dart';
import 'package:dairy_track_admin/features/presentation/pages/home/home.dart';
import 'package:dairy_track_admin/features/presentation/pages/user_management/map.dart';
import 'package:dairy_track_admin/features/presentation/themes/themes.dart';
import 'package:dairy_track_admin/features/presentation/widgets/custom_dropdown.dart';
import 'package:dairy_track_admin/features/presentation/widgets/custom_snackbar.dart';
import 'package:dairy_track_admin/features/presentation/widgets/custom_text_button.dart';
import 'package:dairy_track_admin/features/presentation/widgets/custom_textformfiled.dart';
import 'package:dairy_track_admin/features/presentation/widgets/gap.dart';
import 'package:dairy_track_admin/core/validations/validations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EditUserPage extends StatefulWidget {
  final bool drivers;
  final DriverModel? driverModel;
  final ShopModel? shopModel;
  const EditUserPage(
      {super.key, required this.drivers, this.driverModel, this.shopModel});
  @override
  _EditUserPageState createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String entityType = 'Driver';
  String route = 'Kalpetta';
  LatLng? location;
  final UserManagementController userManagementController =
      Get.put(UserManagementController());
  final TextEditingController nameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController placeController = TextEditingController();
  final TextEditingController licenseController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _intialiseFields();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: _form(),
          ),
        ),
      ),
    );
  }

  Column _form() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //---------entity type---------------
        CustomDropdownFormField(
          labelText: 'Entity Type',
          value: entityType,
          items: const ['Driver', 'Store'],
          onChanged: (value) {
            setState(() {
              entityType = value!;
            });
          },
        ),
        const Gap(),
        //----------name---------------
        CustomTextFormField(
          controller: nameController,
          labelText: entityType == 'Driver' ? 'Full Name' : 'Shop Name',
          validator: Validations.validateName,
        ),
        const Gap(),
        //-------user name and password only visible in the driver section---------------
        if (entityType == 'Driver') _userNameAndPassword(),

        //-----------phone number--------------
        CustomTextFormField(
          controller: phoneController,
          labelText: 'Phone Number',
          keyboardType: TextInputType.number,
          validator: Validations.validatePhoneNumber,
          maxLength: 10,
        ),
        if (entityType == 'Driver') const Gap(),
        //-----------licence number---------------------
        if (entityType == 'Driver')
          CustomTextFormField(
            controller: licenseController,
            labelText: 'License Number',
            validator: Validations.validateLicense,
          ),
        const Gap(),
        //----------place-------------------
        if (entityType != 'Driver')
          CustomTextFormField(
            controller: placeController,
            labelText: 'Place',
            validator: Validations.validatePlace,
          ),
        if (entityType != 'Driver') const Gap(),
        //--------------route selection-------------
        CustomDropdownFormField(
          labelText: 'Route',
          value: route,
          items: Constants.routs,
          onChanged: (value) {
            if (value != null) {
              setState(() {
                route = value;
              });
            }
          },
        ),
        //-------------location-------------------
        if (entityType != 'Driver') _locationSelection(),
        const Gap(),
        //------------save button-------------------
        Obx(
          () {
            if (userManagementController.loading.value) {
              return CustomTextButton(progress: true);
            }

            return CustomTextButton(
              onPressed: () => _validate(),
              text: 'Save',
            );
          },
        ),
      ],
    );
  }

  void _validate() {
    if (_formKey.currentState!.validate()) {
      if (entityType != 'Driver' && location == null) {
        showCustomSnackbar(
            title: 'Error',
            message: 'Please select the location before saving data',
            isSuccess: false);
      } else {
        if (entityType == 'Driver') {
          userManagementController.updateUser(
              driverModel: DriverModel(
            id: widget.driverModel?.id ?? '',
            name: nameController.text.trim(),
            userName: userNameController.text.trim(),
            password: passwordController.text.trim(),
            licenceNumber: licenseController.text.trim(),
            phoneNumber: int.parse(phoneController.text.trim()),
            route: route,
          ));
        } else {
          userManagementController.updateUser(
              driver: false,
              storeModel: ShopModel(
                  id: widget.shopModel?.id ?? '',
                  name: nameController.text.trim(),
                  phoneNumber: int.parse(phoneController.text.trim()),
                  location: GeoPoint(location!.latitude, location!.longitude),
                  place: placeController.text.trim(),
                  route: route));
        }
      }
    }
  }

  Column _userNameAndPassword() {
    return Column(
      children: [
        CustomTextFormField(
          controller: userNameController,
          labelText: 'User Name',
          validator: Validations.validateName,
        ),
        const Gap(),
        CustomTextFormField(
          controller: passwordController,
          labelText: 'Password',
          password: true,
          validator: Validations.validatePassword,
        ),
        const Gap(),
      ],
    );
  }

  Row _locationSelection() {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Get.to(const MapSample())?.then((value) {
              if (value != null && value is LatLng) {
                setState(() {
                  location = value;
                });
              }
            });
          },
          icon: location == null
              ? const Icon(
                  Icons.location_on_outlined,
                )
              : const Icon(
                  Icons.location_on,
                  color: Colors.red,
                ),
        ),
        const Text('Location')
      ],
    );
  }

  AppBar _appbar() {
    return AppBar(
      title: const Text('User Management'),
      centerTitle: true,
      backgroundColor: Themes.primary,
      foregroundColor: Themes.secondary,
    );
  }

  void _intialiseFields() {
    entityType = widget.drivers ? 'Driver' : 'Store';
    route =
        widget.drivers ? widget.driverModel!.route : widget.shopModel!.route;

    nameController.text =
        widget.drivers ? widget.driverModel!.name : widget.shopModel!.name;
    phoneController.text = widget.drivers
        ? widget.driverModel!.phoneNumber.toString()
        : widget.shopModel!.phoneNumber.toString();
    if (widget.drivers) {
      userNameController.text = widget.driverModel!.userName;
      passwordController.text = widget.driverModel!.password;
      licenseController.text = widget.driverModel!.licenceNumber;
    } else {
      placeController.text = widget.shopModel!.place;
      location = LatLng(widget.shopModel!.location.latitude,
          widget.shopModel!.location.latitude);
    }
  }
}
