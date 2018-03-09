import $ from 'jquery';
import 'fullcalendar';
import 'fullcalendar/dist/locale/fr';
import 'fullcalendar/dist/fullcalendar.css';

$(() => {
  const colors = {};

  const getRandomColor = (id) => {
    if(colors[id])
      return colors[id];
    const letters = '0123456789ABCDEF';
    let color = '#';
    for (let i = 0; i < 6; i += 1) {
      color += letters[Math.floor(Math.random() * 16)];
    }
    colors[id] = color;
    return color;
  };

  const calendarByAddress = (calendar, indice) => {

    let eventSources = []
    let selectable = false;
    let selectHelper = false;
    let select = function(start, end){};

    $.each(calendar.data("slots"), (i, e) => {
      let events = []
      $.each(e[1], (i, e) => {
        events.push({start: e.from, end: e.to})
      });
      eventSources.push({
        events: events,
        color: getRandomColor(e[0])
      })
    });

    if(calendar.data("synchro") == true){
      selectable = true;
      selectHelper = true;
      select = function(start, end) {
        const title = 1;
        let eventData;
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
        calendar.fullCalendar('unselect');
      }
    }

    calendar.fullCalendar({
      views: {
        agendaWeek: {
          titleFormat: 'D MMMM',
        },
        month: {
          titleFormat: 'MMMM YYYY',
        },
      },
      selectable: selectable,
      selectHelper: selectHelper,
      select,
      eventSources: eventSources,
      themeSystem: 'bootstrap3',
      defaultView: 'agendaWeek',
      slotDuration: '01:00:00',
      locale: 'fr',
      nowIndicator: true,
      navLinks: true
    })
  };

  $.each($('.calendar'), (i, e) => {
    calendarByAddress($(e), i);
    $('a[role=button]').on('click', () => {
      setTimeout(() => {
        $(e).fullCalendar('rerenderEvents');
      }, 1);
    });
  });


});




