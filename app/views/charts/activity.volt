<script>
  d3.json("/api/activity").get(function(error, rows) {
    var data = rows;
    var dataset = new Plottable.Dataset(data);
    var dayOffset = (24*60*60*1000); // 1 day
    var today = new Date();
    var xScale = new Plottable.Scales.Time()
        .domain([
          new Date(today.getTime() - dayOffset * 90),
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
    var pPosts = function(d) { return +d.posts; };
    var pAvg = function(d) { return +d.avg; };
    var pMax = function(d) { return +d.max; };
    var pTotal = function(d) { return +d.total; };
    var pVotes = function(d) { return +d.votes; };

    // Chart Highest Payouts
    var lPayouts = new Plottable.Plots.Area();
    lPayouts.addDataset(dataset);
    lPayouts.x(pDate, xScale)
            .y0(pAvg, yScale)
            .y(pMax, yScale)
            .attr("fill", "#999999")
            .attr("stroke-width", 0);

    // Chart Totals
    var lTotal = new Plottable.Plots.Area();
    lTotal.addDataset(dataset);
    lTotal.x(pDate, xScale)
            .y0(pAvg, yScale)
            .y(pTotal, yScale)
            .attr("fill", "#bbbbbb")
            .attr("stroke-width", 0);

    // Chart Posts
    var lPosts = new Plottable.Plots.Line();
    lPosts.addDataset(dataset);
    lPosts.x(pDate, xScale)
           .y(pPosts, yScale2)
           .attr("stroke", "#EF320B")
           ;

    // // Chart Replies
    // var lReplies = new Plottable.Plots.Line();
    // lReplies.addDataset(dataset);
    // lReplies.x(pDate, xScale)
    //          .y(pReplies, yScale2)
    //          .attr("stroke", "#0A46D6")
    //          ;

    // Chart Votes
    var lVotes = new Plottable.Plots.Line();
    lVotes.addDataset(dataset);
    lVotes.x(pDate, xScale)
             .y(pVotes, yScale)
             .attr("stroke", "#58DC0A");

    var cs = new Plottable.Scales.Color();
    cs.range(["#999999", "#bbbbbb", "#EF320B", "#58DC0A"]);
    cs.domain(["Highest Payout", "Total Payouts", "Root Posts", "Root Votes"]);
    var legend = new Plottable.Components.Legend(cs);
    legend.maxEntriesPerRow(3);

    var squareFactory = Plottable.SymbolFactories.square();
    var circleFactory = Plottable.SymbolFactories.circle();

    legend.symbol(function (d, i) {
      if(i === 0) { return squareFactory; }
      else { return circleFactory; }
    });

    legend.maxEntriesPerRow(5)

    var yLabelVotes = new Plottable.Components.AxisLabel("BBD Value", "270");
    var yLabelPosts = new Plottable.Components.AxisLabel("Posts/Votes", "90");
    var xLabelTitle = new Plottable.Components.TitleLabel("45-day Network Activity", "0");

    var plots = new Plottable.Components.Group([lTotal, lPayouts, lPosts, lVotes]);
    var table = new Plottable.Components.Table([
      [null, null, xLabelTitle, null, null],
      [null, null, legend, null, null],
      [yLabelVotes, yAxis, plots, yAxis2, yLabelPosts],
      [null, null, xAxis, null, null]
    ]);

    table.renderTo("svg#activity");
  });
</script>
