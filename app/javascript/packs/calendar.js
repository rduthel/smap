import $ from 'jquery';
import 'fullcalendar';
import 'fullcalendar/dist/locale/fr';
import 'fullcalendar/dist/fullcalendar.css';

$(() => {
  const slots = [];
  const slotsObject = {};
  $.each($('.slot-from'), (i, e) => {
    slotsObject.start = e.innerText;
  });
  $.each($('.slot-to'), (i, e) => {
    slotsObject.stop = e.innerText;
  });
  slots.push(slotsObject);

  $('#calendar').fullCalendar({
    header: {
      left: 'month,agendaWeek,agendaDay',
      center: 'title',
      right: 'today prev,next'
    },
    views: {
      agendaWeek: {
        titleFormat: 'D MMMM'
      },
      month: {
        titleFormat: 'MMMM YYYY'
      }
    },
    aspectRatio: 2,
    themeSystem: 'bootstrap3',
    defaultView: 'agendaWeek',
    locale: 'fr',
    nowIndicator: true,
    navLinks: true,
    events: slots,
    dayClick(date) {
      console.log(`Clicked on: ${date.format()}`);
    }
  });
});
