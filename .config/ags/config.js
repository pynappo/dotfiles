const date = Variable("", {
  poll: [1000, "date"],
});
function Bar(monitor = 0) {
  const myLabel = Widget.Label({
    label: "Example",
  });

  return Widget.Window({
    monitor,
    name: `bar${monitor}`,
    anchor: ["top", "left", "right"],
    child: myLabel,
  });
}

App.config({
  windows: [Bar(0), Bar(1)],
});
