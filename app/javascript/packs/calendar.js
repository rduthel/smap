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
    aspectRatio: 2,
    themeSystem: 'bootstrap3',
    defaultView: 'agendaWeek',
    locale: 'fr',
    nowIndicator: true,
    navLinks: true,
    dayClick(date, jsEvent, view) {
      console.log(`Clicked on: ${date.format()}`);
    },
  });
});
