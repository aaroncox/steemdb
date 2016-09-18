<script>
  d3.json("/api/account/{{ account.name }}/posts").get(function(error, rows) {
    var data = rows;
    var dataset = new Plottable.Dataset(data);
    var dayOffset = (24*60*60*1000); // 1 day
    var today = new Date();
    var xScale = new Plottable.Scales.Time()
        .domain([
          new Date(today.getTime() - dayOffset * 30),
          new Date(today.getTime())
        ]);

    var xAxis = new Plottable.Axes.Time(xScale, "bottom");
    var yScale = new Plottable.Scales.Linear();
    var yScale2 = new Plottable.Scales.Linear();
    var yAxis = new Plottable.Axes.Numeric(yScale, "right");
    var yAxis2 = new Plottable.Axes.Numeric(yScale2, "left");

    var pDate = function(d) {
      var dateString = d._id.year + "/" + d._id.month + "/" + d._id.day;
      return new Date(dateString);
    };
    var pPosts = function(d) { return +d.posts; };
    var pReplies = function(d) { return +d.replies; };

    // Chart Posts
    var lPosts = new Plottable.Plots.Bar();
    lPosts.addDataset(dataset);
    lPosts.x(pDate, xScale)
            .y(pPosts, yScale)
            .attr("fill", "#2185D0");

    // Chart Replies
    var lReplies = new Plottable.Plots.Line();
    lReplies.addDataset(dataset);
    lReplies.x(pDate, xScale)
            .y(pReplies, yScale2)
            .attr("stroke", "#58DC0A");

    var cs = new Plottable.Scales.Color();
    cs.range(["#2185D0", "#58DC0A"]);
    cs.domain(["Posts", "Replies"]);
    var legend = new Plottable.Components.Legend(cs);
    legend.maxEntriesPerRow(3);

    var squareFactory = Plottable.SymbolFactories.square();
    var circleFactory = Plottable.SymbolFactories.circle();

    legend.symbol(function (d, i) {
      if(i === 0) { return squareFactory; }
      else { return circleFactory; }
    });

    legend.maxEntriesPerRow(5)

    var yLabelPosts = new Plottable.Components.AxisLabel("Posts", "90");
    var yLabelReplies = new Plottable.Components.AxisLabel("Replies", "270");
    var xLabelTitle = new Plottable.Components.TitleLabel("30-day Posting Activity", "0");

    var plots = new Plottable.Components.Group([lPosts, lReplies]);
    var table = new Plottable.Components.Table([
      [null, null, xLabelTitle, null, null],
      [null, null, legend, null, null],
      [yLabelReplies, yAxis2, plots, yAxis, yLabelPosts],
      [null, null, xAxis, null, null]
    ]);

    table.renderTo("svg#account-posts");
  });
</script>
