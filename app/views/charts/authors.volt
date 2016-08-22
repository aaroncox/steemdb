<script>
  d3.json("/api/growth").get(function(error, rows) {
    console.log(rows);
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
    var pVotes = function(d) { return +d.votes; };
    var pReplies = function(d) { return +d.replies; };
    var pPosts = function(d) { return +d.posts; };
    var pAuthors = function(d) { return +d.authors; };
    var pUsers = function(d) { return +d.users; };

    var lUsers = new Plottable.Plots.Line();
    lUsers.addDataset(dataset);
    lUsers.x(pDate, xScale)
             .y(pUsers, yScale)
             .attr("stroke", "#58DC0A")
             ;

    var lAuthors = new Plottable.Plots.Line();
    lAuthors.addDataset(dataset);
    lAuthors.x(pDate, xScale)
            .y(pAuthors, yScale2)
            .attr("stroke", "#0939D6")
            ;

    var cs = new Plottable.Scales.Color();
    cs.range(["#0939D6", "#58DC0A", "#EF320B"]);
    cs.domain(["Unique Authors", "Users"]);
    var legend = new Plottable.Components.Legend(cs);
    legend.maxEntriesPerRow(3);

    var squareFactory = Plottable.SymbolFactories.square();
    var circleFactory = Plottable.SymbolFactories.circle();

    legend.symbol(function (d, i) {
      if(i === 0) { return squareFactory; }
      else { return circleFactory; }
    });

    legend.maxEntriesPerRow(5)

    var yLabelVotes = new Plottable.Components.AxisLabel("Total Users", "270");
    var yLabelPosts = new Plottable.Components.AxisLabel("Unique Authors", "90");
    var xLabelTitle = new Plottable.Components.TitleLabel("90-day Author Growth", "0");

    var plots = new Plottable.Components.Group([lAuthors, lUsers]);
    var table = new Plottable.Components.Table([
      [null, null, xLabelTitle, null, null],
      [null, null, legend, null, null],
      [yLabelVotes, yAxis, plots, yAxis2, yLabelPosts],
      [null, null, xAxis, null, null]
    ]);

    table.renderTo("svg#authors");
  });
</script>
