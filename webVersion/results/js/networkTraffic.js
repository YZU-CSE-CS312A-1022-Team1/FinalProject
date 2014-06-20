$(function () {
  $('#txrx_chart').highcharts({
    chart: {
      type: 'column'
    },
    title: {
      text: ''
    },
    xAxis: {
      categories: date,
      labels: {
        rotation: -60,
        style: {
          fontSize: '13px'
        }
      },
      title: {
        text: '(date)',
        align:'high'
      }
    },
    yAxis: {
      min: 0,
      title: {
        text: 'MiB'
      }
    },
    tooltip: {
      headerFormat: '<span>{point.key}</span><table>',
      pointFormat: '<tr><td style="color:{series.color};padding:0 5 0 5">{series.name}: </td>' +
                   '<td style="padding:0 5 0 5 "><b>{point.y:.1f}</td><td>MiB</b></td></tr>',
      footerFormat: '</table>',
      shared: true,
      useHTML: true
    },
    plotOptions: {
      column: {
        pointPadding: 0
      }
    },
    credits: {
      enabled: false
    },
    series: [{ name: 'Rx', data: rx },
             { name: 'Tx', data: tx
    }]
  });
});

$(function () {
  $('#total_chart').highcharts({
    chart: {
      type: 'column'
    },
    title: {
      text: ''
    },
    xAxis: {
      categories: date ,
      labels: {
        rotation: -60,
        style: {
          fontSize: '13px'
        }
      },
      title: {
        text: '(date)',
        align:'high'
      }
    },
    yAxis: {
      min: 0,
        title: {
          text: 'MiB'
        }
    },
    tooltip: {
      headerFormat: '{point.key}<table>',
      pointFormat: '<tr><td style="color:{series.color};padding:0 5 0 5">{series.name}: </td>' +
                   '<td style="padding:0 5 0 5 "><b>{point.y:.1f}</td><td>MiB</b></td></tr>',
      footerFormat: '</table>',
      shared: true,
      useHTML: true
    },
    plotOptions: {
      column: {
        pointPadding: 0
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
      name: 'total',
      data: total
    }]
  });
});


$(function () {
  $('#rate_chart').highcharts({
    chart: {
      type: 'column'
    },
    title: {
      text: ''
    },
    xAxis: {
      categories: date ,
        labels: {
          rotation: -60,
          style: {
            fontSize: '13px'
          }
        },
      title: {
        text: '(date)',
        align:'high'
      }
    },
    yAxis: {
      min: 0,
      title: {
        text: 'kBit/s'
      }
    },
    tooltip: {
    headerFormat: '{point.key}<table>',
    pointFormat: '<tr><td style="color:{series.color};padding:0 5 0 5">{series.name}: </td>' +
                 '<td style="padding:0 5 0 5 "><b>{point.y:.1f}</td><td>kBit/s</b></td></tr>',
    footerFormat: '</table>',
    shared: true,
    useHTML: true
    },
    plotOptions: {
      column: {
        pointPadding: 0
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
      name: 'rate',
      data: rate
    }]
  });
});
