import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChipRow extends StatefulWidget {
  final List<String> chipNames;
  final List<Function()> onChipTap;
  final List<bool> isSelected;

  const ChipRow({
    Key? key,
    required this.chipNames,
    required this.onChipTap,
    required this.isSelected,
  }) : assert(chipNames.length == onChipTap.length && chipNames.length == isSelected.length,
  "Chip names, onTap actions, and isSelected states must match."),
        super(key: key);

  @override
  _ChipRowState createState() => _ChipRowState();
}

class _ChipRowState extends State<ChipRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.chipNames.length, (index) {
        final isSelected = widget.isSelected[index];

        return GestureDetector(
          onTap: () {
            setState(() {
              for (int i = 0; i < widget.isSelected.length; i++) {
                widget.isSelected[i] = (i == index);
              }
            });
            widget.onChipTap[index]();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Chip(
              label: Text(
                widget.chipNames[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              backgroundColor: isSelected ? const Color(0xFF105DFB) : Colors.grey[300],
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            ),
          ),
        );
      }),
    );
  }
}
