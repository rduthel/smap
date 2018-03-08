import $ from 'jquery';
import 'fullcalendar';
import 'fullcalendar/dist/locale/fr';
import 'fullcalendar/dist/fullcalendar.css';

$(() => {
  const colors = [];

  const getRandomColor = () => {
    const letters = '0123456789ABCDEF';
    let color = '#';
    for (let i = 0; i < 6; i += 1) {
      color += letters[Math.floor(Math.random() * 16)];
    }
    return color;
  };

  const calendarByAddress = (calendar, indice) => {
    const slots = [];
    const slotsStart = [];
    const slotsEnd = [];
    const parents = [];
    const calendarColor = getRandomColor();
    colors.push(calendarColor);

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
      themeSystem: 'bootstrap3',
      defaultView: 'agendaWeek',
      slotDuration: '01:00:00',
      locale: 'fr',
      nowIndicator: true,
      navLinks: true,
      eventSources: [
        {
          events: slots,
        },
      ],
      eventColor: calendarColor,
    });
  };

  const generalCalendar = (calendar) => {
    const slots = [];
    const slotsStart = [];
    const slotsEnd = [];
    const parents = [];

    $.each($('.address-name'), (i, e) => {
      parents.push(e);
    });

    $.each($('[class*=slot-from-]'), (ind, el) => {
      slotsStart.push(new Date(el.innerText));
    });

    $.each($('[class*=slot-to-]'), (ind, el) => {
      slotsEnd.push(new Date(el.innerText));
    });

    $.each($('.slots'), (index) => {
      const slotsObject = {};
      slotsObject.start = slotsStart[index];
      slotsObject.end = slotsEnd[index];
      slots.push(slotsObject);
    });

    calendar.fullCalendar({
      views: {
        agendaWeek: {
          titleFormat: 'D MMMM',
        },
        month: {
          titleFormat: 'MMMM YYYY',
        },
      },
      themeSystem: 'bootstrap3',
      defaultView: 'agendaWeek',
      slotDuration: '01:00:00',
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
  };

  generalCalendar($('#general-calendar'));

  $.each($('.calendar'), (i, e) => {
    calendarByAddress($(e), i);
    $('a[role=button]').on('click', () => {
      setTimeout(() => {
        $(e).fullCalendar('rerenderEvents');
      }, 1);
    });
  });
});
