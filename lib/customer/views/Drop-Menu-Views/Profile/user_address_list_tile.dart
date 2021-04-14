import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:harvest/customer/models/delivery-data.dart';
import 'package:harvest/helpers/Localization/localization.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/helpers/constants.dart';
import 'package:harvest/widgets/remove_icon.dart';

class UserAddressListTile extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onRemove;
  final int index;
  final DeliveryAddresses address;

  const UserAddressListTile({
    Key key,
    this.isSelected,
    this.onTap,
    this.index,
    this.address,
    this.onRemove,
    this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppTranslations trs = AppTranslations.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          RemoveIcon(
            enabled: true,
            onTap: onRemove,
            child: Container(
              child: Row(
                children: [
                  Theme(
                    data: ThemeData(
                        unselectedWidgetColor: Color(0x993c984f),
                        disabledColor: Color(0x993c984f)),
                    child: Radio<int>(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      activeColor: Color(0x993c984f),
                      value: index,
                      groupValue: isSelected ? index : -1,
                      onChanged: (_) {},
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? CColors.fadeBlue : CColors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: !isSelected
                                ? CColors.fadeBlue
                                : CColors.transparent,
                            width: 2),
                      ),
                      child: ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 3),

                        leading: SvgPicture.asset(Constants.mapPinIcon),
                        title: Text(
                          "delivery_address".trs(context),
                          style: TextStyle(
                            fontSize: 16,
                            color: const Color(0xff525768),
                          ),
                        ),
                        subtitle: Row(
                          children: [
                            Text(
                              "${address.city.name}, ${address.address != null ? address.address + ',' : ''}",
                              style: TextStyle(
                                fontSize: 14,
                                color: const Color(0xffaaafb6),
                              ),
                            ),
                            Text(
                              "${address.buildingNumber != null ? address.buildingNumber.toString() + ', ' : ''} ${address.unitNumber != null ? address.unitNumber.toString() + '' : ''}",
                              style: TextStyle(
                                fontSize: 14,
                                color: const Color(0xffaaafb6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned.directional(
            textDirection: LangProvider().getLocaleCode() == 'ar'?TextDirection.rtl:TextDirection.ltr,
            end: -10,
            top: -10,
            child: GestureDetector(
              onTap: onEdit,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: CColors.darkOrange,
                  border: Border.all(color: CColors.white, width: 3),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
