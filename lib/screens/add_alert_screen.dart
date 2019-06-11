import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tgv_max_alert/models/sncf_gare.dart';
import 'package:tgv_max_alert/utils/api/api.dart';
import 'package:tgv_max_alert/utils/utils.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class AddAlertScreen extends StatefulWidget {
  AddAlertScreen({Key key}) : super(key: key);

  _AddAlertScreenState createState() => _AddAlertScreenState();
}

class _AddAlertScreenState extends State<AddAlertScreen> {
  final _departureController = TextEditingController();
  final _arrivalController = TextEditingController();
  SncfStation _departure;
  SncfStation _arrival;
  DateTime _firstDate = DateTime.now();
  DateTime _date = DateTime.now();
  TimeOfDay _hour = TimeOfDay.now();

  void _openDatePicker() async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: _firstDate,
      lastDate: _firstDate.add(Duration(days: 31 * 3)),
      initialDate: _date,
    );
    if (date != null) setState(() => _date = date);
  }

  void _openTimePicker() async {
    TimeOfDay hour = await showTimePicker(
      context: context,
      initialTime: _hour,
    );
    if (hour != null) setState(() => _hour = hour);
  }

  Widget _buildStation(BuildContext context, SncfStation station) {
    return ListTile(
      leading: const Icon(Icons.location_city),
      title: Text(station.label),
    );
  }

  void _addAlert() {
    // TODO: Check fields and add alert to sharedpreferences
    // Return the alert on navigation pop
  }

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context)
        .textTheme
        .subhead
        .copyWith(fontWeight: FontWeight.w500);

    return Scaffold(
      appBar: AppBar(
        title: Text("Add alert"),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: _addAlert,
      ),
      body: Stack(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            height: 55.0,
          ),
          Card(
            margin: const EdgeInsets.all(16.0),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(20.0),
              children: [
                Text("Departure", style: labelStyle),
                const SizedBox(height: 5.0),
                TypeAheadField<SncfStation>(
                  textFieldConfiguration: TextFieldConfiguration(
                    decoration: InputDecoration(hintText: "Departure station"),
                    controller: _departureController,
                    maxLines: 1,
                  ),
                  suggestionsCallback: (pattern) async {
                    if (pattern.length < 3) return null;
                    return await Api.getStations(pattern);
                  },
                  itemBuilder: _buildStation,
                  onSuggestionSelected: (suggestion) {
                    _departure = suggestion;
                    _departureController.text = suggestion?.label ?? "";
                  },
                ),
                const SizedBox(height: 20.0),
                Text("Arrival", style: labelStyle),
                const SizedBox(height: 5.0),
                TypeAheadField<SncfStation>(
                  textFieldConfiguration: TextFieldConfiguration(
                    decoration: InputDecoration(hintText: "Arrival station"),
                    controller: _arrivalController,
                    maxLines: 1,
                  ),
                  suggestionsCallback: (pattern) async {
                    if (pattern.length < 3) return null;
                    return await Api.getStations(pattern, false);
                  },
                  itemBuilder: _buildStation,
                  onSuggestionSelected: (suggestion) {
                    _arrival = suggestion;
                    _arrivalController.text = suggestion?.label ?? "";
                  },
                ),
                const SizedBox(height: 20.0),
                Text("Date", style: labelStyle),
                const SizedBox(height: 5.0),
                GestureDetector(
                  onTap: _openDatePicker,
                  child: AbsorbPointer(
                    child: TextField(
                      controller: TextEditingController(
                        text: capitalize(formatMediumDate(_date)),
                      ),
                      decoration: InputDecoration(
                        hintText: "Choose date",
                        icon: const Icon(Icons.date_range),
                      ),
                      enabled: false,
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Text("Hour", style: labelStyle),
                const SizedBox(height: 5.0),
                GestureDetector(
                  onTap: _openTimePicker,
                  child: AbsorbPointer(
                    child: TextField(
                      controller: TextEditingController(
                        text: formatTimeHm(_hour),
                      ),
                      decoration: InputDecoration(
                        hintText: "Choose departure time",
                        icon: const Icon(Icons.access_time),
                      ),
                      enabled: false,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
