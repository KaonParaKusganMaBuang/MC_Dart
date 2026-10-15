import 'package:event_booking_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    rememberSession = false;
  });
  testWidgets('booking list supports delete action', (WidgetTester tester) async {
    bookings.clear();
    bookings.add(
      Booking(
        event: const Event(
          id: 1,
          name: 'Sample Event',
          description: 'Sample event description',
          location: 'Cebu City',
          date: '2026-11-10',
          price: 150,
          icon: Icons.event,
          color: Colors.blue,
        ),
        quantity: 2,
        total: 300,
        name: 'Ana',
        email: 'ana@example.com',
      ),
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: BookingTabPage(),
      ),
    );

    expect(find.text('My Bookings'), findsOneWidget);
    expect(find.byIcon(Icons.delete_outline), findsOneWidget);

    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pumpAndSettle();

    expect(find.text('Delete'), findsOneWidget);

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(find.text('No bookings yet'), findsOneWidget);
  });

  testWidgets('admin login grants admin access', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LoginPage(),
      ),
    );

    await tester.enterText(
      find.byType(TextField).at(0),
      'admin@event.com',
    );
    await tester.enterText(
      find.byType(TextField).at(1),
      'admin123',
    );
    await tester.tap(find.widgetWithText(ElevatedButton, 'LOGIN'));
    await tester.pumpAndSettle();

    expect(find.text('Admin'), findsOneWidget);
  });

  testWidgets('non-admin cannot see add or delete event controls', (WidgetTester tester) async {
    eventList = List<Event>.from(fallbackEvents);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: EventsPage(),
        ),
      ),
    );

    expect(find.byTooltip('Add event'), findsNothing);
    expect(find.byIcon(Icons.delete_outline), findsNothing);
  });

  testWidgets('dark mode toggle updates app theme notifier', (WidgetTester tester) async {
    appThemeNotifier.value = false;

    await tester.pumpWidget(
      const MaterialApp(
        home: SettingsPage(),
      ),
    );

    expect(appThemeNotifier.value, isFalse);

    await tester.tap(find.byType(SwitchListTile).first);
    await tester.pump();

    expect(appThemeNotifier.value, isTrue);
  });

  testWidgets('admin can edit an event', (WidgetTester tester) async {
    eventList = List<Event>.from(fallbackEvents);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EventsPage(isAdmin: true),
        ),
      ),
    );

    expect(find.byTooltip('Edit event'), findsWidgets);
  });

  testWidgets('remember session defaults to off', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SettingsPage(),
      ),
    );

    final switchTile = tester.widget<SwitchListTile>(find.byType(SwitchListTile).at(1));
    expect(switchTile.value, isFalse);
  });
}
