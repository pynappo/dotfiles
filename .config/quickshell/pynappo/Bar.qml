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
            [[2, 4, 6 ,8], [1, 3, 5, 7]],
          ]
          const sticky_workspace_ids = sticky_workspaces_maps[Hyprland.monitors.values.length][panel.hyprmonitor.id]
          const fake_workspace_ids = sticky_workspace_ids.filter((id) => !panel.workspaces.find((ws) => ws.id == id))

          return [...panel.workspaces, ...fake_workspace_ids].sort((a, b) => {
            return id(a) - id(b)
          })
        }
        Button {
          id: workspaceButton
          required property var modelData
          property HyprlandWorkspace workspace: {
            typeof(modelData) == "object" ? modelData : null
          }
          property int workspace_id: {
            typeof(modelData) == "number" ? modelData : workspace.id
          }
          implicitWidth: workspaceMouseArea.width + 4
          implicitHeight: workspaceMouseArea.height + 2
          WrapperMouseArea {
            id: workspaceMouseArea
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            anchors.fill: parent
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
            RowLayout {
              IconImage {
                implicitSize: 15
                Layout.leftMargin: 5
                source: Quickshell.iconPath(workspaceButton.workspace?.toplevels.values[1]?.wayland?.appId, true)
              }
              Text {
                Layout.maximumWidth: 200
                text: workspaceButton.workspace_id
                wrapMode: Text.ElideRight
                maximumLineCount: 1
                color: activePalette.text
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
          Button {
            id: toplevelButton
            required property var modelData
            property HyprlandToplevel toplevel: modelData
            implicitWidth: clientRow.implicitWidth
            implicitHeight: clientRow.implicitHeight + 2
            Layout.preferredWidth: implicitWidth
            Layout.preferredHeight: implicitHeight
            WrapperMouseArea {
              id: toplevelMouseArea
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
                id: clientRow
                IconImage {
                  implicitSize: 15
                  Layout.leftMargin: 5
                  source: Quickshell.iconPath(toplevelButton.toplevel?.wayland?.appId, true)
                }
                Text {
                  Layout.maximumWidth: 200
                  text: toplevelButton.toplevel?.title ?? ""
                  elide: Text.ElideRight
                  wrapMode: Text.NoWrap
                  color: activePalette.text
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
              edges: Edges.Top | Edges.Right
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
      Button {
        id: sidebarToggleButton
        Layout.rightMargin: 5
        implicitWidth: 26
        implicitHeight: 26
        checkable: true
        checked: notificationSidebar.visible
        onCheckedChanged: () => notificationSidebar.visible = sidebarToggleButton.checked
        IconImage {
          anchors.centerIn: parent
          implicitSize: 16
          source: Quickshell.iconPath("notification-symbolic", true)
        }
        ToolTip.visible: hovered
        ToolTip.text: "Notification history"
      }
      Text {
        Layout.minimumWidth: 75
        Layout.rightMargin: 10
        Layout.leftMargin: 10
        color: "#ffffff"
        text: Services.Time.text
      }
    }

    // notifs history sidebar
    PanelWindow {
      id: notificationSidebar
      visible: false
      color: "transparent"
      anchors {
        right: true
        top: true
        bottom: true
      }
      margins {
        right: 8
        top: 8
        bottom: 8
      }
      width: 340
      ColumnLayout {
        anchors.fill: parent
        spacing: 8
        Rectangle {
          Layout.fillWidth: true
          Layout.preferredHeight: 40
          radius: 10
          color: activePalette.window
          RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 12
            Text {
              text: "Notifications"
              font.bold: true
              color: activePalette.text
            }
            Rectangle { Layout.fillWidth: true }
            Button {
              implicitWidth: 26
              implicitHeight: 26
              text: "X"
              onClicked: () => notificationSidebar.visible = false
            }
          }
        }
        Rectangle {
          Layout.fillWidth: true
          Layout.fillHeight: true
          radius: 10
          color: activePalette.window
          clip: true
          ScrollView {
            anchors.fill: parent
            clip: true
            ListView {
              id: historyList
              model: Services.Notifications.history
              spacing: 6
              anchors.fill: parent
              delegate: Rectangle {
                required property var modelData
                width: historyList.width - 16
                anchors.bottom: parent.top
                implicitHeight: mainColumn.implicitHeight + 20
                radius: 8
                color: activePalette.base
                ColumnLayout {
                  id: mainColumn
                  anchors {
                    left: parent.left
                    right: parent.right
                    top: parent.top
                    margins: 10
                  }
                  RowLayout {
                    IconImage {
                      implicitSize: 20
                      source: Quickshell.iconPath(modelData.appIcon, true)
                    }
                    Text {
                      text: modelData.appName
                      color: activePalette.text
                      font.bold: true
                    }
                    Rectangle { Layout.fillWidth: true }
                  }
                  Image {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 120
                    fillMode: Image.PreserveAspectFit
                    source: modelData.image != "" ? URL(modelData.image) : ""
                    visible: modelData.image != ""
                  }
                  Text {
                    Layout.fillWidth: true
                    color: activePalette.text
                    text: modelData.body
                    wrapMode: Text.WordWrap
                    visible: modelData.body != ""
                  }
                }
              }
              }
            }
          }
        }
      }
    // notifs
    Variants {
      model: Services.Notifications.list
      PanelWindow {
        required property var modelData
        id: notificationPopup
        property Notification notif: modelData
        property int notificationIndex: Services.Notifications.list.indexOf(modelData)
        visible: notif
        anchors {
          right: true
          bottom: true
        }
        margins {
          right: 10
          top: 10
          bottom: 10 + notificationPopup.notificationIndex * (notificationPopup.implicitHeight + 10)
          left: 10
        }
        color: "transparent";
        implicitWidth: 320
        implicitHeight: 160
        Rectangle {
          anchors.fill: parent
          radius: 10
          color: activePalette.window
          clip: true
          ColumnLayout {
            anchors.fill: parent;
            // top
            WrapperRectangle {
              Layout.fillWidth: true
              topLeftRadius: 10
              topRightRadius: 10
              color: activePalette.base
              RowLayout {
                IconImage {
                  implicitSize: 20
                  source: Quickshell.iconPath(notificationPopup.notif?.appIcon ?? "checkmark", true)
                }
                Text {
                  text: notificationPopup.notif.appName
                  color: activePalette.text
                }
                Rectangle {
                  Layout.fillWidth: true
                }
                Button {
                  width: parent.width * 2
                  text: "X"
                  onClicked: () => notificationPopup.notif?.dismiss()
                }
              }
            }
            // mid
            RowLayout {
              Layout.fillWidth: true
              Layout.minimumHeight: 0
              Image {
                source: URL(notificationPopup.notif?.image)
              }
              Text {
                color: activePalette.text
                text: notificationPopup.notif?.body ?? ""
                Layout.fillWidth: true
                Layout.minimumWidth: 0
                wrapMode: Text.WordWrap
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
                  Layout.fillWidth: true
                  text: modelData.text;
                  onClicked: () => {
                    modelData.invoke()
                  }

                  IconImage {
                    source: Quickshell.iconPath(notificationPopup.notif?.identifier, true);
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
