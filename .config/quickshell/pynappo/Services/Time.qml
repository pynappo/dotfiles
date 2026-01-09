pragma Singleton

import Quickshell
import QtQuick

Singleton {
  id: root
  readonly property string text: {
    Qt.formatDateTime(clock.date, "hh:mm:ss")
  }

  SystemClock {
    id: clock
    precision: SystemClock.Seconds
  }
}
