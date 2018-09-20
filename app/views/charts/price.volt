<script>
  d3.json("/api/price").get(function(error, rows) {
    var data = rows;
    var dataset = new Plottable.Dataset(data);
    var dayOffset = (24*60*60*1000); // 1 day
    var today = new Date();
    var xScale = new Plottable.Scales.Time()
        .domain([
          new Date(today.getTime() - dayOffset * 45),
          new Date(today.getTime() - dayOffset)
        ]);
        console.log(rows);
    var xAxis = new Plottable.Axes.Time(xScale, "bottom");
    var yScale = new Plottable.Scales.Linear();
    var yAxis = new Plottable.Axes.Numeric(yScale, "left");

    var pDate = function(d) {
      var dateString = d._id.year + "/" + d._id.month + "/" + d._id.day;
      return new Date(dateString);
    };
    var pVotes = function(d) { return +d.count; };

    // Chart Votes
    var lVotes = new Plottable.Plots.Line();
    lVotes.addDataset(dataset);
    lVotes.x(pDate, xScale)
             .y(pVotes, yScale)
             .attr("stroke", "#58DC0A");

    var cs = new Plottable.Scales.Color();
    cs.range(["#58DC0A"]);
    cs.domain(["Total Votes"]);
    var legend = new Plottable.Components.Legend(cs);
    legend.maxEntriesPerRow(3);

    var squareFactory = Plottable.SymbolFactories.square();
    var circleFactory = Plottable.SymbolFactories.circle();

    legend.symbol(function (d, i) {
      if(i === 0) { return squareFactory; }
      else { return circleFactory; }
    });

    legend.maxEntriesPerRow(5)

    var yLabelVotes = new Plottable.Components.AxisLabel("Votes", "270");
    var xLabelTitle = new Plottable.Components.TitleLabel("45-day Voting", "0");

    var plots = new Plottable.Components.Group([lVotes]);
    var table = new Plottable.Components.Table([
      [null, null, xLabelTitle, null, null],
      [null, null, legend, null, null],
      [yLabelVotes, yAxis, plots],
      [null, null, xAxis, null, null]
    ]);

    table.renderTo("svg#votes");
  });
</script>
