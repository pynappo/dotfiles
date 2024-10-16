const notifications = await Service.import("notifications");
import GLib from "gi://GLib";
notifications.popupTimeout = 10 * 1000; // 10s

/** @param {import('resource:///com/github/Aylur/ags/service/notifications.js').Notification} n */
function NotificationIcon({ app_entry, app_icon, image }) {
  if (image) {
    return Widget.Box({
      css:
        `background-image: url("${image}");` +
        "background-size: contain;" +
        "background-repeat: no-repeat;" +
        "background-position: center;",
    });
  }

  let icon = "dialog-information-symbolic";
  if (Utils.lookUpIcon(app_icon)) icon = app_icon;

  if (app_entry && Utils.lookUpIcon(app_entry)) icon = app_entry;

  return Widget.Box({
    child: Widget.Icon(icon),
  });
}

/** @param {import('resource:///com/github/Aylur/ags/service/notifications.js').Notification} n */
function Notification(n) {
  const icon = Widget.Box({
    vpack: "start",
    class_name: "icon",
    child: NotificationIcon(n),
  });

  const title = Widget.Label({
    class_name: "title",
    xalign: 0,
    justification: "left",
    hexpand: true,
    max_width_chars: 24,
    truncate: "end",
    wrap: true,
    label: n.summary,
    use_markup: true,
  });

  const body = Widget.Label({
    class_name: "body",
    hexpand: true,
    use_markup: true,
    xalign: 0,
    justification: "left",
    label: n.body,
    wrap: true,
  });

  const actions = Widget.Box({
    class_name: "actions",
    children: n.actions.map(({ id, label }) =>
      Widget.Button({
        class_name: "action-button",
        on_clicked: () => {
          n.invoke(id);
          n.dismiss();
        },
        hexpand: true,
        child: Widget.Label(label),
      }),
    ),
  });

  return Widget.EventBox(
    {
      attribute: { id: n.id },
      on_primary_click: n.dismiss,
    },
    Widget.Box(
      {
        class_name: `notification ${n.urgency}`,
        vertical: true,
      },
      Widget.Box([icon, Widget.Box({ vertical: true }, title, body)]),
      actions,
    ),
  );
}
const urgency_to_priority = {
  low: 2,
  normal: 3,
  urgent: 4,
};
export function NotificationPopups(monitor = 0) {
  const list = Widget.Box({
    vertical: true,
    children: notifications.popups.map(Notification),
  });

  function onNotified(_, id: number) {
    const n = notifications.getNotification(id);
    if (n) {
      list.children = [Notification(n), ...list.children];
    }
  }

  function onDismissed(_, id: number) {
    list.children.find((n) => n.attribute.id === id)?.destroy();
  }

  list
    .hook(notifications, onNotified, "notified")
    .hook(notifications, onDismissed, "dismissed");

  const NTFYSH_URL = GLib.getenv("NTFYSH_TO_PHONE_URL");
  if (monitor != 0) {
    const NTFYSH_IGNORE = {
      vesktop: true,
    };
    if (!NTFYSH_URL) {
      Utils.notify({
        urgency: "low",
        summary: "Incomplete configuration",
        body: "NTFYSH_TO_PHONE_URL not set",
      });
    } else {
      list.hook(
        notifications,
        (_, id) => {
          const n = notifications.getNotification(id);
          console.log(n);
          // prettier-ignore
          if (n) {
            if (!NTFYSH_IGNORE[n.app_name]) {
              Utils.execAsync([
                "curl",
                "-H", `Title: (${n.app_name}) ${n.summary}`,
                "-H", `Priority: ${urgency_to_priority[n.urgency]}`,
                "-d", n.body,
                NTFYSH_URL,
              ]);
            }
          }
        },
        "notified",
      );
    }
  }

  return Widget.Window({
    monitor,
    name: `notifications${monitor}`,
    class_name: "notification-popups",
    anchor: ["bottom", "right"],
    child: Widget.Box({
      css: "min-width: 2px; min-height: 2px;",
      class_name: "notifications",
      vertical: true,
      child: list,
    }),
  });
}
