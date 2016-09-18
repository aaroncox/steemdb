<script>
  d3.json("/api/account/{{ account.name }}/votes").get(function(error, rows) {
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
    var pVotes = function(d) { return +d.votes; };
    var pIncoming = function(d) { return +d.incoming; };
    var pOutgoing = function(d) { return +d.outgoing; };

    // Chart all votes
    var lVotes = new Plottable.Plots.Line();
    lVotes.addDataset(dataset);
    lVotes.x(pDate, xScale)
            .y(pVotes, yScale2)
            .attr("stroke", "#0C42D4");

    // Chart outgoing votes
    var lOutgoing = new Plottable.Plots.Line();
    lOutgoing.addDataset(dataset);
    lOutgoing.x(pDate, xScale)
            .y(pOutgoing, yScale)
            .attr("stroke", "#D2760C");

    // Chart incoming votes
    var lIncoming = new Plottable.Plots.Line();
    lIncoming.addDataset(dataset);
    lIncoming.x(pDate, xScale)
            .y(pIncoming, yScale2)
            .attr("stroke", "#58DC0A");


    var cs = new Plottable.Scales.Color();
    cs.range(["#D2760C", "#58DC0A"]);
    cs.domain(["Outgoing", "Incoming"]);
    var legend = new Plottable.Components.Legend(cs);
    legend.maxEntriesPerRow(3);

    var squareFactory = Plottable.SymbolFactories.square();
    var circleFactory = Plottable.SymbolFactories.circle();

    legend.symbol(function (d, i) {
      if(i === 0) { return squareFactory; }
      else { return circleFactory; }
    });

    legend.maxEntriesPerRow(5)

    var yLabelOutgoing = new Plottable.Components.AxisLabel("Outgoing Votes", "90");
    var yLabelTotal = new Plottable.Components.AxisLabel("Incoming Votes", "270");

    var xLabelTitle = new Plottable.Components.TitleLabel("30-day Voting Activity", "0");

    var plots = new Plottable.Components.Group([lOutgoing, lIncoming]);
    var table = new Plottable.Components.Table([
      [null, null, xLabelTitle, null, null],
      [null, null, legend, null, null],
      [yLabelTotal, yAxis2, plots, yAxis, yLabelOutgoing],
      [null, null, xAxis, null, null]
    ]);

    table.renderTo("svg#account-votes");
  });
</script>
