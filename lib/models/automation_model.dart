import 'package:flutter/material.dart';

enum AutomationType { schedule, condition }
enum TriggerType { time, temperature, motion, humidity, deviceState }
enum ActionType { power, brightness, temperature, fanSpeed, color }

class Automation {
  final String id;
  final String name;
  final AutomationType type;
  final List<AutomationTrigger> triggers;
  final List<AutomationAction> actions;
  final Schedule? schedule;
  bool isEnabled;

  Automation({
    required this.id,
    required this.name,
    required this.type,
    required this.triggers,
    required this.actions,
    this.schedule,
    this.isEnabled = true,
  });

  factory Automation.fromJson(Map<String, dynamic> json) {
    return Automation(
      id: json['id'] as String,
      name: json['name'] as String,
      type: AutomationType.values.firstWhere(
        (e) => e.toString() == 'AutomationType.${json['type']}',
      ),
      triggers: (json['triggers'] as List)
          .map((e) => AutomationTrigger.fromJson(e as Map<String, dynamic>))
          .toList(),
      actions: (json['actions'] as List)
          .map((e) => AutomationAction.fromJson(e as Map<String, dynamic>))
          .toList(),
      schedule: json['schedule'] != null
          ? Schedule.fromJson(json['schedule'] as Map<String, dynamic>)
          : null,
      isEnabled: json['isEnabled'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.toString().split('.').last,
      'triggers': triggers.map((t) => t.toJson()).toList(),
      'actions': actions.map((a) => a.toJson()).toList(),
      'schedule': schedule?.toJson(),
      'isEnabled': isEnabled,
    };
  }
}

class AutomationTrigger {
  final TriggerType type;
  final String? deviceId;
  final dynamic value;
  final String operator;
  final Map<String, dynamic>? conditions;

  AutomationTrigger({
    required this.type,
    this.deviceId,
    required this.value,
    required this.operator,
    this.conditions,
  });

  factory AutomationTrigger.fromJson(Map<String, dynamic> json) {
    return AutomationTrigger(
      type: TriggerType.values.firstWhere(
        (e) => e.toString() == 'TriggerType.${json['type']}',
      ),
      deviceId: json['deviceId'] as String?,
      value: json['value'],
      operator: json['operator'] as String,
      conditions: json['conditions'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.toString().split('.').last,
      'deviceId': deviceId,
      'value': value,
      'operator': operator,
      'conditions': conditions,
    };
  }
}

class AutomationAction {
  final String deviceId;
  final ActionType type;
  final dynamic value;

  AutomationAction({
    required this.deviceId,
    required this.type,
    required this.value,
  });

  factory AutomationAction.fromJson(Map<String, dynamic> json) {
    return AutomationAction(
      deviceId: json['deviceId'] as String,
      type: ActionType.values.firstWhere(
        (e) => e.toString() == 'ActionType.${json['type']}',
      ),
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deviceId': deviceId,
      'type': type.toString().split('.').last,
      'value': value,
    };
  }
}

class Schedule {
  final List<int> daysOfWeek;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final bool repeat;

  Schedule({
    required this.daysOfWeek,
    required this.startTime,
    required this.endTime,
    this.repeat = true,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    final startTimeParts = (json['startTime'] as String).split(':');
    final endTimeParts = (json['endTime'] as String).split(':');

    return Schedule(
      daysOfWeek: (json['daysOfWeek'] as List).cast<int>(),
      startTime: TimeOfDay(
        hour: int.parse(startTimeParts[0]),
        minute: int.parse(startTimeParts[1]),
      ),
      endTime: TimeOfDay(
        hour: int.parse(endTimeParts[0]),
        minute: int.parse(endTimeParts[1]),
      ),
      repeat: json['repeat'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'daysOfWeek': daysOfWeek,
      'startTime': '${startTime.hour}:${startTime.minute}',
      'endTime': '${endTime.hour}:${endTime.minute}',
      'repeat': repeat,
    };
  }
}
