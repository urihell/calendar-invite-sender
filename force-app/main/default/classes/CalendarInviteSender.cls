public class CalendarInviteSender {
    @InvocableMethod(label='Send Calendar Invite')
    public static void sendCalendarInvite(List<CalendarInvite> invites) {
        for (CalendarInvite invite : invites) {
            // Get the Service Appointment record
            ServiceAppointment sa = [SELECT Id, SchedStartTime, SchedEndTime, Subject FROM ServiceAppointment WHERE Id = :invite.serviceAppointmentId];
            
            // Get the Contact record
            Contact contact = [SELECT Id, Name, Email FROM Contact WHERE Id = :invite.contactId];
            
            // Create the calendar invite
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setTargetObjectId(contact.Id);
            email.setSaveAsActivity(false);
            
            // Set the subject and body
            email.setSubject('Service Appointment Calendar Invite: ' + sa.Subject );
            String body = 'Hi ' + contact.Name + ' Here is the calendar invite for your Service Appointment.\n\n Please click on the link to add it to your calendar.';
            body += '\n\nStart: ' + sa.SchedStartTime.format('MMMM d, yyyy h:mm a');
            body += '\nEnd: ' + sa.SchedEndTime.format('MMMM d, yyyy h:mm a');
            email.setHtmlBody(body);
            
            // Create the iCal attachment
            String iCalContent = 'BEGIN:VCALENDAR\n';
            iCalContent += 'VERSION:2.0\n';
            iCalContent += 'PRODID:-//hacksw/handcal//NONSGML v1.0//EN\n';
            iCalContent += 'BEGIN:VEVENT\n';
            iCalContent += 'UID:' + sa.Id + '\n';
            iCalContent += 'DTSTAMP:' + System.now().format('yyyyMMdd\'T\'HHmmss\'Z\'') + '\n';
            iCalContent += 'DTSTART:' + sa.SchedStartTime.format('yyyyMMdd\'T\'HHmmss\'Z\'') + '\n';
            iCalContent += 'DTEND:' + sa.SchedEndTime.format('yyyyMMdd\'T\'HHmmss\'Z\'') + '\n';
            iCalContent += 'SUMMARY:Service Appointment\n';
            iCalContent += 'END:VEVENT\n';
            iCalContent += 'END:VCALENDAR';
            
            Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
            attachment.setFileName('invite.ics');
            attachment.setBody(Blob.valueOf(iCalContent));
            attachment.setContentType('text/calendar');
            
            email.setFileAttachments(new Messaging.EmailFileAttachment[] {attachment});
            
            // Send the email
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        }
    }
    
    public class CalendarInvite {
        @InvocableVariable(required=true)
        public Id serviceAppointmentId;
        
        @InvocableVariable(required=true)
        public Id contactId;

    }
}