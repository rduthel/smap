import $ from 'jquery';
import 'fullcalendar';
import 'fullcalendar/dist/locale/fr';
import 'fullcalendar/dist/fullcalendar.css';

$(() => {
  $('#calendar').fullCalendar({
    header: {
      center: 'month,agendaWeek',
    },
    views: {
      month: {
        titleFormat: 'D MMMM YYYY',
      },
    },
    locale: 'fr',
  });
});
