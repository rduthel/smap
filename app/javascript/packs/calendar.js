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

    console.log("je usis la");
    // console.log(Json.calendar);
    console.log(calendar.data("slots"));

    const slots = [];
    const slotsStart = [];
    const slotsEnd = [];
    const parents = [];
    const calendarColor = getRandomColor();

    calendar.data("slots").each

    let eventSources = []

    $.each(calendar.data("slots"), (i, e) => {
       let events = [ // put the array in the `events` property
                  {
                      title  : 'event1',
                      start  : '2018-03-01'
                  },
                  {
                      title  : 'event2',
                      start  : '2018-03-05',
                      end    : '2018-03-07'
                  },
                  {
                      title  : 'event3',
                      start  : '2018-03-09 12:30:00',
                  }
              ]

       eventSources.push({
              events: events,
              color: 'black',     // an option!
              textColor: 'yellow' // an option!
          })
    });


    calendar.fullCalendar({
      eventSources: eventSources
    })

    // calendar.fullCalendar({
    //   views: {
    //     agendaWeek: {
    //       titleFormat: 'D MMMM',
    //     },
    //     month: {
    //       titleFormat: 'MMMM YYYY',
    //     },
    //   },
    //   selectable: true,
    //   selectHelper: true,
    //   select(start, end) {
    //     const title = $(parents[indice]).text();
    //     let eventData;
    //     if (title) {
    //       eventData = {
    //         title,
    //         start,
    //         end,
    //       };
    //       calendar.fullCalendar('renderEvent', eventData, true); // stick? = true
    //       $.ajax({
    //         url: '/dashboard/slot',
    //         type: 'POST',
    //         beforeSend(xhr) {
    //           xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
    //         },
    //         data: `address=${eventData.title}&from=${eventData.start}&to=${eventData.end}`,
    //       });
    //     }
    //     calendar.fullCalendar('unselect');
    //   },
    //   themeSystem: 'bootstrap3',
    //   defaultView: 'agendaWeek',
    //   slotDuration: '01:00:00',
    //   locale: 'fr',
    //   nowIndicator: true,
    //   navLinks: true,
    //   eventSources: [
    //     {
    //       events: slots,
    //     },
    //   ],
    //   eventColor: calendarColor,
    // });
  };


  // generalCalendar($('#general-calendar'));

  // $.each($('.calendar'), (i, e) => {
  //   calendarByAddress($(e), i);
  //   $('a[role=button]').on('click', () => {
  //     setTimeout(() => {
  //       $(e).fullCalendar('rerenderEvents');
  //     }, 1);
  //   });
  // });

  $.each($('.calendar'), (i, e) => {
    calendarByAddress($(e), i);
  });
});




