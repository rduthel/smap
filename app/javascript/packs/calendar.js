import $ from 'jquery';
import 'bootstrap';
import 'fullcalendar';
import 'fullcalendar/dist/locale/fr';
import 'fullcalendar/dist/fullcalendar.css';

$(() => {
  const getRandomColor = () => {
    const letters = '0123456789ABCDEF';
    let color = '#';
    for (let i = 0; i < 6; i += 1) {
      color += letters[Math.floor(Math.random() * 16)];
    }
    return color;
  };

  const myCalendar = (calendar, indice) => {
    const slots = [];
    const slotsStart = [];
    const slotsEnd = [];
    const parents = [];

    $.each($('.address-name'), (i, e) => {
      parents.push(e);
    });

    $.each($(`.slot-from-${indice}`), (ind, el) => {
      slotsStart.push(new Date(el.innerText));
    });

    $.each($(`.slot-to-${indice}`), (ind, el) => {
      slotsEnd.push(new Date(el.innerText));
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
          calendar.fullCalendar('renderEvent', eventData, true); // stick? = true
          $.ajax({
            url: '/dashboard/slot',
            type: 'POST',
            beforeSend(xhr) {
              xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
            },
            data: `address=${eventData.title}&from=${eventData.start}&to=${eventData.end}`,
          });
        }
        calendar.fullCalendar('unselect');
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
      eventColor: getRandomColor(),
    });
    calendar.fullCalendar('rerenderEvents');
  };

  $.each($('.calendar'), (i, e) => {
    myCalendar($(e), i);
    $('a[role=button]').on('click', () => {
      setTimeout(() => {
        $(e).fullCalendar('rerenderEvents');
      }, 1);
    });
  });
});
