<script>
d3.json("/api/account/{{ account.name }}/history").get(function(error, rows) {
  var data = rows;
  var dataset = new Plottable.Dataset(data);
  var dayOffset = (24*60*60*1000); // 1 day
  var today = new Date();
  var xScale = new Plottable.Scales.Time()
      .domain([
        new Date(today.getTime() - dayOffset * 30),
        new Date(today.getTime() - dayOffset)
      ]);

  var xAxis = new Plottable.Axes.Time(xScale, "bottom");
  var yScale = new Plottable.Scales.Linear();
  var yScale2 = new Plottable.Scales.Linear();
  var yAxis = new Plottable.Axes.Numeric(yScale, "left");
  var yAxis2 = new Plottable.Axes.Numeric(yScale2, "right");

  var pDate = function(d) {
    var dateString = d._id.year + "/" + d._id.month + "/" + d._id.day;
    return new Date(dateString);
  };
  var pVests = function(d) { return +d.vests; };
  var pPosts = function(d) { return +d.posts; };
  var pFollowers = function(d) { return +d.followers; };

  // Chart Highest Payouts
  var lPosts = new Plottable.Plots.Bar();
  lPosts.addDataset(dataset);
  lPosts.x(pDate, xScale)
          .y(pPosts, yScale)
          .attr("fill", "#dddddd")
          .attr("stroke-width", 0);

  // Chart Totals
  var lFollowers = new Plottable.Plots.Line();
  lFollowers.addDataset(dataset);
  lFollowers.x(pDate, xScale)
          .y(pFollowers, yScale)
          .attr("stroke", "#0700D4")
          ;

  // Chart Posts
  var lVests = new Plottable.Plots.Line();
  lVests.addDataset(dataset);
  lVests.x(pDate, xScale)
         .y(pVests, yScale2)
         .attr("stroke", "#EF320B")
         ;

  var cs = new Plottable.Scales.Color();
  cs.range(["#dddddd", "#0700D4", "#EF320B"]);
  cs.domain(["Posts", "Followers", "Vests"]);
  var legend = new Plottable.Components.Legend(cs);
  legend.maxEntriesPerRow(3);

  var squareFactory = Plottable.SymbolFactories.square();
  var circleFactory = Plottable.SymbolFactories.circle();

  legend.symbol(function (d, i) {
    if(i === 0) { return squareFactory; }
    else { return circleFactory; }
  });

  legend.maxEntriesPerRow(5)

  var yLabelCRewards = new Plottable.Components.AxisLabel("Activity", "270");
  var yLabelVests = new Plottable.Components.AxisLabel("VESTS", "90");
  var xLabelTitle = new Plottable.Components.TitleLabel("30-day account history", "0");

  var plots = new Plottable.Components.Group([lPosts, lFollowers, lVests]);
  var table = new Plottable.Components.Table([
    [null, null, xLabelTitle, null, null],
    [null, null, legend, null, null],
    [yLabelCRewards, yAxis, plots, yAxis2, yLabelVests],
    [null, null, xAxis, null, null]
  ]);

  table.renderTo("svg#account-view");
});
</script>
