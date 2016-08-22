<script>
  var data = [];
for (var i = 1; i < 184; i++) {
  data.push({
    date: new Date(2015, 0, i),
    val: 1.5 * Math.random() - 0.5
  });
}

var daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

// Gets the date of the top left square in the calendar, i.e. the first Sunday on / before Jan 1
function getFirstDisplayableSunday(date) {
  return new Date(
    date.getFullYear(),
    0,
    1 - new Date(date.getFullYear(), 0, 1).getDay()
  );
}

function getWeekOfTheYear(date) {
  var firstSunday = getFirstDisplayableSunday(date);
  var diff = date - firstSunday;
  var oneDay = 1000 * 60 * 60 * 24;
  return Math.floor(Math.ceil(diff / oneDay) / 7);
}

function monthFormatter() {
  return function(yearAndWeek) {
    var year = yearAndWeek[0];
    var week = yearAndWeek[1];
    var startOfWeek = new Date(year, 0, (week + 1) * 7 - new Date(year, 0, 1).getDay());
    if (startOfWeek.getDate() > 7) {
      return "";
    }
    return months[startOfWeek.getMonth()];
  }
}

var xScale = new Plottable.Scales.Category();
var yScale = new Plottable.Scales.Category();
yScale.domain(daysOfWeek);

var xAxis = new Plottable.Axes.Category(xScale, "bottom");
var yAxis = new Plottable.Axes.Category(yScale, "left");
xAxis.formatter(monthFormatter());

var colorScale = new Plottable.Scales.InterpolatedColor();
colorScale.domain([0,1]);
colorScale.range(["#eee", "#d6e685", "#8cc665", "#44a340", "#1e6823"]);

var plot = new Plottable.Plots.Rectangle()
  .addDataset(new Plottable.Dataset(data))
  .x(function(d) { return [d.date.getFullYear(), getWeekOfTheYear(d.date)] }, xScale)
  .y(function(d) { return daysOfWeek[d.date.getDay()] }, yScale)
  .attr("fill", function(d) { return d.val; }, colorScale)
  .attr("stroke", "#fff")
  .attr("stroke-width", 2);

var plotHighlighter = new Plottable.Plots.Rectangle()
  .addDataset(new Plottable.Dataset(data))
  .x(function(d) { return [d.date.getFullYear(), getWeekOfTheYear(d.date)] }, xScale)
  .y(function(d) { return daysOfWeek[d.date.getDay()] }, yScale)
  .attr("fill", "black")
  .attr("fill-opacity", 0);

var group = new Plottable.Components.Group([plot, plotHighlighter]);

var interaction = new Plottable.Interactions.Pointer();
interaction.onPointerEnter(function(p) {
  var entity = plot.entityNearest(p);
})
interaction.onPointerMove(function(p) {
  var nearestEntity = plotHighlighter.entityNearest(p);
  // var hoveredMonth = nearestEntity.datum.date.getMonth();
  plotHighlighter.entities().forEach(function(entity) {
    entity.selection.attr("fill-opacity", 0);
    entity.selection.attr("fill", "transparent");
  });
  var entity = plotHighlighter.entityNearest(p);
  entity.selection.attr("fill-opacity", 1);
  entity.selection.attr("fill", "blue");

})
interaction.onPointerExit(function() {
  plotHighlighter.entities().forEach(function(entity) {
    entity.selection.attr("fill-opacity", 0);
  });
})
interaction.attachTo(plot);

var table = new Plottable.Components.Table([
  [yAxis, group],
  [null,  xAxis]
]);

table.renderTo("svg#daily");

// Initializing tooltip anchor
var tooltipAnchorSelection = plot.foreground().append("circle").attr({
  r: 3,
  opacity: 0
});

var tooltipAnchor = $(tooltipAnchorSelection.node());
console.log(tooltipAnchor)
tooltipAnchor.popup({
  animation: false,
  container: "body",
  placement: "auto",
  title: "text",
  trigger: "manual"
});
</script>
