import $ from 'jquery';
import 'fullcalendar';
import 'fullcalendar/dist/locale/fr';
import 'fullcalendar/dist/fullcalendar.css';

$(() => {
  const myCalendar = (calendar, indice) => {
    const slots = [];
    const slotsStart = [];
    const slotsEnd = [];
    const parents = [];

    $.each($(calendar).parent().parent().find('.address-name'), (i, e) => {
      parents.push(e);
    });

    $.each($('.slot-from'), (i, e) => {
      slotsStart.push(new Date(e.innerText));
    });

    $.each($('.slot-to'), (i, e) => {
      slotsEnd.push(new Date(e.innerText));
    });

    $.each($('.slots'), (index) => {
      const slotsObject = {};
      slotsObject.start = slotsStart[index];
      slotsObject.end = slotsEnd[index];
      slots.push(slotsObject);
    });

    calendar.fullCalendar({
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
      selectable: true,
      selectHelper: true,
      select(start, end) {
        const title = $(parents[indice]).text();
        let eventData;
        if (title) {
          eventData = {
            title,
            start,
            end,
          };
          $('#calendar').fullCalendar('renderEvent', eventData, true); // stick? = true
          $.ajax({
            url: '/dashboard/slot',
            type: 'POST',
            beforeSend(xhr) { xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content')); },
            data: `title=${eventData.title}&start=${eventData.start}&end=${eventData.end}`,
          });
        }
        $('#calendar').fullCalendar('unselect');
      },
      aspectRatio: 2,
      themeSystem: 'bootstrap3',
      defaultView: 'agendaWeek',
      locale: 'fr',
      nowIndicator: true,
      navLinks: true,
      eventSources: [
        {
          events: slots,
        },
      ],
      dayClick(date) {
        console.log(`Clicked on: ${date.format()}`);
      },
    });
  };

  $.each($('.calendar'), (i, e) => {
    myCalendar($(e), i);
  });
});
