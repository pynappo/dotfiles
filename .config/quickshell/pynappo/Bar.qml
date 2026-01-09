pragma ComponentBehavior: Bound
// Bar.qml
import Quickshell
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick
import Quickshell.Hyprland
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import Quickshell.Services.Notifications
import "Services" as Services
import "Widgets/Bar" as BarWidgets

Variants {
  model: Quickshell.screens
  PanelWindow {
    id: panel
    required property var modelData
    screen: modelData
    property var hyprmonitor: Hyprland.monitorFor(screen)
    property var workspaces: {
      return Hyprland.workspaces.values.filter((ws) => ws.monitor?.id == hyprmonitor.id)
    }


    SystemPalette {
      id: activePalette
      colorGroup: SystemPalette.Active
    }
    color: activePalette.window
    anchors {
      bottom: true
      left: true
      right: true
    }

    implicitHeight: 30

    RowLayout {
      anchors {
        fill: parent
      }

      // left
      Repeater {
        function id(a) {
          return (typeof(a) == "number" ? a : a.id);
        }
        model: {
          const sticky_workspaces_maps = [
            [],
            [[1, 2, 3, 4, 5, 6, 7, 8]],
            [[1, 3, 5, 7], [2, 4, 6 ,8]],
          ]
          const sticky_workspace_ids = sticky_workspaces_maps[Hyprland.monitors.values.length][panel.hyprmonitor.id]
          const fake_workspace_ids = sticky_workspace_ids.filter((id) => !panel.workspaces.find((ws) => ws.id == id))

          return [...panel.workspaces, ...fake_workspace_ids].sort((a, b) => {
            return id(a) - id(b)
          })
        }
        WrapperRectangle {
          id: workspaceButton
          required property var modelData
          property HyprlandWorkspace workspace: {
            typeof(modelData) == "number" ? null : modelData
          }
          property int workspace_id: {
            typeof(modelData) == "number" ? modelData : workspace.id
          }
          margin: {
            top: 1
            bottom: 1
          }
          radius: 3
          WrapperMouseArea {
            id: mouseArea
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onClicked: (mouse) => {
              if (mouse.button === Qt.LeftButton) {
                if (workspaceButton.workspace) {
                  workspaceButton.workspace.activate();
                } else {
                  Hyprland.dispatch(`workspace ${workspaceButton.workspace_id}`)
                }
              }
            }
            hoverEnabled: true
            leftMargin: 5
            rightMargin: 5
            RowLayout {
              IconImage {
                implicitSize: 15
                source: Quickshell.iconPath(workspaceButton.workspace?.toplevels.values[1]?.wayland?.appId)
              }
              Text {
                id: text
                Layout.maximumWidth: 200
                text: workspaceButton.workspace_id
                wrapMode: Text.ElideRight
                maximumLineCount: 1
              }
            }
          }
        }
      }
      Item { Layout.fillWidth: true }

      // center
      Repeater {
        model: panel.workspaces

        Repeater {
          required property var modelData
          property HyprlandWorkspace workspace: modelData
          model: {
            return modelData.toplevels;
          }
          WrapperRectangle {
            id: toplevelButton
            required property var modelData
            property HyprlandToplevel toplevel: modelData
            margin: {
              top: 1
              bottom: 1
            }
            radius: 3
            WrapperMouseArea {
              acceptedButtons: Qt.LeftButton | Qt.RightButton
              onClicked: (mouse) => {
                if (mouse.button === Qt.LeftButton) {
                  toplevelButton.toplevel.workspace.activate();
                } else if (mouse.button === Qt.RightButton) {
                  toplevelButton.toplevel.wayland.activate()
                }
              }
              hoverEnabled: true
              RowLayout {
                IconImage {
                  implicitSize: 15
                  source: Quickshell.iconPath(toplevelButton.toplevel?.wayland?.appId)
                }
                Text {
                  Layout.maximumWidth: 200
                  text: toplevelButton.toplevel?.title ?? ""
                  elide: Text.ElideRight
                  wrapMode: Text.NoWrap
                }
              }
            }
          }
        }
      }

      // right
      Item { Layout.fillWidth: true }
      Repeater {
        model: SystemTray.items
        Button {
          id: trayItem
          required property var modelData
          Layout.preferredWidth: 25
          IconImage {
            anchors {
              centerIn: parent
            }
            implicitSize: 15
            source: trayItem.modelData.icon
          }
          QsMenuAnchor {
            id: trayItemMenuAnchor
            anchor {
              item: trayItem
              edges: Edges.Bottom | Edges.Right
              gravity: Edges.Top | Edges.Left
            }
            menu: trayItem.modelData.menu
          }
          onClicked: () => {
            trayItemMenuAnchor.open()
          }
          onHoveredChanged: () => {
            if (trayItem.hovered) {
              console.log(trayItem.modelData.title)
              console.log(trayItem.modelData.icon)
            }
          }
        }
      }

      // right
      Text {
        Layout.minimumWidth: 75
        Layout.rightMargin: 10
        Layout.leftMargin: 10
        color: "#ffffff"
        text: Services.Time.text
      }
    }

    // notifs
    Variants {
      model: Services.Notifications.list
      PanelWindow {
        required property var modelData
        id: notificationPopup
        property Notification notif: modelData
        anchors {
          right: true
          bottom: true
        }
        margins {
          right: 10
          top: 10
          bottom: 10
          left: 10
        }
        color: activePalette.window
        implicitWidth: 320
        implicitHeight: 160
        ColumnLayout {
          anchors.fill: parent
          // top
          RowLayout {
            Text {
              text: "hi"
              color: activePalette.text
            }
            Item {
              Layout.fillWidth: true
            }
            Button {
              text: "X"
              onClicked: () => notificationPopup.notif?.dismiss()
            }
          }
          // mid
          RowLayout {
            IconImage {
              implicitSize: 50
              source: Quickshell.iconPath(notificationPopup.notif?.appIcon ?? "checkmark")
            }
            Text {
              text: notificationPopup.notif?.body ?? "asdf"
            }
          }
          // footer (buttons)
          RowLayout {
            Repeater {
              model: {
                if (!notificationPopup.notif) {
                  return []
                }
                return notificationPopup.notif?.actions;
              }
              Button {
                required property NotificationAction modelData
                IconImage {
                  source: Quickshell.iconPath(notificationPopup.notif?.identifier);
                }
                Layout.fillWidth: true
                text: modelData.text;
                onClicked: () => {
                  modelData.invoke()
                }
              }
            }
          }
        }
      }
    }
  }
}
