$(function () {
  for(var i in username){
    $("#userlist_other").after(function(){
      return '<li> <a href=\"userInfo/'+username[i]+'.html\">'+username[i]+'</a></li>'
    });
  }

  for(var i in username){
    $("#userlist_user").after(function(){
      return '<li> <a href=\"'+username[i]+'.html\">'+username[i]+'</a></li>'
    });
  }

 for(var i in commands){
    $("#user_command_rank").before(function(){
      var index = parseInt(i);
      index ++ ;
      return '<tr><td width=30px height=30px>'+index+'</td><td width=100px>'+commands[i]+'</td><td width=50px>'+command_times[i]+'</td></tr>'
    });
  }

  $("#user_command_chart").highcharts({
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

function extend(hider)
{
  HideMenu = document.all[hider].style;
  if (HideMenu.display == 'none')
    HideMenu.display = "block";
  else
    HideMenu.display = "none";
}

function extend_2(hider)
{
  HideMenu = document.all[hider].style;
//  HideMenu.display = "block";

  if (HideMenu.display == 'none')
    HideMenu.display = "block";
  else
    HideMenu.display = "none";
}
