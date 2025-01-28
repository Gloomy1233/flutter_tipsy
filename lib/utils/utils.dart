String formatDateString1(String? dateStr) {
  if (dateStr == null) return "no Date";
  // Step 1: Clean up the string if necessary.
  // Remove the unwanted space/hyphen combination (assuming it's a typo).
  String cleanedString = dateStr.replaceAll(' -', ' ');

  // Parse the cleaned string into a DateTime object.
  DateTime parsedDate;
  // Attempt to parse the date using try-catch
  try {
    parsedDate = DateTime.parse(cleanedString);
  } catch (e) {
    print("Error parsing date: $e");
    return "No Date"; // Exit or handle accordingly if parsing fails
  }

  // Step 2: Manually format the date.
  // Extract day, month, hour, and minute
  String day = parsedDate.day.toString();
  String month = parsedDate.month.toString();
  // Ensure hour and minute are two digits if needed
  String hour = parsedDate.hour.toString().padLeft(2, '0');
  String minute = parsedDate.minute.toString().padLeft(2, '0');

  // Construct the desired formatted string: "day/month at hour:minute"
  String formattedDate = "$day/$month at $hour:$minute";

  return formattedDate; // Should print: 19/1 at 12:00
}
