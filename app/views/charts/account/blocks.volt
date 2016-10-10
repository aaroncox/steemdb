<script>
  d3.json("/api/account/{{ account.name }}/mining").get(function(error, rows) {
    var data = rows;
    var dataset = new Plottable.Dataset(data['pow']).metadata(2);
    var dataset2 = new Plottable.Dataset(data['witness']).metadata(5);
    var dayOffset = (24*60*60*1000); // 1 day
    var today = new Date();
    var xScale = new Plottable.Scales.Time()
        .domain([
          new Date(today.getTime() - dayOffset * 30),
          new Date(today.getTime() + dayOffset)
        ]);

    var xAxis = new Plottable.Axes.Time(xScale, "bottom");
    var yScale = new Plottable.Scales.Linear();
    var yAxis = new Plottable.Axes.Numeric(yScale, "right");

    var pDate = function(d) {
      var dateString = d._id.year + "/" + d._id.month + "/" + d._id.day;
      return new Date(dateString);
    };
    var pBlocks = function(d) { return +d.blocks; };
    var pTooltip = function(d) { return +d.blocks + " BLOCKS"; };

    var colorScale = new Plottable.Scales.InterpolatedColor();
    colorScale.range(["#BDCEF0", "#5279C7"]);

    var lBlocks = new Plottable.Plots.ClusteredBar();
    lBlocks.addDataset(dataset);
    lBlocks.addDataset(dataset2);
    lBlocks.x(pDate, xScale)
            .y(pBlocks, yScale)
            .attr("data-title", pTooltip)
            .attr("data-position", "bottom center")
            .attr("data-variation", "inverted")
            .attr("fill", function(d, i, dataset) { return dataset.metadata(); }, colorScale)

    var cs = new Plottable.Scales.Color();
    cs.range(["#BDCEF0","#5279C7"]);
    cs.domain(["POW","Witnessed"]);
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
    var xLabelTitle = new Plottable.Components.TitleLabel("30-day Block Generation Activity", "0");

    var plots = new Plottable.Components.Group([lBlocks]);
    var table = new Plottable.Components.Table([
      [xLabelTitle, null],
      [legend, null],
      [plots, yAxis],
      [xAxis, null]
    ]);

    table.renderTo("svg#account-blocks");
    $(".bar-area rect").popup({target: '#account-blocks'});
  });
</script>
