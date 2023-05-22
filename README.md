# Calendar Invite Sender

This is an invocable class which can be used along side Salesforce Scheduler or Salesforce Field Service.

## How to use

1. In your Salesforce org, create a Flow that collects the Id of a ServiceAppointment record and the associated ContactId. 
2. Add CalendarInviteSender Apex Action and map these values under the ServiceAppointmentId and ContactId input fields.

## What to expect
The code will fetch the Service Appointment and contact information (i.e. Name, Email, Subject, SchedStartTime, SchedEndtime, etc.) and use them generate and send a calendar invitation via email.

## Considerations
* An organization email must be configured.

