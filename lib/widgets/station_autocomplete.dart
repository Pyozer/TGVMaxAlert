import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:tgv_max_alert/models/sncf_gare.dart';

class StationAutoComplete extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final SuggestionsCallback<SncfStation> onSuggestion;
  final SuggestionSelectionCallback<SncfStation> onSelect;

  const StationAutoComplete({
    Key key,
    this.hint,
    this.controller,
    this.onSuggestion,
    this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<SncfStation>(
      textFieldConfiguration: TextFieldConfiguration(
        decoration: InputDecoration(hintText: hint),
        controller: controller,
        maxLines: 1,
      ),
      suggestionsCallback: (pattern) async {
        if (pattern.length < 3) return null;
        return await onSuggestion(pattern);
      },
      itemBuilder: (_, station) {
        return ListTile(
          title: Text(station.label),
        );
      },
      onSuggestionSelected: onSelect,
    );
  }
}
