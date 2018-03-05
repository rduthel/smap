import $ from 'jquery';
import 'fullcalendar';
import 'fullcalendar/dist/locale/fr';
import 'fullcalendar/dist/fullcalendar.css';

$(() => {
  $('#calendar').fullCalendar({
    header: {
      left: 'month,agendaWeek,agendaDay',
      center: 'title',
      right: 'today prev,next',
    },
    views: {
      agendaWeek: {
        titleFormat: 'D MMMM',
      },
      month: {
        titleFormat: 'MMMM YYYY',
      },
    },
    locale: 'fr',
    nowIndicator: true,
    defaultView: 'agendaWeek',
  });
});
