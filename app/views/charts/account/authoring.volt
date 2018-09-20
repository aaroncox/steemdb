<script>
  d3.json("/api/account/{{ account.name }}/authoring").get(function(error, rows) {
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
    var yScale2 = new Plottable.Scales.Linear();
    var yAxis2 = new Plottable.Axes.Numeric(yScale2, "left");

    var pDate = function(d) {
      var dateString = d._id.year + "/" + d._id.month + "/" + d._id.day;
      return new Date(dateString);
    };
    var pSteem = function(d) { return +d.steem; };
    var pVest = function(d) { return +d.vest; };
    var pSbd = function(d) { return +d.sbd; };

    // Chart Posts
    var lSteem = new Plottable.Plots.ClusteredBar();
    lSteem.addDataset(dataset);
    lSteem.x(pDate, xScale)
          .y(pSteem, yScale)
          .attr("fill", "#21BA45");

    var lVest = new Plottable.Plots.Line();
    lVest.addDataset(dataset);
    lVest.x(pDate, xScale)
            .y(pVest, yScale2)
            .attr("fill", "#2185D0");

    var lSbd = new Plottable.Plots.ClusteredBar();
    lSbd.addDataset(dataset);
    lSbd.x(pDate, xScale)
            .y(pSbd, yScale)
            .attr("fill", "#c83333");

    var cs = new Plottable.Scales.Color();
    cs.range(["#21BA45", "#2185D0", "#c83333"]);
    cs.domain(["Steem", "VESTS", "SBD"]);
    var legend = new Plottable.Components.Legend(cs);

    var squareFactory = Plottable.SymbolFactories.square();
    var circleFactory = Plottable.SymbolFactories.circle();

    legend.symbol(function (d, i) {
      if(i === 0) { return squareFactory; }
      else { return circleFactory; }
    });

    legend.maxEntriesPerRow(5)

    var yLabelValue = new Plottable.Components.AxisLabel("SBD/STEEM", "90");
    var xLabelTitle = new Plottable.Components.TitleLabel("90-day Author Rewards", "0");
    var yLabelVest = new Plottable.Components.AxisLabel("VESTS", "270");


    var plots = new Plottable.Components.Group([lSteem, lVest, lSbd]);
    var table = new Plottable.Components.Table([
      [null, null, xLabelTitle, null, null],
      [null, null, legend, null, null],
      [yLabelVest, yAxis2, plots, yAxis, yLabelValue],
      [null, null, xAxis, null, null]
    ]);

    table.renderTo("svg#account-authoring");
  });
</script>
