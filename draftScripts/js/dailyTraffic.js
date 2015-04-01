$(function () {
    $('#Daily').highcharts({
    chart: {
      type: 'bar'
    },
    title: {
      text: ''
    },
    credits: {
      enabled: false
    },
    exporting: {
      enabled: false
    },
    tooltip: {
      enabled: false
    },
    xAxis: {
      title:'',
      tickWidth:0,
      labels:{
      enabled:false
      }
    },
    yAxis: {
      min: 0,
      title:'',
      gridLineWidth:0,
      labels:{
      enabled:false
      }
    },
    legend: {
      align: 'center',
      verticalAlign: 'top'
    },
    plotOptions: {
      series: {
        stacking: 'normal'
      }
    },
    series: [{
      name: 'Rx',
      data: barChart_Daily_Rx
      },
      {
      name: 'Tx',
      data: barChart_Daily_Tx
      }]
  });
});

