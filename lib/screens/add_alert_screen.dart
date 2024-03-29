import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tgv_max_alert/models/alert/alert.dart';
import 'package:tgv_max_alert/models/sncf_gare.dart';
import 'package:tgv_max_alert/utils/api/api.dart';
import 'package:tgv_max_alert/utils/utils.dart';
import 'package:tgv_max_alert/widgets/station_autocomplete.dart';
import 'package:uuid/uuid.dart';

class AddAlertScreen extends StatefulWidget {
  final Alert alert;

  AddAlertScreen({Key key, this.alert}) : super(key: key);

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

  @override
  void initState() {
    super.initState();
    if (widget.alert != null) {
      _departure = SncfStation(
        id: widget.alert.originCode,
        label: widget.alert.origin,
      );
      _departureController.text = _departure.label;
      _arrival = SncfStation(
        id: widget.alert.destinationCode,
        label: widget.alert.destination,
      );
      _arrivalController.text = _arrival.label;
      _date = widget.alert.departureDate;
      _hour = TimeOfDay.fromDateTime(widget.alert.departureDate);
    }
  }

  void _openDatePicker() async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: _firstDate,
      lastDate: _firstDate.add(Duration(days: 31 * 4)),
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

  void _addAlert() {
    // TODO: Check fields and add alert to sharedpreferences
    // Return the alert on navigation pop

    Alert newAlert = Alert(
      departureDate: mergeDateAndTime(_date, _hour),
      origin: _departure.label,
      originCode: _departure.id,
      destination: _arrival.label,
      destinationCode: _arrival.id,
    );
    newAlert.uuid = widget.alert?.uuid ?? Uuid().v4();

    Navigator.of(context).pop(newAlert);
  }

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context)
        .textTheme
        .subhead
        .copyWith(fontWeight: FontWeight.w500);

    return Scaffold(
      appBar: AppBar(
        title: widget.alert == null
            ? const Text("Add alert")
            : const Text('Edit alert'),
        centerTitle: true,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: widget.alert == null
            ? const Icon(Icons.add)
            : const Icon(Icons.edit),
        label: widget.alert == null
            ? const Text("Ajouter")
            : const Text("Modifier"),
        onPressed: _addAlert,
      ),
      body: Stack(
        children: [
          Container(color: Theme.of(context).primaryColor, height: 55.0),
          Card(
            margin: const EdgeInsets.all(16.0),
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(20.0),
              children: [
                Text("Departure", style: labelStyle),
                const SizedBox(height: 5.0),
                StationAutoComplete(
                  controller: _departureController,
                  hint: "Departure station",
                  onSuggestion: Api.getDepartureStations,
                  onSelect: (station) {
                    _departure = station;
                    _departureController.text = station?.label ?? "";
                  },
                ),
                const SizedBox(height: 20.0),
                Text("Arrival", style: labelStyle),
                const SizedBox(height: 5.0),
                StationAutoComplete(
                  controller: _arrivalController,
                  hint: "Arrival station",
                  onSuggestion: Api.getArrivalStations,
                  onSelect: (station) {
                    _arrival = station;
                    _arrivalController.text = station?.label ?? "";
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
