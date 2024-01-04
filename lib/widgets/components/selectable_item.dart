import 'package:flutter/material.dart';

class SelectableItem<T> extends StatelessWidget {
  const SelectableItem({
    super.key,
    required this.text,
    this.subtitle,
    this.selected = false,
    required this.color,
    this.textColor,
    this.selectedTextColor,
    required this.leading,
    this.middle,
    this.trailing,
    this.onTap,
    this.object,
  });
  final String text;
  final String? subtitle;
  final bool selected;
  final Color color;
  final Color? textColor;
  final Color? selectedTextColor;
  final Widget leading;
  final Widget? middle;
  final Widget? trailing;
  final Function()? onTap;
  final T? object;

  SelectableItem copyWith({
    String? text,
    String? subtitle,
    bool? selected,
    Color? color,
    Color? textColor,
    Color? selectedTextColor,
    Widget? leading,
    bool? alwaysShowTrailing,
    Widget? trailing,
    Function()? onTap,
    T? object,
  }) {
    return SelectableItem(
      text: text ?? this.text,
      subtitle: subtitle ?? this.subtitle,
      selected: selected ?? this.selected,
      color: color ?? this.color,
      textColor: textColor ?? this.textColor,
      selectedTextColor: selectedTextColor ?? this.selectedTextColor,
      leading: leading ?? this.leading,
      trailing: trailing ?? this.trailing,
      onTap: onTap ?? this.onTap,
      object: object ?? this.object,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 72,
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.2) : null,
          border: Border.all(
            color: selected ? color : Colors.grey.shade300,
            width: selected ? 3 : 1,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
          borderRadius: BorderRadius.circular(50),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              leading,
              const SizedBox(width: 18),
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.3,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      text,
                      style: TextStyle(
                        color: selected ? selectedTextColor : textColor,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null)
                      Flexible(
                        child: Text(
                          subtitle!,
                          style: TextStyle(
                            color: selected ? selectedTextColor : textColor,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (middle != null) middle!,
              const SizedBox(width: 4),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}
