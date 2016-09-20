<script>
  d3.json("/api/account/{{ account.name }}/witness").get(function(error, rows) {
    var data = rows;
    var dataset = new Plottable.Dataset(data);
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
    var pVotes = function(d) { return +d.votes; };

    // Chart Posts
    var lVotes = new Plottable.Plots.Bar();
    lVotes.addDataset(dataset);
    lVotes.x(pDate, xScale)
            .y(pVotes, yScale)
            .attr("fill", "#2185D0");

    var cs = new Plottable.Scales.Color();
    cs.range(["#2185D0"]);
    cs.domain(["Votes"]);
    var legend = new Plottable.Components.Legend(cs);

    var squareFactory = Plottable.SymbolFactories.square();
    var circleFactory = Plottable.SymbolFactories.circle();

    legend.symbol(function (d, i) {
      if(i === 0) { return squareFactory; }
      else { return circleFactory; }
    });

    legend.maxEntriesPerRow(5)

    var yLabelVotes = new Plottable.Components.AxisLabel("Vote Weight", "90");
    var xLabelTitle = new Plottable.Components.TitleLabel("30-day Witness Votes", "0");

    var plots = new Plottable.Components.Group([lVotes]);
    var table = new Plottable.Components.Table([
      [xLabelTitle, null, null],
      [legend, null, null],
      [plots, yAxis, yLabelVotes],
      [xAxis, null, null]
    ]);

    table.renderTo("svg#account-witness");
  });
</script>
