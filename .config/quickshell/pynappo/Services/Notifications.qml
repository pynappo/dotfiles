pragma Singleton
import Quickshell
import Quickshell.Services.Notifications
import QtQuick

Singleton {
  id: root
  property alias tracked: server.trackedNotifications
  property list<Notification> list: []
  property var history: []
  NotificationServer {
    id: server
    // inlineReplySupported: true
    // hasInlineReply: true
    bodySupported: true
    actionsSupported: true
    actionIconsSupported: true
    bodyHyperlinksSupported: true
    imageSupported: true
    bodyMarkupSupported: true
    keepOnReload: true
    persistenceSupported: true
    onNotification: (notification) => {
      notification.tracked = true;
      root.list = [...root.list, notification]
      root.history = [...root.history, {
        appName: notification.appName,
        appIcon: notification.appIcon,
        body: notification.body,
        summary: notification.summary,
        image: notification.image,
        timestamp: Date.now(),
      }]
      notification.closed.connect(() => {
        root.list = root.list.filter((n) => n !== notification)
      })
    }
    Component.onCompleted: {
      console.log("Notification Server started")
    }
  }
}
