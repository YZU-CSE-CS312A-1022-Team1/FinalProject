$(function () {
  $('#login_rank').highcharts({
    chart: {
      type: 'bar'
    },
    title: {
      text: ''
    },
    xAxis: {
      categories: login_rank_user ,
      title: {
        text: null
      }
    },
    yAxis: {
      min: 0,
      title: {
        text: 'login times',
        align: 'high'
      },
      labels: {
        overflow: 'justify'
      }
    },
    plotOptions: {
      bar: {
        dataLabels: {
          enabled: true
        }
      }
    },
    legend: {
      layout: 'vertical',
      align: 'right',
      verticalAlign: 'top',
      x: -40,
      y: 100,
      floating: false,
      borderWidth: 1,
      backgroundColor: (Highcharts.theme && Highcharts.theme.legendBackgroundColor || '#FFFFFF'),
      shadow: true
    },
    tooltip: {
       enabled: false,
    },
    credits: {
      enabled: false
    },
    series: [{
      name: 'times',
      data: login_times
    }]
  });
});

$(function () {
  $('#command_rank').highcharts({
    chart: {
      type: 'bar'
    },
    title: {
      text: ''
    },
    xAxis: {
      categories: commands,
      title: {
        text: null
      }
    },
    yAxis: {
      min: 0,
      title: {
        text: 'used times',
        align: 'high'
      },
      labels: {
        overflow: 'justify'
      }
    },
    plotOptions: {
      bar: {
        dataLabels: {
          enabled: true
        }
      }
    },
    legend: {
      layout: 'vertical',
      align: 'right',
      verticalAlign: 'top',
      x: -40,
      y: 100,
      borderWidth: 1,
      backgroundColor: (Highcharts.theme && Highcharts.theme.legendBackgroundColor || '#FFFFFF'),
      shadow: true
    },
    tooltip: {
      enabled: false,
    },
    credits: {
      enabled: false
    },
    series: [{
      name: 'times',
      data: command_times
    }]
  });
});

$(function () {
  $('#space_usage').highcharts({
    chart: {
      type: 'bar'
    },
    title: {
      text: ''
    },
    xAxis: {
      categories: space_rank_user,
      title: {
        text: null
      }
    },
    yAxis: {
      min: 0,
      title: {
        text: '(Mbyte)',
        align: 'high'
      },
      labels: {
        overflow: 'justify'
      }
    },
    plotOptions: {
      bar: {
        dataLabels: {
          enabled: true
        }
      }
    },
    legend: {
      layout: 'vertical',
      align: 'right',
      verticalAlign: 'top',
      x: -40,
      y: 100,
      borderWidth: 1,
      backgroundColor: (Highcharts.theme && Highcharts.theme.legendBackgroundColor || '#FFFFFF'),
      shadow: true
    },
    tooltip: {
      enabled: false,
    },
    credits: {
      enabled: false
    },
    series: [{
      name: 'Mbyte',
      data: space_usage
    }]
  });
});

$(function () {
  $('#login_in_week').highcharts({
    chart: {
      type: 'column'
    },
    title: {
      text: ''
    },
    xAxis: {
      categories: [ 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun' ],
      title: {
        text: 'Day'
      }
    },
    yAxis: {
      min: 0,
      title: {
        text: 'user login times'
      }
    },
    tooltip: {
      enabled: false,
    },
    plotOptions: {
      column: {
        dataLabels: {
          enabled: true
        },
      }
    },
    legend: {
      layout: 'vertical',
      align: 'right',
      verticalAlign: 'middle',
      borderWidth: 1,
      backgroundColor: (Highcharts.theme && Highcharts.theme.legendBackgroundColor || '#FFFFFF'),
      shadow: true
    },
    credits: {
      enabled: false
    },
    series: [{
      name: 'times',
      data: login_times_week
    }]
  });
});

$(function () {
  $('#login_in_day').highcharts({
    chart: {
      type: 'column'
    },
    title: {
      text: ''
    },
    xAxis: {
      categories: [ '00', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11',
                    '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23' ],
      title: {
         text: 'time'
       }
    },
     yAxis: {
       min: 0,
       title: {
         text: 'user login times'
       }
     },
     tooltip: {
       enabled: false,
     },
     plotOptions: {
       column: {
         dataLabels: {
           enabled: true
         },
       }
     },
     legend: {
       layout: 'vertical',
       align: 'right',
       verticalAlign: 'middle',
       borderWidth: 1,
       backgroundColor: (Highcharts.theme && Highcharts.theme.legendBackgroundColor || '#FFFFFF'),
       shadow: true
     },
     credits: {
       enabled: false
     },
     series: [{
       name: 'times',
       data: login_times_day
     }]
   });
 });
