<script>
  d3.json("/api/account/{{ account.name }}/transfers").get(function(error, rows) {
    var data = rows;
    var dataset = new Plottable.Dataset(data);
    var dayOffset = (24*60*60*1000); // 1 day
    var today = new Date();
    var xScale = new Plottable.Scales.Time()
        .domain([
          new Date(today.getTime() - dayOffset * 90),
          new Date(today.getTime() + dayOffset)
        ]);

    var xAxis = new Plottable.Axes.Time(xScale, "bottom");
    var yScale = new Plottable.Scales.Linear();
    var yAxis = new Plottable.Axes.Numeric(yScale, "right");

    var pDate = function(d) {
      var dateString = d._id.year + "/" + d._id.month + "/" + d._id.day;
      return new Date(dateString);
    };
    var pValue = function(d) { return +d.value; };
    var pTooltip = function(d) { return +d.value + " BEX/BBD"; };

    // Chart Posts
    var lValue = new Plottable.Plots.Bar();
    lValue.addDataset(dataset);
    lValue.x(pDate, xScale)
            .y(pValue, yScale)
            .attr("data-title", pTooltip)
            .attr("data-position", "bottom center")
            .attr("data-variation", "inverted")
            .attr("fill", "#2185D0");

    var cs = new Plottable.Scales.Color();
    cs.range(["#2185D0"]);
    cs.domain(["BEX/BBD"]);
    var legend = new Plottable.Components.Legend(cs);

    var squareFactory = Plottable.SymbolFactories.square();
    var circleFactory = Plottable.SymbolFactories.circle();

    legend.symbol(function (d, i) {
      if(i === 0) { return squareFactory; }
      else { return circleFactory; }
    });

    legend.maxEntriesPerRow(5)

    var yLabelValue = new Plottable.Components.AxisLabel("BEX/BBD", "90");
    var xLabelTitle = new Plottable.Components.TitleLabel("90-day Transfers", "0");

    var plots = new Plottable.Components.Group([lValue]);
    var table = new Plottable.Components.Table([
      [xLabelTitle, null, null],
      [legend, null, null],
      [plots, yAxis, yLabelValue],
      [xAxis, null, null]
    ]);

    table.renderTo("svg#account-transfers");
    $(".bar-area rect").popup({target: '#account-transfers'});
  });
</script>
