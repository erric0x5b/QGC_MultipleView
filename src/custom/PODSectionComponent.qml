import QtQuick                  2.4
import QtPositioning            5.2
import QtQuick.Layouts          1.2
import QtQuick.Controls         1.4
import QtQuick.Dialogs          1.2
import QtGraphicalEffects       1.0

import QGroundControl                   1.0
import QGroundControl.ScreenTools       1.0
import QGroundControl.Controls          1.0
import QGroundControl.Palette           1.0
import QGroundControl.Vehicle           1.0
import QGroundControl.Controllers       1.0
import QGroundControl.FactSystem        1.0
import QGroundControl.FactControls      1.0

//ROV DATA
Item{
    Rectangle{
        id:                     dataSpace
        color:                  "transparent"
        gradient: Gradient {
            GradientStop {
                position: 0.29;
                color: "#141033";
            }
            GradientStop {
                position: 1.00;
                color: "#041082";
            }
        }
        visible: true
        border.width: 1
        width:                  multiVideoWindow.width/2
        height:                 multiVideoWindow.height
        x:                      0
        y:                      0

        //POD 1
        Rectangle{
            id:                     pod1Section
            color:                  Qt.rgba(0,0,0,0.40)
            visible: true
            border.width: 1
            radius:                 10
            width:                  dataSpace.width/4
            height:                 dataSpace.height/2-10
            anchors.left:           dataSpace.left
            anchors.top:            dataSpace.top
            anchors.topMargin:      5
            anchors.leftMargin:     5

            QGCLabel{
                id:                 labelPod1
                text:               qsTr("POD 1")
                font.family:        ScreenTools.demiboldFontFamily
                color:              "white"
                font.pointSize:     ScreenTools.largeFontPointSize
                anchors.horizontalCenter:     pod1Section.horizontalCenter
                anchors.top:        pod1Section.top
                anchors.topMargin:  10
                anchors.rightMargin: 10
            }

            QGCLabel{
                id:                 labelBatt1
                text:               qsTr("Batt V:")
                font.family:        ScreenTools.demiboldFontFamily
                color:              "white"
                font.pointSize:     ScreenTools.largeFontPointSize
                anchors.left:       pod1Section.left
                anchors.top:        labelPod1.bottom
                anchors.leftMargin: 10
                anchors.topMargin:  10
            }
            QGCLabel{
                id:                 labelVbat1
                text:               qsTr("00.0 V")
                font.family:        ScreenTools.normalFontFamily
                color:              "Light Green"
                font.pointSize:     ScreenTools.largeFontPointSize
                anchors.left:       pod1Section.horizontalCenter
                anchors.verticalCenter:   labelBatt1.verticalCenter
                anchors.leftMargin: 20
            }

            QGCLabel{
                id:                 labelIBatt1
                text:               qsTr("Batt A:")
                font.family:        ScreenTools.demiboldFontFamily
                color:              "white"
                font.pointSize:     ScreenTools.largeFontPointSize
                anchors.left:       pod1Section.left
                anchors.top:        labelBatt1.bottom
                anchors.leftMargin: 10
                anchors.topMargin:  5
            }
            QGCLabel{
                id:                 labelIBattv1
                text:               qsTr("00.0 A")
                font.family:        ScreenTools.normalFontFamily
                color:              "Light Green"
                font.pointSize:     ScreenTools.largeFontPointSize
                anchors.left:       pod1Section.horizontalCenter
                anchors.verticalCenter:   labelIBatt1.verticalCenter
                anchors.leftMargin: 20
            }

            QGCLabel{
                id:                 labelV481
                text:               qsTr("Power IN:")
                font.family:        ScreenTools.demiboldFontFamily
                color:              "white"
                font.pointSize:     ScreenTools.largeFontPointSize
                anchors.left:       pod1Section.left
                anchors.top:        labelIBatt1.bottom
                anchors.leftMargin: 10
                anchors.topMargin:  5
            }
            QGCLabel{
                id:                 labelV48v1
                text:               qsTr("00.0 V")
                font.family:        ScreenTools.normalFontFamily
                color:              "Light Green"
                font.pointSize:     ScreenTools.largeFontPointSize
                anchors.left:       pod1Section.horizontalCenter
                anchors.verticalCenter:   labelV481.verticalCenter
                anchors.leftMargin: 20
            }

            QGCLabel{
                id:                 labelMott1
                text:               qsTr("Mott:")
                font.family:        ScreenTools.demiboldFontFamily
                color:              "white"
                font.pointSize:     ScreenTools.largeFontPointSize
                anchors.top:        labelV481.bottom
                anchors.left:       pod1Section.left
                anchors.leftMargin: 10
                anchors.topMargin:  5
            }
            QGCLabel{
                id:                 labelVmot1
                text:               qsTr("00.0 V")
                font.family:        ScreenTools.normalFontFamily
                color:              "Light Green"
                font.pointSize:     ScreenTools.largeFontPointSize
                anchors.left:       pod1Section.horizontalCenter
                anchors.verticalCenter:   labelMott1.verticalCenter
                anchors.leftMargin: 20
            }

            QGCLabel{
                id:                 labelTemperature1
                text:               qsTr("Temp:")
                font.family:        ScreenTools.demiboldFontFamily
                color:              "white"
                font.pointSize:     ScreenTools.largeFontPointSize
                anchors.left:       pod1Section.left
                anchors.top:        labelMott1.bottom
                anchors.leftMargin: 10
                anchors.topMargin:  5
            }
            QGCLabel{
                id:                 labelTemperaturev1
                text:               qsTr("00.0°C")
                font.family:        ScreenTools.normalFontFamily
                color:              "Light Green"
                font.pointSize:     ScreenTools.largeFontPointSize
                anchors.left:       pod1Section.horizontalCenter
                anchors.verticalCenter:   labelTemperature1.verticalCenter
                anchors.leftMargin: 20
            }

            QGCSwitch{
                id:                 buttonEnable12V1
                anchors.left:       pod1Section.left
                anchors.top:        labelTemperaturev1.bottom
                anchors.topMargin:  20
                anchors.leftMargin: 10
                checked:            true

                onCheckedChanged: {
                    QGroundControl.customProtocol.enable24V(checked)
                }
                QGCLabel{
                    text:               qsTr("Main 12V")
                    font.family:        ScreenTools.normalFontFamily
                    color:              "white"
                    font.pointSize:     ScreenTools.largeFontPointSize
                    anchors.left:       parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin:     5
                }
            }

            QGCSwitch{
                id:                     buttonEnable24V1
                anchors.left:           pod1Section.left
                anchors.top:            buttonEnable12V1.bottom
                anchors.topMargin:      20
                anchors.leftMargin:     10
                checked:                false

                onCheckedChanged: {
                    QGroundControl.customProtocol.enable24V(checked)
                }
                QGCLabel{
                    text:               qsTr("Aux 24V")
                    font.family:        ScreenTools.normalFontFamily
                    color:              "white"
                    font.pointSize:     ScreenTools.largeFontPointSize
                    anchors.left:       parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin:     5
                }
            }

            QGCSwitch{
                id:                     buttonEnableVmot1
                anchors.left:           pod1Section.left
                anchors.top:            buttonEnable24V1.bottom
                anchors.topMargin:      20
                anchors.leftMargin:     10
                checked:                false

                onCheckedChanged: {
                    QGroundControl.customProtocol.enable24V(checked)
                }
                QGCLabel{
                    text:               qsTr("Thrusters")
                    font.family:        ScreenTools.normalFontFamily
                    color:              "white"
                    font.pointSize:     ScreenTools.largeFontPointSize
                    anchors.left:       parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin:     5
                }
            }
        }
    }
}
