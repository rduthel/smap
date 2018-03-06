import $ from 'jquery';
import 'fullcalendar';
import 'fullcalendar/dist/locale/fr';
import 'fullcalendar/dist/fullcalendar.css';

$(() => {
  const myCalendar = () => {
    const slots = [];
    const slotsObject = {};
    $.each($('.address_name'), (i, e) => {
      slotsObject.title = e.innerText;
    });
    $.each($('.slot-from'), (i, e) => {
      slotsObject.start = new Date(e.innerText);
    });
    $.each($('.slot-to'), (i, e) => {
      slotsObject.end = new Date(e.innerText);
    });
    slots.push(slotsObject);

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
      selectable: true,
      selectHelper: true,
      select(start, end) {
        const title = prompt('Event Title:');
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
        // fetch('/dashboard/slot', {
        //   method: 'POST',
        //   body: title
        // });
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

  if ($('.slot-from').length !== 0) {
    myCalendar();
  }

  $('#button_new_slot').on('click', () => {
    myCalendar();
  });
});
