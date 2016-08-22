<script>
if(!window.steemdb) window.steemdb = {};
window.steemdb.chart_mining = function() {
  d3.json("/api/account/{{ account.name }}/mining").get(function(error, rows) {
    var data = rows;
    var dataset = new Plottable.Dataset(data);
    var dayOffset = (24*60*60*1000); // 1 day
    var today = new Date();
    var xScale = new Plottable.Scales.Time()
        .domain([
          new Date(today.getTime() - dayOffset * 45),
          new Date(today.getTime())
        ]);

    var xAxis = new Plottable.Axes.Time(xScale, "bottom");
    var yScale = new Plottable.Scales.Linear();
    var yAxis = new Plottable.Axes.Numeric(yScale, "right");

    var pDate = function(d) {
      var dateString = d._id.year + "/" + d._id.month + "/" + d._id.day;
      return new Date(dateString);
    };
    var pBlocks = function(d) { return +d.blocks; };

    // Chart Highest Payouts
    var lBlocks = new Plottable.Plots.Bar();
    lBlocks.addDataset(dataset);
    lBlocks.x(pDate, xScale)
            .y(pBlocks, yScale)
            .attr("fill", "#58DC0A");

    var cs = new Plottable.Scales.Color();
    cs.range(["#58DC0A"]);
    cs.domain(["Blocks"]);
    var legend = new Plottable.Components.Legend(cs);
    legend.maxEntriesPerRow(3);

    var squareFactory = Plottable.SymbolFactories.square();
    var circleFactory = Plottable.SymbolFactories.circle();

    legend.symbol(function (d, i) {
      if(i === 0) { return squareFactory; }
      else { return circleFactory; }
    });

    legend.maxEntriesPerRow(5)

    var yLabelPosts = new Plottable.Components.AxisLabel("Blocks", "90");
    var xLabelTitle = new Plottable.Components.TitleLabel("45-day Mining Activity", "0");

    var plots = new Plottable.Components.Group([lBlocks]);
    var table = new Plottable.Components.Table([
      [xLabelTitle, null],
      [legend, null],
      [plots, yAxis],
      [xAxis, null]
    ]);

    table.renderTo("svg#account-mining");
  });
}
</script>
